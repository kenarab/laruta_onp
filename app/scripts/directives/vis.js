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
            default_gravity = 0.1,
            damper = 0.1,
            bounding_radius = null

        var positions = [
            { "name": "Cancillería", "department": { "x":225, "y":476 } },
            { "name": "Ciencia", "department": { "x":225, "y":476 } },
            { "name": "Defensa", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
            { "name": "", "department": { "x":225, "y":476 } },
        ]

        function find_position(name) {
            var pos = positions.filter(function (pos) {
                return pos.name == name
            });
            console.log(pos);        //TODO(gb): Remove trace!!!
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
//                        .each(total_sort(e.alpha))
//                        .each(buoyancy(e.alpha))
//                        .each(static_department(e.alpha))
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

        function total_sort(alpha) {
            var that = this;
            return function(d) {
                var targetY = height/2;
                var targetX = width/2;

                if (d.isNegative) {
                    if (d.changeCategory > 0) {
                        d.x = - 200
                    } else {
                        d.x =  1100
                    }
                }

                d.y = d.y + (targetY - d.y) * (default_gravity + 0.02) * alpha
                d.x = d.x + (targetX - d.x) * (default_gravity + 0.02) * alpha

            };
        }

        function buoyancy(alpha) {
            return function(d) {
                var targetY = height/2 - (d.changeCategory / 3) * bounding_radius
                d.y = d.y + (targetY - d.y) * (default_gravity) * alpha * alpha * alpha * 100
            };
        }

        function static_department(alpha) {
            return function(d){
                var targetY = 0;
                var targetX = 0;

                if (d.positions.department) {
                    targetX = d.positions.department.x;
                    targetY = d.positions.department.y;
                };

                d.y += (targetY - d.y) * Math.sin(Math.PI * (1 - alpha*10)) * 0.6
                d.x += (targetX - d.x) * Math.sin(Math.PI * (1 - alpha*10)) * 0.4
            };
        }

        // SVG
        var svg,
            circles;

        /* Initialize tooltip */
        var tip = d3.tip().attr('class', 'd3-tip').html(function(d) { return d; });

        /* Invoke the tip in the context of your visualization */
        svg.call(tip);

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

        var color = d3.scale.ordinal()
            .domain([-3, -3])
            .range(["#d84b2a", "#7aa25c"]);

        return {
            restrict: 'E',
            scope: {
                data: '='
            },
            link: function postLink(scope, element, attrs) {
                svg = d3.select($(element)[0]).append("svg")
                    .attr("width", width)
                    .attr("height", height)
                    .append("g")
                    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")


                scope.$watch('data', function(data) {
                    if (!data) return;

                    var node_data = data.filter(function(d) {
                        return d['categoria'] != "TOTAL" && d['type'] == "EJEC";
                    })

                    var total = data.filter(function(d) {
                        return d['categoria'] == "TOTAL" && d['type'] == "EJEC";
                    })

                    radius.domain([0, d3.max(node_data, function(d) { return parseInt(d['value'], 10); } )]);

                    nodes = []
                    for (var i=0; i<node_data.length; i++) {
                        nodes.push({
                            index: i,
                            sid: node_data[i]['id'],
                            radius: radius(parseInt(node_data[i]['value'], 10)),
                            value: node_data[i]['value'],
                            year: scope.year,
                            x: Math.random() * 900,
                            y: Math.random() * 800,
                            category: node_data[i]['categoria'],
                            jurisdiction: node_data[i]['juris_abrev'],
                            changeCategory: Math.floor((Math.random()*7) - 3),
                            positions: find_position(node_data[i]['juris_abrev'])
                        })
                    }
                    console.log(nodes);        //TODO(gb): Remove trace!!!
                    nodes.sort(function(a, b){
                        return Math.abs(b.value) - Math.abs(a.value);
                    });

                    bounding_radius = radius(total.value);
                    console.log(nodes);        //TODO(gb): Remove trace!!!
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

                    display_group_all();
                });
            }
        };
    });
