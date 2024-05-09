1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'CDS' token contract
5 //
6 // Symbol      : CDS
7 // Name        : Coin Dogs Share
8 // Total supply: 3000000
9 // Decimals    : 0
10 // Website     : www.CoinDogs.co
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 contract SafeMath {
19     function safeAdd(uint a, uint b) public pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) public pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) public pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) public pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
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
86 
87     //!!!! before acceptOwnership also transfer tokens from owner to newowner!!!!
88     function acceptOwnership() public {
89         require(msg.sender == newOwner);
90         emit OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92         newOwner = address(0);
93     }
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Token, with the addition of symbol, name and decimals and assisted
99 // token transfers
100 // ----------------------------------------------------------------------------
101 contract CoinDogToken is ERC20Interface, Owned, SafeMath {
102     string public symbol;
103     string public  name;
104     uint8 public decimals;
105 
106     uint public TotalSupply;
107     uint public AmountToDistribute;
108 
109     uint256 public sellPrice;
110     uint256 public buyPrice;
111 
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115 
116 
117     // ------------------------------------------------------------------------
118     // Constructor
119     // ------------------------------------------------------------------------
120     function CoinDogToken() public {
121         symbol = "CDS";
122         name = "Coin Dogs Share";
123         decimals = 0;
124         TotalSupply = 3000000;
125         setAmountToDistribute(TotalSupply/3);
126         buyPrice = 1000000000000000000/400;
127         owner = msg.sender;
128         balances[this] = TotalSupply;
129         emit Transfer(address(0), this, TotalSupply);
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Total supply
135     // ------------------------------------------------------------------------
136     function totalSupply() public constant returns (uint) {
137         return TotalSupply;
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Get the token balance for account tokenOwner
143     // ------------------------------------------------------------------------
144     function balanceOf(address tokenOwner) public constant returns (uint balance) {
145         return balances[tokenOwner];
146     }
147 
148     function balanceOfTheContract() public constant returns (uint balance) {
149         return balances[this];
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Transfer the balance from token owner's account to to account
155     // - Owner's account must have sufficient balance to transfer
156     // - 0 value transfers are allowed
157     // ------------------------------------------------------------------------
158     function transfer(address to, uint tokens) public returns (bool success) {
159         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
160         balances[to] = safeAdd(balances[to], tokens);
161         emit Transfer(msg.sender, to, tokens);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Token owner can approve for spender to transferFrom(...) tokens
168     // from the token owner's account
169     //
170     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
171     // recommends that there are no checks for the approval double-spend attack
172     // as this should be implemented in user interfaces 
173     // ------------------------------------------------------------------------
174     function approve(address spender, uint tokens) public returns (bool success) {
175         allowed[msg.sender][spender] = tokens;
176         emit Approval(msg.sender, spender, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Transfer tokens from the from account to the to account
183     // 
184     // The calling account must already have sufficient tokens approve(...)-d
185     // for spending from the from account and
186     // - From account must have sufficient balance to transfer
187     // - Spender must have sufficient allowance to transfer
188     // - 0 value transfers are allowed
189     // ------------------------------------------------------------------------
190     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
191         balances[from] = safeSub(balances[from], tokens);
192         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
193         balances[to] = safeAdd(balances[to], tokens);
194         emit Transfer(from, to, tokens);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Returns the amount of tokens approved by the owner that can be
201     // transferred to the spender's account
202     // ------------------------------------------------------------------------
203     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
204         return allowed[tokenOwner][spender];
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Token owner can approve for spender to transferFrom(...) tokens
210     // from the token owner's account. The spender contract function
211     // receiveApproval(...) is then executed
212     // ------------------------------------------------------------------------
213     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
214         allowed[msg.sender][spender] = tokens;
215         emit Approval(msg.sender, spender, tokens);
216         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
217         return true;
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // accept ETH
223     // ------------------------------------------------------------------------
224     function () public payable {
225         buy();
226     }
227 
228 
229     // ------------------------------------------------------------------------
230     // Owner can transfer out any accidentally sent ERC20 tokens
231     // ------------------------------------------------------------------------
232     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
233         return ERC20Interface(tokenAddress).transfer(owner, tokens);
234     }
235 
236 
237 
238 
239 
240     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
241         sellPrice = newSellPrice;
242         buyPrice = newBuyPrice;
243     }
244 
245     function setAmountToDistribute(uint amount) public onlyOwner {
246         AmountToDistribute=amount;
247     }
248 
249     function sendToken(address to, uint amount) public onlyOwner {
250         sendToken_internal(to,amount);
251     }
252 
253     function DistributedSoFar() public constant returns (uint tokens) {
254         return TotalSupply-balances[this];
255     }
256     
257 
258     function sendToken_internal(address to, uint amount) internal {
259 
260         require(DistributedSoFar()+amount <= AmountToDistribute);
261 
262         balances[this] = safeSub(balances[this], amount);
263         balances[to] = safeAdd(balances[to], amount);
264 
265         emit Transfer(this, to, amount);
266     }
267 
268     function distributeTokens(address[] addresses, uint[] values) public onlyOwner {
269          require(addresses.length==values.length && values.length>0);
270          for (uint i = 0; i < addresses.length; i++) {
271             sendToken_internal(addresses[i], values[i]);
272          }
273     }
274 
275 
276 
277     function buy() public payable returns (uint amount)  {
278         require(buyPrice>0);
279 
280         amount = msg.value / buyPrice;                    // calculates the amount
281 
282         sendToken_internal(msg.sender, amount);
283 
284         return amount;                                    // ends function and returns
285     }
286 
287     function sell(uint amount) public returns (uint revenue) {
288         require(sellPrice>0);
289 
290         balances[msg.sender] = safeSub(balances[msg.sender], amount);
291         balances[this] = safeAdd(balances[this], amount);
292 
293 
294         revenue = amount * sellPrice;
295         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
296         emit Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
297         return revenue;                                   // ends function and returns
298     }
299 
300 
301 
302 
303 }