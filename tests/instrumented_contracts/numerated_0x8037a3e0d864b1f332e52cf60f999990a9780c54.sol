1 pragma solidity ^0.4.11;
2 
3 // File: contracts/zeppelin/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     require(newOwner != address(0));
38     owner = newOwner;
39   }
40 
41 }
42 
43 // File: contracts/zeppelin/contracts/token/ERC20Basic.sol
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) constant returns (uint256);
53   function transfer(address to, uint256 value) returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 // File: contracts/zeppelin/contracts/token/ERC20.sol
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) constant returns (uint256);
65   function transferFrom(address from, address to, uint256 value) returns (bool);
66   function approve(address spender, uint256 value) returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 // File: contracts/Airdropper.sol
71 
72 /*
73 Copyright 2018 CargiX.io Pte Ltd
74 
75 Licensed under the Apache License, Version 2.0 (the "License");
76 you may not use this file except in compliance with the License.
77 You may obtain a copy of the License at
78 
79     http://www.apache.org/licenses/LICENSE-2.0
80 
81 Unless required by applicable law or agreed to in writing, software
82 distributed under the License is distributed on an "AS IS" BASIS,
83 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
84 See the License for the specific language governing permissions and
85 limitations under the License.
86  */
87 
88 pragma solidity ^0.4.18;
89 
90 
91 
92 
93 
94 contract Airdropper is Ownable {
95 
96     function multisend(address _tokenAddr, address[] dests, uint256[] values)
97     onlyOwner
98     returns (uint256) {
99         uint256 i = 0;
100         while (i < dests.length) {
101            ERC20(_tokenAddr).transfer(dests[i], values[i]);
102            i += 1;
103         }
104         return(i);
105     }
106 
107     function multisendFrom(address _tokenAddr, address _fromAddr, address[] dests, uint256[] values)
108     onlyOwner
109     returns (uint256) {
110         uint256 i = 0;
111         while (i < dests.length) {
112            ERC20(_tokenAddr).transferFrom(_fromAddr, dests[i], values[i]);
113            i += 1;
114         }
115         return(i);
116     }
117 }