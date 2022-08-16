pragma solidity >=0.7.0 <0.9.0;

contract SupplyChainFarmaceutica {
  
  mapping(address => Articulo[]) listaArticulos;
  mapping(address => Proveedor[]) istaProveedores;
  mapping(address => Orden[]) ListaOrdenes;
  mapping(address => Trazabilidad[]) trazabilidadArticulo;
  
  struct Articulo {
    string codigoArticulo;
    string descripcionArticulo;
    string codigoBarrasArticulo;
    string certificado();
    string lote;
  }
  
  struct Proveedor {
    string codigoProveedor;
    string descripcionProveedor;
    string direccionProveedor;
  }
 
  struct Orden {
    string codigoOrden;
    Artiulo articulo;
    Proveedor proveedor;
    uint128 cantidad;
    uint timeStamp;
  }
  
  struct Trazabilidad {
    uint indiceTrazabilidad;
    string codigoBarrasArticulo;
    string descripcionArticulo;
    string codigoOrden;
    string descripcionProveedor;
    string certificadoArticulo;
    string loteTrazabilidad;
  }
  
  function crearArticulo (string memory codigo, string memory descripcion, string memory codigoBarras, 
                          string memory certificado, ctring memory lote) public {
    require(!existeCodigoDeBarras(codigoBarras), "El codigo de barras ya existe");
    Articulo memory nuevoArticulo = Articulo ({codigoArticulo: codigo,
                                               descripcionArticulo: descripcion,
                                               codigoBarrasArticulo: codigoBarras,
                                               certificado: certificado,
                                               lote: lote});
    listaArticulos[msg.sender].push(nuevoArticulo);
  }
  
  function existeCodigoDeBarras(string memory codigo) private view returns (bool exists) {
    for (uint i = 0; i<listaArticulos[mesg.sender].length; i++){
      if (keccak256(abi.encodePacked(listaArticulos[msg.sender].[i].codigoBarrasArticulo)) == keccak256(abi.encodePacked(codigo))){
        return true;
      }
    }
    return false;
  }
  
  function crearProveedor (string memory codigo, string memory descripcion, string memory direccion) public {
    require(!existeProveedor(codigo), "El codigo de proveedor ya existe");
    Proveedor memory nuevoProveedor = Proveedor ({codigoProveedor: codigo,
                                               descripcionProveedor: descripcion,
                                               direccionProveedor: direccion});
    listaProveedores[msg.sender].push(nuevoProveedor);
  }
  
  function existeProveedor(string memory codigo) private view returns (bool exists) {
    for (uint i = 0; i<listaProveedores[mesg.sender].length; i++){
      if (keccak256(abi.encodePacked(listaProveedores[msg.sender].[i].codigoProveedor)) == keccak256(abi.encodePacked(codigo))){
        return true;
      }
    }
    return false;
  }
  
  function crearNuevaOrden (string memory codigo, string memory codigoArticulo, string memory codigoProveedor, uint128 cantidad) public {
    require(!existeOrden(codigoBarras), "El orden con el número de codigo ya existe");
    if (bytes(codigoArticulo).length != 0 && bytes(codigoProveedor).length != 0)
    {
       Articulo memory articuloOrden = consultarArticuloPorCodigo(codigoArticulo);
       Proveedor memory proveedorOrden = consultarProveedorPorCodigo(codigoProveedor);
       Orden memory nuevaOrden = Orden ({codigoOrden: codigo, articulo: articuloOrden,
                                               proveedor: proveedorOrden,
                                               cantidad: cantidad,
                                               timeStamp: now});
    listaOrdenes[msg.sender].push(nuevaOrden);
  }
  
  function existeOrden(string memory codigo) private view returns (bool exists) {
    for (uint i = 0; i<listaOrdenes[mesg.sender].length; i++){
      if (keccak256(abi.encodePacked(listaOrdenes[msg.sender].[i].codigoOrden)) == keccak256(abi.encodePacked(codigo))){
        return true;
      }
    }
    return false;
  }
  
  function consultarArticuloPorCodigo (string memory codigo) public view returns (Articulo memory articulo) {
    require(existeArticulo(codigo), "No existe articulo con tal codigo");
    for(uint i = 0; i<listaArticulos[mesg.sender].length; i++){
      if (keccak256(abi.encodePacked(listaArticulos[msg.sender].[i].codigoArticulo)) == keccak256(abi.encodePacked(codigo))){
        return listaArticulos[msg.sender][i];
      }
    }
  }

  function existeArticulo(string memory codigo) private view returns (bool exists) {
    for (uint i = 0; i<listaArticulos[mesg.sender].length; i++){
      if (keccak256(abi.encodePacked(listaArticulos[msg.sender].[i].codigoArticulo)) == keccak256(abi.encodePacked(codigo))){
        return true;
      }
    }
    return false;
  }
  
   function consultarProveedorPorCodigo (string memory codigo) public view returns (Articulo memory articulo) {
    require(existeProveedor(codigo), "No existe proveedor con tal codigo");
    for(uint i = 0; i<listaProveedores[mesg.sender].length; i++){
      if (keccak256(abi.encodePacked(listaProveedores[msg.sender].[i].codigoProveedor)) == keccak256(abi.encodePacked(codigo))){
        return listaProveedores[msg.sender][i];
      }
    }
  }
  
  function consultarOrdenPorCodigo (string memory codigo) public view returns (Articulo memory articulo) {
    require(existeOrden(codigo), "La orden con el número de código no existe");
    for(uint i = 0; i<listaOrdenes[msg.sender].length; i++){
      if (keccak256(abi.encodePacked(listaOrdenes[msg.sender].[i].codigoOrden)) == keccak256(abi.encodePacked(codigo))){
        return listaOrdenes[msg.sender][i];
      }
    }
  }
  
  function consultarListaArticulos() public view retuns (Articulo[] memory) {
    return listaArticulos[msg.sender];
  }
  
  function consultarListaProveedores() public view retuns (Proveedor[] memory) {
    return listaProveedores[msg.sender];
  }
  
  function consultarTrazabilidad(string memory codigo) public view returns (Trazabilidad[] memory) {
    require(existeCodigoDeBarras(codigo), "El código de barras no existe");
    delete trazabilidadArticulo[msg.sender];
    uint aux = 0;
    for(uint i = 0; i<listaOrdenes[msg.sender].length; i++){
      Articulo memory articuloOrden = listaOrdenes[msg.sender][i].articulo;
      if (keccak256(abi.encodePacked(articuloOrden.codigoBarrasArticulo)) == keccak256(abi.encodePacked(codigo))){
        aux = i;
      }
    }
    
    for(uint j = 0; j<=aux; j++){
      Articulo memory articulo = listaOrdenes[msg.sender][j].articulo;
      Articulo memory proveedor = listaOrdenes[msg.sender][j].proveedor;
      Trazabilidad memory componente = Trazabilidad({indiceTrazabilidad: (j+1),
                                                     descripcionArticulo: articulo.desripcionArticulo,
                                                     codigoBarrasArticulo: articulo.codigoBarrasArticulo,
                                                     codigoOrden: listaOrdenes[msg.sender][j].codigoOrden,
                                                     descripcionProveedor: articulo.desripcionProveedor,
                                                     certificadoArticulo: articulo.certifcado,
                                                     loteTrazabilidad:articulo.lote
                                                     
      });
      trazabilidadArticulo[msg.sender].push(componente);
    }
    return trazbilidadarticulo[msg.sender];
  }

}
