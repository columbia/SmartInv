1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-05
3 */
4 
5 // File: contracts/hardworkInterface/IUpgradeSource.sol
6 
7 pragma solidity 0.5.16;
8 
9 interface IUpgradeSource {
10   function shouldUpgrade() external view returns (bool, address);
11   function finalizeUpgrade() external;
12 }
13 
14 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
15 
16 pragma solidity ^0.5.0;
17 
18 /**
19  * @title Proxy
20  * @dev Implements delegation of calls to other contracts, with proper
21  * forwarding of return values and bubbling of failures.
22  * It defines a fallback function that delegates all calls to the address
23  * returned by the abstract _implementation() internal function.
24  */
25 contract Proxy {
26   /**
27    * @dev Fallback function.
28    * Implemented entirely in `_fallback`.
29    */
30   function () payable external {
31     _fallback();
32   }
33 
34   /**
35    * @return The Address of the implementation.
36    */
37   function _implementation() internal view returns (address);
38 
39   /**
40    * @dev Delegates execution to an implementation contract.
41    * This is a low level function that doesn't return to its internal call site.
42    * It will return to the external caller whatever the implementation returns.
43    * @param implementation Address to delegate.
44    */
45   function _delegate(address implementation) internal {
46     assembly {
47       // Copy msg.data. We take full control of memory in this inline assembly
48       // block because it will not return to Solidity code. We overwrite the
49       // Solidity scratch pad at memory position 0.
50       calldatacopy(0, 0, calldatasize)
51 
52       // Call the implementation.
53       // out and outsize are 0 because we don't know the size yet.
54       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
55 
56       // Copy the returned data.
57       returndatacopy(0, 0, returndatasize)
58 
59       switch result
60       // delegatecall returns 0 on error.
61       case 0 { revert(0, returndatasize) }
62       default { return(0, returndatasize) }
63     }
64   }
65 
66   /**
67    * @dev Function that is run as the first thing in the fallback function.
68    * Can be redefined in derived contracts to add functionality.
69    * Redefinitions must call super._willFallback().
70    */
71   function _willFallback() internal {
72   }
73 
74   /**
75    * @dev fallback implementation.
76    * Extracted to enable manual triggering.
77    */
78   function _fallback() internal {
79     _willFallback();
80     _delegate(_implementation());
81   }
82 }
83 
84 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
85 
86 pragma solidity ^0.5.0;
87 
88 /**
89  * Utility library of inline functions on addresses
90  *
91  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
92  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
93  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
94  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
95  */
96 library OpenZeppelinUpgradesAddress {
97     /**
98      * Returns whether the target address is a contract
99      * @dev This function will return false if invoked during the constructor of a contract,
100      * as the code is not actually created until after the constructor finishes.
101      * @param account address of the account to check
102      * @return whether the target address is a contract
103      */
104     function isContract(address account) internal view returns (bool) {
105         uint256 size;
106         // XXX Currently there is no better way to check if there is a contract in an address
107         // than to check the size of the code at that address.
108         // See https://ethereum.stackexchange.com/a/14016/36603
109         // for more details about how this works.
110         // TODO Check this again before the Serenity release, because all addresses will be
111         // contracts then.
112         // solhint-disable-next-line no-inline-assembly
113         assembly { size := extcodesize(account) }
114         return size > 0;
115     }
116 }
117 
118 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
119 
120 pragma solidity ^0.5.0;
121 
122 
123 
124 /**
125  * @title BaseUpgradeabilityProxy
126  * @dev This contract implements a proxy that allows to change the
127  * implementation address to which it will delegate.
128  * Such a change is called an implementation upgrade.
129  */
130 contract BaseUpgradeabilityProxy is Proxy {
131   /**
132    * @dev Emitted when the implementation is upgraded.
133    * @param implementation Address of the new implementation.
134    */
135   event Upgraded(address indexed implementation);
136 
137   /**
138    * @dev Storage slot with the address of the current implementation.
139    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
140    * validated in the constructor.
141    */
142   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
143 
144   /**
145    * @dev Returns the current implementation.
146    * @return Address of the current implementation
147    */
148   function _implementation() internal view returns (address impl) {
149     bytes32 slot = IMPLEMENTATION_SLOT;
150     assembly {
151       impl := sload(slot)
152     }
153   }
154 
155   /**
156    * @dev Upgrades the proxy to a new implementation.
157    * @param newImplementation Address of the new implementation.
158    */
159   function _upgradeTo(address newImplementation) internal {
160     _setImplementation(newImplementation);
161     emit Upgraded(newImplementation);
162   }
163 
164   /**
165    * @dev Sets the implementation address of the proxy.
166    * @param newImplementation Address of the new implementation.
167    */
168   function _setImplementation(address newImplementation) internal {
169     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
170 
171     bytes32 slot = IMPLEMENTATION_SLOT;
172 
173     assembly {
174       sstore(slot, newImplementation)
175     }
176   }
177 }
178 
179 // File: contracts/VaultProxy.sol
180 
181 pragma solidity 0.5.16;
182 
183 
184 
185 contract VaultProxy is BaseUpgradeabilityProxy {
186 
187   constructor(address _implementation) public {
188     _setImplementation(_implementation);
189   }
190 
191   /**
192   * The main logic. If the timer has elapsed and there is a schedule upgrade,
193   * the governance can upgrade the vault
194   */
195   function upgrade() external {
196     (bool should, address newImplementation) = IUpgradeSource(address(this)).shouldUpgrade();
197     require(should, "Upgrade not scheduled");
198     _upgradeTo(newImplementation);
199 
200     // the finalization needs to be executed on itself to update the storage of this proxy
201     // it also needs to be invoked by the governance, not by address(this), so delegatecall is needed
202     (bool success, bytes memory result) = address(this).delegatecall(
203       abi.encodeWithSignature("finalizeUpgrade()")
204     );
205 
206     require(success, "Issue when finalizing the upgrade");
207   }
208 
209   function implementation() external view returns (address) {
210     return _implementation();
211   }
212 }