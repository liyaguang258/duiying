package com.itheima.service.impl;

import com.itheima.dao.AccountDao;
import com.itheima.dao.impl.AccountDaoImpl;
import com.itheima.service.AccountService;

public class AccountServiceImpl implements AccountService {
    public void saveAccount() {
       AccountDao accountDao = new AccountDaoImpl();

        accountDao.saveAccount();
    }
}
