/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ou.repository.impl.admin;

import com.ou.pojos.Lobby;
import com.ou.repository.admin.LobbyManagementRepository;
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
public class LobbyManagementRepositoryImpl implements LobbyManagementRepository{
    @Autowired
    private LocalSessionFactoryBean sessionFactory;
    
    @Override
    public List<Lobby> getLobbiesByKw(String kw) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Lobby> query = b.createQuery(Lobby.class);
        Root root = query.from(Lobby.class);
        query = query.select(root);
        if(!kw.isEmpty() && kw != null){
            Predicate p = b.like(root.get("lobName").as(String.class), String.format("%%%s%%", kw));
            query = query.where(p);
        }
        query.orderBy(b.desc(root.get("lobIsActive")));
        Query q =  s.createQuery(query);
        return q.getResultList(); 
    }

    @Override
    public Lobby getLobbyById(String id) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Lobby> query = b.createQuery(Lobby.class);
        Root root = query.from(Lobby.class);
        query = query.select(root);
        query.where(b.equal(root.get("id").as(String.class), id));
        Query q =  s.createQuery(query);
        return (Lobby) q.getSingleResult();
    }

    @Override
    public boolean addOrUpdate(Lobby lobby) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        if(lobby.getId() != null)
            session.update(lobby);
        else
            session.save(lobby);
        return true;
    }

    @Override
    public boolean delete(Lobby lobby) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        session.update(lobby);
        return true;
    }

    @Override
    public List<Lobby> getLobbies() {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Lobby> query = b.createQuery(Lobby.class);
        Root root = query.from(Lobby.class);
        query = query.select(root);
        query = query.where(b.equal(root.get("lobIsActive"), true));
        Query q =  s.createQuery(query);
        return q.getResultList(); 
    }

    @Override
    public boolean isExistLobbyName(String lobName, int lobId) {
        Session s = sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = s.getCriteriaBuilder();
        CriteriaQuery<Lobby> query = b.createQuery(Lobby.class);
        Root root = query.from(Lobby.class);
        query = query.select(root);
        query = query.where(b.equal(root.get("lobName"), lobName),
                b.notEqual(root.get("id"), lobId));
        Query q =  s.createQuery(query);
        if(!q.getResultList().isEmpty())
            return true;
        return false; 
    }
    
}
