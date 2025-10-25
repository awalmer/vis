import * as Plot from "npm:@observablehq/plot";

export function plotPassportHeatmap(regionData, countryOrder) {
    const heatmap = Plot.plot({
    padding: 0,
    grid: true,
    x: {axis: "top", label: "Year", tickFormat: ""},
    y: {
        label: "Country",  
        domain: countryOrder
    },
    color: {type: "linear", scheme: "PiYG"},
    marks: [
        Plot.cell(regionData, {x: "year", y: "country", fill: "visa_free_count", inset: 0.7}),
        Plot.text(regionData, {x: "year", y: "country", text: (d) => Math.round(d.visa_free_count?.toFixed(1)), fill: "black", title: "title"})
    ],
    marginLeft: 100,
    })
return heatmap
};

