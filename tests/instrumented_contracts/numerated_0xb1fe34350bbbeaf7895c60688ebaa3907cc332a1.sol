1 pragma solidity 0.4.23;
2 
3 contract CareerCertificate {
4 
5     struct Certificate {
6 
7     bytes32 id;
8     bool isCertificate;
9     bytes32 date;
10     string completeName;
11     string RUT;
12     string institution;
13     bytes32 RutInstitution;
14     string title;
15     string Totalhash;
16     bytes32 FechaTitulacion;
17     bytes32 NroRegistro;
18     bytes32 CodigoVerificacion;
19     
20     bool active;
21 
22   }
23 
24     address public ceoAddress;
25     mapping(address=>bool) employee;
26 
27     mapping (bytes32 => Certificate) certificates;
28 
29     event CertificateCreated(address creator, string id, string RUT);
30     event SetActive(address responsable, string id, bool active, string description);
31 
32     constructor() public {
33     ceoAddress = msg.sender;
34 }
35     //funcion que crea un certificado recibe los campos y lo convierte en la variable bytes32
36     function createCertificate(string _id, string _date, string _completeName, string _RUT, string _institution, string _RutInstition, string _title, string _Totalhash, string _FechaTitulacion, 
37                                 string _NroRegistro, string _CodigoVerificacion) public onlyEmployees {
38  
39          bytes32 realId = convert(_id);
40          
41          certificates[realId].id = realId;
42          certificates[realId].isCertificate = true;
43          certificates[realId].date = convert(_date);
44          
45          certificates[realId].completeName = _completeName;
46          certificates[realId].RUT =_RUT;
47          certificates[realId].institution =_institution ;
48          certificates[realId].RutInstitution = convert(_RutInstition);//CAMBIOS
49          certificates[realId].title = _title;
50          certificates[realId].Totalhash= _Totalhash;//CAMBIOS
51          certificates[realId].FechaTitulacion = convert(_FechaTitulacion);//CAMBIOS
52          certificates[realId].NroRegistro = convert(_NroRegistro) ;//CAMBIOS
53          certificates[realId].CodigoVerificacion = convert(_CodigoVerificacion);//CAMBIOS
54          
55          certificates[realId].active = true;
56         
57          emit CertificateCreated(msg.sender, _id, _RUT);
58 }
59     function convert(string key) internal returns (bytes32 ret) {
60      if (bytes(key).length > 32) {
61         throw;
62      }
63 
64      assembly {
65         ret := mload(add(key, 32))
66      }
67    }
68    function setActive(string _id, bool _active, string description) onlyEmployees {
69          bytes32 realId = convert(_id);
70          certificates[realId].active = _active;
71 
72         emit SetActive(msg.sender, _id, _active, description);
73 }
74 
75 function setCEO(address _newCEO) external onlyCEO {
76         require(_newCEO != address(0));
77 
78         ceoAddress = _newCEO;
79     }
80     function setEmployee (address user) external  onlyCEO {
81         employee[user]=true;
82     }
83     function removeEmployee (address user) external onlyCEO{
84         employee[0];
85         employee[user] = employee[0];
86     }
87     //Ver si employee esta agregado
88     function getEmployee(address user) public view returns (bool) {
89     return employee[user];
90     }
91     modifier onlyCEO() {
92         require(msg.sender == ceoAddress );
93         _;
94     }
95     modifier onlyEmployees() {
96         require(employee[msg.sender] == true || msg.sender == ceoAddress);
97         _;
98     }
99 
100 }