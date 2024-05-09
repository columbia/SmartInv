1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'Claims' token
5 //
6 // Symbol      : CLM
7 // Name        : Claims
8 // Total supply: 36,000,000
9 // Decimals    : 18
10 //
11 // Claim your claims out of the claim pool
12 //
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) internal pure returns (uint c) {
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
75     constructor() public {
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
89         emit OwnershipTransferred(owner, newOwner);
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
100 contract ClaimsToken is ERC20Interface, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint public totalSupply;
105     uint public maxTotalSupply;
106     uint public unitsPerTransaction;
107     uint public tokensDistributed;
108     uint public numDistributions;
109     uint public numDistributionsRemaining;
110     
111     address public fundsWallet;  
112     address public foundationWallet;
113     address public claimPool;
114     uint public initialFoundationSupply;
115 
116     mapping(address => uint) balances;
117     mapping(address => mapping(address => uint)) allowed;
118 
119 
120     // ------------------------------------------------------------------------
121     // Constructor
122     // ------------------------------------------------------------------------
123     constructor() public {   
124 
125         fundsWallet      = 0x0000000000000000000000000000000000000000; 
126         claimPool        = 0x0000000000000000000000000000000000000001;
127 
128         foundationWallet = 0x139E766c7c7e00Ed7214CeaD039C4b782AbD3c3e;
129         
130         // Initially fill the funds wallet (0x0000)
131         balances[fundsWallet] = 12000000000000000000000000;  
132 
133         totalSupply           = 12000000000000000000000000;
134         maxTotalSupply        = 36000000000000000000000000;
135         unitsPerTransaction   = 2400000000000000000000;
136 
137         name = "Claims";                                 
138         decimals = 18;                                              
139         symbol = "CLM";  
140 
141         
142         // We take 12.5% initially to distribute equally between the first 25 seeds on bitcointalk
143         initialFoundationSupply = 1500000000000000000000000;
144         
145         balances[foundationWallet] = safeAdd(balances[foundationWallet], initialFoundationSupply);
146         balances[fundsWallet] = safeSub(balances[fundsWallet], initialFoundationSupply);
147 
148         emit Transfer(fundsWallet, foundationWallet, initialFoundationSupply);
149         
150         tokensDistributed = initialFoundationSupply;   
151         
152         // Calculate remaining distributions
153         numDistributionsRemaining = (totalSupply - tokensDistributed) / unitsPerTransaction;   
154         numDistributions = 1;       
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Total supply
160     // ------------------------------------------------------------------------
161     function totalSupply() public constant returns (uint) {
162         return totalSupply;
163     }
164     
165     // ------------------------------------------------------------------------
166     // Max total supply
167     // ------------------------------------------------------------------------
168     function maxTotalSupply() public constant returns (uint) {
169         return maxTotalSupply;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Get the token balance for account `tokenOwner`
175     // ------------------------------------------------------------------------
176     function balanceOf(address tokenOwner) public constant returns (uint balance) {
177         return balances[tokenOwner];
178     }
179 
180     // ------------------------------------------------------------------------
181     // Mint some tokens in the claim pool unitill maxTotalSupply is reached
182     // ------------------------------------------------------------------------
183     function increaseClaimPool() private returns (bool success) { 
184         if (totalSupply < maxTotalSupply){
185             // Add some extra to the claim pool if the maximum total supply is no reached yet
186             balances[claimPool] = safeAdd(balances[claimPool], safeDiv(unitsPerTransaction, 10));
187             totalSupply = safeAdd(totalSupply, safeDiv(unitsPerTransaction, 10));
188             return true;
189         } else {
190             return false;
191         }
192     }
193 
194     // ------------------------------------------------------------------------
195     // Get your share out of the claim pool
196     // - You will need some balance, your claim reward is limited to 10% your current balance
197     // - 10% of the reward is transferred back to the foundation as a claim-fee
198     // ------------------------------------------------------------------------
199     function mint() public returns (bool success) {
200 
201         uint maxReward = safeDiv(balances[msg.sender], 10);
202 
203         uint reward = maxReward;
204 
205         if(balances[claimPool] < reward){
206             reward = balances[claimPool];
207         }
208 
209         if (reward > 0){
210 
211             balances[claimPool] = safeSub(balances[claimPool], reward);
212 
213             balances[msg.sender] = safeAdd(balances[msg.sender], safeDiv(safeMul(reward, 9), 10));
214             balances[foundationWallet] = safeAdd(balances[foundationWallet], safeDiv(reward, 10));
215 
216 
217             emit Transfer(claimPool, msg.sender, safeDiv(safeMul(reward, 9), 10));
218             emit Transfer(claimPool, foundationWallet, safeDiv(reward, 10));
219 
220             return true;
221 
222         } else {
223             // Nothing to claim
224             return false;
225         }
226     }
227 
228 
229     // ------------------------------------------------------------------------
230     // Transfer the balance from token owner's account to `to` account
231     // - Owner's account must have sufficient balance to transfer
232     // - 0 value transfers are redirected to the 'claim' function
233     // - 99% is tranferred to the destination address, 1% is transferred to the claim pool
234     // ------------------------------------------------------------------------
235     function transfer(address to, uint tokens) public returns (bool success) {
236         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
237         
238         balances[to] = safeAdd(balances[to], safeDiv(safeMul(tokens, 99),100));
239         balances[claimPool] = safeAdd(balances[claimPool], safeDiv(tokens,100));
240         
241         if (tokens > 0){
242             increaseClaimPool(); 
243         
244             emit Transfer(msg.sender, to, safeDiv(safeMul(tokens, 99), 100));
245             emit Transfer(msg.sender, claimPool, safeDiv(tokens, 100));
246 
247         } else {
248             // Mint from the claim pool
249             mint();
250         }
251 
252         return true;
253     }
254 
255 
256     // ------------------------------------------------------------------------
257     // Token owner can approve for `spender` to transferFrom(...) `tokens`
258     // from the token owner's account
259     //
260     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
261     // recommends that there are no checks for the approval double-spend attack
262     // as this should be implemented in user interfaces
263     // ------------------------------------------------------------------------
264     function approve(address spender, uint tokens) public returns (bool success) {
265         allowed[msg.sender][spender] = tokens;
266         emit Approval(msg.sender, spender, tokens);
267         return true;
268     }
269 
270 
271     // ------------------------------------------------------------------------
272     // Transfer `tokens` from the `from` account to the `to` account
273     //
274     // The calling account must already have sufficient tokens approve(...)-d
275     // for spending from the `from` account and
276     // - From account must have sufficient balance to transfer
277     // - Spender must have sufficient allowance to transfer
278     // - 0 value transfers are allowed, they do not result in calling the 'claim' function
279     // - 99% is tranferred to the destination address, 1% is transferred to the claim pool
280     // ------------------------------------------------------------------------
281     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
282         balances[from] = safeSub(balances[from], tokens);
283         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
284   
285         if (tokens > 0){
286             increaseClaimPool();
287         }
288         
289         emit Transfer(from, to, safeDiv(safeMul(tokens, 99), 100));
290         emit Transfer(from, claimPool, safeDiv(tokens, 100));
291         
292         return true;
293     }
294 
295     // ------------------------------------------------------------------------
296     // Returns the amount of tokens approved by the owner that can be
297     // transferred to the spender's account
298     // ------------------------------------------------------------------------
299     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
300         return allowed[tokenOwner][spender];
301     }
302 
303     // ------------------------------------------------------------------------
304     // Token owner can approve for `spender` to transferFrom(...) `tokens`
305     // from the token owner's account. The `spender` contract function
306     // `receiveApproval(...)` is then executed
307     // This is something exchanges are using
308     // ------------------------------------------------------------------------
309     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
310         allowed[msg.sender][spender] = tokens;
311         emit Approval(msg.sender, spender, tokens);
312         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
313         return true;
314     }
315 
316     // ------------------------------------------------------------------------
317     // Fixed amount of tokens per transaction, return Eth
318     // ------------------------------------------------------------------------
319     function () public payable {
320     
321         // Check if distribution phase is active and if the user is allowed to receive the airdrop
322         if(numDistributionsRemaining > 0 && balances[msg.sender] == 0 
323           && balances[fundsWallet] >= unitsPerTransaction){
324 
325             // Do the transaction
326             uint tokens = unitsPerTransaction;
327             
328             balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
329             balances[fundsWallet] = safeSub(balances[fundsWallet], tokens);
330 
331             tokensDistributed = safeAdd(tokensDistributed, tokens);
332             numDistributions = safeAdd(numDistributions, 1);
333             
334             numDistributionsRemaining = safeSub(numDistributionsRemaining, 1);
335             
336             emit Transfer(fundsWallet, msg.sender, tokens);
337         } else {
338             // Mint from the claim pool
339             mint();
340         }
341         
342         // Refund ETH in case you accidentally sent some.. You probably did not want so sent them..
343         msg.sender.transfer(msg.value);
344     }
345 
346 
347     // ------------------------------------------------------------------------
348     // Owner can transfer out any accidentally sent ERC20 tokens
349     // ------------------------------------------------------------------------
350     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
351         return ERC20Interface(tokenAddress).transfer(owner, tokens);
352     }
353 }