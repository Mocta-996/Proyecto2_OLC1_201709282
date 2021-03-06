"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.While = void 0;
var Instrucciones_1 = require("../Abstract/Instrucciones");
var Retorno_1 = require("../Abstract/Retorno");
var Error_1 = require("../Errores/Error");
var While = /** @class */ (function (_super) {
    __extends(While, _super);
    function While(condition, code, line, column) {
        var _this = _super.call(this, line, column) || this;
        _this.condition = condition;
        _this.code = code;
        return _this;
    }
    While.prototype.execute = function (env) {
        var condition = this.condition.execute(env);
        if (condition.type != Retorno_1.Type.BOOLEAN) {
            throw new Error_1.MiError(this.line, this.column, Error_1.TypeError.SEMANTICO, "LA EXPRESION RECIBIDA NO ES DE TIPO BOOLEAN");
        }
        else {
            while (condition.value == true) {
                var element = this.code.execute(env);
                if (element != null || element != undefined) {
                    if (element.type == Retorno_1.Type.BREAK) {
                        break;
                    }
                    else if (element.type == Retorno_1.Type.CONTINUE) {
                        condition = this.condition.execute(env);
                        continue;
                    }
                    else {
                        return element;
                    }
                }
                condition = this.condition.execute(env);
                if (condition.type != Retorno_1.Type.BOOLEAN) {
                    throw new Error_1.MiError(this.line, this.column, Error_1.TypeError.SEMANTICO, "LA EXPRESION RECIBIDA NO ES DE TIPO BOOLEAN");
                }
            }
        }
    };
    While.prototype.draw = function () {
        var x = Math.floor(Math.random() * (100 - 0) + 0);
        var nombreNodoPrincipal = "nodoWhile" + x.toString();
        var condicion = this.condition.draw();
        var inst = this.code.draw();
        var rama = "\n        " + nombreNodoPrincipal + "[label=\"WHILE\"];\n        " + condicion.rama + "\n        " + inst.rama + "\n        " + nombreNodoPrincipal + " -> " + condicion.nodo + ";\n        " + nombreNodoPrincipal + " -> " + inst.nodo + ";\n        ";
        return { rama: rama, nodo: nombreNodoPrincipal.toString() };
    };
    return While;
}(Instrucciones_1.Instruction));
exports.While = While;
