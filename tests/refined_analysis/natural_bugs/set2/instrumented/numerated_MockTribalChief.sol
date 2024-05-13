1 pragma solidity ^0.8.0;
2 pragma solidity ^0.8.0;
3 
4 contract MockTribalChief {
5     /// @dev allocation points of the pool
6     uint120 public poolAllocPoints;
7     /// @dev Total allocation points. Must be the sum of all allocation points in all pools.
8     uint256 public totalAllocPoint;
9 
10     /// @dev Amount of tribe to give out per block
11     uint256 private tribalChiefTribePerBlock;
12 
13     constructor(
14         uint256 _tribalChiefTribePerBlock,
15         uint256 _totalAllocPoint,
16         uint120 _poolAllocPoints
17     ) {
18         tribalChiefTribePerBlock = _tribalChiefTribePerBlock;
19         poolAllocPoints = _poolAllocPoints;
20         totalAllocPoint = _totalAllocPoint;
21     }
22 
23     function poolInfo(
24         uint256 /* _index*/
25     )
26         external
27         view
28         returns (
29             uint256,
30             uint256,
31             uint128,
32             uint120,
33             bool
34         )
35     {
36         return (0, 0, 0, poolAllocPoints, false);
37     }
38 
39     /// @notice Calculates and returns the `amount` of TRIBE per block.
40     function tribePerBlock() public view returns (uint256) {
41         return tribalChiefTribePerBlock;
42     }
43 
44     /// @notice set the total alloc points
45     function setTotalAllocPoint(uint256 newTotalAllocPoint) external {
46         totalAllocPoint = newTotalAllocPoint;
47     }
48 
49     /// @notice set the pool alloc points
50     function setPoolAllocPoints(uint120 newPoolAllocPoint) external {
51         poolAllocPoints = newPoolAllocPoint;
52     }
53 
54     /// @notice set the tribe per block
55     function setTribePerBlock(uint256 newTribePerBlock) external {
56         tribalChiefTribePerBlock = newTribePerBlock;
57     }
58 }
