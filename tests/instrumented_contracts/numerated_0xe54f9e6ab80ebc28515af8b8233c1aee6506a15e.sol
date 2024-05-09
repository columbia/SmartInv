1 pragma solidity ^0.5.0;
2 
3 interface ERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address) external view returns (uint256);
6     function transferFrom(address, address, uint256) external returns (bool);
7     function approve(address) external returns(bool);
8 }
9 
10 contract DSMath {
11     function add(uint x, uint y) internal pure returns (uint z) {
12         require((z = x + y) >= x, "ds-math-add-overflow");
13     }
14     function sub(uint x, uint y) internal pure returns (uint z) {
15         require((z = x - y) <= x, "ds-math-sub-underflow");
16     }
17     function mul(uint x, uint y) internal pure returns (uint z) {
18         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
19     }
20 }
21 
22 // token.sol -- ERC20 implementation with minting and burning
23 
24 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
25 
26 // This program is free software: you can redistribute it and/or modify
27 // it under the terms of the GNU General Public License as published by
28 // the Free Software Foundation, either version 3 of the License, or
29 // (at your option) any later version.
30 
31 // This program is distributed in the hope that it will be useful,
32 // but WITHOUT ANY WARRANTY; without even the implied warranty of
33 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
34 // GNU General Public License for more details.
35 
36 // You should have received a copy of the GNU General Public License
37 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
38 
39 contract SpaghettiTokenV2 is DSMath {
40     uint256                                           public  totalSupply;
41     mapping (address => uint256)                      public  balanceOf;
42     mapping (address => mapping (address => uint256)) public  allowance;
43     bytes32                                           public  symbol = "PASTA";
44     uint256                                           public  decimals = 18;
45     bytes32                                           public  name = "Spaghetti";
46     ERC20                                             public  pastav1 = ERC20(0x08A2E41FB99A7599725190B9C970Ad3893fa33CF);
47     address                                           public  foodbank = address(0);
48     address                                           public  governance;
49     uint128                                           public  food = 0;
50     uint128                                           public  oven = 0;
51 
52     event Approval(address indexed src, address indexed guy, uint wad);
53     event Transfer(address indexed src, address indexed dst, uint wad);
54     event Mint(address indexed guy, uint wad);
55     event Burn(uint wad);
56 
57     constructor() public {
58         governance = msg.sender;
59         totalSupply = 5000000000000000000000000;
60         balanceOf[msg.sender] = 5000000000000000000000000;
61     }
62 
63     function approve(address guy) external returns (bool) {
64         return approve(guy, uint(-1));
65     }
66 
67     function approve(address guy, uint wad) public returns (bool) {
68         allowance[msg.sender][guy] = wad;
69         emit Approval(msg.sender, guy, wad);
70         return true;
71     }
72 
73     function transfer(address dst, uint wad) external returns (bool) {
74         return transferFrom(msg.sender, dst, wad);
75     }
76 
77     function transferFrom(address src, address dst, uint wad) public returns (bool) {
78         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
79             require(allowance[src][msg.sender] >= wad, "ds-token-insufficient-approval");
80             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
81         }
82 
83         require(balanceOf[src] >= wad, "ds-token-insufficient-balance");
84         balanceOf[src] = sub(balanceOf[src], wad);
85         uint one = wad / 100;
86         uint ninetyeight = sub(wad, mul(one, 2));
87         balanceOf[dst] = add(balanceOf[dst], ninetyeight);
88         food = uint128(add(food, uint128(one)));
89         oven = uint128(add(oven, uint128(one)));
90 
91         emit Transfer(src, dst, wad);
92         return true;
93     }
94 
95     function mint() public returns(bool) {
96         uint v1Balance = pastav1.balanceOf(msg.sender);
97         require(block.timestamp <= 1598745600, "Migration ended");
98         require(v1Balance > 0, "mint:no-tokens");
99         require(pastav1.transferFrom(msg.sender, address(0), v1Balance), "mint:transferFrom-fail");
100         balanceOf[msg.sender] = v1Balance;
101         totalSupply = add(totalSupply, v1Balance);
102         emit Mint(msg.sender, v1Balance);
103     }
104 
105     function give() public {
106         require(foodbank != address(0), "foodbank not set");
107         balanceOf[foodbank] = add(balanceOf[foodbank], food);
108         food = 0;
109     }
110 
111     function burn() public {
112         totalSupply = sub(totalSupply, oven);
113         emit Burn(oven);
114         oven = 0;
115     }
116 
117     function setFoodbank(address _foodbank) public {
118         require(msg.sender == governance, "setFoodbank:not-gov");
119         foodbank = _foodbank;
120     }
121 
122     function setGovernance(address _governance) public {
123         require(msg.sender == governance, "setGovernance:not-gov");
124         governance = _governance;
125     }
126 
127 }