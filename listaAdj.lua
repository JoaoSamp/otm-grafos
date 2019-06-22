local ListaAdj = {}
	
	function ListaAdj:NovaArestaFluxo( vertice, cap, fluxo, tipo )
		local aresta = {}
		aresta.vertice 		= vertice
		aresta.capacidade	= cap
		aresta.fluxo 		= fluxo
		aresta.tipo			= tipo or 1
		aresta.gemeo		= {}
		aresta.proximo 		= {}
		return aresta
	end

	function ListaAdj:NovaAresta( vertice )
		local aresta = {}
		aresta.vertice 		= vertice
		aresta.explorada 	= false
		aresta.descoberta 	= false
		aresta.proximo 		= {}
		return aresta
	end	

	function ListaAdj:novo( nome, n, m )
		local listaAdj = {}
		listaAdj.nome 		= nome
		listaAdj.tipo		= "Lista de Adjacencia"
		listaAdj.visitado 	= {}
		listaAdj.distancia 	= {}
		listaAdj.lista 		= {}
		listaAdj.floresta 	= {}
		listaAdj.inicio 	= 0
		listaAdj.fim 		= 0
		listaAdj.capacitado = false


			function listaAdj:AdicionaVertice( )
				table.insert(self.lista, {})
				table.insert(self.visitado, false)
				table.insert(self.distancia, 0)
				return #self.lista
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
									arestaAnterior.proximo 		= aresta.proximo
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
					return true
				else
					return false
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
						arestaAnterior 	= aresta
						aresta 			= aresta.proximo
					end	
				else
					return false
				end
			end

			function listaAdj:AdicionaAresta( vertA, vertB )
				if self:InsereAresta(vertA, vertB) then
					self:InsereAresta(vertB, vertA)
					return true
				else
					return false
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
					arestaAnterior 	= aresta
					aresta 			= aresta.proximo
				end	
			end 

			function listaAdj:RemoveAresta( vertA, vertB )
				if self.lista[vertA] and self.lista[vertB] then
	 				if self:RetiraAresta(vertA, vertB) then
						self:RetiraAresta(vertB, vertA)
						return true
					else
						return false
					end
				else
					return false
				end
			end

			function listaAdj:ImprimeVizinhosDoVerticie( vert )
				local vizinhos 	= ""
				local vizinho 	= self.lista[vert]
				if vizinho then
					while vizinho do
						if vizinho.vertice then
							vizinhos 	= vizinhos .. vizinho.vertice .. " "
						end
						vizinho 	= vizinho.proximo
					end
					print("O(s) vizinho(s) do vertice "..vert..": "..vizinhos..".")
				else
					print("O vertice "..vert.." nao possui vizinhos.")
				end
			end

			function listaAdj:ImprimeGrafo( g )
				local grafo = g or self
				for i = 1, #grafo.lista do
					local linha = "Vertice " .. i
					local aresta = grafo.lista[i]
					if aresta.vertice then
						linha = linha .. " - "
						while aresta.vertice do
							linha 	= linha .. aresta.vertice .. " "
							if self.capacitado then
								linha = linha .. "Cap("..aresta.capacidade..") "
							end
							aresta 	= aresta.proximo
						end
					end
					print(linha)
				end
			end

			function listaAdj:ImprimeDistancia( vert )
				print("Distancia em relação ao vertice "..vert)
				for i = 1, #self.lista do
					local linha = "Vertice " .. i .. " - Dist " .. self.distancia[i]
					print(linha)
				end
			end
			
			function listaAdj:IniciaBusca(  )
				for i = 1, #self.lista do
					self.visitado[i] = false;
					self.distancia[i] = 0;
					local aresta = self.lista[i]
					while aresta do
						if aresta.vertice then
							aresta.explorada 	= false
							aresta.descoberta 	= false
						end
						aresta 				= aresta.proximo
					end
				end				
			end

			function listaAdj:MarcaVisitado( vert )
				self.visitado[vert] = true
			end

			function listaAdj:MarcaDistancia( vert, nivel )
				self.distancia[vert] = nivel
			end

			function listaAdj:MarcaExplorada( vertA, vertB, exibir )
				local aresta = self.lista[vertA]
				while aresta do
					if aresta.vertice == vertB then
						aresta.explorada = true
						break
					end
					aresta = aresta.proximo
				end
				aresta = self.lista[vertB]
				while aresta do
					if aresta.vertice == vertA then
						aresta.explorada = true
						break
					end
					aresta = aresta.proximo
				end
				if exibir ==true then
					print("Aresta "..vertA.."-"..vertB.." explorada")
				end
			end

			function listaAdj:MarcaDescoberta( vertA, vertB, exibir )
				local aresta = self.lista[vertA]
				while aresta do
					if aresta.vertice == vertB then
						aresta.descoberta = true
						break
					end
					aresta = aresta.proximo
				end
				aresta = self.lista[vertB]
				while aresta do
					if aresta.vertice == vertA then
						aresta.descoberta = true
						break
					end
					aresta = aresta.proximo
				end
				if exibir == true then
					print("Aresta "..vertA.."-"..vertB.." descoberta")
				end
			end

			function listaAdj:BuscaProfundidade (vert, exibir)
				local pilha = {}
				table.insert(pilha, {vert, self.lista[vert]})
				self:MarcaVisitado(vert)
				while #pilha > 0 do
					local ultVertVis 	= pilha[#pilha][1]
					local aresta 		= pilha[#pilha][2]
					pilha[#pilha][2]	= pilha[#pilha][2].proximo
					if aresta.vertice then
						if self.visitado[aresta.vertice] then
							if not (aresta.explorada) then
								self:MarcaExplorada(	ultVertVis, aresta.vertice, exibir)
							end
						else
							self:MarcaVisitado(aresta.vertice)
							self:MarcaExplorada(	ultVertVis, aresta.vertice, exibir)
							self:MarcaDescoberta(	ultVertVis, aresta.vertice, exibir)
							table.insert(pilha, {aresta.vertice, self.lista[aresta.vertice]})
						end
					else
						table.remove(pilha)
					end
				end
			end

			function listaAdj:BuscaProfundidadeRecur (vert, exibir)
				self:MarcaVisitado(vert)
				local aresta = self.lista[vert]
				while aresta.vertice do
					if aresta.vertice then
						if self.visitado[aresta.vertice] then
							if not (aresta.explorada) then
								self:MarcaExplorada(	vert, aresta.vertice, exibir)
							end
						else
							self:MarcaExplorada(	vert, aresta.vertice, exibir)
							self:MarcaDescoberta(	vert, aresta.vertice, exibir)
							self:BuscaProfundidadeRecur(aresta.vertice, exibir)
						end
					end
					aresta = aresta.proximo
				end
			end

			function listaAdj:BuscaLargura (vert, exibir)
				local fila = {vert}
				self:MarcaVisitado(vert)
				while #fila > 0 do
					local vertVisitado 	= table.remove(fila, 1)
					local aresta 		= self.lista[vertVisitado]
					while aresta do
						if aresta.vertice then
							if self.visitado[aresta.vertice] then
								if not (aresta.explorada) then
									self:MarcaExplorada( vertVisitado, aresta.vertice, exibir )
								end
							else
								table.insert(fila, aresta.vertice)
								self:MarcaExplorada( vertVisitado, aresta.vertice, exibir )
								self:MarcaVisitado( aresta.vertice )
								self:MarcaDescoberta( vertVisitado, aresta.vertice, exibir )
							end
						end
						aresta = aresta.proximo
					end
				end
			end

			function listaAdj:DeterminarDistancias( vert, exibir )
				self:IniciaBusca()
				if self.lista[vert] ~= nil then
					local fila = {}
					table.insert(fila, { vert, 1 })
					self:MarcaVisitado ( vert )
					self:MarcaDistancia ( vert, 1 )
					while #fila > 0 do
						local elementoFila			= table.remove(fila, 1)
						local vertVisitado, nivel	= elementoFila[1], elementoFila[2]
						local aresta 				= self.lista[vertVisitado]
						while aresta do
							if aresta.vertice then
								if self.visitado[aresta.vertice] then
									if not (aresta.explorada) then
										self:MarcaExplorada( vertVisitado, aresta.vertice, exibir )
									end
								else
									table.insert(fila, {	aresta.vertice, nivel + 1})
									self:MarcaVisitado ( 	aresta.vertice )
									self:MarcaDistancia (	aresta.vertice, nivel + 1)
									self:MarcaExplorada ( 	vertVisitado, aresta.vertice, exibir )
									self:MarcaDescoberta (	vertVisitado, aresta.vertice, exibir )
								end
							end
							aresta = aresta.proximo
						end
					end
					return true
				end
				return false
			end

			function listaAdj:BuscaUnicaLargura(vert, exibir)
				self:IniciaBusca()
				self:BuscaLargura(vert, exibir)
			end

			function listaAdj:BuscaUnicaProfundidade(vert, exibir)
				self:IniciaBusca()
				self:BuscaProfundidade(vert, exibir)
			end

			function listaAdj:BuscaUnicaProfundidadeRecur(vert, exibir)
				self:IniciaBusca()
				self:BuscaProfundidadeRecur(vert, exibir)
			end

			function listaAdj:BuscaCompletaLargura( exibir )
				self:IniciaBusca()
				for i = 1, #self.lista do
					self:BuscaLargura(i, exibir)
				end
			end

			function listaAdj:BuscaCompletaProfundidade( exibir )
				self:IniciaBusca()
				for i = 1, #self.lista do
					self:BuscaProfundidade(i, exibir)
				end
			end

			function listaAdj:BuscaCompletaProfundidadeRecur( exibir )
				self:IniciaBusca()
				for i = 1, #self.lista do
					self:BuscaProfundidadeRecur(i, exibir)
				end
			end

			function listaAdj:EhArvore( )
				for i = 1, #self.visitado do
					if not(self.visitado[i]) then
						return false
					end
				end
				for i = 1, #self.lista do
					local aresta = self.lista[i]
					while aresta do
						if aresta.vertice then
							if not(aresta.descoberta) then
								return false
							end
						end
						aresta = aresta.proximo
					end
				end
				return true
			end

			function listaAdj:EhConexo()
				for i = 1, #self.visitado do
					if not(self.visitado[i]) then
						return false
					end
				end
				return true
			end

			function listaAdj:TemCiclo()
				for i = 1, #self.lista do
					local aresta = self.lista[i]
					while aresta do
						if aresta.vertice then
							if not(aresta.descoberta) then
								return true
							end
						end
						aresta = aresta.proximo
					end
				end
				return false
			end

			function listaAdj:ObterFlorestaGeradora(  )
				self.floresta 		= ListaAdj:novo("Floresta Geradora", #self.lista)
				self.floresta.lista = {}
				for i = 1, #self.lista do
					self.floresta.lista[i] 		= {}
					self.floresta.visitado[i] 	= false;
				end

				for i = 1, #self.lista do
					local aresta = self.lista[i]
					while aresta do
						if aresta.vertice then
							if (aresta.descoberta) then
								self.floresta:AdicionaAresta(i, aresta.vertice)
							end
						end
						aresta = aresta.proximo
					end
				end
			end

			function listaAdj:AdicionaArestaCapacitada( vertA, vertB, cap, fluxo, tipo )
				if self.lista[vertA] and self.lista[vertB] then
					local aresta 			= self.lista[vertA]
					local arestaAnterior 	= nil
					while true do
						if aresta.vertice == nil then
							local aresta = ListaAdj:NovaArestaFluxo(vertB, cap, fluxo, tipo)
							if arestaAnterior == nil then
								self.lista[vertA] = aresta
							else
								arestaAnterior.proximo = aresta
							end
							return true, aresta
						else
							if aresta.vertice == vertB then
								return false
							end
						end
						arestaAnterior 	= aresta
						aresta 			= aresta.proximo
					end	
				else
					return false
				end
			end

			function listaAdj:InicializaGrafoCapacitado ( inicio, fim )
				self.inicio = inicio
				self.fim = fim
				for i = 1, #self.lista do
					self.lista[i] 		= {}
					self.visitado[i] 	= false;
				end

				local arestas = m or {}
				for i = 1, #arestas do
					local indexA = tonumber(arestas[i][1])
					local indexB = tonumber(arestas[i][2])
					local capacidade = tonumber(arestas[i][3])
					self:AdicionaArestaCapacitada(indexA, indexB, capacidade, 0, 1)
				end
				self.capacitado = true
			end

			function listaAdj:CaminhoAumentador( )
				self:IniciaBusca()
				local fila 	= {}
				table.insert(fila, {vertice = self.inicio, anterior = nil, capResid = -1})
				self:MarcaVisitado(self.inicio)
				local caminhoCompleto = false
				while #fila > 0 and not(caminhoCompleto) do
					local elementoFila 	= table.remove(fila, 1)
					local vertVisitado 	= elementoFila.vertice
					local aresta 		= self.lista[vertVisitado]
					while aresta do
						if aresta.vertice then
							local capResid = aresta.capacidade - aresta.fluxo
							if not(self.visitado[aresta.vertice]) and (capResid > 0) then
								table.insert(fila, {vertice = aresta.vertice, anterior = elementoFila, capResidual = capResid})
								self:MarcaVisitado( aresta.vertice )
								if aresta.vertice == self.fim then
									caminhoCompleto = true
									break
								end
							end
						end
						aresta = aresta.proximo
					end
				end
				if not(self.visitado[self.fim]) then
					return 0, nil
				end
				local caminho = {}
				local capacidade = -1
				local ultimoElemento = table.remove(fila)
				local delta = -1
				while ultimoElemento do
					if ultimoElemento.capResidual then
						if delta == -1 then
							delta = ultimoElemento.capResidual
						elseif ultimoElemento.capResidual > 0 and ultimoElemento.capResidual < delta then
							delta = ultimoElemento.capResidual
						end
					end
					table.insert(caminho, 1, ultimoElemento.vertice)
					ultimoElemento = ultimoElemento.anterior
				end
				return delta, caminho
			end

			function listaAdj:AtualizaFluxo( vertA, vertB, deltaFluxo )
				local aresta = self.lista[vertA]
				while aresta.proximo do
					if aresta.vertice == vertB then
						aresta.fluxo 		= aresta.fluxo + deltaFluxo
						aresta.gemeo.fluxo 	= aresta.gemeo.fluxo - deltaFluxo
						break
					end
					aresta = aresta.proximo
				end
			end

			function listaAdj:Expandir( )
				for i=1, #self.lista do
					local aresta = self.lista[i]
					while aresta.proximo do
						if aresta.vertice and aresta.tipo == 1 then
							local sucesso, arestaArtificial = self:AdicionaArestaCapacitada(aresta.vertice, i, 0, -aresta.fluxo, -1)
							aresta.gemeo 			= arestaArtificial
							arestaArtificial.gemeo 	= aresta
						end
						aresta = aresta.proximo
					end
				end
			end

			function listaAdj:Contrair( )
				for i=1, #self.lista do
					local aresta = self.lista[i]
					while aresta.proximo do
						if aresta.vertice and aresta.tipo == -1 then
							self:RetiraAresta( i, aresta.vertice )
						end
						aresta = aresta.proximo
					end
				end
			end

			function listaAdj:FluxoMaximo( )
				self:Expandir()

				for i=1, #self.lista do
					local aresta = self.lista[i]
					while aresta.proximo do
						if aresta.vertice and aresta.tipo == -1 then
							aresta.fluxo = 0
						end
						aresta = aresta.proximo
					end
				end
				local intensidade = 0
				local delta, caminho = self:CaminhoAumentador()
				while delta > 1 do
					local linha = "Caminho "
					for i = 1, #caminho - 1 do
						self:AtualizaFluxo( caminho[i], caminho[i+1], delta )
						linha = linha .. caminho[i]
					end
					print(linha .. caminho[#caminho].." - Cap("..delta..")")
					intensidade = intensidade + delta
					delta, caminho = self:CaminhoAumentador()
				end
				self:Contrair()
				return intensidade
			end

			local vertices = n or 0
			for i = 1, vertices do
				listaAdj.lista[i] 		= {}
				listaAdj.visitado[i] 	= false;
				listaAdj.distancia[i] 	= 0;
			end

			local arestas = m or {}
			for i = 1, #arestas do
				local indexA = tonumber(arestas[i][1])
				local indexB = tonumber(arestas[i][2])
				listaAdj:AdicionaAresta(indexA, indexB)
			end

		return listaAdj
	end

return ListaAdj