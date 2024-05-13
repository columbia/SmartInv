1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {SafeMath} from "./SafeMath.sol";
12 import {DecimalMath} from "./DecimalMath.sol";
13 
14 /**
15  * @title DODOMath
16  * @author DODO Breeder
17  *
18  * @notice Functions for complex calculating. Including ONE Integration and TWO Quadratic solutions
19  */
20 library DODOMath {
21     using SafeMath for uint256;
22 
23     /*
24         Integrate dodo curve fron V1 to V2
25         require V0>=V1>=V2>0
26         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)
27         let V1-V2=delta
28         res = i*delta*(1-k+k(V0^2/V1/V2))
29     */
30     function _GeneralIntegrate(
31         uint256 V0,
32         uint256 V1,
33         uint256 V2,
34         uint256 i,
35         uint256 k
36     ) internal pure returns (uint256) {
37         uint256 fairAmount = DecimalMath.mul(i, V1.sub(V2)); // i*delta
38         uint256 V0V0V1V2 = DecimalMath.divCeil(V0.mul(V0).div(V1), V2);
39         uint256 penalty = DecimalMath.mul(k, V0V0V1V2); // k(V0^2/V1/V2)
40         return DecimalMath.mul(fairAmount, DecimalMath.ONE.sub(k).add(penalty));
41     }
42 
43     /*
44         The same with integration expression above, we have:
45         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
46         Given Q1 and deltaB, solve Q2
47         This is a quadratic function and the standard version is
48         aQ2^2 + bQ2 + c = 0, where
49         a=1-k
50         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB
51         c=-kQ0^2
52         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)
53         note: another root is negative, abondan
54         if deltaBSig=true, then Q2>Q1
55         if deltaBSig=false, then Q2<Q1
56     */
57     function _SolveQuadraticFunctionForTrade(
58         uint256 Q0,
59         uint256 Q1,
60         uint256 ideltaB,
61         bool deltaBSig,
62         uint256 k
63     ) internal pure returns (uint256) {
64         // calculate -b value and sig
65         // -b = (1-k)Q1-kQ0^2/Q1+i*deltaB
66         uint256 kQ02Q1 = DecimalMath.mul(k, Q0).mul(Q0).div(Q1); // kQ0^2/Q1
67         uint256 b = DecimalMath.mul(DecimalMath.ONE.sub(k), Q1); // (1-k)Q1
68         bool minusbSig = true;
69         if (deltaBSig) {
70             b = b.add(ideltaB); // (1-k)Q1+i*deltaB
71         } else {
72             kQ02Q1 = kQ02Q1.add(ideltaB); // i*deltaB+kQ0^2/Q1
73         }
74         if (b >= kQ02Q1) {
75             b = b.sub(kQ02Q1);
76             minusbSig = true;
77         } else {
78             b = kQ02Q1.sub(b);
79             minusbSig = false;
80         }
81 
82         // calculate sqrt
83         uint256 squareRoot = DecimalMath.mul(
84             DecimalMath.ONE.sub(k).mul(4),
85             DecimalMath.mul(k, Q0).mul(Q0)
86         ); // 4(1-k)kQ0^2
87         squareRoot = b.mul(b).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)
88 
89         // final res
90         uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)
91         uint256 numerator;
92         if (minusbSig) {
93             numerator = b.add(squareRoot);
94         } else {
95             numerator = squareRoot.sub(b);
96         }
97 
98         if (deltaBSig) {
99             return DecimalMath.divFloor(numerator, denominator);
100         } else {
101             return DecimalMath.divCeil(numerator, denominator);
102         }
103     }
104 
105     /*
106         Start from the integration function
107         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
108         Assume Q2=Q0, Given Q1 and deltaB, solve Q0
109         let fairAmount = i*deltaB
110     */
111     function _SolveQuadraticFunctionForTarget(
112         uint256 V1,
113         uint256 k,
114         uint256 fairAmount
115     ) internal pure returns (uint256 V0) {
116         // V0 = V1+V1*(sqrt-1)/2k
117         uint256 sqrt = DecimalMath.divCeil(DecimalMath.mul(k, fairAmount).mul(4), V1);
118         sqrt = sqrt.add(DecimalMath.ONE).mul(DecimalMath.ONE).sqrt();
119         uint256 premium = DecimalMath.divCeil(sqrt.sub(DecimalMath.ONE), k.mul(2));
120         // V0 is greater than or equal to V1 according to the solution
121         return DecimalMath.mul(V1, DecimalMath.ONE.add(premium));
122     }
123 }
