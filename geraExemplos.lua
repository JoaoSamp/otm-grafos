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
	if (vertA ~= vertB) and matriz[vertA] and matriz[vertB] and matriz[vertA][vertB] == 0 and matriz[vertB][vertA] == 0 then
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

function GeraGrafoCapacitado( n, seed )
	math.randomseed(seed)
	local grafo = {}
	grafo.nome = "Grafo com "..n
	grafo.vertices 	= {}
	grafo.arestas 	= {}

	for i = 1, n do
		table.insert(grafo.vertices, i)
	end

	grafo.inicio = 1
	grafo.fim = n

	local grafoMatAdj = Matriz:novo(grafo.nome, n)
	local vert_por_nivel = 0
	if n < 10  then
		vert_por_nivel = 2
	elseif n < 30 then
		vert_por_nivel = 3
	elseif n < 100 then 
		vert_por_nivel = 4
	else
		vert_por_nivel = 5
	end
	local niveis 		= {}
	table.insert(niveis, {grafo.inicio})
	local qtd_niveis 	= 1
	local vertices 	= n - 1
	local vertice 	= 2
	while vertices > 1 do
		local vert_no_nivel = 0
		if vertices - vert_por_nivel >= (vert_por_nivel * 2) then
			vert_no_nivel = vert_por_nivel
		else
			vert_no_nivel = vertices - 1
		end
		table.insert(niveis, {})
		for i = 1, vert_no_nivel do
			table.insert(niveis[#niveis], vertice)
			vertice = vertice + 1
		end
		vertices = vertices - vert_no_nivel
		qtd_niveis = qtd_niveis + 1
	end
	table.insert(niveis, {grafo.fim})
	for i = 1, #niveis - 1 do
		for l = 1, #niveis[i] do
			for k = 1, #niveis[i+1] do
				local capacidade = math.random(15) + 5
				AdcArestaDir(grafoMatAdj.matriz, niveis[i][l], niveis[i + 1][k], capacidade)
			end
		end
	end
	for i = 1, #niveis do
		for l = 1, #niveis[i] do
			for k = 1, #niveis[i] do
				if math.random(1000) % 5 == 0 then
					local capacidade = math.random(5) + 3
					AdcArestaDir(grafoMatAdj.matriz, niveis[i][l], niveis[i][k], capacidade)
				end
			end
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

grafoObj = GeraGrafoCapacitado(8, 79659, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafoCapacitado(9, 9971239, 'aleatorio')
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

grafoObj = GeraGrafoCapacitado(1000, 8941698, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

file:close()