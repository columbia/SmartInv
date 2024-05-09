1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'A1 Coin' Token Contract
5 //
6 // Deployed To : 0xbac6874fff7ac02c06907d0e340af9f1832e7908
7 // Symbol      : A1
8 // Name        : A1 Coin
9 // Total Supply: 222,000,000 A1
10 // Decimals    : 18
11 //
12 // (c) By 'A1 Coin' With 'A1' Symbol 2019.
13 //
14 // ERC20 Smart Contract Developed By: https://SoftCode.space Blockchain Developer Team.
15 //
16 // https://SoftCode.space is just only a token creation and development service provider
17 // and there is no relationship of any type of financial and offer's provided by 'A1 Coin (A1)'.
18 // If any type of financial and offer related mismanagement or "Financial or Asset related SCAM"
19 // happen/cause with any user's of 'A1 Coin (A1)' by 'A1 Coin (A1)' management; in this case
20 // https://SoftCode.space Blockchain Developer Team will not be liable for that because
21 // https://SoftCode.space Blockchain Developer Team is not part of 'A1 Coin (A1)' management.
22 // ----------------------------------------------------------------------------
23 
24 
25 contract SafeMath {
26     function safeAdd(uint a, uint b) public pure returns (uint c) {
27         c = a + b;
28         require(c >= a);
29     }
30     function safeSub(uint a, uint b) public pure returns (uint c) {
31         require(b <= a);
32         c = a - b;
33     }
34     function safeMul(uint a, uint b) public pure returns (uint c) {
35         c = a * b;
36         require(a == 0 || c / a == b);
37     }
38     function safeDiv(uint a, uint b) public pure returns (uint c) {
39         require(b > 0);
40         c = a / b;
41     }
42 }
43 
44 
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
60 }
61 
62 
63 contract Owned {
64     address public owner;
65     address public newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69     function Owned() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 
90 contract A1Coin is ERC20Interface, Owned, SafeMath {
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint public _totalSupply;
95 
96     mapping(address => uint) balances;
97     mapping(address => mapping(address => uint)) allowed;
98 
99 
100     function A1Coin() public {
101         symbol = "A1";
102         name = "A1 Coin";
103         decimals = 18;
104         _totalSupply = 222000000000000000000000000;
105         balances[0x97215c4A9f496B71Aea11d04E26edE3038aB1AF6] = _totalSupply;
106         Transfer(address(0), 0x97215c4A9f496B71Aea11d04E26edE3038aB1AF6, _totalSupply);
107     }
108 
109 
110     function totalSupply() public constant returns (uint) {
111         return _totalSupply  - balances[address(0)];
112     }
113 
114 
115     function balanceOf(address tokenOwner) public constant returns (uint balance) {
116         return balances[tokenOwner];
117     }
118 
119 
120     function transfer(address to, uint tokens) public returns (bool success) {
121         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
122         balances[to] = safeAdd(balances[to], tokens);
123         Transfer(msg.sender, to, tokens);
124         return true;
125     }
126 
127 
128     function approve(address spender, uint tokens) public returns (bool success) {
129         allowed[msg.sender][spender] = tokens;
130         Approval(msg.sender, spender, tokens);
131         return true;
132     }
133 
134 
135     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
136         balances[from] = safeSub(balances[from], tokens);
137         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
138         balances[to] = safeAdd(balances[to], tokens);
139         Transfer(from, to, tokens);
140         return true;
141     }
142 
143 
144     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
145         return allowed[tokenOwner][spender];
146     }
147 
148 
149     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
150         allowed[msg.sender][spender] = tokens;
151         Approval(msg.sender, spender, tokens);
152         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
153         return true;
154     }
155 
156 
157     function () public payable {
158         revert();
159     }
160 
161 
162     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
163         return ERC20Interface(tokenAddress).transfer(owner, tokens);
164     }
165 }