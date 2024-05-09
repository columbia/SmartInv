1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // 'DiipCoin' token contract
5 //
6 // Deployed to : 0xeB086DF649c34bFb1E074B272fB8139095648eFF
7 // Symbol      : DIIP
8 // Name        : diipCoin
9 // Decimals    : 0
10 //
11 // 
12 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
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
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 // TokenRecipient interface for paying other contracts in this token
66 contract TokenRecipient {
67     function tokenFallback(address sender, uint value, uint[] extraData) public returns (bool);
68 }
69 
70 
71 // ----------------------------------------------------------------------------
72 // Owned contract
73 // ----------------------------------------------------------------------------
74 contract Owned {
75     address public owner;
76     address public newOwner;
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 
80     function Owned() public {
81         owner = msg.sender;
82     }
83 
84     modifier onlyOwner {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     function transferOwnership(address _newOwner) public onlyOwner {
90         newOwner = _newOwner;
91     }
92     function acceptOwnership() public {
93         require(msg.sender == newOwner);
94         emit OwnershipTransferred(owner, newOwner);
95         owner = newOwner;
96         newOwner = address(0);
97     }
98 }
99 
100 
101 // ----------------------------------------------------------------------------
102 // ERC20 Token, with the addition of symbol, name and decimals and assisted
103 // token transfers
104 // ----------------------------------------------------------------------------
105 contract DiipCoin is ERC20Interface, Owned, SafeMath {
106     string public symbol;
107     string public  name;
108     uint8 public decimals;
109     uint public _totalSupply;
110     bool public mintingFinished;
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114 
115     event Mint(address indexed to, uint tokens);
116     event MintingFinished();  
117 
118     // Minting can only happen when minting is not finished
119     modifier canMint() {
120       require(!mintingFinished);
121       _;
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Constructor
127     // ------------------------------------------------------------------------
128     function DiipCoin() public {
129         symbol = "DIIP";
130         name = "DiipCoin";
131         decimals = 0;
132         _totalSupply = 100000000;
133         balances[0xeB086DF649c34bFb1E074B272fB8139095648eFF] = _totalSupply;
134         emit Transfer(address(0), 0xeB086DF649c34bFb1E074B272fB8139095648eFF, _totalSupply);
135         mintingFinished = false;
136     }
137 
138     // ------------------------------------------------------------------------
139     // Don't accept ETH
140     // ------------------------------------------------------------------------
141     function () public payable {
142         revert();
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Getters
148     // ------------------------------------------------------------------------
149     function totalSupply() public view returns (uint) {
150         return _totalSupply  - balances[address(0)];
151     }
152 
153     function balanceOf(address tokenOwner) public view returns (uint balance) {
154         return balances[tokenOwner];
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Transfer the balance from token owner's account to to account
160     // - Owner's account must have sufficient balance to transfer
161     // - 0 value transfers are allowed
162     // ------------------------------------------------------------------------
163     function transfer(address to, uint tokens) public returns (bool success) {
164         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
165         balances[to] = safeAdd(balances[to], tokens);
166         emit Transfer(msg.sender, to, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Token owner can approve for spender to transferFrom(...) tokens
173     // from the token owner's account
174     //
175     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
176     // recommends that there are no checks for the approval double-spend attack
177     // as this should be implemented in user interfaces 
178     // ------------------------------------------------------------------------
179     function approve(address spender, uint tokens) public returns (bool success) {
180         allowed[msg.sender][spender] = tokens;
181         emit Approval(msg.sender, spender, tokens);
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Transfer tokens from the from account to the to account
188     // 
189     // The calling account must already have sufficient tokens approve(...)-d
190     // for spending from the from account and
191     // - From account must have sufficient balance to transfer
192     // - Spender must have sufficient allowance to transfer
193     // - 0 value transfers are allowed
194     // ------------------------------------------------------------------------
195     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
196         balances[from] = safeSub(balances[from], tokens);
197         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
198         balances[to] = safeAdd(balances[to], tokens);
199         emit Transfer(from, to, tokens);
200         return true;
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Returns the amount of tokens approved by the owner that can be
206     // transferred to the spender's account
207     // ------------------------------------------------------------------------
208     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
209         return allowed[tokenOwner][spender];
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Token owner can approve for spender to transferFrom(...) tokens
215     // from the token owner's account. The spender contract function
216     // receiveApproval(...) is then executed
217     // ------------------------------------------------------------------------
218     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
219         allowed[msg.sender][spender] = tokens;
220         emit Approval(msg.sender, spender, tokens);
221         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
222         return true;
223     }
224 
225 
226     //========================================================================
227     // Transfer and call function for calling functions in other contracts
228     // while sending this token
229     //========================================================================
230     function transferAndCall(address _recipient, uint _value, uint[] _extraData) public {
231         transfer(_recipient, _value);
232         require(TokenRecipient(_recipient).tokenFallback(msg.sender, _value, _extraData));
233     }
234 
235     // ------------------------------------------------------------------------
236     // Owner can mint new tokens
237     // ------------------------------------------------------------------------
238     function mint(address to, uint tokens) public onlyOwner canMint returns (bool) {        
239         _totalSupply = safeAdd(_totalSupply, tokens);
240         balances[to] = safeAdd(balances[to], tokens);
241         emit Mint(to, tokens);
242         emit Transfer(address(0), to, tokens);
243         return true;
244     }
245 
246     // ------------------------------------------------------------------------
247     // Owner can remove the ability to mint new coins
248     // ------------------------------------------------------------------------
249     function finishMinting() onlyOwner canMint public returns (bool) {
250       mintingFinished = true;
251       emit MintingFinished();
252       return true;
253     }
254 
255 
256     // ------------------------------------------------------------------------
257     // Owner can transfer out any accidentally sent ERC20 tokens
258     // ------------------------------------------------------------------------
259     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
260         return ERC20Interface(tokenAddress).transfer(owner, tokens);
261     }
262 }