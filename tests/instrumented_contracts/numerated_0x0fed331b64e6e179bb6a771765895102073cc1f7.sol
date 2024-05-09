1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract Ownable {
37 
38     address public owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44      * account.
45      */
46     function Ownable() public {
47         owner = msg.sender;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         require(newOwner != address(0));
64         OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66     }
67 }
68 
69 /**
70  * @title Finalizable
71  * @dev Base contract to finalize some features
72  */
73 contract Finalizable is Ownable {
74     event Finish();
75 
76     bool public finalized = false;
77 
78     function finalize() public onlyOwner {
79         finalized = true;
80     }
81 
82     modifier notFinalized() {
83         require(!finalized);
84         _;
85     }
86 }
87 
88 /**
89  * @title Part of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract IToken {
93     function balanceOf(address who) public view returns (uint256);
94 
95     function transfer(address to, uint256 value) public returns (bool);
96 }
97 
98 /**
99  * @title Token Receivable
100  * @dev Support transfer of ERC20 tokens out of this contract's address
101  * @dev Even if we don't intend for people to send them here, somebody will
102  */
103 contract TokenReceivable is Ownable {
104     event logTokenTransfer(address token, address to, uint256 amount);
105 
106     function claimTokens(address _token, address _to) public onlyOwner returns (bool) {
107         IToken token = IToken(_token);
108         uint256 balance = token.balanceOf(this);
109         if (token.transfer(_to, balance)) {
110             logTokenTransfer(_token, _to, balance);
111             return true;
112         }
113         return false;
114     }
115 }
116 
117 contract EventDefinitions {
118     event Transfer(address indexed from, address indexed to, uint256 value);
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120     event Mint(address indexed to, uint256 amount);
121     event Burn(address indexed burner, uint256 value);
122 }
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract Token is Finalizable, TokenReceivable, EventDefinitions {
132     using SafeMath for uint256;
133 
134     string public name = "FairWin Token";
135     uint8 public decimals = 8;
136     string public symbol = "FWIN";
137 
138     Controller controller;
139 
140     // message of the day
141     string public motd;
142 
143     function setController(address _controller) public onlyOwner notFinalized {
144         controller = Controller(_controller);
145     }
146 
147     modifier onlyController() {
148         require(msg.sender == address(controller));
149         _;
150     }
151 
152     modifier onlyPayloadSize(uint256 numwords) {
153         assert(msg.data.length >= numwords * 32 + 4);
154         _;
155     }
156 
157     /**
158      * @dev Gets the balance of the specified address.
159      * @param _owner The address to query the the balance of.
160      * @return An uint256 representing the amount owned by the passed address.
161      */
162     function balanceOf(address _owner) public view returns (uint256) {
163         return controller.balanceOf(_owner);
164     }
165 
166     function totalSupply() public view returns (uint256) {
167         return controller.totalSupply();
168     }
169 
170     /**
171      * @dev transfer token for a specified address
172      * @param _to The address to transfer to.
173      * @param _value The amount to be transferred.
174      */
175     function transfer(address _to, uint256 _value) public
176     onlyPayloadSize(2)
177     returns (bool success) {
178         success = controller.transfer(msg.sender, _to, _value);
179         if (success) {
180             Transfer(msg.sender, _to, _value);
181         }
182     }
183 
184     /**
185      * @dev Transfer tokens from one address to another
186      * @param _from address The address which you want to send tokens from
187      * @param _to address The address which you want to transfer to
188      * @param _value uint256 the amount of tokens to be transferred
189      */
190     function transferFrom(address _from, address _to, uint256 _value) public
191     onlyPayloadSize(3)
192     returns (bool success) {
193         success = controller.transferFrom(msg.sender, _from, _to, _value);
194         if (success) {
195             Transfer(_from, _to, _value);
196         }
197     }
198 
199     /**
200      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201      *
202      * Beware that changing an allowance with this method brings the risk that someone may use both the old
203      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206      * @param _spender The address which will spend the funds.
207      * @param _value The amount of tokens to be spent.
208      */
209     function approve(address _spender, uint256 _value) public
210     onlyPayloadSize(2)
211     returns (bool success) {
212         //promote safe user behavior
213         require(controller.allowance(msg.sender, _spender) == 0);
214 
215         success = controller.approve(msg.sender, _spender, _value);
216         if (success) {
217             Approval(msg.sender, _spender, _value);
218         }
219         return true;
220     }
221 
222     /**
223      * @dev Increase the amount of tokens that an owner allowed to a spender.
224      *
225      * approve should be called when allowed[_spender] == 0. To increment
226      * allowed value is better to use this function to avoid 2 calls (and wait until
227      * the first transaction is mined)
228      * From MonolithDAO Token.sol
229      * @param _spender The address which will spend the funds.
230      * @param _addedValue The amount of tokens to increase the allowance by.
231      */
232     function increaseApproval(address _spender, uint256 _addedValue) public
233     onlyPayloadSize(2)
234     returns (bool success) {
235         success = controller.increaseApproval(msg.sender, _spender, _addedValue);
236         if (success) {
237             uint256 newValue = controller.allowance(msg.sender, _spender);
238             Approval(msg.sender, _spender, newValue);
239         }
240     }
241 
242     /**
243      * @dev Decrease the amount of tokens that an owner allowed to a spender.
244      *
245      * approve should be called when allowed[_spender] == 0. To decrement
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * @param _spender The address which will spend the funds.
250      * @param _subtractedValue The amount of tokens to decrease the allowance by.
251      */
252     function decreaseApproval(address _spender, uint _subtractedValue) public
253     onlyPayloadSize(2)
254     returns (bool success) {
255         success = controller.decreaseApproval(msg.sender, _spender, _subtractedValue);
256         if (success) {
257             uint newValue = controller.allowance(msg.sender, _spender);
258             Approval(msg.sender, _spender, newValue);
259         }
260     }
261 
262     /**
263      * @dev Function to check the amount of tokens that an owner allowed to a spender.
264      * @param _owner address The address which owns the funds.
265      * @param _spender address The address which will spend the funds.
266      * @return A uint256 specifying the amount of tokens still available for the spender.
267      */
268     function allowance(address _owner, address _spender) public view returns (uint256) {
269         return controller.allowance(_owner, _spender);
270     }
271 
272     /**
273      * @dev Burns a specific amount of tokens.
274      * @param _amount The amount of token to be burned.
275      */
276     function burn(uint256 _amount) public
277     onlyPayloadSize(1)
278     {
279         bool success = controller.burn(msg.sender, _amount);
280         if (success) {
281             Burn(msg.sender, _amount);
282         }
283     }
284 
285     function controllerTransfer(address _from, address _to, uint256 _value) public onlyController {
286         Transfer(_from, _to, _value);
287     }
288 
289     function controllerApprove(address _owner, address _spender, uint256 _value) public onlyController {
290         Approval(_owner, _spender, _value);
291     }
292 
293     function controllerBurn(address _burner, uint256 _value) public onlyController {
294         Burn(_burner, _value);
295     }
296 
297     function controllerMint(address _to, uint256 _value) public onlyController {
298         Mint(_to, _value);
299     }
300 
301     event Motd(string message);
302 
303     function setMotd(string _motd) public onlyOwner {
304         motd = _motd;
305         Motd(_motd);
306     }
307 }
308 
309 contract Controller is Finalizable {
310 
311     Ledger public ledger;
312     Token public token;
313 
314     function setToken(address _token) public onlyOwner {
315         token = Token(_token);
316     }
317 
318     function setLedger(address _ledger) public onlyOwner {
319         ledger = Ledger(_ledger);
320     }
321 
322     modifier onlyToken() {
323         require(msg.sender == address(token));
324         _;
325     }
326 
327     modifier onlyLedger() {
328         require(msg.sender == address(ledger));
329         _;
330     }
331 
332     function totalSupply() public onlyToken view returns (uint256) {
333         return ledger.totalSupply();
334     }
335 
336     function balanceOf(address _a) public onlyToken view returns (uint256) {
337         return ledger.balanceOf(_a);
338     }
339 
340     function allowance(address _owner, address _spender) public onlyToken view returns (uint256) {
341         return ledger.allowance(_owner, _spender);
342     }
343 
344     function transfer(address _from, address _to, uint256 _value) public
345     onlyToken
346     returns (bool) {
347         return ledger.transfer(_from, _to, _value);
348     }
349 
350     function transferFrom(address _spender, address _from, address _to, uint256 _value) public
351     onlyToken
352     returns (bool) {
353         return ledger.transferFrom(_spender, _from, _to, _value);
354     }
355 
356     function burn(address _owner, uint256 _amount) public
357     onlyToken
358     returns (bool) {
359         return ledger.burn(_owner, _amount);
360     }
361 
362     function approve(address _owner, address _spender, uint256 _value) public
363     onlyToken
364     returns (bool) {
365         return ledger.approve(_owner, _spender, _value);
366     }
367 
368     function increaseApproval(address _owner, address _spender, uint256 _addedValue) public
369     onlyToken
370     returns (bool) {
371         return ledger.increaseApproval(_owner, _spender, _addedValue);
372     }
373 
374     function decreaseApproval(address _owner, address _spender, uint256 _subtractedValue) public
375     onlyToken
376     returns (bool) {
377         return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
378     }
379 }
380 
381 contract Ledger is Finalizable {
382     using SafeMath for uint256;
383 
384     address public controller;
385     mapping(address => uint256) internal balances;
386     mapping(address => mapping(address => uint256)) internal allowed;
387     uint256 totalSupply_;
388     bool public mintingFinished = false;
389 
390     event Mint(address indexed to, uint256 amount);
391     event MintFinished();
392 
393     function setController(address _controller) public onlyOwner notFinalized {
394         controller = _controller;
395     }
396 
397     modifier onlyController() {
398         require(msg.sender == controller);
399         _;
400     }
401 
402     modifier canMint() {
403         require(!mintingFinished);
404         _;
405     }
406 
407     function finishMinting() public onlyOwner canMint {
408         mintingFinished = true;
409         MintFinished();
410     }
411 
412     /**
413      * @dev Gets the balance of the specified address.
414      * @param _owner The address to query the the balance of.
415      * @return An uint256 representing the amount owned by the passed address.
416      */
417     function balanceOf(address _owner) public view returns (uint256) {
418         return balances[_owner];
419     }
420 
421     /**
422      * @dev total number of tokens in existence
423      */
424     function totalSupply() public view returns (uint256) {
425         return totalSupply_;
426     }
427 
428     /**
429      * @dev Function to check the amount of tokens that an owner allowed to a spender.
430      * @param _owner address The address which owns the funds.
431      * @param _spender address The address which will spend the funds.
432      * @return A uint256 specifying the amount of tokens still available for the spender.
433      */
434     function allowance(address _owner, address _spender) public view returns (uint256) {
435         return allowed[_owner][_spender];
436     }
437 
438     /**
439      * @dev transfer token for a specified address
440      * @param _from msg.sender from controller.
441      * @param _to The address to transfer to.
442      * @param _value The amount to be transferred.
443      */
444     function transfer(address _from, address _to, uint256 _value) public onlyController returns (bool) {
445         require(_to != address(0));
446         require(_value <= balances[_from]);
447 
448         // SafeMath.sub will throw if there is not enough balance.
449         balances[_from] = balances[_from].sub(_value);
450         balances[_to] = balances[_to].add(_value);
451         return true;
452     }
453 
454     /**
455      * @dev Transfer tokens from one address to another
456      * @param _from address The address which you want to send tokens from
457      * @param _to address The address which you want to transfer to
458      * @param _value uint256 the amount of tokens to be transferred
459      */
460     function transferFrom(address _spender, address _from, address _to, uint256 _value) public onlyController returns (bool) {
461         uint256 allow = allowed[_from][_spender];
462         require(_to != address(0));
463         require(_value <= balances[_from]);
464         require(_value <= allow);
465 
466         balances[_from] = balances[_from].sub(_value);
467         balances[_to] = balances[_to].add(_value);
468         allowed[_from][_spender] = allow.sub(_value);
469         return true;
470     }
471 
472     /**
473      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
474      *
475      * Beware that changing an allowance with this method brings the risk that someone may use both the old
476      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
477      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
478      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
479      * @param _spender The address which will spend the funds.
480      * @param _value The amount of tokens to be spent.
481      */
482     function approve(address _owner, address _spender, uint256 _value) public onlyController returns (bool) {
483         //require user to set to zero before resetting to nonzero
484         if ((_value != 0) && (allowed[_owner][_spender] != 0)) {
485             return false;
486         }
487 
488         allowed[_owner][_spender] = _value;
489         return true;
490     }
491 
492     /**
493      * @dev Increase the amount of tokens that an owner allowed to a spender.
494      *
495      * approve should be called when allowed[_spender] == 0. To increment
496      * allowed value is better to use this function to avoid 2 calls (and wait until
497      * the first transaction is mined)
498      * From MonolithDAO Token.sol
499      * @param _spender The address which will spend the funds.
500      * @param _addedValue The amount of tokens to increase the allowance by.
501      */
502     function increaseApproval(address _owner, address _spender, uint256 _addedValue) public onlyController returns (bool) {
503         allowed[_owner][_spender] = allowed[_owner][_spender].add(_addedValue);
504         return true;
505     }
506 
507     /**
508      * @dev Decrease the amount of tokens that an owner allowed to a spender.
509      *
510      * approve should be called when allowed[_spender] == 0. To decrement
511      * allowed value is better to use this function to avoid 2 calls (and wait until
512      * the first transaction is mined)
513      * From MonolithDAO Token.sol
514      * @param _spender The address which will spend the funds.
515      * @param _subtractedValue The amount of tokens to decrease the allowance by.
516      */
517     function decreaseApproval(address _owner, address _spender, uint256 _subtractedValue) public onlyController returns (bool) {
518         uint256 oldValue = allowed[_owner][_spender];
519         if (_subtractedValue > oldValue) {
520             allowed[_owner][_spender] = 0;
521         } else {
522             allowed[_owner][_spender] = oldValue.sub(_subtractedValue);
523         }
524         return true;
525     }
526 
527     /**
528      * @dev Burns a specific amount of tokens.
529      * @param _amount The amount of token to be burned.
530      */
531     function burn(address _burner, uint256 _amount) public onlyController returns (bool) {
532         require(balances[_burner] >= _amount);
533         // no need to require _amount <= totalSupply, since that would imply the
534         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
535 
536         balances[_burner] = balances[_burner].sub(_amount);
537         totalSupply_ = totalSupply_.sub(_amount);
538         return true;
539     }
540 
541     /**
542      * @dev Function to mint tokens
543      * @param _to The address that will receive the minted tokens.
544      * @param _amount The amount of tokens to mint.
545      * @return A boolean that indicates if the operation was successful.
546      */
547     function mint(address _to, uint256 _amount) public canMint returns (bool) {
548         require(msg.sender == controller || msg.sender == owner);
549         totalSupply_ = totalSupply_.add(_amount);
550         balances[_to] = balances[_to].add(_amount);
551         Mint(_to, _amount);
552         return true;
553     }
554 }