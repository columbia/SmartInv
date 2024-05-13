1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity =0.7.6;
4 
5 interface ICurvePool {
6     function A_precise() external view returns (uint256);
7     function get_balances() external view returns (uint256[2] memory);
8     function totalSupply() external view returns (uint256);
9     function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount) external returns (uint256);
10     function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_amount) external returns (uint256);
11     function balances(int128 i) external view returns (uint256);
12     function fee() external view returns (uint256);
13     function coins(uint256 i) external view returns (address);
14     function get_virtual_price() external view returns (uint256);
15     function calc_token_amount(uint256[2] calldata amounts, bool deposit) external view returns (uint256);
16     function calc_withdraw_one_coin(uint256 _token_amount, int128 i) external view returns (uint256);
17     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns (uint256);
18     function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 }
21 
22 interface ICurveZap {
23     function add_liquidity(address _pool, uint256[4] memory _deposit_amounts, uint256 _min_mint_amount) external returns (uint256);
24     function calc_token_amount(address _pool, uint256[4] memory _amounts, bool _is_deposit) external returns (uint256);
25 }
26 
27 interface ICurvePoolR {
28     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy, address receiver) external returns (uint256);
29     function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy, address receiver) external returns (uint256);
30     function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_amount, address receiver) external returns (uint256);
31 }
32 
33 interface ICurvePool2R {
34     function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount, address reciever) external returns (uint256);
35     function remove_liquidity(uint256 _burn_amount, uint256[2] memory _min_amounts, address reciever) external returns (uint256[2] calldata);
36     function remove_liquidity_imbalance(uint256[2] memory _amounts, uint256 _max_burn_amount, address reciever) external returns (uint256);
37 }
38 
39 interface ICurvePool3R {
40     function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount, address reciever) external returns (uint256);
41     function remove_liquidity(uint256 _burn_amount, uint256[3] memory _min_amounts, address reciever) external returns (uint256[3] calldata);
42     function remove_liquidity_imbalance(uint256[3] memory _amounts, uint256 _max_burn_amount, address reciever) external returns (uint256);
43 }
44 
45 interface ICurvePool4R {
46     function add_liquidity(uint256[4] memory amounts, uint256 min_mint_amount, address reciever) external returns (uint256);
47     function remove_liquidity(uint256 _burn_amount, uint256[4] memory _min_amounts, address reciever) external returns (uint256[4] calldata);
48     function remove_liquidity_imbalance(uint256[4] memory _amounts, uint256 _max_burn_amount, address reciever) external returns (uint256);
49 }
50 
51 interface I3Curve {
52     function get_virtual_price() external view returns (uint256);
53 }
54 
55 interface ICurveFactory {
56     function get_coins(address _pool) external view returns (address[4] calldata);
57     function get_underlying_coins(address _pool) external view returns (address[8] calldata);
58 }
59 
60 interface ICurveCryptoFactory {
61     function get_coins(address _pool) external view returns (address[8] calldata);
62 }
63 
64 interface ICurvePoolC {
65     function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external returns (uint256);
66 }
67 
68 interface ICurvePoolNoReturn {
69     function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external;
70     function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external;
71     function remove_liquidity(uint256 _burn_amount, uint256[3] memory _min_amounts) external;
72     function remove_liquidity_imbalance(uint256[3] memory _amounts, uint256 _max_burn_amount) external;
73     function remove_liquidity_one_coin(uint256 _token_amount, uint256 i, uint256 min_amount) external;
74 }
75 
76 interface ICurvePoolNoReturn128 {
77     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
78     function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_amount) external;
79 }
