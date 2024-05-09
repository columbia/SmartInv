1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * @dev Based on: OpenZeppelin
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title Ownable
54  * @dev Contract provides ownership control
55  * @dev Based on: OpenZeppelin
56  */
57 contract Ownable {
58   address public owner;
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Basic ERC20 interface
96  * @dev Based on: OpenZeppelin
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 
106 
107 /**
108  * @title Full ERC20 interface
109  * @dev Based on: OpenZeppelin
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  * @dev Based on: OpenZeppelin
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   uint256 totalSupply_;
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 
167 
168 /**
169  * @title Standard ERC20 token
170  * @dev Implementation of the basic standard token.
171  * @dev Based on: OpenZeppelin
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public view returns (uint256) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    *
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 
253 
254 /**
255  * @title Tri_Ag
256  * @dev Implementation of the Tri_Ag token.
257  */
258 contract Tri_Ag is StandardToken, Ownable {
259   string public name = 'Tri_Ag';
260   string public symbol = 'tAg';
261   uint public decimals = 18;
262   uint public INITIAL_SUPPLY = 0;  // we're starting off with zero initial supply and will 'mint' as needed
263 
264   // The following were created as arrays instead of mappings since the dapp requires access to all elements (a mapping doesn't allow access to its keys). Extra iteration gas costs are negligible due to the fact that delegates are usually very limited in number.
265   address[] mintDelegates;   // accounts allowed to mint tokens
266   address[] burnDelegates;   // accounts allowed to burn tokens
267 
268   // Events
269   event Mint(address indexed to, uint256 amount);
270   event Burn(address indexed burner, uint256 value);
271   event ApproveMintDelegate(address indexed mintDelegate);
272   event RevokeMintDelegate(address indexed mintDelegate);
273   event ApproveBurnDelegate(address indexed burnDelegate);
274   event RevokeBurnDelegate(address indexed burnDelegate);
275 
276 
277   // Constructor
278   function Tri_Ag() public {
279     totalSupply_ = INITIAL_SUPPLY;
280   }
281 
282 
283   /**
284    * @dev Throws if called by any account other than an owner or a mint delegate.
285    */
286   modifier onlyOwnerOrMintDelegate() {
287     bool allowedToMint = false;
288 
289     if(msg.sender==owner) {
290       allowedToMint = true;
291     }
292     else {
293       for(uint i=0; i<mintDelegates.length; i++) {
294         if(mintDelegates[i]==msg.sender) {
295           allowedToMint = true;
296           break;
297         }
298       }
299     }
300 
301     require(allowedToMint==true);
302     _;
303   }
304 
305   /**
306    * @dev Throws if called by any account other than an owner or a burn delegate.
307    */
308   modifier onlyOwnerOrBurnDelegate() {
309     bool allowedToBurn = false;
310 
311     if(msg.sender==owner) {
312       allowedToBurn = true;
313     }
314     else {
315       for(uint i=0; i<burnDelegates.length; i++) {
316         if(burnDelegates[i]==msg.sender) {
317           allowedToBurn = true;
318           break;
319         }
320       }
321     }
322 
323     require(allowedToBurn==true);
324     _;
325   }
326 
327   /**
328    * @dev Return the array of mint delegates.
329    */
330   function getMintDelegates() public view returns (address[]) {
331     return mintDelegates;
332   }
333 
334   /**
335    * @dev Return the array of burn delegates.
336    */
337   function getBurnDelegates() public view returns (address[]) {
338     return burnDelegates;
339   }
340 
341   /**
342    * @dev Give a mint delegate permission to mint tokens.
343    * @param _mintDelegate The account to be approved.
344    */
345   function approveMintDelegate(address _mintDelegate) onlyOwner public returns (bool) {
346     bool delegateFound = false;
347     for(uint i=0; i<mintDelegates.length; i++) {
348       if(mintDelegates[i]==_mintDelegate) {
349         delegateFound = true;
350         break;
351       }
352     }
353 
354     if(!delegateFound) {
355       mintDelegates.push(_mintDelegate);
356     }
357 
358     ApproveMintDelegate(_mintDelegate);
359     return true;
360   }
361 
362   /**
363    * @dev Revoke permission to mint tokens from a mint delegate.
364    * @param _mintDelegate The account to be revoked.
365    */
366   function revokeMintDelegate(address _mintDelegate) onlyOwner public returns (bool) {
367     uint length = mintDelegates.length;
368     require(length > 0);
369 
370     address lastDelegate = mintDelegates[length-1];
371     if(_mintDelegate == lastDelegate) {
372       delete mintDelegates[length-1];
373       mintDelegates.length--;
374     }
375     else {
376       // Game plan: find the delegate, replace it with the very last item in the array, then delete the last item
377       for(uint i=0; i<length; i++) {
378         if(mintDelegates[i]==_mintDelegate) {
379           mintDelegates[i] = lastDelegate;
380           delete mintDelegates[length-1];
381           mintDelegates.length--;
382           break;
383         }
384       }
385     }
386 
387     RevokeMintDelegate(_mintDelegate);
388     return true;
389   }
390 
391   /**
392    * @dev Give a burn delegate permission to burn tokens.
393    * @param _burnDelegate The account to be approved.
394    */
395   function approveBurnDelegate(address _burnDelegate) onlyOwner public returns (bool) {
396     bool delegateFound = false;
397     for(uint i=0; i<burnDelegates.length; i++) {
398       if(burnDelegates[i]==_burnDelegate) {
399         delegateFound = true;
400         break;
401       }
402     }
403 
404     if(!delegateFound) {
405       burnDelegates.push(_burnDelegate);
406     }
407 
408     ApproveBurnDelegate(_burnDelegate);
409     return true;
410   }
411 
412   /**
413    * @dev Revoke permission to burn tokens from a burn delegate.
414    * @param _burnDelegate The account to be revoked.
415    */
416   function revokeBurnDelegate(address _burnDelegate) onlyOwner public returns (bool) {
417     uint length = burnDelegates.length;
418     require(length > 0);
419 
420     address lastDelegate = burnDelegates[length-1];
421     if(_burnDelegate == lastDelegate) {
422       delete burnDelegates[length-1];
423       burnDelegates.length--;
424     }
425     else {
426       // Game plan: find the delegate, replace it with the very last item in the array, then delete the last item
427       for(uint i=0; i<length; i++) {
428         if(burnDelegates[i]==_burnDelegate) {
429           burnDelegates[i] = lastDelegate;
430           delete burnDelegates[length-1];
431           burnDelegates.length--;
432           break;
433         }
434       }
435     }
436 
437     RevokeBurnDelegate(_burnDelegate);
438     return true;
439   }
440 
441 
442   /**
443    * @dev Function to mint tokens and transfer them to contract owner's address
444    * @param _amount The amount of tokens to mint.
445    * @return A boolean that indicates if the operation was successful.
446    */
447   function mint(uint256 _amount) onlyOwnerOrMintDelegate public returns (bool) {
448     totalSupply_ = totalSupply_.add(_amount);
449     balances[msg.sender] = balances[msg.sender].add(_amount);
450 
451     // Call events
452     Mint(msg.sender, _amount);
453     Transfer(address(0), msg.sender, _amount);
454 
455     return true;
456   }
457 
458   /**
459    * @dev Function to burn tokens
460    * @param _value The amount of tokens to be burned.
461    * @return A boolean that indicates if the operation was successful.
462    */
463   function burn(uint256 _value) onlyOwnerOrBurnDelegate public returns (bool) {
464     require(_value <= balances[msg.sender]);
465 
466     address burner = msg.sender;
467     balances[burner] = balances[burner].sub(_value);
468     totalSupply_ = totalSupply_.sub(_value);
469 
470     // Call events
471     Burn(burner, _value);
472     Transfer(burner, address(0), _value);
473 
474     return true;
475   }
476 }