local json 		= require("json")
local Matriz 	= require("matrizAdj")
local Lista		= require("listaAdj")

	grafo = {}
	grafoAdj = nil

	function Valor_Invalido(  )
		print("Valor invalido !")
		print()
	end
	
	function Leitura( )
		local file = nil
		while true do
			print()
			print("Insira o nome do arquivo: ")
			local dir 	= io.read("*line")
			file 		= io.open(dir, "rb")
			print("...")
			if not file then
				print("Diretorio invalido !")
				print("Deseja repetir o processo?")
				print("1 - Sim")
				print("2 - Nao")
				local entrada = io.read("*line")
				if tonumber(entrada) then
					if opcao ~= 1 then
						print("Leitura Abortada.")
						return
					end
				else
					print("Valor invalido ! Leitura Abortada.")
					return
				end
			else
				break
			end
		end
		local jsObj = file:read("*all")
		local grafoJS = json.decode(jsObj)
		grafo.nome 		= grafoJS.nome
		grafo.vertices 	= grafoJS.vertices
		grafo.arestas 	= grafoJS.arestas
		file:close()
		local opcao = 0
		print("Arquivo lido com sucesso!")
		print()
		while opcao ~= 1 or opcao ~= 2 do
			print("Selecione o tipo de armazenamento:")
			print("1 - Matriz Adj")
			print("2 - Lista Adj")
			local entrada = io.read("*line")
			if tonumber(entrada) then
				opcao = tonumber(entrada)
				if opcao == 1 then
					grafoAdj = Matriz:new(grafo)
					break
				elseif opcao == 2 then
					grafoAdj = Lista:new(grafo)
					break
				else
					Valor_Invalido()
				end
			end
		end
		print()
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
			print("7 - Voltar")
			print()
			print("Digite a opção desejada: ")
			local entrada = io.read("*line")
			print()
			if tonumber(entrada) then
				opcao = tonumber(entrada)
				if opcao == 1 then
					grafoAdj:AdicionaVertice()

				elseif opcao == 2 then
					print("Insira o vertice a ser removido: ")
					entrada = io.read("*line")
					if tonumber(entrada) then
						grafoAdj:RemoveVertice(tonumber(entrada))
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
							grafoAdj:AdicionaAresta(vertA, tonumber(entrada))
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
							grafoAdj:RemoveAresta(vertA, tonumber(entrada))
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
						grafoAdj:ImprimeVizinhosDoVerticie(tonumber(entrada))
					else
						Valor_Invalido()				
					end

				elseif opcao == 6 then
					grafoAdj:ImprimeGrafo()
					print()

				elseif opcao == 7 then
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
			print("1 - Ler Grafo")
			print("2 - Ferramentas")
			print("3 - Sair")
			--print("3 - Exportar Grafo")
			print()
			print("Digite a opção desejada: ")
			entrada = io.read("*line")

			if tonumber(entrada) then
				opcao = tonumber(entrada)
				if opcao == 1 then
					Leitura()
				elseif opcao == 2 then
					Ferramentas()
				elseif opcao == 3 then
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