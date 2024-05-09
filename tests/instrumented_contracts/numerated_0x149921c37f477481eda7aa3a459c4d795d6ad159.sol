1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // ==> Vote Your Token for Pumps with VPC0x
5 // ==> Website https://votepumpcoin.me
6 // ==> Telegram : https://t.me/vpc0x_official
7 // ----------------------------------------------------------------------------
8 
9 contract SafeMath {
10     function safeAdd(uint a, uint b) public pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function safeMul(uint a, uint b) public pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function safeDiv(uint a, uint b) public pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     function Owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         newOwner = _newOwner;
63     }
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69     }
70 }
71 
72 
73 contract VotePumpCoin0x is ERC20Interface, Owned, SafeMath {
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint public _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82     function VotePumpCoin0x() public {
83         symbol = "VPC0x";
84         name = "VotePumpCOin0x";
85         decimals = 18;
86         _totalSupply = 46000000000000000000000000;
87         balances[owner] = _totalSupply;
88         Transfer(address(0), owner, _totalSupply);
89     }
90 
91 
92     function totalSupply() public constant returns (uint) {
93         return _totalSupply  - balances[address(0)];
94     }
95 
96     function balanceOf(address tokenOwner) public constant returns (uint balance) {
97         return balances[tokenOwner];
98     }
99 
100 
101 
102     function transfer(address to, uint tokens) public returns (bool success) {
103         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);
105         Transfer(msg.sender, to, tokens);
106         return true;
107     }
108 
109 
110     function approve(address spender, uint tokens) public returns (bool success) {
111         allowed[msg.sender][spender] = tokens;
112         Approval(msg.sender, spender, tokens);
113         return true;
114     }
115 
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
136     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
137         return ERC20Interface(tokenAddress).transfer(owner, tokens);
138     }
139 }