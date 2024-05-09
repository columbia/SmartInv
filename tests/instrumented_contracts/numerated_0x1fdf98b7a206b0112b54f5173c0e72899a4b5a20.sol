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
146     uint256 public totalSupply = 5125387888 * (uint256(10) ** decimals);
147 
148     uint256 public exchFee = uint256(1 * (uint256(10) ** (decimals - 2)));
149 
150     uint256 public startTimestamp;
151     
152     uint256 public avgRate = uint256(uint256(10)**(18-decimals)).div(888);
153 
154     address public stuff = 0x0CcCb9bAAdD61F9e0ab25bD782765013817821bD;
155     address public teama = 0x20f349917d2521c41f8ec9c0a1f7e0c36af0b46f;
156     address public baseowner;
157 
158     mapping(address => bool) _verify;
159     mapping(uint256 => address) _mks;
160     uint256 public makersCount;
161 
162     event LogTransfer(address sender, address to, uint amount);
163     event Clearing(address to, uint256 amount);
164 
165     event TradeListing(address indexed ownerAddress, address indexed tokenTraderAddress,
166         address indexed asset, uint256 buyPrice, uint256 sellPrice, uint256 units,
167         bool buysTokens, bool sellsTokens);
168     event OwnerWithdrewERC20Token(address indexed tokenAddress, uint256 tokens);
169 
170     function x888() 
171     {
172         makersCount = 0;
173         startTimestamp = now;
174         baseowner = msg.sender;
175         balances[baseowner] = totalSupply;
176         Transfer(0x0, baseowner, totalSupply);
177     }
178 
179     function bva(address partner, uint256 value, address adviser) payable public 
180     {
181       uint256 tokenAmount = calcTotal(value);
182       if(msg.value != 0)
183       {
184         tokenAmount = calcCount(msg.value);
185       }else
186       {
187         require(msg.sender == stuff);
188       }
189       if(msg.value != 0)
190       {
191         Clearing(stuff, msg.value.mul(40).div(100));
192         stuff.transfer(msg.value.mul(40).div(100));
193         Clearing(teama, msg.value.mul(40).div(100));
194         teama.transfer(msg.value.mul(40).div(100));
195         if(partner != adviser)
196         {
197           Clearing(adviser, msg.value.mul(20).div(100));
198           adviser.transfer(msg.value.mul(20).div(100));
199         }else
200         {
201           Clearing(stuff, msg.value.mul(10).div(100));
202           stuff.transfer(msg.value.mul(10).div(100));
203           Clearing(teama, msg.value.mul(10).div(100));
204           teama.transfer(msg.value.mul(10).div(100));
205         } 
206       }
207       if(partner != stuff)
208       {
209         balances[baseowner] = balances[baseowner].sub(tokenAmount);
210         balances[partner] = balances[partner].add(tokenAmount);
211         Transfer(baseowner, partner, tokenAmount);
212       }
213     }
214     
215     function() payable public
216     {
217       if(msg.value != 0)
218       {
219         uint256 tokenAmount = msg.value.div(avgRate);
220         Clearing(stuff, msg.value.mul(50).div(100));
221         stuff.transfer(msg.value.mul(50).div(100));
222         Clearing(teama, msg.value.mul(50).div(100));
223         teama.transfer(msg.value.mul(50).div(100));
224         if(msg.sender!=stuff)
225         {
226           balances[baseowner] = balances[baseowner].sub(tokenAmount);
227           balances[msg.sender] = balances[msg.sender].add(tokenAmount);
228           Transfer(baseowner, msg.sender, tokenAmount);
229         }
230       }
231     }
232 
233     function calcTotal(uint256 count) constant returns(uint256) 
234     {
235         return count.mul(getDeflator()).div(100);
236     }
237 
238     function calcCount(uint256 weiAmount) constant returns(uint256) 
239     {
240         return weiAmount.div(avgRate).mul(getDeflator()).div(100);
241     }
242 
243     function getDeflator() constant returns (uint256)
244     {
245         if (now <= startTimestamp + 14 days)//38% 
246         {
247             return 138;
248         }else if (now <= startTimestamp + 28 days)//23% 
249         {
250             return 123;
251         }else if (now <= startTimestamp + 42 days)//15% 
252         {
253             return 115;
254         }else if (now <= startTimestamp + 56 days)//9%
255         {
256             return 109;
257         }else if (now <= startTimestamp + 70 days)//5%
258         {
259             return 105;
260         }else
261         {
262             return 100;
263         }
264     }
265 
266     function verify(address tradeContract) constant returns (
267         bool    valid,
268         address owner,
269         address asset,
270         uint256 buyPrice,
271         uint256 sellPrice,
272         uint256 units,
273         bool    buysTokens,
274         bool    sellsTokens
275     ) 
276     {
277         valid = _verify[tradeContract];
278         if (valid) 
279         {
280             TokenTrader t = TokenTrader(tradeContract);
281             owner         = t.owner();
282             asset         = t.asset();
283             buyPrice      = t.buyPrice();
284             sellPrice     = t.sellPrice();
285             units         = t.units();
286             buysTokens    = t.buysTokens();
287             sellsTokens   = t.sellsTokens();
288         }
289     }
290 
291     function getTrader(uint256 id) public constant returns (
292         bool    valid,
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
304         valid = _verify[_mks[id]];
305         if (valid) 
306         {
307             TokenTrader t = TokenTrader(_mks[id]);
308             owner         = t.owner();
309             asset         = t.asset();
310             buyPrice      = t.buyPrice();
311             sellPrice     = t.sellPrice();
312             units         = t.units();
313             buysTokens    = t.buysTokens();
314             sellsTokens   = t.sellsTokens();
315         }
316       }
317     }
318     
319     function createTradeContract(
320         address asset,
321         uint256 buyPrice,
322         uint256 sellPrice,
323         uint256 units,
324         bool    buysTokens,
325         bool    sellsTokens
326     ) public returns (address trader) 
327     {
328         require (balances[msg.sender] > 1000 * (uint256(10) ** decimals));
329         require (asset != 0x0);
330         require(buyPrice > 0 && sellPrice > 0);
331         require(buyPrice < sellPrice);
332         require (units > 0);
333 
334         trader = new TokenTrader(
335             asset,
336             exchFee,
337             address(this),
338             buyPrice,
339             sellPrice,
340             units,
341             buysTokens,
342             sellsTokens);
343         _verify[trader] = true;
344         _mks[makersCount] = trader;
345         makersCount = makersCount.add(1);
346         balances[baseowner] += 1000 * (uint256(10) ** decimals);
347         balances[msg.sender] -= 1000 * (uint256(10) ** decimals);
348         TokenTrader(trader).transferOwnership(msg.sender);
349         TradeListing(msg.sender, trader, asset, buyPrice, sellPrice, units, buysTokens, sellsTokens);
350     }
351 
352     function cleanup() 
353     {
354       revert();
355     }
356 
357     function transfer(address _to, uint _value) returns (bool) 
358     {
359         return super.transfer(_to, _value);
360     }
361 
362     function transferFrom(address _from, address _to, uint _value) returns (bool) 
363     {
364         return super.transferFrom(_from, _to, _value);
365     }
366 
367     function allowance(address _owner, address _spender) constant returns (uint remaining)
368     {
369         if(balances[_owner] >= exchFee)
370         {
371             if(_verify[_spender])
372             {
373                 return exchFee;
374             }else
375             {
376                 return super.allowance(_owner, _spender);
377             }
378         }else
379         {
380             return super.allowance(_owner, _spender);
381         }
382     }
383 
384 }
385 
386 contract ERCTW 
387 {
388     function totalSupply() constant returns (uint256);
389     function balanceOf(address _owner) constant returns (uint256);
390     function transfer(address _to, uint _value) returns (bool);
391     function transferFrom(address _from, address _to, uint _value) returns (bool);
392     function approve(address _spender, uint _value) returns (bool);
393     function allowance(address _owner, address _spender) constant returns (uint256);
394     event Transfer(address indexed _from, address indexed _to, uint _value);
395     event Approval(address indexed _owner, address indexed _spender, uint _value);
396 }
397 
398 
399 contract TokenTrader is Owned 
400 {
401     address public exchange;    // address of exchange
402     address public asset;       // address of token
403     uint256 public buyPrice;    // contract buys lots of token at this price
404     uint256 public sellPrice;   // contract sells lots at this price
405     uint256 public units;       // lot size (token-wei)
406     uint256 public exchFee;     // fee size (0,01 x8888)
407 
408     bool public buysTokens;     // is contract buying
409     bool public sellsTokens;    // is contract selling
410 
411     event ActivatedEvent(bool buys, bool sells);
412     event MakerDepositedEther(uint256 amount);
413     event MakerWithdrewAsset(uint256 tokens);
414     event MakerTransferredAsset(address toTokenTrader, uint256 tokens);
415     event MakerWithdrewERC20Token(address tokenAddress, uint256 tokens);
416     event MakerWithdrewEther(uint256 ethers);
417     event MakerTransferredEther(address toTokenTrader, uint256 ethers);
418     event TakerBoughtAsset(address indexed buyer, uint256 ethersSent,
419         uint256 ethersReturned, uint256 tokensBought);
420     event TakerSoldAsset(address indexed seller, uint256 amountOfTokensToSell,
421         uint256 tokensSold, uint256 etherValueOfTokensSold);
422 
423     // Constructor - only to be called by the TokenTraderFactory contract
424     function TokenTrader (
425         address _asset,
426         uint256 _exchFee,
427         address _exchange,
428         uint256 _buyPrice,
429         uint256 _sellPrice,
430         uint256 _units,
431         bool    _buysTokens,
432         bool    _sellsTokens
433     ) 
434     {
435         asset       = _asset;
436         exchFee     = _exchFee;
437         exchange    = _exchange;
438         buyPrice    = _buyPrice;
439         sellPrice   = _sellPrice;
440         units       = _units;
441         buysTokens  = _buysTokens;
442         sellsTokens = _sellsTokens;
443         ActivatedEvent(buysTokens, sellsTokens);
444     }
445 
446     function activate (
447         address _asset,
448         uint256 _exchFee,
449         address _exchange,
450         uint256 _buyPrice,
451         uint256 _sellPrice,
452         uint256 _units,
453         bool    _buysTokens,
454         bool    _sellsTokens
455     ) onlyOwner 
456     {
457         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
458         asset       = _asset;
459         exchFee     = _exchFee;
460         exchange    = _exchange;
461         buyPrice    = _buyPrice;
462         sellPrice   = _sellPrice;
463         units       = _units;
464         buysTokens  = _buysTokens;
465         sellsTokens = _sellsTokens;
466         ActivatedEvent(buysTokens, sellsTokens);
467     }
468 
469     function makerDepositEther() payable onlyOwnerOrTokenTraderWithSameOwner 
470     {
471         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
472         MakerDepositedEther(msg.value);
473     }
474 
475     function makerWithdrawAsset(uint256 tokens) onlyOwner returns (bool ok) 
476     {
477         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
478         MakerWithdrewAsset(tokens);
479         return ERCTW(asset).transfer(owner, tokens);
480     }
481 
482     function makerTransferAsset(
483         TokenTrader toTokenTrader,
484         uint256 tokens
485     ) onlyOwner returns (bool ok) 
486     {
487         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
488         require (owner == toTokenTrader.owner() && asset == toTokenTrader.asset()); 
489         MakerTransferredAsset(toTokenTrader, tokens);
490         return ERCTW(asset).transfer(toTokenTrader, tokens);
491     }
492 
493     function makerWithdrawERC20Token(
494         address tokenAddress,
495         uint256 tokens
496     ) onlyOwner returns (bool ok) 
497     {
498         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
499         MakerWithdrewERC20Token(tokenAddress, tokens);
500         return ERCTW(tokenAddress).transfer(owner, tokens);
501     }
502 
503     function makerWithdrawEther(uint256 ethers) onlyOwner returns (bool ok) 
504     {
505         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
506         if (this.balance >= ethers) 
507         {
508             MakerWithdrewEther(ethers);
509             return owner.send(ethers);
510         }
511     }
512 
513     function makerTransferEther(
514         TokenTrader toTokenTrader,
515         uint256 ethers
516     ) onlyOwner returns (bool) 
517     {
518         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
519         require (owner == toTokenTrader.owner() && asset == toTokenTrader.asset()); 
520         if (this.balance >= ethers) 
521         {
522             MakerTransferredEther(toTokenTrader, ethers);
523             toTokenTrader.makerDepositEther.value(ethers)();
524         }
525     }
526 
527     function takerBuyAsset() payable 
528     {
529         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
530         if (sellsTokens || msg.sender == owner) 
531         {
532             uint order    = msg.value / sellPrice;
533             uint can_sell = ERCTW(asset).balanceOf(address(this)) / units;
534             uint256 change = 0;
535             if (msg.value > (can_sell * sellPrice)) 
536             {
537                 change  = msg.value - (can_sell * sellPrice);
538                 order = can_sell;
539             }
540             if (change > 0) 
541             {
542                 require(msg.sender.send(change));
543             }
544             if (order > 0) 
545             {
546                 require (ERCTW(asset).transfer(msg.sender, order * units));
547             }
548             TakerBoughtAsset(msg.sender, msg.value, change, order * units);
549         }
550         else require (msg.sender.send(msg.value));
551     }
552 
553     function takerSellAsset(uint256 amountOfTokensToSell) 
554     {
555         require(ERCTW(exchange).transferFrom(owner, exchange, exchFee));
556         if (buysTokens || msg.sender == owner) 
557         {
558             uint256 can_buy = this.balance / buyPrice;
559             uint256 order = amountOfTokensToSell / units;
560             if (order > can_buy) order = can_buy;
561             if (order > 0) 
562             {
563                 require(ERCTW(asset).transferFrom(msg.sender, address(this), order * units));
564                 require(msg.sender.send(order * buyPrice));
565             }
566             TakerSoldAsset(msg.sender, amountOfTokensToSell, order * units, order * buyPrice);
567         }
568     }
569     function () payable 
570     {
571         takerBuyAsset();
572     }
573 }