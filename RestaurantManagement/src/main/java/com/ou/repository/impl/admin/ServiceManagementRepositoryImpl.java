/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ou.repository.impl.admin;

import com.ou.pojos.Service;
import com.ou.repository.admin.ServiceManagementRepository;
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
 * @author Wall D
 */
@Repository
@Transactional
public class ServiceManagementRepositoryImpl implements ServiceManagementRepository{
    @Autowired
    LocalSessionFactoryBean sessionFactory;
    
    @Override
    public List<Service> getServicesByKw(String kw) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Service> query = b.createQuery(Service.class);
        Root root = query.from(Service.class);
        query = query.select(root);
        if(!kw.isEmpty() && kw != null){
            Predicate p = b.like(root.get("serName").as(String.class), String.format("%%%s%%", kw));
            query = query.where(p);
        }
        query.orderBy(b.desc(root.get("serIsActive")));
        Query q =  s.createQuery(query);
        return q.getResultList();
    }

    @Override
    public Service getServiceById(String id) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Service> query = b.createQuery(Service.class);
        Root root = query.from(Service.class);
        query = query.select(root);
        query.where(b.equal(root.get("id").as(String.class), id));
        Query q =  s.createQuery(query);
        return (Service) q.getSingleResult();
    }

    @Override
    public boolean addOrUpdate(Service service) {
        Session session = sessionFactory.getObject().getCurrentSession();
        if(service.getId() != null)
            session.update(service);
        else
            session.save(service);
        return true;
    }

    @Override
    public boolean delete(Service service) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        session.update(service);
        return true;
    }

    @Override
    public boolean isExistServiceName(Service s) {
        Session session = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<Service> query = b.createQuery(Service.class);
        Root root = query.from(Service.class);
        query = query.select(root);
        Predicate p = b.equal(root.get("serName").as(String.class), s.getSerName());
        Predicate p2 = b.notEqual(root.get("id").as(String.class), s.getId());
        query = query.where(p, p2);
        Query q =  session.createQuery(query);
        if(!q.getResultList().isEmpty())
            return true;
        return false;
    }
    
}
