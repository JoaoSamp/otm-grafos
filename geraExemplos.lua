local json 		= require("json")
local Matriz 	= require("matrizAdj")

function AdcAresta( matriz, vertA, vertB )
	if matriz[vertA] and matriz[vertB] and matriz[vertA][vertB] == 0 then
		matriz[vertA][vertB] = 1
		matriz[vertB][vertA] = 1
		return true
	else
		return false
	end
end

function AdcArestaDir( matriz, vertA, vertB, capacidade )
	if matriz[vertA] and matriz[vertB] and matriz[vertA][vertB] == 0 and matriz[vertB][vertA] == 0 then
		matriz[vertA][vertB] = capacidade
		return true
	else
		return false
	end
end

function ArestasAleatorias( grafo, n )

	local max_m = math.floor((n * (n -1))/2)
	local m = math.random(math.floor(max_m/2), max_m)

	local arestas_criadas = 0

	while (arestas_criadas < m) do
		for i = 1, n do
			for l = i+1, n do
				if math.random(1000) % 7 == 0 then
					if AdcAresta(grafo.matriz, i, l) then
						arestas_criadas = arestas_criadas + 1
						if arestas_criadas == m then
							break
						end
					end
				end
			end
			if arestas_criadas == m then
				break
			end
		end
	end
end

function KCompleto( grafo, n )

	local max_m = math.floor((n * (n -1))/2)
	local m = math.random(math.floor(max_m/2), max_m)

	local arestas_criadas = 0

	for i = 1, n do
		for l = i+1, n do
			AdcAresta(grafo.matriz, i, l)
		end
	end
end

function GeraGrafo( n, seed, tipo )
	math.randomseed(seed)
	local grafo = {}
	grafo.nome = "Grafo com "..n
	grafo.vertices 	= {}
	grafo.arestas 	= {}

	for i = 1, n do
		table.insert(grafo.vertices, i)
	end

	local grafoMatAdj = Matriz:novo(grafo.nome, n)

	if tipo == 'completo' then
		KCompleto(grafoMatAdj, n)
	else
		ArestasAleatorias(grafoMatAdj, n)
	end

	for i = 1, n do
		for l = i+1, n do
			if grafoMatAdj.matriz[i][l] == 1 then
				table.insert(grafo.arestas, {i, l})
			end
		end
	end

	return grafo
end

function IsIn( tabela, valor )
	for i, v in ipairs(tabela) do
		if v == valor then
			return true
		end
	end
	return false
end

function GeraGrafoCapacitado( n, seed )
	math.randomseed(seed)
	local grafo = {}
	grafo.nome = "Grafo com "..n
	grafo.vertices 	= {}
	grafo.arestas 	= {}

	for i = 1, n do
		table.insert(grafo.vertices, i)
	end

	grafo.inicio = math.random(n)
	local fim = math.random(n)
	while fim == grafo.inicio do
		fim = math.random(n)
	end
	grafo.fim = fim

	local grafoMatAdj = Matriz:novo(grafo.nome, n)

	local qtd_caminhos = math.floor(n/5) * 2
	for i = 1, qtd_caminhos do
		local qtd_vertices = n - qtd_caminhos
		local caminho = {}
		table.insert(caminho, grafo.inicio)
		for l = 1, qtd_vertices - 2 do
			local novo_vertice = 0
			local tentativa = 0
			while (novo_vertice == 0) or (novo_vertice == grafo.inicio )
				or ( novo_vertice == grafo.fim ) or ( IsIn( caminho, novo_vertice)) do
				novo_vertice = math.random(n)
				if tentativa < 10  then
					if n > 10 then
						if grafoMatAdj.matriz[grafo.inicio][novo_vertice] > 0 
							or grafoMatAdj.matriz[novo_vertice][grafo.fim] > 0 then
							novo_vertice = 0 
						end
					end
					if #caminho > 0 and novo_vertice > 0 then
						if grafoMatAdj.matriz[caminho[#caminho]][novo_vertice] > 0 then
							novo_vertice = 0
						end
					end
					tentativa = tentativa + 1
				else
					tentativa = 0
				end
			end
			table.insert(caminho, novo_vertice)
		end
		table.insert(caminho, grafo.fim)
		for l = 2, (#caminho) do
			local capacidade = math.random(12) + 3
			AdcArestaDir( grafoMatAdj.matriz, caminho[l-1], caminho[l], capacidade )
		end
	end

	for i = 1, n do
		for l = 1, n do
			if grafoMatAdj.matriz[i][l] > 1 then
				table.insert(grafo.arestas, {i, l, grafoMatAdj.matriz[i][l] })
			end
		end
	end

	return grafo
end


file = io.open("grafos.txt", "w")
local grafoObj = nil

-- grafoObj = GeraGrafo(5, 216589, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(6, 8749163, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(7, 35646, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(8, 215687, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(9, 4651189, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(10, 56589412, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(20, 578413, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(20, 154278, 'completo')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(50, 74529, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(100, 784956123, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(200, 15611536, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(500, 9781319, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

-- grafoObj = GeraGrafo(1000, 6549894, 'aleatorio')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

grafoObj = GeraGrafoCapacitado(5, 3197856, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafoCapacitado(6, 798923, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafoCapacitado(7, 323189, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafoCapacitado(10, 5594169, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafoCapacitado(15, 8516885, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafoCapacitado(20, 12558965, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafoCapacitado(50, 1156786, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafoCapacitado(100, 55868965, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

file:close()