1 // SPDX-License-Identifier: mit
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
73 /**
74  * Utility library of inline functions on addresses
75  *
76  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
77  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
78  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
79  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
80  */
81 library OpenZeppelinUpgradesAddress {
82     /**
83      * Returns whether the target address is a contract
84      * @dev This function will return false if invoked during the constructor of a contract,
85      * as the code is not actually created until after the constructor finishes.
86      * @param account address of the account to check
87      * @return whether the target address is a contract
88      */
89     function isContract(address account) internal view returns (bool) {
90         uint256 size;
91         // XXX Currently there is no better way to check if there is a contract in an address
92         // than to check the size of the code at that address.
93         // See https://ethereum.stackexchange.com/a/14016/36603
94         // for more details about how this works.
95         // TODO Check this again before the Serenity release, because all addresses will be
96         // contracts then.
97         // solhint-disable-next-line no-inline-assembly
98         assembly { size := extcodesize(account) }
99         return size > 0;
100     }
101 }
102 
103 /**
104  * @title BaseUpgradeabilityProxy
105  * @dev This contract implements a proxy that allows to change the
106  * implementation address to which it will delegate.
107  * Such a change is called an implementation upgrade.
108  */
109 contract BaseUpgradeabilityProxy is Proxy {
110   /**
111    * @dev Emitted when the implementation is upgraded.
112    * @param implementation Address of the new implementation.
113    */
114   event Upgraded(address indexed implementation);
115 
116   /**
117    * @dev Storage slot with the address of the current implementation.
118    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
119    * validated in the constructor.
120    */
121   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
122 
123   /**
124    * @dev Returns the current implementation.
125    * @return Address of the current implementation
126    */
127   function _implementation() internal view returns (address impl) {
128     bytes32 slot = IMPLEMENTATION_SLOT;
129     assembly {
130       impl := sload(slot)
131     }
132   }
133 
134   /**
135    * @dev Upgrades the proxy to a new implementation.
136    * @param newImplementation Address of the new implementation.
137    */
138   function _upgradeTo(address newImplementation) internal {
139     _setImplementation(newImplementation);
140     emit Upgraded(newImplementation);
141   }
142 
143   /**
144    * @dev Sets the implementation address of the proxy.
145    * @param newImplementation Address of the new implementation.
146    */
147   function _setImplementation(address newImplementation) internal {
148     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
149 
150     bytes32 slot = IMPLEMENTATION_SLOT;
151 
152     assembly {
153       sstore(slot, newImplementation)
154     }
155   }
156 }
157 
158 /**
159  * @title UpgradeabilityProxy
160  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
161  * implementation and init data.
162  */
163 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
164   /**
165    * @dev Contract constructor.
166    * @param _logic Address of the initial implementation.
167    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
168    * It should include the signature and the parameters of the function to be called, as described in
169    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
170    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
171    */
172   constructor(address _logic, bytes memory _data) public payable {
173     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
174     _setImplementation(_logic);
175     if(_data.length > 0) {
176       (bool success,) = _logic.delegatecall(_data);
177       require(success);
178     }
179   }  
180 }
181 
182 /*
183     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
184 
185     Licensed under the Apache License, Version 2.0 (the "License");
186     you may not use this file except in compliance with the License.
187     You may obtain a copy of the License at
188 
189     http://www.apache.org/licenses/LICENSE-2.0
190 
191     Unless required by applicable law or agreed to in writing, software
192     distributed under the License is distributed on an "AS IS" BASIS,
193     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
194     See the License for the specific language governing permissions and
195     limitations under the License.
196 */
197 contract Root is UpgradeabilityProxy {
198     constructor (address implementation) UpgradeabilityProxy(
199         implementation,
200         abi.encodeWithSignature("initialize()")
201     ) public { }
202 }