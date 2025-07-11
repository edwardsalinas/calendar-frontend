// En caso de necesitar la implementación del FetchAPI
// yarn add -D whatwg-fetch
import 'whatwg-fetch'; 

import { TextEncoder, TextDecoder } from 'util';

global.TextEncoder = TextEncoder;
global.TextDecoder = TextDecoder;
// En caso de encontrar paquetes que lo requieran 
// yarn add -D setimmediate
// import 'setimmediate';



// En caso de tener variables de entorno y aún no soporta el import.meta.env
// yarn add -D dotenv
require('dotenv').config({
    path: '.env.test'
});

// Realizar el mock completo de las variables de entorno
jest.mock('./src/helpers/getEnvVariables', () => ({
    getEnvVariables: () => ({ ...process.env })
}));

// import { TextEncoder, TextDecoder } from 'util';

// Object.assign(global, { TextDecoder, TextEncoder });
