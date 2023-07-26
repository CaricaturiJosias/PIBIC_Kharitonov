function [] = ParallelCoords(Tabela, QntKharitonov)
    % 3 porque ignora a linha de métodos e PID (ambos string)
    legenda = cellstr(Tabela(1, 3:end));
    % 2 porque ignora o nome da coluna no topo
    metodos = cellstr(Tabela(2:end, 1))';
    % Desconsidera a linha de PID
    QntColuna = size(Tabela, 2)-2;
    % Desconsidera nome das colunas
    QntLinha = size(Tabela, 1)-1;
    % Retira cell de 1x1 de cada posição
    values = cell2mat(Tabela(2:end,3:end));
    
    % Se eu tenho 5 polinomios, tenho 6 items (1 é nominal)
    espacamento_itens = QntKharitonov;  

    % Número de itens diferentes que podem ser usados
    % para fazer gráficos
    QntItens = length(legenda)/(espacamento_itens);

    % Se eu tenho 4 polinomios, tenho 5 colunas por item
    % Então se eu tenho 20 colunas, eu tenho 4 items
    % Ex:
    % Itae, Itae k1, Itae k2, Itae k3, Itae k4
    % então 
    % MSE, MSE k1, MSE k2, MSE k3, MSE k4
    % e dessa forma em diante...
    
    Legenda = ["", "", "Nominal", "K^{1}", "K^{2}", "K^{3}", "K^{4}"];
    symbol = ["*", "o"];
    
    % Se eu tenho 4 itens, quero fazer 4 gráficos, se tenho 6 quero 6
    % A Divisão escurece as cores
    colors = flipud(jet(length(Legenda))/1.3);
    for k = 1:(length(metodos)/2)
        for j = 1:(QntItens/2) % Para cada metodo (ZN, Parr, Chimdambaram, etc.)
            
            figure();
            hold all; grid on;
            legendItem = [];
    
            % Gerando handler do plot pra fazer uma legenda de cores
            % Index de começo dos 5 itens
            indexItem1 = 1 + (j-1)*(espacamento_itens*2); % 1, 11, 21
            indexItem2 = 1 + espacamento_itens + (j-1)*(espacamento_itens*2); % 6, 16, 26 
    
            for i = 0:length(Legenda)-3 % Para cada polinomio (nominal, k1, k2...)
                % Plota a linha conectando os pontos
                % Tenho QntItens - 1 linhas, logo um dos casos tem que ser
                % ignorado
                if (i == 1)
                    legendItem = [legendItem ...
                        scatter(nan, nan, 'Marker', symbol(1))];
                    legendItem = [legendItem ...
                        scatter(nan, nan, 'Marker', symbol(2))];
                    legendItem = [legendItem ...
                        plot(nan, nan, 'color', colors(i+1, :))];
                end
    
                if (i ~= 0)
                    % All of these represent 2 values, the previous and the
                    % current to have a line in the graph
                    line_y_index_1 = i+indexItem1 -1;
                    line_y_index_2 = i+indexItem1;
                    line_x_index_1 = i+indexItem2 -1;
                    line_x_index_2 = i+indexItem2;

                    legendItem = [legendItem ...
                        plot(   values((k-1)*2 + 1,line_y_index_1:line_y_index_2), ...
                                values((k-1)*2 + 1,line_x_index_1:line_x_index_2), ...
                                'Color', colors(i+1, :), ...
                                'Marker', symbol(1))];
                    plot(   values((k-1)*2 + 2,line_y_index_1:line_y_index_2), ...
                            values((k-1)*2 + 2,line_x_index_1:line_x_index_2), ...
                            'Color', colors(i+1, :), ...
                            'Marker', symbol(2));
                end
            end
            ylabel(legenda(indexItem2));
            xlabel(legenda(indexItem1));
            titulo = strcat(metodos((k-1)*2 + 1), " x ", metodos((k-1)*2 + 2), ...
                           " - ", legenda(indexItem2), ...
                           " x ", legenda(indexItem1));
            title(titulo);    
            % Incluir a representação dos critérios na legenda
            Legenda(1) = metodos((k-1)*2 + 1);
            Legenda(2) = metodos((k-1)*2 + 2);
            legend(legendItem, Legenda, 'Location', 'best');
        end
    end
end