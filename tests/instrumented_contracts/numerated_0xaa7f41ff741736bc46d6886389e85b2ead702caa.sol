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
126 
127     mapping(address => mapping(address => uint256)) internal allowed;
128 
129     mapping (address => bool) public frozenAccount;
130 
131     uint256 internal totalSupply_;
132 
133     event Transfer(
134         address indexed from,
135         address indexed to,
136         uint256 value
137     );
138 
139     event Approval(
140         address indexed owner,
141         address indexed spender,
142         uint256 vaule
143     );
144 
145     event FrozenFunds(
146         address indexed _account, 
147         bool _frozen
148     );
149 
150     /**
151      * @dev Total number of tokens in existence
152      */
153     function totalSupply() public view returns(uint256) {
154         return totalSupply_;
155     }
156 
157     /**
158      * @dev Gets the balance of the specified address.
159      * @param _owner The address to query the the balance of.
160      * @return An uint256 representing the amount owned by the passed address.
161      */
162     function balanceOf(address _owner) public view returns(uint256) {
163         return balances[_owner];
164     }
165 
166     /**
167      * @dev Function to check the amount of tokens that an owner allowed to a spender.
168      * @param _owner address The address which owns the funds.
169      * @param _spender address The address which will spend the funds.
170      * @return A uint256 specifying the amount of tokens still available for the spender.
171      */
172     function allowance(
173         address _owner,
174         address _spender
175     )
176     public
177     view
178     returns(uint256) {
179         return allowed[_owner][_spender];
180     }
181 
182     /**
183      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184      * Beware that changing an allowance with this method brings the risk that someone may use both the old
185      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      * @param _spender The address which will spend the funds.
189      * @param _value The amount of tokens to be spent.
190      */
191     function approve(address _spender, uint256 _value) public returns(bool) {
192         allowed[msg.sender][_spender] = _value;
193         emit Approval(msg.sender, _spender, _value);
194         return true;
195     }
196 
197     /**
198      * @dev Increase the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed[_spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * @param _spender The address which will spend the funds.
204      * @param _addedValue The amount of tokens to increase the allowance by.
205      */
206     function increaseApproval(
207         address _spender,
208         uint256 _addedValue
209     )
210     public
211     returns(bool) {
212         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217     /**
218      * @dev Decrease the amount of tokens that an owner allowed to a spender.
219      * approve should be called when allowed[_spender] == 0. To decrement
220      * allowed value is better to use this function to avoid 2 calls (and wait until
221      * the first transaction is mined)
222      * From MonolithDAO Token.sol
223      * @param _spender The address which will spend the funds.
224      * @param _subtractedValue The amount of tokens to decrease the allowance by.
225      */
226     function decreaseApproval(
227         address _spender,
228         uint256 _subtractedValue
229     )
230     public
231     returns(bool) {
232         uint256 oldValue = allowed[msg.sender][_spender];
233         if (_subtractedValue >= oldValue) {
234             allowed[msg.sender][_spender] = 0;
235         } else {
236             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237         }
238         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 }
242 
243 
244 contract BurnableToken is StandardToken, Ownable {
245 
246     event Burn(address indexed account, uint256 value);
247 
248     /**
249      * @dev Internal function that burns an amount of the token of a given
250      * account. Uses the internal burn function.
251      * @param account The account whose tokens will be burnt.
252      * @param value The amount that will be burnt.
253      */
254     function _burn(address account, uint256 value) internal {
255         require(account != address(0)); 
256         totalSupply_ = totalSupply_.sub(value);
257         balances[account] = balances[account].sub(value);
258         emit Burn(account, value);
259         emit Transfer(account, address(0), value);
260     }
261 
262     /**
263      * @dev Burns a specific amount of tokens.
264      * @param value The amount of token to be burned.
265      */
266     function burn(uint256 value) public onlyOwner {
267         _burn(msg.sender, value);
268     }
269 }
270 
271 
272 contract PausableToken is StandardToken, Pausable {
273     function approve(
274         address _spender,
275         uint256 _value
276     )
277     public
278     whenNotPaused
279     returns(bool) {
280         return super.approve(_spender, _value);
281     }
282 
283     function increaseApproval(
284         address _spender,
285         uint _addedValue
286     )
287     public
288     whenNotPaused
289     returns(bool success) {
290         return super.increaseApproval(_spender, _addedValue);
291     }
292 
293     function decreaseApproval(
294         address _spender,
295         uint _subtractedValue
296     )
297     public
298     whenNotPaused
299     returns(bool success) {
300         return super.decreaseApproval(_spender, _subtractedValue);
301     }
302 }
303 
304 
305 /**
306  * @title AQQToken token
307  * @dev Initialize the basic information of AQQToken.
308  */
309 contract AQQToken is PausableToken, BurnableToken {
310     using SafeMath for uint256;
311 
312     string public constant name = "AQQ"; // name of Token
313     string public constant symbol = "AQQ"; // symbol of Token
314     uint8 public constant decimals = 18; // decimals of Token
315 
316     uint256 internal vestingToken; 
317     uint256 public initialCirculatingToken; 
318     address constant wallet = 0xC151c00E83988ce3774Cde684f0209AD46C12aFC; 
319 
320     uint256 constant _INIT_TOTALSUPPLY = 100000000; 
321     uint256 constant _INIT_VESTING_TOKEN = 60000000; 
322     uint256 constant _INIT_CIRCULATE_TOKEN = 10000000;
323 
324   /**
325    * @dev constructor Initialize the basic information.
326    */
327     constructor() public {
328         totalSupply_ = _INIT_TOTALSUPPLY * 10 ** uint256(decimals); // amount of totalsupply
329         vestingToken = _INIT_VESTING_TOKEN * 10 ** uint256(decimals); // total amount of token circulation plan after deploy
330         initialCirculatingToken = _INIT_CIRCULATE_TOKEN * 10 ** uint256(decimals); // amount of circulating tokens
331         owner = wallet; // Specify owner as wallet address
332         balances[wallet] = totalSupply_;
333     }
334 
335   /**
336    * @dev getVestingToken function that returns a value of the remaining outstanding tokens in the current circulation plan.
337    */
338     function getVestingToken() public view returns(uint256 amount){
339         if(now < 1546272000) { //2019.01.01 00:00:00
340             return vestingToken;
341         }else if(now < 1577808000) { //2020.01.01 00:00:00
342             return vestingToken.sub(20000000 * 10 ** uint256(decimals));
343         }else if(now < 1609430400) { //2021.01.01 00:00:00
344             return vestingToken.sub(40000000 * 10 ** uint256(decimals));
345         }else {
346             return 0;
347         }
348     }
349 
350   /**
351    * @dev _validate internal function that validate the balance of _addr is more than _value.
352    */
353     function _validate(address _addr, uint256 _value) internal view {
354         uint256 vesting = getVestingToken();
355         require(balances[_addr] >= vesting.add(_value));
356     }
357 
358     /**
359      * @dev Transfer token for a specified address
360      * @param _to The address to transfer to.
361      * @param _value The amount to be transferred.
362      */
363     function transfer(
364         address _to, 
365         uint256 _value
366     ) 
367     public 
368     whenNotPaused 
369     returns(bool) {
370         require(_to != address(0));
371         require(!frozenAccount[msg.sender]);
372         require(!frozenAccount[_to]);
373         require(_value <= balances[msg.sender]);
374         if(msg.sender == wallet) {
375             _validate(msg.sender, _value);
376         }
377         balances[msg.sender] = balances[msg.sender].sub(_value);
378         balances[_to] = balances[_to].add(_value);
379         emit Transfer(msg.sender, _to, _value);
380         return true;
381     }
382 
383     /**
384      * @dev Transfer tokens from one address to another
385      * @param _from address The address which you want to send tokens from
386      * @param _to address The address which you want to transfer to
387      * @param _value uint256 the amount of tokens to be transferred
388      */
389     function transferFrom(
390         address _from,
391         address _to,
392         uint256 _value
393     )
394     public
395     whenNotPaused
396     returns(bool) {
397         require(_to != address(0));
398         require(!frozenAccount[_from]);
399         require(!frozenAccount[_to]);
400         require(_value <= balances[_from]);
401         require(_value <= allowed[_from][msg.sender]);
402         if(_from == wallet) {
403             _validate(_from, _value);
404         }
405         balances[_from] = balances[_from].sub(_value);
406         balances[_to] = balances[_to].add(_value);
407         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
408         emit Transfer(_from, _to, _value);
409         return true;
410     }
411 
412   /**
413    * @dev freezeAccount function that freeze the funds of target address.
414    * @param _account target address
415    * @param _freeze position of funds，true or false
416    */
417     function freezeAccount(address _account, bool _freeze) public onlyOwner returns(bool) {
418         frozenAccount[_account] = _freeze;
419         emit FrozenFunds(_account, _freeze);    
420         return true;    
421     }
422 
423   /**
424    * @dev _batchTransfer internal function for airdropping candy to target address.
425    * @param _to target address
426    * @param _amount amount of token
427    */
428     function _batchTransfer(address[] memory _to, uint256[] memory _amount) internal whenNotPaused {
429         require(_to.length == _amount.length);
430         uint256 sum = 0; 
431         for(uint256 i = 0;i < _to.length;i += 1){
432             require(_to[i] != address(0)); 
433             require(!frozenAccount[_to[i]]); 
434             sum = sum.add(_amount[i]);
435             require(sum <= balances[msg.sender]);  
436             balances[_to[i]] = balances[_to[i]].add(_amount[i]); 
437             emit Transfer(msg.sender, _to[i], _amount[i]);
438         } 
439         _validate(msg.sender, sum);
440         balances[msg.sender] = balances[msg.sender].sub(sum); 
441     }
442 
443   /**
444    * @dev airdrop function for airdropping candy to target address.
445    * @param _to target address
446    * @param _amount amount of token
447    */
448     function airdrop(address[] memory _to, uint256[] memory _amount) public onlyOwner returns(bool){
449         _batchTransfer(_to, _amount);
450         return true;
451     }
452 
453   /**
454    * @dev overwrite the burn function and call the _validate internal function to validate the value.
455    * @param value amount of burn tokens
456    */
457     function burn(uint256 value) public onlyOwner {
458         _validate(msg.sender, value);
459         super.burn(value); 
460     }
461 }