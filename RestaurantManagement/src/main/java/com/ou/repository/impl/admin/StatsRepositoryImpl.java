package com.ou.repository.impl.admin;

import com.ou.pojos.Bill;
import com.ou.pojos.Order;
import com.ou.repository.admin.StatsRepository;
import java.time.LocalDate;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.stereotype.Repository;

import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.ArrayList;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class StatsRepositoryImpl implements StatsRepository {

    @Autowired
    private LocalSessionFactoryBean sessionFactory;

    @Override
    public List<Object[]> billStats(LocalDate fromDate, LocalDate toDate) {
        Session s = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> query = b.createQuery(Object[].class);
        Root root = query.from(Bill.class);
        query.multiselect(root.get("billCreatedDate"), b.sum(root.get("billTotalMoney")));
        List<Predicate> predicates = new ArrayList<>();
        if (fromDate != null) {
            predicates.add(b.greaterThanOrEqualTo(root.get("billCreatedDate"), fromDate));
        }
        if (toDate != null) {
            predicates.add(b.lessThanOrEqualTo(root.get("billCreatedDate"), toDate));
        }
        query.where(predicates.toArray(new Predicate[]{}));
        query.groupBy(root.get("billCreatedDate"));
        query.orderBy(b.asc(root.get("billCreatedDate")));
        Query q = s.createQuery(query);

        return q.getResultList();
    }

    @Override
    public List<Object[]> billMonthStats(int fromYear, int toYear) {
        Session s = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> query = b.createQuery(Object[].class);
        Root root = query.from(Bill.class);
        List<Predicate> predicates = new ArrayList<>();
        query.multiselect(b.function("MONTH", Integer.class, root.get("billCreatedDate")),
                b.function("YEAR", Integer.class, root.get("billCreatedDate")),
                b.sum(root.get("billTotalMoney")));
        predicates.add(b.greaterThanOrEqualTo(b.function("YEAR", Integer.class, root.get("billCreatedDate")), fromYear));
        if (toYear != 0) {
            predicates.add(b.lessThanOrEqualTo(b.function("YEAR", Integer.class, root.get("billCreatedDate")), toYear));
        }
        query.where(predicates.toArray(new Predicate[]{}));
        query.groupBy(b.function("MONTH", Integer.class, root.get("billCreatedDate")),
                 b.function("YEAR", Integer.class, root.get("billCreatedDate")));
        query.orderBy(b.asc(root.get("billCreatedDate")));
        Query q = s.createQuery(query);

        return q.getResultList();
    }

    @Override
    public List<Object[]> billQuarterStats(int fromYear, int toYear) {
        Session s = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> query = b.createQuery(Object[].class);
        Root root = query.from(Bill.class);
        List<Predicate> predicates = new ArrayList<>();

        query.multiselect(b.function("QUARTER", Integer.class, root.get("billCreatedDate")),
                b.function("YEAR", Integer.class, root.get("billCreatedDate")),
                b.sum(root.get("billTotalMoney")));
        predicates.add(b.greaterThanOrEqualTo(b.function("YEAR", Integer.class, root.get("billCreatedDate")), fromYear));
        if (toYear != 0) {
            predicates.add(b.lessThanOrEqualTo(b.function("YEAR", Integer.class, root.get("billCreatedDate")), toYear));
        }
        query.where(predicates.toArray(new Predicate[]{}));
        query.groupBy(b.function("QUARTER", Integer.class, root.get("billCreatedDate")),
                 b.function("YEAR", Integer.class, root.get("billCreatedDate")));
        query.orderBy(b.asc(root.get("billCreatedDate")));
        Query q = s.createQuery(query);

        return q.getResultList();
    }

    @Override
    public List<Object[]> billYearStats(int fromYear, int toYear) {
        Session s = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> query = b.createQuery(Object[].class);
        Root root = query.from(Bill.class);
        List<Predicate> predicates = new ArrayList<>();

        query.multiselect(b.function("YEAR", Integer.class, root.get("billCreatedDate")),
                b.sum(root.get("billTotalMoney")));
        predicates.add(b.greaterThanOrEqualTo(b.function("YEAR", Integer.class, root.get("billCreatedDate")), fromYear));
        if (toYear != 0) {
            predicates.add(b.lessThanOrEqualTo(b.function("YEAR", Integer.class, root.get("billCreatedDate")), toYear));
        }
        query.where(predicates.toArray(new Predicate[]{}));
        query.groupBy(b.function("YEAR", Integer.class, root.get("billCreatedDate")));
        query.orderBy(b.asc(root.get("billCreatedDate")));
        Query q = s.createQuery(query);

        return q.getResultList();
    }

    @Override
    public List<Object[]> getListYears() {
        Session s = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Integer> query = b.createQuery(Integer.class);
        Root root = query.from(Bill.class);
        query.multiselect(b.function("YEAR", Integer.class, root.get("billCreatedDate")));
        query.groupBy(b.function("YEAR", Integer.class, root.get("billCreatedDate")));
        query.orderBy(b.asc(root.get("billCreatedDate")));
        Query q = s.createQuery(query);
        return q.getResultList();
    }

    @Override
    public List<Object[]> orderMonthStats(int fromYear, int toYear) {
        Session s = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> query = b.createQuery(Object[].class);
        Root root = query.from(Order.class);
        List<Predicate> predicates = new ArrayList<>();

        query.multiselect(b.function("MONTH", Integer.class, root.get("ordBookingDate")),
                b.function("YEAR", Integer.class, root.get("ordBookingDate")),
                b.count(root.get("id")));
        predicates.add(b.greaterThanOrEqualTo(b.function("YEAR", Integer.class, root.get("ordBookingDate")), fromYear));
        if (toYear != 0) {
            predicates.add(b.lessThanOrEqualTo(b.function("YEAR", Integer.class, root.get("ordBookingDate")), toYear));
        }
        query.where(predicates.toArray(new Predicate[]{}));
        query.groupBy(b.function("MONTH", Integer.class, root.get("ordBookingDate")),
                b.function("YEAR", Integer.class, root.get("ordBookingDate")));
        query.orderBy(b.asc(root.get("ordBookingDate")));
        Query q = s.createQuery(query);

        return q.getResultList();
    }

    @Override
    public List<Object[]> orderQuarterStats(int fromYear, int toYear) {
        Session s = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> query = b.createQuery(Object[].class);
        Root root = query.from(Order.class);
        List<Predicate> predicates = new ArrayList<>();

        query.multiselect(b.function("QUARTER", Integer.class, root.get("ordBookingDate")),
                b.function("YEAR", Integer.class, root.get("ordBookingDate")),
                b.count(root.get("id")));
        predicates.add(b.greaterThanOrEqualTo(b.function("YEAR", Integer.class, root.get("ordBookingDate")), fromYear));
        if (toYear != 0) {
            predicates.add(b.lessThanOrEqualTo(b.function("YEAR", Integer.class, root.get("ordBookingDate")), toYear));
        }
        query.where(predicates.toArray(new Predicate[]{}));
        query.groupBy(b.function("QUARTER", Integer.class, root.get("ordBookingDate")),
                b.function("YEAR", Integer.class, root.get("ordBookingDate")));
        query.orderBy(b.asc(root.get("ordBookingDate")));
        Query q = s.createQuery(query);

        return q.getResultList();
    }

    @Override
    public List<Object[]> orderYearStats(int fromYear, int toYear) {
        Session s = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> query = b.createQuery(Object[].class);
        Root root = query.from(Order.class);
        List<Predicate> predicates = new ArrayList<>();

        query.multiselect( b.function("YEAR", Integer.class, root.get("ordBookingDate")),
                b.count(root.get("id")));
        predicates.add(b.greaterThanOrEqualTo(b.function("YEAR", Integer.class, root.get("ordBookingDate")), fromYear));
        if (toYear != 0) {
            predicates.add(b.lessThanOrEqualTo(b.function("YEAR", Integer.class, root.get("ordBookingDate")), toYear));
        }
        query.where(predicates.toArray(new Predicate[]{}));
        query.groupBy(b.function("YEAR", Integer.class, root.get("ordBookingDate")));
        query.orderBy(b.asc(root.get("ordBookingDate")));
        Query q = s.createQuery(query);

        return q.getResultList();
    }
}
