/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ou.repository.impl.client;

import com.ou.pojos.Order;
import com.ou.pojos.OrderMenu;
import com.ou.pojos.OrderService;
import com.ou.pojos.User;

import java.util.List;
import com.ou.repository.client.OrderRepository;
import java.time.LocalDate;
import java.util.ArrayList;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import org.hibernate.HibernateException;
import org.hibernate.Session;
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
public class OrderRepositoryImpl implements OrderRepository {

    @Autowired
    private LocalSessionFactoryBean sessionFactory;

    @Override
    public List<Object[]> getOrders(String kw, int page) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<Object[]> query = b.createQuery(Object[].class);
        Root rootU = query.from(User.class);
        Root rootO = query.from(Order.class);
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(b.equal(rootO.get("user"), rootU.get("id")));
         if(!kw.isEmpty()){
             predicates.add(b.equal(rootO.get("user"), getUserIdByPhone(kw)));
         }
        predicates.add(b.equal(rootO.get("ordIsPayment"), false));
        query.multiselect(rootO.get("id"), rootU.get("userLastName"), rootU.get("userFirstName"),
                rootU.get("userSex"), rootU.get("userIdCard"), rootU.get("userPhoneNumber"),
                rootO.get("ordCreatedDate"), rootO.get("ordBookingDate"),
                rootO.get("ordBookingLesson"));
        query.where(predicates.toArray(new Predicate[]{}));
        Query q = session.createQuery(query);
        int max = 8;
        q.setMaxResults(max);
        q.setFirstResult((page - 1) * max);
        return q.getResultList();
    }

    @Override
    public Order getOrderById(Integer id) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        return session.get(Order.class, id);
    }

    @Override
    public boolean updateOrderIsPayment(Order order) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        session.update(order);
        return true;
    }

    @Override
    public boolean checkBooking(LocalDate bookingDate, String lesson, int lobId) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<Order> query = b.createQuery(Order.class);
        Root root = query.from(Order.class);
        query = query.select(root);
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(b.equal(root.get("ordBookingDate"), bookingDate));
        predicates.add(b.equal(root.get("ordBookingLesson"), lesson));
        predicates.add(b.equal(root.get("lob"), lobId));
        query.where(predicates.toArray(new Predicate[]{}));
        Query q = session.createQuery(query);
        List<Order> kq = q.getResultList();
        return kq.isEmpty();
    }

    @Override
    public boolean addOrder(Order order) {
        Session s = this.sessionFactory.getObject().getCurrentSession();
        s.save(order);
        return true;
    }

    @Override
    public Order getOrderByDate(LocalDate bookingDate, String lesson) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<Order> query = b.createQuery(Order.class);
        Root rootO = query.from(Order.class);
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(b.equal(rootO.get("ordBookingDate"), bookingDate));
        predicates.add(b.equal(rootO.get("ordBookingLesson"), lesson));
        query.select(rootO);
        query.where(predicates.toArray(new Predicate[]{}));
        Query q = session.createQuery(query);
        return (Order) q.getResultList().get(0);
    }

    @Override
    public List<Order> getAmountOrder() {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<Object[]> query = b.createQuery(Object[].class);
        Root rootO = query.from(Order.class);
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(b.equal(rootO.get("ordIsPayment"), false));
        query.select(rootO);
        query.where(predicates.toArray(new Predicate[]{}));
        Query q = session.createQuery(query);
        return q.getResultList();
    }

    @Override
    public boolean deleteOrder(Order order) {
        try {
            Session s = this.sessionFactory.getObject().getCurrentSession();
            List<OrderService> os = getListOrderService(order.getId());
            List<OrderMenu> om = getListOrderMenu(order.getId());
            om.forEach((e) -> {
                s.delete(e);
            });
            os.forEach((e) -> {
                s.delete(e);
            });
            s.delete(order);
            return true;
        } catch (HibernateException hibernateException) {
            return false;
        }
    }

    private List<OrderService> getListOrderService(Integer ordId) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<OrderService> query = b.createQuery(OrderService.class);
        Root rootO = query.from(OrderService.class);
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(b.equal(rootO.get("ord"), ordId));
        query.select(rootO);
        query.where(predicates.toArray(new Predicate[]{}));
        Query q = session.createQuery(query);
        return q.getResultList();
    }

    private List<OrderMenu> getListOrderMenu(Integer ordId) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<OrderMenu> query = b.createQuery(OrderMenu.class);
        Root rootO = query.from(OrderMenu.class);
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(b.equal(rootO.get("ord"), ordId));
        query.select(rootO);
        query.where(predicates.toArray(new Predicate[]{}));
        Query q = session.createQuery(query);
        return q.getResultList();
    }
    
    private Integer getUserIdByPhone(String phone){
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<User> query = b.createQuery(User.class);
        Root rootO = query.from(User.class);
        query.select(rootO.get("id"));
        query.where(b.equal(rootO.get("userPhoneNumber").as(String.class), phone));
        Query q = session.createQuery(query);
        if(!q.getResultList().isEmpty())
            return (Integer) q.getResultList().get(0);
        return 0;
    }

    @Override
    public List<Order> getOrderByUserId(int userId) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<Order> query = b.createQuery(Order.class);
        Root rootO = query.from(Order.class);
        query.select(rootO);
        query.where(b.equal(rootO.get("user"), userId));
        query.orderBy(b.asc(rootO.get("ordIsPayment")));
        Query q = session.createQuery(query);
        return q.getResultList();
    }

}
