1 pragma solidity ^0.4.24;
2 
3 // FLICoin
4 // Krizzy 2019
5 
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ERC20 Interface
27 
28 contract ERC20Interface {
29     function totalSupply() public constant returns (uint);
30     function balanceOf(address tokenOwner) public constant returns (uint balance);
31     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
32     function transfer(address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns (bool success);
34     function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 contract ApproveAndCallFallBack {
41     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
42 }
43 
44 
45 // Owned contract
46 
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 
74 // FLICoin details and transfer functions.
75 
76 contract FLICoin is ERC20Interface, Owned, SafeMath {
77     string public symbol;
78     string public  name;
79     uint8 public decimals;
80     uint public _totalSupply;
81 
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85     constructor() public {
86         symbol = "FLI";
87         name = "FLICoin";
88         decimals = 4;
89         _totalSupply = 10000000000;
90         balances[0xe03766D5219C40970126a6f139aae20dDA81Dcf5] = _totalSupply;
91         emit Transfer(address(0), 0xe03766D5219C40970126a6f139aae20dDA81Dcf5, _totalSupply);
92     }
93 
94 
95     // Coin supply
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
106 
107         uint256 CoinTransfer = safeSub(tokens, 500000);  //Subtract 50 coins from transaction
108 
109         balances[to] = safeAdd(balances[to], CoinTransfer);
110 
111         emit Transfer(msg.sender, to, CoinTransfer);
112         emit Transfer(msg.sender, address(0), 500000);  //Burn 50 coins
113         return true;
114     }
115 
116     function approve(address spender, uint tokens) public returns (bool success) {
117         allowed[msg.sender][spender] = tokens;
118         emit Approval(msg.sender, spender, tokens);
119         return true;
120     }
121 
122     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
123         balances[from] = safeSub(balances[from], tokens);
124 
125         uint256 CoinTransfer = safeSub(tokens, 500000);
126 
127         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
128         balances[to] = safeAdd(balances[to], CoinTransfer);
129 
130         emit Transfer(from, to, CoinTransfer);
131         emit Transfer(msg.sender, address(0), 500000);
132         return true;
133     }
134 
135     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
136         return allowed[tokenOwner][spender];
137     }
138 
139     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
140         allowed[msg.sender][spender] = tokens;
141         emit Approval(msg.sender, spender, tokens);
142         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
143         return true;
144     }
145 
146 
147     // Don't accept ETH
148 
149     function () public payable {
150         revert();
151     }
152 
153     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
154         return ERC20Interface(tokenAddress).transfer(owner, tokens);
155     }
156 }