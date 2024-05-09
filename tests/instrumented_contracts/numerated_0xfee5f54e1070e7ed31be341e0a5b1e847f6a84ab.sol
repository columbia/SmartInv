1 // SPDX-License-Identifier: AGPL-3.0-only
2 pragma solidity 0.8.7;
3 
4 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
5 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
6 /// Taken from Solmate: https://github.com/Rari-Capital/solmate
7 
8 contract ERC20 {
9     /*///////////////////////////////////////////////////////////////
10                                   EVENTS
11     //////////////////////////////////////////////////////////////*/
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 
16     /*///////////////////////////////////////////////////////////////
17                              METADATA STORAGE
18     //////////////////////////////////////////////////////////////*/
19 
20     string public constant name     = "ZUG";
21     string public constant symbol   = "ZUG";
22     uint8  public constant decimals = 18;
23 
24     /*///////////////////////////////////////////////////////////////
25                              ERC20 STORAGE
26     //////////////////////////////////////////////////////////////*/
27 
28     uint256 public totalSupply;
29 
30     mapping(address => uint256) public balanceOf;
31 
32     mapping(address => mapping(address => uint256)) public allowance;
33 
34     mapping(address => bool) public isMinter;
35 
36     address public ruler;
37 
38     /*///////////////////////////////////////////////////////////////
39                               ERC20 LOGIC
40     //////////////////////////////////////////////////////////////*/
41 
42     constructor() { ruler = msg.sender;}
43 
44     function approve(address spender, uint256 value) external returns (bool) {
45         allowance[msg.sender][spender] = value;
46 
47         emit Approval(msg.sender, spender, value);
48 
49         return true;
50     }
51 
52     function transfer(address to, uint256 value) external returns (bool) {
53         balanceOf[msg.sender] -= value;
54 
55         // This is safe because the sum of all user
56         // balances can't exceed type(uint256).max!
57         unchecked {
58             balanceOf[to] += value;
59         }
60 
61         emit Transfer(msg.sender, to, value);
62 
63         return true;
64     }
65 
66     function transferFrom(
67         address from,
68         address to,
69         uint256 value
70     ) external returns (bool) {
71         if (allowance[from][msg.sender] != type(uint256).max) {
72             allowance[from][msg.sender] -= value;
73         }
74 
75         balanceOf[from] -= value;
76 
77         // This is safe because the sum of all user
78         // balances can't exceed type(uint256).max!
79         unchecked {
80             balanceOf[to] += value;
81         }
82 
83         emit Transfer(from, to, value);
84 
85         return true;
86     }
87 
88     /*///////////////////////////////////////////////////////////////
89                              ORC PRIVILEGE
90     //////////////////////////////////////////////////////////////*/
91 
92     function mint(address to, uint256 value) external {
93         require(isMinter[msg.sender], "FORBIDDEN TO MINT");
94         _mint(to, value);
95     }
96 
97     function burn(address from, uint256 value) external {
98         require(isMinter[msg.sender], "FORBIDDEN TO BURN");
99         _burn(from, value);
100     }
101 
102     /*///////////////////////////////////////////////////////////////
103                          Ruler Function
104     //////////////////////////////////////////////////////////////*/
105 
106     function setMinter(address minter, bool status) external {
107         require(msg.sender == ruler, "NOT ALLOWED TO RULE");
108 
109         isMinter[minter] = status;
110     }
111 
112     function setRuler(address ruler_) external {
113         require(msg.sender == ruler ||ruler == address(0), "NOT ALLOWED TO RULE");
114 
115         ruler = ruler_;
116     }
117 
118 
119     /*///////////////////////////////////////////////////////////////
120                           INTERNAL UTILS
121     //////////////////////////////////////////////////////////////*/
122 
123     function _mint(address to, uint256 value) internal {
124         totalSupply += value;
125 
126         // This is safe because the sum of all user
127         // balances can't exceed type(uint256).max!
128         unchecked {
129             balanceOf[to] += value;
130         }
131 
132         emit Transfer(address(0), to, value);
133     }
134 
135     function _burn(address from, uint256 value) internal {
136         balanceOf[from] -= value;
137 
138         // This is safe because a user won't ever
139         // have a balance larger than totalSupply!
140         unchecked {
141             totalSupply -= value;
142         }
143 
144         emit Transfer(from, address(0), value);
145     }
146 }