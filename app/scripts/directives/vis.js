'use strict';

angular.module('onpApp')
    .directive('vis', function () {

        var margin = { top: 0, right: 0, bottom: 0, left: 0 },
            width = 730 - margin.left - margin.right,
            height = 730 - margin.top - margin.bottom;

        // Force layout
        var nodes = [],
            links = [],
            force = d3.layout.force()
                .nodes(nodes)
                .size([width, height])
                .gravity(.02)
                .charge(0)

        // Radius scale
        var radius = d3.scale.log()
            .range([20, 100])

        return {
            restrict: 'E',
            scope: {
                data: '='
            },
            link: function postLink(scope, element, attrs) {
                var svg = d3.select($(element)[0]).append("svg")
                    .attr("width", width)
                    .attr("height", height)
                    .append("g")
                    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

                scope.$watch('data', function(data) {
                    if (!data) return;
                });
            }
        };
    });
