1 pragma solidity ^0.6.0;
2 
3 // SPDX-License-Identifier: MIT
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function allowance(address owner, address spender)
10         external
11         view
12         returns (uint256);
13 
14     function transfer(address recipient, uint256 amount)
15         external
16         returns (bool);
17 
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     function transferFrom(
21         address sender,
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33 
34 contract ERC20Basic is IERC20 {
35     string public name;
36     string public symbol;
37     uint8 public constant decimals = 18;
38 
39     event Approval(
40         address indexed tokenOwner,
41         address indexed spender,
42         uint256 tokens
43     );
44     event Transfer(address indexed from, address indexed to, uint256 tokens);
45 
46     mapping(address => uint256) balances;
47 
48     mapping(address => mapping(address => uint256)) allowed;
49 
50     uint256 totalSupply_;
51 
52     using SafeMath for uint256;
53 
54     constructor(
55         string memory tokenName,
56         string memory tokenSymbol,
57         uint256 total
58     ) public {
59         totalSupply_ = total * 10**uint256(decimals);
60         balances[msg.sender] = totalSupply_;
61         name = tokenName;
62         symbol = tokenSymbol;
63     }
64 
65     function totalSupply() public override view returns (uint256) {
66         return totalSupply_;
67     }
68 
69     function balanceOf(address tokenOwner)
70         public
71         override
72         view
73         returns (uint256)
74     {
75         return balances[tokenOwner];
76     }
77 
78     function transfer(address receiver, uint256 numTokens)
79         public
80         override
81         returns (bool)
82     {
83         require(numTokens <= balances[msg.sender]);
84         balances[msg.sender] = balances[msg.sender].sub(numTokens);
85         balances[receiver] = balances[receiver].add(numTokens);
86         emit Transfer(msg.sender, receiver, numTokens);
87         return true;
88     }
89 
90     function approve(address delegate, uint256 numTokens)
91         public
92         override
93         returns (bool)
94     {
95         allowed[msg.sender][delegate] = numTokens;
96         emit Approval(msg.sender, delegate, numTokens);
97         return true;
98     }
99 
100     function allowance(address owner, address delegate)
101         public
102         override
103         view
104         returns (uint256)
105     {
106         return allowed[owner][delegate];
107     }
108 
109     function transferFrom(
110         address owner,
111         address buyer,
112         uint256 numTokens
113     ) public override returns (bool) {
114         require(numTokens <= balances[owner]);
115         require(numTokens <= allowed[owner][msg.sender]);
116 
117         balances[owner] = balances[owner].sub(numTokens);
118         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
119         balances[buyer] = balances[buyer].add(numTokens);
120         emit Transfer(owner, buyer, numTokens);
121         return true;
122     }
123 }
124 
125 library SafeMath {
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         assert(b <= a);
128         return a - b;
129     }
130 
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         assert(c >= a);
134         return c;
135     }
136 }