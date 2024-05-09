1 pragma solidity ^0.4.18;
2 
3 contract Ownable 
4 {
5     address public owner;
6     address public newOwner;
7     
8     function Ownable() public 
9     {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner() 
14     {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function changeOwner(address _owner) onlyOwner public 
20     {
21         require(_owner != 0);
22         newOwner = _owner;
23     }
24     
25     function confirmOwner() public 
26     {
27         require(newOwner == msg.sender);
28         owner = newOwner;
29         delete newOwner;
30     }
31 }
32 
33 
34 /**
35  * Math operations with safety checks
36  */
37 contract SafeMath {
38   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b > 0);
46     uint256 c = a / b;
47     assert(a == b * c + a % b);
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 
69 {
70     uint256 public totalSupply;
71     function balanceOf(address who) public constant returns (uint256);
72     function transfer(address to, uint256 value) public;
73     function allowance(address owner, address spender) public constant returns (uint256);
74     function transferFrom(address from, address to, uint256 value) public;
75     function approve(address spender, uint256 value) public;
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     function getDecimals() public constant returns(uint8);
79     function getTotalSupply() public constant returns(uint256 supply);
80 }
81 
82 
83 
84 contract IzubrToken is Ownable, ERC20, SafeMath 
85 {
86     string  public constant standard    = 'Token 0.1';
87     string  public constant name        = 'Izubr';
88     string  public constant symbol      = "IZR";
89     uint8   public constant decimals    = 18;
90     uint256 public constant tokenKoef = 1000000000000000000;
91 
92     mapping (address => uint256) internal balances;
93     mapping (address => mapping (address => uint256)) public allowed;
94 
95     uint       private constant gasPrice = 3000000;
96 
97     uint256    public etherPrice;
98     uint256    public minimalSuccessTokens;
99     uint256    public collectedTokens;
100 
101     enum    State { Disabled, PreICO, CompletePreICO, Crowdsale, Enabled, Migration }
102     event   NewState(State state);
103 
104     State      public state = State.Disabled;
105     uint256    public crowdsaleStartTime;
106     uint256    public crowdsaleFinishTime;
107 
108     mapping (address => uint256)  public investors;
109     mapping (uint256 => address)  public investorsIter;
110     uint256                       public numberOfInvestors;
111 
112     modifier onlyTokenHolders 
113     {
114         require(balances[msg.sender] != 0);
115         _;
116     }
117 
118     // Fix for the ERC20 short address attack
119     modifier onlyPayloadSize(uint size) 
120     {
121         require(msg.data.length >= size + 4);
122         _;
123     }
124 
125     modifier enabledState 
126     {
127         require(state == State.Enabled);
128         _;
129     }
130 
131     modifier enabledOrMigrationState 
132     {
133         require(state == State.Enabled || state == State.Migration);
134         _;
135     }
136 
137 
138 
139     function getDecimals() public constant returns(uint8)
140     {
141         return decimals;
142     }
143 
144     function balanceOf(address who) public constant returns (uint256) 
145     {
146         return balances[who];
147     }
148 
149     function investorsCount() public constant returns (uint256) 
150     {
151         return numberOfInvestors;
152     }
153 
154     function transfer(address _to, uint256 _value)
155         public enabledState onlyPayloadSize(2 * 32) 
156     {
157         require(balances[msg.sender] >= _value);
158 
159         balances[msg.sender] = sub( balances[msg.sender], _value );
160         balances[_to] = add( balances[_to], _value );
161 
162         Transfer(msg.sender, _to, _value);
163     }
164     
165     function transferFrom(address _from, address _to, uint256 _value)
166         public enabledState onlyPayloadSize(3 * 32) 
167     {
168         require(balances[_from] >= _value);
169         require(allowed[_from][msg.sender] >= _value);
170 
171         balances[_from] = sub( balances[_from], _value );
172         balances[_to] = add( balances[_to], _value );
173 
174         allowed[_from][msg.sender] = sub( allowed[_from][msg.sender], _value );
175 
176         Transfer(_from, _to, _value);
177     }
178 
179     function approve(address _spender, uint256 _value) public enabledState 
180     {
181         allowed[msg.sender][_spender] = _value;
182 
183         Approval(msg.sender, _spender, _value);
184     }
185 
186     function allowance(address _owner, address _spender) public constant enabledState
187         returns (uint256 remaining) 
188     {
189         return allowed[_owner][_spender];
190     }
191 
192 
193     
194     function () public payable
195     {
196         require(state == State.PreICO || state == State.Crowdsale);
197         require(now < crowdsaleFinishTime);
198 
199         uint256 valueWei = msg.value;
200 
201         uint256 price = currentPrice();
202 
203         uint256 valueTokens = div( mul( valueWei, price ), 1 ether);
204 
205         if( valueTokens > 33333*tokenKoef ) // 5 BTC
206         {
207             price = price * 112 / 100;
208             valueTokens = mul( valueWei, price );
209         }
210 
211         require(valueTokens > 10*tokenKoef);
212 
213 
214         collectedTokens = add( collectedTokens, valueTokens );
215             
216         if(msg.data.length == 20) 
217         {
218             address referer = bytesToAddress(bytes(msg.data));
219 
220             require(referer != msg.sender);
221 
222             mintTokensWithReferal(msg.sender, referer, valueTokens);
223         }
224         else
225         {
226             mintTokens(msg.sender, valueTokens);
227         }
228     }
229 
230     function bytesToAddress(bytes source) internal pure returns(address) 
231     {
232         uint result;
233         uint mul = 1;
234 
235         for(uint i = 20; i > 0; i--) 
236         {
237             result += uint8(source[i-1])*mul;
238             mul = mul*256;
239         }
240 
241         return address(result);
242     }
243 
244     function getTotalSupply() public constant returns(uint256) {
245         return totalSupply;
246     }
247 
248     function depositTokens(address _who, uint256 _valueTokens) public onlyOwner 
249     {
250         require(state == State.PreICO || state == State.Crowdsale);
251         require(now < crowdsaleFinishTime);
252 
253         uint256 bonus = currentBonus();
254         uint256 tokens = _valueTokens * (100 + bonus) / 100;
255 
256         collectedTokens = add( collectedTokens, tokens );
257 
258         mintTokens(_who, tokens);
259     }
260 
261 
262     function bonusForDate(uint date) public constant returns (uint256) 
263     {
264         require(state == State.PreICO || state == State.Crowdsale);
265 
266         uint nday = (date - crowdsaleStartTime) / (1 days);
267 
268         uint256 bonus = 0;
269 
270         if (state == State.PreICO) 
271         {
272             if( nday < 7*1 ) bonus = 100;
273             else
274             if( nday < 7*2 ) bonus = 80;
275             else
276             if( nday < 7*3 ) bonus = 70;
277             else
278             if( nday < 7*4 ) bonus = 60;
279             else
280             if( nday < 7*5 ) bonus = 50;
281             else             bonus = 40;
282         }
283         else
284         if (state == State.Crowdsale) 
285         {
286             if( nday < 1 ) bonus = 20;
287             else
288             if( nday < 4 ) bonus = 15;
289             else
290             if( nday < 8 ) bonus = 10;
291             else
292             if( nday < 12 ) bonus = 5;
293         }
294 
295         return bonus;
296     }
297 
298     function currentBonus() public constant returns (uint256) 
299     {
300         return bonusForDate(now);
301     }
302 
303 
304     function priceForDate(uint date) public constant returns (uint256) 
305     {
306         uint256 bonus = bonusForDate(date);
307 
308         return etherPrice * (100 + bonus) / 100;
309     }
310 
311     function currentPrice() public constant returns (uint256) 
312     {
313         return priceForDate(now);
314     }
315 
316 
317     function mintTokens(address _who, uint256 _tokens) internal 
318     {
319         uint256 inv = investors[_who];
320 
321         if (inv == 0) // new investor
322         {
323             investorsIter[numberOfInvestors++] = _who;
324         }
325 
326         inv = add( inv, _tokens );
327         balances[_who] = add( balances[_who], _tokens );
328 
329         Transfer(this, _who, _tokens);
330 
331         totalSupply = add( totalSupply, _tokens );
332     }
333 
334 
335     function mintTokensWithReferal(address _who, address _referal, uint256 _valueTokens) internal 
336     {
337         uint256 refererTokens = _valueTokens * 5 / 100;
338 
339         uint256 valueTokens = _valueTokens * 103 / 100;
340 
341         mintTokens(_referal, refererTokens);
342 
343         mintTokens(_who, valueTokens);
344     }
345     
346     function startTokensSale(
347             uint    _crowdsaleStartTime,
348             uint    _crowdsaleFinishTime,
349             uint256 _minimalSuccessTokens,
350             uint256 _etherPrice) public onlyOwner 
351     {
352         require(state == State.Disabled || state == State.CompletePreICO);
353 
354         crowdsaleStartTime  = _crowdsaleStartTime;
355         crowdsaleFinishTime = _crowdsaleFinishTime;
356 
357         etherPrice = _etherPrice;
358         delete numberOfInvestors;
359         delete collectedTokens;
360 
361         minimalSuccessTokens = _minimalSuccessTokens;
362 
363         if (state == State.Disabled) 
364         {
365             state = State.PreICO;
366         } 
367         else 
368         {
369             state = State.Crowdsale;
370         }
371 
372         NewState(state);
373     }
374     
375     function timeToFinishTokensSale() public constant returns(uint256 t) 
376     {
377         require(state == State.PreICO || state == State.Crowdsale);
378 
379         if (now > crowdsaleFinishTime) 
380         {
381             t = 0;
382         } 
383         else 
384         {
385             t = crowdsaleFinishTime - now;
386         }
387     }
388     
389     function finishTokensSale(uint256 _investorsToProcess) public 
390     {
391         require(state == State.PreICO || state == State.Crowdsale);
392 
393         require(now >= crowdsaleFinishTime || 
394             (collectedTokens >= minimalSuccessTokens && msg.sender == owner));
395 
396         if (collectedTokens < minimalSuccessTokens) 
397         {
398             // Investors can get their ether calling withdrawBack() function
399             while (_investorsToProcess > 0 && numberOfInvestors > 0) 
400             {
401                 address addr = investorsIter[--numberOfInvestors];
402                 uint256 inv = investors[addr];
403                 balances[addr] = sub( balances[addr], inv );
404                 totalSupply = sub( totalSupply, inv );
405                 Transfer(addr, this, inv);
406 
407                 --_investorsToProcess;
408 
409                 delete investorsIter[numberOfInvestors];
410             }
411 
412             if (numberOfInvestors > 0) 
413             {
414                 return;
415             }
416 
417             if (state == State.PreICO) 
418             {
419                 state = State.Disabled;
420             } 
421             else 
422             {
423                 state = State.CompletePreICO;
424             }
425         } 
426         else 
427         {
428             while (_investorsToProcess > 0 && numberOfInvestors > 0) 
429             {
430                 --numberOfInvestors;
431                 --_investorsToProcess;
432 
433                 address i = investorsIter[numberOfInvestors];
434 
435                 investors[i] = 0;
436 
437                 delete investors[i];
438                 delete investorsIter[numberOfInvestors];
439             }
440 
441             if (numberOfInvestors > 0) 
442             {
443                 return;
444             }
445 
446             if (state == State.PreICO) 
447             {
448                 state = State.CompletePreICO;
449             } 
450             else 
451             {
452                 // Create additional tokens for owner (40% of complete totalSupply)
453                 uint256 tokens = div( mul( 4, totalSupply ) , 6 );
454                 balances[owner] = tokens;
455                 totalSupply = add( totalSupply, tokens );
456                 Transfer(this, owner, tokens);
457                 state = State.Enabled;
458             }
459         }
460 
461         NewState(state);
462     }
463     
464     // This function must be called by token holder in case of crowdsale failed
465     function withdrawBack() public 
466     {
467         require(state == State.Disabled);
468 
469         uint256 tokens = investors[msg.sender];
470         uint256 value = div( tokens, etherPrice );
471 
472         if (value > 0) 
473         {
474             investors[msg.sender] = 0;
475             require( msg.sender.call.gas(gasPrice).value(value)() );
476 
477             totalSupply = sub( totalSupply, tokens );
478         }
479     }
480 
481     
482 }