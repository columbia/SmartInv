1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 import "./ICurvePool.sol";
5 
6 interface ICurveStableSwap3 is ICurvePool {
7     // Deployment
8     function __init__(
9         address _owner,
10         address[3] memory _coins,
11         address _pool_token,
12         uint256 _A,
13         uint256 _fee,
14         uint256 _admin_fee
15     ) external;
16 
17     // Public property getters
18     function get_balances() external view returns (uint256[3] memory);
19 
20     // 3Pool
21     function calc_token_amount(uint256[3] memory amounts, bool deposit) external view returns (uint256);
22 
23     function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external;
24 
25     function remove_liquidity(uint256 _amount, uint256[3] memory min_amounts) external;
26 
27     function remove_liquidity_imbalance(uint256[3] memory amounts, uint256 max_burn_amount) external;
28 }
