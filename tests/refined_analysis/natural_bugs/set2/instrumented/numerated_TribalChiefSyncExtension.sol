1 pragma solidity ^0.8.0;
2 
3 import "./TribalChiefSyncV2.sol";
4 
5 /**
6     @title TribalChiefSyncExtension supports multiple auto-reward-distributors
7     @author joeysantoro
8 
9     @notice Include the autoRewardsDistributors with the TribalChiefSyncV2 permissionless functions. 
10     The TribalChiefSyncExtension will sync the autoRewardsDistributors after completing the main sync
11  */
12 contract TribalChiefSyncExtension {
13     TribalChiefSyncV2 public immutable tribalChiefSync;
14 
15     constructor(TribalChiefSyncV2 _tribalChiefSync) {
16         tribalChiefSync = _tribalChiefSync;
17     }
18 
19     modifier update(IAutoRewardsDistributor[] calldata distributors) {
20         _;
21         unchecked {
22             for (uint256 i = 0; i < distributors.length; i++) {
23                 distributors[i].setAutoRewardsDistribution();
24             }
25         }
26     }
27 
28     /// @notice Sync a rewards rate change automatically using pre-approved map
29     function autoDecreaseRewards(IAutoRewardsDistributor[] calldata distributors) external update(distributors) {
30         tribalChiefSync.autoDecreaseRewards();
31     }
32 
33     /// @notice Sync a rewards rate change
34     function decreaseRewards(
35         uint256 tribePerBlock,
36         bytes32 salt,
37         IAutoRewardsDistributor[] calldata distributors
38     ) external update(distributors) {
39         tribalChiefSync.decreaseRewards(tribePerBlock, salt);
40     }
41 
42     /// @notice Sync a pool addition
43     function addPool(
44         uint120 allocPoint,
45         address stakedToken,
46         address rewarder,
47         TribalChiefSyncV2.RewardData[] calldata rewardData,
48         bytes32 salt,
49         IAutoRewardsDistributor[] calldata distributors
50     ) external update(distributors) {
51         tribalChiefSync.addPool(allocPoint, stakedToken, rewarder, rewardData, salt);
52     }
53 
54     /// @notice Sync a pool set action
55     function setPool(
56         uint256 pid,
57         uint120 allocPoint,
58         IRewarder rewarder,
59         bool overwrite,
60         bytes32 salt,
61         IAutoRewardsDistributor[] calldata distributors
62     ) external update(distributors) {
63         tribalChiefSync.setPool(pid, allocPoint, rewarder, overwrite, salt);
64     }
65 
66     /// @notice Sync a pool reset rewards action
67     function resetPool(
68         uint256 pid,
69         bytes32 salt,
70         IAutoRewardsDistributor[] calldata distributors
71     ) external update(distributors) {
72         tribalChiefSync.resetPool(pid, salt);
73     }
74 }
