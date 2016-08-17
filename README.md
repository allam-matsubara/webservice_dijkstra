Desenvolvimento de webservice para avaliação de código. Esta aplicação usa 
rails 4.2.3, ruby 2.1.5 e foi gerado a partir da gem rails-api. Para 
persistência de dados foi utilizado um banco de dados postgresql. 

**Algumas considerações:**

* Utilizar um banco como postgresql parece um pouco além do que o necessaŕio
  para este problema, talvez um banco de dados NoSQL paderia ter sido utilizado.

* O algortimo utilizado é o famoso algritmo de Dijkstra para solução de 
  caminhos ótimos em grafos direcionados ou não sem arestas negativas, como
  é o nosso caso. Porém eu não previ a existência de arestas direcionadas, 
  no problema pois o caso de exemplo e a descrição do problema não falam 
  nada a respeito de estradas(arestas) que vão só em um direção sem que 
  haja o mesmo caminha de volta. A solução prevê a existência de grafos 
  desconexos, e, caso, se selecione um vértice de origem e de destinos que 
  partençam a componentes conexas diferentes, o webservice irá retornar um 
  objeto JSON vazio.

* Um dos maiores desafios desse exercício foi a criação de um webservice.
  Nunca havia sido solicitado para criar um webservice e, apesar de ter noção
  teórica do que se tratava, a noção prática me faltava. Durante dois dias
  busquei mais informações e implementações de um webservice e, penso, 
  consegui um resultado satisfatório utilizando apenas as requisições e 
  respostas do REST dos controllers rails. Então todas as requisições feitas
  para essa aplicação devem ser feitas via HTTP utilizando os verbos corretos.
  Os detalhes de uso seguem abaixo.

* Essa aplicação não contém um cliente para enviar requisições e receber
  respostas do servidor.

* Como servidor de desenvolvimento foi usado passenger standalone.

* Essa aplicação ainda não possui testes.

**Como utilizar:**

1. Baixar a cplicação, via git ou http [daqui](https://github.com/allam-matsubara/webservice_dijkstra).

2. No diretório da aplicação rodar bundle install para download das gems 
  necessárias.

3. Configurar o config/database.yml ou utilizar o existente caso contemple suas
  necessidades.

4. Rodar as tarefas referentes ao banco de dados.
  `rake db:create && rake db:migrate && rake db:setup`

5. Iniciar o servidor de sua preferência. No Gemset da aplicação está 
  adicionado o passenger para uso standalone, mas ele pode ser substituído da
  maneira desejada.

6. Para a uitlização da aplicação é necessário popular o banco de dados,
  para tanto existe uma interface http, via POST, para que sejam adicionados
  os dados para o problema. Uma requisição deve ser feita pra http://<server>/paths
  e um objeto JSON deve ser passado logo em seguida no seguinte formato:
  ```json
  {
    "path" : [{
      "point_a": "A",
      "point_b": "B",
      "distance": "<distância de A pra B em km>",
      "name": "map_name",
    }]
  }
  ```
  **IMPORTANTE**: note que o valor da chave path é um array [] e deve ser assim
  para que se possa passar múltiplos valores para a action de um só vez, sem 
  precisr salvar um registros de cada vez. Mesmo que se vá passar apenas 1 
  registro para ser salvo, este precisa estar encapsulado dentro de um array.

7. Se tudo ocorrer bem durante a criação dos objetos, pode ser fazer a requisição
  para execução do programa. Novamente, via POST, para http://<server>/paths/find_shortest
  e um outro objeto JSON deve ser passado como parâmetro no seguinte formato
  ```json
  {
    "find_shortest" : {
      "map_name": "<nome do mapa>",
      "origin": "<nome do ponto de origem>",
      "destination": "<nome do ponto de destino>",
      "autonomy": "<um valor numérico>",
      "fuel_cost": "<outro valor numérico>"
    }
  }
  ```

8. A aplicação vai gerar como resposta um JSON. vazio caso o algoritmo tenha
  falhado, ou o seguinte objeto:
  ```json
  {
    "route": "A B D",
    "cost": 6.25
  }
  ```
 onde route é o caminho ótimo a ser percorrido e cost é custo da viagem pelo
 caminho ótimo.

Acho que é isso. Obrigado pela oportunidade.
  









