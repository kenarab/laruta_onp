'use strict';

angular.module('onpApp')
  .directive('vis', function () {
    return {
      template: '<div></div>',
      restrict: 'E',
      link: function postLink(scope, element, attrs) {
        element.text('this is the vis directive');
      }
    };
  });
