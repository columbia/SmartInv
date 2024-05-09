1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev give an account access to this role
14      */
15     function add(Role storage role, address account) internal {
16         require(account != address(0));
17         require(!has(role, account));
18 
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev remove an account's access to this role
24      */
25     function remove(Role storage role, address account) internal {
26         require(account != address(0));
27         require(has(role, account));
28 
29         role.bearer[account] = false;
30     }
31 
32     /**
33      * @dev check if an account has this role
34      * @return bool
35      */
36     function has(Role storage role, address account) internal view returns (bool) {
37         require(account != address(0));
38         return role.bearer[account];
39     }
40 }
41 
42 /**
43  * @title WhitelistAdminRole
44  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
45  */
46 contract WhitelistAdminRole {
47     using Roles for Roles.Role;
48 
49     event WhitelistAdminAdded(address indexed account);
50     event WhitelistAdminRemoved(address indexed account);
51 
52     Roles.Role private _whitelistAdmins;
53 
54     constructor () internal {
55         _addWhitelistAdmin(msg.sender);
56     }
57 
58     modifier onlyWhitelistAdmin() {
59         require(isWhitelistAdmin(msg.sender));
60         _;
61     }
62 
63     function isWhitelistAdmin(address account) public view returns (bool) {
64         return _whitelistAdmins.has(account);
65     }
66 
67     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
68         _addWhitelistAdmin(account);
69     }
70 
71     function renounceWhitelistAdmin() public {
72         _removeWhitelistAdmin(msg.sender);
73     }
74 
75     function _addWhitelistAdmin(address account) internal {
76         _whitelistAdmins.add(account);
77         emit WhitelistAdminAdded(account);
78     }
79 
80     function _removeWhitelistAdmin(address account) internal {
81         _whitelistAdmins.remove(account);
82         emit WhitelistAdminRemoved(account);
83     }
84 }
85 
86 /**
87  * @title WhitelistedRole
88  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
89  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
90  * it), and not Whitelisteds themselves.
91  */
92 contract WhitelistedRole is WhitelistAdminRole {
93     using Roles for Roles.Role;
94 
95     event WhitelistedAdded(address indexed account);
96     event WhitelistedRemoved(address indexed account);
97 
98     Roles.Role private _whitelisteds;
99 
100     modifier onlyWhitelisted() {
101         require(isWhitelisted(msg.sender));
102         _;
103     }
104 
105     function isWhitelisted(address account) public view returns (bool) {
106         return _whitelisteds.has(account);
107     }
108 
109     function addWhitelisted(address account) public onlyWhitelistAdmin {
110         _addWhitelisted(account);
111     }
112 
113     function removeWhitelisted(address account) public onlyWhitelistAdmin {
114         _removeWhitelisted(account);
115     }
116 
117     function renounceWhitelisted() public {
118         _removeWhitelisted(msg.sender);
119     }
120 
121     function _addWhitelisted(address account) internal {
122         _whitelisteds.add(account);
123         emit WhitelistedAdded(account);
124     }
125 
126     function _removeWhitelisted(address account) internal {
127         _whitelisteds.remove(account);
128         emit WhitelistedRemoved(account);
129     }
130 }
131 
132 contract ERC20 {
133   function totalSupply() public view returns (uint256);
134 
135   function balanceOf(address _who) public view returns (uint256);
136 
137   function allowance(address _owner, address _spender)
138     public view returns (uint256);
139 
140   function transfer(address _to, uint256 _value) public returns (bool);
141 
142   function approve(address _spender, uint256 _value)
143     public returns (bool);
144 
145   function transferFrom(address _from, address _to, uint256 _value)
146     public returns (bool);
147 
148   event Transfer(
149     address indexed from,
150     address indexed to,
151     uint256 value
152   );
153 
154   event Approval(
155     address indexed owner,
156     address indexed spender,
157     uint256 value
158   );
159 }
160 
161 library SafeMath {
162 
163   /**
164   * @dev Multiplies two numbers, reverts on overflow.
165   */
166   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
167     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168     // benefit is lost if 'b' is also tested.
169     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
170     if (_a == 0) {
171       return 0;
172     }
173 
174     uint256 c = _a * _b;
175     require(c / _a == _b);
176 
177     return c;
178   }
179 
180   /**
181   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
182   */
183   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
184     require(_b > 0); // Solidity only automatically asserts when dividing by 0
185     uint256 c = _a / _b;
186     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
187 
188     return c;
189   }
190 
191   /**
192   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
193   */
194   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
195     require(_b <= _a);
196     uint256 c = _a - _b;
197 
198     return c;
199   }
200 
201   /**
202   * @dev Adds two numbers, reverts on overflow.
203   */
204   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
205     uint256 c = _a + _b;
206     require(c >= _a);
207 
208     return c;
209   }
210 
211   /**
212   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
213   * reverts when dividing by zero.
214   */
215   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216     require(b != 0);
217     return a % b;
218   }
219 }
220 
221 library MathFixed {
222 
223   /**
224   * @dev Multiplies two fixed_point numbers.
225   */
226   function mulFixed(uint256 a, uint256 b) internal pure returns (uint256) {
227     return (((a * b) >> 95) + 1) >> 1;
228   }
229 
230   /**
231   * @dev return a^n with fixed_point a, unsinged integer n.
232   * using exponentiation_by_squaring
233   */
234   function powFixed(uint256 a, uint256 n) internal pure returns (uint256){
235     uint256 r = 79228162514264337593543950336; // 1.0  * 2^96
236     while(n > 0){
237       if(n&1 > 0){
238         r = mulFixed(a, r);
239       }
240       a = mulFixed(a, a);
241       n >>= 1;
242     }
243     return r;
244   }
245 }
246 
247 contract TokenBase is ERC20 {
248   using SafeMath for uint256;
249 
250   mapping (address => mapping (address => uint256)) allowed;
251 
252   function allowance(
253     address _owner,
254     address _spender
255    )
256     public
257     view
258     returns (uint256)
259   {
260     return allowed[_owner][_spender];
261   }
262 
263   function approve(address _spender, uint256 _value) public returns (bool) {
264     allowed[msg.sender][_spender] = _value;
265     emit Approval(msg.sender, _spender, _value);
266     return true;
267   }
268 
269   function increaseApproval(
270     address _spender,
271     uint256 _addedValue
272   )
273     public
274     returns (bool)
275   {
276     allowed[msg.sender][_spender] = (
277       allowed[msg.sender][_spender].add(_addedValue));
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282   function decreaseApproval(
283     address _spender,
284     uint256 _subtractedValue
285   )
286     public
287     returns (bool)
288   {
289     uint256 oldValue = allowed[msg.sender][_spender];
290     if (_subtractedValue >= oldValue) {
291       allowed[msg.sender][_spender] = 0;
292     } else {
293       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
294     }
295     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299 }
300 
301 contract WR2Token is TokenBase {
302 
303     WiredToken public wiredToken;
304 
305     string public constant name = "WRD Exodus";
306     string public constant symbol = "WR2";
307     uint8 public constant decimals = 8;
308 
309     constructor() public {
310         wiredToken = WiredToken(msg.sender);
311         emit Transfer(address(0), address(this), 0);
312     }
313 
314     function balanceOf(address _holder) public view returns (uint256) {
315         return wiredToken.lookBalanceWR2(_holder);
316     }
317 
318     function transfer(address _to, uint256 _value) public returns (bool) {
319         require(_to != address(0));
320 
321         wiredToken.transferWR2(msg.sender, _to, _value);
322         emit Transfer(msg.sender, _to, _value);
323         return true;
324     }
325 
326     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
327         require(_to != address(0));
328         require(_value <= allowed[_from][msg.sender]);
329 
330         wiredToken.transferWR2(_from, _to, _value);
331         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
332         emit Transfer(_from, _to, _value);
333         return true;
334     }
335 
336     function totalSupply() public view returns (uint256) {
337         return wiredToken.totalWR2();
338     }
339 
340     function mint(address _holder, uint256 _value) external {
341         require(msg.sender == address(wiredToken));
342         wiredToken.mintWR2(_holder, _value);
343         emit Transfer(address(0), _holder, _value);
344     }
345 
346     function transferByAdmin(address _from, uint256 _value) external {
347         require(wiredToken.isWhitelistAdmin(msg.sender));
348         wiredToken.transferWR2(_from, msg.sender, _value);
349         emit Transfer(_from, msg.sender, _value);
350     }
351 }
352 
353 contract WiredToken is WhitelistedRole, TokenBase {
354     using SafeMath for uint256;
355     using MathFixed for uint256;
356 
357     string public constant name = "WRD Genesis";
358     string public constant symbol = "WRD";
359     uint8 public constant decimals = 8;
360 
361     uint32 constant month = 30 days;
362     uint256 public constant bonusWRDtoWR2 = 316912650057057350374175801; //0.4%
363     uint256 public constant bonusWR2toWRD = 7922816251426433759354395; //0.01%
364     uint256 public initialSupply = uint256(250000000000).mul(uint(10)**decimals);
365 
366     WR2Token public wr2Token;
367     uint256 private totalWRD;
368     uint256 public totalWR2;
369 
370     bool public listing = false;
371     uint256 public launchTime = 9999999999999999999999;
372 
373     mapping(address => uint256) lastUpdate;
374 //    mapping(address => uint256) public startTime;
375     mapping(address => uint256) WRDBalances;
376     mapping(address => uint256) WRDDailyHoldBalances;
377     mapping(address => uint256) WR2Balances;
378     mapping(address => uint256) WR2DailyHoldBalances;
379 
380     mapping(address => uint256) public presaleTokens;
381 
382     uint256 public totalAirdropTokens;
383     uint256 public totalPresaleTokens;
384 
385     constructor() public {
386         wr2Token = new WR2Token();
387 
388         mint(address(this), initialSupply.mul(2).div(10));
389         WRDDailyHoldBalances[address(this)] = initialSupply.mul(2).div(10);
390 
391         mint(msg.sender, initialSupply.mul(8).div(10));
392         WRDDailyHoldBalances[msg.sender] = initialSupply.mul(8).div(10);
393 
394         _addWhitelisted(address(this));
395     }
396 
397     function totalSupply() public view returns (uint) {
398         return totalWRD;
399     }
400 
401     function balanceOf(address _holder) public view returns (uint256) {
402         uint[2] memory arr = lookBonus(_holder);
403         return WRDBalances[_holder].add(arr[0]).sub(lockUpAmount(_holder));
404     }
405 
406     function lookBalanceWR2(address _holder) public view returns (uint256) {
407         uint[2] memory arr = lookBonus(_holder);
408         return WR2Balances[_holder].add(arr[1]);
409     }
410 
411     function lockUpAmount(address _holder) internal view returns (uint) {
412         uint percentage = 100;
413         if (now >= launchTime.add(uint(12).mul(month))) {
414             uint pastMonths = (now.sub(launchTime.add(uint(12).mul(month)))).div(month);
415             percentage = 0;
416             if (pastMonths < 50) {
417                 percentage = uint(100).sub(uint(2).mul(pastMonths));
418             }
419         }
420         return (presaleTokens[_holder]).mul(percentage).div(100);
421     }
422 
423     function transfer(address _to, uint256 _value) public returns (bool) {
424         require(_to != address(0));
425 
426         transferWRD(msg.sender, _to, _value);
427         emit Transfer(msg.sender, _to, _value);
428         return true;
429     }
430 
431     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
432         require(_to != address(0));
433         require(_value <= allowed[_from][msg.sender]);
434 
435         transferWRD(_from, _to, _value);
436         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
437         emit Transfer(_from, _to, _value);
438         return true;
439     }
440 
441     function transferWRD(address _from, address _to, uint256 _value) internal {
442         if (listing) {
443             updateBonus(_from);
444             updateBonus(_to);
445         } else {
446             WRDDailyHoldBalances[_to] = WRDDailyHoldBalances[_to].add(_value);
447         }
448 
449         require(WRDBalances[_from].sub(lockUpAmount(_from)) >= _value);
450 
451         WRDBalances[_from] = WRDBalances[_from].sub(_value);
452         WRDBalances[_to] = WRDBalances[_to].add(_value);
453 
454         WRDDailyHoldBalances[_from] = min(
455             WRDDailyHoldBalances[_from],
456             WRDBalances[_from]
457         );
458     }
459 
460     function transferWR2(address _from, address _to, uint256 _value) external {
461         require(msg.sender == address(wr2Token));
462 
463         if (listing) {
464             updateBonus(_from);
465             updateBonus(_to);
466         } else {
467             WR2DailyHoldBalances[_to] = WR2DailyHoldBalances[_to].add(_value);
468         }
469 
470         require(WR2Balances[_from] >= _value);
471 
472         WR2Balances[_from] = WR2Balances[_from].sub(_value);
473         WR2Balances[_to] = WR2Balances[_to].add(_value);
474 
475 
476         WR2DailyHoldBalances[_from] = min(
477             WR2DailyHoldBalances[_from],
478             WR2Balances[_from]
479         );
480     }
481 
482     function mint(address _holder, uint _value) internal {
483         WRDBalances[_holder] = WRDBalances[_holder].add(_value);
484         totalWRD = totalWRD.add(_value);
485         emit Transfer(address(0), _holder, _value);
486     }
487 
488     function mintWR2(address _holder, uint _value) external {
489         require(msg.sender == address(wr2Token));
490         WR2Balances[_holder] = WR2Balances[_holder].add(_value);
491         totalWR2 = totalWR2.add(_value);
492     }
493 
494     function min(uint a, uint b) internal pure returns (uint) {
495         if(a > b) return b;
496         return a;
497     }
498 
499     function updateBonus(address _holder) internal {
500         uint256 pastDays = now.sub((lastUpdate[_holder].mul(1 days)).add(launchTime)).div(1 days);
501         if (pastDays > 0) {
502             uint256[2] memory arr = lookBonus(_holder);
503 
504             lastUpdate[_holder] = lastUpdate[_holder].add(pastDays);
505             WRDDailyHoldBalances[_holder] = WRDBalances[_holder].add(arr[0]);
506             WR2DailyHoldBalances[_holder] = WR2Balances[_holder].add(arr[1]);
507 
508             if(arr[0] > 0) mint(_holder, arr[0]);
509             if(arr[1] > 0) wr2Token.mint(_holder, arr[1]);
510         }
511     }
512 
513     function lookBonus(address _holder) internal view returns (uint256[2] memory bonuses) {
514         bonuses[0] = 0;
515         bonuses[1] = 0;
516         if (!isBonus(_holder) || !listing ){
517             return bonuses;
518         }
519         uint256 pastDays = (now.sub((lastUpdate[_holder].mul(1 days)).add(launchTime))).div(1 days);
520         if (pastDays == 0){
521             return bonuses;
522         }
523 
524         // X(n+1) = X(n) + A*Y(n), Y(n+1) = B*X(n) + Y(n)
525         // => a := sqrt(A)
526         //    b := sqrt(B)
527         //    c := ((1+ab)^n + (1-ab)^n)/2
528         //    d := ((1+ab)^n - (1-ab)^n)/2
529         //    X(n) = c*X(0) + d*(a/b)*Y(0)
530         //    Y(n) = d*(b/a)*X(0) + c*Y(0)
531 
532         // 1.0 : 79228162514264337593543950336
533         // A = 0.0001, B = 0.004
534         // A : 7922816251426433759354395
535         // a : 792281625142643375935439503
536         // B : 316912650057057350374175801
537         // b : 5010828967500958623728276031
538         // ab : 50108289675009586237282760
539         // 1+ab : 79278270803939347179781233096
540         // 1-ab : 79178054224589328007306667576
541         // a/b : 12527072418752396559320690078
542         // b/a : 501082896750095862372827603139
543 
544         pastDays--;
545         uint256 ratePlus  = (uint256(79278270803939347179781233096)).powFixed(pastDays); // (1+sqrt(ab)) ^ n
546         uint256 rateMinus = (uint256(79178054224589328007306667576)).powFixed(pastDays); // (1-sqrt(ab)) ^ n
547         ratePlus += rateMinus;                 // c*2
548         rateMinus = ratePlus - (rateMinus<<1); // d*2
549         uint256 x0 = WRDBalances[_holder] + WR2DailyHoldBalances[_holder].mulFixed(bonusWR2toWRD);  // x(0)
550         uint256 y0 = WR2Balances[_holder] + WRDDailyHoldBalances[_holder].mulFixed(bonusWRDtoWR2); // y(0)
551         bonuses[0] = ratePlus.mulFixed(x0) + rateMinus.mulFixed(y0).mulFixed(uint256(12527072418752396559320690078));  // x(n)*2
552         bonuses[1] = rateMinus.mulFixed(x0).mulFixed(uint256(501082896750095862372827603139)) + ratePlus.mulFixed(y0); // y(n)*2
553         bonuses[0] = (bonuses[0]>>1) - WRDBalances[_holder]; // x(n) - balance
554         bonuses[1] = (bonuses[1]>>1) - WR2Balances[_holder]; // y(n) - balance
555         return bonuses;
556     }
557 
558     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
559         if(listing) updateBonus(account);
560         _addWhitelistAdmin(account);
561     }
562 
563     function addWhitelisted(address account) public onlyWhitelistAdmin {
564         if(listing) updateBonus(account);
565         _addWhitelisted(account);
566     }
567 
568     function renounceWhitelistAdmin() public {
569         if(listing) updateBonus(msg.sender);
570         _removeWhitelistAdmin(msg.sender);
571     }
572 
573     function removeWhitelisted(address account) public onlyWhitelistAdmin {
574         if(listing) updateBonus(account);
575         _removeWhitelisted(account);
576     }
577 
578     function renounceWhitelisted() public {
579         if(listing) updateBonus(msg.sender);
580         _removeWhitelisted(msg.sender);
581     }
582 
583     function isBonus(address _holder) internal view returns(bool) {
584         return !isWhitelistAdmin(_holder) && !isWhitelisted(_holder);
585     }
586 
587     function startListing() public onlyWhitelistAdmin {
588         require(!listing);
589         launchTime = now;
590         listing = true;
591     }
592 
593     function addAirdropTokens(address[] calldata sender, uint256[] calldata amount) external onlyWhitelistAdmin {
594         require(sender.length > 0 && sender.length == amount.length);
595 
596         for (uint i = 0; i < sender.length; i++) {
597             transferWRD(address(this), sender[i], amount[i]);
598             //send as presaletoken
599             presaleTokens[sender[i]] = presaleTokens[sender[i]].add(amount[i]);
600             totalAirdropTokens = totalAirdropTokens.add(amount[i]);
601             emit Transfer(address(this), sender[i], amount[i]);
602         }
603     }
604 
605     function addPresaleTokens(address[] calldata sender, uint256[] calldata amount) external onlyWhitelistAdmin {
606         require(sender.length > 0 && sender.length == amount.length);
607 
608         for (uint i = 0; i < sender.length; i++) {
609             transferWRD(address(this), sender[i], amount[i]);
610             presaleTokens[sender[i]] = presaleTokens[sender[i]].add(amount[i]);
611             totalPresaleTokens = totalPresaleTokens.add(amount[i]);
612             emit Transfer(address(this), sender[i], amount[i]);
613         }
614     }
615 
616     function addSpecialsaleTokens(address to, uint256 amount) external onlyWhitelisted {
617         transferWRD(msg.sender, to, amount);
618         presaleTokens[to] = presaleTokens[to].add(amount);
619         emit Transfer(msg.sender, to, amount);
620     }
621 
622     function transferByAdmin(address from, uint256 amount) external onlyWhitelistAdmin {
623         transferWRD(from, msg.sender, amount);
624         emit Transfer(from, msg.sender, amount);
625     }
626 }