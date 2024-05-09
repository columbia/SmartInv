1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82     uint256 c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[msg.sender]);
125 
126     // SafeMath.sub will throw if there is not enough balance.
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param _owner The address to query the the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address _owner) public view returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142 }
143 
144 
145 
146 
147 
148 
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender) public view returns (uint256);
156   function transferFrom(address from, address to, uint256 value) public returns (bool);
157   function approve(address spender, uint256 value) public returns (bool);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172   mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175   /**
176    * @dev Transfer tokens from one address to another
177    * @param _from address The address which you want to send tokens from
178    * @param _to address The address which you want to transfer to
179    * @param _value uint256 the amount of tokens to be transferred
180    */
181   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    *
196    * Beware that changing an allowance with this method brings the risk that someone may use both the old
197    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200    * @param _spender The address which will spend the funds.
201    * @param _value The amount of tokens to be spent.
202    */
203   function approve(address _spender, uint256 _value) public returns (bool) {
204     allowed[msg.sender][_spender] = _value;
205     Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifying the amount of tokens still available for the spender.
214    */
215   function allowance(address _owner, address _spender) public view returns (uint256) {
216     return allowed[_owner][_spender];
217   }
218 
219   /**
220    * @dev Increase the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To increment
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _addedValue The amount of tokens to increase the allowance by.
228    */
229   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
230     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
231     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
246     uint oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue > oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 
259 
260 
261 
262 
263 
264 /**
265  * @title Pausable
266  * @dev Base contract which allows children to implement an emergency stop mechanism.
267  */
268 contract Pausable is Ownable {
269   event Pause();
270   event Unpause();
271 
272   bool public paused = false;
273 
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is not paused.
277    */
278   modifier whenNotPaused() {
279     require(!paused);
280     _;
281   }
282 
283   /**
284    * @dev Modifier to make a function callable only when the contract is paused.
285    */
286   modifier whenPaused() {
287     require(paused);
288     _;
289   }
290 
291   /**
292    * @dev called by the owner to pause, triggers stopped state
293    */
294   function pause() onlyOwner whenNotPaused public {
295     paused = true;
296     Pause();
297   }
298 
299   /**
300    * @dev called by the owner to unpause, returns to normal state
301    */
302   function unpause() onlyOwner whenPaused public {
303     paused = false;
304     Unpause();
305   }
306 }
307 
308 
309 /**
310  * @title Pausable token
311  *
312  * @dev StandardToken modified with pausable transfers.
313  **/
314 
315 contract PausableToken is StandardToken, Pausable {
316 
317   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
318     return super.transfer(_to, _value);
319   }
320 
321   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
322     return super.transferFrom(_from, _to, _value);
323   }
324 
325   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
326     return super.approve(_spender, _value);
327   }
328 
329   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
330     return super.increaseApproval(_spender, _addedValue);
331   }
332 
333   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
334     return super.decreaseApproval(_spender, _subtractedValue);
335   }
336 }
337 
338 
339 contract Obirum is PausableToken {
340     string public constant name = "Obirum";
341     string public constant symbol = "OBR";
342     uint8 public constant decimals = 18;
343 
344     uint256 private constant TOKEN_UNIT = 10 ** uint256(decimals);
345 
346     uint256 public constant totalSupply = 2302000000 * TOKEN_UNIT;
347     uint256 public constant publicAmount = 1151000000 * TOKEN_UNIT; // Tokens for public
348 
349     uint public startTime;
350     address public crowdsaleAddress;
351 
352     struct TokenLock { uint256 amount; uint duration; bool withdrawn; }
353 
354     TokenLock public foundationLock = TokenLock({
355         amount: 230200000 * TOKEN_UNIT,
356         duration: 720 days,
357         withdrawn: false
358     });
359 
360     TokenLock public teamLock = TokenLock({
361         amount: 299260000 * TOKEN_UNIT,
362         duration: 720 days,
363         withdrawn: false
364     });
365 
366     TokenLock public advisorLock = TokenLock({
367         amount: 276240000 * TOKEN_UNIT,
368         duration: 720 days,
369         withdrawn: false
370     });
371 
372     function Obirum(uint256 lockTill) public {
373         startTime = lockTill;
374 
375         balances[owner] = totalSupply;
376         Transfer(address(0), owner, balances[owner]);
377 
378         lockTokens(foundationLock);
379         lockTokens(teamLock);
380         lockTokens(advisorLock);
381     }
382 
383     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
384         crowdsaleAddress = _crowdsaleAddress;
385         assert(approve(crowdsaleAddress, publicAmount));
386     }
387 
388     function withdrawLocked() external onlyOwner {
389         if(unlockTokens(foundationLock)) foundationLock.withdrawn = true;
390         if(unlockTokens(teamLock)) teamLock.withdrawn = true;
391         if(unlockTokens(advisorLock)) advisorLock.withdrawn = true;
392     }
393 
394     function lockTokens(TokenLock lock) internal {
395         balances[owner] = balances[owner].sub(lock.amount);
396         balances[address(0)] = balances[address(0)].add(lock.amount);
397         Transfer(owner, address(0), lock.amount);
398     }
399 
400     function unlockTokens(TokenLock lock) internal returns (bool) {
401         uint lockReleaseTime = startTime + lock.duration;
402 
403         if(lockReleaseTime < now && lock.withdrawn == false) {
404             balances[owner] = balances[owner].add(lock.amount);
405             balances[address(0)] = balances[address(0)].sub(lock.amount);
406             Transfer(address(0), owner, lock.amount);
407             return true;
408         }
409 
410         return false;
411     }
412 
413     function setStartTime(uint _startTime) external {
414         require(msg.sender == crowdsaleAddress);
415         if(_startTime < startTime) {
416             startTime = _startTime;
417         }
418     }
419 
420     function transfer(address _to, uint _value) public returns (bool) {
421         // Only owner's tokens can be transferred before ICO ends
422         if (now < startTime)
423             require(msg.sender == owner);
424 
425         return super.transfer(_to, _value);
426     }
427 
428     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
429         // Only owner's tokens can be transferred before ICO ends
430         if (now < startTime)
431             require(_from == owner);
432 
433         return super.transferFrom(_from, _to, _value);
434     }
435 
436     function transferOwnership(address newOwner) public onlyOwner {
437         require(now >= startTime);
438         super.transferOwnership(newOwner);
439     }
440 }