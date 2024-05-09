1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      **/
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19     
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      **/
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29     
30     /**
31      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      **/
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37     
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      **/
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title ERC20Basic interface
50  * @dev Basic ERC20 interface
51  **/
52 contract ERC20Basic {
53     function totalSupply() public view returns (uint256);
54     function balanceOf(address who) public view returns (uint256);
55     function transfer(address to, uint256 value) public returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  **/
63 contract ERC20 is ERC20Basic {
64     function allowance(address owner, address spender) public view returns (uint256);
65     function transferFrom(address from, address to, uint256 value) public returns (bool);
66     function approve(address spender, uint256 value) public returns (bool);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  **/
74 contract BasicToken is ERC20Basic {
75     using SafeMath for uint256;
76     mapping(address => uint256) balances;
77     uint256 totalSupply_;
78     
79     /**
80      * @dev total number of tokens in existence
81      **/
82     function totalSupply() public view returns (uint256) {
83         return totalSupply_;
84     }
85     
86     /**
87      * @dev transfer token for a specified address
88      * @param _to The address to transfer to.
89      * @param _value The amount to be transferred.
90      **/
91     function transfer(address _to, uint256 _value) public returns (bool) {
92         require(_to != address(0));
93         require(_value <= balances[msg.sender]);
94         
95         balances[msg.sender] = balances[msg.sender].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         emit Transfer(msg.sender, _to, _value);
98         return true;
99     }
100     
101     /**
102      * @dev Gets the balance of the specified address.
103      * @param _owner The address to query the the balance of.
104      * @return An uint256 representing the amount owned by the passed address.
105      **/
106     function balanceOf(address _owner) public view returns (uint256) {
107         return balances[_owner];
108     }
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112     mapping (address => mapping (address => uint256)) internal allowed;
113     /**
114      * @dev Transfer tokens from one address to another
115      * @param _from address The address which you want to send tokens from
116      * @param _to address The address which you want to transfer to
117      * @param _value uint256 the amount of tokens to be transferred
118      **/
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120         require(_to != address(0));
121         require(_value <= balances[_from]);
122         require(_value <= allowed[_from][msg.sender]);
123     
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         
128         emit Transfer(_from, _to, _value);
129         return true;
130     }
131     
132     /**
133      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134      *
135      * Beware that changing an allowance with this method brings the risk that someone may use both the old
136      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
137      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
138      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139      * @param _spender The address which will spend the funds.
140      * @param _value The amount of tokens to be spent.
141      **/
142     function approve(address _spender, uint256 _value) public returns (bool) {
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147     
148     /**
149      * @dev Function to check the amount of tokens that an owner allowed to a spender.
150      * @param _owner address The address which owns the funds.
151      * @param _spender address The address which will spend the funds.
152      * @return A uint256 specifying the amount of tokens still available for the spender.
153      **/
154     function allowance(address _owner, address _spender) public view returns (uint256) {
155         return allowed[_owner][_spender];
156     }
157     
158     /**
159      * @dev Increase the amount of tokens that an owner allowed to a spender.
160      *
161      * approve should be called when allowed[_spender] == 0. To increment
162      * allowed value is better to use this function to avoid 2 calls (and wait until
163      * the first transaction is mined)
164      * From MonolithDAO Token.sol
165      * @param _spender The address which will spend the funds.
166      * @param _addedValue The amount of tokens to increase the allowance by.
167      **/
168     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
169         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173     
174     /**
175      * @dev Decrease the amount of tokens that an owner allowed to a spender.
176      *
177      * approve should be called when allowed[_spender] == 0. To decrement
178      * allowed value is better to use this function to avoid 2 calls (and wait until
179      * the first transaction is mined)
180      * From MonolithDAO Token.sol
181      * @param _spender The address which will spend the funds.
182      * @param _subtractedValue The amount of tokens to decrease the allowance by.
183      **/
184     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         } else {
189             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190         }
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 }
195 
196 /**
197  * @title Ownable
198  * @dev The Ownable contract has an owner address, and provides basic authorization control
199  * functions, this simplifies the implementation of "user permissions".
200  **/
201 contract Ownable {
202     address public owner;
203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205     /**
206      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
207      **/
208    constructor() public {
209       owner = msg.sender;
210     }
211     
212     /**
213      * @dev Throws if called by any account other than the owner.
214      **/
215     modifier onlyOwner() {
216       require(msg.sender == owner);
217       _;
218     }
219     
220     /**
221      * @dev Allows the current owner to transfer control of the contract to a newOwner.
222      * @param newOwner The address to transfer ownership to.
223      **/
224     function transferOwnership(address newOwner) public onlyOwner {
225       require(newOwner != address(0));
226       emit OwnershipTransferred(owner, newOwner);
227       owner = newOwner;
228     }
229 }
230 
231 /**
232  * @title Pausable
233  * @dev The Pausable contract has control functions to pause and unpause token transfers
234  **/
235 contract Pausable is Ownable {
236     event Pause();
237     event Unpause();
238     
239     bool public canPause = true;
240     bool public paused = false;
241 
242 
243     /**
244      * @dev Modifier to make a function callable only when the contract is not paused.
245      **/
246     modifier whenNotPaused() {
247         require(!paused || msg.sender == owner);
248         _;
249     }
250     
251     /**
252      * @dev Modifier to make a function callable only when the contract is paused.
253      **/
254     modifier whenPaused() {
255         require(paused);
256         _;
257     }
258     
259     /**
260      * @dev called by the owner to pause, triggers stopped state
261      **/
262     function pause() onlyOwner whenNotPaused public {
263         require(canPause == true);
264         paused = true;
265         emit Pause();
266     }
267     
268     /**
269      * @dev called by the owner to unpause, returns to normal state
270      **/
271     function unpause() onlyOwner whenPaused public {
272         paused = false;
273         emit Unpause();
274     }
275     
276     /**
277      * @dev Prevent the token from ever being paused again
278      **/
279     function notPauseable() onlyOwner public{
280         paused = false;
281         canPause = false;
282     }
283 }
284 
285 /**
286  * @title Pausable token
287  * @dev StandardToken modified with pausable transfers.
288  **/
289 contract PausableToken is StandardToken, Pausable {
290     /**
291      * @dev Prevent the token from ever being paused again
292      **/
293     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
294         return super.transfer(_to, _value);
295     }
296     
297     /**
298      * @dev transferFrom function to tansfer tokens when token is not paused
299      **/
300     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
301         return super.transferFrom(_from, _to, _value);
302     }
303     
304     /**
305      * @dev approve spender when not paused
306      **/
307     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
308         return super.approve(_spender, _value);
309     }
310     
311     /**
312      * @dev increaseApproval of spender when not paused
313      **/
314     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
315         return super.increaseApproval(_spender, _addedValue);
316     }
317     
318     /**
319      * @dev decreaseApproval of spender when not paused
320      **/
321     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
322         return super.decreaseApproval(_spender, _subtractedValue);
323     }
324 }
325 
326 /**
327  * @title Configurable
328  * @dev Configurable varriables of the contract
329  **/
330 contract Configurable {
331     uint256 public constant cap = 1000000000*10**18;
332     uint256 public constant preSaleFirstCap = 25000000*10**18;
333     uint256 public constant preSaleSecondCap = 175000000*10**18; // 25,000,000 + 150,000,000
334     uint256 public constant preSaleThirdCap = 325000000*10**18; // 25,000,000 + 150,000,000 + 150,000,000
335     uint256 public constant preSaleFourthCap = 425000000*10**18; // 25,000,000 + 150,000,000 + 150,000,000 + 100,000,000
336     uint256 public constant privateLimit = 200000000*10**18;
337     uint256 public constant basePrice = 2777777777777777777778; // tokens per 1 ether
338     uint256 public constant preSaleDiscountPrice = 11111111111111111111111; // pre sale 1 stage > 10 ETH or pre sale private discount 75% tokens per 1 ether
339     uint256 public constant preSaleFirstPrice = 5555555555555555555556; // pre sale 1 stage < 10 ETH discount 50%, tokens per 1 ether
340     uint256 public constant preSaleSecondPrice = 5555555555555555555556; // pre sale 2 stage discount 50%, tokens per 1 ether
341     uint256 public constant preSaleThirdPrice = 4273504273504273504274; // pre sale 3 stage discount 35%, tokens per 1 ether
342     uint256 public constant preSaleFourthPrice = 3472222222222222222222; // pre sale 4 stage discount 20%, tokens per 1 ether
343     uint256 public constant privateDiscountPrice = 7936507936507936507937; // sale private discount 65%, tokens per 1 ether
344     uint256 public privateSold = 0;
345     
346     uint256 public icoStartDate = 0;
347     uint256 public constant timeToBeBurned = 1 years;
348     uint256 public constant companyReserve = 1000000000*10**18;
349     uint256 public remainingTokens = 0;
350     bool public icoFinalized = false;
351     uint256 public icoEnd = 0; 
352     uint256 public maxAmmount = 1000 ether; // maximum investment allowed
353     uint256 public minContribute = 0.1 ether; // Minimum investment allowed
354     uint256 public constant preSaleStartDate = 1525046400; // 30/04/2018 00:00:00
355     
356     //custom variables for private and public events
357     uint256 public privateEventTokens = 0;
358     uint256 public publicEventTokens = 0;
359     bool public privateEventActive = false;
360     bool public publicEventActive = false;
361     uint256 public publicMin = 0;
362     uint256 public privateMin = 0;
363     uint256 public privateRate = 0;
364     uint256 public publicRate = 0;
365 }
366 
367 /**
368  * @title CrowdsaleToken 
369  * @dev Contract to preform crowd sale with token
370  **/
371 contract CrowdsaleToken is PausableToken, Configurable {
372     /**
373      * @dev enum of current crowd sale state
374      **/
375      enum Stages {
376         preSale, 
377         pause, 
378         sale, 
379         icoEnd
380     }
381   
382     Stages currentStage;
383     mapping(address => bool) saleDiscountList; // 65% private discount
384     mapping(address => bool) customPrivateSale; // Private discount for events
385     
386     /**
387      * @dev constructor of CrowdsaleToken
388      **/
389     constructor() public {
390         currentStage = Stages.preSale;
391         pause();
392         balances[owner] = balances[owner].add(companyReserve);
393         totalSupply_ = totalSupply_.add(companyReserve);
394         emit Transfer(address(this), owner, companyReserve);
395     }
396     
397     /**
398      * @dev fallback function to send ether to for Crowd sale
399      **/
400     function () public payable {
401         require(msg.value >= minContribute);
402         require(preSaleStartDate < now);
403         require(currentStage != Stages.pause);
404         require(currentStage != Stages.icoEnd);
405         require(msg.value > 0);
406         uint256[] memory tokens = tokensAmount(msg.value);
407         require (tokens[0] > 0);
408         balances[msg.sender] = balances[msg.sender].add(tokens[0]);
409         totalSupply_ = totalSupply_.add(tokens[0]);
410         require(totalSupply_ <= cap.add(companyReserve));
411         emit Transfer(address(this), msg.sender, tokens[0]);
412         uint256 ethValue = msg.value.sub(tokens[1]);
413         owner.transfer(ethValue);
414         if(tokens[1] > 0){
415             msg.sender.transfer(tokens[1]);
416             emit Transfer(address(this), msg.sender, tokens[1]);
417         }
418     }
419     
420     
421     /**
422      * @dev tokensAmount calculates the amount of tokens the sender is purchasing 
423      **/
424     function tokensAmount (uint256 _wei) internal returns (uint256[]) {
425         uint256[] memory tokens = new uint256[](7);
426         tokens[0] = tokens[1] = 0;
427         uint256 stageWei = 0;
428         uint256 stageTokens = 0;
429         uint256 stagePrice = 0;
430         uint256 totalSold = totalSupply_.sub(companyReserve);
431         uint256 extraWei = 0;
432         bool ismember = false;
433         
434         // if sender sent more then maximum spending amount
435         if(_wei > maxAmmount){
436             extraWei = _wei.sub(maxAmmount);
437             _wei = maxAmmount;
438         }
439         
440         // if member is part of a private sale event
441        if(customPrivateSale[msg.sender] == true && msg.value >= privateMin && privateEventActive == true && privateEventTokens > 0){
442             stagePrice = privateRate;
443             stageTokens = _wei.mul(stagePrice).div(1 ether);
444            
445             if(stageTokens <= privateEventTokens){
446                 tokens[0] = tokens[0].add(stageTokens);
447                 privateEventTokens = privateEventTokens.sub(tokens[0]);
448                 
449                 if(extraWei > 0){
450                     tokens[1] = extraWei;
451                     //emit Transfer(address(this), msg.sender, extraWei);
452                 }
453                 
454                 return tokens;
455             } else {
456                 stageTokens = privateEventTokens;
457                 privateEventActive = false;
458                 stageWei = stageTokens.mul(1 ether).div(stagePrice);
459                 tokens[0] = tokens[0].add(stageTokens);
460                 privateEventTokens = privateEventTokens.sub(tokens[0]);
461                 _wei = _wei.sub(stageWei);
462             }
463         }
464         
465         // private member 
466         if (totalSold > preSaleFirstCap && privateSold <= privateLimit && saleDiscountList[msg.sender]) {
467             stagePrice = privateDiscountPrice; // private member %65 discount
468           
469           stageTokens = _wei.mul(stagePrice).div(1 ether);
470           
471           if (privateSold.add(tokens[0]).add(stageTokens) <= privateLimit) {
472             tokens[0] = tokens[0].add(stageTokens);
473             
474             if(extraWei > 0){
475                 tokens[1] = extraWei;
476             }
477             totalSold = totalSold.add(tokens[0]);
478             privateSold = privateSold.add(tokens[0]);
479             return tokens;
480           } else {
481             stageTokens = privateLimit.sub(privateSold);
482             privateSold = privateSold.add(stageTokens);
483             stageWei = stageTokens.mul(1 ether).div(stagePrice);
484             tokens[0] = tokens[0].add(stageTokens);
485             _wei = _wei.sub(stageWei);
486           }
487         }
488         
489          // if public event is active and tokens available
490         if(publicEventActive == true && publicEventTokens > 0 && msg.value >= publicMin) {
491             stagePrice = publicRate;
492             stageTokens = _wei.mul(stagePrice).div(1 ether);
493            
494             if(stageTokens <= publicEventTokens){
495                 tokens[0] = tokens[0].add(stageTokens);
496                 publicEventTokens = publicEventTokens.sub(tokens[0]);
497                 
498                 if(extraWei > 0){
499                     tokens[1] = stageWei;
500                     //emit Transfer(address(this), msg.sender, extraWei);
501                 }
502                 
503                 return tokens;
504             } else {
505                 stageTokens = publicEventTokens;
506                 publicEventActive = false;
507                 stageWei = stageTokens.mul(1 ether).div(stagePrice);
508                 tokens[0] = tokens[0].add(stageTokens);
509                 publicEventTokens = publicEventTokens.sub(tokens[0]);
510                 _wei = _wei.sub(stageWei);
511             }
512         }
513         
514         
515         // 75% discount
516         if (currentStage == Stages.preSale && totalSold <= preSaleFirstCap) {
517           if (msg.value >= 10 ether) 
518             stagePrice = preSaleDiscountPrice;
519           else {
520               if (saleDiscountList[msg.sender]) {
521                   ismember = true;
522                 stagePrice = privateDiscountPrice; // private member %65 discount
523               }
524             else
525                 stagePrice = preSaleFirstPrice;
526           }
527             
528             stageTokens = _wei.mul(stagePrice).div(1 ether);
529           
530           if (totalSold.add(stageTokens) <= preSaleFirstCap) {
531             tokens[0] = tokens[0].add(stageTokens);
532             
533             if(extraWei > 0){
534                 tokens[1] = extraWei;
535             }
536             return tokens;
537           }
538             else if( ismember && totalSold.add(stageTokens) <= privateLimit) {
539                 tokens[0] = tokens[0].add(stageTokens);
540                 privateSold = privateSold.sub(tokens[0]);
541             
542             if(extraWei > 0){
543                 tokens[1] = extraWei;
544             }
545             return tokens;
546             
547           } else {
548             stageTokens = preSaleFirstCap.sub(totalSold);
549             stageWei = stageTokens.mul(1 ether).div(stagePrice);
550             tokens[0] = tokens[0].add(stageTokens);
551             if(ismember)
552                 privateSold = privateSold.sub(tokens[0]);
553             _wei = _wei.sub(stageWei);
554           }
555         }
556         
557         // 50% discount
558         if (currentStage == Stages.preSale && totalSold.add(tokens[0]) <= preSaleSecondCap) {
559               stagePrice = preSaleSecondPrice; 
560 
561           stageTokens = _wei.mul(stagePrice).div(1 ether);
562           
563           if (totalSold.add(tokens[0]).add(stageTokens) <= preSaleSecondCap) {
564             tokens[0] = tokens[0].add(stageTokens);
565             
566             if(extraWei > 0){
567                 tokens[1] = extraWei;
568             }
569         
570             return tokens;
571           } else {
572             stageTokens = preSaleSecondCap.sub(totalSold).sub(tokens[0]);
573             stageWei = stageTokens.mul(1 ether).div(stagePrice);
574             tokens[0] = tokens[0].add(stageTokens);
575             _wei = _wei.sub(stageWei);
576           }
577         }
578         
579         // 35% discount
580         if (currentStage == Stages.preSale && totalSold.add(tokens[0]) <= preSaleThirdCap) {
581             stagePrice = preSaleThirdPrice;
582           stageTokens = _wei.mul(stagePrice).div(1 ether);
583           
584           if (totalSold.add(tokens[0]).add(stageTokens) <= preSaleThirdCap) {
585             tokens[0] = tokens[0].add(stageTokens);
586            
587             if(extraWei > 0){
588                 tokens[1] = extraWei;
589             }
590         
591             return tokens;
592           } else {
593             stageTokens = preSaleThirdCap.sub(totalSold).sub(tokens[0]);
594             stageWei = stageTokens.mul(1 ether).div(stagePrice);
595             tokens[0] = tokens[0].add(stageTokens);
596             _wei = _wei.sub(stageWei);
597           }
598         }
599         // 20% discount
600         if (currentStage == Stages.preSale && totalSold.add(tokens[0]) <= preSaleFourthCap) {
601             stagePrice = preSaleFourthPrice;
602           
603           stageTokens = _wei.mul(stagePrice).div(1 ether);
604           
605           if (totalSold.add(tokens[0]).add(stageTokens) <= preSaleFourthCap) {
606             tokens[0] = tokens[0].add(stageTokens);
607             
608             if(extraWei > 0){
609                 tokens[1] = extraWei;
610             }
611         
612             return tokens;
613           } else {
614             stageTokens = preSaleFourthCap.sub(totalSold).sub(tokens[0]);
615             stageWei = stageTokens.mul(1 ether).div(stagePrice);
616             tokens[0] = tokens[0].add(stageTokens);
617             _wei = _wei.sub(stageWei);
618             currentStage = Stages.pause;
619             
620             if(_wei > 0 || extraWei > 0){
621                 _wei = _wei.add(extraWei);
622                 tokens[1] = _wei;
623             }
624             return tokens;
625           }
626         }
627         
628         // 0% discount
629         if (currentStage == Stages.sale) {
630           if (privateSold > privateLimit && saleDiscountList[msg.sender]) {
631             stagePrice = privateDiscountPrice; // private member %65 discount
632             stageTokens = _wei.mul(stagePrice).div(1 ether);
633             uint256 ceil = totalSold.add(privateLimit);
634             
635             if (ceil > cap) {
636               ceil = cap;
637             }
638             
639             if (totalSold.add(stageTokens) <= ceil) {
640               tokens[0] = tokens[0].add(stageTokens);
641              
642               if(extraWei > 0){
643                tokens[1] = extraWei;
644             }
645             privateSold = privateSold.sub(tokens[0]);
646               return tokens;          
647             } else {
648               stageTokens = ceil.sub(totalSold);
649               tokens[0] = tokens[0].add(stageTokens);
650               stageWei = stageTokens.mul(1 ether).div(stagePrice);
651               _wei = _wei.sub(stageWei);
652             }
653             
654             if (ceil == cap) {
655               endIco();
656               if(_wei > 0 || extraWei > 0){
657                 _wei = _wei.add(extraWei);
658                 tokens[1] = _wei;
659               }
660               privateSold = privateSold.sub(tokens[0]);
661               return tokens;
662             }
663           }
664           
665           stagePrice = basePrice;
666           stageTokens = _wei.mul(stagePrice).div(1 ether);
667           
668           if (totalSold.add(tokens[0]).add(stageTokens) <= cap) {
669             tokens[0] = tokens[0].add(stageTokens);
670             
671             if(extraWei > 0){
672                 tokens[1] = extraWei;
673             }
674         
675                 
676             return tokens;
677           } else {
678             stageTokens = cap.sub(totalSold).sub(tokens[0]);
679             stageWei = stageTokens.mul(1 ether).div(stagePrice);
680             tokens[0] = tokens[0].add(stageTokens);
681             _wei = _wei.sub(stageWei);
682             endIco();
683             
684             if(_wei > 0 || extraWei > 0){
685                 _wei = _wei.add(extraWei);
686                 tokens[1] = _wei;
687             }
688             return tokens;
689           }      
690         }
691     }
692 
693     /**
694      * @dev startIco starts the public ICO
695      **/
696     function startIco() public onlyOwner {
697         require(currentStage != Stages.icoEnd);
698         currentStage = Stages.sale;
699         icoStartDate = now;
700     }
701     
702     /**
703      * @dev Sets either custom public or private sale events. 
704      * @param tokenCap : the amount of toknes to cap the event with
705      * @param eventRate : the discounted price of the event given in amount per ether
706      * @param isActive : boolean that stats is the event is active or not
707      * @param eventType : string that says is the event is public or private
708      **/
709     function setCustomEvent(uint256 tokenCap, uint256 eventRate, bool isActive, string eventType, uint256 minAmount) public onlyOwner {
710         require(tokenCap > 0);
711         require(eventRate > 0);
712         require(minAmount > 0);
713         
714         if(compareStrings(eventType, "private")){
715             privateEventTokens = tokenCap;
716             privateRate = eventRate;
717             privateEventActive = isActive;
718             privateMin = minAmount;
719         }
720         else if(compareStrings(eventType, "public")){
721             publicEventTokens = tokenCap;
722             publicRate = eventRate;
723             publicEventActive = isActive;
724             publicMin = minAmount;
725         }
726         else
727             require(1==2);
728     }
729     
730     /**
731      * @dev function to compare two strings for equality
732      **/
733     function compareStrings (string a, string b) internal pure returns (bool){
734        return keccak256(a) == keccak256(b);
735    }
736     
737     /**
738      * @dev setEventActive sets the private presale discount members address
739      **/
740     function setEventActive (bool isActive, string eventType) public onlyOwner {
741         // Turn private event on/off
742         if(compareStrings(eventType, "private"))
743             privateEventActive = isActive;
744         // Turn public event on or off
745         else if(compareStrings(eventType, "public"))
746             publicEventActive = isActive;
747         else
748             require(1==2);
749     }
750 
751     /**
752      * @dev setMinMax function to set the minimum or maximum investment amount 
753      **/
754     function setMinMax (uint256 minMax, string eventType) public onlyOwner {
755         require(minMax >= 0);
756         // Set new maxAmmount
757         if(compareStrings(eventType, "max"))
758             maxAmmount = minMax;
759         // Set new min to Contribute
760         else if(compareStrings(eventType,"min"))
761             minContribute = minMax;
762         else
763             require(1==2);
764     }
765 
766     /**
767      * @dev function to set the discount member as active or not for one of the 4 events
768      * @param _address : address of the member
769      * @param memberType : specifying if the member should belong to private sale, pre sale, private event or public event
770      * @param isActiveMember : bool to set the member at active or not
771      **/
772     function setDiscountMember(address _address, string memberType, bool isActiveMember) public onlyOwner {
773         // Set discount sale member    
774         if(compareStrings(memberType, "preSale"))
775             saleDiscountList[_address] = isActiveMember;
776         // Set private event member
777         else if(compareStrings(memberType,"privateEvent"))
778             customPrivateSale[_address] = isActiveMember;
779         else
780             require(1==2);
781     }
782     
783     /**
784      * @dev checks if an address is a member of a specific address
785      * @param _address : address of member to check
786      * @param memberType : member type to check: preSlae, privateEvent
787      **/
788     function isMemberOf(address _address, string memberType) public view returns (bool){
789         // Set discount sale member    
790         if(compareStrings(memberType, "preSale"))
791             return saleDiscountList[_address];
792         // Set private event member
793         else if(compareStrings(memberType,"privateEvent"))
794             return customPrivateSale[_address];
795         else
796             require(1==2);
797     }
798 
799     /**
800      * @dev endIco closes down the ICO 
801      **/
802     function endIco() internal {
803         currentStage = Stages.icoEnd;
804     }
805 
806     /**
807      * @dev withdrawFromRemainingTokens allows the owner of the contract to withdraw 
808      * remaining unsold tokens for acquisitions. Any remaining tokens after 1 year from
809      * ICO end time will be burned.
810      **/
811     function withdrawFromRemainingTokens(uint256 _value) public onlyOwner returns(bool) {
812         require(currentStage == Stages.icoEnd);
813         require(remainingTokens > 0);
814         
815         // if 1 year after ICO, Burn all remaining tokens
816         if (now > icoEnd.add(timeToBeBurned)) 
817             remainingTokens = 0;
818         
819         // If tokens remain, withdraw
820         if (_value <= remainingTokens) {
821             balances[owner] = balances[owner].add(_value);
822             totalSupply_ = totalSupply_.add(_value);
823             remainingTokens = remainingTokens.sub(_value);
824             emit Transfer(address(this), owner, _value);
825             return true;
826           }
827           return false;
828     }
829 
830     /**
831      * @dev finalizeIco closes down the ICO and sets needed varriables
832      **/
833     function finalizeIco() public onlyOwner {
834         require(!icoFinalized);
835             icoFinalized = true;
836         
837         if (currentStage != Stages.icoEnd){
838              endIco();
839              icoEnd = now;
840         }
841         
842         remainingTokens = cap.add(companyReserve).sub(totalSupply_);
843         owner.transfer(address(this).balance);
844     }
845     
846     /**
847      * @dev function to get the current discount rate
848      **/
849     function currentBonus() public view returns (string) {
850         if(totalSupply_.sub(companyReserve) < preSaleFirstCap)
851             return "300% Bonus!";
852         else if((totalSupply_.sub(companyReserve) < preSaleSecondCap) && (totalSupply_.sub(companyReserve) > preSaleFirstCap))
853             return "100% Bonus!";
854         else if((totalSupply_.sub(companyReserve) < preSaleThirdCap) && (totalSupply_.sub(companyReserve) > preSaleSecondCap))
855             return "54% Bonus!";
856         else if((totalSupply_.sub(companyReserve) < preSaleFourthCap) && (totalSupply_.sub(companyReserve) > preSaleThirdCap))
857             return "25% Bonus!";
858         else
859             return "No Bonus... Sorry...#BOTB";
860     }
861 }
862 
863 /**
864  * @title KimeraToken 
865  * @dev Contract to create the Kimera Token
866  **/
867 contract KimeraToken is CrowdsaleToken {
868     string public constant name = "KIMERACoin";
869     string public constant symbol = "KIMERA";
870     uint32 public constant decimals = 18;
871 }