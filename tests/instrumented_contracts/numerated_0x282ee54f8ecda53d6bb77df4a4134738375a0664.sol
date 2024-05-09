1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // XT token contract
5 //
6 // Symbol      : XT
7 // Name        : X Token
8 // Total supply: 1000000000
9 // Decimals    : 18
10 //
11 // Inspired by BokkyPooBah.
12 //
13 // This is the official X Token ERC20 contract. XT is WCX's native crypto token.
14 // wcex.com (c) WCX 2018.
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
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // ----------------------------------------------------------------------------
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
54     event Burn(address indexed burner, uint tokens);
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
100 contract XToken is ERC20Interface, Owned, SafeMath {
101     string public symbol;
102     string public name;
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
113     function XToken() public {
114         symbol = "XT";
115         name = "X Token";
116         decimals = 18;
117         _totalSupply = 1000000000 * 10**uint(decimals);
118         balances[owner] = _totalSupply;
119         Transfer(address(0), owner, _totalSupply);
120     }
121 
122     // ------------------------------------------------------------------------
123     // Total supply
124     // ------------------------------------------------------------------------
125     function totalSupply() public constant returns (uint) {
126         return _totalSupply  - balances[address(0)];
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Get the token balance for account tokenOwner
132     // ------------------------------------------------------------------------
133     function balanceOf(address tokenOwner) public constant returns (uint balance) {
134         return balances[tokenOwner];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to to account
140     // - Owner's account must have sufficient balance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transfer(address to, uint tokens) public returns (bool success) {
144         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
145         balances[to] = safeAdd(balances[to], tokens);
146         Transfer(msg.sender, to, tokens);
147         return true;
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Token owner can approve for spender to transferFrom(...) tokens
153     // from the token owner's account
154     //
155     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
156     // recommends that there are no checks for the approval double-spend attack
157     // as this should be implemented in user interfaces 
158     // ------------------------------------------------------------------------
159     function approve(address spender, uint tokens) public returns (bool success) {
160         allowed[msg.sender][spender] = tokens;
161         Approval(msg.sender, spender, tokens);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Transfer tokens from the from account to the to account
168     // 
169     // The calling account must already have sufficient tokens approve(...)-d
170     // for spending from the from account and
171     // - From account must have sufficient balance to transfer
172     // - Spender must have sufficient allowance to transfer
173     // - 0 value transfers are allowed
174     // ------------------------------------------------------------------------
175     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
176         balances[from] = safeSub(balances[from], tokens);
177         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
178         balances[to] = safeAdd(balances[to], tokens);
179         Transfer(from, to, tokens);
180         return true;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Returns the amount of tokens approved by the owner that can be
186     // transferred to the spender's account
187     // ------------------------------------------------------------------------
188     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
189         return allowed[tokenOwner][spender];
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Token owner can approve for spender to transferFrom(...) tokens
195     // from the token owner's account. The spender contract function
196     // receiveApproval(...) is then executed
197     // ------------------------------------------------------------------------
198     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
199         allowed[msg.sender][spender] = tokens;
200         Approval(msg.sender, spender, tokens);
201         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
202         return true;
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Don't accept ETH
208     // ------------------------------------------------------------------------
209     function () public payable {
210         revert();
211     }
212 
213     // ------------------------------------------------------------------------
214     // Burn function
215     // Owner can burn tokens = send tokens to address(0) 
216     // and decrease total supply
217     // ------------------------------------------------------------------------
218     function burn(uint tokens) public onlyOwner returns (bool success) {
219         require(balances[msg.sender] >= tokens);
220         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
221         _totalSupply = safeSub(_totalSupply, tokens);
222         Burn(msg.sender, tokens);
223         Transfer(msg.sender, address(0), tokens);
224         return true;
225     }
226 
227     // ------------------------------------------------------------------------
228     // Owner can transfer out any accidentally sent ERC20 tokens
229     // ------------------------------------------------------------------------
230     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
231         return ERC20Interface(tokenAddress).transfer(owner, tokens);
232     }
233 }