1 pragma solidity ^0.4.20;
2 
3 /*************************************************************************************
4 *
5 * Transfiere 2018 Database
6 * Property of FYCMA
7 * Powered by TICsmart
8 * Description: 
9 * Smart Contract of attendance at the event and forum Transfiere 2018
10 *
11 **************************************************************************************/
12 
13 contract Transfiere2018Database {
14   struct Organization {
15     string codigo;
16     string nombre;
17     string tipo;
18   }
19 
20   Organization[] internal availableOrgs;
21   address public owner = msg.sender;
22 
23   function addOrg(string _codigo, string _nombre, string _tipo) public {
24     require(msg.sender == owner);
25     availableOrgs.push(Organization(_codigo, _nombre, _tipo));
26   }
27 
28   function deleteOrg(string _codigo) public {
29     require(msg.sender == owner);
30 
31     for (uint i = 0; i < availableOrgs.length; i++) {
32       if (keccak256(availableOrgs[i].codigo) == keccak256(_codigo)) {
33         delete availableOrgs[i];
34       }
35     }
36   }
37 
38   function numParticipants() public view returns (uint) {
39     return availableOrgs.length;
40   }
41   
42   function checkCode(string _codigo) public view returns (string, string) {
43     for (uint i = 0; i < availableOrgs.length; i++) {
44       if (keccak256(availableOrgs[i].codigo) == keccak256(_codigo)) {
45           return (availableOrgs[i].nombre, availableOrgs[i].tipo);
46       }
47     }
48     
49     return (_codigo,"The codigo no existe.");
50   }
51   
52   function destroy() public {
53       require(msg.sender == owner);
54       selfdestruct(owner);
55   }
56 }