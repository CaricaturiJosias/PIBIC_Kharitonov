function [] = ParallelCoords(Tabela)
    legenda = cellstr(Tabela(1, 3:end));
    metodos = cellstr(Tabela(2:end, 1))';
    % Desconsidera a linha de PID
    QntColuna = size(Tabela, 2)-2;
    % Desconsidera nome das colunas
    QntLinha = size(Tabela, 1)-1;
    % Retira cell de 1x1 de cada posição
    values = cell2mat(Tabela(2:end,3:end));

    % 3 porque ignora a linha de métodos e PID (ambos string)
    for j = 3:QntColuna
        % 2 porque ignora o nome da coluna no topo
        for i= 2:QntLinha
            % Calcula cada ponto
            JK(i,j)=(values(i,j)-mean(values(2:end,j)))/std(values(2:end,j));
        end   
    end

    % JK(:,QntColuna+1)=Tabela(2:end,QntColuna+1);
    figure(6);

    % Parametros de desempenho
    parallelcoords(JK(:,:),'Group', metodos,'Labels',legenda);
    hold on
    
    ylabel('Standardised Cost Function Values');
    %% retira o que é maior que a média
    JK(find(JK(:,1)>0),:)=[];
    JK(find(JK(:,2)>0),:)=[];
    %% normalização Satti
    for j= 3:QntColuna
        for i= 2:QntLinha
            J2(i,j)=values(i,j)/sum(values(:,j));
        end   
    end
    
    figure(7);
    parallelcoords(J2(:,:), 'Group', metodos,'Labels',legenda);
    hold on
    ylabel('Standardised Cost Function Values');
end