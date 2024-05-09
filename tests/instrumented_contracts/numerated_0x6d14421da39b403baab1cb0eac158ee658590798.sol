1 pragma solidity ^0.4.18;
2 
3 contract Agencies {
4   mapping (address => string) private agencyOfOwner;
5   mapping (string => address) private ownerOfAgency;
6 
7   event Set (string indexed _agency, address indexed _owner);
8   event Unset (string indexed _agency, address indexed _owner);
9 
10   function Agencies () public {
11   }
12 
13   function agencyOf (address _owner) public view returns (string _agency) {
14     return agencyOfOwner[_owner];
15   }
16 
17   function ownerOf (string _agency) public view returns (address _owner) {
18     return ownerOfAgency[_agency];
19   }
20 
21   function set (string _agency) public {
22     require(bytes(_agency).length > 2);
23     require(ownerOf(_agency) == address(0));
24 
25     address owner = msg.sender;
26     string storage oldAgency = agencyOfOwner[owner];
27 
28     if (bytes(oldAgency).length > 0) {
29       Unset(oldAgency, owner);
30       delete ownerOfAgency[oldAgency];
31     }
32 
33     agencyOfOwner[owner] = _agency;
34     ownerOfAgency[_agency] = owner;
35     Set(_agency, owner);
36   }
37 
38   function unset () public {
39     require(bytes(agencyOfOwner[msg.sender]).length > 0);
40 
41     address owner = msg.sender;
42     string storage oldAgency = agencyOfOwner[owner];
43 
44     Unset(oldAgency, owner);
45 
46     delete ownerOfAgency[oldAgency];
47     delete agencyOfOwner[owner];
48   }
49 }