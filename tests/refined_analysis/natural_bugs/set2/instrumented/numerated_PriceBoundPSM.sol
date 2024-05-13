1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./PegStabilityModule.sol";
5 import "./IPriceBound.sol";
6 
7 /// @notice contract to create a price bound DAI PSM
8 /// This contract will allow swaps when the price of DAI is between 98 cents and 1.02 by default
9 /// These defaults are changeable by the admin and governance by calling floor and ceiling setters
10 /// setOracleFloor and setOracleCeiling
11 contract PriceBoundPSM is PegStabilityModule, IPriceBound {
12     using Decimal for Decimal.D256;
13     using SafeERC20 for IERC20;
14     using SafeCast for *;
15 
16     /// @notice the default minimum acceptable oracle price floor is 98 cents
17     uint256 public override floor;
18 
19     /// @notice the default maximum acceptable oracle price ceiling is $1.02
20     uint256 public override ceiling;
21 
22     /// @notice constructor
23     /// @param _floor minimum acceptable oracle price
24     /// @param _ceiling maximum  acceptable oracle price
25     /// @param _params PSM construction params
26     constructor(
27         uint256 _floor,
28         uint256 _ceiling,
29         OracleParams memory _params,
30         uint256 _mintFeeBasisPoints,
31         uint256 _redeemFeeBasisPoints,
32         uint256 _reservesThreshold,
33         uint256 _feiLimitPerSecond,
34         uint256 _mintingBufferCap,
35         IERC20 _underlyingToken,
36         IPCVDeposit _surplusTarget
37     )
38         PegStabilityModule(
39             _params,
40             _mintFeeBasisPoints,
41             _redeemFeeBasisPoints,
42             _reservesThreshold,
43             _feiLimitPerSecond,
44             _mintingBufferCap,
45             _underlyingToken,
46             _surplusTarget
47         )
48     {
49         _setCeilingBasisPoints(_ceiling);
50         _setFloorBasisPoints(_floor);
51     }
52 
53     /// @notice sets the floor price in BP
54     function setOracleFloorBasisPoints(uint256 newFloorBasisPoints) external override onlyGovernorOrAdmin {
55         _setFloorBasisPoints(newFloorBasisPoints);
56     }
57 
58     /// @notice sets the ceiling price in BP
59     function setOracleCeilingBasisPoints(uint256 newCeilingBasisPoints) external override onlyGovernorOrAdmin {
60         _setCeilingBasisPoints(newCeilingBasisPoints);
61     }
62 
63     function isPriceValid() external view override returns (bool) {
64         return _validPrice(readOracle());
65     }
66 
67     /// @notice Allocates a portion of escrowed PCV to a target PCV deposit
68     function _allocate(uint256 amount) internal override {
69         _transfer(address(surplusTarget), amount);
70 
71         emit AllocateSurplus(msg.sender, amount);
72     }
73 
74     /// @notice helper function to set the ceiling in basis points
75     function _setCeilingBasisPoints(uint256 newCeilingBasisPoints) internal {
76         require(newCeilingBasisPoints != 0, "PegStabilityModule: invalid ceiling");
77         require(
78             Decimal.ratio(newCeilingBasisPoints, Constants.BASIS_POINTS_GRANULARITY).greaterThan(
79                 Decimal.ratio(floor, Constants.BASIS_POINTS_GRANULARITY)
80             ),
81             "PegStabilityModule: ceiling must be greater than floor"
82         );
83         uint256 oldCeiling = ceiling;
84         ceiling = newCeilingBasisPoints;
85 
86         emit OracleCeilingUpdate(oldCeiling, ceiling);
87     }
88 
89     /// @notice helper function to set the floor in basis points
90     function _setFloorBasisPoints(uint256 newFloorBasisPoints) internal {
91         require(newFloorBasisPoints != 0, "PegStabilityModule: invalid floor");
92         require(
93             Decimal.ratio(newFloorBasisPoints, Constants.BASIS_POINTS_GRANULARITY).lessThan(
94                 Decimal.ratio(ceiling, Constants.BASIS_POINTS_GRANULARITY)
95             ),
96             "PegStabilityModule: floor must be less than ceiling"
97         );
98         uint256 oldFloor = floor;
99         floor = newFloorBasisPoints;
100 
101         emit OracleFloorUpdate(oldFloor, floor);
102     }
103 
104     /// @notice helper function to determine if price is within a valid range
105     function _validPrice(Decimal.D256 memory price) internal view returns (bool valid) {
106         valid =
107             price.greaterThan(Decimal.ratio(floor, Constants.BASIS_POINTS_GRANULARITY)) &&
108             price.lessThan(Decimal.ratio(ceiling, Constants.BASIS_POINTS_GRANULARITY));
109     }
110 
111     /// @notice reverts if the price is greater than or equal to the ceiling or less than or equal to the floor
112     function _validatePriceRange(Decimal.D256 memory price) internal view override {
113         require(_validPrice(price), "PegStabilityModule: price out of bounds");
114     }
115 }
