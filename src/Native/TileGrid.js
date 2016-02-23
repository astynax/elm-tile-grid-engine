Elm.Native.WebGL = Elm.Native.WebGL || {};
Elm.Native.WebGL.make = function(elm) {

    elm.Native = elm.Native || {};
    elm.Native.TileGrid = elm.Native.TileGrid || {};

    if (elm.Native.TileGrid.values) {
        return elm.Native.TileGrid.values;
    };

    var createNode = Elm.Native.Graphics.Element.make(elm).createNode;
    var newElement = Elm.Native.Graphics.Element.make(elm).newElement;

    function grid(dimensions, tileset, signal) {
        var w = dimensions._0;
        var h = dimensions._1;

        function render(model) {
            var canvas = createNode('canvas');

            canvas.style.display = "block";
            canvas.style.position = "absolute";

            model.cache.context = canvas.getContext('2d');

            resize(canvas, model.w, model.h);
            update(canvas, model, model);

            return canvas;
        };

        function resize(canvas, w, h) {
            canvas.style.width = w + 'px';
            canvas.style.height = h + 'px';
            canvas.width = w;
            canvas.height = h;
        };

        function update(canvas, oldModel, newModel) {
            newModel.cache = oldModel.cache;

            if (newModel.w != oldModel.w || newModel.h != oldModel.h) {
                resize(canvas, newModel.w, newModel.h);
            };

            // TODO: subscribing

            return canvas;
        }

        var elem = {
            ctor: 'Custom',
            type: 'TileGrid',
            render: render,
            update: update,
            model: {
                cache: {},
                tileset: tileset,
                signal: signal,
                w: w,
                h: h
            }
        };

        return A3(newElement, w, h, elem);
    }

    function loadTiles(items) {
        return Task.asyncFunction(function(callback) {
            var tileset = {};
            var errors = [];
            var counter = items.length;

            function checkCompletion() {
                if (counter == 0) {
                    if (errors.length == 0) {
                        return callback(Task.success(tileset));
                    } else {
                        return callback(Task.fail(
                            "Failed to load image(s): " + errors.toString()
                        ));
                    };
                };
            };

            for (var idx = 0; idx < items.length; idx++) {
                var item = items[idx];
                var key = item._0;
                var src = item._1;

                var img = new Image();

                img.onload = function() {
                    tileset[key] = img;
                    return checkCompletion();
                };

                img.onerror = function() {
                    errors.push(src);
                    return checkCompletion();
                };

                img.src = src;
            };
        });
    };

    return elm.Native.TileGrid.values = {
        grid: F3(grid),
        loadTiles: loadTiles
    };
};
