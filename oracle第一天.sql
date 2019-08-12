select e.ename, 
       case e.ename
         when 'SMITH' then '曹贼'
           when 'ALLEN' then '大耳贼'
             when 'WARD' then '诸葛小儿'
               --else '无名'
                 end
from emp e;
select e.ename, 
        decode(e.ename,
          'JONES',  '李云龙',
            'MARTIN',  '楚云飞',
              'BLAKE',  '赵刚',
                '无名') "中文名"             
from emp e;
--判断emp表中的员工工资,如果高于3000显示高收入,如果在1500和3000之间显示
--中等收入,其余显示低收入.
select e.sal,
       case
         when e.sal>3000 then '高收入'
           when e.sal>1500 then'中等收入'
             else '低收入'
               end
               from emp e;
--多行函数查询               
 --查询总数量
 select count(*) from emp; 
 --工资总和
 select sum(sal) from emp; 
 --最高工资
 select max(sal) from emp;
 --平均工资
 select avg(sal) from emp; 
 
 --分组查询  
 --分组查询中,出现在group by后面的原始列,才能出现在select后面
 --没有出现在group by后面的列,想在select后面.必须加上聚合函数
 --聚合函数有一个特性,可以把多行记录变成一个值
 --所有条件判断都不能用别名来判断
 --查询出每个部门的平均工资
 --where是过滤分组前的数据.having是过滤分组后的数据
 --表现形式:where必须在group by之前,having是在group by后面
 select e.deptno,avg(e.sal) a from emp e group by e.deptno
--查询出平均工资高于2000的部门信息 
--用where条件
select e.deptno ,avg(e.sal) a from emp e where e.sal>2000 group by e.deptno;
--用having条件
select e.deptno ,avg(e.sal) a from emp e group by e.deptno having avg(e.sal)>2000;    
--查询出每个部门工资高于800的员工的平均工资
--然后在查询出平均工资大于2000的部门
select e.deptno ,avg(e.sal) from emp e where sal>800 group by e.deptno;
select e.deptno ,avg(e.sal) from emp e where sal>800 group by e.deptno having
avg(e.sal)>2000;



--多表查询中的一些概念
--笛卡尔积
select * from emp ,dept ;
--等值连接
select * from emp e,dept d where e.deptno=d.deptno;
--内连接
select * from emp e inner join dept d on e.deptno=d.deptno;
--查询所有部门,以及部门下的员工信息(外连接)
--左外链接
select * from dept d left join emp e on d.deptno=e.deptno;
--右外连接
select * from emp e right join dept d on e.deptno=d.deptno;
--查询所有员工信息.以及员工所属部门
select * from emp e left join dept d on e.deptno= d.deptno;
--oracle中专用外连接
select * from emp e ,dept d where e.deptno(+)=d.deptno;
select * from emp e ,dept d where e.deptno=d.deptno(+);
--查询出员工姓名,员工领导姓名
select * from emp 
select * from dept
--自连接 :自连接其实就是站在不同的角度把一张表看成多张表.
select e1.ename,e2.ename from emp e1,emp e2 where e1.mgr=e2.empno;
--查询出员工姓名.员工部门名称,员工领导姓名.员工领导部门名称
select e1.ename,d1.dname,e2.ename,d2.dname from emp e1,emp e2,dept d1,dept d2
where e1.mgr =e2.empno and e1.deptno=d1.deptno and e2.deptno=d2.deptno;

--子查询
--子查询返回一个值
--查询出工资和SCOTT一样的员工信息
select * from emp where sal in
(select sal from emp e where e.ename = 'SCOTT');
--查询出工资个10号部门任意员工一样的员工信息
select * from emp where sal in 
(select sal from emp e where e.deptno =10);
--
--子查询返回一张表
--查询出每个部门最低工资,和最低工资员工姓名,和该员工所在部门名称
--1,查出每个部门最低工资
select deptno , min(sal) from emp group by deptno;
--2.三表联合,得到最终结果
select t.m,e.ename,d.dname 
       from (select deptno , min(sal) m from emp group by deptno) t ,emp e
       ,dept d 
       where t.deptno = e.deptno
       and t.m =e.sal
       and e.deptno=d.deptno;
--

--orcal中的分页
---rownum行号:当我们做select操作的时候.
---没查询出一行记录,就会在该行上加上一个行号,
--行号从1开始,依次递增,不能跳着走
--排序操作会影响rownum的顺序
select rownum ,e.* from emp e order by e.sal desc;

--如果涉及到排序,但是还要使用rownum的话,可以再次嵌套查询
select rownum, t.* from (
select rownum ,e.* from emp e order by e.sal desc) t ;

--emp表工资倒叙排列后,每页五条记录,查询第二页.
--rownum行号不能写上大于一个正数.
select * from (
select rownum rn,tt.* from (
select * from emp order by sal desc) tt where rownum < 11
) where rn >5;

