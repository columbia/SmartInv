1 /*
2     Copyright 2017-2019 Phillip A. Elsasser
3 
4     Licensed under the Apache License, Version 2.0 (the "License");
5     you may not use this file except in compliance with the License.
6     You may obtain a copy of the License at
7 
8     http://www.apache.org/licenses/LICENSE-2.0
9 
10     Unless required by applicable law or agreed to in writing, software
11     distributed under the License is distributed on an "AS IS" BASIS,
12     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13     See the License for the specific language governing permissions and
14     limitations under the License.
15 */
16 
17 pragma solidity 0.5.2;
18 
19 
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33      * account.
34      */
35     constructor () internal {
36         _owner = msg.sender;
37         emit OwnershipTransferred(address(0), _owner);
38     }
39 
40     /**
41      * @return the address of the owner.
42      */
43     function owner() public view returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(isOwner());
52         _;
53     }
54 
55     /**
56      * @return true if `msg.sender` is the owner of the contract.
57      */
58     function isOwner() public view returns (bool) {
59         return msg.sender == _owner;
60     }
61 
62     /**
63      * @dev Allows the current owner to relinquish control of the contract.
64      * It will not be possible to call the functions with the `onlyOwner`
65      * modifier anymore.
66      * @notice Renouncing ownership will leave the contract without an owner,
67      * thereby removing any functionality that is only available to the owner.
68      */
69     function renounceOwnership() public onlyOwner {
70         emit OwnershipTransferred(_owner, address(0));
71         _owner = address(0);
72     }
73 
74     /**
75      * @dev Allows the current owner to transfer control of the contract to a newOwner.
76      * @param newOwner The address to transfer ownership to.
77      */
78     function transferOwnership(address newOwner) public onlyOwner {
79         _transferOwnership(newOwner);
80     }
81 
82     /**
83      * @dev Transfers control of the contract to a newOwner.
84      * @param newOwner The address to transfer ownership to.
85      */
86     function _transferOwnership(address newOwner) internal {
87         require(newOwner != address(0));
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 }
92 
93 /*
94     Copyright 2017-2019 Phillip A. Elsasser
95 
96     Licensed under the Apache License, Version 2.0 (the "License");
97     you may not use this file except in compliance with the License.
98     You may obtain a copy of the License at
99 
100     http://www.apache.org/licenses/LICENSE-2.0
101 
102     Unless required by applicable law or agreed to in writing, software
103     distributed under the License is distributed on an "AS IS" BASIS,
104     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
105     See the License for the specific language governing permissions and
106     limitations under the License.
107 */
108 
109 
110 
111 
112 contract MarketContractRegistryInterface {
113     function addAddressToWhiteList(address contractAddress) external;
114     function isAddressWhiteListed(address contractAddress) external view returns (bool);
115 }
116 
117 
118 
119 /// @title MarketContractRegistry
120 /// @author Phil Elsasser <phil@marketprotocol.io>
121 contract MarketContractRegistry is Ownable, MarketContractRegistryInterface {
122 
123     // whitelist accounting
124     mapping(address => bool) public isWhiteListed;
125     address[] public addressWhiteList;                             // record of currently deployed addresses;
126     mapping(address => bool) public factoryAddressWhiteList;       // record of authorized factories
127 
128     // events
129     event AddressAddedToWhitelist(address indexed contractAddress);
130     event AddressRemovedFromWhitelist(address indexed contractAddress);
131     event FactoryAddressAdded(address indexed factoryAddress);
132     event FactoryAddressRemoved(address indexed factoryAddress);
133 
134     /*
135     // External Methods
136     */
137 
138     /// @notice determines if an address is a valid MarketContract
139     /// @return false if the address is not white listed.
140     function isAddressWhiteListed(address contractAddress) external view returns (bool) {
141         return isWhiteListed[contractAddress];
142     }
143 
144     /// @notice all currently whitelisted addresses
145     /// returns array of addresses
146     function getAddressWhiteList() external view returns (address[] memory) {
147         return addressWhiteList;
148     }
149 
150     /// @dev allows for the owner to remove a white listed contract, eventually ownership could transition to
151     /// a decentralized smart contract of community members to vote
152     /// @param contractAddress contract to removed from white list
153     /// @param whiteListIndex of the contractAddress in the addressWhiteList to be removed.
154     function removeContractFromWhiteList(
155         address contractAddress,
156         uint whiteListIndex
157     ) external onlyOwner
158     {
159         require(isWhiteListed[contractAddress], "can only remove whitelisted addresses");
160         require(addressWhiteList[whiteListIndex] == contractAddress, "index does not match address");
161         isWhiteListed[contractAddress] = false;
162 
163         // push the last item in array to replace the address we are removing and then trim the array.
164         addressWhiteList[whiteListIndex] = addressWhiteList[addressWhiteList.length - 1];
165         addressWhiteList.length -= 1;
166         emit AddressRemovedFromWhitelist(contractAddress);
167     }
168 
169     /// @dev allows for the owner or factory to add a white listed contract, eventually ownership could transition to
170     /// a decentralized smart contract of community members to vote
171     /// @param contractAddress contract to removed from white list
172     function addAddressToWhiteList(address contractAddress) external {
173         require(isOwner() || factoryAddressWhiteList[msg.sender], "Can only be added by factory or owner");
174         require(!isWhiteListed[contractAddress], "Address must not be whitelisted");
175         isWhiteListed[contractAddress] = true;
176         addressWhiteList.push(contractAddress);
177         emit AddressAddedToWhitelist(contractAddress);
178     }
179 
180     /// @dev allows for the owner to add a new address of a factory responsible for creating new market contracts
181     /// @param factoryAddress address of factory to be allowed to add contracts to whitelist
182     function addFactoryAddress(address factoryAddress) external onlyOwner {
183         require(!factoryAddressWhiteList[factoryAddress], "address already added");
184         factoryAddressWhiteList[factoryAddress] = true;
185         emit FactoryAddressAdded(factoryAddress);
186     }
187 
188     /// @dev allows for the owner to remove an address of a factory
189     /// @param factoryAddress address of factory to be removed
190     function removeFactoryAddress(address factoryAddress) external onlyOwner {
191         require(factoryAddressWhiteList[factoryAddress], "factory address is not in the white list");
192         factoryAddressWhiteList[factoryAddress] = false;
193         emit FactoryAddressRemoved(factoryAddress);
194     }
195 }