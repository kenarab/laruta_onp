'use strict';

angular.module('onpApp')
    .controller('MainCtrl', function ($scope) {

        $scope.setYear = function(year) {
            $scope.year = year;
            $scope.data = $scope.alldata.filter(function(d) {
                return parseInt(d.anio) == year;
            })
        }

        $scope.init = function() {
            // Parse and process data
            d3.csv('data/onp-presupuesto_indicadores.csv', function(data) {
                $scope.alldata = data;
                $scope.setYear(2013);
                $scope.$apply()
            })
        }

        $scope.$watch('year', function(y) {
            if (parseInt(y) > 2002 && parseInt(y) < 2015) {
                $scope.setYear(y);
            }
        })
    });
