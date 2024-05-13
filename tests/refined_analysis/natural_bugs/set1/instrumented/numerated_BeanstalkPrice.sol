1 //SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 import "./CurvePrice.sol";
6 import {WellPrice, C, SafeMath} from "./WellPrice.sol";
7 
8 interface IWhitelistFacet {
9     function getWhitelistedWellLpTokens() external view returns (address[] memory tokens);
10 }
11 
12 contract BeanstalkPrice is CurvePrice, WellPrice {
13     using SafeMath for uint256;
14 
15     address immutable _beanstalk;
16 
17     constructor(address beanstalk) {
18         _beanstalk = beanstalk;
19     }
20 
21     struct Prices {
22         uint256 price;
23         uint256 liquidity;
24         int deltaB;
25         P.Pool[] ps;
26     }
27 
28     /**
29      * @notice Returns the non-manipulation resistant on-chain liquidiy, deltaB and price data for
30      * Bean in the following liquidity pools:
31      * - Curve Bean:3Crv Metapool
32      * - Constant Product Bean:Eth Well
33      * - Constant Product Bean:Wsteth Well
34      * NOTE: Assumes all whitelisted Wells are CP2 wells. Needs to be updated if this changes.
35      * @dev No protocol should use this function to calculate manipulation resistant Bean price data.
36     **/
37     function price() external view returns (Prices memory p) {
38 
39         address[] memory wells = IWhitelistFacet(_beanstalk).getWhitelistedWellLpTokens();
40         p.ps = new P.Pool[](1 + wells.length);
41         p.ps[0] = getCurve();
42         for (uint256 i = 0; i < wells.length; i++) {
43             // Assume all Wells are CP2 wells.
44             p.ps[i + 1] = getConstantProductWell(wells[i]);
45         }
46 
47         // assumes that liquidity and prices on all pools uses the same precision.
48         for (uint256 i = 0; i < p.ps.length; i++) {
49             p.price += p.ps[i].price.mul(p.ps[i].liquidity);
50             p.liquidity += p.ps[i].liquidity;
51             p.deltaB += p.ps[i].deltaB;
52         }
53         p.price =  p.price.div(p.liquidity);
54     }
55 }