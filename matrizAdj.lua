local MatrizAdj = {}
	
	function MatrizAdj:novo( nome, n, m )
		local matrizAdj = {}
		matrizAdj.nome 		= nome
		matrizAdj.tipo		= "Matriz de Adjacencia"
		matrizAdj.visitado		= {}
		matrizAdj.explorada 	= {}
		matrizAdj.descoberta 	= {}
		matrizAdj.matriz 		= {}

			function matrizAdj:AdicionaVertice( )
				for i = 1, #self.matriz do
					table.insert(self.matriz[i], 0)
					table.insert(self.visitado[i], 0)
					table.insert(self.explorada[i], 0)
					table.insert(self.descoberta[i], 0)
				end
				table.insert(self.matriz, {})
				table.insert(self.visitado, 0)
				table.insert(self.explorada, {})
				table.insert(self.descoberta, {})
				for i = 1, #self.matriz do
					table.insert(self.matriz[#self.matriz], 0)
					table.insert(self.explorada[#self.matriz], 0)
					table.insert(self.descoberta[#self.matriz], 0)
				end
				print("Vertice "..#self.matriz.." foi adicionado.")
			end

			function matrizAdj:RemoveVertice( vert )
				if self.matriz[vert] then
					for i = 1, #self.matriz do
						self.matriz[i][vert] = self.matriz[i][#self.matriz]
						table.remove(self.matriz[i])
					end
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
					if self.matriz[vertA][vertB] == 1 then
						self.matriz[vertA][vertB] = 0
						self.matriz[vertB][vertA] = 0
						print("Aresta "..vertA.."-"..vertB.." foi removida.")
					else
						print("Vertices invalidos!")
					end
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

		local vertices = n or 0
		for i = 1, vertices do
			matrizAdj.matriz[i] = {}
			for j = 1, vertices do
				matrizAdj.matriz[i][j] = 0
			end
		end

		local arestas = m or {}
		for i = 1, #arestas do
			local indexA = tonumber(arestas[i][1])
			local indexB = tonumber(arestas[i][2])
			matrizAdj:AdicionaAresta(indexA, indexB)
		end

		return matrizAdj
	end

return MatrizAdj