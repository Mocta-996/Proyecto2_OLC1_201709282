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
exports.NewArray = void 0;
var Expresiones_1 = require("../Abstract/Expresiones");
var Retorno_1 = require("../Abstract/Retorno");
var Array_1 = require("../Symbol/Array");
var Symbol_1 = require("../Symbol/Symbol");
var Error_1 = require("../Errores/Error");
var NewArray = /** @class */ (function (_super) {
    __extends(NewArray, _super);
    function NewArray(listExpr, line, column) {
        var _this = _super.call(this, line, column) || this;
        _this.listExpr = listExpr;
        return _this;
    }
    NewArray.prototype.execute = function (environment) {
        var array = new Array_1.MiArray();
        var index = 0;
        if (this.listExpr.every(function (actual) { return (actual.execute(environment).type == Retorno_1.Type.INT) || (actual.execute(environment).type == Retorno_1.Type.DOUBLE) || (actual.execute(environment).type == Retorno_1.Type.CHAR) || (actual.execute(environment).type == Retorno_1.Type.BOOLEAN) || (actual.execute(environment).type == Retorno_1.Type.STRING); })) {
            this.listExpr.forEach(function (expr) {
                var value = expr.execute(environment);
                if (value.type == Retorno_1.Type.CHAR) {
                    array.setValue(index++, new Symbol_1.Symbol(String.fromCharCode(value.value), '', value.type));
                }
                else {
                    array.setValue(index++, new Symbol_1.Symbol(value.value, '', value.type));
                }
            });
            return { value: array, type: Retorno_1.Type.ARRAY };
        }
        else {
            throw new Error_1.MiError(this.line, this.column, Error_1.TypeError.SEMANTICO, "LOS ELEMENTOS DEL ARRAY DEBEN SER DEL MISMO TIPO");
        }
    };
    NewArray.prototype.draw = function () {
        var x = Math.floor(Math.random() * (100 - 0) + 0);
        var nombreNodoPrincipal = "nodoNewArray" + x.toString();
        var rama = "\n        " + nombreNodoPrincipal + "[label=\"Array\"];\n        ";
        this.listExpr.forEach(function (exp) {
            var expExp = exp.draw();
            rama = rama + ("\n            " + expExp.rama + "\n            " + nombreNodoPrincipal + " -> " + expExp.nodo + ";\n            ");
        });
        return { rama: rama, nodo: nombreNodoPrincipal.toString() };
    };
    return NewArray;
}(Expresiones_1.Expression));
exports.NewArray = NewArray;
