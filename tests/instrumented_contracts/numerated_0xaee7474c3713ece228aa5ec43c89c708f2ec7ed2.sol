1 pragma solidity ^0.5.3;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, reverts on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43     // benefit is lost if 'b' is also tested.
44     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45     if (a == 0) {
46       return 0;
47     }
48 
49     uint256 c = a * b;
50     require(c / a == b);
51 
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b > 0); // Solidity only automatically asserts when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63     return c;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b <= a);
71     uint256 c = a - b;
72 
73     return c;
74   }
75 
76   /**
77   * @dev Adds two numbers, reverts on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     require(c >= a);
82 
83     return c;
84   }
85 
86   /**
87   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
88   * reverts when dividing by zero.
89   */
90   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91     require(b != 0);
92     return a % b;
93   }
94 }
95 
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
102  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract ERC20 is IERC20 {
105   using SafeMath for uint256;
106 
107   mapping (address => uint256) private _balances;
108 
109   mapping (address => mapping (address => uint256)) private _allowed;
110 
111   uint256 private _totalSupply;
112 
113   /**
114   * @dev Total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return _totalSupply;
118   }
119 
120   /**
121   * @dev Gets the balance of the specified address.
122   * @param owner The address to query the balance of.
123   * @return An uint256 representing the amount owned by the passed address.
124   */
125   function balanceOf(address owner) public view returns (uint256) {
126     return _balances[owner];
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param owner address The address which owns the funds.
132    * @param spender address The address which will spend the funds.
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135   function allowance(
136     address owner,
137     address spender
138    )
139     public
140     view
141     returns (uint256)
142   {
143     return _allowed[owner][spender];
144   }
145 
146   /**
147   * @dev Transfer token for a specified address
148   * @param to The address to transfer to.
149   * @param value The amount to be transferred.
150   */
151   function transfer(address to, uint256 value) public returns (bool) {
152     require(value <= _balances[msg.sender]);
153     require(to != address(0));
154 
155     _balances[msg.sender] = _balances[msg.sender].sub(value);
156     _balances[to] = _balances[to].add(value);
157     emit Transfer(msg.sender, to, value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param spender The address which will spend the funds.
168    * @param value The amount of tokens to be spent.
169    */
170   function approve(address spender, uint256 value) public returns (bool) {
171     require(spender != address(0));
172 
173     _allowed[msg.sender][spender] = value;
174     emit Approval(msg.sender, spender, value);
175     return true;
176   }
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param from address The address which you want to send tokens from
181    * @param to address The address which you want to transfer to
182    * @param value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(
185     address from,
186     address to,
187     uint256 value
188   )
189     public
190     returns (bool)
191   {
192     require(value <= _balances[from]);
193     require(value <= _allowed[from][msg.sender]);
194     require(to != address(0));
195 
196     _balances[from] = _balances[from].sub(value);
197     _balances[to] = _balances[to].add(value);
198     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
199     emit Transfer(from, to, value);
200     return true;
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    * approve should be called when allowed_[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param spender The address which will spend the funds.
210    * @param addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseAllowance(
213     address spender,
214     uint256 addedValue
215   )
216     public
217     returns (bool)
218   {
219     require(spender != address(0));
220 
221     _allowed[msg.sender][spender] = (
222       _allowed[msg.sender][spender].add(addedValue));
223     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed_[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param spender The address which will spend the funds.
234    * @param subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseAllowance(
237     address spender,
238     uint256 subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = (
246       _allowed[msg.sender][spender].sub(subtractedValue));
247     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Internal function that mints an amount of the token and assigns it to
253    * an account. This encapsulates the modification of balances such that the
254    * proper events are emitted.
255    * @param account The account that will receive the created tokens.
256    * @param amount The amount that will be created.
257    */
258   function _mint(address account, uint256 amount) internal {
259     require(account != 0x0000000000000000000000000000000000000000);
260     _totalSupply = _totalSupply.add(amount);
261     _balances[account] = _balances[account].add(amount);
262     emit Transfer(address(0), account, amount);
263   }
264 
265   /**
266    * @dev Internal function that burns an amount of the token of a given
267    * account.
268    * @param account The account whose tokens will be burnt.
269    * @param amount The amount that will be burnt.
270    */
271   function _burn(address account, uint256 amount) internal {
272     require(account != 0x0000000000000000000000000000000000000000);
273     require(amount <= _balances[account]);
274 
275     _totalSupply = _totalSupply.sub(amount);
276     _balances[account] = _balances[account].sub(amount);
277     emit Transfer(account, address(0), amount);
278   }
279 
280   /**
281    * @dev Internal function that burns an amount of the token of a given
282    * account, deducting from the sender's allowance for said account. Uses the
283    * internal burn function.
284    * @param account The account whose tokens will be burnt.
285    * @param amount The amount that will be burnt.
286    */
287   function _burnFrom(address account, uint256 amount) internal {
288     require(amount <= _allowed[account][msg.sender]);
289 
290     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
291     // this function needs to emit an event with the updated approval.
292     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
293       amount);
294     _burn(account, amount);
295   }
296 }
297 
298 
299 /**
300  * @title ERC20Detailed token
301  * @dev The decimals are only for visualization purposes.
302  * All the operations are done using the smallest and indivisible token unit,
303  * just as on Ethereum all the operations are done in wei.
304  */
305 contract ERC20Detailed is IERC20 {
306     string private _name;
307     string private _symbol;
308     uint8 private _decimals;
309 
310     constructor (string memory name, string memory symbol, uint8 decimals) public {
311         _name = name;
312         _symbol = symbol;
313         _decimals = decimals;
314     }
315 
316     /**
317      * @return the name of the token.
318      */
319     function name() public view returns (string memory) {
320         return _name;
321     }
322 
323     /**
324      * @return the symbol of the token.
325      */
326     function symbol() public view returns (string memory) {
327         return _symbol;
328     }
329 
330     /**
331      * @return the number of decimals of the token.
332      */
333     function decimals() public view returns (uint8) {
334         return _decimals;
335     }
336 }
337 
338 
339 
340 /**
341  * @title SlotToken
342  * @dev Very simple ERC20 Token example, where some tokens are pre-assigned one contract, and the others arre assigned to another
343  * Note they can later distribute these tokens as they wish using `transfer` and other
344  * `ERC20` functions.
345  */
346 contract SlotToken is ERC20, ERC20Detailed {
347     using SafeMath for uint256;
348     
349     uint8 public constant DECIMALS = 18;
350     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));
351     
352     mapping (address => address) private _vote_target_one;
353     mapping (address => address) private _vote_target_two;
354     mapping (address => uint256) private _vote_target_three;
355     event VoteOne(address indexed from, address indexed to);
356     event VoteTwo(address indexed from, address indexed to);
357     event VoteThree(address indexed from, uint256 value);
358 
359     /**
360      * @dev Function to check the vote target one of a token holder
361      * @param holder address The address which owns the funds.
362      * @return A address specifying the voting position held by the holder
363      */
364     function getTypeOneHolderVote(address holder) public view returns (address) {
365         return _vote_target_one[holder];
366     }
367 
368     /**
369      * @dev Set type one holder vote
370      * @param target The address to vote for
371      */
372     function setTypeOneHolderVote(address target) public returns (bool) {
373         _vote_target_one[msg.sender] = target;
374         
375         emit VoteOne(msg.sender, target);
376         return true;
377     }
378 
379     /**
380      * @dev Function to check the vote target two of a token holder
381      * @param holder address The address which owns the funds.
382      * @return A address specifying the voting position held by the holder
383      */
384     function getTypeTwoHolderVote(address holder) public view returns (address) {
385         return _vote_target_two[holder];
386     }
387 
388     /**
389      * @dev Set type two holder vote
390      * @param target The address to vote for
391      */
392     function setTypeTwoHolderVote(address target) public returns (bool) {
393         _vote_target_two[msg.sender] = target;
394         
395         emit VoteTwo(msg.sender, target);
396         return true;
397     }
398 
399     /**
400      * @dev Function to check the vote target three of a token holder
401      * @param holder address The address which owns the funds.
402      * @return A address specifying the voting position held by the holder
403      */
404     function getTypeThreeHolderVote(address holder) public view returns (uint256) {
405         return _vote_target_three[holder];
406     }
407 
408     /**
409      * @dev Set type three holder vote
410      * @param value The address to vote for
411      */
412     function setTypeThreeHolderVote(uint256 value) public returns (bool) {
413         _vote_target_three[msg.sender] = value;
414         
415         emit VoteThree(msg.sender, value);
416         return true;
417     }
418 
419     /**
420      * @dev Constructor that gives msg.sender all of existing tokens.
421      */
422     constructor (address communityGovAddress, address econSupportAddress, uint256 econSupportAmount) public ERC20Detailed("Alphaslot", "SLOT", DECIMALS) {
423         require(econSupportAmount > 0);
424         require(communityGovAddress != address(0));
425         require(econSupportAddress != address(0));
426         require(econSupportAmount<INITIAL_SUPPLY && INITIAL_SUPPLY-econSupportAmount>0);
427         uint256 communityGovAmount = INITIAL_SUPPLY - econSupportAmount;
428         require(communityGovAmount<INITIAL_SUPPLY && econSupportAmount+communityGovAmount == INITIAL_SUPPLY);
429         
430         _mint(communityGovAddress, communityGovAmount);
431         _mint(econSupportAddress, econSupportAmount);
432     }
433 }