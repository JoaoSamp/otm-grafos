local json 		= require("json")
local Matriz 	= require("matrizAdj")

function AdcAresta( matriz, vertA, vertB )
	if matriz[vertA] and matriz[vertB] then
		matriz[vertA][vertB] = 1
		matriz[vertB][vertA] = 1
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

file = io.open("grafos.txt", "w")
local grafoObj = nil

grafoObj = GeraGrafo(5, 216589, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(6, 8749163, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(7, 35646, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(8, 215687, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(9, 4651189, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(10, 56589412, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(20, 578413, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

-- grafoObj = GeraGrafo(20, 154278, 'completo')
-- jsGrafo = json.encode(grafoObj)
-- file:write(jsGrafo)
-- file:write("\n")

grafoObj = GeraGrafo(50, 74529, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(100, 784956123, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(200, 15611536, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(500, 9781319, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(1000, 6549894, 'aleatorio')
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")


file:close()