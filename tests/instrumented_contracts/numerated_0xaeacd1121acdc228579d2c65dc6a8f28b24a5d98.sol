1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol      : YUC
6 // Name        : Yet Another Useless Coin
7 // Total supply: 10^7
8 // Decimals    : 10
9 //
10 // Enjoy.
11 //
12 // (c) With reference to Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
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
44     function totalSupply() public constant returns (uint256);
45     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
47     function transfer(address to, uint256 tokens) public returns (bool success);
48     function approve(address spender, uint256 tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint256 tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     constructor() public {
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
88         emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token, with the addition of symbol, name and decimals and assisted
97 // token transfers
98 // ----------------------------------------------------------------------------
99 contract YetAnotherUselessToken is ERC20Interface, Owned, SafeMath {
100     string public symbol;
101     string public  name;
102     uint256 public decimals;
103     uint256 public _totalSupply;
104     bool public purchasingAllowed;
105     uint256 public totalContribution;
106     uint256 public totalIssued;
107     uint256 public totalBonusTokensIssued;
108 
109     mapping(address => uint256) balances;
110     mapping(address => mapping(address => uint256)) allowed;
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor() public {
117         symbol = "YUC";
118         name = "YetAnotherUselessToken";
119         decimals = 10;
120         _totalSupply = 10000000;
121         balances[owner] = _totalSupply * (10 ** decimals);
122         purchasingAllowed = false;
123         totalContribution = 0;
124         totalIssued = 0;
125         totalBonusTokensIssued = 0;
126 
127         emit Transfer(address(0), owner, _totalSupply * (10 ** decimals));
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Total supply
133     // ------------------------------------------------------------------------
134     function totalSupply() public constant returns (uint256) {
135         return _totalSupply * (10 ** decimals)  - balances[address(0)];
136     }
137 
138     // ------------------------------------------------------------------------
139     // Get the token balance for account tokenOwner
140     // ------------------------------------------------------------------------
141     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
142         return balances[tokenOwner];
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer the balance from token owner's account to to account
148     // - Owner's account must have sufficient balance to transfer
149     // - 0 value transfers are allowed
150     // ------------------------------------------------------------------------
151     function transfer(address to, uint256 tokens) public returns (bool success) {
152         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
153         balances[to] = safeAdd(balances[to], tokens);
154         emit Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for spender to transferFrom(...) tokens
161     // from the token owner's account
162     //
163     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
164     // recommends that there are no checks for the approval double-spend attack
165     // as this should be implemented in user interfaces
166     // ------------------------------------------------------------------------
167     function approve(address spender, uint256 tokens) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Transfer tokens from the from account to the to account
176     //
177     // The calling account must already have sufficient tokens approve(...)-d
178     // for spending from the from account and
179     // - From account must have sufficient balance to transfer
180     // - Spender must have sufficient allowance to transfer
181     // - 0 value transfers are allowed
182     // ------------------------------------------------------------------------
183     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
184         balances[from] = safeSub(balances[from], tokens);
185         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
186         balances[to] = safeAdd(balances[to], tokens);
187         emit Transfer(from, to, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Returns the amount of tokens approved by the owner that can be
194     // transferred to the spender's account
195     // ------------------------------------------------------------------------
196     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
197         return allowed[tokenOwner][spender];
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for spender to transferFrom(...) tokens
203     // from the token owner's account. The spender contract function
204     // receiveApproval(...) is then executed
205     // ------------------------------------------------------------------------
206     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
207         allowed[msg.sender][spender] = tokens;
208         emit Approval(msg.sender, spender, tokens);
209         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
210         return true;
211     }
212 
213     // ------------------------------------------------------------------------
214     // Owner can transfer out any accidentally sent ERC20 tokens
215     // ------------------------------------------------------------------------
216     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
217         return ERC20Interface(tokenAddress).transfer(owner, tokens);
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // purchasingAllowed
223     // ------------------------------------------------------------------------
224     function purchasingAllowed() public constant returns (bool) {
225         return purchasingAllowed;
226     }
227 
228     function enablePurchasing() public onlyOwner {
229         purchasingAllowed = true;
230     }
231 
232     function disablePurchasing() public onlyOwner {
233         purchasingAllowed = false;
234     }
235 
236     // ------------------------------------------------------------------------
237     // Interface to the web app.
238     // Its Keccak-256 hash value is 0xc59d4847
239     // ------------------------------------------------------------------------
240     function getStats() constant public returns (uint256, uint256, uint256, bool) {
241         return (totalContribution, totalIssued, totalBonusTokensIssued, purchasingAllowed);
242     }
243 
244     // -----------------------------------------------------------------------
245     // Accept ETH
246     // ------------------------------------------------------------------------
247     function() public payable {
248         if (!purchasingAllowed) { revert(); }
249 
250         if (msg.value == 0) { return; }
251 
252         owner.transfer(msg.value);
253 
254         totalContribution += msg.value;
255 
256         // issue the token
257         uint256 tokensIssued = (msg.value * 100);
258         if (msg.value >= 10 finney) {
259             bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
260             if (bonusHash[0] == 0) {
261                 uint256 bonusMultiplier =
262                     ((bonusHash[1] & 0x01 != 0) ? 1 : 0) + ((bonusHash[1] & 0x02 != 0) ? 1 : 0) +
263                     ((bonusHash[1] & 0x04 != 0) ? 1 : 0) + ((bonusHash[1] & 0x08 != 0) ? 1 : 0) +
264                     ((bonusHash[1] & 0x10 != 0) ? 1 : 0) + ((bonusHash[1] & 0x20 != 0) ? 1 : 0) +
265                     ((bonusHash[1] & 0x40 != 0) ? 1 : 0) + ((bonusHash[1] & 0x80 != 0) ? 1 : 0);
266 
267                 uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
268                 tokensIssued += bonusTokensIssued;
269                 totalBonusTokensIssued += bonusTokensIssued;
270             }
271         }
272         totalIssued += tokensIssued;
273         balances[msg.sender] += tokensIssued * (10 ** decimals);
274         balances[owner] -= tokensIssued * (10 ** decimals);
275 
276         emit Transfer(owner, msg.sender, tokensIssued * (10 ** decimals));
277     }
278 }