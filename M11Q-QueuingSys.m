% Nora Basha
% Assignment 1- ECE 576- Advanced Computer Networks
clc
clear
z= qfuncinv((1-0.9)/2);
n=100:10:600; 
for j=1:length(n)
%n=100
w=zeros(n(j),1);
control_s=zeros(n(j),1);
control_i=zeros(n(j),1);
control_q=zeros(n(j),1);
L=zeros(n(j),1);
for i=1:n(j)
iat = exprnd(0.5,10,1);
s = exprnd(1,10,1);
control_s(i)=sum(s);
control_i(i)= sum(iat(1:9));
control_q(i)=control_s(i)-control_i(i);
T=zeros(10,1);
T(1)= s(1);
N(1)=0;
arrival_t(1)=0;
completion_t(1)=s(1);
% Time a frame p resides in system
 for p= 2:10
   arrival_t(p)=arrival_t(p-1)+iat(p);
   enter_service_time(p) = max(completion_t(p-1), arrival_t(p));
   completion_t(p) = enter_service_time(p) + s(p);
   T(p) = completion_t(p) - arrival_t(p);
 end
 % # of Packets in system when frame h arrives 
 for h= 1:10
     if arrival_t(h)<completion_t(1)
    N(h)= h-1;

elseif arrival_t(h)<completion_t(2)
    N(h)= h-2;
     elseif arrival_t(h)<completion_t(3)
         N(h)= h-3;
        elseif arrival_t(h)<completion_t(4)
            N(h)= h-4;
            elseif arrival_t(h)<completion_t(5)
                N(h)= h-5;
                elseif arrival_t(h)<completion_t(6)
                    N(h)= h-6;
                    elseif arrival_t(h)<completion_t(7)
                        N(h)= h-7;
                        elseif arrival_t(h)<completion_t(8)
                            N(h)= h-8;
                            elseif arrival_t(h)<completion_t(9)
                                N(h)= h-9;
                                elseif completion_t(h)<completion_t(10)
                                    N(h)= h-10;
     else
         N(h)=0;

end
 end
   w(i)=sum(T);
   L(i)= sum(N+1);
end
control_s_avg=(1/n(j))*sum(control_s);
control_q_avg=(1/n(j))*sum(control_q);
w1(j)=(1/n(j))*sum(w); %raw estimator
co_v_s=(1/n(j))*(w-w1(j))'*(control_s-control_s_avg);
co_v_q=(1/n(j))*(w-w1(j))'*(control_q-control_q_avg);
w2(j)= w1(j)-(co_v_s/var(control_s))*(control_s_avg-10);% Service time as control variate
w3(j)=w1(j)-(co_v_q/var(control_q))*(control_q_avg-5.5);% Q= S-I time as control variate
L1(j)=(1/n(j))*sum(L); % conditioning on N 'The number of packets in the AP as frame k arrives'
% Confidence Interval 
Variance_raw(j)= var(w);
Confidence_raw(j)= (2*Variance_raw(j)*z)/(sqrt(n(j))*w1(j));
Variance_control_s(j)= Variance_raw(j)-((co_v_s^2)/var(control_s));
Confidence_control_s(j)= (2*Variance_control_s(j)*z)/(sqrt(n(j))*w2(j));
Variance_control_q(j)= Variance_raw(j)-((co_v_q^2)/var(control_q));
Confidence_control_q(j)= (2*Variance_control_q(j)*z)/(sqrt(n(j))*w3(j));
Variance_L1=var(L);
Confidence_L1(j)= (2*Variance_L1*z)/(sqrt(n(j))*L1(j));
end
%finding Min # of simulations for +- 10% confidence interval at 90%
%confidence level
index1=find(Confidence_raw<=0.2,1);
index2= find(Confidence_control_s<=0.2, 1 );
index3= find(Confidence_control_q<=0.3,1);
index4=find(Confidence_L1<=0.3,1);
min_no_sim_confidence_raw=n(index1);
min_no_sim_confidence_control_s=n(index2);
min_no_sim_confidence_control_q=n(index3);
min_no_sim_confidence_Conditional=n(index4);
% Graphs
hold on
plot(n,w1,'g-*','DisplayName','1 Raw estimator')
plot(n,w2,'b--*','DisplayName','2 Control Variate S Graph')
plot(n,w3,'r-o','DisplayName','3 Control Variate Q Graph')
plot(n,L1,'c-*','DisplayName','4 Conditioning Estimator')
xlabel('simulations Runs n')
ylabel(' Total Delay Time Estimated Value')
hold off
figure
hold on 
plot(n,Confidence_raw,'g-*','DisplayName',' 1 Raw estimator Confidence interval value Graph')
plot(n,Confidence_control_s,'b--*','DisplayName',' 2 Control Variate S Confidence interval value Graph')
plot(n,Confidence_control_q,'r-o','DisplayName','3 Control Variate Q Confidence interval value Graph')
plot(n,Confidence_L1,'c-*','DisplayName',' 4 Conditioning Estimator')
xlabel('simulations Runs n')
ylabel('90% Confidence Level Confidence Interval')
hold off