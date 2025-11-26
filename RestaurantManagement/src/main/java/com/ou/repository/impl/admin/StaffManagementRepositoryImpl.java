package com.ou.repository.impl.admin;

import com.ou.pojos.User;
import com.ou.repository.admin.StaffManagementRepository;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.List;
import org.hibernate.query.Query;

@Repository
@Transactional
public class StaffManagementRepositoryImpl implements StaffManagementRepository {
    @Autowired
    private LocalSessionFactoryBean sessionFactory;

    @Override
    public List<User> getUsers(String kw) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<User> query = b.createQuery(User.class);
        Root root = query.from(User.class);
        query = query.select(root);
        Predicate predicate = b.equal(root.get("userRole").as(String.class), "STAFF");
        query = query.where(predicate);
        if(!kw.isEmpty() && kw != null){
            Predicate p1 = b.like(root.get("userFirstName").as(String.class), String.format("%%%s%%", kw));
            Predicate p2 = b.like(root.get("userLastName").as(String.class), String.format("%%%s%%", kw));
            Predicate p = b.or(p1, p2);
            query = query.where(p, predicate);
        }
        query.orderBy(b.desc(root.get("userIsActive")));
        Query q =  s.createQuery(query);
        return q.getResultList();
    }

    @Override
    public User getUserById(String id) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<User> query = b.createQuery(User.class);
        Root root = query.from(User.class);
        query = query.select(root);
        query = query.where(b.equal(root.get("id").as(String.class), id));
        Query q =  s.createQuery(query);
        return (User) q.getSingleResult();
    }

    @Override
    public boolean addOrUpdate(User staff) {
        Session s = sessionFactory.getObject().getCurrentSession();
        if(staff.getId() != null)
            s.update(staff);
        else
            s.save(staff);
        return true;
    }

    @Override
    public boolean delete(User staff) {
        Session s = sessionFactory.getObject().getCurrentSession();
        s.update(staff);
        return true;
    }

    @Override
    public boolean isExistIdCard(User staff) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder builder = session.getCriteriaBuilder();
        CriteriaQuery<User> query = builder.createQuery(User.class);
        Root root = query.from(User.class);
        query = query.select(root);

        Predicate p = builder.equal(root.get("userIdCard"), staff.getUserIdCard());
        Predicate p2 = builder.notEqual(root.get("id"), staff.getId());
        query = query.where(p,p2);

        Query q = session.createQuery(query);
        if(q.getResultList().size()!=0)
            return true;
        return false;
    }
}
