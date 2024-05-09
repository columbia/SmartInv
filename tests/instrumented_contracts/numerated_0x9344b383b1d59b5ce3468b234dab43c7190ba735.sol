1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 
23 contract ERC20Interface {
24     function totalSupply() public constant returns (uint);
25     function balanceOf(address tokenOwner) public constant returns (uint balance);
26     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     function Owned() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 
68 contract NeedsCoin is ERC20Interface, Owned, SafeMath {
69     string public symbol;
70     string public  name;
71     uint8 public decimals;
72     uint public _totalSupply;
73 
74     mapping(address => uint) balances;
75     mapping(address => mapping(address => uint)) allowed;
76 
77 
78     function NeedsCoin() public {
79         symbol = "NCC";
80         name = "NeedsCoin";
81         decimals = 18;
82         _totalSupply = 1000000000000000000000000000;
83         balances[0x4C6b77c3a88ffb4993902ECF3cCE6044bd9178Ee] = _totalSupply;
84         Transfer(address(0), 0x4C6b77c3a88ffb4993902ECF3cCE6044bd9178Ee, _totalSupply);
85     }
86 
87 
88     function totalSupply() public constant returns (uint) {
89         return _totalSupply  - balances[address(0)];
90     }
91 
92 
93     function balanceOf(address tokenOwner) public constant returns (uint balance) {
94         return balances[tokenOwner];
95     }
96 
97 
98     function transfer(address to, uint tokens) public returns (bool success) {
99         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
100         balances[to] = safeAdd(balances[to], tokens);
101         Transfer(msg.sender, to, tokens);
102         return true;
103     }
104 
105 
106     function approve(address spender, uint tokens) public returns (bool success) {
107         allowed[msg.sender][spender] = tokens;
108         Approval(msg.sender, spender, tokens);
109         return true;
110     }
111 
112 
113     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
114         balances[from] = safeSub(balances[from], tokens);
115         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
116         balances[to] = safeAdd(balances[to], tokens);
117         Transfer(from, to, tokens);
118         return true;
119     }
120 
121 
122     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
123         return allowed[tokenOwner][spender];
124     }
125 
126 
127     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         Approval(msg.sender, spender, tokens);
130         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
131         return true;
132     }
133 
134 
135     function () public payable {
136         revert();
137     }
138 
139 
140     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
141         return ERC20Interface(tokenAddress).transfer(owner, tokens);
142     }
143 }