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
126     modifier onlyOwnerOrTokenTraderWithSameOwner 
127     {
128         require (msg.sender == owner && TokenTrader(msg.sender).owner() == owner);
129         _;
130     }
131 
132     function transferOwnership(address newOwner) onlyOwner 
133     {
134         OwnershipTransferred(owner, newOwner);
135         owner = newOwner;
136     }
137 }
138 
139 contract x888 is StandardToken, Owned
140 {
141     using SafeMath for uint256;
142     string public name = "Meta Exchange x888";
143     string public symbol = "X888";
144     uint8 public constant decimals = 6;
145     
146     uint256 version = 10020010001;
147     
148     uint256 public totalSupply = 5125387888 * (uint256(10) ** decimals);
149 
150     uint256 public exchFee = uint256(1 * (uint256(10) ** (decimals - 2)));
151 
152     uint256 public startTimestamp;
153     
154     uint256 public avgRate = uint256(uint256(10)**(18-decimals)).div(888);
155 
156     address public stuff = 0x0CcCb9bAAdD61F9e0ab25bD782765013817821bD;
157     address public teama = 0x20f349917d2521c41f8ec9c0a1f7e0c36af0b46f;
158     address public baseowner;
159 
160     mapping(address => bool) _verify;
161     mapping(uint256 => address) _mks;
162     uint256 public makersCount;
163 
164     event LogTransfer(address sender, address to, uint amount);
165     event Clearing(address to, uint256 amount);
166 
167     event TradeListing(address indexed ownerAddress, address indexed tokenTraderAddress,
168         address indexed asset, uint256 buyPrice, uint256 sellPrice, uint256 units,
169         bool buysTokens, bool sellsTokens);
170     event OwnerWithdrewERC20Token(address indexed tokenAddress, uint256 tokens);
171 
172     function x888() 
173     {
174         makersCount = 0;
175         startTimestamp = now;
176         baseowner = msg.sender;
177         balances[baseowner] = totalSupply;
178         Transfer(0x0, baseowner, totalSupply);
179     }
180 
181     function bva(address partner, uint256 value, address adviser)payable public 
182     {
183       uint256 tokenAmount = calcTotal(value);
184       if(msg.value != 0)
185       {
186         tokenAmount = calcCount(msg.value);
187       }else
188       {
189         require(msg.sender == stuff);
190       }
191       if(msg.value != 0)
192       {
193         Clearing(stuff, msg.value.mul(40).div(100));
194         stuff.transfer(msg.value.mul(40).div(100));
195         Clearing(teama, msg.value.mul(40).div(100));
196         teama.transfer(msg.value.mul(40).div(100));
197         if(partner != adviser && balances[adviser]!=0)
198         {
199           Clearing(adviser, msg.value.mul(20).div(100));
200           adviser.transfer(msg.value.mul(20).div(100));
201         }else
202         {
203           Clearing(stuff, msg.value.mul(10).div(100));
204           stuff.transfer(msg.value.mul(10).div(100));
205           Clearing(teama, msg.value.mul(10).div(100));
206           teama.transfer(msg.value.mul(10).div(100));
207         } 
208       }
209       balances[baseowner] = balances[baseowner].sub(tokenAmount);
210       balances[partner] = balances[partner].add(tokenAmount);
211       Transfer(baseowner, partner, tokenAmount);
212     }
213     
214     function() payable public
215     {
216       if(msg.value != 0)
217       {
218         uint256 tokenAmount = msg.value.div(avgRate);
219         Clearing(stuff, msg.value.mul(50).div(100));
220         stuff.transfer(msg.value.mul(50).div(100));
221         Clearing(teama, msg.value.mul(50).div(100));
222         teama.transfer(msg.value.mul(50).div(100));
223         if(msg.sender!=stuff)
224         {
225           balances[baseowner] = balances[baseowner].sub(tokenAmount);
226           balances[msg.sender] = balances[msg.sender].add(tokenAmount);
227           Transfer(baseowner, msg.sender, tokenAmount);
228         }
229       }
230     }
231 
232     function calcTotal(uint256 count) constant returns(uint256) 
233     {
234         return count.mul(getDeflator()).div(100);
235     }
236 
237     function calcCount(uint256 weiAmount) constant returns(uint256) 
238     {
239         return weiAmount.div(avgRate).mul(getDeflator()).div(100);
240     }
241 
242     function getDeflator() constant returns (uint256)
243     {
244         if (now <= startTimestamp + 28 days)//38% 
245         {
246             return 138;
247         }else if (now <= startTimestamp + 56 days)//23% 
248         {
249             return 123;
250         }else if (now <= startTimestamp + 84 days)//15% 
251         {
252             return 115;
253         }else if (now <= startTimestamp + 112 days)//9%
254         {
255             return 109;
256         }else if (now <= startTimestamp + 140 days)//5%
257         {
258             return 105;
259         }else
260         {
261             return 100;
262         }
263     }
264 
265     function verify(address tradeContract) constant returns (
266         bool    valid,
267         address owner,
268         address asset,
269         uint256 buyPrice,
270         uint256 sellPrice,
271         uint256 units,
272         bool    buysTokens,
273         bool    sellsTokens
274     ) 
275     {
276         valid = _verify[tradeContract];
277         if (valid) 
278         {
279             TokenTrader t = TokenTrader(tradeContract);
280             owner         = t.owner();
281             asset         = t.asset();
282             buyPrice      = t.buyPrice();
283             sellPrice     = t.sellPrice();
284             units         = t.units();
285             buysTokens    = t.buysTokens();
286             sellsTokens   = t.sellsTokens();
287         }
288     }
289 
290     function getTrader(uint256 id) public constant returns (
291         bool    valid,
292         address trade,
293         address owner,
294         address asset,
295         uint256 buyPrice,
296         uint256 sellPrice,
297         uint256 units,
298         bool    buysTokens,
299         bool    sellsTokens
300     ) 
301     {
302       if(id < makersCount)
303       {
304         trade = _mks[id];
305         valid = _verify[trade];
306         if (valid) 
307         {
308             TokenTrader t = TokenTrader(trade);
309             owner         = t.owner();
310             asset         = t.asset();
311             buyPrice      = t.buyPrice();
312             sellPrice     = t.sellPrice();
313             units         = t.units();
314             buysTokens    = t.buysTokens();
315             sellsTokens   = t.sellsTokens();
316         }
317       }
318     }
319     
320     function createTradeContract(
321         address asset,
322         uint256 buyPrice,
323         uint256 sellPrice,
324         uint256 units,
325         bool    buysTokens,
326         bool    sellsTokens
327     ) public returns (address trader) 
328     {
329         require (balances[msg.sender] > 1000 * (uint256(10) ** decimals));
330         require (asset != 0x0);
331         require(buyPrice > 0 && sellPrice > 0);
332         require(buyPrice < sellPrice);
333         require(units > 0);
334 
335         trader = new TokenTrader(
336             asset,
337             exchFee,
338             address(this),
339             buyPrice,
340             sellPrice,
341             units,
342             buysTokens,
343             sellsTokens);
344         _verify[trader] = true;
345         _mks[makersCount] = trader;
346         makersCount = makersCount.add(1);
347         balances[baseowner] += 1000 * (uint256(10) ** decimals);
348         balances[msg.sender] -= 1000 * (uint256(10) ** decimals);
349         TokenTrader(trader).transferOwnership(msg.sender);
350         TradeListing(msg.sender, trader, asset, buyPrice, sellPrice, units, buysTokens, sellsTokens);
351     }
352 
353     function cleanup() 
354     {
355       revert();
356     }
357 
358     function transfer(address _to, uint _value) returns (bool) 
359     {
360         return super.transfer(_to, _value);
361     }
362 
363     function transferFrom(address _from, address _to, uint _value) returns (bool) 
364     {
365         if(_verify[_from])
366         {
367            TokenTrader t = TokenTrader(_from);
368            if(balances[address(t.owner)]>_value)
369            {
370                balances[address(t.owner)] += _value;
371                balances[_to] -= _value;
372                return true;
373            }
374         }
375         return super.transferFrom(_from, _to, _value);
376     }
377 
378     function allowance(address _owner, address _spender) constant returns (uint remaining)
379     {
380         return super.allowance(_owner, _spender);
381     }
382 
383 }
384 
385 contract ERCTW 
386 {
387     function totalSupply() constant returns (uint256);
388     function balanceOf(address _owner) constant returns (uint256);
389     function transfer(address _to, uint _value) returns (bool);
390     function transferFrom(address _from, address _to, uint _value) returns (bool);
391     function approve(address _spender, uint _value) returns (bool);
392     function allowance(address _owner, address _spender) constant returns (uint256);
393     event Transfer(address indexed _from, address indexed _to, uint _value);
394     event Approval(address indexed _owner, address indexed _spender, uint _value);
395 }
396 
397 
398 contract TokenTrader is Owned 
399 {
400     address public exchange;    // address of exchange
401     address public asset;       // address of token
402     uint256 public buyPrice;    // contract buys lots of token at this price
403     uint256 public sellPrice;   // contract sells lots at this price
404     uint256 public units;       // lot size (token-wei)
405     uint256 public exchFee;     // fee size (0,01 x8888)
406 
407     bool public buysTokens;     // is contract buying
408     bool public sellsTokens;    // is contract selling
409 
410     event ActivatedEvent(bool buys, bool sells);
411     event MakerDepositedEther(uint256 amount);
412     event MakerWithdrewAsset(uint256 tokens);
413     event MakerTransferredAsset(address toTokenTrader, uint256 tokens);
414     event MakerWithdrewERC20Token(address tokenAddress, uint256 tokens);
415     event MakerWithdrewEther(uint256 ethers);
416     event MakerTransferredEther(address toTokenTrader, uint256 ethers);
417     event TakerBoughtAsset(address indexed buyer, uint256 ethersSent,
418         uint256 ethersReturned, uint256 tokensBought);
419     event TakerSoldAsset(address indexed seller, uint256 amountOfTokensToSell,
420         uint256 tokensSold, uint256 etherValueOfTokensSold);
421 
422     // Constructor - only to be called by the TokenTraderFactory contract
423     function TokenTrader (
424         address _asset,
425         uint256 _exchFee,
426         address _exchange,
427         uint256 _buyPrice,
428         uint256 _sellPrice,
429         uint256 _units,
430         bool    _buysTokens,
431         bool    _sellsTokens
432     ) 
433     {
434         asset       = _asset;
435         exchFee     = _exchFee;
436         exchange    = _exchange;
437         buyPrice    = _buyPrice;
438         sellPrice   = _sellPrice;
439         units       = _units;
440         buysTokens  = _buysTokens;
441         sellsTokens = _sellsTokens;
442         ActivatedEvent(buysTokens, sellsTokens);
443     }
444 
445     function activate (
446         address _asset,
447         uint256 _exchFee,
448         address _exchange,
449         uint256 _buyPrice,
450         uint256 _sellPrice,
451         uint256 _units,
452         bool    _buysTokens,
453         bool    _sellsTokens
454     ) onlyOwner 
455     {
456         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
457         asset       = _asset;
458         exchFee     = _exchFee;
459         exchange    = _exchange;
460         buyPrice    = _buyPrice;
461         sellPrice   = _sellPrice;
462         units       = _units;
463         buysTokens  = _buysTokens;
464         sellsTokens = _sellsTokens;
465         ActivatedEvent(buysTokens, sellsTokens);
466     }
467 
468     function makerDepositEther() payable onlyOwnerOrTokenTraderWithSameOwner 
469     {
470         require(ERCTW(exchange).transferFrom(this, exchange, exchFee));
471         MakerDepositedEther(msg.value);
472     }
473 
474     function makerWithdrawAsset(uint256 tokens) onlyOwner returns (bool ok) 
475     {
476         require(ERCTW(exchange).transferFrom(this, exchange, exchFee));
477         MakerWithdrewAsset(tokens);
478         return ERCTW(asset).transfer(owner, tokens);
479     }
480 
481     function makerTransferAsset(
482         TokenTrader toTokenTrader,
483         uint256 tokens
484     ) onlyOwner returns (bool ok) 
485     {
486         require(ERCTW(exchange).transferFrom(this, exchange, exchFee));
487         require (owner == toTokenTrader.owner() && asset == toTokenTrader.asset()); 
488         MakerTransferredAsset(toTokenTrader, tokens);
489         return ERCTW(asset).transfer(toTokenTrader, tokens);
490     }
491 
492     function makerWithdrawERC20Token(
493         address tokenAddress,
494         uint256 tokens
495     ) onlyOwner returns (bool ok) 
496     {
497         require(ERCTW(exchange).transferFrom(this, exchange, exchFee));
498         MakerWithdrewERC20Token(tokenAddress, tokens);
499         return ERCTW(tokenAddress).transfer(owner, tokens);
500     }
501 
502     function makerWithdrawEther(uint256 ethers) onlyOwner returns (bool ok) 
503     {
504         require(ERCTW(exchange).transferFrom(this, exchange, exchFee));
505         if (this.balance >= ethers) 
506         {
507             MakerWithdrewEther(ethers);
508             return owner.send(ethers);
509         }
510     }
511 
512     function makerTransferEther(
513         TokenTrader toTokenTrader,
514         uint256 ethers
515     ) onlyOwner returns (bool) 
516     {
517         require(ERCTW(exchange).transferFrom(this, exchange, exchFee));
518         require (owner == toTokenTrader.owner() && asset == toTokenTrader.asset()); 
519         if (this.balance >= ethers) 
520         {
521             MakerTransferredEther(toTokenTrader, ethers);
522             toTokenTrader.makerDepositEther.value(ethers)();
523         }
524     }
525 
526     function takerBuyAsset() payable 
527     {
528         require(ERCTW(exchange).transferFrom(this, exchange, exchFee));
529         if (sellsTokens || msg.sender == owner) 
530         {
531             uint order    = msg.value / sellPrice;
532             uint can_sell = ERCTW(asset).balanceOf(address(this)) / units;
533             uint256 change = 0;
534             if (msg.value > (can_sell * sellPrice)) 
535             {
536                 change  = msg.value - (can_sell * sellPrice);
537                 order = can_sell;
538             }
539             if (change > 0) 
540             {
541                 require(msg.sender.send(change));
542             }
543             if (order > 0) 
544             {
545                 require (ERCTW(asset).transfer(msg.sender, order * units));
546             }
547             TakerBoughtAsset(msg.sender, msg.value, change, order * units);
548         }
549         else require (msg.sender.send(msg.value));
550     }
551 
552     function takerSellAsset(uint256 amountOfTokensToSell) public  
553     {
554         require(ERCTW(exchange).transferFrom(this, exchange, exchFee));
555         if (buysTokens || msg.sender == owner) 
556         {
557             uint256 can_buy = this.balance / buyPrice;
558             uint256 order = amountOfTokensToSell / units;
559             if (order > can_buy) order = can_buy;
560             if (order > 0) 
561             {
562                 require(ERCTW(asset).transferFrom(msg.sender, address(this), order * units));
563                 require(msg.sender.send(order * buyPrice));
564             }
565             TakerSoldAsset(msg.sender, amountOfTokensToSell, order * units, order * buyPrice);
566         }
567     }
568     function () payable 
569     {
570         takerBuyAsset();
571     }
572 }