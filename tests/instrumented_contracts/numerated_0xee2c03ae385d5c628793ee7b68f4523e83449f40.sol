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
111 	uint private SaleStage2_tokenPrice = 108; // 0.65 usd
112 
113 	uint private SaleStage3_start = 1533081600;
114 	uint256 private SaleStage3_supply = 50 * (10**24);
115 	uint private SaleStage3_tokenPrice = 134 * (10**24); // 0.8 usd
116 	
117     uint public startDate = 1527811200;
118     uint public endDate = 1535760000;
119 
120 	uint256 public hardcap = 22800 ether;
121 	uint256 public softcap = 62250 ether;
122 
123     mapping(address => uint) balances;
124     mapping(address => mapping(address => uint)) allowed;
125 
126 
127     // ------------------------------------------------------------------------
128     // Constructor
129     // ------------------------------------------------------------------------
130     function RebateCoin() public {
131         symbol = "RBC";
132         name = "Rebate Coin";
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Total supply
138     // ------------------------------------------------------------------------
139     function totalSupply() public constant returns (uint) {
140         return _totalSupply  - balances[address(0)];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Get the token balance for account `tokenOwner`
146     // ------------------------------------------------------------------------
147     function balanceOf(address tokenOwner) public constant returns (uint balance) {
148         return balances[tokenOwner];
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Transfer the balance from token owner's account to `to` account
154     // - Owner's account must have sufficient balance to transfer
155     // - 0 value transfers are allowed
156     // ------------------------------------------------------------------------
157     function transfer(address to, uint tokens) public returns (bool success) {
158         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
159         balances[to] = safeAdd(balances[to], tokens);
160         Transfer(msg.sender, to, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Token owner can approve for `spender` to transferFrom(...) `tokens`
167     // from the token owner's account
168     //
169     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
170     // recommends that there are no checks for the approval double-spend attack
171     // as this should be implemented in user interfaces
172     // ------------------------------------------------------------------------
173     function approve(address spender, uint tokens) public returns (bool success) {
174         allowed[msg.sender][spender] = tokens;
175         Approval(msg.sender, spender, tokens);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Transfer `tokens` from the `from` account to the `to` account
182     //
183     // The calling account must already have sufficient tokens approve(...)-d
184     // for spending from the `from` account and
185     // - From account must have sufficient balance to transfer
186     // - Spender must have sufficient allowance to transfer
187     // - 0 value transfers are not allowed
188     // ------------------------------------------------------------------------
189     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
190         balances[from] = safeSub(balances[from], tokens);
191 		if (tokens > 0 && from != to) {
192         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
193         balances[to] = safeAdd(balances[to], tokens);
194         Transfer(from, to, tokens);
195 		}
196         return true;
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Returns the amount of tokens approved by the owner that can be
202     // transferred to the spender's account
203     // ------------------------------------------------------------------------
204     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
205         return allowed[tokenOwner][spender];
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Token owner can approve for `spender` to transferFrom(...) `tokens`
211     // from the token owner's account. The `spender` contract function
212     // `receiveApproval(...)` is then executed
213     // ------------------------------------------------------------------------
214     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
215         allowed[msg.sender][spender] = tokens;
216         Approval(msg.sender, spender, tokens);
217         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
218         return true;
219     }
220 
221     // ------------------------------------------------------------------------
222     // RBC Tokens per 1 ETH
223     // ------------------------------------------------------------------------
224     function () public payable {
225         require(now >= startDate && now <= endDate);
226         uint tokens;
227         if (now >= SaleStage3_start) {
228             tokens = safeDiv(msg.value * (10**18),SaleStage3_tokenPrice);
229 			_supply = safeAdd(SaleStage3_supply,safeAdd(SaleStage2_supply,SaleStage1_supply));
230         } else if(now >= SaleStage2_start) {
231             tokens = safeDiv(msg.value * (10**18),SaleStage2_tokenPrice);
232 			_supply = safeAdd(SaleStage2_supply,SaleStage1_supply);
233         } else if(now >= SaleStage1_start) {
234             tokens = safeDiv(msg.value * (10**18),SaleStage1_tokenPrice);
235 			_supply = SaleStage1_supply;
236 		} else {}
237 		require( _totalSupply < _supply);
238         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
239         _totalSupply = safeAdd(_totalSupply, tokens);
240         Transfer(address(0), msg.sender, tokens);
241         owner.transfer(msg.value);
242     }
243 
244 
245     // ------------------------------------------------------------------------
246     // Owner can transfer out any accidentally sent ERC20 tokens
247     // ------------------------------------------------------------------------
248     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
249         return ERC20Interface(tokenAddress).transfer(owner, tokens);
250     }
251 }