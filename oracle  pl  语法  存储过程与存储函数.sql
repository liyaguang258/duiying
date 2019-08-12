create table dept as select * from scott.dept;
select * from emp;
--创建视图(必须有dba权限)
create view v_emp3 as select ename ,job from emp; 
--查询视图
select * from v_emp3;
--修改视图(视图一般用于查询,不建议用于增删改操作)
update v_emp3 set job = 'guang' where ename = 'ALLEN';
commit;--需要提交才会修改成功
--创建只读视图,只可以查询,不可以修改
create view v_emp4 as select ename,job from emp with read only;

--视图的作用:
----1.视图可以屏蔽掉一些敏感字段;
----2.保证总部和分布数据的及时统一;

--索引
--概念:索引就是在表的列上构建一个二叉树;
--达到大幅度提高查询效率的目的,但是索引会影响增删改的效率.
--索引分类:
--1.单列索引
--创建单列的索引,在enamel上创建索引,会加快通过ename查询数据的速度.
create index idx_ename on emp(ename);
select * from emp where ename='SCOTT';
--单列索引触发规则,条件必须是索引列中的原始值
--单行函数,模糊查询,都会影响索引的触发.

--2.复合索引
--创建复合索引,就是在多个列上增加索引
create index idx_enamejob on emp(ename,job);
--复合索引中第一列为优先检索列.如果要触发复合索引
--必须包含有优先检索列中的原始值.如果只有优先检索列的值
--则会默认按照单列索引查询.
select * from emp where ename='SCOTT';--触发单列
select * from emp where ename='SCOTT' and job='ANALYST';--触发复合
--如果条件判断是or时,优先检索列的原始值可能不存在,则不会触发复合索引
select * from emp where ename='SCOTT' or job='ANALYST';--不会触发


--pl/sql编程语言
--是对sql语言的扩展,是的sql语言具有过程化编程的特性;
--他比一般的过程化编程语言,更加灵活高效.
--它被主要用来编写存储过程和存储函数等.

--声明方法
--赋值操作可以使用 := ,也可以使用 into查询语句赋值
declare--声明
    i number(2) :=10;
    s varchar2(10) :='fangfang';
    ena emp.ename%type;--引入型变量
    emprow emp%rowtype;--记录型变量

begin
    dbms_output.put_line(i);
    dbms_output.put_line(s);
    select ename into ena from emp where empno = 7788;
    dbms_output.put_line(ena);
    select * into emprow from emp where empno=7788;
    dbms_output.put_line(emprow.ename ||'的工作为'||emprow.job);
end;

--pl中的if判断
--输入小于18 的数字,输出未成年
--输入18到40的数字,输出中年人
--输入40以上的数字,输出老年人
declare
--声明一个变量i,&x用来接收参数
i number(3) := &x;

begin
  if i<18 then
    dbms_output.put_line('未成年');
    elsif i<40 then
      dbms_output.put_line('中年人');
      else 
        dbms_output.put_line('老年人');
        end if;
  end;

--pl中的loop循环
--循环的三种方式,循环输出1-10;
--1,while循环
declare
   i number(2) :=1;
begin
  while i<11 loop
    dbms_output.put_line(i);
    i :=i+1;
    end loop; 
  end;

--2,exit循环,常用的循环方式,掌握
declare
i number(2) :=1;
begin
  loop
    exit when i>10;
    dbms_output.put_line(i);
    i :=i+1;
    end loop;
    
  end;
