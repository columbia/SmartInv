1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "./IStabilityPool.sol";
6 
7 // Ref: https://github.com/backstop-protocol/dev/blob/main/packages/contracts/contracts/B.Protocol/BAMM.sol
8 interface IBAMM {
9     // Views
10 
11     /// @notice returns ETH price scaled by 1e18
12     function fetchPrice() external view returns (uint256);
13 
14     /// @notice returns amount of ETH received for an LUSD swap
15     function getSwapEthAmount(uint256 lusdQty) external view returns (uint256 ethAmount, uint256 feeEthAmount);
16 
17     /// @notice LUSD token address
18     function LUSD() external view returns (IERC20);
19 
20     /// @notice Liquity Stability Pool Address
21     function SP() external view returns (IStabilityPool);
22 
23     /// @notice BAMM shares held by user
24     function balanceOf(address account) external view returns (uint256);
25 
26     /// @notice total BAMM shares
27     function totalSupply() external view returns (uint256);
28 
29     /// @notice Reward token
30     function bonus() external view returns (address);
31 
32     // Mutative Functions
33 
34     /// @notice deposit LUSD for shares in BAMM
35     function deposit(uint256 lusdAmount) external;
36 
37     /// @notice withdraw shares  in BAMM for LUSD + ETH
38     function withdraw(uint256 numShares) external;
39 
40     /// @notice transfer shares
41     function transfer(address to, uint256 amount) external;
42 
43     /// @notice swap LUSD to ETH in BAMM
44     function swap(
45         uint256 lusdAmount,
46         uint256 minEthReturn,
47         address dest
48     ) external returns (uint256);
49 }
