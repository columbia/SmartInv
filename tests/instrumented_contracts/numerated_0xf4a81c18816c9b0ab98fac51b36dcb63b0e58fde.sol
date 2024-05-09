1 pragma solidity =0.5.17;
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 
17 contract WAR {
18 
19     // --- ERC20 Data ---
20     string  public constant name     = "yieldwars.com";
21     string  public constant symbol   = "WAR";
22     uint8   public constant decimals = 18;
23     uint256 public constant totalSupply = 2800000e18;
24 
25     mapping (address => uint)                      public balanceOf;
26     mapping (address => mapping (address => uint)) public allowance;
27 
28     event Approval(address indexed owner, address indexed spender, uint value);
29     event Transfer(address indexed src, address indexed dst, uint value);
30 
31     constructor() public {
32         balanceOf[msg.sender] = totalSupply;
33         emit Transfer(address(0), msg.sender, totalSupply);
34     }
35 
36     // --- Math ---
37     function add(uint x, uint y) internal pure returns (uint z) {
38         require((z = x + y) >= x);
39     }
40     function sub(uint x, uint y) internal pure returns (uint z) {
41         require((z = x - y) <= x);
42     }
43 
44     // --- Token ---
45     function transfer(address dst, uint value) external returns (bool) {
46         return transferFrom(msg.sender, dst, value);
47     }
48 
49     function transferFrom(address src, address dst, uint value)
50         public returns (bool)
51     {
52         require(balanceOf[src] >= value, "WAR/insufficient-balance");
53         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
54             require(allowance[src][msg.sender] >= value, "WAR/insufficient-allowance");
55             allowance[src][msg.sender] = sub(allowance[src][msg.sender], value);
56         }
57         balanceOf[src] = sub(balanceOf[src], value);
58         balanceOf[dst] = add(balanceOf[dst], value);
59         emit Transfer(src, dst, value);
60         return true;
61     }
62 
63     function approve(address spender, uint value) external returns (bool) {
64         allowance[msg.sender][spender] = value;
65         emit Approval(msg.sender, spender, value);
66         return true;
67     }
68 }