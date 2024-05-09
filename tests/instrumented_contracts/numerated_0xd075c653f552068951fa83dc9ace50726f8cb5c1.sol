1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender)
12         public view returns (uint256);
13 
14     function transferFrom(address from, address to, uint256 value)
15         public returns (bool);
16 
17     function approve(address spender, uint256 value) public returns (bool);
18     
19     event Approval(
20         address indexed owner,
21         address indexed spender,
22         uint256 value
23     );
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
38     // benefit is lost if 'b' is also tested.
39     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40     if (a == 0) {
41       return 0;
42     }
43 
44     c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   /**
50   * @dev Integer division of two numbers, truncating the quotient.
51   */
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     // uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return a / b;
57   }
58 
59   /**
60   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   /**
68   * @dev Adds two numbers, throws on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   uint256 totalSupply_;
89 
90   /**
91   * @dev Total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev Transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256) {
118     return balances[_owner];
119   }
120 }
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * https://github.com/ethereum/EIPs/issues/20
128  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amount of tokens to be transferred
140    */
141   function transferFrom(
142     address _from,
143     address _to,
144     uint256 _value
145   )
146     public
147     returns (bool)
148   {
149     require(_to != address(0));
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     emit Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    * Beware that changing an allowance with this method brings the risk that someone may use both the old
163    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    * @param _spender The address which will spend the funds.
167    * @param _value The amount of tokens to be spent.
168    */
169   function approve(address _spender, uint256 _value) public returns (bool) {
170     allowed[msg.sender][_spender] = _value;
171     emit Approval(msg.sender, _spender, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param _owner address The address which owns the funds.
178    * @param _spender address The address which will spend the funds.
179    * @return A uint256 specifying the amount of tokens still available for the spender.
180    */
181   function allowance(
182     address _owner,
183     address _spender
184    )
185     public
186     view
187     returns (uint256)
188   {
189     return allowed[_owner][_spender];
190   }
191 
192   /**
193    * @dev Increase the amount of tokens that an owner allowed to a spender.
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _addedValue The amount of tokens to increase the allowance by.
200    */
201   function increaseApproval(
202     address _spender,
203     uint256 _addedValue
204   )
205     public
206     returns (bool)
207   {
208     allowed[msg.sender][_spender] = (
209       allowed[msg.sender][_spender].add(_addedValue));
210     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214   /**
215    * @dev Decrease the amount of tokens that an owner allowed to a spender.
216    * approve should be called when allowed[_spender] == 0. To decrement
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _subtractedValue The amount of tokens to decrease the allowance by.
222    */
223   function decreaseApproval(
224     address _spender,
225     uint256 _subtractedValue
226   )
227     public
228     returns (bool)
229   {
230     uint256 oldValue = allowed[msg.sender][_spender];
231     if (_subtractedValue > oldValue) {
232       allowed[msg.sender][_spender] = 0;
233     } else {
234       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235     }
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 }
240 
241 contract MultiOwnable {
242     address public superOwner;
243     mapping (address => bool) owners;
244     
245     event ChangeSuperOwner(address indexed newSuperOwner);
246     event AddOwner(address indexed newOwner);
247     event DeleteOwner(address indexed toDeleteOwner);
248 
249     constructor() public {
250         superOwner = msg.sender;
251         owners[superOwner] = true;
252     }
253 
254     modifier onlySuperOwner() {
255         require(superOwner == msg.sender);
256         _;
257     }
258 
259     modifier onlyOwner() {
260         require(owners[msg.sender]);
261         _;
262     }
263 
264     function addOwner(address owner) public onlySuperOwner returns (bool) {
265         require(owner != address(0));
266         owners[owner] = true;
267         emit AddOwner(owner);
268         return true;
269     }
270 
271     function deleteOwner(address owner) public onlySuperOwner returns (bool) {
272         
273         require(owner != address(0));
274         owners[owner] = false;
275         
276         emit DeleteOwner(owner);
277         
278         return true;
279     }
280     function changeSuperOwner(address _superOwner) public onlySuperOwner returns(bool) {
281         
282         superOwner = _superOwner;
283         
284         emit ChangeSuperOwner(_superOwner);
285         
286         return true;
287     }
288 
289     function chkOwner(address owner) public view returns (bool) {
290         return owners[owner];
291     }
292 }
293 
294 contract HasNoEther is MultiOwnable {
295     
296     /**
297   * @dev Constructor that rejects incoming Ether
298   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
299   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
300   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
301   * we could use assembly to access msg.value.
302   */
303     constructor() public payable {
304         require(msg.value == 0);
305     }
306     
307     /**
308    * @dev Disallows direct send by settings a default function without the `payable` flag.
309    */
310     function() external {
311     }
312     
313     /**
314    * @dev Transfer all Ether held by the contract to the owner.
315    */
316     function reclaimEther() external onlySuperOwner returns (bool) {
317         superOwner.transfer(address(this).balance);
318 
319         return true;
320     }
321 }
322 
323 contract Blacklist is MultiOwnable {
324    
325     mapping(address => bool) blacklisted;
326     
327     event TMTG_Blacklisted(address indexed blacklist);
328     event TMTG_Whitelisted(address indexed whitelist);
329 
330     modifier whenPermitted(address node) {
331         require(!blacklisted[node]);
332         _;
333     }
334     
335     /**
336     * @dev Check a certain node is in a blacklist
337     * @param node  Check whether the user at a certain node is in a blacklist
338     */
339     function isPermitted(address node) public view returns (bool) {
340         return !blacklisted[node];
341     }
342 
343     /**
344     * @dev Process blacklisting
345     * @param node Process blacklisting. Put the user in the blacklist.   
346     */
347     function blacklist(address node) public onlyOwner returns (bool) {
348         blacklisted[node] = true;
349         emit TMTG_Blacklisted(node);
350 
351         return blacklisted[node];
352     }
353 
354     /**
355     * @dev Process unBlacklisting. 
356     * @param node Remove the user from the blacklist.   
357     */
358     function unblacklist(address node) public onlyOwner returns (bool) {
359         blacklisted[node] = false;
360         emit TMTG_Whitelisted(node);
361 
362         return blacklisted[node];
363     }
364 }
365 
366 contract PausableToken is StandardToken, HasNoEther, Blacklist {
367     bool public paused = true;
368 
369     /**
370      * @dev 거래 중지 상태에서도 거래 가능 계정
371      */
372     mapping(address => bool) public unlockAddrs;
373 
374     event Pause(address addr);
375     event Unpause(address addr);
376     event UnlockAddress(address addr);
377     event LockAddress(address addr);
378     
379     /**
380      * @dev 서킷브레이커가 작동하거나 해당 계정이 언락인 경우
381      */
382 
383     modifier checkUnlock(address addr) {
384         require(!paused || unlockAddrs[addr]);
385         _;
386     }
387 
388     function unlockAddress (address addr) public onlyOwner returns (bool) {
389         unlockAddrs[addr] = true;
390         emit UnlockAddress(addr);
391 
392         return unlockAddrs[addr];
393     }
394 
395     function lockAddress (address addr) public onlyOwner returns (bool) {
396         unlockAddrs[addr] = false;
397         emit LockAddress(addr);
398 
399         return unlockAddrs[addr];
400     }
401 
402     function pause() public onlyOwner returns (bool) {
403         paused = true;
404         emit Pause(msg.sender);
405 
406         return paused;
407     }
408 
409     function unpause() public onlyOwner returns (bool) {
410         paused = false;
411         emit Unpause(msg.sender);
412 
413         return paused;
414     }
415 
416     function transfer(address to, uint256 value) public checkUnlock(msg.sender) returns (bool) {
417         return super.transfer(to, value);
418     }
419 
420     function transferFrom(address from, address to, uint256 value) public checkUnlock(from) returns (bool) {
421         return super.transferFrom(from, to, value);
422     }
423 }
424 
425 contract lbcCoin is PausableToken {
426     string public constant name = "BIO";
427     uint8 public constant decimals = 18;
428     string public constant symbol = "BIO";
429     uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals)); 
430 
431     constructor() public {
432         totalSupply_ = INITIAL_SUPPLY;
433         balances[msg.sender] = INITIAL_SUPPLY;
434         
435         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
436     }
437 
438     function destory() onlySuperOwner public returns (bool) {
439         
440         selfdestruct(superOwner);
441 
442         return true;
443 
444     }
445 }