1 pragma solidity ^0.4.15;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18 
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28  
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36  
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   uint256 totalSupply_;
56 
57   
58   function totalSupply() public view returns (uint256) {
59     return totalSupply_;
60   }
61 
62  
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74  
75   function balanceOf(address _owner) public view returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79 }
80 
81 //-------------StandardToken.sol--------------
82 
83 contract StandardToken is ERC20, BasicToken {
84 
85   mapping (address => mapping (address => uint256)) internal allowed;
86 
87   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[_from]);
90     require(_value <= allowed[_from][msg.sender]);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99 
100   function approve(address _spender, uint256 _value) public returns (bool) {
101     allowed[msg.sender][_spender] = _value;
102     Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106 
107   function allowance(address _owner, address _spender) public view returns (uint256) {
108     return allowed[_owner][_spender];
109   }
110 
111 
112   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
113     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118 
119   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
120     uint oldValue = allowed[msg.sender][_spender];
121     if (_subtractedValue > oldValue) {
122       allowed[msg.sender][_spender] = 0;
123     } else {
124       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
125     }
126     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127     return true;
128   }
129 
130 }
131 
132 
133 contract AOG is StandardToken {
134     
135     using SafeMath for uint256;
136 
137     string public name = "AOG";
138     string public symbol = "AOG";
139     uint256 public decimals = 18;
140 
141     uint256 public totalSupply = 2700000000 * (uint256(10) ** decimals);
142     
143     uint256 public constant PreIcoSupply                  = 135000000 * (10 ** uint256(18));
144     uint256 public constant IcoSupply                     = 675000000  * (10 ** uint256(18));
145     uint256 public constant CharityInProgressSupply       = 54000000 * (10 ** uint256(18));
146     uint256 public constant CharityReservesSupply         = 1296000000 * (10 ** uint256(18));
147     uint256 public constant CoreTeamAndFoundersSupply     = 270000000 * (10 ** uint256(18));
148     uint256 public constant DevPromotionsMarketingSupply  = 270000000 * (10 ** uint256(18));
149     
150     bool public PRE_ICO_ON;
151     bool public ICO_ON;
152     
153     string public PreIcoMessage = "Coming Soon";
154     string public IcoMessage    = "Not Started";
155     
156     uint256 public totalRaised; // total ether raised (in wei)
157     uint256 public totalRaisedIco; // total ether raised (in wei)
158 
159     uint256 public startTimestamp; // timestamp after which ICO will start
160     uint256 public durationSeconds = 31 * 24 * 60 * 60; // 31 Days pre ico
161 
162     uint256 public minCap; // the ICO ether goal (in wei)
163     uint256 public maxCap; // the ICO ether max cap (in wei)
164     
165     uint256 public startTimestampIco; // timestamp after which ICO will start
166     uint256 public durationSecondsIco = 6 * 7 * 24 * 60 * 60; // 6 weeks ico
167 
168     uint256 public minCapIco; // the ICO ether goal (in wei)
169     uint256 public maxCapIco; // the ICO ether max cap (in wei)
170     
171      address public owner;
172    
173    event Burn(address indexed from, uint256 value);
174    
175     /**
176      * Address which will receive raised funds 
177      * and owns the total supply of tokens
178      */
179     address public fundsWallet;
180     
181     /* Token Distribution Wallets Address */
182     
183     address public PreIcoWallet;
184     address public IcoWallet;
185     address public CharityInProgressWallet;
186     address public CharityReservesWallet;
187     address public CoreTeamAndFoundersWallet;
188     address public DevPromotionsMarketingWallet;
189 
190     function AOG (
191         address _fundsWallet,
192         address _PreIcoWallet,
193         address _IcoWallet,
194         address _CharityWallet,
195         address _CharityReservesWallet,
196         address _CoreTeamFoundersWallet,
197         address _DevPromotionsMarketingWallet
198         ) {
199             
200         fundsWallet = _fundsWallet;
201         PreIcoWallet = _PreIcoWallet;
202         IcoWallet = _IcoWallet;
203         CharityInProgressWallet = _CharityWallet;
204         CharityReservesWallet = _CharityReservesWallet;
205         CoreTeamAndFoundersWallet = _CoreTeamFoundersWallet;
206         DevPromotionsMarketingWallet = _DevPromotionsMarketingWallet;
207         owner = msg.sender;
208         // initially assign all tokens to the fundsWallet
209         balances[fundsWallet] = totalSupply;
210         
211         balances[PreIcoWallet]                  = PreIcoSupply;
212         balances[IcoWallet]                     = IcoSupply;
213         balances[CharityInProgressWallet]       = CharityInProgressSupply;
214         balances[CharityReservesWallet]         = CharityReservesSupply;
215         balances[CoreTeamAndFoundersWallet]     = CoreTeamAndFoundersSupply;
216         balances[DevPromotionsMarketingWallet]  = DevPromotionsMarketingSupply;
217         
218         Transfer(0x0, PreIcoWallet, PreIcoSupply);
219         Transfer(0x0, IcoWallet, IcoSupply);
220         Transfer(0x0, CharityInProgressWallet, CharityInProgressSupply);
221         Transfer(0x0, CharityReservesWallet, CharityReservesSupply);
222         Transfer(0x0, CoreTeamAndFoundersWallet, CoreTeamAndFoundersSupply);
223         Transfer(0x0, DevPromotionsMarketingWallet, DevPromotionsMarketingSupply);
224         
225     }
226     
227 
228  function startPreIco(uint256 _startTimestamp,uint256 _minCap,uint256 _maxCap) external returns(bool)
229     {
230         require(owner == msg.sender);
231         require(PRE_ICO_ON == false);
232         PRE_ICO_ON = true;
233         PreIcoMessage = "PRE ICO RUNNING";
234         startTimestamp = _startTimestamp;
235         minCap = _minCap;
236         maxCap = _maxCap;
237         return true;
238     }
239     
240     function stopPreIoc() external returns(bool)
241     {
242         require(owner == msg.sender);
243         require(PRE_ICO_ON == true);
244         PRE_ICO_ON = false;
245         PreIcoMessage = "Finish";
246         
247         return true;
248     }
249     
250     function startIco(uint256 _startTimestampIco,uint256 _minCapIco,uint256 _maxCapIco) external returns(bool)
251     {
252         require(owner == msg.sender);
253         require(ICO_ON == false);
254         ICO_ON = true;
255         PRE_ICO_ON = false;
256         PreIcoMessage = "Finish";
257         IcoMessage = "ICO RUNNING";
258         
259         startTimestampIco = _startTimestampIco;
260         minCapIco = _minCapIco;
261         maxCapIco = _maxCapIco;
262         
263          return true;
264     }
265     
266 
267     function() isPreIcoAndIcoOpen payable {
268       
269       uint256 tokenPreAmount;
270       uint256 tokenIcoAmount;
271       
272       // during Pre ICO   
273       
274         if(PRE_ICO_ON == true)
275         {
276             totalRaised = totalRaised.add(msg.value);
277         
278         if(totalRaised >= maxCap || (now >= (startTimestamp + durationSeconds) && totalRaised >= minCap))
279             {
280                 PRE_ICO_ON = false;
281                 PreIcoMessage = "Finish";
282             }
283             
284         }
285     
286     // during ICO   
287     
288          if(ICO_ON == true)
289         {
290             totalRaisedIco = totalRaisedIco.add(msg.value);
291            
292             if(totalRaisedIco >= maxCapIco || (now >= (startTimestampIco + durationSecondsIco) && totalRaisedIco >= minCapIco))
293             {
294                 ICO_ON = false;
295                 IcoMessage = "Finish";
296             }
297         } 
298         
299         // immediately transfer ether to fundsWallet
300         fundsWallet.transfer(msg.value);
301     }
302     
303      modifier isPreIcoAndIcoOpen() {
304         
305         if(PRE_ICO_ON == true)
306         {
307              require(now >= startTimestamp);
308              require(now <= (startTimestamp + durationSeconds) || totalRaised < minCap);
309              require(totalRaised <= maxCap);
310              _;
311         }
312         
313         if(ICO_ON == true)
314         {
315             require(now >= startTimestampIco);
316             require(now <= (startTimestampIco + durationSecondsIco) || totalRaisedIco < minCapIco);
317             require(totalRaisedIco <= maxCapIco);
318             _;
319         }
320         
321     }
322     
323     /****** Pre Ico Token Calculation ******/
324 
325     function calculatePreTokenAmount(uint256 weiAmount) constant returns(uint256) {
326        
327    
328         uint256 tokenAmount;
329         uint256 standardRateDaysWise;
330         
331         standardRateDaysWise = calculatePreBonus(weiAmount); // Rate
332         tokenAmount = weiAmount.mul(standardRateDaysWise);       // Number of coin
333               
334         return tokenAmount;
335     
336     }
337     
338       /************ ICO Token Calculation ***********/
339 
340     function calculateIcoTokenAmount(uint256 weiAmount) constant returns(uint256) {
341      
342         uint256 tokenAmount;
343         uint256 standardRateDaysWise;
344         
345         if (now <= startTimestampIco + 7 days) {
346              
347             standardRateDaysWise = calculateIcoBonus(weiAmount,1,1); // Rate
348             return tokenAmount = weiAmount.mul(standardRateDaysWise);  // Number of coin
349              
350          } else if (now >= startTimestampIco + 7 days && now <= startTimestampIco + 14 days) {
351               
352               standardRateDaysWise = calculateIcoBonus(weiAmount,1,2); // Rate 
353                
354               return tokenAmount = weiAmount.mul(standardRateDaysWise);
355              
356          } else if (now >= startTimestampIco + 14 days) {
357              
358                standardRateDaysWise = calculateIcoBonus(weiAmount,1,3);
359               
360                return tokenAmount = weiAmount.mul(standardRateDaysWise);
361              
362          } else {
363             return tokenAmount;
364         }
365     }
366         
367     function calculatePreBonus(uint256 userAmount) returns(uint256)
368     {
369      
370     // 0.1 to 4.99 eth
371     
372         if(userAmount >= 100000000000000000 && userAmount < 5000000000000000000)
373         {
374                 return 7000;
375         } 
376         else if(userAmount >= 5000000000000000000 && userAmount < 15000000000000000000)
377         {
378                 return 8000;
379         }
380         else if(userAmount >= 15000000000000000000 && userAmount < 30000000000000000000)
381         {
382                return 9000;
383         }
384         else if(userAmount >= 30000000000000000000 && userAmount < 60000000000000000000)
385         {
386                 return 10000;
387         }
388         else if(userAmount >= 60000000000000000000 && userAmount < 100000000000000000000)
389         {
390                return 11250;
391         }
392         else if(userAmount >= 100000000000000000000)
393         {
394                 return 12500;
395         }
396     }
397     
398     
399     function calculateIcoBonus(uint256 userAmount,uint _calculationType, uint _sno) returns(uint256)
400     {
401             // 0.1 to 4.99 eth 
402     
403         if(userAmount >= 100000000000000000 && userAmount < 5000000000000000000)
404         {
405                 if(_sno == 1) // 1-7 Days
406                 {
407                     return 6000;
408                     
409                 } else if(_sno == 2)  // 8-14 Days
410                 {
411                     return 5500;
412                     
413                 } else if(_sno == 3) // 15+ Days
414                 {
415                     return 5000;
416                 }
417             
418         } 
419         else if(userAmount >= 5000000000000000000 && userAmount < 15000000000000000000)
420         {
421                 if(_sno == 1) // 1-7 Days
422                 {
423                     return 6600;
424                     
425                 } else if(_sno == 2)  //8-14 Days
426                 {
427                     return 6050;
428                     
429                 } else if(_sno == 3) // 15+ Days
430                 {
431                     return 5500;
432                 }
433             
434         }
435         else if(userAmount >= 15000000000000000000 && userAmount < 30000000000000000000)
436         {
437                 if(_sno == 1) // 1-7 Days
438                 {
439                     return 7200;
440                     
441                 } else if(_sno == 2)  // 8-14 Days
442                 {
443                     return 6600;
444                     
445                 } else if(_sno == 3) // 15+ Days
446                 {
447                     return 6000;
448                 }
449             
450         }
451         else if(userAmount >= 30000000000000000000 && userAmount < 60000000000000000000)
452         {
453                 if(_sno == 1) // 1-7 Days
454                 {
455                     return 7500;
456                     
457                 } else if(_sno == 2)  // 8-14 Days
458                 {
459                     return 6875;
460                     
461                 } else if(_sno == 3) // 15+ Days
462                 {
463                     return 6250;
464                 }
465             
466         }
467         else if(userAmount >= 60000000000000000000 && userAmount < 100000000000000000000)
468         {
469                 if(_sno == 1) // 1-7 Days
470                 {
471                     return 7800;
472                     
473                 } else if(_sno == 2)  // 8-14 Days
474                 {
475                     return 7150;
476                     
477                 } else if(_sno == 3) // 15+ Days
478                 {
479                     return 6500;
480                 }
481             
482         }
483         else if(userAmount >= 100000000000000000000)
484         {
485                 if(_sno == 1) // 1-7 Days
486                 {
487                     return 8400;
488                     
489                 } else if(_sno == 2)  // 8-14 Days
490                 {
491                     return 7700;
492                     
493                 } else if(_sno == 3) // 15+ Days
494                 {
495                     return 7000;
496                 }
497         }
498     }
499     
500      // AOG GAME   
501  
502    function TokenGameTransfer(address _to, uint _gamevalue) returns (bool)
503     {
504         return super.transfer(_to, _gamevalue);
505     } 
506           
507  
508    function TokenTransferFrom(address _from, address _to, uint _value) returns (bool)
509     {
510             return super.transferFrom(_from, _to, _value);
511     } 
512     
513      function TokenTransferTo(address _to, uint _value) returns (bool)
514     {
515            return super.transfer(_to, _value);
516     } 
517     
518     function BurnToken(address _from) public returns(bool success)
519     {
520         require(owner == msg.sender);
521         require(balances[_from] > 0);   // Check if the sender has enough
522         uint _value = balances[_from];
523         balances[_from] -= _value;            // Subtract from the sender
524         totalSupply -= _value;                      // Updates totalSupply
525         Burn(_from, _value);
526         return true;
527     }
528     
529 // Add off chain Pre Ico and Ico contribution for BTC users transparency
530          
531     function addOffChainRaisedContribution(address _to, uint _value,uint weiAmount)  returns(bool) {
532             
533         if(PRE_ICO_ON == true)
534         {
535             totalRaised = totalRaised.add(weiAmount);  
536             return super.transfer(_to, _value);
537         } 
538         
539         if(ICO_ON == true)
540         {
541             totalRaisedIco = totalRaisedIco.add(weiAmount);
542             return super.transfer(_to, _value);
543         }
544             
545     }
546     
547     function changeOwner(address _addr) external returns (bool){
548         require(owner == msg.sender);
549         owner = _addr;
550         return true;
551     }
552    
553 }