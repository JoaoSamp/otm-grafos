local Matriz 	= require("matrizAdj")
local Lista		= require("listaAdj")

	grafosLidos = {}
	grafoSelecionado = nil

	function Valor_Invalido(  )
		print("Valor invalido !")
		print()
	end
	
	function LerArquivo(  )
		grafosLidos = {}
		local file = nil
		print()
		local dir 	= "grafos.txt"
		file 		= io.open(dir, "rb")
		print("...")
		if file then
			local jsObj = file:read("*line")
			while jsObj ~= nil do
				jsObj = jsObj:gsub( "{(%s*)(\")", "{")
				jsObj = jsObj:gsub( "(\")(%s*):", ":")
				jsObj = jsObj:gsub( ",(%s*)(\")", ",")
				jsObj = jsObj:gsub( ":", "=")
				jsObj = jsObj:gsub( '%[', "{")
				jsObj = jsObj:gsub( '%]', "}")
				jsObj = "grafoJS = "..jsObj
				load(jsObj)()
				print(grafoJS.nome .. " lido com sucesso.")
				table.insert(grafosLidos, grafoJS)
				jsObj = file:read("*line")
			end
			file:close()
			return true
		else
			return false
		end
	end

	function Leitura( )
		print("Pressione ENTER para continuar com leitura...")
		io.read("*line")
		print("Lendo Arquivo")
		if LerArquivo() then
			print("Leitura realizada com sucesso !")
			return true
		else
			print("Arquivo grafos.txt não encontrado !")
			print("Deseja repetir o processo?")
			print("1 - Sim")
			print("2 - Nao")
			local entrada = io.read("*line")
			if tonumber(entrada) then
				if tonumber(entrada) ~= 1 then
					print("Leitura Abortada.")
					return false
				end
			else
				print("Valor invalido ! Leitura Abortada.")
				return false
			end
		end
	end

	function Seleciona( )
		if grafosLidos[1] == nil then
			print()
			print("Nenhum grafo lido recentemente.")
			if not(Leitura()) then
				return false
			end
		end
		while true do
			print()
			print("Selecione um dos grafos armazenados:")
			for i=1, #grafosLidos do
				print(i .." - "..grafosLidos[i].nome)
			end 
			print( (#grafosLidos + 1).." - Realizar leitura novamente")
			print("0 - Manter grafo atual")
			if grafoSelecionado ~= nil then
				print()
				print("O grafo selecionado atualmente é "..grafoSelecionado.nome)
				print("No formato de "..grafoSelecionado.tipo)
			end
			print()
			print("Selecione o grafo a ser utilizado: ")
			entrada = io.read("*line")
			if tonumber(entrada) then
				local grafoSelec = tonumber(entrada)
				if grafoSelec == 0 then
					print("Grafo mantido")
					break
				elseif grafoSelec <= #grafosLidos and grafoSelec > 0 then
					local opcao = 0
					while opcao ~= 1 or opcao ~= 2 do
						print("Selecione o tipo de armazenamento:")
						print("1 - Matriz Adj")
						print("2 - Lista Adj")
						local entrada = io.read("*line")
						if tonumber(entrada) then
							opcao = tonumber(entrada)
							if opcao == 1 then
								grafoSelecionado = Matriz:novo( grafosLidos[grafoSelec].nome, 
																#grafosLidos[grafoSelec].vertices, 
																grafosLidos[grafoSelec].arestas )
								break
							elseif opcao == 2 then
								grafoSelecionado = Lista:novo( grafosLidos[grafoSelec].nome, 
																#grafosLidos[grafoSelec].vertices, 
																grafosLidos[grafoSelec].arestas )
								break
							else
								Valor_Invalido()
							end
						end
					end
					print("\n"..grafoSelecionado.nome.." selecionado com sucesso - "..grafoSelecionado.tipo)

					local opcao = 0
					while opcao ~= 1 or opcao ~= 2 do
						print("Inicia capacitado:")
						print("1 - Sim")
						print("2 - Não")
						local entrada = io.read("*line")
						if tonumber(entrada) then
							opcao = tonumber(entrada)
							if opcao == 1 then
								grafoSelecionado:InicializaGrafoCapacitado( 
																grafosLidos[grafoSelec].inicio, 
																grafosLidos[grafoSelec].fim )
								break
							elseif opcao == 2 then
								print("Grafo não foi capacitado")
								break
							else
								Valor_Invalido()
							end
						end
					end

					break
				elseif grafoSelec == #grafosLidos + 1 then
					if not(Leitura()) then
						return false
					end
				else
					Valor_Invalido()
					break
				end
			end
		end
	end

	function Ferramentas( )
		local opcao = 0;
		while true do
			print()
			print("Ferramentas:")
			print("1 - Inserir vertice")
			print("2 - Remover vertice")
			print("3 - Inserir aresta")
			print("4 - Remover aresta")
			print("5 - Listar Vizinhos")
			print("6 - Imprime Grafo")
			print("0 - Voltar")
			print()
			print("Digite a opção desejada: ")
			local entrada = io.read("*line")
			print()
			if tonumber(entrada) then
				opcao = tonumber(entrada)
				if opcao == 1 then
					print("Vertice "..grafoSelecionado:AdicionaVertice().." foi adicionado.")

				elseif opcao == 2 then
					print("Insira o vertice a ser removido: ")
					entrada = io.read("*line")
					if tonumber(entrada) then
						local vertRemov = tonumber(entrada)
						if grafoSelecionado:RemoveVertice(tonumber(entrada)) then
							print("Vertice "..vertRemov.." foi removido.")
						else
							print("Vertice invalido!")
						end
					else
						Valor_Invalido()				
					end

				elseif opcao == 3 then
					print("Insira o primeiro vertice da aresta a ser adicionada: ")
					entrada = io.read("*line")
					if tonumber(entrada) then
						local vertA = tonumber(entrada)
						print("Insira o segundo vertice da aresta a ser adicionada: ")
						entrada = io.read("*line")
						if tonumber(entrada) then
							local vertB = tonumber(entrada)
							if grafoSelecionado:AdicionaAresta(vertA, vertB) then
								print("Aresta "..vertA.."-"..vertB.." foi adicionada.")
							else
								print("Vertices invalidos!")
							end
						else
							Valor_Invalido()
						end
					else
						Valor_Invalido()
					end

				elseif opcao == 4 then
					print("Insira o primeiro vertice da aresta a ser removida: ")
					entrada = io.read("*line")
					if tonumber(entrada) then
						local vertA = tonumber(entrada)
						print("Insira o segundo vertice da aresta a ser removida: ")
						entrada = io.read("*line")
						if tonumber(entrada) then
							local vertB = tonumber(entrada)
							if grafoSelecionado:RemoveAresta(vertA, vertB) then
								print("Aresta "..vertA.."-"..vertB.." foi removida.")
							else
								print("Vertices invalidos!")
							end
						else
							Valor_Invalido()
						end
					else
						Valor_Invalido()
					end

				elseif opcao == 5 then
					print("Insira o valor do vertice: ")
					entrada = io.read("*line")
					if tonumber(entrada) then
						grafoSelecionado:ImprimeVizinhosDoVerticie(tonumber(entrada))
					else
						Valor_Invalido()				
					end

				elseif opcao == 6 then
					grafoSelecionado:ImprimeGrafo()
					print()

				elseif opcao == 0 then
					break
				end
			else
				Valor_Invalido()
			end
		end
	end

	function AlgBuscaLargura( ... )
		local opcao = 0;
		while true do
			print()
			print("Algoritmos com Busca em Largura:")
			print("1 - Busca")
			print("2 - Busca Completa")
			print("3 - Verificar Conectividade")
			print("4 - Verificar Ciclo")
			print("5 - Verificar se é floresta")
			print("6 - Verificar se é árvore")
			print("7 - Verificar se é árvore 2")
			print("8 - Floresta Geradora")
			print("9 - Determinar Distancias")
			print("0 - Voltar")
			print()
			print("Digite a opção desejada: ")
			local entrada = io.read("*line")
			print()
			if tonumber(entrada) then
				opcao = tonumber(entrada)
				if opcao == 1 then
					print("Insira o vertice inicial: ")
					entrada = io.read("*line")
					if tonumber(entrada) then
						local vertInicial = tonumber(entrada)
						grafoSelecionado:BuscaUnicaLargura(vertInicial, true)
						local start = os.clock()
						grafoSelecionado:BuscaUnicaLargura(vertInicial, false)
						print("Tempo de execução ".. os.clock() - start)

					else
						Valor_Invalido()
					end
				elseif opcao == 2 then
					grafoSelecionado:BuscaCompletaLargura(true)
					local start = os.clock()
					grafoSelecionado:BuscaCompletaLargura(false)
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 3 then
					local start = os.clock()
					grafoSelecionado:BuscaUnicaLargura(1, false)
					if grafoSelecionado:EhConexo() then
						print("Conexo")
					else
						print("Desconexo")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 4 then
					local start = os.clock()
					grafoSelecionado:BuscaCompletaLargura(false)
					if grafoSelecionado:TemCiclo() then
						print("Tem ciclo")
					else
						print("Não tem ciclo")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 5 then
					local start = os.clock()
					grafoSelecionado:BuscaCompletaLargura(false)
					if grafoSelecionado:TemCiclo() then
						print("Não é floresta")
					else
						print("É floresta")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 6 then
					local start = os.clock()
					grafoSelecionado:BuscaUnicaLargura(1, false)
					if grafoSelecionado:EhArvore() then
						print("É árvore")
					else
						print("Não é árvore")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 7 then
					local start = os.clock()
					grafoSelecionado:BuscaUnicaLargura(1, false)
					if (not(grafoSelecionado:TemCiclo())) then
						grafoSelecionado:BuscaUnicaLargura(1, false)
						if grafoSelecionado:EhConexo() then
							print("É árvore")
						else
							print("Não é árvore")
						end
					else
						print("Não é árvore")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 8 then
					local start = os.clock()
					grafoSelecionado:BuscaCompletaLargura(false)
					grafoSelecionado:ObterFlorestaGeradora()
					local endt = os.clock()
					grafoSelecionado:ImprimeGrafo(grafoSelecionado.floresta)
					print("Tempo de execução ".. endt - start)

				elseif opcao == 9 then
					print("Insira vertice de referencia: ")
					entrada = io.read("*line")
					if tonumber(entrada) then
						local vertRef = tonumber(entrada)
						local start = os.clock()
						if grafoSelecionado:DeterminarDistancias(vertRef, false) then
							local endt = os.clock()
							grafoSelecionado:ImprimeDistancia(vertRef)
							print("Tempo de execução ".. endt - start)
						else
							print("Vertice invalidos!")
						end
					else
						Valor_Invalido()
					end
				elseif opcao == 0 then
					break
				end
			else
				Valor_Invalido()
			end
		end
	end

	function AlgBuscaProfundidade( ... )
		local opcao = 0;
		while true do
			print()
			print("Algoritmos com Busca em Profundidade:")
			print("1 - Busca")
			print("2 - Busca Recursiva")
			print("3 - Busca Completa")
			print("4 - Busca Completa Recursiva")
			print("5 - Verificar Conectividade")
			print("6 - Verificar Ciclo")
			print("7 - Verificar se é floresta")
			print("8 - Verificar se é árvore")
			print("9 - Verificar se é árvore 2")
			print("10 - Floresta Geradora")
			print("0 - Voltar")
			print()
			print("Digite a opção desejada: ")
			local entrada = io.read("*line")
			print()
			if tonumber(entrada) then
				opcao = tonumber(entrada)
				if opcao == 1 then
					print("Insira o vertice inicial: ")
					entrada = io.read("*line")
					if tonumber(entrada) then
						local vertInicial = tonumber(entrada)
						grafoSelecionado:BuscaUnicaProfundidade(vertInicial, true)
						local start = os.clock()
						grafoSelecionado:BuscaUnicaProfundidade(vertInicial, false)
						print("Tempo de execução ".. os.clock() - start)

					else
						Valor_Invalido()
					end
				elseif opcao == 2 then
					print("Insira o vertice inicial: ")
					entrada = io.read("*line")
					if tonumber(entrada) then
						local vertInicial = tonumber(entrada)
						grafoSelecionado:BuscaUnicaProfundidadeRecur(vertInicial, true)
						local start = os.clock()
						grafoSelecionado:BuscaUnicaProfundidadeRecur(vertInicial, false)
						print("Tempo de execução ".. os.clock() - start)

					else
						Valor_Invalido()
					end
				elseif opcao == 3 then
					grafoSelecionado:BuscaCompletaProfundidade(true)
					local start = os.clock()
					grafoSelecionado:BuscaCompletaProfundidade(false)
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 4 then
					grafoSelecionado:BuscaCompletaProfundidadeRecur(true)
					local start = os.clock()
					grafoSelecionado:BuscaCompletaProfundidadeRecur(false)
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 5 then
					local start = os.clock()
					grafoSelecionado:BuscaUnicaProfundidade(1, false)
					if grafoSelecionado:EhConexo() then
						print("Conexo")
					else
						print("Desconexo")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 6 then
					local start = os.clock()
					grafoSelecionado:BuscaCompletaProfundidade(false)
					if grafoSelecionado:TemCiclo() then
						print("Tem ciclo")
					else
						print("Não tem ciclo")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 7 then
					local start = os.clock()
					grafoSelecionado:BuscaCompletaProfundidade(false)
					if grafoSelecionado:TemCiclo() then
						print("Não é floresta")
					else
						print("É floresta")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 8 then
					local start = os.clock()
					grafoSelecionado:BuscaUnicaProfundidade(1, false)
					if grafoSelecionado:EhArvore() then
						print("É árvore")
					else
						print("Não é árvore")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 9 then
					local start = os.clock()
					grafoSelecionado:BuscaUnicaProfundidade(1, false)
					if grafoSelecionado:EhConexo() then
						grafoSelecionado:BuscaUnicaProfundidade(1, false)
						if not(grafoSelecionado:TemCiclo()) then
							print("É árvore")
						else
							print("Não é árvore")
						end
					else
						print("Não é árvore")
					end
					print("Tempo de execução ".. os.clock() - start)

				elseif opcao == 10 then
					local start = os.clock()
					grafoSelecionado:BuscaCompletaProfundidade(false)
					grafoSelecionado:ObterFlorestaGeradora()
					local endt = os.clock()
					grafoSelecionado:ImprimeGrafo(grafoSelecionado.floresta)
					print("Tempo de execução ".. endt - start)

				elseif opcao == 0 then
					break
				end
			else
				Valor_Invalido()
			end
		end
	end

	function Algoritmos ( )
		local opcao = 0;
		while true do
			print()
			print("Algoritmos:")
			print("1 - Utilizando Busca em Largura")
			print("2 - Utilizando Busca em Profundidade")
			print("3 - Fluxo Maximo")
			print("0 - Voltar")
			print()
			print("Digite a opção desejada: ")
			local entrada = io.read("*line")
			print()
			if tonumber(entrada) then
				opcao = tonumber(entrada)
				if opcao == 1 then
					AlgBuscaLargura()
				elseif opcao == 2 then
					AlgBuscaProfundidade()
				elseif opcao == 3 then
					if grafoSelecionado.capacitado == true then
						print("O fluxo máximo é "..grafoSelecionado:FluxoMaximo( ))
					else
						print("O grafo não é um grafo capacitado")
					end
				elseif opcao == 0 then
					break
				end
			else
				Valor_Invalido()
			end
		end
	end

	function Menu_Inicial( )
		local opcao = 0;
		while true do

			print()
			print("Menu Inicial:")
			print("1 - Selecionar Grafo")
			print("2 - Ferramentas")
			print("3 - Algoritmos")
			print("0 - Sair")
			--print("3 - Exportar Grafo")
			print()
			print("Digite a opção desejada: ")
			entrada = io.read("*line")

			if tonumber(entrada) then
				opcao = tonumber(entrada)
				if opcao == 1 then
					Seleciona()
				elseif opcao == 2 then
					if grafoSelecionado then
						Ferramentas()
					else 
						print("\nNenhum grafo selecionado. Selecione um grafo antes de proseguir.")
					end
				elseif opcao == 3 then
					if grafoSelecionado then
						Algoritmos()
					else 
						print("\nNenhum grafo selecionado. Selecione um grafo antes de proseguir.")
					end
				elseif opcao == 0 then
					break
				end
			else
				Valor_Invalido()
			end
		end
	end

print("GRAFOS")
print()
Menu_Inicial()