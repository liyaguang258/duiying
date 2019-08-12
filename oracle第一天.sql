select e.ename, 
       case e.ename
         when 'SMITH' then '����'
           when 'ALLEN' then '�����'
             when 'WARD' then '���С��'
               --else '����'
                 end
from emp e;
select e.ename, 
        decode(e.ename,
          'JONES',  '������',
            'MARTIN',  '���Ʒ�',
              'BLAKE',  '�Ը�',
                '����') "������"             
from emp e;
--�ж�emp���е�Ա������,�������3000��ʾ������,�����1500��3000֮����ʾ
--�е�����,������ʾ������.
select e.sal,
       case
         when e.sal>3000 then '������'
           when e.sal>1500 then'�е�����'
             else '������'
               end
               from emp e;
--���к�����ѯ               
 --��ѯ������
 select count(*) from emp; 
 --�����ܺ�
 select sum(sal) from emp; 
 --��߹���
 select max(sal) from emp;
 --ƽ������
 select avg(sal) from emp; 
 
 --�����ѯ  
 --�����ѯ��,������group by�����ԭʼ��,���ܳ�����select����
 --û�г�����group by�������,����select����.������ϾۺϺ���
 --�ۺϺ�����һ������,���԰Ѷ��м�¼���һ��ֵ
 --���������ж϶������ñ������ж�
 --��ѯ��ÿ�����ŵ�ƽ������
 --where�ǹ��˷���ǰ������.having�ǹ��˷���������
 --������ʽ:where������group by֮ǰ,having����group by����
 select e.deptno,avg(e.sal) a from emp e group by e.deptno
--��ѯ��ƽ�����ʸ���2000�Ĳ�����Ϣ 
--��where����
select e.deptno ,avg(e.sal) a from emp e where e.sal>2000 group by e.deptno;
--��having����
select e.deptno ,avg(e.sal) a from emp e group by e.deptno having avg(e.sal)>2000;    
--��ѯ��ÿ�����Ź��ʸ���800��Ա����ƽ������
--Ȼ���ڲ�ѯ��ƽ�����ʴ���2000�Ĳ���
select e.deptno ,avg(e.sal) from emp e where sal>800 group by e.deptno;
select e.deptno ,avg(e.sal) from emp e where sal>800 group by e.deptno having
avg(e.sal)>2000;



--����ѯ�е�һЩ����
--�ѿ�����
select * from emp ,dept ;
--��ֵ����
select * from emp e,dept d where e.deptno=d.deptno;
--������
select * from emp e inner join dept d on e.deptno=d.deptno;
--��ѯ���в���,�Լ������µ�Ա����Ϣ(������)
--��������
select * from dept d left join emp e on d.deptno=e.deptno;
--��������
select * from emp e right join dept d on e.deptno=d.deptno;
--��ѯ����Ա����Ϣ.�Լ�Ա����������
select * from emp e left join dept d on e.deptno= d.deptno;
--oracle��ר��������
select * from emp e ,dept d where e.deptno(+)=d.deptno;
select * from emp e ,dept d where e.deptno=d.deptno(+);
--��ѯ��Ա������,Ա���쵼����
select * from emp 
select * from dept
--������ :��������ʵ����վ�ڲ�ͬ�ĽǶȰ�һ�ű��ɶ��ű�.
select e1.ename,e2.ename from emp e1,emp e2 where e1.mgr=e2.empno;
--��ѯ��Ա������.Ա����������,Ա���쵼����.Ա���쵼��������
select e1.ename,d1.dname,e2.ename,d2.dname from emp e1,emp e2,dept d1,dept d2
where e1.mgr =e2.empno and e1.deptno=d1.deptno and e2.deptno=d2.deptno;

--�Ӳ�ѯ
--�Ӳ�ѯ����һ��ֵ
--��ѯ�����ʺ�SCOTTһ����Ա����Ϣ
select * from emp where sal in
(select sal from emp e where e.ename = 'SCOTT');
--��ѯ�����ʸ�10�Ų�������Ա��һ����Ա����Ϣ
select * from emp where sal in 
(select sal from emp e where e.deptno =10);
--
--�Ӳ�ѯ����һ�ű�
--��ѯ��ÿ��������͹���,����͹���Ա������,�͸�Ա�����ڲ�������
--1,���ÿ��������͹���
select deptno , min(sal) from emp group by deptno;
--2.��������,�õ����ս��
select t.m,e.ename,d.dname 
       from (select deptno , min(sal) m from emp group by deptno) t ,emp e
       ,dept d 
       where t.deptno = e.deptno
       and t.m =e.sal
       and e.deptno=d.deptno;
--

--orcal�еķ�ҳ
---rownum�к�:��������select������ʱ��.
---û��ѯ��һ�м�¼,�ͻ��ڸ����ϼ���һ���к�,
--�кŴ�1��ʼ,���ε���,����������
--���������Ӱ��rownum��˳��
select rownum ,e.* from emp e order by e.sal desc;

--����漰������,���ǻ�Ҫʹ��rownum�Ļ�,�����ٴ�Ƕ�ײ�ѯ
select rownum, t.* from (
select rownum ,e.* from emp e order by e.sal desc) t ;

--emp���ʵ������к�,ÿҳ������¼,��ѯ�ڶ�ҳ.
--rownum�кŲ���д�ϴ���һ������.
select * from (
select rownum rn,tt.* from (
select * from emp order by sal desc) tt where rownum < 11
) where rn >5;

