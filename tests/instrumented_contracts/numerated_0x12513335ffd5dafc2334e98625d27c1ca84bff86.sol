1 pragma solidity ^0.5.0;
2 
3 //--------------------------------------
4 //  AME Token contract
5 //
6 // Symbol      : AME
7 // Name        : AME Token
8 // Total supply: 1500000000
9 // Decimals    : 18
10 //--------------------------------------
11 
12 contract ERC20Interface {
13     function totalSupply() public view returns (uint256);
14     function balanceOf(address tokenOwner) public view returns (uint getBalance);
15     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
16     function transfer(address to, uint tokens) public returns (bool success);
17     function approve(address spender, uint tokens) public returns (bool success);
18     function transferFrom(address from, address to, uint tokens) public returns (bool success);
19     
20     event Transfer(address indexed from, address indexed to, uint tokens);
21     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
22     }
23 
24 // ----------------------------------------------------------------------------
25 // Safe Math Library 
26 // ----------------------------------------------------------------------------
27 contract SafeMath {
28     function safeAdd(uint a, uint b) public pure returns (uint c) {
29         c = a + b;
30         require(c >= a);
31     }
32 
33     function safeSub(uint a, uint b) public pure returns (uint c) {
34         require(b <= a); 
35         c = a - b; 
36     }
37 
38     function safeMul(uint a, uint b) public pure returns (uint c){
39     c = a * b; require(a == 0 || c / a == b);
40     }
41 
42     function safeDiv(uint a, uint b) public pure returns (uint c) {
43         require(b > 0);
44         c = a / b;
45     }
46 }
47 
48 contract AME is ERC20Interface, SafeMath{
49     bytes32 public name;
50     bytes32 public symbol;
51     uint8 public decimals;
52     uint256 private initialSupply;
53     uint256 public _totalSupply;
54     address private owner;
55    
56     mapping(address => uint) balances;
57     mapping(address => mapping(address => uint)) allowed;
58 
59     constructor() public {
60         name = "AME Token";
61         symbol = "AME";
62         decimals = 18;
63         _totalSupply = 1500000000 * 10 ** uint256(decimals);
64 	    initialSupply = _totalSupply;
65        	balances[msg.sender] = _totalSupply;
66         owner = msg.sender;
67         emit Transfer(address(0), msg.sender, _totalSupply);
68     }
69  
70     function totalSupply() public view returns (uint) {
71         return safeSub(_totalSupply, balances[address(0)]);
72     }
73 
74     function balanceOf(address tokenOwner) public view returns (uint getBalance) {
75         return balances[tokenOwner];
76     }
77  
78     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
79         return allowed[tokenOwner][spender];
80     }
81  
82     function approve(address spender, uint tokens) public returns (bool success) {
83         allowed[msg.sender][spender] = tokens;
84         emit Approval(msg.sender, spender, tokens);
85         return true;
86     }
87     
88     function transfer(address to, uint tokens) public returns (bool success) {
89         require(to != address(0));
90         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
91         balances[to] = safeAdd(balances[to], tokens);
92         emit Transfer(msg.sender, to, tokens);
93         return true;
94     }
95     
96    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
97         require(to != address(0));
98         balances[from] = safeSub(balances[from], tokens);
99         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
100         balances[to] = safeAdd(balances[to], tokens);
101         emit Transfer(from, to, tokens);
102         return true;
103    }
104    
105 }