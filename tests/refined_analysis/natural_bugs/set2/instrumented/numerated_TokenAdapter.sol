1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.5.17;
4 pragma experimental ABIEncoderV2;
5 
6 struct TokenMetadata {
7     address token;
8     string name;
9     string symbol;
10     uint8 decimals;
11 }
12 
13 struct Component {
14     address token;
15     string tokenType;  // "ERC20" by default
16     uint rate;  // price per full share (1e18)
17 }
18 
19 interface IERC20 {
20     function approve(address, uint256) external returns (bool);
21 
22     function transfer(address, uint256) external returns (bool);
23 
24     function transferFrom(
25         address,
26         address,
27         uint256
28     ) external returns (bool);
29 
30     function name() external view returns (string memory);
31 
32     function symbol() external view returns (string memory);
33 
34     function decimals() external view returns (uint8);
35 
36     function totalSupply() external view returns (uint256);
37 
38     function balanceOf(address) external view returns (uint256);
39 
40     function allowance(address, address) external view returns (uint256);
41 }
42 
43 interface TokenAdapter {
44     function getMetadata(address token) external view returns (TokenMetadata memory);
45     function getComponents(address token) external view returns (Component[] memory);
46 }
47 
48 interface IPair {
49     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
50 }
51 
52 abstract contract ProtocolAdapter {
53     function getBalance(address token, address account) public virtual returns (int256);
54 }
55 
56 contract ERC20ProtocolAdapter is ProtocolAdapter {
57     
58     IPair public pair;
59     IERC20 public nbu; // 0xa4d872235dde5694af92a1d0df20d723e8e9e5fc
60     IERC20 public usdt;
61 
62     string public constant adapterType = "Asset";
63     string public constant tokenType = "ERC20";
64     
65     constructor(address pairAddress) {
66         pair = IPair(pairAddress); // 0x7496Bfbdf1B26eFf11B9311900Ab5cC0FEe4c16C gnbu/wbnb
67     }
68 
69     function getMetadata(address token) external view returns (TokenMetadata memory) {
70         return TokenMetadata({
71             token: token,
72             name: IERC20(token).name(),
73             symbol: IERC20(token).symbol(),
74             decimals: IERC20(token).decimals()
75         });
76     }
77     
78     function getComponents(address token) external view returns (Component[] memory) {
79         
80         (uint256 reserve0,uint256 reserve1,) = pair.getReserves();
81         
82         uint rate = ((reserve0 * 10 ** 30) / (reserve1* 10 ** 18)) * 10 ** 18;
83         
84         Component[] memory components = new Component[](1);
85         
86         components[0] = Component({
87             token: token,
88             tokenType: "ERC20",
89             rate: rate
90         });
91         
92         return components;
93     }
94 
95     function getBalance(address token, address account) public view override returns (int256) {
96         return int256(IERC20(token).balanceOf(account));
97     }
98     
99 }
100 
101 
102 
103 
104 
105 
106 
107 
108 
