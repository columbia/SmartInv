1 //SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 import {P} from "./P.sol";
6 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
7 import {SafeCast} from "@openzeppelin/contracts/utils/SafeCast.sol";
8 import {Call, IWell, IERC20} from "../../interfaces/basin/IWell.sol";
9 import {IBeanstalkWellFunction} from "../../interfaces/basin/IBeanstalkWellFunction.sol";
10 import {LibUsdOracle} from "../../libraries/Oracle/LibUsdOracle.sol";
11 import {LibWell} from "../../libraries/Well/LibWell.sol";
12 import {C} from "../../C.sol";
13 
14 interface IBeanstalk {
15     function bdv(address token, uint256 amount) external view returns (uint256);
16 
17     function poolDeltaB(address pool) external view returns (int256);
18 }
19 
20 interface dec{
21     function decimals() external view returns (uint256);
22 }
23 
24 contract WellPrice {
25 
26     using SafeMath for uint256;
27     using SafeCast for uint256;
28 
29     IBeanstalk private constant BEANSTALK = IBeanstalk(0xC1E088fC1323b20BCBee9bd1B9fC9546db5624C5);
30     uint256 private constant WELL_DECIMALS = 1e18;
31     uint256 private constant PRICE_PRECISION = 1e6;
32 
33     struct Pool {
34         address pool;
35         address[2] tokens;
36         uint256[2] balances;
37         uint256 price;
38         uint256 liquidity;
39         int256 deltaB;
40         uint256 lpUsd;
41         uint256 lpBdv;
42     }
43 
44     /**
45      * @notice Returns the non-manipulation resistant on-chain liquidiy, deltaB and price data for
46      * Bean a given Well.
47      * @dev No protocol should use this function to calculate manipulation resistant Bean price data.
48     **/
49     function getConstantProductWell(address wellAddress) public view returns (P.Pool memory pool) {
50         IWell well = IWell(wellAddress);
51         pool.pool = wellAddress;
52         
53         IERC20[] memory wellTokens = well.tokens();
54         pool.tokens = [address(wellTokens[0]), address(wellTokens[1])];
55 
56         uint256[] memory wellBalances = well.getReserves();
57         pool.balances = [wellBalances[0], wellBalances[1]];
58 
59         uint256 beanIndex = LibWell.getBeanIndex(wellTokens);
60         uint256 tknIndex = beanIndex == 0 ? 1 : 0;
61 
62         // swap 1 bean of the opposite asset to get the usd price 
63         // price = amtOut/tknOutPrice
64         uint256 assetPrice = LibUsdOracle.getUsdPrice(pool.tokens[tknIndex]);
65         if (assetPrice > 0) {
66             pool.price = 
67             well.getSwapOut(wellTokens[beanIndex], wellTokens[tknIndex], 1e6)
68                 .mul(PRICE_PRECISION)
69                 .div(assetPrice);
70         }
71 
72         // liquidity is calculated by getting the usd value of the bean portion of the pool, 
73         // and multiplying by 2 to get the total liquidity of the pool.
74         pool.liquidity = 
75             pool.balances[beanIndex]
76             .mul(pool.price)
77             .mul(2)
78             .div(PRICE_PRECISION);
79 
80         pool.deltaB = getDeltaB(wellAddress, wellTokens, wellBalances);
81         pool.lpUsd = pool.liquidity.mul(WELL_DECIMALS).div(IERC20(wellAddress).totalSupply());
82         try BEANSTALK.bdv(wellAddress, WELL_DECIMALS) returns (uint256 bdv) {
83             pool.lpBdv = bdv;
84         } catch {}
85     }
86 
87     function getDeltaB(address well, IERC20[] memory tokens, uint256[] memory reserves) internal view returns (int256 deltaB) {
88         Call memory wellFunction = IWell(well).wellFunction();
89         (uint256[] memory ratios, uint256 beanIndex, bool success) = LibWell.getRatiosAndBeanIndex(tokens);
90         // If the USD Oracle oracle call fails, we can't compute deltaB
91         if (!success) return 0;
92 
93         uint256 beansAtPeg = IBeanstalkWellFunction(wellFunction.target).calcReserveAtRatioSwap(
94             reserves,
95             beanIndex,
96             ratios,
97             wellFunction.data
98         );
99 
100         deltaB = beansAtPeg.toInt256() - reserves[beanIndex].toInt256();
101     }
102 
103 }
