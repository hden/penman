penman
======

JSON to CSV with ease

Installtion
-----------

    npm install penman

Usage
-----

    var app = require('penman');
    var transformer = function (string) {
      return string + '!!';
    }
    app
      .map('column1', 'foo', 'default value')
      .map('column2', 'bar', 'default value', transformer)
      .map('column3', 'baz.deep.path', 'default value');

    target = {
      foo: 'fooValue',
      bar: 'bar',
      baz: {
        deep: {
          path: 'wow'
        }
      }
    };

    var row = app(target);
    row === 'fooValue,bar!!,wow';
