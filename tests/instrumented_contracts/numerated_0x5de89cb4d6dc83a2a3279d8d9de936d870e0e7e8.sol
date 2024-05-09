1 pragma solidity ^0.5.17;
2 pragma experimental ABIEncoderV2;
3 
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
71 /**
72  * Utility library of inline functions on addresses
73  *
74  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
75  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
76  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
77  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
78  */
79 library OpenZeppelinUpgradesAddress {
80     /**
81      * Returns whether the target address is a contract
82      * @dev This function will return false if invoked during the constructor of a contract,
83      * as the code is not actually created until after the constructor finishes.
84      * @param account address of the account to check
85      * @return whether the target address is a contract
86      */
87     function isContract(address account) internal view returns (bool) {
88         uint256 size;
89         // XXX Currently there is no better way to check if there is a contract in an address
90         // than to check the size of the code at that address.
91         // See https://ethereum.stackexchange.com/a/14016/36603
92         // for more details about how this works.
93         // TODO Check this again before the Serenity release, because all addresses will be
94         // contracts then.
95         // solhint-disable-next-line no-inline-assembly
96         assembly { size := extcodesize(account) }
97         return size > 0;
98     }
99 }
100 
101 /**
102  * @title BaseUpgradeabilityProxy
103  * @dev This contract implements a proxy that allows to change the
104  * implementation address to which it will delegate.
105  * Such a change is called an implementation upgrade.
106  */
107 contract BaseUpgradeabilityProxy is Proxy {
108   /**
109    * @dev Emitted when the implementation is upgraded.
110    * @param implementation Address of the new implementation.
111    */
112   event Upgraded(address indexed implementation);
113 
114   /**
115    * @dev Storage slot with the address of the current implementation.
116    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
117    * validated in the constructor.
118    */
119   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
120 
121   /**
122    * @dev Returns the current implementation.
123    * @return Address of the current implementation
124    */
125   function _implementation() internal view returns (address impl) {
126     bytes32 slot = IMPLEMENTATION_SLOT;
127     assembly {
128       impl := sload(slot)
129     }
130   }
131 
132   /**
133    * @dev Upgrades the proxy to a new implementation.
134    * @param newImplementation Address of the new implementation.
135    */
136   function _upgradeTo(address newImplementation) internal {
137     _setImplementation(newImplementation);
138     emit Upgraded(newImplementation);
139   }
140 
141   /**
142    * @dev Sets the implementation address of the proxy.
143    * @param newImplementation Address of the new implementation.
144    */
145   function _setImplementation(address newImplementation) internal {
146     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
147 
148     bytes32 slot = IMPLEMENTATION_SLOT;
149 
150     assembly {
151       sstore(slot, newImplementation)
152     }
153   }
154 }
155 
156 /**
157  * @title UpgradeabilityProxy
158  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
159  * implementation and init data.
160  */
161 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
162   /**
163    * @dev Contract constructor.
164    * @param _logic Address of the initial implementation.
165    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
166    * It should include the signature and the parameters of the function to be called, as described in
167    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
168    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
169    */
170   constructor(address _logic, bytes memory _data) public payable {
171     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
172     _setImplementation(_logic);
173     if(_data.length > 0) {
174       (bool success,) = _logic.delegatecall(_data);
175       require(success);
176     }
177   }  
178 }
179 
180 /*
181     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
182 
183     Licensed under the Apache License, Version 2.0 (the "License");
184     you may not use this file except in compliance with the License.
185     You may obtain a copy of the License at
186 
187     http://www.apache.org/licenses/LICENSE-2.0
188 
189     Unless required by applicable law or agreed to in writing, software
190     distributed under the License is distributed on an "AS IS" BASIS,
191     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
192     See the License for the specific language governing permissions and
193     limitations under the License.
194 */
195 contract Root is UpgradeabilityProxy {
196     constructor (address implementation) UpgradeabilityProxy(
197         implementation,
198         abi.encodeWithSignature("initialize()")
199     ) public { }
200 }