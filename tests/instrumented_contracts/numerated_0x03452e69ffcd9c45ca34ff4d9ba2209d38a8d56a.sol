1 pragma solidity 0.5.1; 
2 
3 
4 library SafeMath {
5 
6     uint256 constant internal MAX_UINT = 2 ** 256 - 1; // max uint256
7 
8     /**
9      * @dev Multiplies two numbers, reverts on overflow.
10      */
11     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
12         if (_a == 0) {
13             return 0;
14         }
15         require(MAX_UINT / _a >= _b);
16         return _a * _b;
17     }
18 
19     /**
20      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
21      */
22     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
23         require(_b != 0);
24         return _a / _b;
25     }
26 
27     /**
28      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
31         require(_b <= _a);
32         return _a - _b;
33     }
34 
35     /**
36      * @dev Adds two numbers, reverts on overflow.
37      */
38     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
39         require(MAX_UINT - _a >= _b);
40         return _a + _b;
41     }
42 
43 }
44 
45 
46 contract Ownable {
47     address public owner;
48 
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param _newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address _newOwner) public onlyOwner {
67         _transferOwnership(_newOwner);
68     }
69 
70     /**
71      * @dev Transfers control of the contract to a newOwner.
72      * @param _newOwner The address to transfer ownership to.
73      */
74     function _transferOwnership(address _newOwner) internal {
75         require(_newOwner != address(0));
76         emit OwnershipTransferred(owner, _newOwner);
77         owner = _newOwner;
78     }
79 }
80 
81 
82 contract Pausable is Ownable {
83     event Pause();
84     event Unpause();
85 
86     bool public paused = false;
87 
88     /**
89      * @dev Modifier to make a function callable only when the contract is not paused.
90      */
91     modifier whenNotPaused() {
92         require(!paused);
93         _;
94     }
95 
96     /**
97      * @dev Modifier to make a function callable only when the contract is paused.
98      */
99     modifier whenPaused() {
100         require(paused);
101         _;
102     }
103 
104     /**
105      * @dev called by the owner to pause, triggers stopped state
106      */
107     function pause() public onlyOwner whenNotPaused {
108         paused = true;
109         emit Pause();
110     }
111 
112     /**
113      * @dev called by the owner to unpause, returns to normal state
114      */
115     function unpause() public onlyOwner whenPaused {
116         paused = false;
117         emit Unpause();
118     }
119 }
120 
121 
122 contract StandardToken {
123     using SafeMath for uint256;
124 
125     mapping(address => uint256) internal balances;
126     mapping(address => mapping(address => uint256)) internal allowed;
127 
128     uint256 internal totalSupply_;
129 
130     event Transfer(
131         address indexed from,
132         address indexed to,
133         uint256 value
134     );
135 
136     event Approval(
137         address indexed owner,
138         address indexed spender,
139         uint256 value
140     );
141 
142     /**
143      * @dev Total number of tokens in existence
144      */
145     function totalSupply() public view returns(uint256) {
146         return totalSupply_;
147     }
148 
149     /**
150      * @dev Gets the balance of the specified address.
151      * @param _owner The address to query the the balance of.
152      * @return An uint256 representing the amount owned by the passed address.
153      */
154     function balanceOf(address _owner) public view returns(uint256) {
155         return balances[_owner];
156     }
157 
158     /**
159      * @dev Function to check the amount of tokens that an owner allowed to a spender.
160      * @param _owner address The address which owns the funds.
161      * @param _spender address The address which will spend the funds.
162      * @return A uint256 specifying the amount of tokens still available for the spender.
163      */
164     function allowance(
165         address _owner,
166         address _spender
167     )
168     public
169     view
170     returns(uint256) {
171         return allowed[_owner][_spender];
172     }
173 
174     /**
175      * @dev Transfer token for a specified address
176      * @param _to The address to transfer to.
177      * @param _value The amount to be transferred.
178      */
179     function transfer(address _to, uint256 _value) public returns(bool) {
180         require(_to != address(0));
181         require(_value <= balances[msg.sender]);
182 
183         balances[msg.sender] = balances[msg.sender].sub(_value);
184         balances[_to] = balances[_to].add(_value);
185         emit Transfer(msg.sender, _to, _value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      * @param _spender The address which will spend the funds.
192      * @param _value The amount of tokens to be spent.
193      */
194     function approve(address _spender, uint256 _value) public returns(bool) {
195         allowed[msg.sender][_spender] = _value;
196         emit Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     /**
201      * @dev Transfer tokens from one address to another
202      * @param _from address The address which you want to send tokens from
203      * @param _to address The address which you want to transfer to
204      * @param _value uint256 the amount of tokens to be transferred
205      */
206     function transferFrom(
207         address _from,
208         address _to,
209         uint256 _value
210     )
211     public
212     returns(bool) {
213         require(_to != address(0));
214         require(_value <= balances[_from]);
215         require(_value <= allowed[_from][msg.sender]);
216 
217         balances[_from] = balances[_from].sub(_value);
218         balances[_to] = balances[_to].add(_value);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220         emit Transfer(_from, _to, _value);
221         return true;
222     }
223 
224     /**
225      * @dev Increase the amount of tokens that an owner allowed to a spender.
226      * @param _spender The address which will spend the funds.
227      * @param _addedValue The amount of tokens to increase the allowance by.
228      */
229     function increaseApproval(
230         address _spender,
231         uint256 _addedValue
232     )
233     public
234     returns(bool) {
235         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237         return true;
238     }
239 
240     /**
241      * @dev Decrease the amount of tokens that an owner allowed to a spender.
242      * @param _spender The address which will spend the funds.
243      * @param _subtractedValue The amount of tokens to decrease the allowance by.
244      */
245     function decreaseApproval(
246         address _spender,
247         uint256 _subtractedValue
248     )
249     public
250     returns(bool) {
251         uint256 oldValue = allowed[msg.sender][_spender];
252         if (_subtractedValue >= oldValue) {
253             allowed[msg.sender][_spender] = 0;
254         } else {
255             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256         }
257         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258         return true;
259     }
260 }
261 
262 
263 contract BurnableToken is StandardToken {
264     event Burn(address indexed account, uint256 value);
265 
266     /**
267      * @dev Burns a specific amount of tokens.
268      * @param value The amount of token to be burned.
269      */
270     function burn(uint256 value) public {
271         require(balances[msg.sender] >= value);
272         totalSupply_ = totalSupply_.sub(value);
273         balances[msg.sender] = balances[msg.sender].sub(value);
274         emit Burn(msg.sender, value);
275         emit Transfer(msg.sender, address(0), value);
276     }
277 
278     /**
279      * @dev Burns a specific amount of tokens which belong to appointed address of account.
280      * @param account The address of appointed account.
281      * @param value The amount of token to be burned.
282      */
283     function burnFrom(address account, uint256 value) public {
284         require(account != address(0)); 
285         require(balances[account] >= value);
286         require(allowed[account][msg.sender] >= value);
287         totalSupply_ = totalSupply_.sub(value);
288         balances[account] = balances[account].sub(value);
289         allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);
290         emit Burn(account, value);
291         emit Transfer(account, address(0), value);
292     }
293 }
294 
295 
296 /**
297  * @dev Rewrite the key functions, add the modifier 'whenNotPaused',owner can stop the transaction.
298  */
299 contract PausableToken is StandardToken, Pausable {
300     function transfer(
301         address _to,
302         uint256 _value
303     )
304     public
305     whenNotPaused
306     returns(bool) {
307         return super.transfer(_to, _value);
308     }
309 
310     function transferFrom(
311         address _from,
312         address _to,
313         uint256 _value
314     )
315     public
316     whenNotPaused
317     returns(bool) {
318         return super.transferFrom(_from, _to, _value);
319     }
320 
321     function approve(
322         address _spender,
323         uint256 _value
324     )
325     public
326     whenNotPaused
327     returns(bool) {
328         return super.approve(_spender, _value);
329     }
330 
331     function increaseApproval(
332         address _spender,
333         uint _addedValue
334     )
335     public
336     whenNotPaused
337     returns(bool success) {
338         return super.increaseApproval(_spender, _addedValue);
339     }
340 
341     function decreaseApproval(
342         address _spender,
343         uint _subtractedValue
344     )
345     public
346     whenNotPaused
347     returns(bool success) {
348         return super.decreaseApproval(_spender, _subtractedValue);
349     }
350 }
351 
352 
353 /**
354  * @title VESTELLAToken token contract
355  * @dev Initialize the basic information of VESTELLAToken.
356  */
357 contract VESTELLAToken is PausableToken, BurnableToken {
358     using SafeMath for uint256;
359 
360     string public constant name = "VESTELLA"; // name of Token
361     string public constant symbol = "VES"; // symbol of Token
362     uint8 public constant decimals = 18; // decimals of Token
363     uint256 constant _INIT_TOTALSUPPLY = 15000000000; 
364 
365     mapping (address => uint256[]) internal locktime;
366     mapping (address => uint256[]) internal lockamount;
367 
368     event AddLockPosition(address indexed account, uint256 amount, uint256 time);
369 
370     /**
371      * @dev constructor Initialize the basic information.
372      */
373     constructor() public {
374         totalSupply_ = _INIT_TOTALSUPPLY * 10 ** uint256(decimals); 
375         owner = 0x0F1b590cD3155571C8680B363867e20b8E4303bE;
376         balances[owner] = totalSupply_;
377     }
378 
379     /**
380      * @dev addLockPosition function that only owner can add lock position for appointed address of account.
381      * one address can participate more than one lock position plan.
382      * @param account The address of account will participate lock position plan.
383      * @param amount The array of token amount that will be locked.
384      * @param time The timestamp of token will be released.
385      */
386     function addLockPosition(address account, uint256[] memory amount, uint256[] memory time) public onlyOwner returns(bool) { 
387         require(account != address(0));
388         require(amount.length == time.length);
389         uint256 _lockamount = 0;
390         for(uint i = 0; i < amount.length; i++) {
391             uint256 _amount = amount[i] * 10 ** uint256(decimals);
392             require(time[i] > now);
393             locktime[account].push(time[i]);
394             lockamount[account].push(_amount);
395             emit AddLockPosition(account, _amount, time[i]);
396             _lockamount = _lockamount.add(_amount);
397         }
398         require(balances[msg.sender] >= _lockamount);
399         balances[account] = balances[account].add(_lockamount);
400         balances[msg.sender] = balances[msg.sender].sub(_lockamount);
401         emit Transfer(msg.sender, account, _lockamount);
402         return true;
403     }
404 
405     /**
406      * @dev getLockPosition function get the detail information of an appointed account.
407      * @param account The address of appointed account.
408      */
409     function getLockPosition(address account) public view returns(uint256[] memory _locktime, uint256[] memory _lockamount) {
410         return (locktime[account], lockamount[account]);
411     }
412 
413     /**
414      * @dev getLockedAmount function get the amount of locked token which belong to appointed address at the current time.
415      * @param account The address of appointed account.
416      */
417     function getLockedAmount(address account) public view returns(uint256 _lockedAmount) {
418         uint256 _Amount = 0;
419         uint256 _lockAmount = 0;
420         for(uint i = 0; i < locktime[account].length; i++) {
421             if(now < locktime[account][i]) {
422                 _Amount = lockamount[account][i]; 
423                 _lockAmount = _lockAmount.add(_Amount);
424             }
425         }
426         return _lockAmount;   
427     }
428 
429     /**
430      * @dev Rewrite the transfer functions, call the getLockedAmount to validate the balances after transaction is more than lock-amount.
431      */
432     function transfer(
433         address _to,
434         uint256 _value
435     )
436     public
437     returns(bool) {
438         require(balances[msg.sender].sub(_value) >= getLockedAmount(msg.sender));
439         return super.transfer(_to, _value);
440     }
441 
442     /**
443      * @dev Rewrite the transferFrom functions, call the getLockedAmount to validate the balances after transaction is more than lock-amount.
444      */
445     function transferFrom(
446         address _from,
447         address _to,
448         uint256 _value
449     )
450     public
451     returns(bool) {
452         require(balances[_from].sub(_value) >= getLockedAmount(_from));
453         return super.transferFrom(_from, _to, _value);
454     }
455 
456     /**
457      * @dev Rewrite the burn functions, call the getLockedAmount to validate the balances after burning is more than lock-amount.
458      */
459     function burn(uint256 value) public {
460         require(balances[msg.sender].sub(value) >= getLockedAmount(msg.sender));
461         super.burn(value);
462     }  
463 
464     /**
465      * @dev Rewrite the burnFrom functions, call the getLockedAmount to validate the balances after burning is more than lock-amount.
466      */
467     function burnFrom(address account, uint256 value) public {
468         require(balances[account].sub(value) >= getLockedAmount(account));
469         super.burnFrom(account, value);
470     } 
471 
472     /**
473      * @dev _batchTransfer internal function for airdropping candy to target address.
474      * @param _to target address
475      * @param _amount amount of token
476      */
477     function _batchTransfer(address[] memory _to, uint256[] memory _amount) internal whenNotPaused {
478         require(_to.length == _amount.length);
479         uint256 sum = 0; 
480         for(uint i = 0;i < _to.length;i += 1){
481             require(_to[i] != address(0));  
482             sum = sum.add(_amount[i]);
483             require(sum <= balances[msg.sender]);  
484             balances[_to[i]] = balances[_to[i]].add(_amount[i]); 
485             emit Transfer(msg.sender, _to[i], _amount[i]);
486         } 
487         balances[msg.sender] = balances[msg.sender].sub(sum); 
488     }
489 
490     /**
491      * @dev airdrop function for airdropping candy to target address.
492      * @param _to target address
493      * @param _amount amount of token
494      */
495     function airdrop(address[] memory _to, uint256[] memory _amount) public onlyOwner returns(bool){
496         _batchTransfer(_to, _amount);
497         return true;
498     }
499 }