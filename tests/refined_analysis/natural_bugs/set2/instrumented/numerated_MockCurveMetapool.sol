1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockERC20.sol";
5 
6 contract MockCurveMetapool is MockERC20 {
7     address[2] public coins;
8     uint256 public slippage = 0; // in bp
9 
10     constructor(address _3pool, address _fei) {
11         coins[0] = _3pool;
12         coins[1] = _fei;
13     }
14 
15     function set_slippage(uint256 _slippage) public {
16         slippage = _slippage;
17     }
18 
19     function add_liquidity(
20         uint256[2] memory amounts,
21         uint256 /* min_mint_amount*/
22     ) public {
23         IERC20(coins[0]).transferFrom(msg.sender, address(this), amounts[0]);
24         IERC20(coins[1]).transferFrom(msg.sender, address(this), amounts[1]);
25         uint256 totalTokens = ((amounts[0] + amounts[1]) * (10000 - slippage)) / 10000;
26         MockERC20(this).mint(msg.sender, totalTokens);
27     }
28 
29     function balances(uint256 i) public view returns (uint256) {
30         return IERC20(coins[i]).balanceOf(address(this));
31     }
32 
33     function remove_liquidity(
34         uint256 _amount,
35         uint256[2] memory /* min_amounts*/
36     ) public {
37         uint256[2] memory amounts;
38         amounts[0] = _amount / 2;
39         amounts[1] = _amount / 2;
40         IERC20(coins[0]).transfer(msg.sender, amounts[0]);
41         IERC20(coins[1]).transfer(msg.sender, amounts[1]);
42         MockERC20(this).burnFrom(msg.sender, _amount);
43     }
44 
45     function remove_liquidity_one_coin(
46         uint256 _amount,
47         int128 i,
48         uint256 /* min_amount*/
49     ) public {
50         uint256 _amountOut = (_amount * (10000 - slippage)) / 10000;
51         _amountOut = (_amountOut * 10000) / 10002; // 0.02% fee
52         IERC20(coins[uint256(uint128(i))]).transfer(msg.sender, _amountOut);
53         MockERC20(this).burnFrom(msg.sender, _amount);
54     }
55 
56     function get_virtual_price() public pure returns (uint256) {
57         return 1000000000000000000;
58     }
59 
60     function calc_withdraw_one_coin(
61         uint256 _token_amount,
62         int128 /* i*/
63     ) public view returns (uint256) {
64         uint256 _amountOut = (_token_amount * (10000 - slippage)) / 10000;
65         _amountOut = (_amountOut * 10000) / 10002; // 0.02% fee
66         return _amountOut;
67     }
68 }
