1 pragma solidity ^0.5.0;
2 
3 
4 interface TubLike {
5     function wipe(bytes32, uint) external;
6     function gov() external view returns (TokenLike);
7     function sai() external view returns (TokenLike);
8     function tab(bytes32) external returns (uint);
9     function rap(bytes32) external returns (uint);
10     function pep() external view returns (PepLike);
11 }
12 
13 interface TokenLike {
14     function allowance(address, address) external view returns (uint);
15     function balanceOf(address) external view returns (uint);
16     function approve(address, uint) external;
17     function transfer(address, uint) external returns (bool);
18     function transferFrom(address, address, uint) external returns (bool);
19 }
20 
21 interface PepLike {
22     function peek() external returns (bytes32, bool);
23 }
24 
25 interface UniswapExchangeLike {
26     function getEthToTokenOutputPrice(uint256 tokensBought) external view returns (uint256 ethSold);
27     function getTokenToEthOutputPrice(uint256 ethBought) external view returns (uint256 tokensSold);
28     function tokenToTokenSwapOutput(
29         uint256 tokensBought,
30         uint256 maxTokensSold,
31         uint256 maxEthSold,
32         uint256 deadline,
33         address tokenAddr
34         ) external returns (uint256  tokensSold);
35 }
36 
37 
38 contract DSMath {
39 
40     function add(uint x, uint y) internal pure returns (uint z) {
41         require((z = x + y) >= x, "math-not-safe");
42     }
43 
44     function mul(uint x, uint y) internal pure returns (uint z) {
45         require(y == 0 || (z = x * y) / y == x, "math-not-safe");
46     }
47 
48     uint constant WAD = 10 ** 18;
49     uint constant RAY = 10 ** 27;
50 
51     function rmul(uint x, uint y) internal pure returns (uint z) {
52         z = add(mul(x, y), RAY / 2) / RAY;
53     }
54 
55     function rdiv(uint x, uint y) internal pure returns (uint z) {
56         z = add(mul(x, RAY), y / 2) / y;
57     }
58 
59     function wdiv(uint x, uint y) internal pure returns (uint z) {
60         z = add(mul(x, WAD), y / 2) / y;
61     }
62 
63 }
64 
65 
66 contract WipeProxy is DSMath {
67 
68     function wipeWithDai(
69         address _tub,
70         address _daiEx,
71         address _mkrEx,
72         uint cupid,
73         uint wad
74     ) public 
75     {
76         require(wad > 0, "no-wipe-no-dai");
77 
78         TubLike tub = TubLike(_tub);
79         UniswapExchangeLike daiEx = UniswapExchangeLike(_daiEx);
80         UniswapExchangeLike mkrEx = UniswapExchangeLike(_mkrEx);
81         TokenLike dai = tub.sai();
82         TokenLike mkr = tub.gov();
83         PepLike pep = tub.pep();
84 
85         bytes32 cup = bytes32(cupid);
86 
87         setAllowance(dai, _tub);
88         setAllowance(mkr, _tub);
89         setAllowance(dai, _daiEx);
90 
91         (bytes32 val, bool ok) = pep.peek();
92 
93         // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
94         uint mkrFee = wdiv(rmul(wad, rdiv(tub.rap(cup), tub.tab(cup))), uint(val));
95 
96         uint ethAmt = mkrEx.getEthToTokenOutputPrice(mkrFee);
97         uint daiAmt = daiEx.getTokenToEthOutputPrice(ethAmt);
98 
99         daiAmt = add(wad, daiAmt);
100         require(dai.transferFrom(msg.sender, address(this), daiAmt), "not-approved-yet");
101 
102         if (ok && val != 0) {
103             daiEx.tokenToTokenSwapOutput(
104                 mkrFee,
105                 daiAmt,
106                 uint(999000000000000000000),
107                 uint(1645118771), // 17 feb
108                 address(mkr)
109             );
110         }
111 
112         tub.wipe(cup, wad);
113     }
114 
115     function setAllowance(TokenLike token_, address spender_) private {
116         if (token_.allowance(address(this), spender_) != uint(-1)) {
117             token_.approve(spender_, uint(-1));
118         }
119     }
120 
121 }