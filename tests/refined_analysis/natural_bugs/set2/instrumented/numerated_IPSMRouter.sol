1 pragma solidity ^0.8.4;
2 
3 import "./IPegStabilityModule.sol";
4 import "../fei/IFei.sol";
5 
6 interface IPSMRouter {
7     // ---------- View-Only API ----------
8 
9     /// @notice reference to the PegStabilityModule that this router interacts with
10     function psm() external returns (IPegStabilityModule);
11 
12     /// @notice reference to the FEI contract used.
13     function fei() external returns (IFei);
14 
15     /// @notice calculate the amount of FEI out for a given `amountIn` of underlying
16     function getMintAmountOut(uint256 amountIn) external view returns (uint256 amountFeiOut);
17 
18     /// @notice calculate the amount of underlying out for a given `amountFeiIn` of FEI
19     function getRedeemAmountOut(uint256 amountFeiIn) external view returns (uint256 amountOut);
20 
21     /// @notice the maximum mint amount out
22     function getMaxMintAmountOut() external view returns (uint256);
23 
24     /// @notice the maximum redeem amount out
25     function getMaxRedeemAmountOut() external view returns (uint256);
26 
27     // ---------- State-Changing API ----------
28 
29     /// @notice Mints fei to the given address, with a minimum amount required
30     /// @dev This wraps ETH and then calls into the PSM to mint the fei. We return the amount of fei minted.
31     /// @param _to The address to mint fei to
32     /// @param _minAmountOut The minimum amount of fei to mint
33     function mint(
34         address _to,
35         uint256 _minAmountOut,
36         uint256 ethAmountIn
37     ) external payable returns (uint256);
38 
39     /// @notice Redeems fei for ETH
40     /// First pull user FEI into this contract
41     /// Then call redeem on the PSM to turn the FEI into weth
42     /// Withdraw all weth to eth in the router
43     /// Send the eth to the specified recipient
44     /// @param to the address to receive the eth
45     /// @param amountFeiIn the amount of FEI to redeem
46     /// @param minAmountOut the minimum amount of weth to receive
47     function redeem(
48         address to,
49         uint256 amountFeiIn,
50         uint256 minAmountOut
51     ) external returns (uint256 amountOut);
52 }
