1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-31
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 contract ERC20Basic {
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address who) public view returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract ERC20 is ERC20Basic {
18     function allowance(address owner, address spender)
19         public view returns (uint256);
20 
21     function transferFrom(address from, address to, uint256 value)
22         public returns (bool);
23 
24     function approve(address spender, uint256 value) public returns (bool);
25     
26     event Approval(
27         address indexed owner,
28         address indexed spender,
29         uint256 value
30     );
31 }
32 
33 library SafeERC20 {
34     function safeTransfer(
35         ERC20Basic _token,
36         address _to,
37         uint256 _value
38     ) internal
39     {
40         require(_token.transfer(_to, _value));
41     }
42 
43     function safeTransferFrom(
44         ERC20 _token,
45         address _from,
46         address _to,
47         uint256 _value
48     ) internal
49     {
50         require(_token.transferFrom(_from, _to, _value));
51     }
52 
53     function safeApprove(
54         ERC20 _token,
55         address _spender,
56         uint256 _value
57     ) internal
58     {
59         require(_token.approve(_spender, _value));
60     }
61 }
62 
63 library SafeMath {
64 	/**
65     * @dev Multiplies two numbers, throws on overflow.
66     */
67     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
68 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
69 		// benefit is lost if 'b' is also tested.
70 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
71         if(a == 0) {
72             return 0;
73 		}
74         c = a * b;
75         assert(c / a == b);
76         return c;
77     }
78 
79 	/**
80 	* @dev Integer division of two numbers, truncating the quotient.
81 	*/
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83 		// assert(b > 0); // Solidity automatically throws when dividing by 0
84 		// uint256 c = a / b;
85 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
86         return a / b;
87     }
88 
89 	/**
90 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91 	*/
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         assert(b <= a);
94         return a - b;
95     }
96 	/**
97     * @dev Adds two numbers, throws on overflow.
98     */
99     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
100         c = a + b;
101         assert(c >= a);
102         return c;
103     }
104 }
105 
106 
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 contract BasicToken is ERC20Basic {
113     using SafeMath for uint256;
114     
115     mapping(address => uint256) balances;
116     
117     uint256 totalSupply_;
118 
119     /**
120     * @dev Total number of tokens in existence
121     */
122     function totalSupply() public view returns (uint256) {
123         return totalSupply_;
124     }
125     /**
126     * @dev Transfer token for a specified address
127     * @param _to The address to transfer to.
128     * @param _value The amount to be transferred.
129     */
130     function transfer(address _to, uint256 _value) public returns (bool) {
131         require(_to != address(0));
132         require(_value <= balances[msg.sender]);
133         balances[msg.sender] = balances[msg.sender].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         
136         emit Transfer(msg.sender, _to, _value);
137         
138         return true;
139     }
140 
141 	/**
142     * @dev Gets the balance of the specified address.
143     * @param _owner The address to query the the balance of.
144     * @return An uint256 representing the amount owned by the passed address.
145     */
146     function balanceOf(address _owner) public view returns (uint256) {
147         return balances[_owner];
148     }
149 }
150 
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * https://github.com/ethereum/EIPs/issues/20
157  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is ERC20, BasicToken {
160 
161     mapping (address => mapping (address => uint256)) internal allowed;
162 
163 
164     /**
165     * @dev Transfer tokens from one address to another
166     * @param _from address The address which you want to send tokens from
167     * @param _to address The address which you want to transfer to
168     * @param _value uint256 the amount of tokens to be transferred
169     */
170     function transferFrom (
171         address _from,
172         address _to,
173         uint256 _value
174     ) public returns (bool)
175     {
176         require(_to != address(0));
177         require(_value <= balances[_from]);
178         require(_value <= allowed[_from][msg.sender]);
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         
183         emit Transfer(_from, _to, _value);
184         
185         return true;
186     }
187 
188     function approve(address _spender, uint256 _value) public returns (bool) {
189         allowed[msg.sender][_spender] = _value;
190         
191         emit Approval(msg.sender, _spender, _value);
192         
193         return true;
194     }
195 
196     function allowance (
197         address _owner,
198         address _spender
199 	)
200 		public
201 		view
202 		returns (uint256)
203 	{
204         return allowed[_owner][_spender];
205     }
206 
207     function increaseApproval(
208         address _spender,
209         uint256 _addedValue
210 	)
211 		public
212 		returns (bool)
213 	{
214         allowed[msg.sender][_spender] = (
215         allowed[msg.sender][_spender].add(_addedValue));
216         
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         
219         return true;
220     }
221 
222 	/**
223     * @dev Decrease the amount of tokens that an owner allowed to a spender.
224     * approve should be called when allowed[_spender] == 0. To decrement
225     * allowed value is better to use this function to avoid 2 calls (and wait until
226     * the first transaction is mined)
227     * From MonolithDAO Token.sol
228     * @param _spender The address which will spend the funds.
229     * @param _subtractedValue The amount of tokens to decrease the allowance by.
230     */
231     function decreaseApproval(
232         address _spender,
233         uint256 _subtractedValue
234 	) public returns (bool)
235 	{
236         uint256 oldValue = allowed[msg.sender][_spender];
237         if (_subtractedValue > oldValue) {
238             allowed[msg.sender][_spender] = 0;
239 		} else {
240             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241 		}
242         
243         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244         
245         return true;
246     }
247 }
248 
249 contract Ownable {
250     uint8 constant MAX_BURN = 3;
251 
252     address[MAX_BURN] public chkBurnerList;
253     
254     mapping(address => bool) public burners;
255     //mapping (address => bool) public owners;
256     address owner;
257     
258     event AddedBurner(address indexed newBurner);
259     event ChangeOwner(address indexed newOwner);
260     event DeletedBurner(address indexed toDeleteBurner);
261 
262     constructor() public {
263         owner = msg.sender;
264     }
265     modifier onlyOwner() {
266         require(owner == msg.sender);
267         _;
268     }
269     modifier onlyBurner(){
270         require(burners[msg.sender]);
271         _;
272     }
273     
274     function changeOwnerShip(address newOwner) public onlyOwner returns(bool) {
275         require(newOwner != address(0));
276         owner = newOwner;
277         
278         emit ChangeOwner(newOwner);
279         
280         return true;
281     }
282     
283     function addBurner(address burner, uint8 num) public onlyOwner returns (bool) {
284         require(num < MAX_BURN);
285         require(burner != address(0));
286         require(chkBurnerList[num] == address(0));
287         require(burners[burner] == false);
288 
289         burners[burner] = true;
290         chkBurnerList[num] = burner;
291         
292         emit AddedBurner(burner);
293         
294         return true;
295     }
296 
297     function deleteBurner(address burner, uint8 num) public onlyOwner returns (bool){
298         require(num < MAX_BURN);
299         require(burner != address(0));
300         require(chkBurnerList[num] == burner);
301         
302         burners[burner] = false;
303 
304         chkBurnerList[num] = address(0);
305         
306         emit DeletedBurner(burner);
307         
308         return true;
309     }
310 }
311 
312 contract Blacklist is Ownable {
313 
314     mapping(address => bool) blacklisted;
315 
316     event Blacklisted(address indexed blacklist);
317     event Whitelisted(address indexed whitelist);
318     
319     modifier whenPermitted(address node) {
320         require(!blacklisted[node]);
321         _;
322     }
323     
324     function isPermitted(address node) public view returns (bool) {
325         return !blacklisted[node];
326     }
327 
328     function blacklist(address node) public onlyOwner returns (bool) {
329         require(!blacklisted[node]);
330         blacklisted[node] = true;
331         emit Blacklisted(node);
332 
333         return blacklisted[node];
334     }
335    
336     function unblacklist(address node) public onlyOwner returns (bool) {
337         require(blacklisted[node]);
338         blacklisted[node] = false;
339         emit Whitelisted(node);
340 
341         return blacklisted[node];
342     }
343 }
344 
345 contract Burnlist is Blacklist {
346     mapping(address => bool) public isburnlist;
347 
348     event Burnlisted(address indexed burnlist, bool signal);
349 
350     modifier isBurnlisted(address who) {
351         require(isburnlist[who]);
352         _;
353     }
354 
355     function addBurnlist(address node) public onlyOwner returns (bool) {
356         require(!isburnlist[node]);
357         
358         isburnlist[node] = true;
359         
360         emit Burnlisted(node, true);
361         
362         return isburnlist[node];
363     }
364 
365     function delBurnlist(address node) public onlyOwner returns (bool) {
366         require(isburnlist[node]);
367         
368         isburnlist[node] = false;
369         
370         emit Burnlisted(node, false);
371         
372         return isburnlist[node];
373     }
374 }
375 
376 
377 contract PausableToken is StandardToken, Burnlist {
378     
379     bool public paused = false;
380     
381     event Paused(address addr);
382     event Unpaused(address addr);
383 
384     constructor() public {
385     }
386     
387     modifier whenNotPaused() {
388         require(!paused || owner == msg.sender);
389         _;
390     }
391    
392     function pause() public onlyOwner returns (bool) {
393         require(!paused);
394 
395         paused = true;
396         
397         emit Paused(msg.sender);
398 
399         return paused;
400     }
401 
402     function unpause() public onlyOwner returns (bool) {
403         require(paused);
404 
405         paused = false;
406         
407         emit Unpaused(msg.sender);
408 
409         return paused;
410     }
411 
412     function transfer(address to, uint256 value) public whenNotPaused whenPermitted(msg.sender) returns (bool) {
413        
414         return super.transfer(to, value);
415     }
416 
417     function transferFrom(address from, address to, uint256 value) public 
418     whenNotPaused whenPermitted(from) whenPermitted(msg.sender) returns (bool) {
419       
420         return super.transferFrom(from, to, value);
421     }
422 
423 }
424 /**
425  * @title EasyGame
426  *
427  */
428 contract EasyGame is PausableToken {
429     
430     event Burn(address indexed burner, uint256 value);
431     event Mint(address indexed minter, uint256 value);
432 
433     string public constant name = "EasyGame";
434     uint8 public constant decimals = 18;
435     string public constant symbol = "EG";
436     uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals)); 
437 
438     constructor() public {
439         totalSupply_ = INITIAL_SUPPLY;
440         balances[msg.sender] = INITIAL_SUPPLY;
441         
442         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
443     }
444 
445     function destory() public onlyOwner returns (bool) {
446         
447         selfdestruct(owner);
448 
449         return true;
450     }
451  
452     function mint(uint256 _amount) public onlyOwner returns (bool) {
453         
454         require(INITIAL_SUPPLY >= totalSupply_.add(_amount));
455         
456         totalSupply_ = totalSupply_.add(_amount);
457         
458         balances[owner] = balances[owner].add(_amount);
459 
460         emit Mint(owner, _amount);
461         
462         emit Transfer(address(0), owner, _amount);
463         
464         return true;
465     }
466 
467  
468     function burn(address _to,uint256 _value) public onlyBurner isBurnlisted(_to) returns(bool) {
469         
470         _burn(_to, _value);
471 		
472         return true;
473     }
474 
475     function _burn(address _who, uint256 _value) internal returns(bool){     
476         require(_value <= balances[_who]);
477         
478 
479         balances[_who] = balances[_who].sub(_value);
480         totalSupply_ = totalSupply_.sub(_value);
481     
482         emit Burn(_who, _value);
483         emit Transfer(_who, address(0), _value);
484 		
485         return true;
486     }
487 }