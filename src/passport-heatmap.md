---
title: Henley Passport Index
theme: near-midnight
toc: false
pager: false
sidebar: true
footer: false
header: "Heatmap with D3.js Observable Plot"
---

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

```js
import * as Plot from "npm:@observablehq/plot";
import {BumpChart} from "./components/BumpChart.js";
// Import inputs so that I can add a selector for the heatmaps
import * as Inputs from "npm:@observablehq/inputs";
```

```js
const asia_data = await FileAttachment("data/asia-passport.json").json();
// Convert visa_free_count to integer:
asia_data.visa_free_count = Math.round(asia_data.visa_free_count)
// Create a data order by how the countries are ordered the JSON
const asiaCountryOrder = asia_data.map(d => d.country);
```

```js
const europe_data = await FileAttachment("data/europe-passport.json").json();
// Convert visa_free_count to integer:
europe_data.visa_free_count = Math.round(europe_data.visa_free_count)
// Create a data order by how the countries are ordered the JSON
const europeCountryOrder = europe_data.map(d => d.country);
```

```js
const africa_data = await FileAttachment("data/africa-passport.json").json();
africa_data.visa_free_count = Math.round(africa_data.visa_free_count)
const africaCountryOrder = africa_data.map(d => d.country);
```



```js
const asia_heatmap = Plot.plot({
    padding: 0,
    grid: true,
    x: {axis: "top", label: "Year", tickFormat: ""},
    y: {
        label: "Country",
        domain: asiaCountryOrder
    },
    color: {type: "linear", scheme: "PiYG"},
    marks: [
        Plot.cell(asia_data, {x: "year", y: "country", fill: "visa_free_count", inset: 0.7}),
        Plot.text(asia_data, {x: "year", y: "country", text: (d) => Math.round(d.visa_free_count?.toFixed(1)), fill: "black", title: "title"})
    ],
    marginLeft: 100,
});
```

```js
const europe_heatmap = Plot.plot({
    padding: 0,
    grid: true,
    x: {axis: "top", label: "Year", tickFormat: ""},
    y: {
        label: "Country",
        domain: europeCountryOrder
    },
    color: {type: "linear", scheme: "PiYG"},
    marks: [
        Plot.cell(europe_data, {x: "year", y: "country", fill: "visa_free_count", inset: 0.7}),
        Plot.text(europe_data, {x: "year", y: "country", text: (d) => Math.round(d.visa_free_count?.toFixed(1)), fill: "black", title: "title"})
    ],
    marginLeft: 100,
});
```

```js
const africa_heatmap = Plot.plot({
    padding: 0,
    grid: true,
    x: {axis: "top", label: "Year", tickFormat: ""},
    y: {
        label: "Country",
        domain: africaCountryOrder
    },
    color: {type: "linear", scheme: "PiYG"},
    marks: [
        Plot.cell(africa_data, {x: "year", y: "country", fill: "visa_free_count", inset: 0.7}),
        Plot.text(africa_data, {x: "year", y: "country", text: (d) => Math.round(d.visa_free_count?.toFixed(1)), fill: "black", title: "title"})
    ],
    marginLeft: 100,
});
```


```js
const inputViz = Inputs.select(["Asia", "Europe", "Africa"], {value: "Asia"});
// WITH LABEL: 
        // const inputViz = Inputs.select(["Asia", "Europe"], {value: "Asia", label: "Select a Region:"});
// https://observablehq.com/framework/inputs/select

// Create the reactive value from the element
const selection = Generators.input(inputViz); 
// https://observablehq.com/documentation/misc/standard-library#generators
```

<div class="card" style="width: fit-content;">
    <div style="display: flex; justify-content: space-between; align-items: top;">
        <div style="min-width: 65%;">
            <h1>Henley Passport Index</h1>
            <h2 style="margin-bottom: 0;">This index captures the number of countries to which travelers in possession of each passport in the world may enter visa free.</h2>
            <h3 style="margin-top: 5px;">2006 — 2025 (excepting '07 and '09 which were not collected)</h3>
            ${selection === "Asia" ? asia_heatmap
            : selection === "Europe" ? europe_heatmap
            : selection === "Africa" ? africa_heatmap
            : null}
        </div>
        <div>
            <h1 style="font-size: 1.4em; margin-top: 15px;">Heatmap by Region</h1>
            <p>Select a region: ${inputViz}</p>
            <h2><b>Variable descriptions:</b></h2>
            <p>X: Years from 2006 to 2025.</p>
            <p>Y: Country within selected region.</p>
            <p>Heatmap tiles: The number of countries that do not require a visa for the passport holder, or passport holders can obtain a visa on arrival, a visitor’s permit, or an electronic travel authority (ETA) when entering the destination.</p>
            <p>Data Source: <a href="https://www.henleyglobal.com/passport-index/ranking" target="_blank">The Henley Passport Index</a> and <a href="https://github.com/rfordatascience/tidytuesday/tree/main/data/2025/2025-09-09" target="_blank">Tidy Tuesday</a>.</p>
        </div>
    </div>
</div>


```js
//<div class="grid grid-cols-4">
//    <div class="card"><h1>A</h1></div>
//    <div class="card"><h1>B</h1></div>
//    <div class="card"><h1>C</h1></div>
//    <div class="card"><h1>D</h1>${resize((width) => BumpChart(asia_data, {width}))}</div>
//</div>
```



```js
const bump = BumpChart(asia_data);
// https://observablehq.observablehq.cloud/framework-example-chess/
// https://observablehq.com/@analyzer2004/bump-chart
```