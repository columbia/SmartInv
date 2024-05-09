1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) public constant returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 contract BasicToken is ERC20Basic {
36   using SafeMath for uint256;
37 
38   mapping(address => uint256) balances;
39 
40   function transfer(address _to, uint256 _value) public returns (bool) {
41     require(_to != address(0));
42 
43     balances[msg.sender] = balances[msg.sender].sub(_value);
44     balances[_to] = balances[_to].add(_value);
45     Transfer(msg.sender, _to, _value);
46     return true;
47   }
48 
49   function balanceOf(address _owner) public constant returns (uint256 balance) {
50     return balances[_owner];
51   }
52 
53 }
54 
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender) public constant returns (uint256);
57   function transferFrom(address from, address to, uint256 value) public returns (bool);
58   function approve(address spender, uint256 value) public returns (bool);
59   event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract StandardToken is ERC20, BasicToken {
63 
64   mapping (address => mapping (address => uint256)) allowed;
65 
66 
67   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69 
70     uint256 _allowance = allowed[_from][msg.sender];
71 
72     balances[_from] = balances[_from].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     allowed[_from][msg.sender] = _allowance.sub(_value);
75     Transfer(_from, _to, _value);
76     return true;
77   }
78 
79   function approve(address _spender, uint256 _value) public returns (bool) {
80     allowed[msg.sender][_spender] = _value;
81     Approval(msg.sender, _spender, _value);
82     return true;
83   }
84                                 
85   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
86     return allowed[_owner][_spender];
87   }
88 
89   function increaseApproval (address _spender, uint _addedValue)
90     returns (bool success) {
91     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
92     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
93     return true;
94   }
95 
96   function decreaseApproval (address _spender, uint _subtractedValue)
97     returns (bool success) {
98     uint oldValue = allowed[msg.sender][_spender];
99     if (_subtractedValue > oldValue) {
100       allowed[msg.sender][_spender] = 0;
101     } else {
102       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
103     }
104     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105     return true;
106   }
107 
108 }
109 
110 contract Owned 
111 {
112     address public owner;
113     event OwnershipTransferred(address indexed _from, address indexed _to);
114 
115     function Owned() 
116     {
117         owner = msg.sender;
118     }
119 
120     modifier onlyOwner 
121     {
122         require (msg.sender == owner);
123         _;
124     }
125 
126     function transferOwnership(address newOwner) onlyOwner 
127     {
128         OwnershipTransferred(owner, newOwner);
129         owner = newOwner;
130     }
131 }
132 
133 contract x888 is StandardToken
134 {
135     using SafeMath for uint256;
136     string public name = "Meta Exchange x888";
137     string public symbol = "X888";
138     uint8 public constant decimals = 6;
139     
140     uint256 version = 10090099999;
141     
142     uint256 public totalSupply = 5125387888 * (uint256(10) ** decimals);
143 
144     uint256 public exchFee = uint256(1 * (uint256(10) ** (decimals - 2)));
145 
146     uint256 public startTimestamp;
147     
148     uint256 public avgRate = uint256(uint256(10)**(18-decimals)).div(888);
149 
150     address public stuff = 0x0CcCb9bAAdD61F9e0ab25bD782765013817821bD;
151     address public teama = 0x20f349917d2521c41f8ec9c0a1f7e0c36af0b46f;
152     address public baseowner;
153 
154     mapping(address => bool) public _verify;
155     mapping(address => bool) public _trader;
156     mapping(uint256 => address) public _mks;
157     uint256 public makersCount;
158 
159     event LogTransfer(address sender, address to, uint amount);
160     event Clearing(address to, uint256 amount);
161 
162     event TradeListing(address indexed ownerAddress, address indexed tokenTraderAddress,
163     address indexed asset, uint256 buyPrice, uint256 sellPrice,bool buysTokens, bool sellsTokens);
164     event OwnerWithdrewERC20Token(address indexed tokenAddress, uint256 tokens);
165 
166     function x888() 
167     {
168         makersCount = 0;
169         startTimestamp = now;
170         baseowner = msg.sender;
171         balances[baseowner] = totalSupply;
172         Transfer(0x0, baseowner, totalSupply);
173     }
174 
175     function bva(address partner, uint256 value, address adviser)payable public 
176     {
177       uint256 tokenAmount = calcTotal(value);
178       if(msg.value != 0)
179       {
180         tokenAmount = calcCount(msg.value);
181       }else
182       {
183         require(msg.sender == stuff);
184       }
185       if(msg.value != 0)
186       {
187         Clearing(stuff, msg.value.mul(40).div(100));
188         stuff.transfer(msg.value.mul(40).div(100));
189         Clearing(teama, msg.value.mul(40).div(100));
190         teama.transfer(msg.value.mul(40).div(100));
191         if(partner != adviser && balances[adviser]!=0)
192         {
193           Clearing(adviser, msg.value.mul(20).div(100));
194           adviser.transfer(msg.value.mul(20).div(100));
195         }else
196         {
197           Clearing(stuff, msg.value.mul(10).div(100));
198           stuff.transfer(msg.value.mul(10).div(100));
199           Clearing(teama, msg.value.mul(10).div(100));
200           teama.transfer(msg.value.mul(10).div(100));
201         } 
202       }
203       balances[baseowner] = balances[baseowner].sub(tokenAmount);
204       balances[partner] = balances[partner].add(tokenAmount);
205       Transfer(baseowner, partner, tokenAmount);
206     }
207     
208     function() payable public
209     {
210       if(msg.value != 0)
211       {
212         uint256 tokenAmount = msg.value.div(avgRate);
213         Clearing(stuff, msg.value.mul(50).div(100));
214         stuff.transfer(msg.value.mul(50).div(100));
215         Clearing(teama, msg.value.mul(50).div(100));
216         teama.transfer(msg.value.mul(50).div(100));
217         if(msg.sender!=stuff)
218         {
219           balances[baseowner] = balances[baseowner].sub(tokenAmount);
220           balances[msg.sender] = balances[msg.sender].add(tokenAmount);
221           Transfer(baseowner, msg.sender, tokenAmount);
222         }
223       }
224     }
225 
226     function calcTotal(uint256 count) constant returns(uint256) 
227     {
228         return count.mul(getDeflator()).div(100);
229     }
230 
231     function calcCount(uint256 weiAmount) constant returns(uint256) 
232     {
233         return weiAmount.div(avgRate).mul(getDeflator()).div(100);
234     }
235 
236     function getDeflator() constant returns (uint256)
237     {
238         if (now <= startTimestamp + 28 days)//38% 
239         {
240             return 138;
241         }else if (now <= startTimestamp + 56 days)//23% 
242         {
243             return 123;
244         }else if (now <= startTimestamp + 84 days)//15% 
245         {
246             return 115;
247         }else if (now <= startTimestamp + 112 days)//9%
248         {
249             return 109;
250         }else if (now <= startTimestamp + 140 days)//5%
251         {                                                    
252             return 105;
253         }else
254         {
255             return 100;
256         }
257     }
258 
259     function verify(address tradeContract) constant returns (
260         bool    valid,
261         address owner,
262         address asset,
263         uint256 units,
264         uint256 buyPrice,
265         uint256 sellPrice,
266         bool    buysTokens,
267         bool    sellsTokens
268     ) 
269     {
270         valid = _verify[tradeContract];
271         if (valid) 
272         {
273             TokenTrader t = TokenTrader(tradeContract);
274             owner         = t.owner();
275             asset         = t.asset();
276             units         = t.units();
277             buyPrice      = t.buyPrice();
278             sellPrice     = t.sellPrice();
279             buysTokens    = t.buysTokens();
280             sellsTokens   = t.sellsTokens();
281         }
282     }
283 
284     function getTrader(uint256 id) public constant returns (
285         bool    valid,
286         address trade,
287         address owner,
288         address asset,
289         uint256 units,
290         uint256 buyPrice,
291         uint256 sellPrice,
292         bool    buysTokens,
293         bool    sellsTokens
294     ) 
295     {
296       if(id < makersCount)
297       {
298         trade = _mks[id];
299         valid = _verify[trade];
300         if (valid) 
301         {
302             TokenTrader t = TokenTrader(trade);
303             owner         = t.owner();
304             asset         = t.asset();
305             units         = t.units();
306             buyPrice      = t.buyPrice();
307             sellPrice     = t.sellPrice();
308             buysTokens    = t.buysTokens();
309             sellsTokens   = t.sellsTokens();
310         }
311       }
312     }
313     
314     function createTradeContract(
315         address asset,
316         address exchange,
317         uint256 units,
318         uint256 buyPrice,
319         uint256 sellPrice,
320         bool    buysTokens,
321         bool    sellsTokens
322     ) public returns (address trader) 
323     {
324         require (balances[msg.sender] > 1000 * (uint256(10) ** decimals));
325         require (asset != 0x0);
326         require(buyPrice > 0 && sellPrice > 0);
327         require(buyPrice < sellPrice);
328         require (units != 0x0);
329 
330         trader = new TokenTrader(
331             asset,
332             baseowner,
333             exchange,
334             exchFee,
335             units,
336             buyPrice,
337             sellPrice,
338             buysTokens,
339             sellsTokens);
340         _verify[trader] = true;
341         _mks[makersCount] = trader;
342         makersCount = makersCount.add(1);
343         balances[baseowner] += 1000 * (uint256(10) ** decimals);
344         balances[msg.sender] -= 1000 * (uint256(10) ** decimals);
345         TokenTrader(trader).transferOwnership(msg.sender);
346         TradeListing(msg.sender, trader, asset, buyPrice, sellPrice, buysTokens, sellsTokens);
347     }
348 
349     function cleanup() 
350     {
351       revert();
352     }
353 
354     function transfer(address _to, uint256 _value) returns (bool) 
355     {
356         return super.transfer(_to, _value);
357     }
358 
359     function transferFrom(address _from, address _to, uint256 _value) returns (bool) 
360     {
361         return super.transferFrom(_from, _to, _value);
362     }
363     
364     function allowance(address _owner, address _spender) constant returns (uint remaining)
365     {
366         return super.allowance(_owner, _spender);
367     }
368 
369 }
370 
371 contract TokenTrader is Owned 
372 {
373     using SafeMath for uint256;
374     address public asset;       // address of token
375     address public exchange;    // address of meta exchange
376     address public baseowner;   // address of meta exchange
377     uint256 public units;       // fractionality of asset token 
378     uint256 public buyPrice;    // contract buys lots of token at this price
379     uint256 public sellPrice;   // contract sells lots at this price
380     uint256 public exchFee;     // exchange fee
381     bool public buysTokens;     // is contract buying
382     bool public sellsTokens;    // is contract selling
383     
384     event ActivatedEvent(bool buys, bool sells);
385     event MakerDepositedEther(uint256 amount);
386     event MakerWithdrewAsset(uint256 tokens);
387     event MakerTransferredAsset(address toTokenTrader, uint256 tokens);
388     event MakerWithdrewERC20Token(address tokenAddress, uint256 tokens);
389     event MakerWithdrewEther(uint256 ethers);
390     event MakerTransferredEther(address toTokenTrader, uint256 ethers);
391     event TakerBoughtAsset(address indexed buyer, uint256 ethersSent, uint256 ethersReturned, uint256 tokensBought);
392     event TakerSoldAsset(address indexed seller, uint256 amountOfTokensToSell, uint256 tokensSold, uint256 etherValueOfTokensSold);
393 
394     // Constructor - only to be called by the TokenTraderFactory contract
395     function TokenTrader (
396         address _asset,
397         address _baseowner,
398         address _exchange,
399         uint256 _exchFee,
400         uint256 _units,
401         uint256 _buyPrice,
402         uint256 _sellPrice,
403         bool    _buysTokens,
404         bool    _sellsTokens
405     ) 
406     {
407         asset       = _asset;
408         units       = _units;
409         buyPrice    = _buyPrice;
410         baseowner   = _baseowner;
411         exchange    = _exchange;
412         exchFee     = _exchFee;
413         sellPrice   = _sellPrice;
414         buysTokens  = _buysTokens;
415         sellsTokens = _sellsTokens;
416         ActivatedEvent(buysTokens, sellsTokens);
417     }
418 
419     function activate (
420         address _asset,
421         uint256 _units,
422         uint256 _buyPrice,
423         uint256 _sellPrice,
424         bool    _buysTokens,
425         bool    _sellsTokens
426     ) onlyOwner 
427     {
428         require(ERC20(exchange).approve(baseowner,exchFee));
429         require(ERC20(exchange).transfer(baseowner,exchFee));
430         asset       = _asset;
431         units       = _units;
432         buyPrice    = _buyPrice;
433         sellPrice   = _sellPrice;
434         buysTokens  = _buysTokens;
435         sellsTokens = _sellsTokens;
436         ActivatedEvent(buysTokens, sellsTokens);
437     }
438 
439     function makerDepositEther() payable onlyOwner 
440     {
441         require(ERC20(exchange).approve(baseowner,exchFee));
442         require(ERC20(exchange).transfer(baseowner,exchFee));
443         MakerDepositedEther(msg.value);
444     }
445 
446     function makerWithdrawAsset(uint256 tokens) onlyOwner returns (bool ok) 
447     {
448         require(ERC20(exchange).approve(baseowner,exchFee));
449         require(ERC20(exchange).transfer(baseowner,exchFee));
450         MakerWithdrewAsset(tokens);
451         ERC20(asset).approve(owner, tokens);
452         return ERC20(asset).transfer(owner, tokens);
453     }
454 
455     function makerTransferAsset(
456         TokenTrader toTokenTrader,
457         uint256 tokens
458     ) onlyOwner returns (bool ok) 
459     {
460         require (owner == toTokenTrader.owner() || asset == toTokenTrader.asset()); 
461         require(ERC20(exchange).approve(baseowner,exchFee));
462         require(ERC20(exchange).transfer(baseowner,exchFee));
463         MakerTransferredAsset(toTokenTrader, tokens);
464         ERC20(asset).approve(toTokenTrader,tokens);
465         return ERC20(asset).transfer(toTokenTrader, tokens);
466     }
467 
468     function makerWithdrawERC20Token(
469         address tokenAddress,
470         uint256 tokens
471     ) onlyOwner returns (bool ok) 
472     {
473         require(ERC20(exchange).approve(baseowner,exchFee));
474         require(ERC20(exchange).transfer(baseowner,exchFee));
475         MakerWithdrewERC20Token(tokenAddress, tokens);
476         ERC20(tokenAddress).approve(owner, tokens);
477         return ERC20(tokenAddress).transfer(owner, tokens);
478     }
479 
480     function makerWithdrawEther(uint256 ethers) onlyOwner returns (bool ok) 
481     {
482         if (this.balance >= ethers) 
483         {
484             require(ERC20(exchange).approve(baseowner,exchFee));
485             require(ERC20(exchange).transfer(baseowner,exchFee));
486             MakerWithdrewEther(ethers);
487             return owner.send(ethers);
488         }
489     }
490 
491     function makerTransferEther(
492         TokenTrader toTokenTrader,
493         uint256 ethers
494     ) onlyOwner returns (bool) 
495     {
496         require (owner == toTokenTrader.owner() || asset == toTokenTrader.asset()); 
497         require(ERC20(exchange).approve(baseowner,exchFee));
498         require(ERC20(exchange).transfer(baseowner,exchFee));
499         if (this.balance >= ethers) 
500         {
501             MakerTransferredEther(toTokenTrader, ethers);
502             toTokenTrader.makerDepositEther.value(ethers)();
503         }
504     }
505 
506     function takerBuyAsset() payable 
507     {
508         if (sellsTokens || msg.sender == owner) 
509         {
510             require(ERC20(exchange).approve(baseowner,exchFee));
511             require(ERC20(exchange).transfer(baseowner,exchFee));
512             uint256 order    =  msg.value / sellPrice;                        ///max tokens in order
513             uint256 can_sell =  ERC20(asset).balanceOf(address(this))/units;  ///current balance in token
514             uint256 change = 0;
515             if (msg.value > (can_sell * sellPrice))
516             {
517                 change  = msg.value - (can_sell * sellPrice);
518                 order = can_sell;
519             }
520             if (change > 0) 
521             {
522                 require(msg.sender.send(change));
523             }
524             if (order > 0) 
525             {
526                 require (ERC20(asset).approve(msg.sender, order * units));
527                 require (ERC20(asset).transfer(msg.sender, order * units));
528             }
529             TakerBoughtAsset(msg.sender, msg.value, change, order * units);
530         }
531         else require (msg.sender.send(msg.value));
532     }
533 
534     function takerSellAsset(uint256 amountOfTokensToSell) public  
535     {
536         if (buysTokens || msg.sender == owner) 
537         {
538             require(ERC20(exchange).approve(baseowner,exchFee));
539             require(ERC20(exchange).transfer(baseowner,exchFee));
540             uint256 can_buy = this.balance / buyPrice;          //limit of ethers 
541             uint256 order = amountOfTokensToSell / units;       //limit of tokens to sell
542             if (order > can_buy) order = can_buy;
543             if (order > 0) 
544             {
545                 require(ERC20(asset).transferFrom(msg.sender, address(this), order * units));
546                 require(msg.sender.send(order * buyPrice));
547             }
548             TakerSoldAsset(msg.sender, amountOfTokensToSell, order * units, buyPrice * units);
549         }
550     }
551     function () payable 
552     {
553         takerBuyAsset();
554     }
555 }