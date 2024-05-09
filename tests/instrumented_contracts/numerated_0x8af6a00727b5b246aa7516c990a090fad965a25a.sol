1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: contracts/ServiceRegistry.sol
69 
70 /**
71    Copyright (c) 2017 Harbor Platform, Inc.
72 
73    Licensed under the Apache License, Version 2.0 (the “License”);
74    you may not use this file except in compliance with the License.
75    You may obtain a copy of the License at
76 
77    http://www.apache.org/licenses/LICENSE-2.0
78 
79    Unless required by applicable law or agreed to in writing, software
80    distributed under the License is distributed on an “AS IS” BASIS,
81    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
82    See the License for the specific language governing permissions and
83    limitations under the License.
84 */
85 
86 pragma solidity ^0.4.24;
87 
88 
89 /// @notice A service that points to a `RegulatorService`
90 contract ServiceRegistry is Ownable {
91   address public service;
92 
93   /**
94    * @notice Triggered when service address is replaced
95    */
96   event ReplaceService(address oldService, address newService);
97 
98   /**
99    * @dev Validate contract address
100    * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114
101    *
102    * @param _addr The address of a smart contract
103    */
104   modifier withContract(address _addr) {
105     uint length;
106     assembly { length := extcodesize(_addr) }
107     require(length > 0);
108     _;
109   }
110 
111   /**
112    * @notice Constructor
113    *
114    * @param _service The address of the `RegulatorService`
115    *
116    */
117   constructor(address _service) public {
118     service = _service;
119   }
120 
121   /**
122    * @notice Replaces the address pointer to the `RegulatorService`
123    *
124    * @dev This method is only callable by the contract's owner
125    *
126    * @param _service The address of the new `RegulatorService`
127    */
128   function replaceService(address _service) onlyOwner withContract(_service) public {
129     address oldService = service;
130     service = _service;
131     emit ReplaceService(oldService, service);
132   }
133 }