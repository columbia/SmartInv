1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'MWorld' Token Contract
5 //
6 // Deployed To : 0x33a0924b74b8ec4bc654a5dfd6603a7c27ab0af4
7 // Symbol      : MWE
8 // Name        : MWorld
9 // Total Supply: 2,000,000,000 MWE
10 // Token Value : 1 MWE = USD 0.01
11 // Decimals    : 8
12 //
13 // (c) By 'MWorld' With 'MWE' Symbol 2019. The MIT Licence.
14 // ERC20 Smart Contract Developed By: https://SoftCode.space Blockchain Developer Team.
15 // ----------------------------------------------------------------------------
16 
17 
18 contract SafeMath {
19     function safeAdd(uint a, uint b) public pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) public pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) public pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) public pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 contract ApproveAndCallFallBack {
52     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
53 }
54 
55 
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     function Owned() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 contract MWorld is ERC20Interface, Owned, SafeMath {
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint public _totalSupply;
88 
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92 
93     function MWorld() public {
94         symbol = "MWE";
95         name = "MWorld";
96         decimals = 8;
97         _totalSupply = 200000000000000000;
98         balances[0xd2c01f9b4e1a200e0e7d0a8d179b621f1cbd25a2] = _totalSupply;
99         Transfer(address(0), 0xd2c01f9b4e1a200e0e7d0a8d179b621f1cbd25a2, _totalSupply);
100     }
101 
102 
103     function totalSupply() public constant returns (uint) {
104         return _totalSupply  - balances[address(0)];
105     }
106 
107 
108     function balanceOf(address tokenOwner) public constant returns (uint balance) {
109         return balances[tokenOwner];
110     }
111 
112 
113     function transfer(address to, uint tokens) public returns (bool success) {
114         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
115         balances[to] = safeAdd(balances[to], tokens);
116         Transfer(msg.sender, to, tokens);
117         return true;
118     }
119 
120 
121     function approve(address spender, uint tokens) public returns (bool success) {
122         allowed[msg.sender][spender] = tokens;
123         Approval(msg.sender, spender, tokens);
124         return true;
125     }
126 
127 
128     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
129         balances[from] = safeSub(balances[from], tokens);
130         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
131         balances[to] = safeAdd(balances[to], tokens);
132         Transfer(from, to, tokens);
133         return true;
134     }
135 
136 
137     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
138         return allowed[tokenOwner][spender];
139     }
140 
141 
142     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
143         allowed[msg.sender][spender] = tokens;
144         Approval(msg.sender, spender, tokens);
145         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
146         return true;
147     }
148 
149 
150     function () public payable {
151         revert();
152     }
153 
154 
155     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
156         return ERC20Interface(tokenAddress).transfer(owner, tokens);
157     }
158 }