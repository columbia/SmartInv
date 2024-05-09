1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'MLMY' token contract
5 //
6 // Deployed to : 0xf8DBDeDAAa95B5c5603523559166e93563b13B75
7 // Symbol      : MLMY
8 // Name        : MLM YOU
9 // Total supply: 15000000
10 // Decimals    : 1
11 
12 contract SafeMath {
13     function safeAdd(uint a, uint b) public pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function safeSub(uint a, uint b) public pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function safeMul(uint a, uint b) public pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function safeDiv(uint a, uint b) public pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
46 }
47 
48 
49 
50 contract Owned {
51     address public owner;
52     address public newOwner;
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 contract MLMYou is ERC20Interface, Owned, SafeMath {
77     string public symbol;
78     string public  name;
79     uint8 public decimals;
80     uint public _totalSupply;
81 
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85 
86     constructor() public {
87         symbol = "MLMY";
88         name = "MLM YOU";
89         decimals = 1;
90         _totalSupply = 15000000;
91         balances[0xf8DBDeDAAa95B5c5603523559166e93563b13B75] = _totalSupply;
92         emit Transfer(address(0), 0xf8DBDeDAAa95B5c5603523559166e93563b13B75, _totalSupply);
93     }
94 
95 
96     function totalSupply() public constant returns (uint) {
97         return _totalSupply  - balances[address(0)];
98     }
99 
100 
101 
102     function balanceOf(address tokenOwner) public constant returns (uint balance) {
103         return balances[tokenOwner];
104     }
105 
106     function transfer(address to, uint tokens) public returns (bool success) {
107         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
108         balances[to] = safeAdd(balances[to], tokens);
109         emit Transfer(msg.sender, to, tokens);
110         return true;
111     }
112 
113     function approve(address spender, uint tokens) public returns (bool success) {
114         allowed[msg.sender][spender] = tokens;
115         emit Approval(msg.sender, spender, tokens);
116         return true;
117     }
118 
119     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
120         balances[from] = safeSub(balances[from], tokens);
121         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
122         balances[to] = safeAdd(balances[to], tokens);
123         emit Transfer(from, to, tokens);
124         return true;
125     }
126 
127     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
128         return allowed[tokenOwner][spender];
129     }
130 
131 
132     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender, spender, tokens);
135         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
136         return true;
137     }
138 
139 
140     function () public payable {
141         revert();
142     }
143 
144     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
145         return ERC20Interface(tokenAddress).transfer(owner, tokens);
146     }
147 }