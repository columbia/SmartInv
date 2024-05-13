1 pragma solidity ^0.8.0;
2 
3 interface IRewardsDistributorAdmin {
4     /*** Set Admin ***/
5 
6     /**
7      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
8      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
9      * @param newPendingAdmin New pending admin.
10      */
11     function _setPendingAdmin(address newPendingAdmin) external;
12 
13     /**
14      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
15      * @dev Admin function for pending admin to accept role and update admin
16      */
17     function _acceptAdmin() external;
18 
19     /*** Comp Distribution ***/
20     /*** Comp Distribution Admin ***/
21 
22     /**
23      * @notice Transfer COMP to the recipient
24      * @dev Note: If there is not enough COMP, we do not perform the transfer all.
25      * @param recipient The address of the recipient to transfer COMP to
26      * @param amount The amount of COMP to (possibly) transfer
27      */
28     function _grantComp(address recipient, uint256 amount) external;
29 
30     /**
31      * @notice Set COMP speed for a single market
32      * @param cToken The market whose COMP speed to update
33      * @param compSpeed New COMP speed for market
34      */
35     function _setCompSupplySpeed(address cToken, uint256 compSpeed) external;
36 
37     /**
38      * @notice Set COMP speed for a single market
39      * @param cToken The market whose COMP speed to update
40      * @param compSpeed New COMP speed for market
41      */
42     function _setCompBorrowSpeed(address cToken, uint256 compSpeed) external;
43 
44     /**
45      * @notice Set COMP speed for a single contributor
46      * @param contributor The contributor whose COMP speed to update
47      * @param compSpeed New COMP speed for contributor
48      */
49     function _setContributorCompSpeed(address contributor, uint256 compSpeed) external;
50 
51     /**
52      * @notice Add a default market to claim rewards for in `claimRewards()`
53      * @param cToken The market to add
54      */
55     function _addMarket(address cToken) external;
56 
57     /// @notice The portion of compRate that each market currently receives
58     function compSupplySpeeds(address) external view returns (uint256);
59 
60     /// @notice The portion of compRate that each market currently receives
61     function compBorrowSpeeds(address) external view returns (uint256);
62 
63     /// @notice Set logic contract address
64     function _setImplementation(address implementation_) external;
65 
66     /// @notice Role for AutoRewardsDistributor contracts
67     function AUTO_REWARDS_DISTRIBUTOR_ROLE() external view returns (bytes32);
68 }
