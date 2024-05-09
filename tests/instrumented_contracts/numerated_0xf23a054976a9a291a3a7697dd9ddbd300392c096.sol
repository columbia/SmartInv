1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // ----------------------------------------------------------------------------
6 contract ERC20Interface {
7     function totalSupply() public view returns (uint);
8     function balanceOf(address tokenOwner) public view returns (uint balance);
9     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 // ----------------------------------------------------------------------------
19 // Safe Math Library 
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a); 
28         c = a - b; 
29     } 
30     function safeMul(uint a, uint b) public pure returns (uint c) { 
31         c = a * b; 
32         require(a == 0 || c / a == b); 
33     } 
34     function safeDiv(uint a, uint b) public pure returns (uint c) { 
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 contract BVB is ERC20Interface, SafeMath {
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     
46     uint256 public _totalSupply;
47     
48     mapping(address => uint) balances;
49     mapping(address => mapping(address => uint)) allowed;
50     
51     /**
52      * Constrctor function
53      *
54      * Initializes contract with initial supply tokens to the creator of the contract
55      */
56     constructor() public {
57         name = "BvB";
58         symbol = "BvB";
59         decimals = 18;
60         _totalSupply = 5 * 10 ** 25;
61         
62         balances[msg.sender] = _totalSupply;
63         emit Transfer(address(0), msg.sender, _totalSupply);
64     }
65     
66     function totalSupply() public view returns (uint) {
67         return _totalSupply  - balances[address(0)];
68     }
69     
70     function balanceOf(address tokenOwner) public view returns (uint balance) {
71         return balances[tokenOwner];
72     }
73     
74     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
75         return allowed[tokenOwner][spender];
76     }
77     
78     function approve(address spender, uint tokens) public returns (bool success) {
79         allowed[msg.sender][spender] = tokens;
80         emit Approval(msg.sender, spender, tokens);
81         return true;
82     }
83     
84     function transfer(address to, uint tokens) public returns (bool success) {
85         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
86         balances[to] = safeAdd(balances[to], tokens);
87         emit Transfer(msg.sender, to, tokens);
88         return true;
89     }
90     
91     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
92         balances[from] = safeSub(balances[from], tokens);
93         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
94         balances[to] = safeAdd(balances[to], tokens);
95         emit Transfer(from, to, tokens);
96         return true;
97     }
98 }