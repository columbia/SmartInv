1 pragma solidity ^0.4.24;
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
133 contract MTC is StandardToken {
134     
135     using SafeMath for uint256;
136 
137     string public name = "Midas Touch Coin";
138     string public symbol = "MTC";
139     uint256 public decimals = 18;
140 
141     uint256 public totalSupply = 2800000000 * (uint256(10) ** decimals);
142     
143     uint256 public constant PreIcoSupply                    = 140000000 * (10 ** uint256(18));
144     uint256 public constant IcoSupply                       = 1120000000 * (10 ** uint256(18));
145     uint256 public constant CharityAndSocialResponsibilitySupply  = 560000000 * (10 ** uint256(18));
146     uint256 public constant CoreTeamAndFoundersSupply       = 560000000 * (10 ** uint256(18));
147     uint256 public constant DevPromotionsMarketingSupply    = 280000000 * (10 ** uint256(18));
148     uint256 public constant ScholarshipSupply               = 140000000 * (10 ** uint256(18));
149     
150     
151     
152     bool public PRE_ICO_ON;
153     bool public ICO_ON;
154     
155     string public PreIcoMessage = "Coming Soon";
156     string public IcoMessage    = "Not Started";
157     
158     uint256 public totalRaisedPreIco; // Pre Ico total ether raised (in wei)
159     uint256 public totalRaisedIco; // Ico total ether raised (in wei)
160 
161     uint256 public startTimestampPreIco; // timestamp after which Pre ICO will start
162     uint256 public durationSecondsPreIco = 31 * 24 * 60 * 60; // 31 Days pre ico
163 
164     uint256 public minCapPreIco; // the PRE ICO ether goal (in wei)
165     uint256 public maxCapPreIco; // the PRE ICO ether max cap (in wei)
166     
167     uint256 public startTimestampIco; // timestamp after which ICO will start
168     uint256 public durationSecondsIco = 6 * 7 * 24 * 60 * 60; // 6 weeks ico
169 
170     uint256 public minCapIco; // the ICO ether goal (in wei)
171     uint256 public maxCapIco; // the ICO ether max cap (in wei)
172     
173      address public owner;
174    
175    event Burn(address indexed from, uint256 value);
176    
177     /**
178      * Address which will receive raised funds 
179      * and owns the total supply of tokens
180      */
181     address public fundsWallet;
182     
183     /* Token Distribution Wallets Address */
184     
185     address public PreIcoWallet;
186     address public IcoWallet;
187     address public CharityAndSocialResponsibilityWallet;
188     address public CoreTeamAndFoundersWallet;
189     address public DevPromotionsMarketingWallet;
190     address public ScholarshipSupplyWallet;
191 
192     function MTC (
193         address _fundsWallet,
194         address _PreIcoWallet,
195         address _IcoWallet,
196         address _CharityAndSocialResponsibilityWallet,
197         address _CoreTeamFoundersWallet,
198         address _DevPromotionsMarketingWallet,
199         address _ScholarshipSupplyWallet
200         ) {
201     
202         fundsWallet = _fundsWallet;
203         PreIcoWallet = _PreIcoWallet;
204         IcoWallet = _IcoWallet;
205         CharityAndSocialResponsibilityWallet = _CharityAndSocialResponsibilityWallet;
206         CoreTeamAndFoundersWallet = _CoreTeamFoundersWallet;
207         DevPromotionsMarketingWallet = _DevPromotionsMarketingWallet;
208         ScholarshipSupplyWallet = _ScholarshipSupplyWallet;
209         
210         owner = msg.sender;
211         
212         // initially assign all tokens to the Wallets
213         
214         balances[PreIcoWallet]                  = PreIcoSupply;
215         balances[IcoWallet]                     = IcoSupply;
216         balances[CharityAndSocialResponsibilityWallet]       = CharityAndSocialResponsibilitySupply;
217         balances[CoreTeamAndFoundersWallet]     = CoreTeamAndFoundersSupply;
218         balances[DevPromotionsMarketingWallet]  = DevPromotionsMarketingSupply;
219         balances[ScholarshipSupplyWallet]  = ScholarshipSupply;
220         
221         // transfer tokens to Wallets
222         
223         Transfer(0x0, PreIcoWallet, PreIcoSupply);
224         Transfer(0x0, IcoWallet, IcoSupply);
225         Transfer(0x0, CharityAndSocialResponsibilityWallet, CharityAndSocialResponsibilitySupply);
226         Transfer(0x0, CoreTeamAndFoundersWallet, CoreTeamAndFoundersSupply);
227         Transfer(0x0, DevPromotionsMarketingWallet, DevPromotionsMarketingSupply);
228         Transfer(0x0, ScholarshipSupplyWallet, ScholarshipSupply);
229         
230     }
231     
232 
233  function startPreIco(uint256 _startTimestamp,uint256 _minCap,uint256 _maxCap) external returns(bool)
234     {
235         require(owner == msg.sender);
236         require(PRE_ICO_ON == false);
237         PRE_ICO_ON = true;
238         PreIcoMessage = "PRE ICO RUNNING";
239         startTimestampPreIco = _startTimestamp;
240         minCapPreIco = _minCap;
241         maxCapPreIco = _maxCap;
242         return true;
243     }
244     
245     function stopPreICO() external returns(bool)
246     {
247         require(owner == msg.sender);
248         require(PRE_ICO_ON == true);
249         PRE_ICO_ON = false;
250         PreIcoMessage = "Finish";
251         
252         return true;
253     }
254     
255     function startIco(uint256 _startTimestampIco,uint256 _minCapIco,uint256 _maxCapIco) external returns(bool)
256     {
257         require(owner == msg.sender);
258         require(ICO_ON == false);
259         ICO_ON = true;
260         PRE_ICO_ON = false;
261         PreIcoMessage = "Finish";
262         IcoMessage = "ICO RUNNING";
263         
264         startTimestampIco = _startTimestampIco;
265         minCapIco = _minCapIco;
266         maxCapIco = _maxCapIco;
267         
268          return true;
269     }
270     
271     function stopICO() external returns(bool)
272     {
273         require(owner == msg.sender);
274         require(ICO_ON == true);
275         ICO_ON = false;
276         PRE_ICO_ON = false;
277         PreIcoMessage = "Finish";
278         IcoMessage = "Finish";
279         
280         return true;
281     }
282 
283     function() isPreIcoAndIcoOpen payable {
284       
285       uint256 tokenPreAmount;
286       uint256 tokenIcoAmount;
287       
288       // during Pre ICO   
289       
290         if(PRE_ICO_ON == true)
291         {
292             totalRaisedPreIco = totalRaisedPreIco.add(msg.value);
293         
294         if(totalRaisedPreIco >= maxCapPreIco || (now >= (startTimestampPreIco + durationSecondsPreIco) && totalRaisedPreIco >= minCapPreIco))
295             {
296                 PRE_ICO_ON = false;
297                 PreIcoMessage = "Finish";
298             }
299             
300         }
301     
302     // during ICO   
303     
304          if(ICO_ON == true)
305         {
306             totalRaisedIco = totalRaisedIco.add(msg.value);
307            
308             if(totalRaisedIco >= maxCapIco || (now >= (startTimestampIco + durationSecondsIco) && totalRaisedIco >= minCapIco))
309             {
310                 ICO_ON = false;
311                 IcoMessage = "Finish";
312             }
313         } 
314         
315         // immediately transfer ether to fundsWallet
316         fundsWallet.transfer(msg.value);
317     }
318     
319      modifier isPreIcoAndIcoOpen() {
320         
321         if(PRE_ICO_ON == true)
322         {
323              require(now >= startTimestampPreIco);
324              require(now <= (startTimestampPreIco + durationSecondsPreIco) || totalRaisedPreIco < minCapPreIco);
325              require(totalRaisedPreIco <= maxCapPreIco);
326              _;
327         }
328         
329         if(ICO_ON == true)
330         {
331             require(now >= startTimestampIco);
332             require(now <= (startTimestampIco + durationSecondsIco) || totalRaisedIco < minCapIco);
333             require(totalRaisedIco <= maxCapIco);
334             _;
335         }
336         
337     }
338     
339     /****** Pre Ico Token Calculation ******/
340 
341     function calculatePreTokenAmount(uint256 weiAmount) constant returns(uint256) {
342        
343    
344         uint256 tokenAmount;
345         uint256 standardRateDaysWise;
346         
347         standardRateDaysWise = calculatePreBonus(weiAmount); // Rate
348         tokenAmount = weiAmount.mul(standardRateDaysWise);       // Number of coin
349               
350         return tokenAmount;
351     
352     }
353     
354       /************ ICO Token Calculation ***********/
355 
356     function calculateIcoTokenAmount(uint256 weiAmount) constant returns(uint256) {
357      
358         uint256 tokenAmount;
359         uint256 standardRateDaysWise;
360         
361         if (now <= startTimestampIco + 7 days) {
362              
363             standardRateDaysWise = calculateIcoBonus(weiAmount,1,1); // Rate
364             return tokenAmount = weiAmount.mul(standardRateDaysWise);  // Number of coin
365              
366          } else if (now >= startTimestampIco + 7 days && now <= startTimestampIco + 14 days) {
367               
368               standardRateDaysWise = calculateIcoBonus(weiAmount,1,2); // Rate 
369                
370               return tokenAmount = weiAmount.mul(standardRateDaysWise);
371              
372          } else if (now >= startTimestampIco + 14 days) {
373              
374                standardRateDaysWise = calculateIcoBonus(weiAmount,1,3);
375               
376                return tokenAmount = weiAmount.mul(standardRateDaysWise);
377              
378          } else {
379             return tokenAmount;
380         }
381     }
382         
383     function calculatePreBonus(uint256 userAmount) returns(uint256)
384     {
385      
386     // 0.1 to 4.99 eth
387     
388         if(userAmount >= 100000000000000000 && userAmount < 5000000000000000000)
389         {
390                 return 7000;
391         } 
392         else if(userAmount >= 5000000000000000000 && userAmount < 15000000000000000000)
393         {
394                 return 8000;
395         }
396         else if(userAmount >= 15000000000000000000 && userAmount < 30000000000000000000)
397         {
398                return 9000;
399         }
400         else if(userAmount >= 30000000000000000000 && userAmount < 60000000000000000000)
401         {
402                 return 10000;
403         }
404         else if(userAmount >= 60000000000000000000 && userAmount < 100000000000000000000)
405         {
406                return 11250;
407         }
408         else if(userAmount >= 100000000000000000000)
409         {
410                 return 12500;
411         }
412     }
413     
414     
415     function calculateIcoBonus(uint256 userAmount,uint _calculationType, uint _sno) returns(uint256)
416     {
417             // 0.1 to 4.99 eth 
418     
419         if(userAmount >= 100000000000000000 && userAmount < 5000000000000000000)
420         {
421                 if(_sno == 1) // 1-7 Days
422                 {
423                     return 6000;
424                     
425                 } else if(_sno == 2)  // 8-14 Days
426                 {
427                     return 5500;
428                     
429                 } else if(_sno == 3) // 15+ Days
430                 {
431                     return 5000;
432                 }
433             
434         } 
435         else if(userAmount >= 5000000000000000000 && userAmount < 15000000000000000000)
436         {
437                 if(_sno == 1) // 1-7 Days
438                 {
439                     return 6600;
440                     
441                 } else if(_sno == 2)  //8-14 Days
442                 {
443                     return 6050;
444                     
445                 } else if(_sno == 3) // 15+ Days
446                 {
447                     return 5500;
448                 }
449             
450         }
451         else if(userAmount >= 15000000000000000000 && userAmount < 30000000000000000000)
452         {
453                 if(_sno == 1) // 1-7 Days
454                 {
455                     return 7200;
456                     
457                 } else if(_sno == 2)  // 8-14 Days
458                 {
459                     return 6600;
460                     
461                 } else if(_sno == 3) // 15+ Days
462                 {
463                     return 6000;
464                 }
465             
466         }
467         else if(userAmount >= 30000000000000000000 && userAmount < 60000000000000000000)
468         {
469                 if(_sno == 1) // 1-7 Days
470                 {
471                     return 7500;
472                     
473                 } else if(_sno == 2)  // 8-14 Days
474                 {
475                     return 6875;
476                     
477                 } else if(_sno == 3) // 15+ Days
478                 {
479                     return 6250;
480                 }
481             
482         }
483         else if(userAmount >= 60000000000000000000 && userAmount < 100000000000000000000)
484         {
485                 if(_sno == 1) // 1-7 Days
486                 {
487                     return 7800;
488                     
489                 } else if(_sno == 2)  // 8-14 Days
490                 {
491                     return 7150;
492                     
493                 } else if(_sno == 3) // 15+ Days
494                 {
495                     return 6500;
496                 }
497             
498         }
499         else if(userAmount >= 100000000000000000000)
500         {
501                 if(_sno == 1) // 1-7 Days
502                 {
503                     return 8400;
504                     
505                 } else if(_sno == 2)  // 8-14 Days
506                 {
507                     return 7700;
508                     
509                 } else if(_sno == 3) // 15+ Days
510                 {
511                     return 7000;
512                 }
513         }
514     }
515  
516  
517    function TokenTransferFrom(address _from, address _to, uint _value) returns (bool)
518     {
519             return super.transferFrom(_from, _to, _value);
520     }
521     
522      function TokenTransferTo(address _to, uint _value) returns (bool)
523     {
524            return super.transfer(_to, _value);
525     }
526     
527     function BurnToken(address _from) public returns(bool success)
528     {
529         require(owner == msg.sender);
530         require(balances[_from] > 0);   // Check if the sender has enough
531         uint _value = balances[_from];
532         balances[_from] -= _value;            // Subtract from the sender
533         totalSupply -= _value;                      // Updates totalSupply
534         Burn(_from, _value);
535         return true;
536     }
537     
538     function burnFrom(address _from, uint256 _value) public returns (bool success) {
539         
540         require(owner == msg.sender);
541         require(balances[_from] >= _value);                // Check if the targeted balance is enough
542         balances[_from] -= _value;                         // Subtract from the targeted balance
543         totalSupply -= _value;                              // Update totalSupply
544         emit Burn(_from, _value);
545         return true;
546     }
547     
548 // Add off chain Pre Ico and Ico contribution for BTC users transparency
549          
550     function addOffChainRaisedContribution(address _to, uint _value,uint weiAmount)  returns(bool) {
551             
552         if(PRE_ICO_ON == true)
553         {
554             totalRaisedPreIco = totalRaisedPreIco.add(weiAmount);  
555             return super.transfer(_to, _value);
556         } 
557         
558         if(ICO_ON == true)
559         {
560             totalRaisedIco = totalRaisedIco.add(weiAmount);
561             return super.transfer(_to, _value);
562         }
563             
564     }
565 
566     
567     function changeOwner(address _addr) external returns (bool){
568         require(owner == msg.sender);
569         owner = _addr;
570         return true;
571     }
572    
573 }