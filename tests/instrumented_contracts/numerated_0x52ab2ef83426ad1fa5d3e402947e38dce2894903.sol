1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // --- 0.4.21+commit.dfe3193c
5 // --- 'VEGAN' 'Vegan' token contract
6 // --- Symbol      : VEGAN
7 // --- Name        : Vegan
8 // --- Total supply: Generated from contributions
9 // --- Decimals    : 18
10 // --- @author EJS32 
11 // --- @title for the 01100101 01100001 01110010 01110100 01101000
12 // --- Developed by the Tessr Foundation - tessr.io 2018. 
13 // --- (c) VeganShift.org / The MIT License.
14 // ----------------------------------------------------------------------------
15 
16 // ----------------------------------------------------------------------------
17 // --- Safe Math
18 // ----------------------------------------------------------------------------
19 
20 contract SafeMath {
21     function safeAdd(uint a, uint b) public pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function safeSub(uint a, uint b) public pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function safeMul(uint a, uint b) public pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function safeDiv(uint a, uint b) public pure returns (uint c) {
34         c = a / b;
35         require(b > 0);
36     }
37 }
38 
39 // ----------------------------------------------------------------------------
40 // --- ERC Token Standard #20 Interface
41 // --- https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 // ----------------------------------------------------------------------------
43 
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 // ----------------------------------------------------------------------------
57 // --- Contract function to receive approval and execute function in one call
58 // ----------------------------------------------------------------------------
59 
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 // ----------------------------------------------------------------------------
65 // --- Owned contract
66 // ----------------------------------------------------------------------------
67 
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88          emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 // ----------------------------------------------------------------------------
95 // --- ERC20 Token, with the addition of symbol, name and decimals
96 // --- Receives ETH and generates tokens
97 // ----------------------------------------------------------------------------
98 
99     contract Vegan is ERC20Interface, Owned, SafeMath {
100         string public symbol;
101         string public  name;
102         uint8 public decimals;
103         uint public _totalSupply;
104         uint public startDate;
105         mapping(address => uint) balances;
106         mapping(address => mapping(address => uint)) allowed;
107 
108 // ------------------------------------------------------------------------
109 // --- Constructor
110 // ------------------------------------------------------------------------
111 
112     function Vegan() public {
113         symbol = "VEGAN";
114         name = "Vegan";
115         decimals = 18;
116         _totalSupply = 300000000000000000000000000;
117         startDate = now;
118         balances[owner] = _totalSupply;
119         emit Transfer(address(0), owner, _totalSupply);
120     }
121 
122 // ------------------------------------------------------------------------
123 // --- Total supply
124 // ------------------------------------------------------------------------
125 
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply  - balances[address(0)];
128     }
129 
130 // ------------------------------------------------------------------------
131 // --- Get the token balance for account `tokenOwner`
132 // ------------------------------------------------------------------------
133 
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 // ------------------------------------------------------------------------
139 // --- Transfer the balance from token owner's account to `to` account
140 // --- Owner's account must have sufficient balance to transfer
141 // --- 0 value transfers are allowed
142 // ------------------------------------------------------------------------
143 
144     function transfer(address to, uint tokens) public returns (bool success) {
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         emit Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151 // ------------------------------------------------------------------------
152 // --- Token owner can approve for `spender` to transferFrom
153 // ------------------------------------------------------------------------
154 
155     function approve(address spender, uint tokens) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         emit Approval(msg.sender, spender, tokens);
158         return true;
159     }
160 
161 // ------------------------------------------------------------------------
162 // --- Transfer `tokens` from the `from` account to the `to` account
163 // ------------------------------------------------------------------------
164 
165     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
166         balances[from] = safeSub(balances[from], tokens);
167         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
168         balances[to] = safeAdd(balances[to], tokens);
169         emit Transfer(from, to, tokens);
170         return true;
171     }
172 
173 // ------------------------------------------------------------------------
174 // --- Returns the amount of tokens approved by the owner
175 // ------------------------------------------------------------------------
176 
177     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
178         return allowed[tokenOwner][spender];
179     }
180 
181 // ------------------------------------------------------------------------
182 // --- Token owner can approve for `spender` to transferFrom(...) `tokens`
183 // --- from the token owner's account. The `spender` contract function
184 // --- `receiveApproval(...)` is then executed
185 // ------------------------------------------------------------------------
186 
187     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         emit Approval(msg.sender, spender, tokens);
190         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
191         return true;
192     }
193 
194 // ------------------------------------------------------------------------
195 // --- 700 tokens per 1 ETH
196 // ------------------------------------------------------------------------
197 
198     function () public payable {
199         uint tokens;
200         tokens = msg.value * 700;
201         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
202         _totalSupply = safeAdd(_totalSupply, tokens);
203         emit Transfer(address(0), msg.sender, tokens);
204         owner.transfer(msg.value);
205     }
206 
207 // ------------------------------------------------------------------------
208 // --- Owner can transfer out any accidentally sent ERC20 tokens
209 // ------------------------------------------------------------------------
210 
211     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
212         return ERC20Interface(tokenAddress).transfer(owner, tokens);
213     }
214 }