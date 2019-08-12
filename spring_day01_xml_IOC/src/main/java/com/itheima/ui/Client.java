package com.itheima.ui;

import com.itheima.dao.AccountDao;

import com.itheima.service.AccountService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Client {
int a = 0;
    /**
     * 获取spring的Ioc核心容器,并根据id获取对象
     *
     * ApplicationContext的三个常用实现类:
     *      ClassPathXmlApplicationContext:它可以加载类路径下的配置文件,要求配置文件必须在类路径下.不在的话,加载不了.
     *      FileSystemXmlApplicationContext:它可以加载磁盘任意路径下的配置文件(必须有访问权限)
     *      AnnotationConfigApplicationContext:它是用于读取注解创建容器的;
     *
     * 核心容器的两个接口引发出的问题:
     *      ApplicationContext:  单例对象适用. 实际开发时多用此接口
     *              它在构建核心容器时,创建对象采取的策略是采用立即加载的方式.也就是说,只要一读取完配置文件马上就创建配置文件中配置的对象
     *      BeanFactory:    多例对象适用
     *              它在构建核心容器时,创建对象采取的策略是延迟加载的方式,也就是说,什么时候根据id来获取对象.什么时候才真正的创建对象
     * @param args
     */
    public static void main(String[] args) {
        //获取核心容器对象
        ApplicationContext ac =new ClassPathXmlApplicationContext("bean.xml");
        //根据id获取Bean对象
        //第一种方法需要手动进行类型强转
        AccountService as = (AccountService)ac.getBean("accountService");
        //第二种方法不需要手动进行类型强转
        AccountDao ad = ac.getBean("accountDao", AccountDao.class);
        //分别打印两个对象
        System.out.println(as);
        System.out.println(ad);

        as.saveAccount();
    }
}
