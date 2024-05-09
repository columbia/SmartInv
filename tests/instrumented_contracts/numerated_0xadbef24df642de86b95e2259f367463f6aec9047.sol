1 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
2 
3 pragma solidity ^0.5.17;
4 pragma experimental ABIEncoderV2;
5 
6 
7 /**
8  * @title Proxy
9  * @dev Implements delegation of calls to other contracts, with proper
10  * forwarding of return values and bubbling of failures.
11  * It defines a fallback function that delegates all calls to the address
12  * returned by the abstract _implementation() internal function.
13  */
14 contract Proxy {
15   /**
16    * @dev Fallback function.
17    * Implemented entirely in `_fallback`.
18    */
19   function () payable external {
20     _fallback();
21   }
22 
23   /**
24    * @return The Address of the implementation.
25    */
26   function _implementation() internal view returns (address);
27 
28   /**
29    * @dev Delegates execution to an implementation contract.
30    * This is a low level function that doesn't return to its internal call site.
31    * It will return to the external caller whatever the implementation returns.
32    * @param implementation Address to delegate.
33    */
34   function _delegate(address implementation) internal {
35     assembly {
36       // Copy msg.data. We take full control of memory in this inline assembly
37       // block because it will not return to Solidity code. We overwrite the
38       // Solidity scratch pad at memory position 0.
39       calldatacopy(0, 0, calldatasize)
40 
41       // Call the implementation.
42       // out and outsize are 0 because we don't know the size yet.
43       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
44 
45       // Copy the returned data.
46       returndatacopy(0, 0, returndatasize)
47 
48       switch result
49       // delegatecall returns 0 on error.
50       case 0 { revert(0, returndatasize) }
51       default { return(0, returndatasize) }
52     }
53   }
54 
55   /**
56    * @dev Function that is run as the first thing in the fallback function.
57    * Can be redefined in derived contracts to add functionality.
58    * Redefinitions must call super._willFallback().
59    */
60   function _willFallback() internal {
61   }
62 
63   /**
64    * @dev fallback implementation.
65    * Extracted to enable manual triggering.
66    */
67   function _fallback() internal {
68     _willFallback();
69     _delegate(_implementation());
70   }
71 }
72 
73 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
74 
75 
76 
77 /**
78  * Utility library of inline functions on addresses
79  *
80  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
81  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
82  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
83  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
84  */
85 library OpenZeppelinUpgradesAddress {
86     /**
87      * Returns whether the target address is a contract
88      * @dev This function will return false if invoked during the constructor of a contract,
89      * as the code is not actually created until after the constructor finishes.
90      * @param account address of the account to check
91      * @return whether the target address is a contract
92      */
93     function isContract(address account) internal view returns (bool) {
94         uint256 size;
95         // XXX Currently there is no better way to check if there is a contract in an address
96         // than to check the size of the code at that address.
97         // See https://ethereum.stackexchange.com/a/14016/36603
98         // for more details about how this works.
99         // TODO Check this again before the Serenity release, because all addresses will be
100         // contracts then.
101         // solhint-disable-next-line no-inline-assembly
102         assembly { size := extcodesize(account) }
103         return size > 0;
104     }
105 }
106 
107 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
108 
109 
110 
111 
112 
113 /**
114  * @title BaseUpgradeabilityProxy
115  * @dev This contract implements a proxy that allows to change the
116  * implementation address to which it will delegate.
117  * Such a change is called an implementation upgrade.
118  */
119 contract BaseUpgradeabilityProxy is Proxy {
120   /**
121    * @dev Emitted when the implementation is upgraded.
122    * @param implementation Address of the new implementation.
123    */
124   event Upgraded(address indexed implementation);
125 
126   /**
127    * @dev Storage slot with the address of the current implementation.
128    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
129    * validated in the constructor.
130    */
131   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
132 
133   /**
134    * @dev Returns the current implementation.
135    * @return Address of the current implementation
136    */
137   function _implementation() internal view returns (address impl) {
138     bytes32 slot = IMPLEMENTATION_SLOT;
139     assembly {
140       impl := sload(slot)
141     }
142   }
143 
144   /**
145    * @dev Upgrades the proxy to a new implementation.
146    * @param newImplementation Address of the new implementation.
147    */
148   function _upgradeTo(address newImplementation) internal {
149     _setImplementation(newImplementation);
150     emit Upgraded(newImplementation);
151   }
152 
153   /**
154    * @dev Sets the implementation address of the proxy.
155    * @param newImplementation Address of the new implementation.
156    */
157   function _setImplementation(address newImplementation) internal {
158     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
159 
160     bytes32 slot = IMPLEMENTATION_SLOT;
161 
162     assembly {
163       sstore(slot, newImplementation)
164     }
165   }
166 }
167 
168 // File: @openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol
169 
170 
171 
172 
173 /**
174  * @title UpgradeabilityProxy
175  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
176  * implementation and init data.
177  */
178 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
179   /**
180    * @dev Contract constructor.
181    * @param _logic Address of the initial implementation.
182    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
183    * It should include the signature and the parameters of the function to be called, as described in
184    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
185    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
186    */
187   constructor(address _logic, bytes memory _data) public payable {
188     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
189     _setImplementation(_logic);
190     if(_data.length > 0) {
191       (bool success,) = _logic.delegatecall(_data);
192       require(success);
193     }
194   }  
195 }
196 
197 // File: contracts/dao/Root.sol
198 
199 /*
200     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
201 
202     Licensed under the Apache License, Version 2.0 (the "License");
203     you may not use this file except in compliance with the License.
204     You may obtain a copy of the License at
205 
206     http://www.apache.org/licenses/LICENSE-2.0
207 
208     Unless required by applicable law or agreed to in writing, software
209     distributed under the License is distributed on an "AS IS" BASIS,
210     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
211     See the License for the specific language governing permissions and
212     limitations under the License.
213 */
214 
215 
216 
217 
218 
219 contract Root is UpgradeabilityProxy {
220     constructor (address implementation) UpgradeabilityProxy(
221         implementation,
222         abi.encodeWithSignature("initialize()")
223     ) public { }
224 }