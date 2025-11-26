/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ou.repository.impl.client;

import com.ou.pojos.Dish;
import com.ou.pojos.Menu;
import com.ou.pojos.MenuDish;
import com.ou.repository.client.MenuRepository;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author Admin
 */
@Repository
@Transactional
public class MenuRepositoryImpl implements MenuRepository {

    @Autowired
    private LocalSessionFactoryBean sessionFactory;

    @Override
    public List<Menu> getListMenu(int sort) {
        Session session = this.sessionFactory.getObject().getCurrentSession();
        CriteriaBuilder b = session.getCriteriaBuilder();
        CriteriaQuery<Menu> q = b.createQuery(Menu.class);

        Root root = q.from(Menu.class);
        q.select(root);

        if (sort == -1) {
            q = q.orderBy(b.desc(root.get("menuPrice")));
        }
        if (sort == 1) {
            q = q.orderBy(b.asc(root.get("menuPrice")));
        }

        Query query = session.createQuery(q);

        return query.getResultList();
    }

    @Override
    public List<Menu> getListMenuDish() {
        Session session = this.sessionFactory.getObject().getCurrentSession();

        CriteriaBuilder b = session.getCriteriaBuilder();

        CriteriaQuery<Object[]> q = b.createQuery(Object[].class);

        Root rootMenuDish = q.from(MenuDish.class);
        Root rootDish = q.from(Dish.class);

        List<Predicate> pre = new ArrayList<>();
        pre.add(b.equal(rootMenuDish.get("dish"), rootDish.get("id")));
        pre.add(b.isTrue(rootDish.get("dishIsActive")));
        q.where(pre.toArray(new Predicate[]{}));

        q.multiselect(rootMenuDish.get("dish"), rootMenuDish.get("menu"));
        Query query = session.createQuery(q);

        return query.getResultList();
    }

    @Override
    public Menu getMenuById(Integer id) {
        Session s = sessionFactory.getObject().getCurrentSession();
        return s.get(Menu.class, id);
    }

}
