export default {
  input: "src/index.js",
  output: {
    file: "dist/rollup-plugin-lry-coffeescript.cjs.js",
    format: "cjs"
  },
  external: [ "path", "coffeescript" ]
};
