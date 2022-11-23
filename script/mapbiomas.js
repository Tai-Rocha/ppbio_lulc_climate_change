/**
 * @description
 *    Calculates area by class id and year
 * 
 * @author
 *    João Siqueira, Modified by Tainá Rocha
 * 
 */

// Asset mapbiomas
var asset = "projects/mapbiomas-workspace/public/collection7/mapbiomas_collection70_integration_v2";

// Asset of regions for which you want to calculate statistics
var assetTerritories = "users/taina013/Grids_Plots_Modules_PPBio_Buffered";

// Numeric attribute to index the shapefile
var attribute = "id";

// A list of class ids you are interested
var classIds = [
    3, // Formação Florestal
    4, // Formação Savânica
    5, // Mangue
    49, // Restinga Florestal
    11, // Área Úmida Natural não Florestal
    12, // Formação Campestre
    32, // Apicum
    29, // Afloramento Rochoso
    50, // Restinga Herbácea
    13, // Outra Formação não Florestal
    18, // Agricultura
    19, // Lavoura Temporária
    39, // Soja
    20, // Cana
    40, // Arroz
    62, // Algodão
    41, // Outras Lavouras Temporárias
    46, // Café
    47, // Citrus
    48, // Outras Lavaouras Perenes
    9, // Silvicultura
    15, // Pastagem
    21, // Mosaico de Agricultura ou Pastagem
    22, // Área não Vegetada
    23, // Praia e Duna
    24, // Infraestrutura Urbana
    30, // Mineração
    25, // Outra Área não Vegetada,
    26, // Water
    27, // Non observed
    33, // Rio, Lago e Oceano
    31 // 'Aquicultura
];

// Output csv name
var outputName = 'areas';

// Change the scale if you need.
var scale = 30;

// Define a list of years to export
var years = [
'2000', '2010','2020', '2021'
];

// Define a Google Drive output folder 
var driverFolder = 'AREA-EXPORT';

/**
 * 
 */
// Territory
var territory = ee.FeatureCollection(assetTerritories);

// LULC mapbiomas image
var mapbiomas = ee.Image(asset).selfMask();

// Image area in km2
var pixelArea = ee.Image.pixelArea().divide(1000000);

// Geometry to export
var geometry = mapbiomas.geometry();

/**
 * Convert a complex ob to feature collection
 * @param obj 
 */
var convert2table = function (obj) {

    obj = ee.Dictionary(obj);

    var territory = obj.get('territory');

    var classesAndAreas = ee.List(obj.get('groups'));

    var tableRows = classesAndAreas.map(
        function (classAndArea) {
            classAndArea = ee.Dictionary(classAndArea);

            var classId = classAndArea.get('class');
            var area = classAndArea.get('sum');

            var tableColumns = ee.Feature(null)
                .set(attribute, territory)
                .set('class', classId)
                .set('area', area);

            return tableColumns;
        }
    );

    return ee.FeatureCollection(ee.List(tableRows));
};

/**
 * Calculate area crossing a cover map (deforestation, mapbiomas)
 * and a region map (states, biomes, municipalites)
 * @param image 
 * @param territory 
 * @param geometry
 */
var calculateArea = function (image, territory, geometry) {

    var reducer = ee.Reducer.sum().group(1, 'class').group(1, 'territory');

    var territotiesData = pixelArea.addBands(territory).addBands(image)
        .reduceRegion({
            reducer: reducer,
            geometry: geometry,
            scale: scale,
            maxPixels: 1e12
        });

    territotiesData = ee.List(territotiesData.get('groups'));

    var areas = territotiesData.map(convert2table);

    areas = ee.FeatureCollection(areas).flatten();

    return areas;
};

var areas = years.map(
    function (year) {
        var image = mapbiomas.select('classification_' + year);

        var areas = territory.map(
            function (feature) {
                return calculateArea(
                    image.remap(classIds, classIds, 0),
                    ee.Image().int64().paint({
                        'featureCollection': ee.FeatureCollection(feature),
                        'color': attribute
                    }),
                    feature.geometry()
                );
            }
        );

        areas = areas.flatten();

        // set additional properties
        areas = areas.map(
            function (feature) {
                return feature.set('year', year);
            }
        );

        return areas;
    }
);

areas = ee.FeatureCollection(areas).flatten();

Map.addLayer(territory);

Export.table.toDrive({
    collection: areas,
    description: outputName,
    folder: driverFolder,
    fileNamePrefix: outputName,
    fileFormat: 'CSV'
});
