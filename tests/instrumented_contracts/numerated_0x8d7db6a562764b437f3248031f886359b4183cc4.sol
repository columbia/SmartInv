1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 //
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8     function totalSupply() public view returns (uint);
9     function balanceOf(address tokenOwner) public view returns (uint balance);
10     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 // ----------------------------------------------------------------------------
20 // Safe Math Library 
21 // ----------------------------------------------------------------------------
22 contract SafeMath {
23     function safeAdd(uint a, uint b) public pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function safeSub(uint a, uint b) public pure returns (uint c) {
28         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 contract SSS is ERC20Interface, SafeMath {
35     string public name;
36     string public symbol;
37     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
38     
39     uint256 public _totalSupply;
40     
41     mapping(address => uint) balances;
42     mapping(address => mapping(address => uint)) allowed;
43     
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     constructor() public {
50         name = "SSS Finance";
51         symbol = "SSS";
52         decimals = 18;
53         _totalSupply = 9000000000000000000000;
54         
55         balances[msg.sender] = _totalSupply;
56         emit Transfer(address(0), msg.sender, _totalSupply);
57     }
58     
59     function totalSupply() public view returns (uint) {
60         return _totalSupply  - balances[address(0)];
61     }
62     
63     function balanceOf(address tokenOwner) public view returns (uint balance) {
64         return balances[tokenOwner];
65     }
66     
67     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
68         return allowed[tokenOwner][spender];
69     }
70     
71     function approve(address spender, uint tokens) public returns (bool success) {
72         allowed[msg.sender][spender] = tokens;
73         emit Approval(msg.sender, spender, tokens);
74         return true;
75     }
76     
77     function transfer(address to, uint tokens) public returns (bool success) {
78         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
79         balances[to] = safeAdd(balances[to], tokens);
80         emit Transfer(msg.sender, to, tokens);
81         return true;
82     }
83     
84     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
85         balances[from] = safeSub(balances[from], tokens);
86         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
87         balances[to] = safeAdd(balances[to], tokens);
88         emit Transfer(from, to, tokens);
89         return true;
90     }
91 }