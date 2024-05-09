1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66    Copyright (c) 2017 Harbor Platform, Inc.
67 
68    Licensed under the Apache License, Version 2.0 (the “License”);
69    you may not use this file except in compliance with the License.
70    You may obtain a copy of the License at
71 
72    http://www.apache.org/licenses/LICENSE-2.0
73 
74    Unless required by applicable law or agreed to in writing, software
75    distributed under the License is distributed on an “AS IS” BASIS,
76    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
77    See the License for the specific language governing permissions and
78    limitations under the License.
79 */
80 
81 pragma solidity ^0.4.24;
82 
83 
84 
85 /// @notice A service that points to a `RegulatorService`
86 contract ServiceRegistry is Ownable {
87   address public service;
88 
89   /**
90    * @notice Triggered when service address is replaced
91    */
92   event ReplaceService(address oldService, address newService);
93 
94   /**
95    * @dev Validate contract address
96    * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114
97    *
98    * @param _addr The address of a smart contract
99    */
100   modifier withContract(address _addr) {
101     uint length;
102     assembly { length := extcodesize(_addr) }
103     require(length > 0);
104     _;
105   }
106 
107   /**
108    * @notice Constructor
109    *
110    * @param _service The address of the `RegulatorService`
111    *
112    */
113   constructor(address _service) public {
114     service = _service;
115   }
116 
117   /**
118    * @notice Replaces the address pointer to the `RegulatorService`
119    *
120    * @dev This method is only callable by the contract's owner
121    *
122    * @param _service The address of the new `RegulatorService`
123    */
124   function replaceService(address _service) onlyOwner withContract(_service) public {
125     address oldService = service;
126     service = _service;
127     emit ReplaceService(oldService, service);
128   }
129 }