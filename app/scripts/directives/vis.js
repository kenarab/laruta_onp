'use strict';

angular.module('onpApp')
    .directive('vis', function () {

        var margin = { top: 0, right: 0, bottom: 0, left: 0 },
            width = 730 - margin.left - margin.right,
            height = 730 - margin.top - margin.bottom,
            center = { x: width / 2, y: height / 2}


        // Force layout
        var nodes = [],
            force = d3.layout.force()
                .nodes(nodes)
                .size([width, height]),
            layout_gravity = -0.01,
            damper = 0.1,
            bounding_radius = null

        var positions = [
            { "name": "Básico", "department": { "x":200, "y":200 }, "title": { "x":-40, "y":-170 } },
            { "name": "Productivo", "department": { "x":400, "y":200 }, "title": { "x":30, "y":-170 } },
            { "name": "Interior", "department": { "x":600, "y":200 }, "title": { "x":60, "y":-170 } },
            { "name": "Ejecutivo", "department": { "x":200, "y":400 }, "title": { "x":-40, "y":-50 } },
            { "name": "Exterior", "department": { "x":350, "y":400 }, "title": { "x":-20, "y":-50 } },
            { "name": "Financiero", "department": { "x":450, "y":400 }, "title": { "x":20, "y":-50 } },
            { "name": "Institucional", "department": { "x":600, "y":400 }, "title": { "x":60, "y":-50 } }
        ]

        function find_position(name) {
            var pos = positions.filter(function (pos) {
                return pos.name == name
            });
            return pos.length>0 ? pos[0] : { "name": "Other", "department": { "x":0, "y":0 } }
        }

        function charge(d) {
            return -Math.pow(d.radius, 2.0) / 8;
        }

        function display_group_all() {
            force.gravity(layout_gravity)
                .nodes(nodes)
                .charge(charge)
                .friction(0.9)
                .on("tick", function(e) {
                    circles
                        .each(move_towards_center(e.alpha))
                        .attr("cx", function(d) {return d.x;})
                        .attr("cy", function(d) {return d.y;})
                        .on('mouseover', tip.show)
                        .on('mouseout', tip.hide);
                });
            force.start();
        }

        function display_group_category() {
            force.gravity(layout_gravity)
                .nodes(nodes)
                .charge(charge)
                .friction(0.9)
                .on("tick", function(e) {
                    circles
                        .each(static_category(e.alpha))
                        .attr("cx", function(d) {return d.x;})
                        .attr("cy", function(d) {return d.y;});
                });
            force.start();
        }

        function move_towards_center(alpha) {
            return function(d) {
                d.x = d.x + (center.x - d.x) * (damper + 0.02) * alpha;
                d.y = d.y + (center.y - d.y) * (damper + 0.02) * alpha;
            };
        }

        function static_category(alpha) {
            return function(d){
                var targetX = d.positions.department.x;
                var targetY = d.positions.department.y;

                d.x = d.x + (targetX - d.x) * (damper + 0.02) * alpha;
                d.y = d.y + (targetY - d.y) * (damper + 0.02) * alpha;
            };
        }

        // SVG
        var svg,
            circles;

        /* Initialize tooltip */
        var tip = d3.tip().attr('class', 'd3-tip').html(function(d) { 
            return '<span>Categoria: ' + d.category + '</span><br><span>Jurisdicción: '+ d.jurisdiction +'</span></span><br><span>Presupuesto Ejecutado: '+ d.presupuesto_ejec +'</span></span><br><span>Presupuesto Proyectado: '+ millones(d.value_proy);
        });

        var millones = d3.format("0,000");

        // Radius scale
        var radius = d3.scale.pow()
            .exponent(0.5)
            .domain([0,1000000000])
            .range([1,90])

        var fillColor = d3.scale.ordinal()
                .domain([-3,-2,-1,0,1,2,3])
                .range(["#d84b2a", "#ee9586","#e4b7b2","#AAA","#beccae", "#9caf84", "#7aa25c"]),
            strokeColor = d3.scale.ordinal()
                .domain([-3,-2,-1,0,1,2,3])
                .range(["#c72d0a", "#e67761","#d9a097","#999","#a7bb8f", "#7e965d", "#5a8731"])

        var changeCategory = d3.scale.ordinal()
            .domain([0.5, 1.5])
            .range([-3,-2,-1,0,1,2,3])

        return {
            restrict: 'E',
            scope: {
                data: '=',
                layout: '=',
                dataloaded: '='
            },
            link: function postLink(scope, element, attrs) {
                svg = d3.select($(element)[0]).append("svg")
                    .attr("width", width)
                    .attr("height", height)
                    .append("g")
                    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
                    .call(tip);

                svg.selectAll(".category-labels")
                    .data(positions)
                    .enter().append("text")
                    .attr("class", "category-labels")
                    .style("opacity", 0)
                    .attr("x", function(d) { return d.department.x + d.title.x })
                    .attr("y", function(d) { return d.department.y + d.title.y })
                    .attr("text-anchor", "middle")
                    .text(function(d) { return d.name; })


                scope.$watch('layout', function(newValue, oldValue) {
                    if (newValue) {
                        if (newValue == "jurisdiction") {
                            display_group_category()
                            svg.selectAll(".category-labels")
                                .transition()
                                .duration(2000)
                                .style("opacity", 1)
                        } else {
                            display_group_all()
                            svg.selectAll(".category-labels")
                                .transition()
                                .duration(200)
                                .style("opacity", 0)
                        }
                    }
                })

                scope.$watch('data', function(data) {
                    if (!data) return;

                    var node_data = data.filter(function(d) {
                        return d['categoria'] != "TOTAL";
                    })

                    var total = data.filter(function(d) {
                        return d['categoria'] == "TOTAL";
                    })

                    radius.domain([0, d3.max(node_data, function(d) { return parseInt(d['value_exec'], 10); } )]);

                    nodes = []
                    for (var i=0; i<node_data.length; i++) {
                        nodes.push({
                            index: i,
                            sid: node_data[i]['id'],
                            radius: radius(parseInt(node_data[i]['value_exec'], 10)),
                            value: parseInt(node_data[i]['value_exec'], 10),
                            value_proy: parseInt(node_data[i]['value_proy'], 10),
                            presupuesto_ejec: millones(parseInt(node_data[i]['value_exec'], 10)),
                            year: scope.year,
                            x: Math.random() * 900,
                            y: Math.random() * 800,
                            category: node_data[i]['categoria'],
                            jurisdiction: node_data[i]['juris_abrev'],
                            changeCategory: changeCategory(node_data[i]['value_exec']/node_data[i]['value_proy']),
                            positions: find_position(node_data[i]['categoria'])
                        })
                    }
                    nodes.sort(function(a, b){
                        return Math.abs(b.value) - Math.abs(a.value);
                    });

                    bounding_radius = radius(total.value);
                    // Circles
                    circles = svg.selectAll('circles')
                        .data(nodes)

                    circles.enter().append('circle')
                        .attr('r', 0)
                        .attr('id', function(d) { return d.id })
                        .style('fill', function(d, i) { return fillColor(d.changeCategory) })
                        .style("stroke-width", 1)
                        .style('stroke', function(d, i) { return strokeColor(d.changeCategory) })

                    circles.transition()
                        .duration(2000)
                        .attr("r", function(d) { return d.radius })

                    circles.exit().remove()

                    scope.layout = "all";
                    display_group_all();
                });
            }
        };
    });
