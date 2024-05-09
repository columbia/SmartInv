1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Seth'  token contract
5 //
6 // Symbol      : seth
7 // Name        : seth Token
8 // Total supply: 1,000,000,000,000
9 // Decimals    : 12
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // Borrowed from MiniMeToken
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
67 contract Owned {
68     address public owner;
69     address public newOwner;
70 
71     event OwnershipTransferred(address indexed _from, address indexed _to);
72 
73     function Owned() public {
74         owner = msg.sender;
75     }
76 
77     modifier onlyOwner {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     function transferOwnership(address _newOwner) public onlyOwner {
83         newOwner = _newOwner;
84     }
85     function acceptOwnership() public {
86         require(msg.sender == newOwner);
87         OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89         newOwner = address(0);
90     }
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and assisted
96 // token transfers
97 // ----------------------------------------------------------------------------
98 contract sethToken is ERC20Interface, Owned, SafeMath {
99     string public symbol = "seth";
100     string public TokenOwner = "Seth Simbulan";
101     string public  name = "sethCoin";
102     uint8 public decimals = 12;
103     uint public _totalSupply = 1000000000000 * 10 ** uint256(decimals);
104 
105 	uint256 public price = 10000;
106 	bool public started = true;
107 	address public ceo = 0x46c6CDc24606eF220c38c12AF8D129026072F829;
108 
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111 
112 	// amount of raised money in wei
113 	uint256 public weiRaised;
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     function sethToken() public {
119         balances[ceo] = _totalSupply;
120         Transfer(address(0), ceo, _totalSupply);
121     }
122 
123 	function startSale(){
124 		if (msg.sender != owner) throw;
125 		started = true;
126 	}
127 
128 	function stopSale(){
129 		if(msg.sender != owner) throw;
130 		started = false;
131 	}
132 
133 	function setPrice(uint256 _price){
134 		if(msg.sender != owner) throw;
135 		price = _price;
136 	}
137 
138 	function changeWallet(address _wallet){
139 		if(msg.sender != owner) throw;
140 		ceo = _wallet;
141 	}
142 
143     // ------------------------------------------------------------------------
144     // Total supply
145     // ------------------------------------------------------------------------
146     function totalSupply() public constant returns (uint) {
147         return _totalSupply  - balances[address(0)];
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Get the token balance for account `tokenOwner`
153     // ------------------------------------------------------------------------
154     function balanceOf(address tokenOwner) public constant returns (uint balance) {
155         return balances[tokenOwner];
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer the balance from token owner's account to `to` account
161     // - Owner's account must have sufficient balance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transfer(address to, uint tokens) public returns (bool success) {
165         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
166         balances[to] = safeAdd(balances[to], tokens);
167         Transfer(msg.sender, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Token owner can approve for `spender` to transferFrom(...) `tokens`
174     // from the token owner's account
175     //
176     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
177     // recommends that there are no checks for the approval double-spend attack
178     // as this should be implemented in user interfaces
179     // ------------------------------------------------------------------------
180     function approve(address spender, uint tokens) public returns (bool success) {
181         allowed[msg.sender][spender] = tokens;
182         Approval(msg.sender, spender, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Transfer `tokens` from the `from` account to the `to` account
189     //
190     // The calling account must already have sufficient tokens approve(...)-d
191     // for spending from the `from` account and
192     // - From account must have sufficient balance to transfer
193     // - Spender must have sufficient allowance to transfer
194     // - 0 value transfers are allowed
195     // ------------------------------------------------------------------------
196     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
197         balances[from] = safeSub(balances[from], tokens);
198         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
199         balances[to] = safeAdd(balances[to], tokens);
200         Transfer(from, to, tokens);
201         return true;
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Returns the amount of tokens approved by the owner that can be
207     // transferred to the spender's account
208     // ------------------------------------------------------------------------
209     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
210         return allowed[tokenOwner][spender];
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Token owner can approve for `spender` to transferFrom(...) `tokens`
216     // from the token owner's account. The `spender` contract function
217     // `receiveApproval(...)` is then executed
218     // ------------------------------------------------------------------------
219     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
220         allowed[msg.sender][spender] = tokens;
221         Approval(msg.sender, spender, tokens);
222         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
223         return true;
224     }
225 
226     function () public payable {
227         require(validPurchase());
228 
229 		uint256 weiAmount = msg.value;
230 		uint256 tokens;
231 
232 		tokens = weiAmount * price / (10 ** 18) * (10 ** 12);
233 
234 		weiRaised = safeAdd(weiRaised, weiAmount);
235 
236         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
237         balances[ceo] = safeSub(balances[ceo], tokens);
238 
239         Transfer(ceo, msg.sender, tokens);
240         ceo.transfer(msg.value);
241     }
242 
243     // ------------------------------------------------------------------------
244     // Owner can transfer out any accidentally sent ERC20 tokens
245     // ------------------------------------------------------------------------
246     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
247         return ERC20Interface(tokenAddress).transfer(owner, tokens);
248     }
249 
250 	function validPurchase() internal constant returns (bool) {
251 		bool withinPeriod = started;
252 		bool nonZeroPurchase = msg.value != 0;
253 		return withinPeriod && nonZeroPurchase;
254 	}
255 }