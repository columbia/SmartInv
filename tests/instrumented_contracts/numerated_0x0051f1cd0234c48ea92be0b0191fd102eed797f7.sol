1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 contract KarbonPlatinum {
5     address private owner;
6 
7     ERC20 private foreignToken;
8 
9     address private constant subAddress1 =
10         0x926994574F4A14c276cb652FF8BC2427BA3e89B3;
11     address private constant subAddress2 =
12         0xB0cE41a94cf9EFCb02F7b70771ad26C98f72265d;
13     address private constant subAddress3 =
14         0xBF30Ea9bD1A129Ee15a2FdBD0B8a4052966C31b0;
15     address private constant mainAddress =
16         0x5cA3a7f835573f872493f8Ca79d6D33B4Cba7287;
17 
18     struct karbonPlatinumStruct {
19         address from;
20         address subAddress1;
21         address subAddress2;
22         address subAddress3;
23         address mainAddress;
24         uint256 fullAmount;
25         uint256 subAmount;
26         uint256 mainAmount;
27         uint256 timestamp;
28         string userId;
29     }
30 
31     event karbonPlatinumLiquidityEvent(karbonPlatinumStruct karbonPlatinumObj);
32 
33     constructor(address _foreignTokenAddress) {
34         owner = msg.sender;
35         foreignToken = ERC20(_foreignTokenAddress);
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner, "Only callable by owner");
40         _;
41     }
42 
43     function karbonPlatinumLiquidity(
44         uint256 foreignTokenAmount,
45         uint256 subAmount,
46         uint256 mainAmount,
47         string memory userId
48     ) public returns (bool) {
49         require(foreignTokenAmount > 0);
50 
51         bool foreignTokenTx1 = foreignToken.transferFrom(
52             msg.sender,
53             address(subAddress1),
54             subAmount
55         );
56         require(foreignTokenTx1);
57 
58         bool foreignTokenTx2 = foreignToken.transferFrom(
59             msg.sender,
60             address(subAddress2),
61             subAmount
62         );
63         require(foreignTokenTx2);
64 
65         bool foreignTokenTx3 = foreignToken.transferFrom(
66             msg.sender,
67             address(subAddress3),
68             subAmount
69         );
70         require(foreignTokenTx3);
71         bool foreignTokenTx4 = foreignToken.transferFrom(
72             msg.sender,
73             address(mainAddress),
74             mainAmount
75         );
76         require(foreignTokenTx4);
77 
78         karbonPlatinumStruct memory karbonPlatinumEventObj = karbonPlatinumStruct(
79             msg.sender,
80             subAddress1,
81             subAddress2,
82             subAddress3,
83             mainAddress,
84             foreignTokenAmount,
85             subAmount,
86             mainAmount,
87             block.timestamp,
88             userId
89         );
90 
91         emit karbonPlatinumLiquidityEvent(karbonPlatinumEventObj);
92 
93         return true;
94     }
95 }
96 
97 interface ERC20 {
98     function totalSupply() external view returns (uint256);
99 
100     function balanceOf(address account) external view returns (uint256);
101 
102     function transfer(address recipient, uint256 amount)
103         external
104         returns (bool);
105 
106     function allowance(address owner, address spender)
107         external
108         view
109         returns (uint256);
110 
111     function approve(address spender, uint256 amount) external returns (bool);
112 
113     function transferFrom(
114         address sender,
115         address recipient,
116         uint256 amount
117     ) external returns (bool);
118 
119     function decimals() external view returns (uint256);
120 
121     event Transfer(address indexed from, address indexed to, uint256 value);
122     event Approval(
123         address indexed owner,
124         address indexed spender,
125         uint256 value
126     );
127 }