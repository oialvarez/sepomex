const winston = require('winston');

const transformAndStoreMxLocations = () => {
  const mexicanLocations = getMexicanLocations();
  winston.log(mexicanLocations, mexicanLocations.length);
  storeData('data/mx.json', mexicanLocations);
};

const storeData = (path, data) => {
  winston.log(`Starting to write file ${path}`);
  const fs = require('fs');
  fs.writeFile(path, JSON.stringify(data), (err) => {
    if (err) {
      winston.error(err);
      return;
    };
    winston.log(`File ${path} has been created`);
  });
};

const getMexicanLocations = () => {
  const json = require('./CPdescarga.txt.json');
  const result = json.reduce((accumulator, current) => {

    const statesFound = findExistingElementsByName(accumulator, current.d_estado);

    if (statesFound.length === 0) {
      accumulator.push(getState(current));
    } else {

      const municipalities = statesFound[0].children;
      const municipalitiesFound = findExistingElementsByName(municipalities, current.D_mnpio);;

      if (municipalitiesFound.length === 0) {
        municipalities.push(getMunicipality(current));
      } else {

        const colonies = municipalitiesFound[0].children;
        const coloniesFound = findExistingElementsByName(colonies, current.d_asenta);

        if (coloniesFound.length === 0) {
          colonies.push(getColony(current));
        }

      }

    }
    return accumulator;
  }, []);

  return result;
};

const findExistingElementsByName = (arrayList, looked) => {
  return arrayList.filter(e => e.name === looked);
};

const getState = (element) => {
  const stateCode = getStateCode(element);
  const state = buildLocation(element.d_estado, element.d_codigo, stateCode);
  const municipality = getMunicipality(element);
  state.children.push(municipality);
  return state;
};

const getStateCode = (element) => {
  const theMap = [{ c_estado: '09', state_code: 'CDMX', d_estado: 'Ciudad de México' },
  { c_estado: '01', state_code: 'AGS', d_estado: 'Aguascalientes' },
  { c_estado: '02', state_code: 'BCN', d_estado: 'Baja California' },
  { c_estado: '03', state_code: 'BCS', d_estado: 'Baja California Sur' },
  { c_estado: '04', state_code: 'CAM', d_estado: 'Campeche' },
  { c_estado: '05', state_code: 'COA', d_estado: 'Coahuila de Zaragoza' },
  { c_estado: '06', state_code: 'COL', d_estado: 'Colima' },
  { c_estado: '07', state_code: 'CHS', d_estado: 'Chiapas' },
  { c_estado: '08', state_code: 'CHI', d_estado: 'Chihuahua' },
  { c_estado: '10', state_code: 'DGO', d_estado: 'Durango' },
  { c_estado: '11', state_code: 'GTO', d_estado: 'Guanajuato' },
  { c_estado: '12', state_code: 'GRO', d_estado: 'Guerrero' },
  { c_estado: '13', state_code: 'HGO', d_estado: 'Hidalgo' },
  { c_estado: '14', state_code: 'JAL', d_estado: 'Jalisco' },
  { c_estado: '15', state_code: 'EM', d_estado: 'México' },
  { c_estado: '16', state_code: 'MICH', d_estado: 'Michoacán de Ocampo' },
  { c_estado: '17', state_code: 'MOR', d_estado: 'Morelos' },
  { c_estado: '18', state_code: 'NAY', d_estado: 'Nayarit' },
  { c_estado: '19', state_code: 'NL', d_estado: 'Nuevo León' },
  { c_estado: '20', state_code: 'OAX', d_estado: 'Oaxaca' },
  { c_estado: '21', state_code: 'PUE', d_estado: 'Puebla' },
  { c_estado: '22', state_code: 'QRO', d_estado: 'Querétaro' },
  { c_estado: '23', state_code: 'QR', d_estado: 'Quintana Roo' },
  { c_estado: '24', state_code: 'SLP', d_estado: 'San Luis Potosí' },
  { c_estado: '25', state_code: 'SIN', d_estado: 'Sinaloa' },
  { c_estado: '26', state_code: 'SON', d_estado: 'Sonora' },
  { c_estado: '27', state_code: 'TAB', d_estado: 'Tabasco' },
  { c_estado: '28', state_code: 'TAM', d_estado: 'Tamaulipas' },
  { c_estado: '29', state_code: 'TLAX', d_estado: 'Tlaxcala' },
  { c_estado: '30', state_code: 'VER', d_estado: 'Veracruz de Ignacio de la Llave' },
  { c_estado: '31', state_code: 'YUC', d_estado: 'Yucatán' },
  { c_estado: '32', state_code: 'ZAC', d_estado: 'Zacatecas' }];

  return theMap.filter(e => e.c_estado === element.c_estado)[0].state_code;

}

const getMunicipality = (element) => {
  const municipality = buildLocation(element.D_mnpio, element.d_codigo, element.c_mnpio);
  const colony = getColony(element);
  municipality.children.push(colony);
  return municipality;
};

const getColony = (element) => {
  const colony = buildLocation(element.d_asenta, element.d_codigo, element.id_asenta_cpcons);
  delete colony.code;
  delete colony.children;
  return colony;
};

const buildLocation = (name, zipcode, code) => {
  return {
    name,
    zipcode,
    code,
    children: []
  }
};

module.exports = {
  getMexicanLocations,
  transformAndStoreMxLocations
}

