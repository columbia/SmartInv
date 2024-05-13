1 pragma solidity ^0.8.4;
2 
3 import "./PriceBoundPSM.sol";
4 
5 contract FixedPricePSM is PriceBoundPSM {
6     using Decimal for Decimal.D256;
7 
8     constructor(
9         uint256 _floor,
10         uint256 _ceiling,
11         OracleParams memory _params,
12         uint256 _mintFeeBasisPoints,
13         uint256 _redeemFeeBasisPoints,
14         uint256 _reservesThreshold,
15         uint256 _feiLimitPerSecond,
16         uint256 _mintingBufferCap,
17         IERC20 _underlyingToken,
18         IPCVDeposit _surplusTarget
19     )
20         PriceBoundPSM(
21             _floor,
22             _ceiling,
23             _params,
24             _mintFeeBasisPoints,
25             _redeemFeeBasisPoints,
26             _reservesThreshold,
27             _feiLimitPerSecond,
28             _mintingBufferCap,
29             _underlyingToken,
30             _surplusTarget
31         )
32     {}
33 
34     // ----------- Internal Methods -----------
35 
36     /// @notice helper function to get mint amount out based on current market prices
37     /// @dev will revert if price is outside of bounds and bounded PSM is being used
38     function _getMintAmountOut(uint256 amountIn) internal view virtual override returns (uint256 amountFeiOut) {
39         Decimal.D256 memory price = readOracle();
40         _validatePriceRange(price);
41 
42         amountFeiOut = Decimal
43             .one()
44             .mul(amountIn)
45             .mul(Constants.BASIS_POINTS_GRANULARITY - mintFeeBasisPoints)
46             .div(Constants.BASIS_POINTS_GRANULARITY)
47             .asUint256();
48     }
49 
50     /// @notice helper function to get redeem amount out based on current market prices
51     /// @dev will revert if price is outside of bounds and bounded PSM is being used
52     function _getRedeemAmountOut(uint256 amountFeiIn) internal view virtual override returns (uint256 amountTokenOut) {
53         Decimal.D256 memory price = readOracle();
54         _validatePriceRange(price);
55 
56         amountTokenOut = Decimal
57             .one()
58             .mul(amountFeiIn)
59             .mul(Constants.BASIS_POINTS_GRANULARITY - redeemFeeBasisPoints)
60             .div(Constants.BASIS_POINTS_GRANULARITY)
61             .asUint256();
62     }
63 }
