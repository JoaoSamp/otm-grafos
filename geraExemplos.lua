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

function GeraGrafo( n, seed )
	math.randomseed(seed)
	local max_m = math.floor((n * (n -1))/2)
	local m = math.random(max_m)
	local grafo = {}
	grafo.nome = "Grafo com "..n
	grafo.vertices 	= {}
	grafo.arestas 	= {}

	for i = 1, n do
		table.insert(grafo.vertices, i)
	end

	local grafoMatAdj = Matriz:new(grafo)

	local arestas_criadas = 0

	while (arestas_criadas < m) do
		for i = 1, n do
			for l = i+1, n do
				if math.random(2) == 2 then
					if AdcAresta(grafoMatAdj.matriz, i, l) then
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
local grafoObj = GeraGrafo(5, 14234)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(6, 423534)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(7, 645687)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(8, 345342)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(9, 97534)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(10, 879453)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(20, 7745)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(50, 974)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(100, 21387)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(200, 312457)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(500, 14654)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")

grafoObj = GeraGrafo(1000, 2677)
jsGrafo = json.encode(grafoObj)
file:write(jsGrafo)
file:write("\n")


file:close()