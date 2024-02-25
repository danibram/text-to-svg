import esbuild from "esbuild";
import { copy } from "esbuild-plugin-copy";
import fs from "fs";

const devMode = process.argv.slice(2).includes("--watch");
const isProd =
  process.env.NODE_ENV === "production" ||
  process.argv.includes("--production");

const StyleLoader = {
  name: "inline-style",
  setup({ onLoad }) {
    const template = (css) =>
      `typeof document<'u'&&` +
      `document.head.appendChild(document.createElement('style'))` +
      `.appendChild(document.createTextNode(${JSON.stringify(css)}))`;
    onLoad({ filter: /\.css$/ }, async (args) => {
      let css = await fs.promises.readFile(args.path, "utf8");
      return { contents: template(css) };
    });
  },
};

const baseCfg = {
  entryPoints: [
    {
      in: "src/Main.res.mjs",
      out: "ui",
    },
    {
      in: "src/Lib.res.mjs",
      out: "lib",
    },
  ],
  outdir: "dist",
  bundle: true,
  legalComments: "none",
  format: "iife",
  minify: isProd,
  sourcemap: isProd ? false : "inline",
  plugins: [
    StyleLoader,
    copy({
      resolveFrom: "cwd",
      assets: [{ from: ["static/**"], to: ["dist"] }],
      copyOnStart: true,
      watch: devMode,
    }),
  ],
  define: {
    "process.env.GOOGLE_API_KEY": process.env.GOOGLE_API_KEY,
  },
};

if (devMode) {
  const ctx = await esbuild.context({
    ...baseCfg,
    logLevel: "info",
  });
  await ctx.watch();
} else {
  await esbuild.build({
    ...baseCfg,
    minify: true,
    logLevel: "error",
  });
}
