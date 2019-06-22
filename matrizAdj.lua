local MatrizAdj = {}
	
	function MatrizAdj:novo( nome, n, m )
		local matrizAdj = {}
		matrizAdj.nome 		= nome
		matrizAdj.tipo		= "Matriz de Adjacencia"
		matrizAdj.visitado		= {}
		matrizAdj.distancia		= {}
		matrizAdj.explorada 	= {}
		matrizAdj.descoberta 	= {}
		matrizAdj.matriz 		= {}
		matrizAdj.inicio 		= 0
		matrizAdj.fim 			= 0

			function matrizAdj:AdicionaVertice( )
				for i = 1, #self.matriz do
					table.insert(self.matriz[i], 0)
				end
				table.insert(self.matriz, {})
				for i = 1, #self.matriz do
					table.insert(self.matriz[#self.matriz], 0)
				end
				return #self.matriz
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
					return true
				end
				return false
			end

			function matrizAdj:AdicionaAresta( vertA, vertB )
				if self.matriz[vertA] and self.matriz[vertB] and (vertA ~= vertB) then
					self.matriz[vertA][vertB] = 1
					self.matriz[vertB][vertA] = 1
					return true
				end
				return false
			end

			function matrizAdj:RemoveAresta( vertA, vertB )
				if (self.matriz[vertA] and self.matriz[vertB]) and (vertA ~= vertB) then
					if self.matriz[vertA][vertB] == 1 then
						self.matriz[vertA][vertB] = 0
						self.matriz[vertB][vertA] = 0
						return true
					else
						return false
					end
				end
				return false
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

			function matrizAdj:ImprimeGrafo( g )
				grafo = g or self
				for i = 1, #grafo.matriz do
					local linha = ""
					for j = 1, #grafo.matriz[i] do
						linha = linha .. grafo.matriz[i][j] .. " "
					end
					print(linha)
				end
			end

			function matrizAdj:ImprimeDistancia( vert )
				print("Distancia em relação ao vertice "..vert)
				for i = 1, #self.distancia do
					local linha = "Vertice " .. i .. " - Dist " .. self.distancia[i]
					print(linha)
				end
			end

			function matrizAdj:IniciaBusca(  )
				self.visitado		= {}
				self.explorada 		= {}
				self.descoberta 	= {}
				self.distancia 		= {}
				for i = 1, #self.matriz do
					table.insert( self.visitado, false )
					table.insert( self.distancia, 0 )
					table.insert( self.explorada, {} )
					table.insert( self.descoberta, {} )
					for j = 1, #self.matriz do
						table.insert(self.explorada[i], false)
						table.insert(self.descoberta[i], false)
					end
				end				
			end

			function matrizAdj:MarcaVisitado( vert )
				self.visitado[vert] = true
			end

			function matrizAdj:MarcaDistancia( vert, nivel )
				self.distancia[vert] = nivel
			end

			function matrizAdj:MarcaExplorada( vertA, vertB, exibir )
				self.explorada[vertA][vertB] = true
				self.explorada[vertB][vertA] = true

				if exibir ==true then
					print("Aresta "..vertA.."-"..vertB.." explorada")
				end
			end

			function matrizAdj:MarcaDescoberta( vertA, vertB, exibir )
				self.descoberta[vertA][vertB] = true
				self.descoberta[vertB][vertA] = true

				if exibir ==true then
					print("Aresta "..vertA.."-"..vertB.." descoberta")
				end
			end

			function matrizAdj:BuscaProfundidade (vert, exibir)
				local pilha = {}
				table.insert(pilha, {vert, 1})
				self:MarcaVisitado(vert)
				while #pilha > 0 do
					local ultVertVis 	= pilha[#pilha][1]
					local vizinho 		= pilha[#pilha][2]
					pilha[#pilha][2]	= vizinho + 1
					if vizinho <= #self.matriz then
						if self.matriz[ultVertVis][vizinho] == 1 then
							if self.visitado[vizinho] then
								if not (self.explorada[ultVertVis][vizinho]) then
									self:MarcaExplorada(	ultVertVis, vizinho, exibir)
								end
							else
								self:MarcaVisitado( 	vizinho)
								self:MarcaExplorada(	ultVertVis, vizinho, exibir)
								self:MarcaDescoberta(	ultVertVis, vizinho, exibir)
								table.insert(pilha, {vizinho, 1})
							end
						end
					else
						table.remove(pilha)
					end
				end
			end

			function matrizAdj:BuscaProfundidadeRecur (vert, exibir)
				self:MarcaVisitado(vert)
				for vizinho = 1, #self.matriz do
					if self.matriz[vert][vizinho] == 1 then
						if self.visitado[vizinho] then
							if not (self.explorada[vert][vizinho]) then
								self:MarcaExplorada(	vert, vizinho, exibir)
							end
						else
							self:MarcaVisitado( 	vizinho)
							self:MarcaExplorada(	vert, vizinho, exibir)
							self:MarcaDescoberta(	vert, vizinho, exibir)
							self:BuscaProfundidadeRecur(vizinho, exibir)
						end
					end
				end
			end

			function matrizAdj:BuscaLargura (vert, exibir)
				local fila = {vert}
				self:MarcaVisitado(vert)
				while #fila > 0 do
					local vertVisitado 	= table.remove(fila, 1)
					for vizinho = 1, #self.matriz do
						if self.matriz[vertVisitado][vizinho] == 1 then
							if self.visitado[vizinho] then
								if not (self.explorada[vertVisitado][vizinho]) then
									self:MarcaExplorada( vertVisitado, vizinho, exibir )
								end
							else
								table.insert(fila, vizinho)
								self:MarcaVisitado( vizinho )
								self:MarcaExplorada( vertVisitado, vizinho, exibir )
								self:MarcaDescoberta( vertVisitado, vizinho, exibir )
							end
						end
					end
				end
			end

			function matrizAdj:DeterminarDistancias( vert, exibir )
				self:IniciaBusca()
				if self.matriz[vert] ~= nil then
					local fila = {}
					table.insert(fila, { vert, 1 })
					self:MarcaVisitado ( vert )
					self:MarcaDistancia ( vert, 1 )
					while #fila > 0 do
						local elementoFila			= table.remove(fila, 1)
						local vertVisitado, nivel	= elementoFila[1], elementoFila[2]
						for vizinho = 1, #self.matriz do
							if self.matriz[vertVisitado][vizinho] == 1 then
								if self.visitado[vizinho] then
									if not (self.explorada[vertVisitado][vizinho]) then
										self:MarcaExplorada( vertVisitado, vizinho, exibir )
									end
								else
									table.insert(fila, {	vizinho, nivel + 1})
									self:MarcaVisitado ( 	vizinho )
									self:MarcaDistancia (	vizinho, nivel + 1)
									self:MarcaExplorada ( 	vertVisitado, vizinho, exibir )
									self:MarcaDescoberta ( 	vertVisitado, vizinho, exibir )
								end
							end
						end
					end
					return true
				end
				return false
			end

			function matrizAdj:BuscaUnicaLargura(vert, exibir)
				self:IniciaBusca()
				self:BuscaLargura(vert, exibir)
			end

			function matrizAdj:BuscaUnicaProfundidade(vert, exibir)
				self:IniciaBusca()
				self:BuscaProfundidade(vert, exibir)
			end

			function matrizAdj:BuscaUnicaProfundidadeRecur(vert, exibir)
				self:IniciaBusca()
				self:BuscaProfundidadeRecur(vert, exibir)
			end

			function matrizAdj:BuscaCompletaLargura( exibir )
				self:IniciaBusca()
				for i = 1, #self.matriz do
					self:BuscaLargura(i, exibir)
				end
			end

			function matrizAdj:BuscaCompletaProfundidade( exibir )
				self:IniciaBusca()
				for i = 1, #self.matriz do
					self:BuscaProfundidade(i, exibir)
				end
			end

			function matrizAdj:BuscaCompletaProfundidadeRecur( exibir )
				self:IniciaBusca()
				for i = 1, #self.matriz do
					self:BuscaProfundidadeRecur(i, exibir)
				end
			end

			function matrizAdj:EhArvore( )
				for i = 1, #self.visitado do
					if not(self.visitado[i]) then
						return false
					end
				end
				for i = 1, #self.descoberta do
					for j = 1, #self.descoberta[i] do
						if (i ~= j) and (not(self.descoberta[i][j])) then
							return false
						end
					end
				end
				return true
			end

			function matrizAdj:EhConexo()
				for i = 1, #self.visitado do
					if not(self.visitado[i]) then
						return false
					end
				end
				return true
			end

			function matrizAdj:TemCiclo()
				for i = 1, #self.descoberta do
					for j = 1, #self.descoberta[i] do
						if (i ~= j) and (not(self.descoberta[i][j])) then
							return true
						end
					end
				end
				return false
			end

			function matrizAdj:ObterFlorestaGeradora(  )
				self.floresta 			= MatrizAdj:novo("Floresta Geradora", #self.matriz)
				self.floresta.matriz 	= {}
				for i = 1, #self.matriz do
					self.floresta.matriz[i] = {}
					for j = 1, #self.matriz do
						self.floresta.matriz[i][j] = 0
					end
				end

				for i = 1, #self.descoberta do
					for j = 1, #self.descoberta do
						if self.descoberta[i][j] == true then
							self.floresta:AdicionaAresta(i, j)
						end
					end
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