1 pragma solidity ^0.5.0;
2 
3 
4 interface TubInterface {
5     function wipe(bytes32, uint) external;
6     function gov() external view returns (TokenInterface);
7     function sai() external view returns (TokenInterface);
8     function tab(bytes32) external returns (uint);
9     function rap(bytes32) external returns (uint);
10     function pep() external view returns (PepInterface);
11 }
12 
13 interface TokenInterface {
14     function allowance(address, address) external view returns (uint);
15     function balanceOf(address) external view returns (uint);
16     function approve(address, uint) external;
17     function transfer(address, uint) external returns (bool);
18     function transferFrom(address, address, uint) external returns (bool);
19 }
20 
21 interface PepInterface {
22     function peek() external returns (bytes32, bool);
23 }
24 
25 interface UniswapExchange {
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
68     function getSaiTubAddress() public pure returns (address sai) {
69         sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
70     }
71 
72     function getUniswapMKRExchange() public pure returns (address ume) {
73         ume = 0x2C4Bd064b998838076fa341A83d007FC2FA50957;
74     }
75 
76     function getUniswapDAIExchange() public pure returns (address ude) {
77         ude = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
78     }
79 
80     function wipe(
81         uint cdpNum,
82         uint _wad
83     ) public 
84     {
85         require(_wad > 0, "no-wipe-no-dai");
86 
87         TubInterface tub = TubInterface(getSaiTubAddress());
88         UniswapExchange daiEx = UniswapExchange(getUniswapDAIExchange());
89         UniswapExchange mkrEx = UniswapExchange(getUniswapMKRExchange());
90         TokenInterface dai = tub.sai();
91         TokenInterface mkr = tub.gov();
92 
93         bytes32 cup = bytes32(cdpNum);
94 
95         setAllowance(dai, getSaiTubAddress());
96         setAllowance(mkr, getSaiTubAddress());
97         setAllowance(dai, getUniswapDAIExchange());
98 
99         (bytes32 val, bool ok) = tub.pep().peek();
100 
101         // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
102         uint mkrFee = wdiv(rmul(_wad, rdiv(tub.rap(cup), tub.tab(cup))), uint(val));
103 
104         uint daiAmt = daiEx.getTokenToEthOutputPrice(mkrEx.getEthToTokenOutputPrice(mkrFee));
105         daiAmt = add(_wad, daiAmt);
106         require(dai.transferFrom(msg.sender, address(this), daiAmt), "not-approved-yet");
107 
108         if (ok && val != 0) {
109             daiEx.tokenToTokenSwapOutput(
110                 mkrFee,
111                 daiAmt,
112                 uint(999000000000000000000),
113                 uint(1899063809), // 6th March 2030 GMT // no logic
114                 address(mkr)
115             );
116         }
117 
118         tub.wipe(cup, _wad);
119     }
120 
121     function setAllowance(TokenInterface token_, address spender_) private {
122         if (token_.allowance(address(this), spender_) != uint(-1)) {
123             token_.approve(spender_, uint(-1));
124         }
125     }
126 
127 }