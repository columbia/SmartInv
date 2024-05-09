1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-05
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 // ----------------------------------------------------------------------------
8 // 'CRSTK' Token Contract
9 //
10 
11 // Deployed To : 0x6B6BadE971C10ce6c13951963e112F7CEfB0B25c
12 // Name        : CRS Token
13 // Symbol      : CRSTK
14 // Total Supply: 98,000,000 CRSTK
15 // Decimals    : 18
16 //  
17 // (c) By 'CRS Token' With 'CRSTK' Symbol 2020.
18 // ERC20 Smart Contract Developed By: Coinxpo Blockchain Developer Team.
19 // ----------------------------------------------------------------------------
20 
21 
22 contract SafeMath {
23     function safeAdd(uint a, uint b) public pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function safeSub(uint a, uint b) public pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function safeMul(uint a, uint b) public pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function safeDiv(uint a, uint b) public pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58 
59 
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     function Owned() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 contract CRSTK is ERC20Interface, Owned, SafeMath {
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint public _totalSupply;
92 
93     mapping(address => uint) balances;
94     mapping(address => mapping(address => uint)) allowed;
95 
96 
97     function CRSTK() public {
98         symbol = "CRSTK";
99         name = "CRS Token";
100         decimals = 18;
101         _totalSupply = 98000000000000000000000000;
102         balances[0x2f77401f74424BBa6f25b239D1440bc5e1D79bb0] = _totalSupply;
103         Transfer(address(0), 0x2f77401f74424BBa6f25b239D1440bc5e1D79bb0, _totalSupply);
104     }
105 
106 
107     function totalSupply() public constant returns (uint) {
108         return _totalSupply  - balances[address(0)];
109     }
110 
111 
112     function balanceOf(address tokenOwner) public constant returns (uint balance) {
113         return balances[tokenOwner];
114     }
115 
116 
117     function transfer(address to, uint tokens) public returns (bool success) {
118         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
119         balances[to] = safeAdd(balances[to], tokens);
120         Transfer(msg.sender, to, tokens);
121         return true;
122     }
123 
124 
125     function approve(address spender, uint tokens) public returns (bool success) {
126         allowed[msg.sender][spender] = tokens;
127         Approval(msg.sender, spender, tokens);
128         return true;
129     }
130 
131 
132     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
133         balances[from] = safeSub(balances[from], tokens);
134         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
135         balances[to] = safeAdd(balances[to], tokens);
136         Transfer(from, to, tokens);
137         return true;
138     }
139 
140 
141     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
142         return allowed[tokenOwner][spender];
143     }
144 
145 
146     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         Approval(msg.sender, spender, tokens);
149         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
150         return true;
151     }
152 
153 
154     function () public payable {
155         revert();
156     }
157 
158 
159     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
160         return ERC20Interface(tokenAddress).transfer(owner, tokens);
161     }
162 }