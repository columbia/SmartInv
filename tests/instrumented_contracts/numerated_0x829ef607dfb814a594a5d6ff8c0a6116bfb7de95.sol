1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-03
3 */
4 
5 pragma solidity 0.8.7;
6 
7 interface PnsAddressesInterface {
8     function owner() external view returns (address);
9     function getPnsAddress(string memory _label) external view returns(address);
10 }
11 
12 pragma solidity 0.8.7;
13 
14 interface PnsPricesOracleInterface {
15     function getMaticCost(string memory _name, uint256 expiration) external view returns (uint256);
16     function getEthCost(string memory _name, uint256 expiration) external view returns (uint256);
17 }
18 
19 pragma solidity 0.8.7;
20 
21 abstract contract PnsAddressesImplementation is PnsAddressesInterface {
22     address private PnsAddresses;
23     PnsAddressesInterface pnsAddresses;
24 
25     constructor(address addresses_) {
26         PnsAddresses = addresses_;
27         pnsAddresses = PnsAddressesInterface(PnsAddresses);
28     }
29 
30     function setAddresses(address addresses_) public {
31         require(msg.sender == owner(), "Not authorized.");
32         PnsAddresses = addresses_;
33         pnsAddresses = PnsAddressesInterface(PnsAddresses);
34     }
35 
36     function getPnsAddress(string memory _label) public override view returns (address) {
37         return pnsAddresses.getPnsAddress(_label);
38     }
39 
40     function owner() public override view returns (address) {
41         return pnsAddresses.owner();
42     }
43 }
44 
45 
46 pragma solidity 0.8.7;
47 
48 contract Computation {
49     function computeNamehash(string memory _name) public pure returns (bytes32 namehash) {
50         namehash = 0x0000000000000000000000000000000000000000000000000000000000000000;
51         namehash = keccak256(
52         abi.encodePacked(namehash, keccak256(abi.encodePacked('eth')))
53         );
54         namehash = keccak256(
55         abi.encodePacked(namehash, keccak256(abi.encodePacked(_name)))
56         );
57     }
58 }
59 
60 // SPDX-License-Identifier: MIT
61 
62 pragma solidity 0.8.7;
63 
64 contract PnsRegistrar is Computation, PnsAddressesImplementation {
65 
66     constructor(address addresses_) PnsAddressesImplementation(addresses_) {
67     }
68 
69     bool public isActive = true;
70 
71     struct Register {
72         string name;
73         address registrant;
74         uint256 expiration;
75     }
76 
77     event registerCall(string _name, address _registrant, uint256 _expiration);
78 
79     function pnsRegisterMinter(Register[] memory register) public payable {
80         require(isActive, "Contract must be active.");
81         require(totalCostEth(register) <= msg.value, "Ether value is not correct.");
82 
83         for(uint256 i=0; i<register.length; i++) {
84             require(checkString(register[i].name) == true, "Invalid name.");
85             emit registerCall(register[i].name, register[i].registrant, register[i].expiration);
86         }
87         
88     }
89 
90     function totalCostEth(Register[] memory register) public view returns (uint256) {
91         PnsPricesOracleInterface pnsPricesOracle = PnsPricesOracleInterface(getPnsAddress("_pnsPricesOracle"));
92         uint256 totalCost;
93         for(uint256 i=0; i<register.length; i++) {
94             totalCost = totalCost + pnsPricesOracle.getEthCost(register[i].name, register[i].expiration);
95         }
96         return totalCost;
97     }
98 
99     function checkString(string memory str) public pure returns (bool){
100         bytes memory b = bytes(str);
101         if(b.length > 15) return false;
102         if(b.length < 3) return false;
103 
104         for(uint i; i<b.length; i++){
105             bytes1 char = b[i];
106             if(
107                 (char == 0x2e)
108             )
109                 return false;
110         }
111         return true;
112     }
113 
114     function withdraw(address to, uint256 amount) public {
115         require(msg.sender == owner());
116         require(amount <= address(this).balance);
117         payable(to).transfer(amount);
118     }
119     
120     function flipActiveState() public {
121         require(msg.sender == owner());
122         isActive = !isActive;
123     }
124 
125 }