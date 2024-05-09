1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7   uint256 constant private MAX_UINT256 =
8   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
9 
10   function safeAdd (uint256 x, uint256 y) constant internal returns (uint256 z) {
11     assert (x <= MAX_UINT256 - y);
12     return x + y;
13   }
14 
15   function safeSub (uint256 x, uint256 y) constant internal returns (uint256 z) {
16     assert (x >= y);
17     return x - y;
18   }
19 
20   function safeMul (uint256 x, uint256 y)  constant internal  returns (uint256 z) {
21     if (y == 0) return 0; // Prevent division by zero at the next line
22     assert (x <= MAX_UINT256 / y);
23     return x * y;
24   }
25   
26   
27    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a / b;
29     return c;
30   }
31   
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
38 // ----------------------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Contract function to receive approval and execute function in one call
54 //
55 // Borrowed from MiniMeToken
56 // ----------------------------------------------------------------------------
57 contract ApproveAndCallFallBack {
58     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Owned contract
64 // ----------------------------------------------------------------------------
65 contract Owned {
66     address public owner;
67     address public newOwner;
68 
69     event OwnershipTransferred(address indexed _from, address indexed _to);
70 
71     function Owned() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newOwner = _newOwner;
82     }
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals and assisted
94 // token transfers
95 // ----------------------------------------------------------------------------
96 contract RebateCoin is ERC20Interface, Owned, SafeMath {
97     string public symbol;
98     string public  name;
99     uint8 public decimals = 18;
100     uint256 private _supply;
101     uint256 private _totalSupply;
102 
103     uint public tokenPrice = 100 * (10**13); // wei , 0.001 eth , 6 usd
104  
105 	uint private SaleStage1_start = 1527811200;
106 	uint256 private SaleStage1_supply = 24 * (10**24);
107 	uint private SaleStage1_tokenPrice = 84 * (10**13); // 0.5 usd
108 
109 	uint private SaleStage2_start = 1530403200;
110 	uint256 private SaleStage2_supply = 10 * (10**24);
111 	uint private SaleStage2_tokenPrice = 108 * (10**13); // 0.65 usd
112 
113 	uint private SaleStage3_start = 1533081600;
114 	uint256 private SaleStage3_supply = 50 * (10**24);
115 	uint private SaleStage3_tokenPrice = 134 * (10**13); // 0.8 usd
116 	
117     uint public startDate = 1527811200;
118     uint public endDate = 1535760000;
119 
120 	uint256 public bounty = 10 * (10**23);
121 
122 	uint256 public hardcap = 22800 ether;
123 	uint256 public softcap = 62250 ether;
124 
125     mapping(address => uint) balances;
126     mapping(address => mapping(address => uint)) allowed;
127 
128 
129     // ------------------------------------------------------------------------
130     // Constructor
131     // ------------------------------------------------------------------------
132     function RebateCoin() public {
133         symbol = "RBC";
134         name = "Rebate Coin";
135 	_totalSupply = safeAdd(_totalSupply, bounty);
136 	//approve(owner, bounty);
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Total supply
142     // ------------------------------------------------------------------------
143     function totalSupply() public constant returns (uint) {
144         return _totalSupply  - balances[address(0)];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Get the token balance for account `tokenOwner`
150     // ------------------------------------------------------------------------
151     function balanceOf(address tokenOwner) public constant returns (uint balance) {
152         return balances[tokenOwner];
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Transfer the balance from token owner's account to `to` account
158     // - Owner's account must have sufficient balance to transfer
159     // - 0 value transfers are allowed
160     // ------------------------------------------------------------------------
161     function transfer(address to, uint tokens) public returns (bool success) {
162         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
163         balances[to] = safeAdd(balances[to], tokens);
164         Transfer(msg.sender, to, tokens);
165         return true;
166     }
167 
168     function reward_list(address[] memory to, uint[] memory tokens) public returns (bool success) {
169 	require(msg.sender == owner);
170         require(to.length == tokens.length);
171 	    for (uint i = 0; i < to.length; ++i) {
172 		reward(to[i],tokens[i]);
173 	    }
174         return true;
175     }
176     
177     function reward(address to, uint tokens) public returns (bool success) {
178         require(msg.sender == owner);
179 	require( tokens <= bounty);		
180 	bounty = safeSub(bounty, tokens);
181 	balances[to] = safeAdd(balances[to], tokens);
182 	
183         Transfer(msg.sender, to, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Token owner can approve for `spender` to transferFrom(...) `tokens`
190     // from the token owner's account
191     //
192     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
193     // recommends that there are no checks for the approval double-spend attack
194     // as this should be implemented in user interfaces
195     // ------------------------------------------------------------------------
196     function approve(address spender, uint tokens) public returns (bool success) {
197         allowed[msg.sender][spender] = tokens;
198         Approval(msg.sender, spender, tokens);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Transfer `tokens` from the `from` account to the `to` account
205     //
206     // The calling account must already have sufficient tokens approve(...)-d
207     // for spending from the `from` account and
208     // - From account must have sufficient balance to transfer
209     // - Spender must have sufficient allowance to transfer
210     // - 0 value transfers are not allowed
211     // ------------------------------------------------------------------------
212     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
213         balances[from] = safeSub(balances[from], tokens);
214         if (tokens > 0 && from != to) {
215             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
216             balances[to] = safeAdd(balances[to], tokens);
217             Transfer(from, to, tokens);
218 	}
219         return true;
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Returns the amount of tokens approved by the owner that can be
225     // transferred to the spender's account
226     // ------------------------------------------------------------------------
227     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
228         return allowed[tokenOwner][spender];
229     }
230 
231     /// @dev extendDeadline(): allows the issuer to add more time to the
232     /// presale, allowing it to continue accepting fulfillments
233     /// @param _newDeadline the new deadline in timestamp format
234     function extendDeadline(uint _newDeadline) public returns (bool success){
235         require(msg.sender == owner);
236         require(_newDeadline > 0);
237         endDate = _newDeadline;
238         return true;
239     }
240 
241     // ------------------------------------------------------------------------
242     // Token owner can approve for `spender` to transferFrom(...) `tokens`
243     // from the token owner's account. The `spender` contract function
244     // `receiveApproval(...)` is then executed
245     // ------------------------------------------------------------------------
246     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
247         allowed[msg.sender][spender] = tokens;
248         Approval(msg.sender, spender, tokens);
249         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
250         return true;
251     }
252 
253     // ------------------------------------------------------------------------
254     // RBC Tokens per 1 ETH
255     // ------------------------------------------------------------------------
256     function () public payable {
257         require(now >= startDate && now <= endDate);
258         uint tokens;
259         if (now >= SaleStage3_start) {
260             tokens = safeDiv(msg.value * (10**18),SaleStage3_tokenPrice);
261 	    _supply = safeAdd(SaleStage3_supply,safeAdd(SaleStage2_supply,SaleStage1_supply));
262         } else if(now >= SaleStage2_start) {
263             tokens = safeDiv(msg.value * (10**18),SaleStage2_tokenPrice);
264 	    _supply = safeAdd(SaleStage2_supply,SaleStage1_supply);
265         } else if(now >= SaleStage1_start) {
266             tokens = safeDiv(msg.value * (10**18),SaleStage1_tokenPrice);
267 	    _supply = SaleStage1_supply;
268 	} else {}
269 	
270 	require( safeAdd(_totalSupply, tokens) <= _supply);
271         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
272         _totalSupply = safeAdd(_totalSupply, tokens);
273         Transfer(address(0), msg.sender, tokens);
274         owner.transfer(msg.value);
275     }
276 
277 
278     // ------------------------------------------------------------------------
279     // Owner can transfer out any accidentally sent ERC20 tokens
280     // ------------------------------------------------------------------------
281     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
282         return ERC20Interface(tokenAddress).transfer(owner, tokens);
283     }
284 }