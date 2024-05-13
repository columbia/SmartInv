1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import './Proxy.sol';
6 import './Address.sol';
7 
8 /**
9  * @title BaseUpgradeabilityProxy
10  * @dev This contract implements a proxy that allows to change the
11  * implementation address to which it will delegate.
12  * Such a change is called an implementation upgrade.
13  */
14 contract BaseUpgradeabilityProxy is Proxy {
15   /**
16    * @dev Emitted when the implementation is upgraded.
17    * @param implementation Address of the new implementation.
18    */
19   event Upgraded(address indexed implementation);
20 
21   /**
22    * @dev Storage slot with the address of the current implementation.
23    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
24    * validated in the constructor.
25    */
26   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
27 
28   /**
29    * @dev Returns the current implementation.
30    * @return impl Address of the current implementation
31    */
32   function _implementation() internal view override returns (address impl) {
33     bytes32 slot = IMPLEMENTATION_SLOT;
34     assembly {
35       impl := sload(slot)
36     }
37   }
38 
39   /**
40    * @dev Upgrades the proxy to a new implementation.
41    * @param newImplementation Address of the new implementation.
42    */
43   function _upgradeTo(address newImplementation) internal {
44     _setImplementation(newImplementation);
45     emit Upgraded(newImplementation);
46   }
47 
48   /**
49    * @dev Sets the implementation address of the proxy.
50    * @param newImplementation Address of the new implementation.
51    */
52   function _setImplementation(address newImplementation) internal {
53     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
54 
55     bytes32 slot = IMPLEMENTATION_SLOT;
56 
57     assembly {
58       sstore(slot, newImplementation)
59     }
60   }
61 }
