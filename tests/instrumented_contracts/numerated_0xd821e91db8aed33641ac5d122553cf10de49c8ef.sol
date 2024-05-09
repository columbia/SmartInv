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
33 contract NFTeGG_Fame_Token is ERC20Interface, SafeMath {
34     string public name;
35     string public symbol;
36     uint8 public decimals; 
37     
38     uint256 public _totalSupply;
39     
40     mapping(address => uint) balances;
41     mapping(address => mapping(address => uint)) allowed;
42     
43     /**
44      * Constructor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     constructor() public {
49         name = "NFTeGG Fame Token";
50         symbol = "eFAME";
51         decimals = 18;
52         _totalSupply = 10000000000000000000000000;
53         
54         balances[msg.sender] = _totalSupply;
55         emit Transfer(address(0), msg.sender, _totalSupply);
56     }
57     
58     function totalSupply() public view returns (uint) {
59         return _totalSupply  - balances[address(0)];
60     }
61     
62     function balanceOf(address tokenOwner) public view returns (uint balance) {
63         return balances[tokenOwner];
64     }
65     
66     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
67         return allowed[tokenOwner][spender];
68     }
69     
70     function approve(address spender, uint tokens) public returns (bool success) {
71         allowed[msg.sender][spender] = tokens;
72         emit Approval(msg.sender, spender, tokens);
73         return true;
74     }
75     
76     function transfer(address to, uint tokens) public returns (bool success) {
77         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
78         balances[to] = safeAdd(balances[to], tokens);
79         emit Transfer(msg.sender, to, tokens);
80         return true;
81     }
82     
83     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
84         balances[from] = safeSub(balances[from], tokens);
85         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
86         balances[to] = safeAdd(balances[to], tokens);
87         emit Transfer(from, to, tokens);
88         return true;
89     }
90 }