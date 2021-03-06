import { Expression } from "../Abstract/Expresiones";
import { Retorno } from "../Abstract/Retorno";
import { Environment } from "../Symbol/Enviorment";
import { MiError, TypeError } from '../Errores/Error';

export class Access extends Expression{

    constructor(private id: string, line : number, column: number){
        super(line, column);
    }

    public execute(environment: Environment): Retorno {
        const value = environment.getVar(this.id);
        if(value == null){
            throw new MiError(this.line,this.column, TypeError.SEMANTICO, "LA VARIABLE NO EXISTE");
        }else{
            return {value : value.valor, type : value.type};
        }
    }
    
    public draw() : {rama : string, nodo: string}{
        const x = Math.floor(Math.random() * (100-0)+0);
        let nombreNodoPrincipal = "nodoAccess"+x.toString();
        const rama = `
        ${nombreNodoPrincipal}[label="Access"];
        nodoaccess${nombreNodoPrincipal}[label="${this.id}"];
        ${nombreNodoPrincipal} -> nodoaccess${nombreNodoPrincipal};
        `;
        return {rama: rama, nodo: nombreNodoPrincipal.toString()};
    }
}