--3,for循环
declare
begin
for i in 1..10 loop
  dbms_output.put_line(i);
  end loop;
  end;
  
  
  --游标-cursor:可以存放多个对象,多行记录.
  --输出emp表中所有员工的姓名
 declare
 cursor cl is select * from emp ;
 emprow emp%rowtype;
 begin
   open cl;
   loop
     fetch cl into emprow;
     exit when cl%notfound;
     dbms_output.put_line(emprow.ename);
     end loop;
     close cl;
   end;
   --输出emp中的工作信息
   declare
   cursor ck is select * from emp;
   empro emp%rowtype;
   begin
     open ck;
     loop
       fetch ck into empro;
       exit when ck%notfound;
       dbms_output.put_line(empro.job);
       end loop;
       close ck;
     end;
 --给指定的部门涨工资
 declare
     cursor c2(eno emp.deptno%type) is
      select empno  from emp where deptno=eno;
 en emp.empno%type;
 begin
   open c2(10);
   loop
     fetch c2 into en;
     exit when c2%notfound;
     update emp set sal=sal+1000 where empno=en;
     end loop;
     close c2;
 end;
 --查询员工工资
 select ename,sal from emp where deptno=20;
 declare
 cursor c3(empo emp.deptno%type) is
  select empno from emp where deptno=empo;
  enn emp.ename%type;
  begin
    open c3(20);
    loop
      fetch c3 into enn;
      exit when c3%notfound;
      update emp set sal = sal+500 where empno=enn;
      end loop;
      close c3;
      end;
 --存储过程
 --存储过程就是提前已经编译好的一段pl/sql语言,放置在数据库端
 ----可以直接被调用,这一段pl/sql一般都是固定步骤的业务.
 --例如:
 --给指定员工涨薪   procedure:程序,手续,步骤
 create or replace procedure pl(eno emp.empno%type) is

 begin 
   update emp set sal=sal+1000 where empno=eno;
   commit;
   end;
   
  select * from emp where empno=7788;
  --测试pl存储
  declare
  begin
    pl(7788);
    end;
    
--存储函数实现计算员工年薪
--存储过程和存储函数的参数都不能带长度
--存储函数的返回值类型不能带长度
create or replace function f_yearsal(eno emp.empno%type)
return number is
s number(10);
begin
  select sal*12+nvl(comm,0) into s from emp where empno=eno;
  return s;
  end;
  
 --存储函数测试
 declare 
 s number(10);
 begin
  s := f_yearsal(7788);
  dbms_output.put_line(s);
   end;
   
 --out类型参数如何使用
 --使用存储过程来算年薪
 create or replace procedure p_yearsal(eno emp.empno%type ,
 yearsal out number) is
 s number(10);
 c emp.comm%type;
 begin
   select sal*12,nvl(comm,0) into s,c from emp where empno=eno;
   yearsal :=s+c;
   end;
  --测试p_yearsal
  declare
  yearsal number(10);
  begin
    p_yearsal(7788,yearsal);
    dbms_output.put_line(yearsal);
    end;
   
  --案例需求：查询出员工姓名，员工所在部门名称。
--传统方式来实现需求
select e.ename,d.dname  from emp e,dept d where e.deptno=d.deptno;
 --使用存储函数来实现提供一个部门编号,输出一个部门名称.
 create or replace function fdna (dno dept.deptno%type)
 return dept.dname%type
 is
 dna dept.dname%type;
 begin
   select dname into dna from dept where deptno=dno;
   
--触发器,即制定一个规则, 在进行增删改操作时,
--只要满足触发器,自动触发,无需调用,只有满足条件才会执行操作
--语句级触发器,不包含for each row的就是语句级触发器
--行级触发器:包含for each row 的
--  加for each row 是为了使用 :old 或者 :new 对象或者一行记录
--语句级触发器
select * from person;
---插入一条记录,输出新员工入职
create or replace trigger t1 
after
insert  on person
declare
  

begin
  dbms_output.put_line('新员工入职');
  end;
  ---触发t1
  insert into person values(1,'阿明','2');
  commit;
  
--行级触发器
--不能给员工降薪
--raise_application_error(-20001-20999之间,'错误提示信息');
create or replace trigger t3
before
update on emp 
for each row
  declare
  begin
    if :old.sal>:new.sal then
   raise_application_error(-20001, '不能给员工降薪');
   end if;
   end;   
--触发t3
select * from emp where empno=7788;
update emp set sal=sal-1 where empno=7788;
commit;













   
   
   
   
   
   
   
   
   
   
   
   return dna;
   end;
   --测试fdna
  select e.ename ,fdna(e.deptno)  from emp e;
 
