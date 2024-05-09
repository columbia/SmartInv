1 // Dependency file: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
2 
3 // pragma solidity ^0.5.0;
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 contract Proxy {
13   /**
14    * @dev Fallback function.
15    * Implemented entirely in `_fallback`.
16    */
17   function () payable external {
18     _fallback();
19   }
20 
21   /**
22    * @return The Address of the implementation.
23    */
24   function _implementation() internal view returns (address);
25 
26   /**
27    * @dev Delegates execution to an implementation contract.
28    * This is a low level function that doesn't return to its internal call site.
29    * It will return to the external caller whatever the implementation returns.
30    * @param implementation Address to delegate.
31    */
32   function _delegate(address implementation) internal {
33     assembly {
34       // Copy msg.data. We take full control of memory in this inline assembly
35       // block because it will not return to Solidity code. We overwrite the
36       // Solidity scratch pad at memory position 0.
37       calldatacopy(0, 0, calldatasize)
38 
39       // Call the implementation.
40       // out and outsize are 0 because we don't know the size yet.
41       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
42 
43       // Copy the returned data.
44       returndatacopy(0, 0, returndatasize)
45 
46       switch result
47       // delegatecall returns 0 on error.
48       case 0 { revert(0, returndatasize) }
49       default { return(0, returndatasize) }
50     }
51   }
52 
53   /**
54    * @dev Function that is run as the first thing in the fallback function.
55    * Can be redefined in derived contracts to add functionality.
56    * Redefinitions must call super._willFallback().
57    */
58   function _willFallback() internal {
59   }
60 
61   /**
62    * @dev fallback implementation.
63    * Extracted to enable manual triggering.
64    */
65   function _fallback() internal {
66     _willFallback();
67     _delegate(_implementation());
68   }
69 }
70 
71 
72 // Dependency file: @openzeppelin/upgrades/contracts/utils/Address.sol
73 
74 // pragma solidity ^0.5.0;
75 
76 /**
77  * Utility library of inline functions on addresses
78  *
79  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
80  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
81  * when the user // imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
82  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
83  */
84 library OpenZeppelinUpgradesAddress {
85     /**
86      * Returns whether the target address is a contract
87      * @dev This function will return false if invoked during the constructor of a contract,
88      * as the code is not actually created until after the constructor finishes.
89      * @param account address of the account to check
90      * @return whether the target address is a contract
91      */
92     function isContract(address account) internal view returns (bool) {
93         uint256 size;
94         // XXX Currently there is no better way to check if there is a contract in an address
95         // than to check the size of the code at that address.
96         // See https://ethereum.stackexchange.com/a/14016/36603
97         // for more details about how this works.
98         // TODO Check this again before the Serenity release, because all addresses will be
99         // contracts then.
100         // solhint-disable-next-line no-inline-assembly
101         assembly { size := extcodesize(account) }
102         return size > 0;
103     }
104 }
105 
106 
107 // Dependency file: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
108 
109 // pragma solidity ^0.5.0;
110 
111 // import '/Users/khuyen/Documents/ProjectSecret/bsd/node_modules/@openzeppelin/upgrades/contracts/upgradeability/Proxy.sol';
112 // import '/Users/khuyen/Documents/ProjectSecret/bsd/node_modules/@openzeppelin/upgrades/contracts/utils/Address.sol';
113 
114 /**
115  * @title BaseUpgradeabilityProxy
116  * @dev This contract implements a proxy that allows to change the
117  * implementation address to which it will delegate.
118  * Such a change is called an implementation upgrade.
119  */
120 contract BaseUpgradeabilityProxy is Proxy {
121   /**
122    * @dev Emitted when the implementation is upgraded.
123    * @param implementation Address of the new implementation.
124    */
125   event Upgraded(address indexed implementation);
126 
127   /**
128    * @dev Storage slot with the address of the current implementation.
129    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
130    * validated in the constructor.
131    */
132   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
133 
134   /**
135    * @dev Returns the current implementation.
136    * @return Address of the current implementation
137    */
138   function _implementation() internal view returns (address impl) {
139     bytes32 slot = IMPLEMENTATION_SLOT;
140     assembly {
141       impl := sload(slot)
142     }
143   }
144 
145   /**
146    * @dev Upgrades the proxy to a new implementation.
147    * @param newImplementation Address of the new implementation.
148    */
149   function _upgradeTo(address newImplementation) internal {
150     _setImplementation(newImplementation);
151     emit Upgraded(newImplementation);
152   }
153 
154   /**
155    * @dev Sets the implementation address of the proxy.
156    * @param newImplementation Address of the new implementation.
157    */
158   function _setImplementation(address newImplementation) internal {
159     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
160 
161     bytes32 slot = IMPLEMENTATION_SLOT;
162 
163     assembly {
164       sstore(slot, newImplementation)
165     }
166   }
167 }
168 
169 
170 // Dependency file: @openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol
171 
172 // pragma solidity ^0.5.0;
173 
174 // import '/Users/khuyen/Documents/ProjectSecret/bsd/node_modules/@openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol';
175 
176 /**
177  * @title UpgradeabilityProxy
178  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
179  * implementation and init data.
180  */
181 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
182   /**
183    * @dev Contract constructor.
184    * @param _logic Address of the initial implementation.
185    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
186    * It should include the signature and the parameters of the function to be called, as described in
187    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
188    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
189    */
190   constructor(address _logic, bytes memory _data) public payable {
191     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
192     _setImplementation(_logic);
193     if(_data.length > 0) {
194       (bool success,) = _logic.delegatecall(_data);
195       require(success);
196     }
197   }  
198 }
199 
200 
201 // Root file: contracts/dao/Root.sol
202 
203 /*
204     Copyright 2020 BullProtocol Devs 
205 
206     Licensed under the Apache License, Version 2.0 (the "License");
207     you may not use this file except in compliance with the License.
208     You may obtain a copy of the License at
209 
210     http://www.apache.org/licenses/LICENSE-2.0
211 
212     Unless required by applicable law or agreed to in writing, software
213     distributed under the License is distributed on an "AS IS" BASIS,
214     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
215     See the License for the specific language governing permissions and
216     limitations under the License.
217 */
218 
219 pragma solidity ^0.5.17;
220 pragma experimental ABIEncoderV2;
221 
222 // import "@openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol";
223 
224 contract Root is UpgradeabilityProxy {
225     constructor (address implementation) UpgradeabilityProxy(
226         implementation,
227         abi.encodeWithSignature("initialize()")
228     ) public { }
229 }