/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ou.repository.impl.client;

import com.ou.pojos.Bill;
import com.ou.pojos.Coefficient;
import com.ou.pojos.Lobby;
import com.ou.pojos.Menu;
import com.ou.pojos.Order;
import com.ou.pojos.OrderMenu;
import com.ou.pojos.OrderService;
import com.ou.pojos.Service;
import com.ou.pojos.User;
import com.ou.repository.client.PaymentRepository;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author Danh Nguyen
 */
@Repository
@Transactional
public class PaymentRepositoryImpl implements PaymentRepository {

    @Autowired
    LocalSessionFactoryBean sessionFactory;

    @Override
    public List<Object[]> getOrderInfo(String id) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> q = b.createQuery(Object[].class);
        Root rootO = q.from(Order.class);
        Root rootC = q.from(Coefficient.class);
        Root rootL = q.from(Lobby.class);
        Root rootU = q.from(User.class);
        q.multiselect(rootO.get("id"), rootO.get("ordCreatedDate"), rootO.get("ordBookingDate"),
                rootO.get("ordBookingLesson"), rootL.get("lobName"), rootL.get("lobPrice"),
                rootU.get("userFirstName"), rootU.get("userLastName"), rootC.get("coefValue"));
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(b.equal(rootO.get("id").as(String.class), id));
        predicates.add(b.equal(rootO.get("coef"), rootC.get("id")));
        predicates.add(b.equal(rootO.get("user"), rootU.get("id")));
        predicates.add(b.equal(rootO.get("lob"), rootL.get("id")));
        q.where(predicates.toArray(new Predicate[]{}));
        Query query = s.createQuery(q);
        return query.getResultList();
    }

    @Override
    public List<Object[]> getMenuOrder(String id) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> q = b.createQuery(Object[].class);
        Root rootOM = q.from(OrderMenu.class);
        Root rootM = q.from(Menu.class);
        q.multiselect(rootM.get("menuName"), rootM.get("menuPrice"), rootOM.get("amountTable"));
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(b.equal(rootOM.get("ord"), Integer.parseInt(id)));
        predicates.add(b.equal(rootOM.get("menu"), rootM.get("id")));
        q.where(predicates.toArray(new Predicate[]{}));
        Query query = s.createQuery(q);
        return query.getResultList();
    }

    @Override
    public List<Object[]> getServiceOrder(String id) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Object[]> q = b.createQuery(Object[].class);
        Root rootOS = q.from(OrderService.class);
        Root rootS = q.from(Service.class);
        q.multiselect(rootS.get("serName"), rootS.get("serPrice"));
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(b.equal(rootOS.get("ord"), Integer.parseInt(id)));
        predicates.add(b.equal(rootOS.get("ser"), rootS.get("id")));
        q.where(predicates.toArray(new Predicate[]{}));
        Query query = s.createQuery(q);
        return query.getResultList();
    }

    @Override
    public boolean createBill(Bill bill) {
        Session s = sessionFactory.getObject().getCurrentSession();
        s.save(bill);
        return true;
    }

}
