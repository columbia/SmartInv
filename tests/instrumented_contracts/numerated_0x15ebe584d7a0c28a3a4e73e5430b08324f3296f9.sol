1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function balanceOf(address who) external view returns (uint256);
12 
13   function allowance(address owner, address spender)
14     external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value)
19     external returns (bool);
20 
21   function transferFrom(address from, address to, uint256 value)
22     external returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 /**
38  * @title ERC20Detailed token
39  * @dev The decimals are only for visualization purposes.
40  * All the operations are done using the smallest and indivisible token unit,
41  * just as on Ethereum all the operations are done in wei.
42  */
43 contract ERC20Detailed is IERC20 {
44   string private _name;
45   string private _symbol;
46   uint8 private _decimals;
47 
48   constructor(string name, string symbol, uint8 decimals) public {
49     _name = name;
50     _symbol = symbol;
51     _decimals = decimals;
52   }
53 
54   /**
55    * @return the name of the token.
56    */
57   function name() public view returns(string) {
58     return _name;
59   }
60 
61   /**
62    * @return the symbol of the token.
63    */
64   function symbol() public view returns(string) {
65     return _symbol;
66   }
67 
68   /**
69    * @return the number of decimals of the token.
70    */
71   function decimals() public view returns(uint8) {
72     return _decimals;
73   }
74 }
75 
76 
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that revert on error
81  */
82 library SafeMath {
83 
84   /**
85   * @dev Multiplies two numbers, reverts on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89     // benefit is lost if 'b' is also tested.
90     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91     if (a == 0) {
92       return 0;
93     }
94 
95     uint256 c = a * b;
96     require(c / a == b);
97 
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b > 0); // Solidity only automatically asserts when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109     return c;
110   }
111 
112   /**
113   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
114   */
115   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116     require(b <= a);
117     uint256 c = a - b;
118 
119     return c;
120   }
121 
122   /**
123   * @dev Adds two numbers, reverts on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     require(c >= a);
128 
129     return c;
130   }
131 
132   /**
133   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
134   * reverts when dividing by zero.
135   */
136   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137     require(b != 0);
138     return a % b;
139   }
140 }
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
147  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract ERC20 is IERC20 {
150   using SafeMath for uint256;
151 
152   mapping (address => uint256) private _balances;
153 
154   mapping (address => mapping (address => uint256)) private _allowed;
155 
156   uint256 private _totalSupply;
157 
158   /**
159   * @dev Total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return _totalSupply;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param owner The address to query the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address owner) public view returns (uint256) {
171     return _balances[owner];
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param owner address The address which owns the funds.
177    * @param spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(
181     address owner,
182     address spender
183    )
184     public
185     view
186     returns (uint256)
187   {
188     return _allowed[owner][spender];
189   }
190 
191   /**
192   * @dev Transfer token for a specified address
193   * @param to The address to transfer to.
194   * @param value The amount to be transferred.
195   */
196   function transfer(address to, uint256 value) public returns (bool) {
197     _transfer(msg.sender, to, value);
198     return true;
199   }
200 
201   /**
202    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param spender The address which will spend the funds.
208    * @param value The amount of tokens to be spent.
209    */
210   function approve(address spender, uint256 value) public returns (bool) {
211     require(spender != address(0));
212 
213     _allowed[msg.sender][spender] = value;
214     emit Approval(msg.sender, spender, value);
215     return true;
216   }
217 
218   /**
219    * @dev Transfer tokens from one address to another
220    * @param from address The address which you want to send tokens from
221    * @param to address The address which you want to transfer to
222    * @param value uint256 the amount of tokens to be transferred
223    */
224   function transferFrom(
225     address from,
226     address to,
227     uint256 value
228   )
229     public
230     returns (bool)
231   {
232     require(value <= _allowed[from][msg.sender]);
233 
234     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
235     _transfer(from, to, value);
236     return true;
237   }
238 
239   /**
240    * @dev Increase the amount of tokens that an owner allowed to a spender.
241    * approve should be called when allowed_[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param spender The address which will spend the funds.
246    * @param addedValue The amount of tokens to increase the allowance by.
247    */
248   function increaseAllowance(
249     address spender,
250     uint256 addedValue
251   )
252     public
253     returns (bool)
254   {
255     require(spender != address(0));
256 
257     _allowed[msg.sender][spender] = (
258       _allowed[msg.sender][spender].add(addedValue));
259     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    * approve should be called when allowed_[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param spender The address which will spend the funds.
270    * @param subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseAllowance(
273     address spender,
274     uint256 subtractedValue
275   )
276     public
277     returns (bool)
278   {
279     require(spender != address(0));
280 
281     _allowed[msg.sender][spender] = (
282       _allowed[msg.sender][spender].sub(subtractedValue));
283     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
284     return true;
285   }
286 
287   /**
288   * @dev Transfer token for a specified addresses
289   * @param from The address to transfer from.
290   * @param to The address to transfer to.
291   * @param value The amount to be transferred.
292   */
293   function _transfer(address from, address to, uint256 value) internal {
294     require(value <= _balances[from]);
295     require(to != address(0));
296 
297     _balances[from] = _balances[from].sub(value);
298     _balances[to] = _balances[to].add(value);
299     emit Transfer(from, to, value);
300   }
301 
302   /**
303    * @dev Internal function that mints an amount of the token and assigns it to
304    * an account. This encapsulates the modification of balances such that the
305    * proper events are emitted.
306    * @param account The account that will receive the created tokens.
307    * @param value The amount that will be created.
308    */
309   function _mint(address account, uint256 value) internal {
310     require(account != 0);
311     _totalSupply = _totalSupply.add(value);
312     _balances[account] = _balances[account].add(value);
313     emit Transfer(address(0), account, value);
314   }
315 
316   /**
317    * @dev Internal function that burns an amount of the token of a given
318    * account.
319    * @param account The account whose tokens will be burnt.
320    * @param value The amount that will be burnt.
321    */
322   function _burn(address account, uint256 value) internal {
323     require(account != 0);
324     require(value <= _balances[account]);
325 
326     _totalSupply = _totalSupply.sub(value);
327     _balances[account] = _balances[account].sub(value);
328     emit Transfer(account, address(0), value);
329   }
330 
331   /**
332    * @dev Internal function that burns an amount of the token of a given
333    * account, deducting from the sender's allowance for said account. Uses the
334    * internal burn function.
335    * @param account The account whose tokens will be burnt.
336    * @param value The amount that will be burnt.
337    */
338   function _burnFrom(address account, uint256 value) internal {
339     require(value <= _allowed[account][msg.sender]);
340 
341     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
342     // this function needs to emit an event with the updated approval.
343     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
344       value);
345     _burn(account, value);
346   }
347 }
348 
349 library CommUtils{
350 
351  
352     uint256 constant MAX_MUL_BASE = 340282366920939000000000000000000000000;
353 
354 
355     function abs(uint256 a,uint256 b) internal pure returns(uint256){
356         return a>b ? a-b : b-a;
357     }
358 
359    
360     function mult(uint256 a, uint256 b) 
361         internal 
362         pure 
363         returns (uint256 c) 
364     {
365         if (a == 0) {
366             return 0;
367         }
368         c = a * b;
369         require(c / a == b, "SafeMath mul failed");
370         return c;
371     }    
372 
373     function pwr(uint256 x, uint256 y)
374         internal 
375         pure 
376         returns (uint256)
377     {
378         if (x==0)
379             return (0);
380         else if (y==0)
381             return (1);
382         else 
383         {
384             uint256 z = x;
385             for (uint256 i=1; i < y; i++)
386                 z = mult(z,x);
387             return (z);
388         }
389     }
390 
391 
392     function mulRate(uint256 tar,uint256 rate) public pure returns (uint256){
393         return tar *rate / 100;
394     }  
395     
396     function mulRate1000(uint256 tar,uint256 rate) public pure returns (uint256){
397         return tar *rate / 1000;
398     }  
399     
400     
401     /**
402      * @dev filters name strings
403      * -converts uppercase to lower case.  
404      * -makes sure it does not start/end with a space
405      * -makes sure it does not contain multiple spaces in a row
406      * -cannot be only numbers
407      * -cannot start with 0x 
408      * -restricts characters to A-Z, a-z, 0-9, and space.
409      * @return reprocessed string in bytes32 format
410      */
411     function nameFilter(string _input)
412         internal
413         pure
414         returns(bytes32)
415     {
416         bytes memory _temp = bytes(_input);
417         uint256 _length = _temp.length;
418         
419         //sorry limited to 32 characters
420         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
421         // make sure it doesnt start with or end with space
422         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
423         // make sure first two characters are not 0x
424         if (_temp[0] == 0x30)
425         {
426             require(_temp[1] != 0x78, "string cannot start with 0x");
427             require(_temp[1] != 0x58, "string cannot start with 0X");
428         }
429         
430         // create a bool to track if we have a non number character
431         bool _hasNonNumber;
432         
433         // convert & check
434         for (uint256 i = 0; i < _length; i++)
435         {
436             // if its uppercase A-Z
437             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
438             {
439                 // convert to lower case a-z
440                 _temp[i] = byte(uint(_temp[i]) + 32);
441                 
442                 // we have a non number
443                 if (_hasNonNumber == false)
444                     _hasNonNumber = true;
445             } else {
446                 require
447                 (
448                     // require character is a space
449                     _temp[i] == 0x20 || 
450                     // OR lowercase a-z
451                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
452                     // or 0-9
453                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
454                     "string contains invalid characters"
455                 );
456                 // make sure theres not 2x spaces in a row
457                 if (_temp[i] == 0x20)
458                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
459                 
460                 // see if we have a character other than a number
461                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
462                     _hasNonNumber = true;    
463             }
464         }
465         
466         require(_hasNonNumber == true, "string cannot be only numbers");
467         
468         bytes32 _ret;
469         assembly {
470             _ret := mload(add(_temp, 32))
471         }
472         return (_ret);
473     }   
474     
475     function isStringEmpty(string str) internal pure returns(bool){
476         bytes memory tempEmptyStringTest = bytes(str); 
477         return tempEmptyStringTest.length == 0;
478     }
479      
480     
481     
482     
483     
484     struct Float{
485         uint256 number;
486         uint256 digits;
487     }
488     
489     function initFloat(uint256 v,uint256 denominator) internal pure returns(Float){
490         return Float(v*denominator,denominator);
491     }
492     
493     
494     function pow(Float f ,uint256 count) internal pure returns(Float ans){
495 
496         if (count==0){
497             return Float(10,1);
498         }
499         ans.number = f.number;
500         ans.digits = f.digits;
501         for(uint256 i=1;i<count;i++){
502             ans = multiply(ans,f);
503         }
504     }
505     
506     function decrease(Float f,Float o) internal pure returns(bool ok,Float ans){
507         sameDigits(f,o);
508         require(f.digits == o.digits,"it`s must same sameDigits");
509         if(f.number >= o.number ){
510             ok = true;            
511             ans.number = f.number - o.number;
512             ans.digits = f.digits;
513         }
514     }
515     
516     function increase(Float f,Float o) internal pure returns(Float ans){
517         sameDigits(f,o);
518         require(f.digits == o.digits,"it`s must same sameDigits");
519         ans.number = f.number+o.number;
520         ans.digits = f.digits;
521     }
522     
523     function sameDigits(Float f,Float o) private pure {
524         return f.digits > o.digits ? _sameDigits(f,o) : _sameDigits(o,f) ;
525     }
526     
527     function _sameDigits(Float big,Float small ) private pure {
528         uint256 dd = big.digits - small.digits;
529         small.number = small.number * pwr(10,dd);
530         small.digits = big.digits;
531     }
532     
533     function multiSafe(uint256 a,uint256 b) internal pure returns (uint256 ans,uint256 ap,uint256 bp){
534         (uint256 newA, uint256 apow)  = powDown(a);
535         (uint256 newB, uint256 bpow)  = powDown(b);
536         ans = mult(newA , newB);
537         ap = apow;
538         bp = bpow;
539     }
540     
541     function powDown(uint256 a) internal pure returns(uint256 newA,uint256 pow10){
542         newA = a;
543         while(newA>=MAX_MUL_BASE){
544             pow10++;
545             newA /= 10;
546         }
547     }
548     
549     function multiply(Float  f,Float o) internal pure returns(Float ans){
550         (uint256 v,uint256 ap,uint256 bp ) = multiSafe(f.number,o.number);
551         ans.number = v;  
552         ans.digits = f.digits+o.digits-(ap+bp);
553     }
554     
555     function multiply(Float  f,uint256 tar) internal pure returns(Float ans){
556         (uint256 v,uint256 ap,uint256 bp ) = multiSafe(f.number,tar);
557         ans.number = v;
558         ans.digits = f.digits-(ap+bp);
559     }    
560     
561     function divide(Float f,Float o) internal pure returns(Float ans){
562        if(f.digits >= o.digits){
563            ans.digits = f.digits - o.digits;
564        }else{
565            uint256 dp = o.digits - f.digits;
566            ans.digits = 0;
567            ans.number = mult( f.number , pwr(10,dp));
568        }
569         ans.number = ans.number / o.number;
570     }
571     
572     function toUint256(Float f) internal pure returns(uint256 ans){
573         ans = f.number;
574         for(uint256 i=0;i<f.digits;i++){
575             ans /= 10;
576         }
577     }
578     
579     function getIntegral(Float exCoefficient,uint256 xb,uint256 tokenDigits,uint256 X_POW) internal pure returns(uint256 ){
580         CommUtils.Float memory x = CommUtils.Float(xb,tokenDigits);
581         Float memory xPow = pow(x,X_POW+1);
582         Float memory ec = pow(exCoefficient,X_POW);
583         Float memory tempAns = multiply(xPow,ec);
584         return toUint256(tempAns)/(X_POW+1); 
585     }   
586     
587     
588     
589     struct Countdown{
590         uint128 max;
591         uint128 current;
592         uint256 timestamp;
593         uint256 period;
594         bool passing;
595     }
596     
597     function freshAndCheck(Countdown  d,uint256 curP,uint256 max,uint256 period) view internal returns(Countdown){
598         if(d.timestamp == 0) {
599             d=Countdown( uint128( max),0,  now,period , true);
600         }  
601         if(now - d.timestamp > period){
602           d= Countdown( uint128( max),0,now,period,true);  
603         } 
604         d.current += uint128(curP);
605         d.passing = d.current <= d.max;
606         return d;
607     }    
608     
609     
610 }
611 
612 
613 
614 library Player{
615 
616     using CommUtils for string;
617     using CommUtils for CommUtils.Countdown;
618     uint256 public constant BONUS_INTERVAL = 60*60*24*7;
619     
620     
621     struct Map{
622         mapping(address=>uint256) bonusAt;
623         mapping(address=>uint256) ethMap;
624         mapping(address=>address) referrerMap;
625         mapping(address=>bytes32) addrNameMap;
626         mapping(bytes32=>address) nameAddrMap;
627         mapping(address=>CommUtils.Countdown) sellLimeMap;
628     }
629     
630     function remove(Map storage ps,address adr) internal{
631         //transferAuthor(ps.ethMap[adr]);
632         delete ps.ethMap[adr];
633         bytes32 b = ps.addrNameMap[adr];
634         delete ps.nameAddrMap[b];
635         delete ps.addrNameMap[adr];
636     }
637     
638     function deposit(Map storage  ps,address adr,uint256 v) internal returns(uint256) {
639        ps.ethMap[adr]+=v;
640         return v;
641     }
642     
643     
644 
645 
646 
647     function refleshBonusAt(Map storage  ps,address addr,uint256 allCount,uint256 plusCount) internal{
648         if(ps.bonusAt[addr] == 0)        {
649             ps.bonusAt[addr] = now;
650             return;
651         }
652         uint256 plsuAt = BONUS_INTERVAL * plusCount / allCount;
653         ps.bonusAt[addr] += plsuAt;
654         ps.bonusAt[addr] = ps.bonusAt[addr] > now ? now : ps.bonusAt[addr];
655     }
656     
657     
658     
659     function isOverBonusAt(Map storage ps,address addr) internal returns(bool ){
660         if( (ps.bonusAt[addr] - now)> BONUS_INTERVAL){
661             ps.bonusAt[addr] = now;
662             return true;
663         }
664         return false;
665     }
666     
667     function transferSafe(address addr,uint256 v) internal {
668         if(address(this).balance>=v){
669             addr.transfer(v);
670         }else{
671             addr.transfer( address(this).balance);
672         }
673     }
674     
675 
676     function minus(Map storage  ps,address adr,uint256 num) internal  {
677         uint256 sum = ps.ethMap[adr];
678         if(sum==num){
679              withdrawalAll(ps,adr);
680         }else{
681             require(sum > num);
682             ps.ethMap[adr] = sum-num;
683         }
684     }
685     
686     function minusAndTransfer(Map storage  ps,address adr,uint256 num) internal  {
687         minus(ps,adr,num);
688         transferSafe(adr,num);
689     }    
690     
691     function withdrawalAll(Map storage  ps,address adr) public returns(uint256) {
692         uint256 sum = ps.ethMap[adr];
693         delete ps.ethMap[adr];
694         return sum;
695     }
696     
697     function getAmmount(Map storage ps,address adr) public view returns(uint256) {
698         return ps.ethMap[adr];
699     }
700     
701     function registerName(Map storage ps,bytes32 _name)internal  {
702         require(ps.nameAddrMap[_name] == address(0) );
703         ps.nameAddrMap[_name] = msg.sender;
704         ps.addrNameMap[msg.sender] = _name;
705     }
706     
707     function isEmptyName(Map storage ps,bytes32 _name) public view returns(bool) {
708         return ps.nameAddrMap[_name] == address(0);
709     }
710     
711     function getByName(Map storage ps,bytes32 _name)public view returns(address) {
712         return ps.nameAddrMap[_name] ;
713     }
714     
715     function getName(Map storage ps) public view returns(bytes32){
716         return ps.addrNameMap[msg.sender];
717     }
718     
719     function getName(Map storage ps,address adr) public view returns(bytes32){
720         return ps.addrNameMap[adr];
721     }    
722     
723     function getNameByAddr(Map storage ps,address adr) public view returns(bytes32){
724         return ps.addrNameMap[adr];
725     }    
726     
727     function getReferrer(Map storage ps,address adr)public view returns(address){
728         address refA = ps.referrerMap[adr];
729         bytes32 b= ps.addrNameMap[refA];
730         return b.length == 0 ? getReferrer(ps,refA) : refA;
731     }
732     
733     function getReferrerName(Map storage ps,address adr)public view returns(bytes32){
734         return getNameByAddr(ps,getReferrer(ps,adr));
735     }
736     
737     function setReferrer(Map storage ps,address self,address referrer)internal {
738          ps.referrerMap[self] = referrer;
739     }
740     
741     function applyReferrer(Map storage ps,string referrer)internal {
742         bytes32 rbs = referrer.nameFilter();
743         address referrerAdr = getByName(ps,rbs);
744         require(referrerAdr != address(0),"referrerAdr is null");
745         require(getReferrer(ps,msg.sender) == address(0) ,"must reffer is null");
746         require(referrerAdr != msg.sender ,"referrerAdr is self ");
747         require(getName(ps).length==0 || getName(ps) == bytes32(0),"must not reqester");
748         setReferrer(ps,msg.sender,referrerAdr);
749     }    
750     
751     
752     function checkSellLimt(Map storage ps,uint256 curP,uint256 max,uint256 period)  internal returns(CommUtils.Countdown) {
753         CommUtils.Countdown storage cd =  ps.sellLimeMap[msg.sender];
754         ps.sellLimeMap[msg.sender] = cd.freshAndCheck(curP,max,period);
755         return ps.sellLimeMap[msg.sender];
756     }   
757     
758     function getSellLimt(Map storage ps) internal view returns (CommUtils.Countdown ) {
759         return ps.sellLimeMap[msg.sender];
760     }
761     
762     
763     
764 }
765 
766 
767 contract IOE is  ERC20, ERC20Detailed {
768     
769     using CommUtils for CommUtils.Countdown;
770     using CommUtils for CommUtils.Float;
771     using CommUtils for string;
772     using Player for Player.Map;
773     
774     
775 
776     uint256 private constant MAX_BUY_BY_USER_RATE = 3;
777     uint256 private constant MAX_SELL_BY_USER_RATE = 10;
778     uint256 private constant MAX_SELL_PER_USER_RATE = 25;
779     uint256 private constant SELL_BUY_PERIOD= 60*60*24;
780     uint256 private constant tokenDigits = 9;
781     uint256 private constant tokenM = 1000000000;
782     uint256 private constant INITIAL_SUPPLY = 100000000 * tokenM;
783     uint256 private constant X_POW = 2; // y= (exCoefficient * x)^X_POW
784     uint256 private constant BUY_BONUS_IN_1000 = 80;
785     uint256 private constant SELL_BONUS_IN_1000 = 100;
786     uint256 private constant REGESTER_FEE = 0.02 ether;
787     uint256 private constant VIP_DISCOUNT_WEIGHT = 3;
788     uint256 private constant VIP_INTTO_POOL_WEIGHT = 3;
789     uint256 private constant VIP_TOUP_WEIGHT = 3;
790     uint256 private constant VIP_RETOUP_RATE_1000 = 110;
791     uint256 private constant HELP_MINING_BUY_1000 = 30;
792     uint256 private constant HELP_MINING_SELL_1000 = 50;
793     uint256 private constant VIP_ALL_WEIGHT = VIP_DISCOUNT_WEIGHT+VIP_INTTO_POOL_WEIGHT+VIP_TOUP_WEIGHT;
794 
795     address private OFFICIAL_ADDR ;
796     uint256 private constant MIN_TX_ETHER = 0.001 ether;
797     uint256 private providedCount =0;
798     uint256 private vipPool = 0;
799     Player.Map private players;
800     CommUtils.Float exCoefficient;
801     CommUtils.Countdown private buyByUserCD ;
802     CommUtils.Countdown private sellByUserCD ;
803     
804 
805     /**
806      * @dev Constructor that gives msg.sender all of existing tokens.
807      */
808     constructor (address oa) public   ERC20Detailed("INTELLIGENT OPERATING SYSTEM EXCHANGE", "IOE",9) {
809         _mint(this, INITIAL_SUPPLY);
810         require(CommUtils.pwr(10,tokenDigits) == tokenM,"it`s not same tokenM");
811         exCoefficient = CommUtils.Float(1224744871,8);
812         OFFICIAL_ADDR = oa;
813     } 
814     
815     
816     function getInfo() public view returns(
817             uint256, //constractBlance
818             uint256, //current providedCount count
819             uint256,   // selfTokenBlance
820             uint256,  //bounus pool
821             uint256,   // contract now
822             uint256,    // bonusAt
823             bytes32, // registeredName
824             bytes32, // refname
825             uint256,   //VIP Reward
826             address   //offAdd
827         ){
828         return (
829             address(this).balance,
830             providedCount, 
831             balanceOf(msg.sender),
832             getBonusPool(),
833             now,
834             players.bonusAt[msg.sender],
835             players.getName(),
836             players.getReferrerName(msg.sender),
837             players.getAmmount(msg.sender),
838             OFFICIAL_ADDR
839         );
840     }
841     
842     function getLimtInfo() public view returns(
843         uint256 buyMax,uint256 buyCur,uint256 buyStartAt,
844         uint256 sellMax , uint256 sellCur , uint256 sellStartAt,
845         uint256 sellPerMax, uint256 sellCurPer , uint256 sellPerStartAt
846     ){
847         CommUtils.Countdown memory bCD = buyByUserCD.freshAndCheck(0,CommUtils.mulRate(INITIAL_SUPPLY-providedCount,MAX_BUY_BY_USER_RATE),SELL_BUY_PERIOD);
848         buyMax = bCD.max;
849         buyCur = bCD.current;
850         buyStartAt = bCD.timestamp;
851         CommUtils.Countdown memory sCD  = sellByUserCD.freshAndCheck(0,CommUtils.mulRate(providedCount,MAX_SELL_BY_USER_RATE),SELL_BUY_PERIOD);
852         sellMax = sCD.max;
853         sellCur = sCD.current;
854         sellStartAt = sCD.timestamp;
855         CommUtils.Countdown memory perCD = players.getSellLimt().freshAndCheck(0,CommUtils.mulRate(balanceOf(msg.sender),MAX_SELL_PER_USER_RATE),SELL_BUY_PERIOD);
856         sellPerMax = perCD.max;
857         sellCurPer = perCD.current;
858         sellPerStartAt = perCD.timestamp;
859     }
860     
861     
862     
863     function applyReferrer(string referrer) private {
864         if(referrer.isStringEmpty()) return;
865         players.applyReferrer(referrer);
866     }
867     
868     function getBuyMinPow(uint256 eth) view public  returns(uint256 pow, uint256 current,uint256 valuePowNum,uint256 valuePowDig){
869         pow = X_POW+1;
870         current = providedCount;
871         CommUtils.Float memory x2Pow = CommUtils.Float(providedCount,tokenDigits).pow(X_POW+1);
872         CommUtils.Float memory rr = exCoefficient.pow(X_POW);
873         CommUtils.Float memory V3 = CommUtils.Float((X_POW+1) * eth,0);
874         CommUtils.Float memory LEFT = V3.divide(rr);
875         CommUtils.Float memory value = LEFT.increase( x2Pow);
876         valuePowNum = value.number;
877         valuePowDig = value.digits;
878     }
879     
880     function getSellMinPow(uint256 eth) view public  returns(uint256 pow, uint256 current,uint256 valuePowNum,uint256 valuePowDig){
881         pow = X_POW+1;
882         current = providedCount;
883         CommUtils.Float memory x2Pow = CommUtils.Float(providedCount,tokenDigits).pow(X_POW+1);
884         CommUtils.Float memory rr = exCoefficient.pow(X_POW);
885         CommUtils.Float memory V3 = CommUtils.Float((X_POW+1) * eth,0);
886         CommUtils.Float memory LEFT = V3.divide(rr);
887         (bool ok,CommUtils.Float memory _value) = x2Pow.decrease(LEFT);
888         CommUtils.Float memory value = ok ? _value : CommUtils.Float(current,tokenDigits).pow(pow);
889         valuePowNum = value.number;
890         valuePowDig = value.digits;
891     }    
892     
893     
894     function getIntegralAtBound(uint256 start,uint256 end) view public  returns(uint256){
895         require(end>start,"must end > start");
896         uint256 endI = exCoefficient.getIntegral(end,tokenDigits,X_POW);
897         uint256 startI = exCoefficient.getIntegral(start,tokenDigits,X_POW);
898         require(endI > startI ,"it`s endI  Integral > startI");
899         return endI - startI;
900     }
901     
902     function buyByUser(uint256 count,string referrer)   public payable {
903         buyByUserCD = buyByUserCD.freshAndCheck(count,CommUtils.mulRate(INITIAL_SUPPLY-providedCount,MAX_BUY_BY_USER_RATE),SELL_BUY_PERIOD);
904         require(buyByUserCD.passing ,"it`s over buy max count");
905         applyReferrer(referrer);
906         uint256 all = providedCount+count;
907         require(all<= INITIAL_SUPPLY,"count over INITIAL_SUPPLY");
908         uint256 costEth = getIntegralAtBound(providedCount,providedCount+count);
909         uint256 reqEth = costEth * (1000+BUY_BONUS_IN_1000) / 1000;
910         require(msg.value >= reqEth,"not enough eth");
911         bonusFee(costEth,reqEth);
912         providedCount = all;
913         uint256 helpM = CommUtils.mulRate1000(count,HELP_MINING_BUY_1000);
914         _transfer(this,msg.sender,count-helpM);
915          _transfer(this,OFFICIAL_ADDR,helpM);
916         players.refleshBonusAt(msg.sender,balanceOf(msg.sender),count);
917         emit OnDealed (msg.sender,true,count,providedCount); 
918     }
919     
920     function sellByUser(uint256 count,string referrer)   public  {
921         require(providedCount >= count ,"count over providedCount ");
922         sellByUserCD = sellByUserCD.freshAndCheck(count,CommUtils.mulRate(providedCount,MAX_SELL_BY_USER_RATE),SELL_BUY_PERIOD);
923         require(sellByUserCD.passing ,"it`s over sell max count");
924         require(players.checkSellLimt(count,CommUtils.mulRate(balanceOf(msg.sender),MAX_SELL_PER_USER_RATE),SELL_BUY_PERIOD).passing,"SELL over per user count");
925         applyReferrer(referrer);
926         uint256 helpM = CommUtils.mulRate1000(count,HELP_MINING_SELL_1000);
927         uint256 realCount = (count-helpM);
928         uint256 start = providedCount-realCount;
929         uint256 end = providedCount;
930         uint256 reqEth = getIntegralAtBound(start,end);
931         uint256 costEth = reqEth * (1000- SELL_BONUS_IN_1000) / 1000;
932         providedCount -= realCount;
933         bonusFee(costEth,reqEth);
934         transfer(this,count);
935          _transfer(this,OFFICIAL_ADDR,helpM);
936         emit OnDealed (msg.sender,false,count,providedCount); 
937         Player.transferSafe(msg.sender,costEth);
938     }
939     
940     function bonusFee(uint256 costEth,uint256 reqEth) private {
941         address referrer = players.getReferrer(msg.sender);
942         bool unreged = players.getName().length==0 || players.getName() == bytes32(0);
943         if(unreged && referrer==address(0)) return;
944         if(reqEth < costEth ) return ;
945         uint256 orgFee = reqEth - costEth;
946         uint256 repay = orgFee * VIP_DISCOUNT_WEIGHT / VIP_ALL_WEIGHT;
947         uint256 toUp = orgFee * VIP_TOUP_WEIGHT / VIP_ALL_WEIGHT;
948        // uint256 inPool = orgFee -(repay+toUp);
949         players.deposit(msg.sender,repay);
950         vipPool += repay;
951         if(referrer != address(0)){
952             players.deposit(referrer,toUp);
953             vipPool += toUp;
954         }
955     }    
956     
957     /*  @override  */  
958     function transferFrom(address from,address to,uint256 value)public returns (bool){
959         players.refleshBonusAt(to,balanceOf(to),value);
960         return super.transferFrom(from,to,value);
961     }    
962     
963     /*  @override  */
964     function transfer(address to, uint256 value) public returns (bool) {
965         players.refleshBonusAt(to,balanceOf(to),value);
966         return super.transfer(to,value);
967     }    
968     
969     function getStockBlance() view private returns(uint256){
970         return exCoefficient.getIntegral(providedCount,tokenDigits,X_POW);
971     }
972     
973     function getBonusPool() view private returns(uint256){
974         return address(this).balance - (getStockBlance()+ vipPool);
975     }    
976 
977     function withdrawalBunos(address[] adrs) public  {
978         if(adrs.length == 0){
979             withdrawalBunos(msg.sender);
980         }else{
981             for(uint256 i=0;i<adrs.length;i++){
982                 withdrawalBunos(adrs[i]);
983             }
984         }
985     }
986     
987     
988     function withdrawalBunos(address adr) private {
989         bool b = players.isOverBonusAt(adr) ;
990         if(!b) return;
991         uint256 bonus = getBonusPool() * balanceOf(adr) / providedCount;
992         Player.transferSafe(adr,bonus);
993     }    
994     
995     function withdrawalVipReward() public  {
996         uint256 reward = players.withdrawalAll(msg.sender);
997         uint256 toUp = CommUtils.mulRate1000(reward,VIP_RETOUP_RATE_1000);
998         uint256 realReward =reward- toUp;
999         vipPool -= realReward;
1000         Player.transferSafe(msg.sender,realReward);
1001         address referrer = players.getReferrer(msg.sender);
1002         if(referrer != address(0)){
1003             players.deposit(referrer,toUp);
1004         }else{
1005             vipPool -= toUp;
1006         }
1007     }    
1008     
1009     
1010     function isEmptyName(string _n) public view returns(bool){
1011         return players.isEmptyName(_n.nameFilter());
1012     }     
1013     
1014     function registerName(string name)  public  payable {
1015         require(msg.value >= REGESTER_FEE,"fee not enough");
1016         players.registerName(name.nameFilter());
1017     }     
1018 
1019     // function testWithdrawalAll()  public {
1020     //     msg.sender.transfer(address( this).balance);
1021     // }
1022     
1023 
1024     event OnDealed(
1025         address who,
1026         bool buyed,
1027         uint256 ammount,
1028         uint256 newProvidedCount
1029     );
1030 
1031 
1032 }