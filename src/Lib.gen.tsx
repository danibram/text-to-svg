/* TypeScript file generated from Lib.res by genType. */

/* eslint-disable */
/* tslint:disable */

import * as LibJS from './Lib.res.mjs';

import type {Font_t as Opentype_Font_t} from '../src/Vendor/Opentype.gen';

import type {Layout_Options_align as Opentype_Layout_Options_align} from '../src/Vendor/Opentype.gen';

import type {model as MakerJS_model} from '../src/Vendor/MakerJS.gen';

export const composeModel: (text:string, letterSpacing:(undefined | number), font:Opentype_Font_t, fontSize:(undefined | number), lineHeight:(undefined | number), align:(undefined | Opentype_Layout_Options_align), canvasWidth:(undefined | number)) => MakerJS_model = LibJS.composeModel as any;
