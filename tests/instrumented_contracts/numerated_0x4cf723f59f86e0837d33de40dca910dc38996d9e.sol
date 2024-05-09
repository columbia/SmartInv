1 /*
2 
3   Copyright 2018 Dexdex.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity ^0.4.21;
20 
21 contract Ownable {
22     address public owner;
23 
24     function Ownable()
25         public
26     {
27         owner = msg.sender;
28     }
29 
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     function transferOwnership(address newOwner)
36         public
37         onlyOwner
38     {
39         if (newOwner != address(0)) {
40             owner = newOwner;
41         }
42     }
43 }
44 
45 contract ITrader {
46 
47   function getDataLength(
48   ) public pure returns (uint256);
49 
50   function getProtocol(
51   ) public pure returns (uint8);
52 
53   function getAvailableVolume(
54     bytes orderData
55   ) public view returns(uint);
56 
57   function isExpired(
58     bytes orderData
59   ) public view returns (bool); 
60 
61   function trade(
62     bool isSell,
63     bytes orderData,
64     uint volume,
65     uint volumeEth
66   ) public;
67   
68   function getFillVolumes(
69     bool isSell,
70     bytes orderData,
71     uint volume,
72     uint volumeEth
73   ) public view returns(uint, uint);
74 
75 }
76 
77 contract ITraders {
78 
79   /// @dev Add a valid trader address. Only owner.
80   function addTrader(uint8 id, ITrader trader) public;
81 
82   /// @dev Remove a trader address. Only owner.
83   function removeTrader(uint8 id) public;
84 
85   /// @dev Get trader by id.
86   function getTrader(uint8 id) public view returns(ITrader);
87 
88   /// @dev Check if an address is a valid trader.
89   function isValidTraderAddress(address addr) public view returns(bool);
90 
91 }
92 
93 contract Traders is ITraders, Ownable {
94 
95   mapping(uint8 => ITrader) public traders; // Mappings of ids of allowed addresses
96   mapping(address => bool) public addresses; // Mappings of addresses of allowed addresses
97 
98   /// @dev Add a valid trader address. Only owner.
99   function addTrader(uint8 protocolId, ITrader trader) public onlyOwner {
100     require(protocolId == trader.getProtocol());
101     traders[protocolId] = trader;
102     addresses[trader] = true;
103   }
104 
105   /// @dev Remove a trader address. Only owner.
106   function removeTrader(uint8 protocolId) public onlyOwner {
107     delete addresses[traders[protocolId]];
108     delete traders[protocolId];
109   }
110 
111   /// @dev Get trader by protocolId.
112   function getTrader(uint8 protocolId) public view returns(ITrader) {
113     return traders[protocolId];
114   }
115 
116   /// @dev Check if an address is a valid trader.
117   function isValidTraderAddress(address addr) public view returns(bool) {
118     return addresses[addr];
119   }
120 }