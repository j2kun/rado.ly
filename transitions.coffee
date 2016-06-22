# Defining a function
polygon = (sides, size, radius, center) ->
    circle = 2 * Math.PI
    angle = circle / sides
    points = []

    for i in [0..sides-1]
        x = (Math.cos(angle * i) * size) + center[0]
        y = (Math.sin(angle * i) * size) + center[1]
        points[i] = {"x": x, "y": y, "r": radius}

    return points

polyData = polygon(6, 120, 20, [200,200])

svg1 = d3.select("#color-size")
    .append("svg")
    .attr("width", 400)
    .attr("height", 400)

circles = svg1.selectAll("circle")
    .data(polyData)
    .enter()
    .append("circle")
    .style("fill", "gray")
    .style("stroke", "none")
    .style("stroke-width", 2)

circleAttributes = circles
    .attr("cx",  (d) -> (d.x))
    .attr("cy",  (d) -> (d.y))
    .attr("r",  (d) -> (d.r))

circlesActions = circles
    .transition()
    .delay(1000)
    .duration(2000)
    .style("fill", "lightblue")
    .attr("r", (d) -> (d.r * 3))



svg2 = d3.select("#color-size-click")
    .append("svg")
    .attr("width", 400)
    .attr("height", 400)

circles = svg2.selectAll("circle")
    .data(polyData)
    .enter()
    .append("circle")
    .style("fill", "gray")
    .style("stroke", "none")
    .style("stroke-width", 2)

circleAttributes = circles
    .attr("cx",  (d) -> (d.x))
    .attr("cy",  (d) -> (d.y))
    .attr("r",  (d) -> (d.r))

circleActions = circleAttributes
    .on("mouseover", () -> (d3.select(this).transition().duration(500).style("fill", "red")))
    .on("mouseout", () -> (d3.select(this).transition().duration(500).style("fill", "gray")))
    .on("mousedown", () -> (d3.select(this).
        transition().
        duration(500).
        style("fill", "lightblue").
        attr("r", (d) -> (d.r * 3))))


svg3 = d3.select("#color-size-click-shrink")
    .append("svg")
    .attr("width", 400)
    .attr("height", 400)

circles = svg3.selectAll("circle")
    .data(polyData)
    .enter()
    .append("circle")
    .style("fill", "gray")
    .style("stroke", "none")
    .style("stroke-width", 2)

circleAttributes = circles
    .attr("cx",  (d) -> (d.x))
    .attr("cy",  (d) -> (d.y))
    .attr("r",  (d) -> (d.r))

circleActions = circleAttributes
    .on("click", () -> 
        d3.select(this)
        .transition()
        .duration(500)
        .style("fill", "lightblue")
        .attr("r", (d) -> (d.r * 3))
        .each("end", () -> 
            d3.select(this)
            .transition()
            .duration(500)
            .style("fill", "gray")
            .attr("r", (d) -> (d.r * 1))))



svg4 = d3.select("#color-size-click-transform")
    .append("svg")
    .attr("width", 400)
    .attr("height", 400)

circles = svg4.selectAll("circle")
    .data(polyData)
    .enter()
    .append("circle")
    .style("fill", "gray")
    .style("stroke", "none")
    .style("stroke-width", 2)

circleAttributes = circles
    .attr("cx",  (d) -> (d.x))
    .attr("cy",  (d) -> (d.y))
    .attr("r",  (d) -> (d.r))

circleActions = circleAttributes
    .on("click", () -> 
        d3.select(this)
        .transition()
        .duration(500)
        .attr("transform", (d) -> "translate(100,100)")
        .attr("r", (d) -> (d.r * 3))
        .style("fill", "lightblue")
        .each("end", () -> 
            d3.select(this)
            .transition()
            .duration(300)
            .style("fill", "gray")
            .attr("r", (d) -> (d.r * 1))
            .attr("transform", (d) -> "translate(0,0)")
            .attr("r", (d) -> (d.r * 1))))

