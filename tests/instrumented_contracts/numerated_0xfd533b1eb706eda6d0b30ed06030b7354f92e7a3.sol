1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // MIECHA contract
5 //
6 // Deployed to : 0xfDfA06e61Ee4322681F9DEF4feBc2D2228E3a7dC
7 // Symbol      : MICA
8 // Name        : MIECHA
9 // Total supply: 100,000,000.000000
10 //
11 // This token represents the Machine Intelligence Emergence Contract for Human Assimilation (MIECHA)
12 //
13 // The entire contract will be released by the MIECHA Organization and can be found on the following web address: miecha.org/contract.html
14 // 
15 // February 20, 2019
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 contract ERC20Interface {
37     function totalSupply() public constant returns (uint);
38     function balanceOf(address tokenOwner) public constant returns (uint balance);
39     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
40     function transfer(address to, uint tokens) public returns (bool success);
41     function approve(address spender, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43 
44     event Transfer(address indexed from, address indexed to, uint tokens);
45     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
46 }
47 
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 contract Owned {
53     address public owner;
54     address public newOwner;
55 
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57 
58     function Owned() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address _newOwner) public onlyOwner {
68         newOwner = _newOwner;
69     }
70     function acceptOwnership() public {
71         require(msg.sender == newOwner);
72         OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74         newOwner = address(0);
75     }
76 }
77 
78 contract MIECHA is ERC20Interface, Owned, SafeMath {
79     string public symbol;
80     string public  name;
81     uint8 public decimals;
82     uint public _totalSupply;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87     function MIECHA() public {
88         symbol = "MICA";
89         name = "MIECHA";
90         decimals = 6;
91         _totalSupply = 100000000000000;
92         balances[0xfDfA06e61Ee4322681F9DEF4feBc2D2228E3a7dC] = _totalSupply;
93         Transfer(address(0), 0xfDfA06e61Ee4322681F9DEF4feBc2D2228E3a7dC, _totalSupply);
94     }
95 
96     function totalSupply() public constant returns (uint) {
97         return _totalSupply  - balances[address(0)];
98     }
99 
100     function balanceOf(address tokenOwner) public constant returns (uint balance) {
101         return balances[tokenOwner];
102     }
103 
104     function transfer(address to, uint tokens) public returns (bool success) {
105         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
106         balances[to] = safeAdd(balances[to], tokens);
107         Transfer(msg.sender, to, tokens);
108         return true;
109     }
110 
111     function approve(address spender, uint tokens) public returns (bool success) {
112         allowed[msg.sender][spender] = tokens;
113         Approval(msg.sender, spender, tokens);
114         return true;
115     }
116 
117     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
118         balances[from] = safeSub(balances[from], tokens);
119         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         Transfer(from, to, tokens);
122         return true;
123     }
124 
125     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
126         return allowed[tokenOwner][spender];
127     }
128 
129     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
130         allowed[msg.sender][spender] = tokens;
131         Approval(msg.sender, spender, tokens);
132         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
133         return true;
134     }
135 
136     function () public payable {
137         revert();
138     }
139 
140     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
141         return ERC20Interface(tokenAddress).transfer(owner, tokens);
142     }
143 }