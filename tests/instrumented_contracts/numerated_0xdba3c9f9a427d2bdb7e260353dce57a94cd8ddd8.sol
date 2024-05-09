1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Owned contract
6 //
7 // ----------------------------------------------------------------------------
8 
9 contract Owned {
10 
11     address public owner;
12     address public newOwner;
13 
14     event OwnershipTransferProposed(
15       address indexed _from,
16       address indexed _to
17     );
18 
19     event OwnershipTransferred(
20       address indexed _from,
21       address indexed _to
22     );
23 
24     function Owned()
25     {
26       owner = msg.sender;
27     }
28 
29     modifier onlyOwner
30     {
31       require(msg.sender == owner);
32       _;
33     }
34 
35     function transferOwnership(address _newOwner) onlyOwner
36     {
37       require(_newOwner != address(0x0));
38       OwnershipTransferProposed(owner, _newOwner);
39       newOwner = _newOwner;
40     }
41 
42     function acceptOwnership()
43     {
44       require(msg.sender == newOwner);
45       OwnershipTransferred(owner, newOwner);
46       owner = newOwner;
47     }
48 
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 //
54 // SafeMath contract
55 //
56 // ----------------------------------------------------------------------------
57 
58 contract SafeMath {
59 
60   function safeAdd(uint a, uint b) internal
61     returns (uint)
62   {
63     uint c = a + b;
64     assert(c >= a && c >= b);
65     return c;
66   }
67 
68   function safeSub(uint a, uint b) internal
69     returns (uint)
70   {
71     assert(b <= a);
72     uint c = a - b;
73     assert(c <= a);
74     return c;
75   }
76 
77 }
78 
79 
80 // ----------------------------------------------------------------------------
81 //
82 // ERC Token Standard #20 Interface
83 // https://github.com/ethereum/EIPs/issues/20
84 //
85 // ----------------------------------------------------------------------------
86 
87 contract ERC20Interface {
88 
89     event LogTransfer(
90       address indexed _from,
91       address indexed _to,
92       uint256 _value
93     );
94     
95     event LogApproval(
96       address indexed _owner,
97       address indexed _spender,
98       uint256 _value
99     );
100 
101     function totalSupply() constant
102       returns (uint256);
103     
104     function balanceOf(address _owner) constant 
105       returns (uint256 balance);
106     
107     function transfer(address _to, uint256 _value)
108       returns (bool success);
109     
110     function transferFrom(address _from, address _to, uint256 _value) 
111       returns (bool success);
112     
113     function approve(address _spender, uint256 _value) 
114       returns (bool success);
115     
116     function allowance(address _owner, address _spender) constant 
117       returns (uint256 remaining);
118 
119 }
120 
121 // ----------------------------------------------------------------------------
122 //
123 // ERC Token Standard #20
124 //
125 // note that totalSupply() is not defined here
126 //
127 // ----------------------------------------------------------------------------
128 
129 contract ERC20Token is ERC20Interface, Owned, SafeMath {
130 
131     // Account balances
132     //
133     mapping(address => uint256) balances;
134 
135     // Account holder approves the transfer of an amount to another account
136     //
137     mapping(address => mapping (address => uint256)) allowed;
138 
139     // Get the account balance for an address
140     function balanceOf(address _owner) constant 
141       returns (uint256 balance)
142     {
143       return balances[_owner];
144     }
145 
146     // ------------------------------------------------------------------------
147     // Transfer the balance from owner's account to another account
148     // ------------------------------------------------------------------------
149     function transfer(address _to, uint256 _amount) 
150       returns (bool success)
151     {
152       require( _amount > 0 );                              // Non-zero transfer
153       require( balances[msg.sender] >= _amount );          // User has balance
154       require( balances[_to] + _amount > balances[_to] );  // Overflow check
155 
156       balances[msg.sender] -= _amount;
157       balances[_to] += _amount;
158       LogTransfer(msg.sender, _to, _amount);
159       return true;
160     }
161 
162     // ------------------------------------------------------------------------
163     // Allow _spender to withdraw from your account, multiple times, up to
164     // _amount. If this function is called again it overwrites the
165     // current allowance with _amount.
166     // ------------------------------------------------------------------------
167     function approve(address _spender, uint256 _amount) 
168       returns (bool success)
169     {
170       // before changing the approve amount for an address, its allowance
171       // must be reset to 0 to mitigate the race condition described here:
172       // cf https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173       require( _amount == 0 || allowed[msg.sender][_spender] == 0 );
174         
175       // the approval amount cannot exceed the balance
176       require (balances[msg.sender] >= _amount);
177         
178       allowed[msg.sender][_spender] = _amount;
179       LogApproval(msg.sender, _spender, _amount);
180       return true;
181     }
182 
183     // ------------------------------------------------------------------------
184     // Spender of tokens transfer an amount of tokens from the token owner's
185     // balance to another account. The owner of the tokens must already
186     // have approve(...)-d this transfer
187     // ------------------------------------------------------------------------
188     function transferFrom(address _from, address _to, uint256 _amount) 
189     returns (bool success) 
190     {
191       require( _amount > 0 );                              // Non-zero transfer
192       require( balances[_from] >= _amount );               // Sufficient balance
193       require( allowed[_from][msg.sender] >= _amount );    // Transfer approved
194       require( balances[_to] + _amount > balances[_to] );  // Overflow check
195 
196       balances[_from] -= _amount;
197       allowed[_from][msg.sender] -= _amount;
198       balances[_to] += _amount;
199       LogTransfer(_from, _to, _amount);
200       return true;
201     }
202 
203     // ------------------------------------------------------------------------
204     // Returns the amount of tokens approved by the owner that can be
205     // transferred by _spender
206     // ------------------------------------------------------------------------
207 
208     function allowance(address _owner, address _spender) constant 
209     returns (uint256 remaining)
210     {
211       return allowed[_owner][_spender];
212     }
213 
214 }
215 
216 // ----------------------------------------------------------------------------
217 //
218 // GZR public token sale
219 //
220 // ----------------------------------------------------------------------------
221 
222 contract Zorro02Token is ERC20Token {
223 
224 
225     // VARIABLES ================================
226 
227 
228     // basic token data
229 
230     string public constant name = "Zorro02";
231     string public constant symbol = "ZORRO02";
232     uint8 public constant decimals = 18;
233     string public constant GITHUB_LINK = 'htp://github.com/..';
234 
235     // wallet address (can be reset at any time during ICO)
236     
237     address public wallet;
238 
239     // ICO variables that can be reset before ICO starts
240 
241     uint public tokensPerEth = 100000;
242     uint public icoTokenSupply = 300;
243 
244     // ICO constants #1
245 
246     uint public constant TOTAL_TOKEN_SUPPLY = 1000;
247     uint public constant ICO_TRIGGER = 10;
248     uint public constant MIN_CONTRIBUTION = 10**15;
249     
250     // ICO constants #2 : ICO dates
251 
252     // Start - Friday, 15-Sep-17 00:00:00 UTC
253     // End - Sunday, 15-Oct-17 00:00:00 UTC
254     // as per http://www.unixtimestamp.com
255     uint public constant START_DATE = 1502787600;
256     uint public constant END_DATE = 1502791200;
257 
258     // ICO variables
259 
260     uint public icoTokensIssued = 0;
261     bool public icoFinished = false;
262     bool public tradeable = false;
263 
264     // Minting
265     
266     uint public ownerTokensMinted = 0;
267     
268     // other variables
269     
270     uint256 constant MULT_FACTOR = 10**18;
271     
272 
273     // EVENTS ===================================
274 
275     
276     event LogWalletUpdated(
277       address newWallet
278     );
279     
280     event LogTokensPerEthUpdated(
281       uint newTokensPerEth
282     );
283     
284     event LogIcoTokenSupplyUpdated(
285       uint newIcoTokenSupply
286     );
287     
288     event LogTokensBought(
289       address indexed buyer,
290       uint ethers,
291       uint tokens, 
292       uint participantTokenBalance, 
293       uint newIcoTokensIssued
294     );
295     
296     event LogMinting(
297       address indexed participant,
298       uint tokens,
299       uint newOwnerTokensMinted
300     );
301 
302 
303     // FUNCTIONS ================================
304     
305     // --------------------------------
306     // initialize
307     // --------------------------------
308 
309     function Zorro02Token() {
310       owner = msg.sender;
311       wallet = msg.sender;
312     }
313 
314 
315     // --------------------------------
316     // implement totalSupply() ERC20 function
317     // --------------------------------
318     
319     function totalSupply() constant
320       returns (uint256)
321     {
322       return TOTAL_TOKEN_SUPPLY;
323     }
324 
325 
326     // --------------------------------
327     // changing ICO parameters
328     // --------------------------------
329     
330     // Owner can change the crowdsale wallet address at any time
331     //
332     function setWallet(address _wallet) onlyOwner
333     {
334       wallet = _wallet;
335       LogWalletUpdated(wallet);
336     }
337     
338     // Owner can change the number of tokens per ETH before the ICO start date
339     //
340     function setTokensPerEth(uint _tokensPerEth) onlyOwner
341     {
342       require(now < START_DATE);
343       require(_tokensPerEth > 0);
344       tokensPerEth = _tokensPerEth;
345       LogTokensPerEthUpdated(tokensPerEth);
346     }
347         
348 
349     // Owner can change the number available tokens for the ICO
350     // (must be below 70 million) 
351     //
352     function setIcoTokenSupply(uint _icoTokenSupply) onlyOwner
353     {
354         require(now < START_DATE);
355         require(_icoTokenSupply < TOTAL_TOKEN_SUPPLY);
356         icoTokenSupply = _icoTokenSupply;
357         LogIcoTokenSupplyUpdated(icoTokenSupply);
358     }
359 
360 
361     // --------------------------------
362     // Default function
363     // --------------------------------
364     
365     function () payable
366     {
367         proxyPayment(msg.sender);
368     }
369 
370     // --------------------------------
371     // Accept ETH during crowdsale
372     // --------------------------------
373 
374     function proxyPayment(address participant) payable
375     {
376         require(!icoFinished);
377         require(now >= START_DATE);
378         require(now <= END_DATE);
379         require(msg.value > MIN_CONTRIBUTION);
380         
381         // get number of tokens
382         uint tokens = msg.value * tokensPerEth;
383         
384         // first check if there is enough capacity
385         uint available = icoTokenSupply - icoTokensIssued;
386         require (tokens <= available); 
387 
388         // ok it's possible to issue tokens so let's do it
389         
390         // Add tokens purchased to account's balance and total supply
391         // TODO - verify SafeAdd is not necessary
392         balances[participant] += tokens;
393         icoTokensIssued += tokens;
394 
395         // Transfer the tokens to the participant  
396         LogTransfer(0x0, participant, tokens);
397         
398         // Log the token purchase
399         LogTokensBought(participant, msg.value, tokens, balances[participant], icoTokensIssued);
400 
401         // Transfer the contributed ethers to the crowdsale wallet
402         // throw is deprecated starting from Ethereum v0.9.0
403         wallet.transfer(msg.value);
404     }
405 
406     
407     // --------------------------------
408     // Minting of tokens by owner
409     // --------------------------------
410 
411     // Tokens remaining available to mint by owner
412     //
413     function availableToMint()
414       returns (uint)
415     {
416       if (icoFinished) {
417         return TOTAL_TOKEN_SUPPLY - icoTokensIssued - ownerTokensMinted;
418       } else {
419         return TOTAL_TOKEN_SUPPLY - icoTokenSupply - ownerTokensMinted;        
420       }
421     }
422 
423     // Minting of tokens by owner
424     //    
425     function mint(address participant, uint256 tokens) onlyOwner 
426     {
427         require( tokens <= availableToMint() );
428         balances[participant] += tokens;
429         ownerTokensMinted += tokens;
430         LogTransfer(0x0, participant, tokens);
431         LogMinting(participant, tokens, ownerTokensMinted);
432     }
433 
434     // --------------------------------
435     // Declare ICO finished
436     // --------------------------------
437     
438     function declareIcoFinished() onlyOwner
439     {
440       // the token can only be made tradeable after ICO finishes
441       require( now > END_DATE || icoTokenSupply - icoTokensIssued < ICO_TRIGGER );
442       icoFinished = true;
443     }
444 
445     // --------------------------------
446     // Make tokens tradeable
447     // --------------------------------
448     
449     function tradeable() onlyOwner
450     {
451       // the token can only be made tradeable after ICO finishes
452       require(icoFinished);
453       tradeable = true;
454     }
455 
456     // --------------------------------
457     // Transfers
458     // --------------------------------
459 
460     function transfer(address _to, uint _amount) 
461       returns (bool success)
462     {
463       // Cannot transfer out until tradeable, except for owner
464       require(tradeable || msg.sender == owner);
465       return super.transfer(_to, _amount);
466     }
467 
468     function transferFrom(address _from, address _to, uint _amount) 
469       returns (bool success)
470     {
471         // not possible until tradeable
472         require(tradeable);
473         return super.transferFrom(_from, _to, _amount);
474     }
475 
476     // --------------------------------
477     // Varia
478     // --------------------------------
479 
480     // Transfer out any accidentally sent ERC20 tokens
481     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner 
482       returns (bool success) 
483     {
484         return ERC20Interface(tokenAddress).transfer(owner, amount);
485     }
486 
487 }