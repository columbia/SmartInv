1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-21
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.6.10;
8 
9 //--------------------------------------
10 //  EVAI contract
11 //
12 // Symbol      : EVAI
13 // Name        : EVAI.IO
14 // Total supply: 1000000000
15 // Decimals    : 8
16 //--------------------------------------
17 
18 abstract contract ERC20Interface {
19     function totalSupply() external view virtual returns (uint256);
20 
21     function balanceOf(address tokenOwner)
22         external
23         view
24         virtual
25         returns (uint256);
26 
27     function allowance(address tokenOwner, address spender)
28         external
29         view
30         virtual
31         returns (uint256);
32 
33     function transfer(address to, uint256 tokens)
34         external
35         virtual
36         returns (bool);
37 
38     function approve(address spender, uint256 tokens)
39         external
40         virtual
41         returns (bool);
42 
43     function transferFrom(
44         address from,
45         address to,
46         uint256 tokens
47     ) external virtual returns (bool);
48 
49     function burn(uint256 tokens) external virtual returns (bool success);
50 
51     function buy(address to, uint256 tokens) external virtual returns (bool);
52 
53     function operationProfit(uint256 _profit) external virtual returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 tokens);
56     event Approval(
57         address indexed tokenOwner,
58         address indexed spender,
59         uint256 tokens
60     );
61     event Burn(address from, address, uint256 value);
62     event Profit(address from, uint256 profit, uint256 totalProfit);
63 }
64 
65 // ----------------------------------------------------------------------------
66 // Safe Math Library
67 // ----------------------------------------------------------------------------
68 contract SafeMath {
69     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
70         c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72         return c;
73     }
74 
75     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
76         require(b <= a, "SafeMath: subtraction overflow");
77         c = a - b;
78         return c;
79     }
80 }
81 
82 contract Evaitoken is ERC20Interface, SafeMath {
83     string public name;
84     string public symbol;
85     uint8 public decimals;
86     uint256 public initialSupply;
87     uint256 public _totalSupply;
88     address public owner;
89     uint256 public totalProfit;
90     uint256 public profit;
91 
92     mapping(address => uint256) internal balances;
93     mapping(address => mapping(address => uint256)) internal allowed;
94     mapping(uint256 => uint256) internal token;
95 
96     constructor() public {
97         name = "EVAI.IO";
98         symbol = "EVAI";
99         decimals = 8;
100         _totalSupply = 1000000000 * 10**uint256(decimals);
101         initialSupply = _totalSupply;
102         balances[msg.sender] = _totalSupply;
103         owner = msg.sender;
104         emit Transfer(address(0), msg.sender, _totalSupply);
105     }
106 
107     function totalSupply() external view override returns (uint256) {
108         return safeSub(_totalSupply, balances[address(0)]);
109     }
110 
111     function balanceOf(address tokenOwner)
112         external
113         view
114         override
115         returns (uint256 getBalance)
116     {
117         return balances[tokenOwner];
118     }
119 
120     function allowance(address tokenOwner, address spender)
121         external
122         view
123         override
124         returns (uint256 remaining)
125     {
126         return allowed[tokenOwner][spender];
127     }
128 
129     function approve(address spender, uint256 tokens)
130         external
131         override
132         returns (bool success)
133     {
134         allowed[msg.sender][spender] = tokens;
135         emit Approval(msg.sender, spender, tokens);
136         return true;
137     }
138 
139     function transfer(address to, uint256 tokens)
140         external
141         override
142         returns (bool success)
143     {
144         require(to != address(0));
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         emit Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151     function transferFrom(
152         address from,
153         address to,
154         uint256 tokens
155     ) external override returns (bool success) {
156         require(to != address(0));
157         balances[from] = safeSub(balances[from], tokens);
158         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
159         balances[to] = safeAdd(balances[to], tokens);
160         emit Transfer(from, to, tokens);
161         return true;
162     }
163 
164     function buy(address to, uint256 tokens)
165         external
166         override
167         returns (bool success)
168     {
169         require(to != address(0));
170         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
171         balances[to] = safeAdd(balances[to], tokens);
172         emit Transfer(msg.sender, to, tokens);
173         return true;
174     }
175 
176     function operationProfit(uint256 _profit)
177         external
178         override
179         returns (bool success)
180     {
181         require(owner == msg.sender, "This is not owner");
182         profit = _profit;
183         totalProfit = safeAdd(totalProfit, profit);
184         emit Profit(msg.sender, profit, totalProfit);
185         return true;
186     }
187 
188     function burn(uint256 tokens) external override returns (bool success) {
189         require(owner == msg.sender, "This is not owner");
190         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
191         _totalSupply = safeSub(_totalSupply, tokens);
192         emit Burn(msg.sender, address(0), tokens);
193         return true;
194     }
195 }