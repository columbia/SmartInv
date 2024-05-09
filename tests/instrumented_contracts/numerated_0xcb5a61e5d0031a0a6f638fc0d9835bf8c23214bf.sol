1 pragma solidity ^0.4.20;
2 
3 /*************************************************************************************
4 *
5 * Transfiere 2018 Database
6 * Property of FYCMA
7 * Powered by TICsmart
8 * Description: 
9 * Smart Contract of attendance at the event and forum Transfiere 2018
10 * Código: Código Hash impreso en el diploma facilitado por Transfiere 2018
11 *
12 **************************************************************************************/
13 
14 contract Transfiere2018Asistencia {
15     struct Organization {
16         string codigo;
17     }
18 
19     Organization[] internal availableOrgs;
20     address public owner = msg.sender;
21 
22     function addOrg(string _codigo) public {
23         require(msg.sender == owner);
24         
25         for (uint i = 0; i < availableOrgs.length; i++) {
26             if (keccak256(availableOrgs[i].codigo) == keccak256(_codigo)) {
27                 return;
28             }
29         }
30         
31         availableOrgs.push(Organization(_codigo));
32     }
33 
34     function deleteOrg(string _codigo) public {
35         require(msg.sender == owner);
36 
37         for (uint i = 0; i < availableOrgs.length; i++) {
38             if (keccak256(availableOrgs[i].codigo) == keccak256(_codigo)) {
39                 delete availableOrgs[i];
40                 availableOrgs.length--;
41                 return;
42             }
43         }
44     }
45     
46     function checkCode(string _codigo) public view returns (string, string) {
47         for (uint i = 0; i < availableOrgs.length; i++) {
48             if (keccak256(availableOrgs[i].codigo) == keccak256(_codigo)) {
49                 return (_codigo,"El código es válido.");
50             }
51         }
52     
53         return (_codigo,"El código no existe.");
54     }
55     
56     function destroy() public {
57         require(msg.sender == owner);
58         selfdestruct(owner);
59     }
60 }