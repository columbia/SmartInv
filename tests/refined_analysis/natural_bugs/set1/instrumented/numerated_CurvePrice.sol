1 //SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 import {P} from "./P.sol";
6 import "contracts/interfaces/ICurve.sol";
7 import "contracts/libraries/Curve/LibCurve.sol";
8 
9 interface IERC20D {
10     function decimals() external view returns (uint8);
11 }
12 
13 interface IBDV {
14     function bdv(address token, uint256 amount) external view returns (uint256);
15 }
16 
17 contract CurvePrice {
18 
19     using SafeMath for uint256;
20 
21     //-------------------------------------------------------------------------------------------------------------------
22     // Mainnet
23     address private constant POOL = 0xc9C32cd16Bf7eFB85Ff14e0c8603cc90F6F2eE49;
24     address private constant CRV3_POOL = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
25     address private constant BEANSTALK = 0xC1E088fC1323b20BCBee9bd1B9fC9546db5624C5;
26     //-------------------------------------------------------------------------------------------------------------------
27 
28     uint256 private constant A_PRECISION = 100; 
29     uint256 private constant N_COINS  = 2;
30     uint256 private constant RATE_MULTIPLIER = 10 ** 30;
31     uint256 private constant PRECISION = 1e18;
32     uint256 private constant i = 0;
33     uint256 private constant j = 1;
34     address[2] private tokens = [0xBEA0000029AD1c77D3d5D23Ba2D8893dB9d1Efab, 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490];
35 
36     /**
37      * @notice Returns the non-manipulation resistant on-chain liquidiy, deltaB and price data for Bean
38      * in the Bean:3Crv Metapool.
39      * @dev No protocol should use this function to calculate manipulation resistant Bean price data.
40     **/
41     function getCurve() public view returns (P.Pool memory pool) {
42         pool.pool = POOL;
43         pool.tokens = tokens;
44         uint256[2] memory balances = ICurvePool(POOL).get_balances();
45         pool.balances = balances;
46         uint256[2] memory rates = getRates();
47         uint256[2] memory xp = LibCurve.getXP(balances, rates);
48         uint256 a = ICurvePool(POOL).A_precise();
49         uint256 D = getD(xp, a);
50 
51         pool.price = LibCurve.getPrice(xp, rates, a, D);
52         rates[0] = rates[0].mul(pool.price).div(1e6);
53         pool.liquidity = getCurveUSDValue(balances, rates);
54         pool.deltaB = getCurveDeltaB(balances[0], D);
55         pool.lpUsd = pool.liquidity * 1e18 / ICurvePool(POOL).totalSupply();
56         pool.lpBdv = IBDV(BEANSTALK).bdv(POOL, 1e18);
57     }
58 
59     function getCurveDeltaB(uint256 balance, uint256 D) private pure returns (int deltaB) {
60         uint256 pegBeans = D / 2 / 1e12;
61         deltaB = int256(pegBeans) - int256(balance);
62     }
63 
64     function getCurveUSDValue(uint256[2] memory balances, uint256[2] memory rates) private pure returns (uint) {
65         uint256[2] memory value = LibCurve.getXP(balances, rates);
66         return (value[0] + value[1]) / 1e12;
67     }
68 
69     function getD(uint256[2] memory xp, uint256 a) private pure returns (uint D) {
70         
71         /*  
72         * D invariant calculation in non-overflowing integer operations
73         * iteratively
74         *
75         * A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
76         *
77         * Converging solution:
78         * D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
79         */
80         uint256 S;
81         uint256 Dprev;
82         for (uint _i = 0; _i < xp.length; _i++) {
83             S += xp[_i];
84         }
85         if (S == 0) return 0;
86 
87         D = S;
88         uint256 Ann = a * N_COINS;
89         for (uint _i = 0; _i < 256; _i++) {
90             uint256 D_P = D;
91             for (uint _j = 0; _j < xp.length; _j++) {
92                 D_P = D_P * D / (xp[_j] * N_COINS);  // If division by 0, this will be borked: only withdrawal will work. And that is good
93             }
94             Dprev = D;
95             D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P);
96             // Equality with the precision of 1
97             if (D > Dprev && D - Dprev <= 1) return D;
98             else if (Dprev - D <= 1) return D;
99         }
100         // convergence typically occurs in 4 rounds or less, this should be unreachable!
101         // if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
102         require(false, "Price: Convergence false");
103     }
104 
105     function getRates() private view returns (uint256[2] memory rates) {
106         uint8 decimals = IERC20D(tokens[0]).decimals();
107         return [10**(36-decimals), I3Curve(CRV3_POOL).get_virtual_price()];
108     }
109 }
