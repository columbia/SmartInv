1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockERC20.sol";
5 
6 contract MockCurve3pool is MockERC20 {
7     address[3] public coins;
8     uint256 public slippage = 0; // in bp
9 
10     constructor(
11         address _dai,
12         address _usdc,
13         address _usdt
14     ) {
15         coins[0] = _dai;
16         coins[1] = _usdc;
17         coins[2] = _usdt;
18     }
19 
20     function set_slippage(uint256 _slippage) public {
21         slippage = _slippage;
22     }
23 
24     function add_liquidity(
25         uint256[3] memory amounts,
26         uint256 /* min_mint_amount*/
27     ) public {
28         IERC20(coins[0]).transferFrom(msg.sender, address(this), amounts[0]);
29         IERC20(coins[1]).transferFrom(msg.sender, address(this), amounts[1]);
30         IERC20(coins[2]).transferFrom(msg.sender, address(this), amounts[2]);
31         uint256 totalTokens = ((amounts[0] + amounts[1] + amounts[2]) * (10000 - slippage)) / 10000;
32         MockERC20(this).mint(msg.sender, totalTokens);
33     }
34 
35     function balances(uint256 i) public view returns (uint256) {
36         return IERC20(coins[i]).balanceOf(address(this));
37     }
38 
39     function remove_liquidity(
40         uint256 _amount,
41         uint256[3] memory /* min_amounts*/
42     ) public {
43         uint256[3] memory amounts;
44         amounts[0] = _amount / 3;
45         amounts[1] = _amount / 3;
46         amounts[2] = _amount / 3;
47         IERC20(coins[0]).transfer(msg.sender, amounts[0]);
48         IERC20(coins[1]).transfer(msg.sender, amounts[1]);
49         IERC20(coins[2]).transfer(msg.sender, amounts[2]);
50         MockERC20(this).mockBurn(msg.sender, _amount);
51     }
52 
53     function remove_liquidity_one_coin(
54         uint256 _amount,
55         int128 i,
56         uint256 /* min_amount*/
57     ) public {
58         uint256 _amountOut = (_amount * (10000 - slippage)) / 10000;
59         _amountOut = (_amountOut * 100000) / 100015; // 0.015% fee
60         IERC20(coins[uint256(uint128(i))]).transfer(msg.sender, _amountOut);
61         MockERC20(this).mockBurn(msg.sender, _amount);
62     }
63 
64     function get_virtual_price() public pure returns (uint256) {
65         return 1000000000000000000;
66     }
67 
68     function calc_withdraw_one_coin(
69         uint256 _token_amount,
70         int128 /* i*/
71     ) public view returns (uint256) {
72         uint256 _amountOut = (_token_amount * (10000 - slippage)) / 10000;
73         _amountOut = (_amountOut * 100000) / 100015; // 0.015% fee
74         return _amountOut;
75     }
76 }
