1 pragma solidity ^0.8.0;
2 
3 import "../../staking/ITribalChief.sol";
4 import "../../refs/CoreRef.sol";
5 import "../../external/fuse/Unitroller.sol";
6 import "../../staking/StakingTokenWrapper.sol";
7 import "./IRewardsDistributorAdmin.sol";
8 
9 /// @notice Controller Contract to set tribe per block in Rewards Distributor Admin on Rari
10 contract AutoRewardsDistributorV2 is CoreRef {
11     /// @notice rewards distributor admin contract
12     IRewardsDistributorAdmin public rewardsDistributorAdmin;
13     /// @notice tribal chief contract
14     ITribalChief public immutable tribalChief;
15     /// @notice address of the underlying token for the cToken this contract controls rewards for
16     address public immutable underlying;
17     /// @notice boolean which decides the action to incentivize
18     bool public immutable isBorrowIncentivized;
19 
20     /// @notice address of the comptroller, used to determine cToken
21     Unitroller public immutable comptroller;
22 
23     /// @notice address of the stakedTokenWrapper
24     StakingTokenWrapper public immutable stakedTokenWrapper;
25 
26     /// @notice address of the cToken this contract controls rewards for
27     address public cTokenAddress;
28 
29     /// @notice reward index on tribal chief to grab this staked token wrapper's index
30     uint256 public tribalChiefRewardIndex;
31 
32     event SpeedChanged(uint256 newSpeed);
33     event RewardsDistributorAdminChanged(
34         IRewardsDistributorAdmin oldRewardsDistributorAdmin,
35         IRewardsDistributorAdmin newRewardsDistributorAdmin
36     );
37 
38     /// @notice constructor function
39     /// @param coreAddress address of core contract
40     /// @param _rewardsDistributorAdmin address of rewards distributor admin contract
41     /// @param _tribalChief address of tribalchief contract
42     /// @param _stakedTokenWrapper the stakedTokenWrapper this contract controls rewards for
43     /// @param _underlying address of the underlying for the cToken
44     /// @param _isBorrowIncentivized boolean that incentivizes borrow or supply
45     /// @param _comptroller address of the comptroller contract
46     constructor(
47         address coreAddress,
48         IRewardsDistributorAdmin _rewardsDistributorAdmin,
49         ITribalChief _tribalChief,
50         StakingTokenWrapper _stakedTokenWrapper,
51         address _underlying,
52         bool _isBorrowIncentivized,
53         Unitroller _comptroller
54     ) CoreRef(coreAddress) {
55         isBorrowIncentivized = _isBorrowIncentivized;
56         underlying = _underlying;
57         stakedTokenWrapper = _stakedTokenWrapper;
58         rewardsDistributorAdmin = _rewardsDistributorAdmin;
59         tribalChief = _tribalChief;
60         comptroller = _comptroller;
61 
62         _setContractAdminRole(keccak256("TRIBAL_CHIEF_ADMIN_ROLE"));
63     }
64 
65     function init() external {
66         tribalChiefRewardIndex = stakedTokenWrapper.pid();
67         require(tribalChiefRewardIndex != 0, "pid");
68 
69         cTokenAddress = comptroller.cTokensByUnderlying(underlying);
70         require(cTokenAddress != address(0), "ctoken");
71     }
72 
73     /// @notice helper function that gets all needed state from the TribalChief contract
74     /// based on this state, it then calculates what the compSpeed should be.
75     function _deriveRequiredCompSpeed() internal view returns (uint256 compSpeed) {
76         (, , , uint120 poolAllocPoints, ) = tribalChief.poolInfo(tribalChiefRewardIndex);
77         uint256 totalAllocPoints = tribalChief.totalAllocPoint();
78         uint256 tribePerBlock = tribalChief.tribePerBlock();
79 
80         if (totalAllocPoints == 0) {
81             compSpeed = 0;
82         } else {
83             compSpeed = (tribePerBlock * poolAllocPoints) / totalAllocPoints;
84         }
85     }
86 
87     /// @notice function to get the new comp speed and figure out if an update is needed
88     /// @return newCompSpeed the newly calculated compSpeed based on allocation points in the TribalChief
89     /// @return updateNeeded boolean indicating whether the new compSpeed is not equal to the existing compSpeed
90     function getNewRewardSpeed() public view returns (uint256 newCompSpeed, bool updateNeeded) {
91         newCompSpeed = _deriveRequiredCompSpeed();
92         uint256 actualCompSpeed;
93 
94         if (isBorrowIncentivized) {
95             actualCompSpeed = rewardsDistributorAdmin.compBorrowSpeeds(cTokenAddress);
96         } else {
97             actualCompSpeed = rewardsDistributorAdmin.compSupplySpeeds(cTokenAddress);
98         }
99 
100         if (actualCompSpeed != newCompSpeed) {
101             updateNeeded = true;
102         }
103     }
104 
105     /// @notice function to automatically set the rewards speed on the RewardsDistributor contract
106     /// through the RewardsDistributorAdmin
107     function setAutoRewardsDistribution() external whenNotPaused {
108         require(cTokenAddress != address(0), "init");
109         (uint256 compSpeed, bool updateNeeded) = getNewRewardSpeed();
110         require(updateNeeded, "AutoRewardsDistributor: update not needed");
111 
112         if (isBorrowIncentivized) {
113             rewardsDistributorAdmin._setCompBorrowSpeed(cTokenAddress, compSpeed);
114         } else {
115             rewardsDistributorAdmin._setCompSupplySpeed(cTokenAddress, compSpeed);
116         }
117         emit SpeedChanged(compSpeed);
118     }
119 
120     /// @notice API to point to a new rewards distributor admin contract
121     /// @param _newRewardsDistributorAdmin the address of the new RewardsDistributorAdmin contract
122     function setRewardsDistributorAdmin(IRewardsDistributorAdmin _newRewardsDistributorAdmin)
123         external
124         onlyGovernorOrAdmin
125     {
126         IRewardsDistributorAdmin oldRewardsDistributorAdmin = rewardsDistributorAdmin;
127         rewardsDistributorAdmin = _newRewardsDistributorAdmin;
128         emit RewardsDistributorAdminChanged(oldRewardsDistributorAdmin, _newRewardsDistributorAdmin);
129     }
130 }
