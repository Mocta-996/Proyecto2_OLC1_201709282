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
exports.Logic = exports.LogicOption = void 0;
var Retorno_1 = require("../Abstract/Retorno");
var Expresiones_1 = require("../Abstract/Expresiones");
var LogicOption;
(function (LogicOption) {
    LogicOption[LogicOption["AND"] = 0] = "AND";
    LogicOption[LogicOption["OR"] = 1] = "OR";
    LogicOption[LogicOption["NOT"] = 2] = "NOT";
})(LogicOption = exports.LogicOption || (exports.LogicOption = {}));
var Logic = /** @class */ (function (_super) {
    __extends(Logic, _super);
    function Logic(left, right, type, line, column) {
        var _this = _super.call(this, line, column) || this;
        _this.left = left;
        _this.right = right;
        _this.type = type;
        return _this;
    }
    Logic.prototype.execute = function (environment) {
        var leftValue = this.left.execute(environment);
        var rightValue = this.right.execute(environment);
        if (this.type == LogicOption.AND) {
            var result = (leftValue.value && rightValue.value);
            return { value: result, type: Retorno_1.Type.BOOLEAN };
        }
        else if (this.type == LogicOption.OR) {
            var result = (leftValue.value || rightValue.value);
            return { value: result, type: Retorno_1.Type.BOOLEAN };
        }
        else if (this.type == LogicOption.NOT) {
            var result = !(leftValue.value);
            return { value: result, type: Retorno_1.Type.BOOLEAN };
        }
        else {
            return { value: null, type: Retorno_1.Type.NULL };
        }
    };
    return Logic;
}(Expresiones_1.Expression));
exports.Logic = Logic;
