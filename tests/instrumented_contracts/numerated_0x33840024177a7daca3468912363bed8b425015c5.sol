1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.2;
3 
4 
5 //------------------------------------------------------------------------------------------------------------------
6 //
7 // ethbox Token
8 //
9 // Token symbol:    EBOX
10 // Token name:      ethbox Token
11 // 
12 // Total supply:    65.000.000 * 10^18
13 // Decimals:        18
14 //
15 //------------------------------------------------------------------------------------------------------------------
16 
17 
18 contract SafeMath
19 {
20     //
21     // Standard overflow / underflow proof basic maths library
22     //
23     
24     function safeAdd(uint a, uint b) public pure returns (uint c)
25     {
26         c = a + b;
27         require(c >= a);
28     }
29 
30     function safeSub(uint a, uint b) public pure returns (uint c)
31     {
32         require(b <= a);
33         c = a - b;
34     }
35 
36     function safeMul(uint a, uint b) public pure returns (uint c)
37     {
38         c = a * b;
39         require(a == 0 || c / a == b);
40     }
41 
42     function safeDiv(uint a, uint b) public pure returns (uint c)
43     {
44         require(b > 0);
45         c = a / b;
46     }
47 }
48 
49 
50 interface ERC20Interface
51 {
52     //
53     // Standard ERC-20 token interface
54     //
55     
56     function totalSupply() external view returns(uint);
57     function balanceOf(address tokenOwner) external view returns(uint);
58     function allowance(address tokenOwner, address spender) external view returns(uint);
59     function approve(address spender, uint tokens) external returns(bool);
60     function transfer(address to, uint tokens) external returns(bool);
61     function transferFrom(address from, address to, uint tokens) external returns(bool);
62 
63     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
64     event Transfer(address indexed from, address indexed to, uint tokens);
65 }
66 
67 
68 contract ethboxToken is ERC20Interface, SafeMath
69 {
70     //
71     // Standard ERC-20 token
72     //
73     
74 
75     string  public symbol       = "EBOX";
76     string  public name         = "ethbox Token";
77     uint8   public decimals     = 18;
78     uint    public _totalSupply = 65000000e18;
79     
80     mapping(address => uint) balances;
81     mapping(address => mapping(address => uint)) allowed;
82     
83     
84     constructor()
85     {
86         balances[msg.sender] = _totalSupply;
87         emit Transfer(address(0), msg.sender, _totalSupply);
88     }
89     
90     fallback() external payable
91     {
92         revert("Please don't send funds directly to the ethbox Token contract.");
93     }
94     
95     function totalSupply() override external view returns(uint)
96     {
97         return safeSub(_totalSupply, balances[address(0)]);
98     }
99 
100     function balanceOf(address tokenOwner) override external view returns(uint)
101     {
102         return balances[tokenOwner];
103     }
104     
105     function allowance(address tokenOwner, address spender) override external view returns(uint)
106     {
107         return allowed[tokenOwner][spender];
108     }
109     
110     function approve(address spender, uint tokens) override external returns(bool)
111     {
112         allowed[msg.sender][spender] = tokens;
113         
114         emit Approval(msg.sender, spender, tokens);
115         
116         return true;
117     }
118     
119     function transfer(address to, uint tokens) override external returns(bool)
120     {
121         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
122         balances[to] = safeAdd(balances[to], tokens);
123         
124         emit Transfer(msg.sender, to, tokens);
125         
126         return true;
127     }
128     
129     function transferFrom(address from, address to, uint tokens) override external returns(bool)
130     {
131         balances[from] = safeSub(balances[from], tokens);
132         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
133         balances[to] = safeAdd(balances[to], tokens);
134         
135         emit Transfer(from, to, tokens);
136         
137         return true;
138     }
139 }