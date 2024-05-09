1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // 'CMAP' token
5 //
6 // Features:
7 // Deployed to : 0x2d23135F74d5cbbD3105c5dE6E782e73A62f2F18
8 // Symbol      : CMAP
9 // Name        : CMAP Token
10 // Total supply: 136000000 (initially given to the contract author).
11 // Decimals    : 18
12 //
13 // Enjoy.
14 //
15 // (c) CriptoMap / CMAP / The MIT Licence.
16 // ----------------------------------------------------------------------------
17 
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
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
42 // ----------------------------------------------------------------------------
43 // ERC Token Standard #20 Interface
44 // ----------------------------------------------------------------------------
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
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token, with the addition of symbol, name and decimals and assisted
98 // token transfers
99 // ----------------------------------------------------------------------------
100 contract CMAPToken is ERC20Interface, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint public _totalSupply;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     function CMAPToken() public {
114         symbol = "CMAP";
115         name = "CMAP Token";
116         decimals = 18;
117         _totalSupply = 136000000000000000000000000;
118         balances[0x2d23135F74d5cbbD3105c5dE6E782e73A62f2F18] = _totalSupply;
119         Transfer(address(0), 0x2d23135F74d5cbbD3105c5dE6E782e73A62f2F18, _totalSupply);
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply  - balances[address(0)];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account tokenOwner
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to to account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens) public returns (bool success) {
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Token owner can approve for spender to transferFrom(...) tokens
154     // from the token owner's account
155     // recommends that there are no checks for the approval double-spend attack
156     // as this should be implemented in user interfaces
157     // ------------------------------------------------------------------------
158     function approve(address spender, uint tokens) public returns (bool success) {
159         allowed[msg.sender][spender] = tokens;
160         Approval(msg.sender, spender, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer tokens from the from account to the to account
167     // The calling account must already have sufficient tokens approve(...)-d
168     // for spending from the from account and
169     // - From account must have sufficient balance to transfer
170     // - Spender must have sufficient allowance to transfer
171     // - 0 value transfers are allowed
172     // ------------------------------------------------------------------------
173     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
174         balances[from] = safeSub(balances[from], tokens);
175         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
176         balances[to] = safeAdd(balances[to], tokens);
177         Transfer(from, to, tokens);
178         return true;
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Returns the amount of tokens approved by the owner that can be
184     // transferred to the spender's account
185     // ------------------------------------------------------------------------
186     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
187         return allowed[tokenOwner][spender];
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Token owner can approve for spender to transferFrom(...) tokens
193     // from the token owner's account. The spender contract function
194     // receiveApproval(...) is then executed
195     // ------------------------------------------------------------------------
196     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
197         allowed[msg.sender][spender] = tokens;
198         Approval(msg.sender, spender, tokens);
199         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
200         return true;
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Don't accept ETH
206     // ------------------------------------------------------------------------
207     function () public payable {
208         revert();
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Owner can transfer out any accidentally sent ERC20 tokens
214     // ------------------------------------------------------------------------
215     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
216         return ERC20Interface(tokenAddress).transfer(owner, tokens);
217     }
218 }