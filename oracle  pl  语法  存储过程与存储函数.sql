create table dept as select * from scott.dept;
select * from emp;
--������ͼ(������dbaȨ��)
create view v_emp3 as select ename ,job from emp; 
--��ѯ��ͼ
select * from v_emp3;
--�޸���ͼ(��ͼһ�����ڲ�ѯ,������������ɾ�Ĳ���)
update v_emp3 set job = 'guang' where ename = 'ALLEN';
commit;--��Ҫ�ύ�Ż��޸ĳɹ�
--����ֻ����ͼ,ֻ���Բ�ѯ,�������޸�
create view v_emp4 as select ename,job from emp with read only;

--��ͼ������:
----1.��ͼ�������ε�һЩ�����ֶ�;
----2.��֤�ܲ��ͷֲ����ݵļ�ʱͳһ;

--����
--����:���������ڱ�����Ϲ���һ��������;
--�ﵽ�������߲�ѯЧ�ʵ�Ŀ��,����������Ӱ����ɾ�ĵ�Ч��.
--��������:
--1.��������
--�������е�����,��enamel�ϴ�������,��ӿ�ͨ��ename��ѯ���ݵ��ٶ�.
create index idx_ename on emp(ename);
select * from emp where ename='SCOTT';
--����������������,�����������������е�ԭʼֵ
--���к���,ģ����ѯ,����Ӱ�������Ĵ���.

--2.��������
--������������,�����ڶ��������������
create index idx_enamejob on emp(ename,job);
--���������е�һ��Ϊ���ȼ�����.���Ҫ������������
--������������ȼ������е�ԭʼֵ.���ֻ�����ȼ����е�ֵ
--���Ĭ�ϰ��յ���������ѯ.
select * from emp where ename='SCOTT';--��������
select * from emp where ename='SCOTT' and job='ANALYST';--��������
--��������ж���orʱ,���ȼ����е�ԭʼֵ���ܲ�����,�򲻻ᴥ����������
select * from emp where ename='SCOTT' or job='ANALYST';--���ᴥ��


--pl/sql�������
--�Ƕ�sql���Ե���չ,�ǵ�sql���Ծ��й��̻���̵�����;
--����һ��Ĺ��̻��������,��������Ч.
--������Ҫ������д�洢���̺ʹ洢������.

--��������
--��ֵ��������ʹ�� := ,Ҳ����ʹ�� into��ѯ��丳ֵ
declare--����
    i number(2) :=10;
    s varchar2(10) :='fangfang';
    ena emp.ename%type;--�����ͱ���
    emprow emp%rowtype;--��¼�ͱ���

begin
    dbms_output.put_line(i);
    dbms_output.put_line(s);
    select ename into ena from emp where empno = 7788;
    dbms_output.put_line(ena);
    select * into emprow from emp where empno=7788;
    dbms_output.put_line(emprow.ename ||'�Ĺ���Ϊ'||emprow.job);
end;

--pl�е�if�ж�
--����С��18 ������,���δ����
--����18��40������,���������
--����40���ϵ�����,���������
declare
--����һ������i,&x�������ղ���
i number(3) := &x;

begin
  if i<18 then
    dbms_output.put_line('δ����');
    elsif i<40 then
      dbms_output.put_line('������');
      else 
        dbms_output.put_line('������');
        end if;
  end;

--pl�е�loopѭ��
--ѭ�������ַ�ʽ,ѭ�����1-10;
--1,whileѭ��
declare
   i number(2) :=1;
begin
  while i<11 loop
    dbms_output.put_line(i);
    i :=i+1;
    end loop; 
  end;

--2,exitѭ��,���õ�ѭ����ʽ,����
declare
i number(2) :=1;
begin
  loop
    exit when i>10;
    dbms_output.put_line(i);
    i :=i+1;
    end loop;
    
  end;
--3,forѭ��
declare
begin
for i in 1..10 loop
  dbms_output.put_line(i);
  end loop;
  end;
  
  
  --�α�-cursor:���Դ�Ŷ������,���м�¼.
  --���emp��������Ա��������
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
   --���emp�еĹ�����Ϣ
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
 --��ָ���Ĳ����ǹ���
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
 --��ѯԱ������
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
 --�洢����
 --�洢���̾�����ǰ�Ѿ�����õ�һ��pl/sql����,���������ݿ��
 ----����ֱ�ӱ�����,��һ��pl/sqlһ�㶼�ǹ̶������ҵ��.
 --����:
 --��ָ��Ա����н   procedure:����,����,����
 create or replace procedure pl(eno emp.empno%type) is

 begin 
   update emp set sal=sal+1000 where empno=eno;
   commit;
   end;
   
  select * from emp where empno=7788;
  --����pl�洢
  declare
  begin
    pl(7788);
    end;
    
--�洢����ʵ�ּ���Ա����н
--�洢���̺ʹ洢�����Ĳ��������ܴ�����
--�洢�����ķ���ֵ���Ͳ��ܴ�����
create or replace function f_yearsal(eno emp.empno%type)
return number is
s number(10);
begin
  select sal*12+nvl(comm,0) into s from emp where empno=eno;
  return s;
  end;
  
 --�洢��������
 declare 
 s number(10);
 begin
  s := f_yearsal(7788);
  dbms_output.put_line(s);
   end;
   
 --out���Ͳ������ʹ��
 --ʹ�ô洢����������н
 create or replace procedure p_yearsal(eno emp.empno%type ,
 yearsal out number) is
 s number(10);
 c emp.comm%type;
 begin
   select sal*12,nvl(comm,0) into s,c from emp where empno=eno;
   yearsal :=s+c;
   end;
  --����p_yearsal
  declare
  yearsal number(10);
  begin
    p_yearsal(7788,yearsal);
    dbms_output.put_line(yearsal);
    end;
   
  --�������󣺲�ѯ��Ա��������Ա�����ڲ������ơ�
--��ͳ��ʽ��ʵ������
select e.ename,d.dname  from emp e,dept d where e.deptno=d.deptno;
 --ʹ�ô洢������ʵ���ṩһ�����ű��,���һ����������.
 create or replace function fdna (dno dept.deptno%type)
 return dept.dname%type
 is
 dna dept.dname%type;
 begin
   select dname into dna from dept where deptno=dno;
   
--������,���ƶ�һ������, �ڽ�����ɾ�Ĳ���ʱ,
--ֻҪ���㴥����,�Զ�����,�������,ֻ�����������Ż�ִ�в���
--��伶������,������for each row�ľ�����伶������
--�м�������:����for each row ��
--  ��for each row ��Ϊ��ʹ�� :old ���� :new �������һ�м�¼
--��伶������
select * from person;
---����һ����¼,�����Ա����ְ
create or replace trigger t1 
after
insert  on person
declare
  

begin
  dbms_output.put_line('��Ա����ְ');
  end;
  ---����t1
  insert into person values(1,'����','2');
  commit;
  
--�м�������
--���ܸ�Ա����н
--raise_application_error(-20001-20999֮��,'������ʾ��Ϣ');
create or replace trigger t3
before
update on emp 
for each row
  declare
  begin
    if :old.sal>:new.sal then
   raise_application_error(-20001, '���ܸ�Ա����н');
   end if;
   end;   
--����t3
select * from emp where empno=7788;
update emp set sal=sal-1 where empno=7788;
commit;













   
   
   
   
   
   
   
   
   
   
   
   return dna;
   end;
   --����fdna
  select e.ename ,fdna(e.deptno)  from emp e;
 
