Elm.Native.TileGridEngine = Elm.Native.TileGridEngine || {};
Elm.Native.TileGridEngine.TileGrid = Elm.Native.TileGridEngine.TileGrid || {};
Elm.Native.TileGridEngine.TileGrid.make = function(elm) {

    elm.Native = elm.Native || {};
    elm.Native.TileGridEngine = elm.Native.TileGridEngine || {};
    elm.Native.TileGridEngine.TileGrid = elm.Native.TileGridEngine.TileGrid || {};

    var Array = Elm.Native.Array.make(elm);
    var List = Elm.Native.List.make(elm);

    if (elm.Native.TileGridEngine.TileGrid.values) {
        return elm.Native.TileGridEngine.TileGrid.values;
    };

    var createNode = Elm.Native.Graphics.Element.make(elm).createNode;
    var newElement = Elm.Native.Graphics.Element.make(elm).newElement;

    function grid(dimensions, tileset, data) {
        var tileSize = tileset._0;
        var tiles = tileset._1;
        var w = dimensions._0 * tileSize._0;
        var h = dimensions._1 * tileSize._1;

        function render(model) {
            var canvas = createNode('canvas');
            canvas.style.display = "block";
            canvas.style.position = "absolute";

            model.cache.context = canvas.getContext('2d');
            model.cache.tileset = {};

            loadTiles(List.toArray(tiles), model.cache.tileset, function() {
                draw(model);
            });

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

        function update(canvas, oldModel, model) {
            model.cache = oldModel.cache;

            if (model.w != oldModel.w || model.h != oldModel.h) {
                resize(canvas, model.w, model.h);
            };

            draw(model);

            return canvas;
        };

        function draw(model) {
            var data = Array.toJSArray(model.data);
            for (var y = 0; y < data.length; y++) {
                var row = Array.toJSArray(data[y]);
                for (var x = 0; x < row.length; x++) {
                    var tile = model.cache.tileset[row[x]];
                    if (tile) {
                        model.cache.context.drawImage(
                            tile,
                            x * model.tw,
                            y * model.th
                        );
                    };
                };
            };
        };

        var elem = {
            ctor: 'Custom',
            type: 'TileGrid',
            render: render,
            update: update,
            model: {
                cache: {},
                tiles: tiles,
                w: w,
                h: h,
                tw: tileSize._0,
                th: tileSize._1,
                data: data,
            }
        };

        return A3(newElement, w, h, elem);
    };

    function loadTiles(items, result, callback) {

        var counter = items.length;

        function checkProgress() {
            counter -= 1;
            if (counter == 0) {
                callback();
            };
        };

        for (var idx = 0; idx < items.length; idx++) {
            var item = items[idx];
            var key = item._0;
            var src = item._1;

            var img = new Image();

            img.onload = (function(key, img) {
                return function() {
                    result[key] = img;
                    checkProgress();
                };
            })(key, img);

            img.onerror = (function(src) {
                return function() {
                    console.error(
                        "TileGrid: image \"" + src + "\" wasn't loaded!");
                    checkProgress();
                };
            })(src);

            img.src = src;
        };
    };

    return elm.Native.TileGridEngine.TileGrid.values = {
        grid: F3(grid),
    };
};
