local ListaAdj = {}
	
	function ListaAdj:NovaAresta( vertice )
		aresta = {}
		aresta.vertice 	= vertice
		aresta.proximo 	= {}
		return aresta
	end	

	function ListaAdj:new( grafo )
		-- body
		listaAdj = {}
		listaAdj.nome 		= grafo.nome
		listaAdj.vertices 	= grafo.vertices
		listaAdj.lista 	= {}

			function listaAdj:AdicionaVertice( )
				table.insert(self.lista, {})
				print("Vertice "..#self.lista.." foi adicionado.")
			end

			function listaAdj:RemoveVertice( vert )
				if self.lista[vert] then
					local vizinho = self.lista[vert];
					while vizinho.vertice do
						local aresta 			= self.lista[vizinho.vertice]
						local arestaAnterior	= nil
						while aresta.vertice do
							if aresta.vertice == vert then
								if arestaAnterior then
									arestaAnterior.proximo = aresta.proximo
								else
									self.lista[vizinho.vertice] = aresta.proximo
								end
								break
							end
							arestaAnterior = aresta
							aresta 		   = aresta.proximo
						end
						vizinho = vizinho.proximo
					end
					vizinho = self.lista[#self.lista];
					while vizinho.vertice do
						local aresta 			= self.lista[vizinho.vertice]
						local arestaAnterior	= nil
						while aresta.vertice do
							if aresta.vertice == #self.lista then
								aresta.vertice = vert
								break
							end
							arestaAnterior = aresta
							aresta 		   = aresta.proximo
						end
						vizinho = vizinho.proximo
					end

					self.lista[vert] = self.lista[#self.lista]
					table.remove(self.lista)
					print("Vertice "..vert.." foi removido.")
				else
					print("Vertice invalido!")
				end
			end

			function listaAdj:InsereAresta( vertA, vertB )
				if self.lista[vertA] and self.lista[vertB] then
					local aresta 			= self.lista[vertA]
					local arestaAnterior 	= nil
					while true do
						if aresta.vertice == nil then
							if arestaAnterior == nil then
								self.lista[vertA] = ListaAdj:NovaAresta(vertB)
							else
								arestaAnterior.proximo = ListaAdj:NovaAresta(vertB)
							end
							return true
						else
							if aresta.vertice == vertB then
								return false
							end
						end
						arestaAnterior = aresta
						aresta = aresta.proximo
					end	
				else
					return false
				end
			end

			function listaAdj:AdicionaAresta( vertA, vertB )
				if self:InsereAresta(vertA, vertB) then
					self:InsereAresta(vertB, vertA)
					print("Aresta "..vertA.."-"..vertB.." foi adicionada.")
				else
					print("Vertices invalidos!")
				end
			end

			function listaAdj:RetiraAresta( vertA, vertB )
				local aresta 			= self.lista[vertA]
				local arestaAnterior 	= nil
				while true do
					if aresta.vertice == nil then
						return false
					else
						if aresta.vertice == vertB then
							if arestaAnterior == nil then
								self.lista[vertA] = aresta.proximo
							else
								arestaAnterior.proximo = aresta.proximo
							end
							return true
						end
					end
					arestaAnterior = aresta
					aresta = aresta.proximo
				end	
			end

			function listaAdj:RemoveAresta( vertA, vertB )
				if self.lista[vertA] and self.lista[vertB] then
	 				if self:RetiraAresta(vertA, vertB) then
						self:RetiraAresta(vertB, vertA)
						print("Aresta "..vertA.."-"..vertB.." foi removida.")
					else
						print("Vertices invalidos!")
					end
				else
					print("Vertices invalidos!")
				end
			end

			function listaAdj:ImprimeVizinhosDoVerticie( vert )
				local vizinhos = ""
				local qtd = 0
				local vizinho = self.lista[vert]
				if vizinho.vertice then
					while vizinho.vertice do
						vizinhos 	= vizinhos .. vizinho.vertice .. " "
						vizinho 	= vizinho.proximo
					end
					print("O(s) vizinho(s) do vertice "..vert..": "..vizinhos..".")
				else
					print("O vertice "..vert.." nao possui vizinhos.")
				end
			end

			function listaAdj:ImprimeGrafo(  )
				for i = 1, #self.lista do
					local linha = "Vertice " .. i
					local aresta = self.lista[i]
					if aresta.vertice then
						linha = linha .. " - "
						while aresta.vertice do
							linha 	= linha .. aresta.vertice .. " "
							aresta 	= aresta.proximo
						end
					end
					print(linha)
				end
			end

		-- cria vertices em sequencia
		for i = 1, #grafo.vertices do
			listaAdj.lista[i] = {}
		end

		-- cria inicia as arestas
		for i = 1, #grafo.arestas do
			local indexA = tonumber(grafo.arestas[i][1])
			local indexB = tonumber(grafo.arestas[i][2])
			listaAdj:AdicionaAresta(indexA, indexB)
		end

		return listaAdj
	end

return ListaAdj