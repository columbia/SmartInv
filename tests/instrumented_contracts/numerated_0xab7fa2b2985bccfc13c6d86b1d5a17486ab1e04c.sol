1 // File: contracts/hardworkInterface/IUpgradeSource.sol
2 
3 pragma solidity 0.5.16;
4 
5 interface IUpgradeSource {
6   function shouldUpgrade() external view returns (bool, address);
7   function finalizeUpgrade() external;
8 }
9 
10 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
11 
12 pragma solidity ^0.5.0;
13 
14 /**
15  * @title Proxy
16  * @dev Implements delegation of calls to other contracts, with proper
17  * forwarding of return values and bubbling of failures.
18  * It defines a fallback function that delegates all calls to the address
19  * returned by the abstract _implementation() internal function.
20  */
21 contract Proxy {
22   /**
23    * @dev Fallback function.
24    * Implemented entirely in `_fallback`.
25    */
26   function () payable external {
27     _fallback();
28   }
29 
30   /**
31    * @return The Address of the implementation.
32    */
33   function _implementation() internal view returns (address);
34 
35   /**
36    * @dev Delegates execution to an implementation contract.
37    * This is a low level function that doesn't return to its internal call site.
38    * It will return to the external caller whatever the implementation returns.
39    * @param implementation Address to delegate.
40    */
41   function _delegate(address implementation) internal {
42     assembly {
43       // Copy msg.data. We take full control of memory in this inline assembly
44       // block because it will not return to Solidity code. We overwrite the
45       // Solidity scratch pad at memory position 0.
46       calldatacopy(0, 0, calldatasize)
47 
48       // Call the implementation.
49       // out and outsize are 0 because we don't know the size yet.
50       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
51 
52       // Copy the returned data.
53       returndatacopy(0, 0, returndatasize)
54 
55       switch result
56       // delegatecall returns 0 on error.
57       case 0 { revert(0, returndatasize) }
58       default { return(0, returndatasize) }
59     }
60   }
61 
62   /**
63    * @dev Function that is run as the first thing in the fallback function.
64    * Can be redefined in derived contracts to add functionality.
65    * Redefinitions must call super._willFallback().
66    */
67   function _willFallback() internal {
68   }
69 
70   /**
71    * @dev fallback implementation.
72    * Extracted to enable manual triggering.
73    */
74   function _fallback() internal {
75     _willFallback();
76     _delegate(_implementation());
77   }
78 }
79 
80 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * Utility library of inline functions on addresses
86  *
87  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
88  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
89  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
90  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
91  */
92 library OpenZeppelinUpgradesAddress {
93     /**
94      * Returns whether the target address is a contract
95      * @dev This function will return false if invoked during the constructor of a contract,
96      * as the code is not actually created until after the constructor finishes.
97      * @param account address of the account to check
98      * @return whether the target address is a contract
99      */
100     function isContract(address account) internal view returns (bool) {
101         uint256 size;
102         // XXX Currently there is no better way to check if there is a contract in an address
103         // than to check the size of the code at that address.
104         // See https://ethereum.stackexchange.com/a/14016/36603
105         // for more details about how this works.
106         // TODO Check this again before the Serenity release, because all addresses will be
107         // contracts then.
108         // solhint-disable-next-line no-inline-assembly
109         assembly { size := extcodesize(account) }
110         return size > 0;
111     }
112 }
113 
114 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
115 
116 pragma solidity ^0.5.0;
117 
118 
119 
120 /**
121  * @title BaseUpgradeabilityProxy
122  * @dev This contract implements a proxy that allows to change the
123  * implementation address to which it will delegate.
124  * Such a change is called an implementation upgrade.
125  */
126 contract BaseUpgradeabilityProxy is Proxy {
127   /**
128    * @dev Emitted when the implementation is upgraded.
129    * @param implementation Address of the new implementation.
130    */
131   event Upgraded(address indexed implementation);
132 
133   /**
134    * @dev Storage slot with the address of the current implementation.
135    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
136    * validated in the constructor.
137    */
138   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
139 
140   /**
141    * @dev Returns the current implementation.
142    * @return Address of the current implementation
143    */
144   function _implementation() internal view returns (address impl) {
145     bytes32 slot = IMPLEMENTATION_SLOT;
146     assembly {
147       impl := sload(slot)
148     }
149   }
150 
151   /**
152    * @dev Upgrades the proxy to a new implementation.
153    * @param newImplementation Address of the new implementation.
154    */
155   function _upgradeTo(address newImplementation) internal {
156     _setImplementation(newImplementation);
157     emit Upgraded(newImplementation);
158   }
159 
160   /**
161    * @dev Sets the implementation address of the proxy.
162    * @param newImplementation Address of the new implementation.
163    */
164   function _setImplementation(address newImplementation) internal {
165     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
166 
167     bytes32 slot = IMPLEMENTATION_SLOT;
168 
169     assembly {
170       sstore(slot, newImplementation)
171     }
172   }
173 }
174 
175 // File: contracts/VaultProxy.sol
176 
177 pragma solidity 0.5.16;
178 
179 
180 
181 contract VaultProxy is BaseUpgradeabilityProxy {
182 
183   constructor(address _implementation) public {
184     _setImplementation(_implementation);
185   }
186 
187   /**
188   * The main logic. If the timer has elapsed and there is a schedule upgrade,
189   * the governance can upgrade the vault
190   */
191   function upgrade() external {
192     (bool should, address newImplementation) = IUpgradeSource(address(this)).shouldUpgrade();
193     require(should, "Upgrade not scheduled");
194     _upgradeTo(newImplementation);
195 
196     // the finalization needs to be executed on itself to update the storage of this proxy
197     // it also needs to be invoked by the governance, not by address(this), so delegatecall is needed
198     (bool success, bytes memory result) = address(this).delegatecall(
199       abi.encodeWithSignature("finalizeUpgrade()")
200     );
201 
202     require(success, "Issue when finalizing the upgrade");
203   }
204 
205   function implementation() external view returns (address) {
206     return _implementation();
207   }
208 }