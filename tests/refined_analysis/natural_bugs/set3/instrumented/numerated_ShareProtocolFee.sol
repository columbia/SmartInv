1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 import "../interfaces/IMasterRegistry.sol";
5 
6 abstract contract ShareProtocolFee {
7     IMasterRegistry public immutable MASTER_REGISTRY;
8     bytes32 public constant FEE_COLLECTOR_NAME =
9         0x466565436f6c6c6563746f720000000000000000000000000000000000000000;
10     address public feeCollector;
11 
12     constructor(IMasterRegistry _masterRegistry) public {
13         MASTER_REGISTRY = _masterRegistry;
14         _updateFeeCollectorCache(_masterRegistry);
15     }
16 
17     /**
18      * @notice Updates cached address of the fee collector
19      */
20     function updateFeeCollectorCache() public payable virtual {
21         _updateFeeCollectorCache(MASTER_REGISTRY);
22     }
23 
24     function _updateFeeCollectorCache(IMasterRegistry masterRegistry)
25         internal
26         virtual
27     {
28         address _feeCollector = masterRegistry.resolveNameToLatestAddress(
29             FEE_COLLECTOR_NAME
30         );
31         require(_feeCollector != address(0), "Fee collector cannot be empty");
32         feeCollector = _feeCollector;
33     }
34 
35     /**
36      * @notice Withdraws admin fees to appropriate addresses
37      */
38     function withdrawAdminFees() external payable virtual;
39 }
