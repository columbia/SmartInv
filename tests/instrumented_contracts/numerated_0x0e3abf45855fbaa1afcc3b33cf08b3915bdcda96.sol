1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Rainbow' Token Contract
5 //
6 // Deployed To : 0xb39796f9ADF2093F1945a095A0fB866087c5f5F2
7 // Symbol      : XRB
8 // Name        : Rainbow
9 // Total Supply: 6000000 XRB
10 // Decimals    : 8
11 //
12 // (c) By 'Rainbow Foundation' With 'XRB' Symbol 2019. The MIT Licence.
13 // ERC20 Smart Contract Developed By: https://SoftCode.space Blockchain Developer Team.
14 // ----------------------------------------------------------------------------
15 
16 
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
36 
37 contract ERC20Interface {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
52 }
53 
54 
55 contract Owned {
56     address public owner;
57     address public newOwner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     function Owned() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78     }
79 }
80 
81 
82 contract Rainbow is ERC20Interface, Owned, SafeMath {
83     string public symbol;
84     string public  name;
85     uint8 public decimals;
86     uint public _totalSupply;
87 
88     mapping(address => uint) balances;
89     mapping(address => mapping(address => uint)) allowed;
90 
91 
92     function Rainbow() public {
93         symbol = "XRB";
94         name = "Rainbow";
95         decimals = 8;
96         _totalSupply = 600000000000000;
97         balances[0xb39796f9ADF2093F1945a095A0fB866087c5f5F2] = _totalSupply;
98         Transfer(address(0), 0xb39796f9ADF2093F1945a095A0fB866087c5f5F2, _totalSupply);
99     }
100 
101 
102     function totalSupply() public constant returns (uint) {
103         return _totalSupply  - balances[address(0)];
104     }
105 
106 
107     function balanceOf(address tokenOwner) public constant returns (uint balance) {
108         return balances[tokenOwner];
109     }
110 
111 
112     function transfer(address to, uint tokens) public returns (bool success) {
113         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
114         balances[to] = safeAdd(balances[to], tokens);
115         Transfer(msg.sender, to, tokens);
116         return true;
117     }
118 
119 
120     function approve(address spender, uint tokens) public returns (bool success) {
121         allowed[msg.sender][spender] = tokens;
122         Approval(msg.sender, spender, tokens);
123         return true;
124     }
125 
126 
127     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
128         balances[from] = safeSub(balances[from], tokens);
129         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
130         balances[to] = safeAdd(balances[to], tokens);
131         Transfer(from, to, tokens);
132         return true;
133     }
134 
135 
136     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
137         return allowed[tokenOwner][spender];
138     }
139 
140 
141     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
142         allowed[msg.sender][spender] = tokens;
143         Approval(msg.sender, spender, tokens);
144         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
145         return true;
146     }
147 
148 
149     function () public payable {
150         revert();
151     }
152 
153 
154     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
155         return ERC20Interface(tokenAddress).transfer(owner, tokens);
156     }
157 }