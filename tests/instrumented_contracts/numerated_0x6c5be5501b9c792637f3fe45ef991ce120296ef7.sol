1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'SuomenMarkka' token contract
5 //
6 // Deployed to : 0x9bcb2b841Ef87d7238f4D3b1D0B2af7cef6D0604
7 // Symbol      : FIM
8 // Name        : SuomenMarkka
9 // Total supply: 1000000000000
10 // Decimals    : 2
11 //
12 // I own this project to my loved family. I thank you for the support and love you have given me :)
13 // especially with this ambitious and possibly stupid idea
14 //
15 // ----------------------------------------------------------------------------
16 
17 
18 
19 contract SafeMath {
20     function safeAdd(uint a, uint b) public pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) public pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) public pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) public pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
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
87 
88 contract SuomenMarkka is ERC20Interface, Owned, SafeMath {
89     string public symbol;
90     string public  name;
91     uint8 public decimals;
92     uint public _totalSupply;
93 
94     mapping(address => uint) balances;
95     mapping(address => mapping(address => uint)) allowed;
96 
97 
98     function SuomenMarkka() public {
99         symbol = "FIM";
100         name = "SuomenMarkka";
101         decimals = 2;
102         _totalSupply = 1000000000000;
103         balances[0x9bcb2b841Ef87d7238f4D3b1D0B2af7cef6D0604] = _totalSupply;
104         Transfer(address(0), 0x9bcb2b841Ef87d7238f4D3b1D0B2af7cef6D0604, _totalSupply);
105     }
106 
107 
108 
109     function totalSupply() public constant returns (uint) {
110         return _totalSupply  - balances[address(0)];
111     }
112 
113 
114 
115     function balanceOf(address tokenOwner) public constant returns (uint balance) {
116         return balances[tokenOwner];
117     }
118 
119 
120 
121     function transfer(address to, uint tokens) public returns (bool success) {
122         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
123         balances[to] = safeAdd(balances[to], tokens);
124         Transfer(msg.sender, to, tokens);
125         return true;
126     }
127 
128 
129 
130     function approve(address spender, uint tokens) public returns (bool success) {
131         allowed[msg.sender][spender] = tokens;
132         Approval(msg.sender, spender, tokens);
133         return true;
134     }
135 
136 
137 
138     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
139         balances[from] = safeSub(balances[from], tokens);
140         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
141         balances[to] = safeAdd(balances[to], tokens);
142         Transfer(from, to, tokens);
143         return true;
144     }
145 
146 
147 
148     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
149         return allowed[tokenOwner][spender];
150     }
151 
152 
153 
154     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
155         allowed[msg.sender][spender] = tokens;
156         Approval(msg.sender, spender, tokens);
157         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
158         return true;
159     }
160 
161 
162 
163     function () public payable {
164         revert();
165     }
166 
167 
168 
169     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
170         return ERC20Interface(tokenAddress).transfer(owner, tokens);
171     }
172 }