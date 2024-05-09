1 // SPDX-License-Identifier: AGPL-3.0-only
2 
3 pragma solidity ^0.8.17;
4 
5 
6 contract InterportToken {
7 
8     error OnlyOwnerError();
9     error ZeroAddressError();
10     error MintAccessError();
11     error BurnAccessError();
12 
13     string public name = "Interport Token";
14     string public symbol = "ITP";
15     uint8 public immutable decimals = 18;
16 
17     address public immutable underlying = address(0); // Anyswap ERC20 standard
18 
19     address public owner;
20     address public multichainRouter;
21 
22     uint256 public totalSupply;
23     mapping(address => uint256) public balanceOf;
24     mapping(address => mapping(address => uint256)) public allowance;
25 
26     event Transfer(address indexed from, address indexed to, uint256 amount);
27     event Approval(address indexed owner, address indexed spender, uint256 amount);
28     event SetMultichainRouter(address indexed multichainRouter);
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         if (msg.sender != owner) {
37             revert OnlyOwnerError();
38         }
39 
40         _;
41     }
42 
43     function approve(address spender, uint256 amount) external returns (bool) {
44         allowance[msg.sender][spender] = amount;
45 
46         emit Approval(msg.sender, spender, amount);
47 
48         return true;
49     }
50 
51     function transfer(address to, uint256 amount) external returns (bool) {
52         balanceOf[msg.sender] -= amount;
53 
54         // Cannot overflow because the sum of all user balances can't exceed the max uint256 value
55         unchecked {
56             balanceOf[to] += amount;
57         }
58 
59         emit Transfer(msg.sender, to, amount);
60 
61         return true;
62     }
63 
64     function transferFrom(
65         address from,
66         address to,
67         uint256 amount
68     )
69         external
70         returns (bool)
71     {
72         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals
73 
74         if (allowed != type(uint256).max) {
75             allowance[from][msg.sender] = allowed - amount;
76         }
77 
78         balanceOf[from] -= amount;
79 
80         // Cannot overflow because the sum of all user balances can't exceed the max uint256 value
81         unchecked {
82             balanceOf[to] += amount;
83         }
84 
85         emit Transfer(from, to, amount);
86 
87         return true;
88     }
89 
90     function mint(address _to, uint256 _amount) external returns (bool) {
91         // Minters: contract owner + Multichain router
92         bool condition =
93             msg.sender == owner ||
94             msg.sender == multichainRouter;
95 
96         if (!condition) {
97             revert MintAccessError();
98         }
99 
100         _mint(_to, _amount);
101 
102         return true;
103     }
104 
105     function burn(uint256 _amount) external returns (bool) {
106         // Simplified burn function for token holders
107         _burn(msg.sender, _amount);
108 
109         return true;
110     }
111 
112     function burn(address _from, uint256 _amount) external returns (bool) {
113         // Burners: token holders + Multichain router
114         bool condition =
115             _from == msg.sender ||
116             msg.sender == multichainRouter;
117 
118         if (!condition) {
119             revert BurnAccessError();
120         }
121 
122         _burn(_from, _amount);
123 
124         return true;
125     }
126 
127     function setMultichainRouter(address _multichainRouter) external onlyOwner {
128         // Zero address is allowed
129         multichainRouter = _multichainRouter;
130 
131         emit SetMultichainRouter(_multichainRouter);
132     }
133 
134     function transferOwnership(address newOwner) external onlyOwner {
135         if (newOwner == address(0)) {
136             revert ZeroAddressError();
137         }
138 
139         address previousOwner = owner;
140         owner = newOwner;
141 
142         emit OwnershipTransferred(previousOwner, newOwner);
143     }
144 
145     function _mint(address to, uint256 amount) private {
146         totalSupply += amount;
147 
148         // Cannot overflow because the sum of all user balances can't exceed the max uint256 value
149         unchecked {
150             balanceOf[to] += amount;
151         }
152 
153         emit Transfer(address(0), to, amount);
154     }
155 
156     function _burn(address from, uint256 amount) private {
157         balanceOf[from] -= amount;
158 
159         // Cannot underflow because a user's balance will never be larger than the total supply
160         unchecked {
161             totalSupply -= amount;
162         }
163 
164         emit Transfer(from, address(0), amount);
165     }
166 }