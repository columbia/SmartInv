1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-05
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.6.10;
8 
9 //--------------------------------------
10 //  GIFX contract
11 //
12 // Symbol      : GIFX
13 // Name        : GIFA Token 
14 // Total supply: 20100000000
15 // Decimals    : 15
16 //--------------------------------------
17 
18 abstract contract ERC20Interface {
19     function totalSupply() virtual external view returns (uint256);
20     function balanceOf(address tokenOwner) virtual external view returns (uint);
21     function allowance(address tokenOwner, address spender) virtual external view returns (uint);
22     function transfer(address to, uint tokens) virtual external returns (bool);
23     function approve(address spender, uint tokens) virtual external returns (bool);
24     function transferFrom(address from, address to, uint tokens) virtual external returns (bool);
25     function mint(uint256 tokens)virtual external returns(bool);
26     
27     event Transfer(address indexed from, address indexed to, uint tokens);
28     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
29     event Mint(address from, address, uint256 tokens);
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
51 contract Gifatoken is ERC20Interface, SafeMath{
52     string public name;
53     string public symbol;
54     uint8 public decimals;
55     uint256 public initialSupply;
56     uint256 public _totalSupply;
57     address public owner;
58     
59    
60     mapping(address => uint) internal balances;
61     mapping(address => mapping(address => uint)) internal allowed;
62     mapping(uint256 => uint256) internal token;
63     
64     
65     constructor() public {
66         name = "GIFA Token";
67         symbol = "GIFX";
68         decimals = 15;
69         _totalSupply = 20100000000 * 10 ** uint256(decimals);
70 	    initialSupply = _totalSupply;
71 	    balances[msg.sender] = _totalSupply;
72         owner = msg.sender;
73         emit Transfer(address(0), msg.sender, _totalSupply);
74     }
75     
76    
77  
78     function totalSupply() external view override returns (uint256) {
79         return safeSub(_totalSupply, balances[address(0)]);
80     }
81 
82     function balanceOf(address tokenOwner) external view override returns (uint getBalance) {
83         return balances[tokenOwner];
84     }
85  
86     function allowance(address tokenOwner, address spender) external view override returns (uint remaining) {
87         return allowed[tokenOwner][spender];
88     }
89  
90     function approve(address spender, uint tokens) external override returns (bool success) {
91         allowed[msg.sender][spender] = tokens;
92         emit Approval(msg.sender, spender, tokens);
93         return true;
94     }
95     
96     function transfer(address to, uint tokens) external override returns (bool success) {
97         require(to != address(0));
98         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
99         balances[to] = safeAdd(balances[to], tokens);
100         emit Transfer(msg.sender, to, tokens);
101         return true;
102     }
103     
104    function transferFrom(address from, address to, uint tokens) external override returns (bool success) {
105         require(to != address(0));
106         balances[from] = safeSub(balances[from], tokens);
107         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
108         balances[to] = safeAdd(balances[to], tokens);
109         emit Transfer(from, to, tokens);
110         return true;
111    }
112    
113    function mint(uint256 tokens) external override returns(bool success){
114        require(owner == msg.sender, 'This is not owner');
115        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
116        _totalSupply = safeAdd(tokens, _totalSupply);
117        emit Mint( msg.sender, address(0), tokens);
118        return true;
119    }
120    
121    
122 }