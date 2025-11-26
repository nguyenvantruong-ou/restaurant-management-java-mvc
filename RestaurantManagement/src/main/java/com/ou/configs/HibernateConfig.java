package com.ou.configs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.orm.hibernate5.HibernateTransactionManager;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import static org.hibernate.cfg.Environment.*;

import javax.sql.DataSource;
import java.util.Properties;

@Configuration
@PropertySource("classpath:database.properties")
public class HibernateConfig {
    @Autowired
    private Environment env;

    @Bean
    public LocalSessionFactoryBean getSessionFactory(){
        LocalSessionFactoryBean factory = new LocalSessionFactoryBean();
        factory.setPackagesToScan("com.ou.pojos");
        factory.setDataSource(dataSource());
        factory.setHibernateProperties(hibernateProperties());

        return factory;
    }

    @Bean
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName(env.getProperty("hibernate.connection.driverClass"));
        config.setJdbcUrl(env.getProperty("hibernate.connection.url"));
        config.setUsername(env.getProperty("hibernate.connection.username"));
        config.setPassword(env.getProperty("hibernate.connection.password"));
        
        // Connection pool settings for better transaction management
        config.setMinimumIdle(5);
        config.setMaximumPoolSize(20);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);
        config.setAutoCommit(false); // Let Spring manage transactions
        config.setTransactionIsolation("TRANSACTION_READ_COMMITTED");
        
        return new HikariDataSource(config);
    }

    public Properties hibernateProperties(){
        Properties pros = new Properties();
        pros.setProperty(SHOW_SQL, env.getProperty("hibernate.showSql"));
        pros.setProperty(DIALECT, env.getProperty("hibernate.dialect"));
        // Enable auto DDL to create/update database schema from entities
        // Uses value from database.properties, defaults to "update" if not set
        String hbm2ddlAuto = env.getProperty("hibernate.hbm2ddl.auto", "update");
        pros.setProperty("hibernate.hbm2ddl.auto", hbm2ddlAuto);
        // Format SQL output for better readability
        pros.setProperty("hibernate.format_sql", "true");
        // Transaction management - use Spring's session context for proper transaction handling
        pros.setProperty("hibernate.current_session_context_class", "org.springframework.orm.hibernate5.SpringSessionContext");
        pros.setProperty("hibernate.transaction.coordinator_class", "jdbc");

        return pros;
    }

    @Bean
    public HibernateTransactionManager transactionManager(){
        HibernateTransactionManager transactionManager = new HibernateTransactionManager();
        transactionManager.setSessionFactory(getSessionFactory().getObject());
        return transactionManager;
    }
}
