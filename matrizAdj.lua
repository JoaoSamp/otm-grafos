local MatrizAdj = {}
	
	function MatrizAdj:new( grafo )
		-- body
		local matrizAdj = {}
		-- copia nome e vertices
		matrizAdj.nome 		= grafo.nome
		matrizAdj.vertices 	= grafo.vertices
		matrizAdj.matriz 	= {}

			function matrizAdj:AdicionaVertice( )
				-- adiciona uma coluna em cada linha com 0
				for i = 1, #self.matriz do
					self.matriz[i][#self.matriz + 1] = 0
				end
				-- adiciona uma linha com 0s
				self.matriz[#self.matriz + 1] = {}
				for i = 1, #self.matriz do
					self.matriz[#self.matriz][i] = 0
				end
				print("Vertice "..#self.matriz.." foi adicionado.")
			end

			function matrizAdj:RemoveVertice( vert )
				-- em cada linha, salva o valor da ultima coluna na coluna do vertice a ser removido
				-- em seguida, remove a ultima coluna de cada linha
				if self.matriz[vert] then
					for i = 1, #self.matriz do
						self.matriz[i][vert] = self.matriz[i][#self.matriz]
						table.remove(self.matriz[i])
					end
					-- em cada coluna, salva o valor da ultima linha na linha do vertice a ser removido
					-- em seguida remove a ultima linha
					for i = 1, #self.matriz[vert] do
						self.matriz[vert][i] = self.matriz[#self.matriz][i]
					end
					table.remove(self.matriz)
					print("Vertice "..vert.." foi removido.")
				else
					print("Vertice invalido!")
				end
			end

			function matrizAdj:AdicionaAresta( vertA, vertB )
				if self.matriz[vertA] and self.matriz[vertB] then
					self.matriz[vertA][vertB] = 1
					self.matriz[vertB][vertA] = 1
					print("Aresta "..vertA.."-"..vertB.." foi adicionada.")
				else
					print("Vertices invalidos!")
				end
			end

			function matrizAdj:RemoveAresta( vertA, vertB )
				if self.matriz[vertA] and self.matriz[vertB] then
					self.matriz[vertA][vertB] = 0
					self.matriz[vertB][vertA] = 0
					print("Aresta "..vertA.."-"..vertB.." foi removida.")
				else
					print("Vertices invalidos!")
				end
			end

			function matrizAdj:ImprimeVizinhosDoVerticie( vert )
				local vizinhos = ""
				local qtd = 0
				for i = 1, #self.matriz do
					if self.matriz[vert][i] == 1 then
						vizinhos = vizinhos..i.." "
						qtd = qtd + 1
					end
				end
				if qtd > 0 then
					print("O(s) vizinho(s) do vertice "..vert..": "..vizinhos..".")
				else
					print("O vertice "..vert.." nao possui vizinhos.")
				end
			end

			function matrizAdj:ImprimeGrafo( )
				for i = 1, #self.matriz do
					local linha = ""
					for j = 1, #self.matriz[i] do
						linha = linha .. matrizAdj.matriz[i][j] .. " "
					end
					print(linha)
				end
			end


		-- cria vertices em sequencia
		for i = 1, #grafo.vertices do
			matrizAdj.matriz[i] = {}
			for j = 1, #grafo.vertices do
				matrizAdj.matriz[i][j] = 0
			end
		end

		-- cria inicia as arestas
		for i = 1, #grafo.arestas do
			local indexA = tonumber(grafo.arestas[i][1])
			local indexB = tonumber(grafo.arestas[i][2])
			matrizAdj:AdicionaAresta(indexA, indexB)
		end

		return matrizAdj
	end

return MatrizAdj