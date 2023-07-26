load('custos.mat')
J(:,11)=[1:50]
for j=1:10
    for i=1:size(J,1)
        JK(i,j)=(J(i,j)-mean(J(:,j)))/std(J(:,j));
    end   
end

JK(:,11)=J(:,11);

figure(1)

% Parametros de desempenho
legenda={'J_1(\theta)','J_2(\theta)','J_3(\theta)','J_4(\theta)','J_5(\theta)','J_6(\theta)','J_7(\theta)','J_8(\theta)','J_9(\theta)','J_1_0(\theta)'};
parallelcoords(JK(:,1:10),'Labels',legenda)
hold on
%parallelcoords(JK(1,:),'Color',[0.4660,0.6740,0.1880],'LineWidth',2)
%parallelcoords(JK(2,:),'Color',[0.4660,0,0.1880],'LineWidth',2)
ylabel('Standardised Cost Function Values');
%% retira o que é maior que a média
%JK(find(JK(:,1)>0),:)=[];
%JK(find(JK(:,2)>0),:)=[];
%% normalização Satti
for j=1:10
    for i=1:size(J,1)
        J2(i,j)=J(i,j)/sum(J(:,j));
    end   
end

figure(2)
legenda={'J_1_,_(_I_A_E_)(\theta)','J_2(\theta)','J_3(\theta)','J_4(\theta)','J_5(\theta)','J_6(\theta)','J_7(\theta)','J_8(\theta)','J_9(\theta)','J_1_0(\theta)'};
parallelcoords(J2(:,1:10),'Labels',legenda)
hold on
%parallelcoords(JK(1,:),'Color',[0.4660,0.6740,0.1880],'LineWidth',2)
%parallelcoords(JK(2,:),'Color',[0.4660,0,0.1880],'LineWidth',2)
ylabel('Standardised Cost Function Values');