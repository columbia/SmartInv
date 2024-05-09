1 pragma solidity 0.4.25;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   uint256 totalSupply_;
16 
17   /**
18   * @dev Total number of tokens in existence
19   */
20   function totalSupply() public view returns (uint256) {
21     return totalSupply_;
22   }
23 
24   /**
25   * @dev Transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_value <= balances[msg.sender]);
31     require(_to != address(0));
32 
33     balances[msg.sender] = balances[msg.sender].sub(_value);
34     balances[_to] = balances[_to].add(_value);
35     emit Transfer(msg.sender, _to, _value);
36     return true;
37   }
38 
39   /**
40   * @dev Gets the balance of the specified address.
41   * @param _owner The address to query the the balance of.
42   * @return An uint256 representing the amount owned by the passed address.
43   */
44   function balanceOf(address _owner) public view returns (uint256) {
45     return balances[_owner];
46   }
47 
48 }
49 
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender)
52     public view returns (uint256);
53 
54   function transferFrom(address from, address to, uint256 value)
55     public returns (bool);
56 
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(
59     address indexed owner,
60     address indexed spender,
61     uint256 value
62   );
63 }
64 
65 contract Ownable {
66   address public owner;
67 
68 
69   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   constructor() public {
77     owner = msg.sender;
78   }
79 
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89 
90   /**
91    * @dev Allows the current owner to transfer control of the contract to a newOwner.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address newOwner) public onlyOwner {
95     require(newOwner != address(0));
96     emit OwnershipTransferred(owner, newOwner);
97     owner = newOwner;
98   }
99 
100 }
101 
102 contract Claimable is Ownable {
103   address public pendingOwner;
104 
105   /**
106    * @dev Modifier throws if called by any account other than the pendingOwner.
107    */
108   modifier onlyPendingOwner() {
109     require(msg.sender == pendingOwner);
110     _;
111   }
112 
113   /**
114    * @dev Allows the current owner to set the pendingOwner address.
115    * @param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) onlyOwner public {
118     pendingOwner = newOwner;
119   }
120 
121   /**
122    * @dev Allows the pendingOwner address to finalize the transfer.
123    */
124   function claimOwnership() onlyPendingOwner public {
125     emit OwnershipTransferred(owner, pendingOwner);
126     owner = pendingOwner;
127     pendingOwner = address(0);
128   }
129 }
130 
131 contract Pausable {
132     address public requester;
133     address public approver;
134 
135     bool public paused = true;
136     bool public pausePending = false;
137     bool public unpausePending = false;
138 
139     function requestPause() public onlyRequester {
140         pausePending = true;
141         unpausePending = false;
142     }
143 
144     function requestUnpause() public onlyRequester {
145         pausePending = false;
146         unpausePending = true;
147     }
148 
149     function cancelRequestPause() public onlyRequester {
150         pausePending = false;
151     }
152 
153     function approveRequestPause() public onlyApprover {
154         require(pausePending);
155         pausePending = false;
156         paused = true;
157     }
158 
159     function rejectRequestPause() public onlyApprover {
160         pausePending = false;
161     }
162 
163     function cancelRequestUnpause() public onlyRequester {
164         unpausePending = false;
165     }
166 
167     function approveRequestUnpause() public onlyApprover {
168         require(unpausePending);
169         unpausePending = false;
170         paused = false;
171     }
172 
173     function rejectRequestUnpause() public onlyApprover {
174         unpausePending = false;
175     }
176 
177     /**
178      * @dev Throws if called by any account other than the owner.
179      */
180     modifier whenPaused() {
181         require(paused);
182         _;
183     }
184 
185     modifier whenNotPaused() {
186         require(!paused);
187         _;
188     }
189 
190     modifier onlyRequester() {
191         require(msg.sender == requester);
192         _;
193     }
194 
195     modifier onlyApprover() {
196         require(msg.sender == approver);
197         _;
198     }
199 }
200 
201 library SafeMath {
202 
203   /**
204   * @dev Multiplies two numbers, throws on overflow.
205   */
206   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
207     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
208     // benefit is lost if 'b' is also tested.
209     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
210     if (a == 0) {
211       return 0;
212     }
213 
214     c = a * b;
215     assert(c / a == b);
216     return c;
217   }
218 
219   /**
220   * @dev Integer division of two numbers, truncating the quotient.
221   */
222   function div(uint256 a, uint256 b) internal pure returns (uint256) {
223     // assert(b > 0); // Solidity automatically throws when dividing by 0
224     // uint256 c = a / b;
225     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226     return a / b;
227   }
228 
229   /**
230   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
231   */
232   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233     assert(b <= a);
234     return a - b;
235   }
236 
237   /**
238   * @dev Adds two numbers, throws on overflow.
239   */
240   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
241     c = a + b;
242     assert(c >= a);
243     return c;
244   }
245 }
246 
247 contract StandardToken is ERC20, BasicToken {
248 
249   mapping (address => mapping (address => uint256)) internal allowed;
250 
251 
252   /**
253    * @dev Transfer tokens from one address to another
254    * @param _from address The address which you want to send tokens from
255    * @param _to address The address which you want to transfer to
256    * @param _value uint256 the amount of tokens to be transferred
257    */
258   function transferFrom(
259     address _from,
260     address _to,
261     uint256 _value
262   )
263     public
264     returns (bool)
265   {
266     require(_value <= balances[_from]);
267     require(_value <= allowed[_from][msg.sender]);
268     require(_to != address(0));
269 
270     balances[_from] = balances[_from].sub(_value);
271     balances[_to] = balances[_to].add(_value);
272     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273     emit Transfer(_from, _to, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
279    * Beware that changing an allowance with this method brings the risk that someone may use both the old
280    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
281    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
282    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
283    * @param _spender The address which will spend the funds.
284    * @param _value The amount of tokens to be spent.
285    */
286   function approve(address _spender, uint256 _value) public returns (bool) {
287     allowed[msg.sender][_spender] = _value;
288     emit Approval(msg.sender, _spender, _value);
289     return true;
290   }
291 
292   /**
293    * @dev Function to check the amount of tokens that an owner allowed to a spender.
294    * @param _owner address The address which owns the funds.
295    * @param _spender address The address which will spend the funds.
296    * @return A uint256 specifying the amount of tokens still available for the spender.
297    */
298   function allowance(
299     address _owner,
300     address _spender
301    )
302     public
303     view
304     returns (uint256)
305   {
306     return allowed[_owner][_spender];
307   }
308 
309   /**
310    * @dev Increase the amount of tokens that an owner allowed to a spender.
311    * approve should be called when allowed[_spender] == 0. To increment
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    * @param _spender The address which will spend the funds.
316    * @param _addedValue The amount of tokens to increase the allowance by.
317    */
318   function increaseAllowance(
319     address _spender,
320     uint256 _addedValue
321   )
322     public
323     returns (bool)
324   {
325     allowed[msg.sender][_spender] = (
326       allowed[msg.sender][_spender].add(_addedValue));
327     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328     return true;
329   }
330 
331   /**
332    * @dev Decrease the amount of tokens that an owner allowed to a spender.
333    * approve should be called when allowed[_spender] == 0. To decrement
334    * allowed value is better to use this function to avoid 2 calls (and wait until
335    * the first transaction is mined)
336    * From MonolithDAO Token.sol
337    * @param _spender The address which will spend the funds.
338    * @param _subtractedValue The amount of tokens to decrease the allowance by.
339    */
340   function decreaseAllowance(
341     address _spender,
342     uint256 _subtractedValue
343   )
344     public
345     returns (bool)
346   {
347     uint256 oldValue = allowed[msg.sender][_spender];
348     if (_subtractedValue >= oldValue) {
349       allowed[msg.sender][_spender] = 0;
350     } else {
351       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
352     }
353     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
354     return true;
355   }
356 
357 }
358 
359 contract StacsToken is StandardToken, Claimable, Pausable {
360     using SafeMath for uint256;
361 
362     uint8 public constant decimals = 18;
363     string public constant symbol = "STACS";
364     string public constant name = "STACS";
365     uint256 private constant MAX_TOKEN_SUPPLY = 900000000 * (10 ** uint256(decimals));
366     bool public migrationPhase = true;
367     address public migrationOperator;
368 
369     constructor(address _migrationOperator, address _requester, address _approver) public {
370         owner = msg.sender;
371         migrationOperator = _migrationOperator;
372         requester = _requester;
373         approver = _approver;
374     }
375 
376     /**
377     * @dev Mint specified number of tokens to respective address. Can only be called during migration phase
378     * @param _accounts The target addresses to transfer to.
379     * @param _amounts The amounts to be transferred.
380     */
381     function mint(address[] _accounts, uint256[] _amounts) public onlyMigrationOperator {
382         require(migrationPhase);
383         uint256 length = _accounts.length;
384         require(length == _amounts.length);
385         for (uint256 i = 0; i < length; i++) {
386             balances[_accounts[i]] = balances[_accounts[i]].add(_amounts[i]);
387             emit Transfer(address(0), _accounts[i], _amounts[i]);
388             totalSupply_ = totalSupply_.add(_amounts[i]);
389         }
390         require(totalSupply_ <= MAX_TOKEN_SUPPLY);
391     }
392 
393     /**
394     * @dev End migration phase and disallow minting
395     */
396     function endMigration() public onlyOwner {
397         migrationPhase = false;
398     }
399 
400     /**
401     * @dev Transfer any ERC20 token belonging to this contract to owner
402     * @param tokenAddress The target ERC20 token address
403     * @param tokens The amount of tokens to be transferred
404     */
405     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
406         return ERC20Basic(tokenAddress).transfer(owner, tokens);
407     }
408 
409     modifier onlyMigrationOperator() {
410         require(msg.sender == migrationOperator);
411         _;
412     }
413 
414     // Overriden methods
415     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
416         return super.transfer(_to, _value);
417     }
418 
419     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
420         return super.transferFrom(_from, _to, _value);
421     }
422 
423     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
424         return super.approve(spender, value);
425     }
426 
427     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
428         return super.increaseAllowance(spender, addedValue);
429     }
430 
431     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
432         return super.decreaseAllowance(spender, subtractedValue);
433     }
434 }