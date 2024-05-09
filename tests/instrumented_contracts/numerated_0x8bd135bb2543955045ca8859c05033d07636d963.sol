1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.10;
4 
5 //--------------------------------------
6 //  EVAI contract
7 //
8 // Symbol      : EV
9 // Name        : EVAI
10 // Total supply: 1000000000
11 // Decimals    : 8
12 //--------------------------------------
13 
14 abstract contract ERC20Interface {
15     function totalSupply() virtual external view returns (uint256);
16     function balanceOf(address tokenOwner) virtual external view returns (uint);
17     function allowance(address tokenOwner, address spender) virtual external view returns (uint);
18     function transfer(address to, uint tokens) virtual external returns (bool);
19     function approve(address spender, uint tokens) virtual external returns (bool);
20     function transferFrom(address from, address to, uint tokens) virtual external returns (bool);
21     function burn(uint tokens) virtual external returns(bool success);
22     function buy(address to, uint tokens) virtual external returns (bool);
23     function operationProfit(uint _profit) virtual external returns(bool);
24     
25  
26     event Transfer(address indexed from, address indexed to, uint tokens);
27     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
28     event Burn(address from, address, uint256 value);
29     event Profit(address from, uint profit, uint totalProfit);
30 
31     }
32 
33 // ----------------------------------------------------------------------------
34 // Safe Math Library 
35 // ----------------------------------------------------------------------------
36 contract SafeMath {
37     function safeAdd(uint a, uint b) public pure returns (uint c) {
38         c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40         return c;
41     }
42 
43     function safeSub(uint a, uint b) public pure returns (uint c) {
44         require(b <= a, "SafeMath: subtraction overflow"); 
45         c = a - b; 
46         return c;
47     }
48 
49 }
50 
51 contract Evaitoken is ERC20Interface, SafeMath{
52     string public name;
53     string public symbol;
54     uint8 public decimals;
55     uint256 public initialSupply;
56     uint256 public _totalSupply;
57     address public owner;
58     uint public totalProfit;
59     uint public profit;
60    
61     mapping(address => uint) internal balances;
62     mapping(address => mapping(address => uint)) internal allowed;
63     mapping(uint256 => uint256) internal token;
64     
65     
66     constructor() public {
67         name = "EVAI";
68         symbol = "Ev";
69         decimals = 8;
70         _totalSupply = 1000000000 * 10 ** uint256(decimals);
71 	    initialSupply = _totalSupply;
72 	    balances[msg.sender] = _totalSupply;
73         owner = msg.sender;
74         emit Transfer(address(0), msg.sender, _totalSupply);
75     }
76     
77    
78  
79     function totalSupply() external view override returns (uint256) {
80         return safeSub(_totalSupply, balances[address(0)]);
81     }
82 
83     function balanceOf(address tokenOwner) external view override returns (uint getBalance) {
84         return balances[tokenOwner];
85     }
86  
87     function allowance(address tokenOwner, address spender) external view override returns (uint remaining) {
88         return allowed[tokenOwner][spender];
89     }
90  
91     function approve(address spender, uint tokens) external override returns (bool success) {
92         allowed[msg.sender][spender] = tokens;
93         emit Approval(msg.sender, spender, tokens);
94         return true;
95     }
96     
97     function transfer(address to, uint tokens) external override returns (bool success) {
98         require(to != address(0));
99         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
100         balances[to] = safeAdd(balances[to], tokens);
101         emit Transfer(msg.sender, to, tokens);
102         return true;
103     }
104     
105    function transferFrom(address from, address to, uint tokens) external override returns (bool success) {
106         require(to != address(0));
107         balances[from] = safeSub(balances[from], tokens);
108         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         emit Transfer(from, to, tokens);
111         return true;
112    }
113    
114    function buy(address to, uint tokens) external override returns (bool success) {
115         require(to != address(0));
116         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
117         balances[to] = safeAdd(balances[to], tokens);
118         emit Transfer(msg.sender, to, tokens);
119         return true;
120     }
121     
122     function operationProfit(uint _profit) external override returns(bool success){
123         require(owner == msg.sender,'This is not owner');
124          profit = _profit;
125          totalProfit = safeAdd(totalProfit, profit);
126          emit Profit(msg.sender, profit, totalProfit);
127          return true;
128         
129     }
130     
131     function burn(uint tokens) external  override returns(bool success){
132         require(owner == msg.sender,'This is not owner');
133         balances[msg.sender] = safeSub(balances[msg.sender],tokens);
134         _totalSupply = safeSub(_totalSupply,tokens);
135         emit Burn(msg.sender,address(0), tokens);
136         return true;
137     }
138     
139      
140     
141   
142     
143  }