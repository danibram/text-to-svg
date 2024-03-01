import esbuild from "esbuild";
import { copy } from "esbuild-plugin-copy";
import fs from "fs";

const devMode = process.argv.slice(2).includes("--watch");
const isProd =
  process.env.NODE_ENV === "production" ||
  process.argv.includes("--production");

const baseCfg = {
  entryPoints: [
    {
      in: "src/Main.res.mjs",
      out: "ui",
    },
  ],
  outdir: "dist",
  bundle: true,
  legalComments: "none",
  format: "iife",
  minify: isProd,
  sourcemap: isProd ? false : "inline",
  plugins: [
    copy({
      resolveFrom: "cwd",
      assets: [{ from: ["public/**"], to: ["dist"] }],
      copyOnStart: true,
      watch: devMode,
    }),
  ],
  define: {
    "process.env.GOOGLE_API_KEY": JSON.stringify(process.env.GOOGLE_API_KEY),
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
