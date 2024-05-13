1 pragma solidity ^0.8.0;
2 
3 import "../../staking/ITribalChief.sol";
4 import "../../refs/CoreRef.sol";
5 import "./IRewardsDistributorAdmin.sol";
6 
7 /// @notice Controller Contract to set tribe per block in Rewards Distributor Admin on Rari
8 contract AutoRewardsDistributor is CoreRef {
9     /// @notice rewards distributor admin contract
10     IRewardsDistributorAdmin public rewardsDistributorAdmin;
11     /// @notice tribal chief contract
12     ITribalChief public immutable tribalChief;
13     /// @notice address of the CToken this contract controls rewards for
14     address public immutable cTokenAddress;
15     /// @notice boolean which decides the action to incentivize
16     bool public immutable isBorrowIncentivized;
17     /// @notice reward index on tribal chief to grab this staked token wrapper's index
18     uint256 public immutable tribalChiefRewardIndex;
19 
20     event SpeedChanged(uint256 newSpeed);
21     event RewardsDistributorAdminChanged(
22         IRewardsDistributorAdmin oldRewardsDistributorAdmin,
23         IRewardsDistributorAdmin newRewardsDistributorAdmin
24     );
25 
26     /// @notice constructor function
27     /// @param coreAddress address of core contract
28     /// @param _rewardsDistributorAdmin address of rewards distributor admin contract
29     /// @param _tribalChief address of tribalchief contract
30     /// @param _tribalChiefRewardIndex index for this contract's rewards in tribalchief
31     /// @param _cTokenAddress address of ctoken contract to incentivize
32     /// @param _isBorrowIncentivized boolean that incentivizes borrow or supply
33     constructor(
34         address coreAddress,
35         IRewardsDistributorAdmin _rewardsDistributorAdmin,
36         ITribalChief _tribalChief,
37         uint256 _tribalChiefRewardIndex,
38         address _cTokenAddress,
39         bool _isBorrowIncentivized
40     ) CoreRef(coreAddress) {
41         isBorrowIncentivized = _isBorrowIncentivized;
42         cTokenAddress = _cTokenAddress;
43         tribalChiefRewardIndex = _tribalChiefRewardIndex;
44         rewardsDistributorAdmin = _rewardsDistributorAdmin;
45         tribalChief = _tribalChief;
46 
47         _setContractAdminRole(keccak256("TRIBAL_CHIEF_ADMIN_ROLE"));
48     }
49 
50     /// @notice helper function that gets all needed state from the TribalChief contract
51     /// based on this state, it then calculates what the compSpeed should be.
52     function _deriveRequiredCompSpeed() internal view returns (uint256 compSpeed) {
53         (, , , uint120 poolAllocPoints, ) = tribalChief.poolInfo(tribalChiefRewardIndex);
54         uint256 totalAllocPoints = tribalChief.totalAllocPoint();
55         uint256 tribePerBlock = tribalChief.tribePerBlock();
56 
57         if (totalAllocPoints == 0) {
58             compSpeed = 0;
59         } else {
60             compSpeed = (tribePerBlock * poolAllocPoints) / totalAllocPoints;
61         }
62     }
63 
64     /// @notice function to get the new comp speed and figure out if an update is needed
65     /// @return newCompSpeed the newly calculated compSpeed based on allocation points in the TribalChief
66     /// @return updateNeeded boolean indicating whether the new compSpeed is not equal to the existing compSpeed
67     function getNewRewardSpeed() public view returns (uint256 newCompSpeed, bool updateNeeded) {
68         newCompSpeed = _deriveRequiredCompSpeed();
69         uint256 actualCompSpeed;
70 
71         if (isBorrowIncentivized) {
72             actualCompSpeed = rewardsDistributorAdmin.compBorrowSpeeds(cTokenAddress);
73         } else {
74             actualCompSpeed = rewardsDistributorAdmin.compSupplySpeeds(cTokenAddress);
75         }
76 
77         if (actualCompSpeed != newCompSpeed) {
78             updateNeeded = true;
79         }
80     }
81 
82     /// @notice function to automatically set the rewards speed on the RewardsDistributor contract
83     /// through the RewardsDistributorAdmin
84     function setAutoRewardsDistribution() external whenNotPaused {
85         (uint256 compSpeed, bool updateNeeded) = getNewRewardSpeed();
86         require(updateNeeded, "AutoRewardsDistributor: update not needed");
87 
88         if (isBorrowIncentivized) {
89             rewardsDistributorAdmin._setCompBorrowSpeed(cTokenAddress, compSpeed);
90         } else {
91             rewardsDistributorAdmin._setCompSupplySpeed(cTokenAddress, compSpeed);
92         }
93         emit SpeedChanged(compSpeed);
94     }
95 
96     /// @notice API to point to a new rewards distributor admin contract
97     /// @param _newRewardsDistributorAdmin the address of the new RewardsDistributorAdmin contract
98     function setRewardsDistributorAdmin(IRewardsDistributorAdmin _newRewardsDistributorAdmin)
99         external
100         onlyGovernorOrAdmin
101     {
102         IRewardsDistributorAdmin oldRewardsDistributorAdmin = rewardsDistributorAdmin;
103         rewardsDistributorAdmin = _newRewardsDistributorAdmin;
104         emit RewardsDistributorAdminChanged(oldRewardsDistributorAdmin, _newRewardsDistributorAdmin);
105     }
106 }
