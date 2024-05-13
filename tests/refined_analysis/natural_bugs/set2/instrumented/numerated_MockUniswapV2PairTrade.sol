1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@uniswap/lib/contracts/libraries/FixedPoint.sol";
5 
6 contract MockUniswapV2PairTrade {
7     uint256 public price0CumulativeLast;
8     uint256 public price1CumulativeLast;
9 
10     uint112 public reserve0;
11     uint112 public reserve1;
12     uint32 public blockTimestampLast;
13 
14     constructor(
15         uint256 _price0CumulativeLast,
16         uint256 _price1CumulativeLast,
17         uint32 _blockTimestampLast,
18         uint112 r0,
19         uint112 r1
20     ) {
21         set(_price0CumulativeLast, _price1CumulativeLast, _blockTimestampLast);
22         setReserves(r0, r1);
23     }
24 
25     function getReserves()
26         public
27         view
28         returns (
29             uint112,
30             uint112,
31             uint32
32         )
33     {
34         return (reserve0, reserve1, blockTimestampLast);
35     }
36 
37     function simulateTrade(
38         uint112 newReserve0,
39         uint112 newReserve1,
40         uint32 blockTimestamp
41     ) external {
42         uint32 timeElapsed = blockTimestamp - blockTimestampLast;
43         if (timeElapsed > 0 && reserve0 != 0 && reserve1 != 0) {
44             price0CumulativeLast += uint256(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
45             price1CumulativeLast += uint256(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
46         }
47         reserve0 = newReserve0;
48         reserve1 = newReserve1;
49         blockTimestampLast = blockTimestamp;
50     }
51 
52     function set(
53         uint256 _price0CumulativeLast,
54         uint256 _price1CumulativeLast,
55         uint32 _blockTimestampLast
56     ) public {
57         price0CumulativeLast = _price0CumulativeLast;
58         price1CumulativeLast = _price1CumulativeLast;
59         blockTimestampLast = _blockTimestampLast;
60     }
61 
62     function setReserves(uint112 r0, uint112 r1) public {
63         reserve0 = r0;
64         reserve1 = r1;
65     }
66 }
