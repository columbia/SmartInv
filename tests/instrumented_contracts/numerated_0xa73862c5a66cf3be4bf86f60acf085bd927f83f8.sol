1 pragma solidity ^0.4.24;
2 contract SafeMath {
3     function safeAdd(uint a, uint b) public pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function safeSub(uint a, uint b) public pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function safeMul(uint a, uint b) public pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function safeDiv(uint a, uint b) public pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 
21 contract ERC20Interface {
22     function totalSupply() public constant returns (uint);
23     function balanceOf(address tokenOwner) public constant returns (uint balance);
24     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
25     function transfer(address to, uint tokens) public returns (bool success);
26     function approve(address spender, uint tokens) public returns (bool success);
27     function transferFrom(address from, address to, uint tokens) public returns (bool success);
28 
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 
33 contract ApproveAndCallFallBack {
34     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
35 }
36 
37 contract MyToken is ERC20Interface, SafeMath {
38     string public symbol;
39     string public  name;
40     uint8 public decimals;
41     uint public _totalSupply;
42 
43     mapping(address => uint) balances;
44     mapping(address => mapping(address => uint)) allowed;
45     constructor(
46         string tokenName,
47         string tokenSymbol,
48         uint8  tokenDecimals,
49         uint256 initialSupply
50     ) public {
51         name = tokenName;
52         symbol = tokenSymbol;
53         decimals = tokenDecimals;
54         _totalSupply = initialSupply * 10 ** uint256(tokenDecimals); 
55         balances[msg.sender] = _totalSupply;
56         emit Transfer(address(0), msg.sender, _totalSupply);
57     }
58 
59     function totalSupply() public constant returns (uint) {
60         return _totalSupply  - balances[address(0)];
61     }
62 
63     function balanceOf(address tokenOwner) public constant returns (uint balance) {
64         return balances[tokenOwner];
65     }
66 
67     function transfer(address to, uint tokens) public returns (bool success) {
68         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
69         balances[to] = safeAdd(balances[to], tokens);
70         emit Transfer(msg.sender, to, tokens);
71         return true;
72     }
73 
74     function approve(address spender, uint tokens) public returns (bool success) {
75         allowed[msg.sender][spender] = tokens;
76         emit Approval(msg.sender, spender, tokens);
77         return true;
78     }
79 
80     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
81         balances[from] = safeSub(balances[from], tokens);
82         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
83         balances[to] = safeAdd(balances[to], tokens);
84         emit Transfer(from, to, tokens);
85         return true;
86     }
87 
88     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
89         return allowed[tokenOwner][spender];
90     }
91 
92     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
93         allowed[msg.sender][spender] = tokens;
94         emit Approval(msg.sender, spender, tokens);
95         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
96         return true;
97     }
98 
99     function () public payable {
100         revert();
101     }
102 
103 }