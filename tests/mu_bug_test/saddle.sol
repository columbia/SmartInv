1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6     function _calculateWithdrawOneTokenDY(
7         SwapUtils.Swap storage self,
8         uint8 tokenIndex,
9         uint256 tokenAmount,
10         uint256 baseVirtualPrice,
11         uint256 totalSupply
12     )
13         internal
14         view
15         returns (
16             uint256,
17             uint256,
18             uint256
19         )
20     {
21 
22         uint256[] memory xp = _xp(self, baseVirtualPrice);
23         require(tokenIndex < xp.length, "Token index out of range");
24 
25         CalculateWithdrawOneTokenDYInfo memory v =
26             CalculateWithdrawOneTokenDYInfo(0, 0, 0, 0, self._getAPrecise(), 0);
27         v.d0 = SwapUtils.getD(xp, v.preciseA);
28         v.d1 = v.d0.sub(tokenAmount.mul(v.d0).div(totalSupply));
29 
30         require(tokenAmount <= xp[tokenIndex], "Withdraw exceeds available");
31 
32         v.newY = SwapUtils.getYD(v.preciseA, tokenIndex, xp, v.d1);
33 
34         uint256[] memory xpReduced = new uint256[](xp.length);
35 
36         v.feePerToken = SwapUtils._feePerToken(self.swapFee, xp.length);
37         for (uint256 i = 0; i < xp.length; i++) {
38             v.xpi = xp[i];
39             xpReduced[i] = v.xpi.sub(
40                 (
41                     (i == tokenIndex)
42                         ? v.xpi.mul(v.d1).div(v.d0).sub(v.newY)
43                         : v.xpi.sub(v.xpi.mul(v.d1).div(v.d0))
44                 )
45                     .mul(v.feePerToken)
46                     .div(FEE_DENOMINATOR)
47             );
48         }
49         uint256 dy =
50             xpReduced[tokenIndex].sub(
51                 SwapUtils.getYD(v.preciseA, tokenIndex, xpReduced, v.d1)
52             );
53 
54         if (tokenIndex == xp.length.sub(1)) {
55             dy = dy.mul(BASE_VIRTUAL_PRICE_PRECISION).div(baseVirtualPrice);
56         }
57         dy = dy.sub(1).div(self.tokenPrecisionMultipliers[tokenIndex]);
58 
59         return (dy, v.newY, xp[tokenIndex]);
60     }
61 
62     function calculateSwap(
63         SwapUtils.Swap storage self,
64         MetaSwap storage metaSwapStorage,
65         uint8 tokenIndexFrom,
66         uint8 tokenIndexTo,
67         uint256 dx
68     ) external view returns (uint256 dy) {
69         (dy, ) = _calculateSwap(
70             self,
71             tokenIndexFrom,
72             tokenIndexTo,
73             dx,
74             _getBaseVirtualPrice(metaSwapStorage)
75         );
76     }
77 
78     function _calculateSwap(
79         SwapUtils.Swap storage self,
80         uint8 tokenIndexFrom,
81         uint8 tokenIndexTo,
82         uint256 dx,
83         uint256 baseVirtualPrice
84     ) internal view returns (uint256 dy, uint256 dyFee) {
85         uint256[] memory xp = _xp(self, baseVirtualPrice);
86         require(
87             tokenIndexFrom < xp.length && tokenIndexTo < xp.length,
88             "Token index out of range"
89         );
90         uint256 x =
91             dx.mul(self.tokenPrecisionMultipliers[tokenIndexFrom]).add(
92                 xp[tokenIndexFrom]
93             );
94         uint256 y =
95             SwapUtils.getY(
96                 self._getAPrecise(),
97                 tokenIndexFrom,
98                 tokenIndexTo,
99                 x,
100                 xp
101             );
102         dy = xp[tokenIndexTo].sub(y).sub(1);
103         dyFee = dy.mul(self.swapFee).div(FEE_DENOMINATOR);
104         dy = dy.sub(dyFee).div(self.tokenPrecisionMultipliers[tokenIndexTo]);
105     }
106 }