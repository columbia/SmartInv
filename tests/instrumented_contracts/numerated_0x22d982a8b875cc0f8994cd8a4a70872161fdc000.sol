1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // GZR 'Gizer Gaming' token presale contract
6 //
7 // For details, please visit: http://www.gizer.io
8 //
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 //
14 // SafeM (div not needed but kept for completeness' sake)
15 //
16 // ----------------------------------------------------------------------------
17 
18 library SafeM {
19 
20   function add(uint a, uint b) public pure returns (uint c) {
21     c = a + b;
22     require( c >= a );
23   }
24 
25   function sub(uint a, uint b) public pure returns (uint c) {
26     require( b <= a );
27     c = a - b;
28   }
29 
30   function mul(uint a, uint b) public pure returns (uint c) {
31     c = a * b;
32     require( a == 0 || c / a == b );
33   }
34 
35   function div(uint a, uint b) public pure returns (uint c) {
36     c = a / b;
37   }  
38 
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 //
44 // Owned contract
45 //
46 // ----------------------------------------------------------------------------
47 
48 contract Owned {
49 
50   address public owner;
51   address public newOwner;
52 
53   // Events ---------------------------
54 
55   event OwnershipTransferProposed(address indexed _from, address indexed _to);
56   event OwnershipTransferred(address indexed _to);
57 
58   // Modifier -------------------------
59 
60   modifier onlyOwner {
61     require( msg.sender == owner );
62     _;
63   }
64 
65   // Functions ------------------------
66 
67   function Owned() public {
68     owner = msg.sender;
69   }
70 
71   function transferOwnership(address _newOwner) public onlyOwner {
72     require( _newOwner != owner );
73     require( _newOwner != address(0x0) );
74     newOwner = _newOwner;
75     OwnershipTransferProposed(owner, _newOwner);
76   }
77 
78   function acceptOwnership() public {
79     require( msg.sender == newOwner );
80     owner = newOwner;
81     OwnershipTransferred(owner);
82   }
83 
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 //
89 // ERC Token Standard #20 Interface
90 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
91 //
92 // ----------------------------------------------------------------------------
93 
94 contract ERC20Interface {
95 
96   // Events ---------------------------
97 
98   event Transfer(address indexed _from, address indexed _to, uint _value);
99   event Approval(address indexed _owner, address indexed _spender, uint _value);
100 
101   // Functions ------------------------
102 
103   function totalSupply() public view returns (uint);
104   function balanceOf(address _owner) public view returns (uint balance);
105   function transfer(address _to, uint _value) public returns (bool success);
106   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
107   function approve(address _spender, uint _value) public returns (bool success);
108   function allowance(address _owner, address _spender) public view returns (uint remaining);
109 
110 }
111 
112 
113 // ----------------------------------------------------------------------------
114 //
115 // ERC Token Standard #20
116 //
117 // ----------------------------------------------------------------------------
118 
119 contract ERC20Token is ERC20Interface, Owned {
120   
121   using SafeM for uint;
122 
123   uint public tokensIssuedTotal = 0;
124   mapping(address => uint) balances;
125   mapping(address => mapping (address => uint)) allowed;
126 
127   // Functions ------------------------
128 
129   /* Total token supply */
130 
131   function totalSupply() public view returns (uint) {
132     return tokensIssuedTotal;
133   }
134 
135   /* Get the account balance for an address */
136 
137   function balanceOf(address _owner) public view returns (uint balance) {
138     return balances[_owner];
139   }
140 
141   /* Transfer the balance from owner's account to another account */
142 
143   function transfer(address _to, uint _amount) public returns (bool success) {
144     // amount sent cannot exceed balance
145     require( balances[msg.sender] >= _amount );
146 
147     // update balances
148     balances[msg.sender] = balances[msg.sender].sub(_amount);
149     balances[_to]        = balances[_to].add(_amount);
150 
151     // log event
152     Transfer(msg.sender, _to, _amount);
153     return true;
154   }
155 
156   /* Allow _spender to withdraw from your account up to _amount */
157 
158   function approve(address _spender, uint _amount) public returns (bool success) {
159     // approval amount cannot exceed the balance
160     require( balances[msg.sender] >= _amount );
161       
162     // update allowed amount
163     allowed[msg.sender][_spender] = _amount;
164     
165     // log event
166     Approval(msg.sender, _spender, _amount);
167     return true;
168   }
169 
170   /* Spender of tokens transfers tokens from the owner's balance */
171   /* Must be pre-approved by owner */
172 
173   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
174     // balance checks
175     require( balances[_from] >= _amount );
176     require( allowed[_from][msg.sender] >= _amount );
177 
178     // update balances and allowed amount
179     balances[_from]            = balances[_from].sub(_amount);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
181     balances[_to]              = balances[_to].add(_amount);
182 
183     // log event
184     Transfer(_from, _to, _amount);
185     return true;
186   }
187 
188   /* Returns the amount of tokens approved by the owner */
189   /* that can be transferred by spender */
190 
191   function allowance(address _owner, address _spender) public view returns (uint remaining) {
192     return allowed[_owner][_spender];
193   }
194 
195 }
196 
197 
198 // ----------------------------------------------------------------------------
199 //
200 // GZR token presale
201 //
202 // ----------------------------------------------------------------------------
203 
204 contract GizerTokenPresale is ERC20Token {
205 
206   /* Utility variables */
207   
208   uint constant E6  = 10**6;
209 
210   /* Basic token data */
211 
212   string public constant name     = "Gizer Gaming Presale Token";
213   string public constant symbol   = "GZRPRE";
214   uint8  public constant decimals = 6;
215 
216   /* Wallets */
217   
218   address public wallet;
219   address public redemptionWallet;
220 
221   /* General crowdsale parameters */  
222   
223   uint public constant MIN_CONTRIBUTION = 1 ether / 10; // 0.1 Ether
224   uint public constant MAX_CONTRIBUTION = 100 ether;
225   
226   /* Private sale */
227 
228   uint public constant PRIVATE_SALE_MAX_ETHER = 2300 ether;
229   
230   /* Presale parameters */
231   
232   uint public constant DATE_PRESALE_START = 1512050400; // 30-Nov-2017 14:00 UTC
233   uint public constant DATE_PRESALE_END   = 1513260000; // 14-Dec-2017 14:00 UTC
234   
235   uint public constant TOKETH_PRESALE_ONE   = 1150 * E6; // presale wave 1 (  1-100)
236   uint public constant TOKETH_PRESALE_TWO   = 1100 * E6; // presale wave 2 (101-500)
237   uint public constant TOKETH_PRESALE_THREE = 1075 * E6; // presale - others
238   
239   uint public constant CUTOFF_PRESALE_ONE = 100; // last contributor wave 1
240   uint public constant CUTOFF_PRESALE_TWO = 500; // last contributor wave 2
241 
242   uint public constant FUNDING_PRESALE_MAX = 2300 ether;
243 
244   /* Presale variables */
245 
246   uint public etherReceivedPrivate = 0; // private sale Ether
247   uint public etherReceivedCrowd   = 0; // crowdsale Ether
248 
249   uint public tokensIssuedPrivate = 0; // private sale tokens
250   uint public tokensIssuedCrowd   = 0; // crowdsale tokens
251   uint public tokensBurnedTotal   = 0; // tokens burned by owner
252   
253   uint public presaleContributorCount = 0;
254   
255   bool public tokensFrozen = false;
256 
257   /* Mappings */
258 
259   mapping(address => uint) public balanceEthPrivate; // private sale Ether
260   mapping(address => uint) public balanceEthCrowd;   // crowdsale Ether
261 
262   mapping(address => uint) public balancesPrivate; // private sale tokens
263   mapping(address => uint) public balancesCrowd;   // crowdsale tokens
264 
265   // Events ---------------------------
266   
267   event WalletUpdated(address _newWallet);
268   event RedemptionWalletUpdated(address _newRedemptionWallet);
269   event TokensIssued(address indexed _owner, uint _tokens, uint _balance, uint _tokensIssuedCrowd, bool indexed _isPrivateSale, uint _amount);
270   event OwnerTokensBurned(uint _tokensBurned, uint _tokensBurnedTotal);
271   
272   // Basic Functions ------------------
273 
274   /* Initialize */
275 
276   function GizerTokenPresale() public {
277     wallet = owner;
278     redemptionWallet = owner;
279   }
280 
281   /* Fallback */
282   
283   function () public payable {
284     buyTokens();
285   }
286 
287   // Information Functions ------------
288   
289   /* What time is it? */
290   
291   function atNow() public view returns (uint) {
292     return now;
293   }
294 
295   // Owner Functions ------------------
296   
297   /* Change the crowdsale wallet address */
298 
299   function setWallet(address _wallet) public onlyOwner {
300     require( _wallet != address(0x0) );
301     wallet = _wallet;
302     WalletUpdated(_wallet);
303   }
304 
305   /* Change the redemption wallet address */
306 
307   function setRedemptionWallet(address _wallet) public onlyOwner {
308     redemptionWallet = _wallet;
309     RedemptionWalletUpdated(_wallet);
310   }
311   
312   /* Issue tokens for ETH received during private sale */
313 
314   function privateSaleContribution(address _account, uint _amount) public onlyOwner {
315     // checks
316     require( _account != address(0x0) );
317     require( atNow() < DATE_PRESALE_END );
318     require( _amount >= MIN_CONTRIBUTION );
319     require( etherReceivedPrivate.add(_amount) <= PRIVATE_SALE_MAX_ETHER );
320     
321     // same conditions as early presale participants
322     uint tokens = TOKETH_PRESALE_ONE.mul(_amount) / 1 ether;
323     
324     // issue tokens
325     issueTokens(_account, tokens, _amount, true); // true => private sale
326   }
327 
328   /* Freeze tokens */
329   
330   function freezeTokens() public onlyOwner {
331     require( atNow() > DATE_PRESALE_END );
332     tokensFrozen = true;
333   }
334   
335   /* Burn tokens held by owner */
336   
337   function burnOwnerTokens() public onlyOwner {
338     // check if there is anything to burn
339     require( balances[owner] > 0 );
340     
341     // update 
342     uint tokensBurned = balances[owner];
343     balances[owner] = 0;
344     tokensIssuedTotal = tokensIssuedTotal.sub(tokensBurned);
345     tokensBurnedTotal = tokensBurnedTotal.add(tokensBurned);
346     
347     // log
348     Transfer(owner, 0x0, tokensBurned);
349     OwnerTokensBurned(tokensBurned, tokensBurnedTotal);
350 
351   }  
352 
353   /* Transfer out any accidentally sent ERC20 tokens */
354 
355   function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success) {
356       return ERC20Interface(tokenAddress).transfer(owner, amount);
357   }
358 
359   // Private functions ----------------
360 
361   /* Accept ETH during presale (called by default function) */
362 
363   function buyTokens() private {
364     // initial checks
365     require( atNow() > DATE_PRESALE_START && atNow() < DATE_PRESALE_END );
366     require( msg.value >= MIN_CONTRIBUTION && msg.value <= MAX_CONTRIBUTION );
367     require( etherReceivedCrowd.add(msg.value) <= FUNDING_PRESALE_MAX );
368 
369     // tokens
370     uint tokens;
371     if (presaleContributorCount < CUTOFF_PRESALE_ONE) {
372       // wave 1
373       tokens = TOKETH_PRESALE_ONE.mul(msg.value) / 1 ether;
374     } else if (presaleContributorCount < CUTOFF_PRESALE_TWO) {
375       // wave 2
376       tokens = TOKETH_PRESALE_TWO.mul(msg.value) / 1 ether;
377     } else {
378       // wave 3
379       tokens = TOKETH_PRESALE_THREE.mul(msg.value) / 1 ether;
380     }
381     presaleContributorCount += 1;
382     
383     // issue tokens
384     issueTokens(msg.sender, tokens, msg.value, false); // false => not private sale
385   }
386   
387   /* Issue tokens */
388   
389   function issueTokens(address _account, uint _tokens, uint _amount, bool _isPrivateSale) private {
390     // register tokens purchased and Ether received
391     balances[_account] = balances[_account].add(_tokens);
392     tokensIssuedCrowd  = tokensIssuedCrowd.add(_tokens);
393     tokensIssuedTotal  = tokensIssuedTotal.add(_tokens);
394     
395     if (_isPrivateSale) {
396       tokensIssuedPrivate         = tokensIssuedPrivate.add(_tokens);
397       etherReceivedPrivate        = etherReceivedPrivate.add(_amount);
398       balancesPrivate[_account]   = balancesPrivate[_account].add(_tokens);
399       balanceEthPrivate[_account] = balanceEthPrivate[_account].add(_amount);
400     } else {
401       etherReceivedCrowd        = etherReceivedCrowd.add(_amount);
402       balancesCrowd[_account]   = balancesCrowd[_account].add(_tokens);
403       balanceEthCrowd[_account] = balanceEthCrowd[_account].add(_amount);
404     }
405     
406     // log token issuance
407     Transfer(0x0, _account, _tokens);
408     TokensIssued(_account, _tokens, balances[_account], tokensIssuedCrowd, _isPrivateSale, _amount);
409 
410     // transfer Ether out
411     if (this.balance > 0) wallet.transfer(this.balance);
412 
413   }
414 
415   // ERC20 functions ------------------
416 
417   /* Override "transfer" */
418 
419   function transfer(address _to, uint _amount) public returns (bool success) {
420     require( _to == owner || (!tokensFrozen && _to == redemptionWallet) );
421     return super.transfer(_to, _amount);
422   }
423   
424   /* Override "transferFrom" */
425 
426   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
427     require( !tokensFrozen && _to == redemptionWallet );
428     return super.transferFrom(_from, _to, _amount);
429   }
430 
431 }