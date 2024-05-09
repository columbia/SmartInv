1 //Copyright Global Invest Place Ltd.
2 pragma solidity ^0.4.13;
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal constant returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 
29 interface GlobalToken {
30     function balanceOf(address _owner) constant returns (uint256 balance);
31     function transfer(address _to, uint256 _value) returns (bool success);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 contract Owned {
37     address public owner;
38     
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     function Owned() {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner) ;
47         _;
48     }
49 	
50 	modifier onlyPayloadSize(uint numwords) {
51         assert(msg.data.length == numwords * 32 + 4);
52 		_;
53 	}
54 
55     function transferOwnership(address newOwner) onlyOwner {
56         owner = newOwner;
57         OwnershipTransferred(owner, newOwner);
58     }
59   
60   function contractVersion() constant returns(uint256) {
61         /*  contractVersion identifies as 100YYYYMMDDHHMM */
62         return 100201712010000;
63     }
64 }
65 
66 // GlobalToken Interface
67 contract GlobalCryptoFund is Owned, GlobalToken {
68     
69     using SafeMath for uint256;
70     
71     /* Public variables of the token */
72     string public name;
73     string public symbol;
74     uint8 public decimals;
75     uint256 public totalSupply;
76 	
77 	address public minter;
78     
79     /* This creates an array with all balances */
80     mapping (address => uint256) public balanceOf;
81     
82 	modifier onlyMinter {
83 		require(msg.sender == minter);
84 		_;
85 	}
86 	
87 	function setMinter(address _addressMinter) onlyOwner {
88 		minter = _addressMinter;
89 	}
90     
91     /* Initializes contract with initial supply tokens to the creator of the contract */
92     function GlobalCryptoFund() {
93 		name = "GlobalCryptoFund";                    								// Set the name for display purposes
94         symbol = "GCF";                												// Set the symbol for display purposes
95         decimals = 18;                          									// Amount of decimals for display purposes
96         totalSupply = 0;                									// Update total supply
97         balanceOf[msg.sender] = totalSupply;       									// Give the creator all initial tokens
98     }
99     
100     function balanceOf(address _owner) constant returns (uint256 balance){
101         return balanceOf[_owner];
102     }
103     
104     /* Internal transfer, only can be called by this contract */
105     function _transfer(address _from, address _to, uint256 _value) internal {
106         require (_to != 0x0);                               						// Prevent transfer to 0x0 address. Use burn() instead
107         require (balanceOf[_from] >= _value);                						// Check if the sender has enough
108         require (balanceOf[_to].add(_value) >= balanceOf[_to]); 						// Check for overflows
109         require(_to != address(this));
110         balanceOf[_from] = balanceOf[_from].sub(_value);                         	// Subtract from the sender
111         balanceOf[_to] = balanceOf[_to].add(_value);                           		// Add the same to the recipient
112         Transfer(_from, _to, _value);
113     }
114     
115     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool) {
116         _transfer(msg.sender, _to, _value);
117         return true;
118     }
119     
120 	event Mint(address indexed from, uint256 value);
121     function mintToken(address target, uint256 mintedAmount) onlyMinter {
122         balanceOf[target] = balanceOf[target].add(mintedAmount);
123         totalSupply = totalSupply.add(mintedAmount);
124         Transfer(0, this, mintedAmount);
125         Transfer(this, target, mintedAmount);
126         Mint(target, mintedAmount);
127     }
128     
129 	event Burn(address indexed from, uint256 value);
130     function burn(uint256 _value) onlyMinter returns (bool success) {
131         require (balanceOf[msg.sender] >= _value);            					// Check if the sender has enough
132         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);              // Subtract from the sender
133         totalSupply = totalSupply.sub(_value);                                	// Updates totalSupply
134         Burn(msg.sender, _value);
135         return true;
136     }  
137 	
138 	function kill() onlyOwner {
139         selfdestruct(owner);
140     }
141     
142     function contractVersion() constant returns(uint256) {
143         /*  contractVersion identifies as 200YYYYMMDDHHMM */
144         return 200201712010000;
145     }
146 }
147 
148 contract ExchangeManager is Owned {
149 	
150 	using SafeMath for uint256;
151 	 
152     GlobalCryptoFund public gcf;
153     ActualInfo[] public periods;
154 	address[] public accounts;
155     
156     struct ActualInfo {
157         uint256 ethAtThePeriod;
158         uint256 tokensAtThePeriod;
159         
160         uint256 price;
161         
162         uint256 ethForReederem;
163     }
164     
165     uint256 ethTax;
166     uint256 tokenTax;
167 	uint256 public currentPeriodPrice;
168 	uint256 public marketCap;
169 	
170     modifier onlyReg {
171         require(isReg[msg.sender]);
172         _;
173     }
174   
175     mapping (address => mapping (uint256 => uint256)) public buyTokens;
176     mapping (address => mapping (uint256 => uint256)) public sellTokens;
177 	mapping (address => address) public myUserWallet;
178     mapping (address => bool) public isReg;
179 	
180 
181     function ExchangeManager() {
182         gcf = GlobalCryptoFund(0x26F45379d3f581e09719f1dC79c184302572AF00);
183         require(gcf.contractVersion() == 200201712010000);
184 		
185 		uint256 newPeriod = periods.length++;
186 		ActualInfo storage info = periods[newPeriod];
187 		info.ethAtThePeriod = 0;
188 		info.tokensAtThePeriod = 0;
189 		info.price = 10000000000000000;
190 		info.ethForReederem = 0;
191     }
192 	
193 	event TaxTillNow(uint256 _ethTx, uint256 _tokenTx);
194 	function taxTillNow() onlyOwner returns (uint256 _ethTax, uint256 _tokenTax) {
195 		TaxTillNow(ethTax, tokenTax);
196 		return (ethTax, tokenTax);
197 	}
198 	
199 	event RegisterEvent(address indexed _person, address indexed _userWallet);
200     function Register() returns (address _userWallet) {
201         _userWallet = address(new UserWallet(this, gcf));
202         accounts.push(_userWallet);
203         UserWallet(_userWallet).transferOwnership(msg.sender);
204        
205         isReg[_userWallet] = true;
206         myUserWallet[msg.sender] = _userWallet;
207         
208 		RegisterEvent(msg.sender, _userWallet);
209         return _userWallet;
210     }
211 	
212     function getActualPeriod() returns (uint256) {
213         return periods.length;
214     }
215 	
216 	event ClosePeriodEvent(uint256 period, uint256 price, uint256 _marketCap, uint256 _ethForReederem);
217     function closePeriod(uint256 _price, uint256 _marketCap, uint256 _ethForReederem) onlyOwner {
218 		uint256 period = getActualPeriod();
219 		ActualInfo storage info = periods[period.sub(1)];
220 		uint256 tokensAtThisPeriod = info.tokensAtThePeriod;
221         //set Prices at this period
222         info.price = _price;
223 		//calculate how much eth must have at the contract for reederem
224 		if(_ethForReederem != 0) {
225 			info.ethForReederem = _ethForReederem;
226 		} else {
227 			info.ethForReederem = ((info.tokensAtThePeriod).mul(_price)).div(1 ether);
228 		}
229 		currentPeriodPrice = _price;
230 		
231 		marketCap = _marketCap;
232 		
233 		ClosePeriodEvent(period, info.price, marketCap, info.ethForReederem);
234 		
235 		end();
236     }
237 
238 	function end() internal {
239 		uint256 period = periods.length ++;
240 		ActualInfo storage info = periods[period];
241 		info.ethAtThePeriod = 0;
242 		info.tokensAtThePeriod = 0;
243 		info.price = 0;
244 		info. ethForReederem = 0;
245 	}
246 	
247     function getPrices() public returns (uint256 _Price) {
248         return currentPeriodPrice;
249     }
250 	
251 	event DepositEvent(address indexed _from, uint256 _amount);
252     function() payable {
253         DepositEvent(msg.sender, msg.value);
254     }
255 
256 	event BuyEvent(address indexed _from, uint256 period, uint256 _amountEthers, uint256 _ethAtThePeriod);
257     function buy(uint256 _amount) onlyReg returns (bool) {
258         require(_amount > 0.01 ether);
259 		
260         uint256 thisPeriod = getActualPeriod();
261         thisPeriod = thisPeriod.sub(1);
262 		
263 		uint256 tax = calculateTax(_amount);
264 		ethTax = ethTax.add(tax);
265 		uint256 _ethValue = _amount.sub(tax);
266 		
267         buyTokens[msg.sender][thisPeriod] = buyTokens[msg.sender][thisPeriod].add(_ethValue);
268 		
269 		ActualInfo storage info = periods[thisPeriod];
270 		info.ethAtThePeriod = info.ethAtThePeriod.add(_ethValue);
271 		
272 		BuyEvent(msg.sender, thisPeriod, _amount, info.ethAtThePeriod);
273 		
274 		return true;
275     }
276 	
277 	event ReederemEvent(address indexed _from, uint256 period, uint256 _amountTokens, uint256 _tokensAtThePeriod);
278     function Reederem(uint256 _amount) onlyReg returns (bool) {
279 		require(_amount > 0);
280 		
281         uint256 thisPeriod = getActualPeriod();
282 		thisPeriod = thisPeriod.sub(1);
283 		
284 		uint256 tax = calculateTax(_amount);
285 		tokenTax = tokenTax.add(tax);
286 		uint256 _tokensValue = _amount.sub(tax);
287 		
288         sellTokens[msg.sender][thisPeriod] = sellTokens[msg.sender][thisPeriod].add(_tokensValue);
289 		
290 		ActualInfo storage info = periods[thisPeriod];
291         info.tokensAtThePeriod = info.tokensAtThePeriod.add(_tokensValue);
292 		
293         ReederemEvent(msg.sender, thisPeriod, _amount, info.tokensAtThePeriod);
294 		
295         return true;
296     }
297 	
298 	event Tax(uint256 _taxPayment);
299 	function calculateTax(uint256 _amount) internal returns (uint256 _tax) {
300 		_tax = (_amount.mul(5)).div(100);
301 		Tax(_tax);
302 		return _tax;
303 	}
304 	
305 	event ClaimTokensEvent(address indexed _from, uint256 period, uint256 _tokensValue, uint256 _tokensPrice, uint256 _ethersAmount);
306     function claimTokens(uint256 _period) onlyReg returns (bool) {
307         require(periods.length > _period);
308 		
309         uint256 _ethValue = buyTokens[msg.sender][_period];
310 		
311 		ActualInfo storage info = periods[_period];
312         uint256 tokenPrice = info.price;
313         uint256 amount = (_ethValue.mul(1 ether)).div(tokenPrice);
314         gcf.mintToken(this, amount);
315 		
316 		buyTokens[msg.sender][_period] = 0;
317 				
318         ClaimTokensEvent(msg.sender, _period, _ethValue, tokenPrice, amount);
319 		
320 		return GlobalToken(gcf).transfer(msg.sender, amount);
321     }
322 	
323 	event ClaimEthersEvent(address indexed _from, uint256 period, uint256 _ethValue, uint256 _tokensPrice, uint256 _tokensAmount);
324     function claimEthers(uint256 _period) onlyReg returns (bool) {
325         require(periods.length > _period);
326 		
327         uint256 _tokensValue = sellTokens[msg.sender][_period];
328 		
329 		ActualInfo storage info = periods[_period];
330         uint256 tokenPrice = info.price;
331         uint256 amount = (_tokensValue.mul(tokenPrice)).div(1 ether);
332         gcf.burn(_tokensValue);
333         msg.sender.transfer(amount);
334 				
335         sellTokens[msg.sender][_period] = 0;
336 		
337 		ClaimEthersEvent(msg.sender, _period, _tokensValue, tokenPrice, amount);
338         
339         return true;
340     }
341 	
342 	event claimTaxex (uint256 _eth, uint256 _tokens);
343     function claimTax() onlyOwner {
344 		if(ethTax != 0) {
345 			transferEther(owner, ethTax);
346 			claimTaxex(ethTax, 0);
347 			ethTax = 0;
348 		}
349 		
350 		if(tokenTax != 0) {
351 			transferTokens(owner, tokenTax);
352 			claimTaxex(0, tokenTax);
353 			tokenTax = 0;
354 		}
355     }
356 	
357     function transferTokens(address _to, uint256 _amount) onlyOwner returns (bool) {
358         return GlobalToken(gcf).transfer(_to, _amount);
359     }
360 	
361     function transferEther(address _to, uint256 _amount) onlyOwner returns (bool) {
362 		require(_amount <= (this.balance).sub(ethTax));
363         _to.transfer(_amount);
364         return true;
365     }
366     
367     function contractVersion() constant returns(uint256) {
368         /*  contractVersion identifies as 300YYYYMMDDHHMM */
369         return 300201712010000;
370     }
371     
372     function numAccounts() returns (uint256 _numAccounts) {
373         return accounts.length;
374     }
375 	
376     function kill() onlyOwner {
377         uint256 amount = GlobalToken(gcf).balanceOf(this);
378         transferTokens(owner, amount);
379         selfdestruct(owner);
380     }
381 }
382 
383 library ConvertStringToUint {
384 	
385 	function stringToUint(string _amount) internal constant returns (uint result) {
386         bytes memory b = bytes(_amount);
387         uint i;
388         uint counterBeforeDot;
389         uint counterAfterDot;
390         result = 0;
391         uint totNum = b.length;
392         totNum--;
393         bool hasDot = false;
394         
395         for (i = 0; i < b.length; i++) {
396             uint c = uint(b[i]);
397             
398             if (c >= 48 && c <= 57) {
399                 result = result * 10 + (c - 48);
400                 counterBeforeDot ++;
401                 totNum--;
402             }
403             
404 			if(c == 46){
405 			    hasDot = true;
406 				break;
407 			}
408         }
409         
410         if(hasDot) {
411             for (uint j = counterBeforeDot + 1; j < 18; j++) {
412                 uint m = uint(b[j]);
413                 
414                 if (m >= 48 && m <= 57) {
415                     result = result * 10 + (m - 48);
416                     counterAfterDot ++;
417                     totNum--;
418                 }
419                 
420                 if(totNum == 0){
421                     break;
422                 }
423             }
424         }
425          if(counterAfterDot < 18){
426              uint addNum = 18 - counterAfterDot;
427              uint multuply = 10 ** addNum;
428              return result = result * multuply;
429          }
430          
431          return result;
432 	}
433 }
434 
435 contract UserWallet is Owned {
436 	using ConvertStringToUint for string;
437 	using SafeMath for uint256;
438 	
439     ExchangeManager fund;
440     GlobalCryptoFund public gcf;
441     
442     uint256[] public investedPeriods;
443     uint256[] public reederemPeriods;
444     
445 	mapping (uint256 => bool) isInvested;
446 	mapping (uint256 => bool) isReederem;
447 	
448     function UserWallet(address _fund, address _token) {
449         fund = ExchangeManager(_fund);
450 		require(fund.contractVersion() == 300201712010000);
451 		
452         gcf = GlobalCryptoFund(_token);
453         require(gcf.contractVersion() == 200201712010000);
454     }
455 	
456     function getPrices() onlyOwner returns (uint256 _Price) {
457 		return fund.getPrices();
458 	}
459 	
460 	function getActualPeriod() onlyOwner returns (uint256) {
461 		uint256 period = fund.getActualPeriod();
462 		return period.sub(1);
463 	}
464 	
465 	event TokensSold(uint256 recivedEthers);
466     function() payable {
467         if(msg.sender == address(fund)) {
468             TokensSold(msg.value);
469         } else {
470             deposit(msg.value);
471         }
472     }
473 	
474     function deposit(uint256 _WeiAmount) payable returns (bool) {
475         fund.transfer(_WeiAmount);
476         fund.buy(_WeiAmount);
477 		uint256 period = fund.getActualPeriod();
478 		bool _isInvested = isInvest(period);
479 		if(!_isInvested) {
480 			investedPeriods.push(period.sub(1));
481 			isInvested[period] = true;
482 		}
483         return true;
484     }
485     
486     function Reederem(string _amount) onlyOwner returns (bool) {
487 		uint256 amount = _amount.stringToUint();
488         gcf.transfer(fund, amount);
489         uint256 period = fund.getActualPeriod();
490 		bool _isReederemed = isReederemed(period);
491 		if(!_isReederemed) {
492 			reederemPeriods.push(period.sub(1));
493 			isReederem[period] = true;
494 		}
495         return fund.Reederem(amount);
496     }
497     
498     function transferTokens() onlyOwner returns (bool) {
499 		uint256 amount = GlobalToken(gcf).balanceOf(this);
500         return GlobalToken(gcf).transfer(owner, amount);
501     }
502     
503     event userWalletTransferEther(address indexed _from, address indexed _to, uint256 _ethersValue);
504     function transferEther() onlyOwner returns (bool) {
505 		uint256 amount = this.balance;
506         owner.transfer(amount);
507         userWalletTransferEther(this,owner,amount);
508         return true;
509     }
510     
511     function claimTokens() onlyOwner {
512         uint256 period;
513         for(uint256 i = 0; i < investedPeriods.length; i++) {
514             period = investedPeriods[i];
515             fund.claimTokens(period);
516         }
517         investedPeriods.length = 0;
518     }
519 
520     function claimEthers() onlyOwner {
521         uint256 period;
522         for(uint256 i = 0; i < reederemPeriods.length; i++) {
523             period = reederemPeriods[i];
524             fund.claimEthers(period);
525         }
526         reederemPeriods.length = 0;
527     }
528   
529     function contractVersion() constant returns(uint256) {
530         /*  contractVersion identifies as 400YYYYMMDDHHMM */
531         return 400201712010000;
532     }
533     
534     function kill() onlyOwner {
535 		transferTokens();
536 		transferEther();
537         selfdestruct(owner);
538     }
539 	
540 	function isInvest(uint256 _per) internal returns (bool) {
541 		return isInvested[_per];
542 	}
543 	
544 	function isReederemed(uint256 _per) internal returns (bool) {
545 		return isReederem[_per];
546 	}
547 }