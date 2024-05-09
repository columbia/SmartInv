1 pragma solidity ^0.5.0;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x, "ds-math-add-overflow");
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x, "ds-math-sub-underflow");
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
12     }
13 }
14 
15 // token.sol -- ERC20 implementation with minting and burning
16 
17 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
18 
19 // This program is free software: you can redistribute it and/or modify
20 // it under the terms of the GNU General Public License as published by
21 // the Free Software Foundation, either version 3 of the License, or
22 // (at your option) any later version.
23 
24 // This program is distributed in the hope that it will be useful,
25 // but WITHOUT ANY WARRANTY; without even the implied warranty of
26 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
27 // GNU General Public License for more details.
28 
29 // You should have received a copy of the GNU General Public License
30 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
31 
32 contract SpaghettiToken is DSMath {
33     uint256                                           public  totalSupply;
34     mapping (address => uint256)                      public  balanceOf;
35     mapping (address => mapping (address => uint256)) public  allowance;
36     bytes32                                           public  symbol = "PASTA";
37     uint256                                           public  decimals = 18;
38     bytes32                                           public  name = "Spaghetti";
39 
40     constructor(address chef) public {
41         // hard limit 15,000,000 PASTA
42         totalSupply = 15000000000000000000000000;
43         balanceOf[chef] = 15000000000000000000000000;
44     }
45 
46     event Approval(address indexed src, address indexed guy, uint wad);
47     event Transfer(address indexed src, address indexed dst, uint wad);
48     event Burn(uint wad);
49 
50     function approve(address guy) external returns (bool) {
51         return approve(guy, uint(-1));
52     }
53 
54     function approve(address guy, uint wad) public returns (bool) {
55         allowance[msg.sender][guy] = wad;
56 
57         emit Approval(msg.sender, guy, wad);
58 
59         return true;
60     }
61 
62     function transfer(address dst, uint wad) external returns (bool) {
63         return transferFrom(msg.sender, dst, wad);
64     }
65 
66     function transferFrom(address src, address dst, uint wad) public returns (bool) {
67         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
68             require(allowance[src][msg.sender] >= wad, "ds-token-insufficient-approval");
69             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
70         }
71 
72         require(balanceOf[src] >= wad, "ds-token-insufficient-balance");
73         balanceOf[src] = sub(balanceOf[src], wad);
74         uint one = wad / 100;
75         uint ninetynine = sub(wad, one);
76         balanceOf[dst] = add(balanceOf[dst], ninetynine);
77         burn(one);
78 
79         emit Transfer(src, dst, wad);
80 
81         return true;
82     }
83 
84     function burn(uint wad) internal {
85         totalSupply = sub(totalSupply, wad);
86         emit Burn(wad);
87     }
88 
89 }