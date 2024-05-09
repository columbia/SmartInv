1 pragma solidity ^0.4.13;
2 
3 contract Owned {
4     address public owner;
5     
6     modifier onlyOwner() {
7         require(isOwner(msg.sender));
8         _;
9     }
10 
11     function Owned() public {
12         owner = msg.sender;
13     }
14 
15     function isOwner(address addr) view public returns(bool) {
16         return addr == owner;
17     }
18 
19     function transferOwnership(address newOwner) public onlyOwner {
20         if (newOwner != address(this)) {
21             owner = newOwner;
22         }
23     }
24 }
25 
26 contract docStore is Owned {
27     
28     uint public indice;
29     
30     mapping(string => Documento) private storeByString;
31     mapping(bytes32 => Documento) private storeByTitle;
32     mapping(uint => Documento) private storeById;
33     mapping(bytes32 => Documento) private storeByHash;
34     
35     struct Documento {
36         string ipfsLink;
37         bytes32 titulo;
38         uint timestamp;
39         address walletAddress;
40         bytes32 fileHash;
41         uint Id;
42     }
43     
44     function docStore() public {
45         indice = 0;
46     }
47     
48     function guardarDocumento(string _ipfsLink, bytes32 _titulo, bytes32 _fileHash) onlyOwner external {
49         require(storeByString[_ipfsLink].titulo == 0x0);
50         require(storeByTitle[_titulo].titulo == 0x0);
51         indice += 1;
52         Documento memory _documento = Documento(_ipfsLink, _titulo, now, msg.sender, _fileHash, indice); 
53         storeByTitle[_titulo] = _documento;
54         storeByString[_ipfsLink] = _documento;
55         storeById[indice] = _documento;
56         storeByHash[_fileHash] = _documento;
57     }
58     
59     function buscarDocumentoPorQM (string _ipfsLink) view external returns (string, bytes32, uint, address, bytes32, uint){
60         Documento memory _documento = storeByString[_ipfsLink];
61         return (_documento.ipfsLink, _documento.titulo, _documento.timestamp, _documento.walletAddress, _documento.fileHash, _documento.Id);
62     }
63     
64     function buscarDocumentoPorTitulo (bytes32 _titulo) view external returns (string, bytes32, uint, address, bytes32, uint){
65         Documento memory _documento = storeByTitle[_titulo];
66         return (_documento.ipfsLink, _documento.titulo, _documento.timestamp, _documento.walletAddress, _documento.fileHash, _documento.Id);
67     }
68     
69     function buscarDocumentoPorId (uint _index) view external returns (string, bytes32, uint, address, bytes32, uint){
70         Documento memory _documento = storeById[_index];
71         return (_documento.ipfsLink, _documento.titulo, _documento.timestamp, _documento.walletAddress, _documento.fileHash, _documento.Id);
72     }
73 
74     function buscarDocumentoPorHash (bytes32 _index) view external returns (string, bytes32, uint, address, bytes32, uint){
75         Documento memory _documento = storeByHash[_index];
76         return (_documento.ipfsLink, _documento.titulo, _documento.timestamp, _documento.walletAddress, _documento.fileHash, _documento.Id);
77     }
78     
79 }