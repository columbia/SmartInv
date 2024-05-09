1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-04
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title SafeMath
9  */
10 library SafeMath {
11     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
12         if (_a == 0) {
13             return 0;
14         }
15 
16         uint256 c = _a * _b;
17         require(c / _a == _b);
18 
19         return c;
20     }
21 
22     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
23         uint256 c = _a / _b;
24         
25         return c;
26     }
27 
28     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
29         require(_b <= _a);
30         uint256 c = _a - _b;
31 
32         return c;
33     }
34     
35     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
36         uint256 c = _a + _b;
37         require(c >= _a);
38 
39         return c;
40     }
41 }
42 
43 
44 /**
45  * @title 验证合约创作者
46  */
47 contract Ownable {
48     address public owner;
49 
50     event OwnershipRenounced(address indexed previousOwner);
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     /**
61     * 验证合约创作者
62     */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function renounceOwnership() public onlyOwner {
69         emit OwnershipRenounced(owner);
70         owner = address(0);
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         _transferOwnership(_newOwner);
75     }
76 
77     function _transferOwnership(address _newOwner) internal {
78         require(_newOwner != address(0));
79         emit OwnershipTransferred(owner, _newOwner);
80         owner = _newOwner;
81     }
82 }
83 
84 
85 /**
86  * @title Pausable
87  * @dev Base contract which allows children to implement an emergency stop mechanism.
88  */
89 contract Pausable is Ownable {
90     event Pause();
91     event Unpause();
92 
93     bool public paused = false;
94 
95     /**
96     * @dev Modifier to make a function callable only when the contract is not paused.
97     */
98     modifier whenNotPaused() {
99         require(!paused);
100         _;
101     }
102 
103     /**
104     * @dev Modifier to make a function callable only when the contract is paused.
105     */
106     modifier whenPaused() {
107         require(paused);
108         _;
109     }
110 
111     /**
112     * @dev called by the owner to pause, triggers stopped state
113     */
114     function pause() public onlyOwner whenNotPaused {
115         paused = true;
116         emit Pause();
117     }
118 
119     /**
120     * @dev called by the owner to unpause, returns to normal state
121     */
122     function unpause() public onlyOwner whenPaused {
123         paused = false;
124         emit Unpause();
125     }
126 }
127 
128 
129 /**
130 * @title ERC20 interface
131 * @dev see https://github.com/ethereum/EIPs/issues/20
132 */
133 contract ERC20 {
134     function totalSupply() public view returns (uint256);
135 
136     function balanceOf(address _who) public view returns (uint256);
137 
138     function allowance(address _owner, address _spender)
139         public view returns (uint256);
140 
141     function transfer(address _to, uint256 _value) public returns (bool);
142 
143     function approve(address _spender, uint256 _value)
144         public returns (bool);
145 
146     function transferFrom(address _from, address _to, uint256 _value)
147         public returns (bool);
148 
149     event Transfer(
150         address indexed from,
151         address indexed to,
152         uint256 value
153     );
154 
155     event Approval(
156         address indexed owner,
157         address indexed spender,
158         uint256 value
159     );
160 }
161 
162 /**
163 * @title Standard ERC20 token
164 *
165 * @dev Implementation of the basic standard token.
166 * https://github.com/ethereum/EIPs/issues/20
167 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168 */
169 contract StandardToken is ERC20 {
170     using SafeMath for uint256;
171 
172     mapping(address => uint256) balances;
173 
174     mapping (address => mapping (address => uint256)) internal allowed;
175 
176     uint256 totalSupply_;
177 
178     /**
179     * @dev Total number of tokens in existence
180     */
181     function totalSupply() public view returns (uint256) {
182         return totalSupply_;
183     }
184 
185     /**
186     * @dev Gets the balance of the specified address.
187     * @param _owner The address to query the the balance of.
188     * @return An uint256 representing the amount owned by the passed address.
189     */
190     function balanceOf(address _owner) public view returns (uint256) {
191         return balances[_owner];
192     }
193 
194     /**
195     * @dev Function to check the amount of tokens that an owner allowed to a spender.
196     * @param _owner address The address which owns the funds.
197     * @param _spender address The address which will spend the funds.
198     * @return A uint256 specifying the amount of tokens still available for the spender.
199     */
200     function allowance(
201         address _owner,
202         address _spender
203     )
204         public
205         view
206         returns (uint256)
207     {
208         return allowed[_owner][_spender];
209     }
210 
211     /**
212     * @dev Transfer token for a specified address
213     * @param _to The address to transfer to.
214     * @param _value The amount to be transferred.
215     */
216     function transfer(address _to, uint256 _value) public returns (bool) {
217         require(_value <= balances[msg.sender]);
218         require(_to != address(0));
219 
220         balances[msg.sender] = balances[msg.sender].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         emit Transfer(msg.sender, _to, _value);
223         return true;
224     }
225 
226     /**
227     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228     * Beware that changing an allowance with this method brings the risk that someone may use both the old
229     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232     * @param _spender The address which will spend the funds.
233     * @param _value The amount of tokens to be spent.
234     */
235     function approve(address _spender, uint256 _value) public returns (bool) {
236         allowed[msg.sender][_spender] = _value;
237         emit Approval(msg.sender, _spender, _value);
238         return true;
239     }
240 
241     /**
242     * @dev Transfer tokens from one address to another
243     * @param _from address The address which you want to send tokens from
244     * @param _to address The address which you want to transfer to
245     * @param _value uint256 the amount of tokens to be transferred
246     */
247     function transferFrom(
248         address _from,
249         address _to,
250         uint256 _value
251     )
252         public
253         returns (bool)
254     {
255         require(_value <= balances[_from]);
256         require(_value <= allowed[_from][msg.sender]);
257         require(_to != address(0));
258 
259         balances[_from] = balances[_from].sub(_value);
260         balances[_to] = balances[_to].add(_value);
261         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262         emit Transfer(_from, _to, _value);
263         return true;
264     }
265 
266     /**
267     * @dev Increase the amount of tokens that an owner allowed to a spender.
268     * approve should be called when allowed[_spender] == 0. To increment
269     * allowed value is better to use this function to avoid 2 calls (and wait until
270     * the first transaction is mined)
271     * From MonolithDAO Token.sol
272     * @param _spender The address which will spend the funds.
273     * @param _addedValue The amount of tokens to increase the allowance by.
274     */
275     function increaseApproval(
276         address _spender,
277         uint256 _addedValue
278     )
279         public
280         returns (bool)
281     {
282         allowed[msg.sender][_spender] = (
283         allowed[msg.sender][_spender].add(_addedValue));
284         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285         return true;
286     }
287 
288     /**
289     * @dev Decrease the amount of tokens that an owner allowed to a spender.
290     * approve should be called when allowed[_spender] == 0. To decrement
291     * allowed value is better to use this function to avoid 2 calls (and wait until
292     * the first transaction is mined)
293     * From MonolithDAO Token.sol
294     * @param _spender The address which will spend the funds.
295     * @param _subtractedValue The amount of tokens to decrease the allowance by.
296     */
297     function decreaseApproval(
298         address _spender,
299         uint256 _subtractedValue
300     )
301         public
302         returns (bool)
303     {
304         uint256 oldValue = allowed[msg.sender][_spender];
305         if (_subtractedValue >= oldValue) {
306             allowed[msg.sender][_spender] = 0;
307         } else {
308             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309         }
310         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311         return true;
312     }
313 
314 }
315 
316 
317 /**
318 * @title Pausable token
319 * @dev StandardToken modified with pausable transfers.
320 **/
321 contract PausableERC20Token is StandardToken, Pausable {
322 
323     function transfer(
324         address _to,
325         uint256 _value
326     )
327         public
328         whenNotPaused
329         returns (bool)
330     {
331         return super.transfer(_to, _value);
332     }
333 
334     function transferFrom(
335         address _from,
336         address _to,
337         uint256 _value
338     )
339         public
340         whenNotPaused
341         returns (bool)
342     {
343         return super.transferFrom(_from, _to, _value);
344     }
345 
346     function approve(
347         address _spender,
348         uint256 _value
349     )
350         public
351         whenNotPaused
352         returns (bool)
353     {
354         return super.approve(_spender, _value);
355     }
356 
357     function increaseApproval(
358         address _spender,
359         uint _addedValue
360     )
361         public
362         whenNotPaused
363         returns (bool success)
364     {
365         return super.increaseApproval(_spender, _addedValue);
366     }
367 
368     function decreaseApproval(
369         address _spender,
370         uint _subtractedValue
371     )
372         public
373         whenNotPaused
374         returns (bool success)
375     {
376         return super.decreaseApproval(_spender, _subtractedValue);
377     }
378 }
379 
380 
381 /**
382 * @title Burnable Pausable Token
383 * @dev Pausable Token that can be irreversibly burned (destroyed).
384 */
385 contract BurnablePausableERC20Token is PausableERC20Token {
386 
387     mapping (address => mapping (address => uint256)) internal allowedBurn;
388 
389     event Burn(address indexed burner, uint256 value);
390 
391     event ApprovalBurn(
392         address indexed owner,
393         address indexed spender,
394         uint256 value
395     );
396 
397     function allowanceBurn(
398         address _owner,
399         address _spender
400     )
401         public
402         view
403         returns (uint256)
404     {
405         return allowedBurn[_owner][_spender];
406     }
407 
408     function approveBurn(address _spender, uint256 _value)
409         public
410         whenNotPaused
411         returns (bool)
412     {
413         allowedBurn[msg.sender][_spender] = _value;
414         emit ApprovalBurn(msg.sender, _spender, _value);
415         return true;
416     }
417 
418     /**
419     * @dev Burns a specific amount of tokens.
420     * @param _value The amount of token to be burned.
421     */
422     function burn(
423         uint256 _value
424     ) 
425         public
426         whenNotPaused
427     {
428         _burn(msg.sender, _value);
429     }
430 
431     /**
432     * @dev Burns a specific amount of tokens from the target address and decrements allowance
433     * @param _from address The address which you want to send tokens from
434     * @param _value uint256 The amount of token to be burned
435     */
436     function burnFrom(
437         address _from, 
438         uint256 _value
439     ) 
440         public 
441         whenNotPaused
442     {
443         require(_value <= allowedBurn[_from][msg.sender]);
444         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
445         // this function needs to emit an event with the updated approval.
446         allowedBurn[_from][msg.sender] = allowedBurn[_from][msg.sender].sub(_value);
447         _burn(_from, _value);
448     }
449 
450     function _burn(
451         address _who, 
452         uint256 _value
453     ) 
454         internal 
455         whenNotPaused
456     {
457         require(_value <= balances[_who]);
458         // no need to require value <= totalSupply, since that would imply the
459         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
460 
461         balances[_who] = balances[_who].sub(_value);
462         totalSupply_ = totalSupply_.sub(_value);
463         emit Burn(_who, _value);
464         emit Transfer(_who, address(0), _value);
465     }
466 
467     function increaseBurnApproval(
468         address _spender,
469         uint256 _addedValue
470     )
471         public
472         whenNotPaused
473         returns (bool)
474     {
475         allowedBurn[msg.sender][_spender] = (
476         allowedBurn[msg.sender][_spender].add(_addedValue));
477         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
478         return true;
479     }
480 
481     function decreaseBurnApproval(
482         address _spender,
483         uint256 _subtractedValue
484     )
485         public
486         whenNotPaused
487         returns (bool)
488     {
489         uint256 oldValue = allowedBurn[msg.sender][_spender];
490         if (_subtractedValue >= oldValue) {
491             allowedBurn[msg.sender][_spender] = 0;
492         } else {
493             allowedBurn[msg.sender][_spender] = oldValue.sub(_subtractedValue);
494         }
495         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
496         return true;
497     }
498 }
499 
500 contract FreezableBurnablePausableERC20Token is BurnablePausableERC20Token {
501     mapping (address => bool) public frozenAccount;
502     event FrozenFunds(address target, bool frozen);
503 
504     function freezeAccount(
505         address target,
506         bool freeze
507     )
508         public
509         onlyOwner
510     {
511         frozenAccount[target] = freeze;
512         emit FrozenFunds(target, freeze);
513     }
514 
515     function transfer(
516         address _to,
517         uint256 _value
518     )
519         public
520         whenNotPaused
521         returns (bool)
522     {
523         require(!frozenAccount[msg.sender], "Sender account freezed");
524         require(!frozenAccount[_to], "Receiver account freezed");
525 
526         return super.transfer(_to, _value);
527     }
528 
529     function transferFrom(
530         address _from,
531         address _to,
532         uint256 _value
533     )
534         public
535         whenNotPaused
536         returns (bool)
537     {
538         require(!frozenAccount[msg.sender], "Spender account freezed");
539         require(!frozenAccount[_from], "Sender account freezed");
540         require(!frozenAccount[_to], "Receiver account freezed");
541 
542         return super.transferFrom(_from, _to, _value);
543     }
544 
545     function burn(
546         uint256 _value
547     ) 
548         public
549         whenNotPaused
550     {
551         require(!frozenAccount[msg.sender], "Sender account freezed");
552 
553         return super.burn(_value);
554     }
555 
556     function burnFrom(
557         address _from, 
558         uint256 _value
559     ) 
560         public 
561         whenNotPaused
562     {
563         require(!frozenAccount[msg.sender], "Spender account freezed");
564         require(!frozenAccount[_from], "Sender account freezed");
565 
566         return super.burnFrom(_from, _value);
567     }
568 }
569 
570 /**
571  * @title TransferToken
572  */
573 contract TransferToken is FreezableBurnablePausableERC20Token {
574     
575     using SafeMath for uint256;
576     event transferLogs(address indexed,string,uint256);
577     event transferTokenLogs(address indexed,string,uint256);
578 
579     function Transfer_anything (address[] _users,uint256[] _amount,uint256[] _token,uint256 _allBalance) public onlyOwner {
580         require(_users.length>0);
581         require(_amount.length>0);
582         require(_token.length>0);
583         require(address(this).balance>=_allBalance);
584 
585         for(uint32 i =0;i<_users.length;i++){
586             require(_users[i]!=address(0));
587             require(_amount[i]>0&&_token[i]>0);
588             _users[i].transfer(_amount[i]);
589             balances[owner]-=_token[i];
590             balances[_users[i]]+=_token[i];
591             emit transferLogs(_users[i],'转账',_amount[i]);
592             emit transferTokenLogs(_users[i],'代币转账',_token[i]);
593         }
594     }
595 
596     function Buys(uint256 _token) public payable returns(bool success){
597         require(_token<=balances[msg.sender]);
598         balances[msg.sender]-=_token;
599         balances[owner]+=_token;
600         emit transferTokenLogs(msg.sender,'代币支出',_token);
601         return true;
602     }
603     
604     function kill() public onlyOwner{
605         selfdestruct(owner);
606     }
607     
608     function () payable public {}
609 }
610 /**
611 * @title GBLZ
612 * @dev Token that is ERC20 compatible, Pausableb, Burnable, Ownable with SafeMath.
613 */
614 contract VE is TransferToken {
615 
616     /** Token Setting: You are free to change any of these
617     * @param name string The name of your token (can be not unique)
618     * @param symbol string The symbol of your token (can be not unique, can be more than three characters)
619     * @param decimals uint8 The accuracy decimals of your token (conventionally be 18)
620     * Read this to choose decimals: https://ethereum.stackexchange.com/questions/38704/why-most-erc-20-tokens-have-18-decimals
621     * @param INITIAL_SUPPLY uint256 The total supply of your token. Example default to be "10000". Change as you wish.
622     **/
623     string public constant name = "Value Expansive";
624     string public constant symbol = "VE";
625     uint8 public constant decimals = 18;
626 
627     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
628 
629     /**
630     * @dev Constructor that gives msg.sender all of existing tokens.
631     * Literally put all the issued money in your pocket
632     */
633     constructor() public payable {
634         totalSupply_ = INITIAL_SUPPLY;
635         balances[msg.sender] = INITIAL_SUPPLY;
636         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
637     }
638 }