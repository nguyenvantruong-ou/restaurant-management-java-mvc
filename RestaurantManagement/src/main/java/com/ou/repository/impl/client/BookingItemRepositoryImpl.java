/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ou.repository.impl.client;

import com.ou.pojos.Order;
import com.ou.pojos.OrderMenu;
import com.ou.pojos.OrderService;
import com.ou.repository.client.BookingItemRepository;
import java.util.List;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
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
public class BookingItemRepositoryImpl implements BookingItemRepository {

    @Autowired
    LocalSessionFactoryBean sessionFactory;

    @Override
    public boolean addMenu(OrderMenu orderMenu) {
        Session s = sessionFactory.getObject().getCurrentSession();
        if (checkOrderMenuIsExist(orderMenu) == true) {
            s.save(orderMenu);
        } else {
            OrderMenu m = getOrderMenu(orderMenu);
            m.setAmountTable(orderMenu.getAmountTable() + m.getAmountTable());
            s.update(m);
        }
        return true;
    }

    @Override
    public boolean addService(OrderService orderService) {
        Session s = sessionFactory.getObject().getCurrentSession();
        if (checkOrderServiceIsExist(orderService) == true) {
            s.save(orderService);
        }
        return true;
    }

    @Override
    public List<OrderMenu> getOrderMenu(Integer ordId) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder builder = session.getCriteriaBuilder();
        CriteriaQuery<OrderMenu> query = builder.createQuery(OrderMenu.class);
        Root root = query.from(OrderMenu.class);
        query = query.select(root);
        query = query.where(builder.equal(root.get("ord"), ordId));
        Query q = session.createQuery(query);
        return q.getResultList();
    }

    private boolean checkOrderMenuIsExist(OrderMenu orderMenu) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder builder = session.getCriteriaBuilder();
        CriteriaQuery<OrderMenu> query = builder.createQuery(OrderMenu.class);
        Root root = query.from(OrderMenu.class);
        query = query.select(root);
        query = query.where(builder.equal(root.get("ord"), orderMenu.getOrd().getId()),
                builder.equal(root.get("menu"), orderMenu.getMenu().getId()));
        Query q = session.createQuery(query);
        return q.getResultList().isEmpty();
    }

    private boolean checkOrderServiceIsExist(OrderService orderService) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder builder = session.getCriteriaBuilder();
        CriteriaQuery<OrderService> query = builder.createQuery(OrderService.class);
        Root root = query.from(OrderService.class);
        query = query.select(root);
        query = query.where(builder.equal(root.get("ord"), orderService.getOrd().getId()),
                builder.equal(root.get("ser"), orderService.getSer().getId()));
        Query q = session.createQuery(query);
        return q.getResultList().isEmpty();
    }

    private OrderMenu getOrderMenu(OrderMenu orderMenu) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder builder = session.getCriteriaBuilder();
        CriteriaQuery<OrderMenu> query = builder.createQuery(OrderMenu.class);
        Root root = query.from(OrderMenu.class);
        query = query.select(root);
        query = query.where(builder.equal(root.get("ord"), orderMenu.getOrd().getId()),
                builder.equal(root.get("menu"), orderMenu.getMenu().getId()));
        Query q = session.createQuery(query);
        return (OrderMenu) q.getResultList().get(0);
    }

    private OrderService getOrderService(OrderService os) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder builder = session.getCriteriaBuilder();
        CriteriaQuery<OrderService> query = builder.createQuery(OrderService.class);
        Root root = query.from(OrderService.class);
        query = query.select(root);
        query = query.where(builder.equal(root.get("ord"), os.getOrd().getId()),
                builder.equal(root.get("ser"), os.getSer().getId()));
        Query q = session.createQuery(query);
        return (OrderService) q.getResultList().get(0);
    }

    @Override
    public List<OrderService> getOderServices(Integer ordId) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder builder = session.getCriteriaBuilder();
        CriteriaQuery<OrderService> query = builder.createQuery(OrderService.class);
        Root root = query.from(OrderService.class);
        query = query.select(root);
        query = query.where(builder.equal(root.get("ord"), ordId));
        Query q = session.createQuery(query);
        return q.getResultList();
    }

    @Override
    public boolean deleteOrderService(OrderService orderService) {
        Session s = sessionFactory.getObject().getCurrentSession();
        OrderService os = getOrderService(orderService);
        s.delete(os);
        return true;
    }

    @Override
    public boolean deleteOrderMenu(OrderMenu orderMenu) {
        Session s = sessionFactory.getObject().getCurrentSession();
        OrderMenu om = getOrderMenu(orderMenu);
        s.delete(om);
        return true;
    }

    @Override
    public boolean bookingIsCompleted(Order order) {
        if(getTotalTableMenuBooking(order.getId()) == null)
            return false;
        if(order.getLob().getLobTotalTable() >= getTotalTableMenuBooking(order.getId())
                && getTotalTableMenuBooking(order.getId()) >= order.getLob().getLobTotalTable()*60/100){
            return true;
        }
        return false;
    }
    
    private Integer getTotalTableMenuBooking(Integer ordId){
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder builder = session.getCriteriaBuilder();
        CriteriaQuery<OrderMenu> query = builder.createQuery(OrderMenu.class);
        Root root = query.from(OrderMenu.class);
        query = query.select(builder.sum(root.get("amountTable")));
        query = query.where(builder.equal(root.get("ord"), ordId));
        Query q = session.createQuery(query);
        return (Integer) q.getResultList().get(0);
    }
}
