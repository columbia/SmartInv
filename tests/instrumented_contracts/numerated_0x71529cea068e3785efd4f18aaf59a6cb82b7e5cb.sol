1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'BBX' token contract
5 //
6 // Deployed to : 0xEF871E2F799bbF939964E9b707Cb2805EB4Bd515
7 // Symbol      : BBX
8 // Name        : BBXCoin
9 // Total supply: 19999999
10 // Decimals    : 18
11 //
12 // Ronald 
13 // Danushka
14 // 
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
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
87 contract BBXCoin is ERC20Interface, Owned, SafeMath {
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint public _totalSupply;
92 
93     mapping(address => uint) balances;
94     mapping(address => mapping(address => uint)) allowed;
95 
96 
97     function BBXCoin() public {
98         symbol = "BBX";
99         name = "BBXCoin";
100         decimals = 18;
101         _totalSupply = 19999999000000000000000000;
102         balances[0xEF871E2F799bbF939964E9b707Cb2805EB4Bd515] = _totalSupply;
103         Transfer(address(0), 0xEF871E2F799bbF939964E9b707Cb2805EB4Bd515, _totalSupply);
104     }
105 
106 
107     function totalSupply() public constant returns (uint) {
108         return _totalSupply - balances[address(0)];
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
132 
133     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
134         balances[from] = safeSub(balances[from], tokens);
135         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         Transfer(from, to, tokens);
138         return true;
139     }
140 
141 
142     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
143         return allowed[tokenOwner][spender];
144     }
145 
146 
147 
148     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
149         allowed[msg.sender][spender] = tokens;
150         Approval(msg.sender, spender, tokens);
151         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
152         return true;
153     }
154 
155 
156     function () public payable {
157         revert();
158     }
159 
160 
161     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
162         return ERC20Interface(tokenAddress).transfer(owner, tokens);
163     }
164 }