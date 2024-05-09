1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract Pausable is Ownable {
67   event Pause();
68   event Unpause();
69 
70   bool public paused = false;
71 
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is not paused.
75    */
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is paused.
83    */
84   modifier whenPaused() {
85     require(paused);
86     _;
87   }
88 
89   /**
90    * @dev called by the owner to pause, triggers stopped state
91    */
92   function pause() onlyOwner whenNotPaused public {
93     paused = true;
94     Pause();
95   }
96 
97   /**
98    * @dev called by the owner to unpause, returns to normal state
99    */
100   function unpause() onlyOwner whenPaused public {
101     paused = false;
102     Unpause();
103   }
104 }
105 
106 contract Contactable is Ownable{
107 
108     string public contactInformation;
109 
110     /**
111      * @dev Allows the owner to set a string with their contact information.
112      * @param info The contact information to attach to the contract.
113      */
114     function setContactInformation(string info) onlyOwner public {
115          contactInformation = info;
116      }
117 }
118 
119 contract HasNoEther is Ownable {
120 
121   /**
122   * @dev Constructor that rejects incoming Ether
123   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
124   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
125   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
126   * we could use assembly to access msg.value.
127   */
128   function HasNoEther() payable {
129     require(msg.value == 0);
130   }
131 
132   /**
133    * @dev Disallows direct send by settings a default function without the `payable` flag.
134    */
135   function() external {
136   }
137 
138   /**
139    * @dev Transfer all Ether held by the contract to the owner.
140    */
141   function reclaimEther() external onlyOwner {
142     assert(owner.send(this.balance));
143   }
144 }
145 
146 contract ERC20Basic {
147   uint256 public totalSupply;
148   function balanceOf(address who) public constant returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) balances;
157 
158   /**
159   * @dev transfer token for a specified address
160   * @param _to The address to transfer to.
161   * @param _value The amount to be transferred.
162   */
163   function transfer(address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165 
166     // SafeMath.sub will throw if there is not enough balance.
167     balances[msg.sender] = balances[msg.sender].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     Transfer(msg.sender, _to, _value);
170     return true;
171   }
172 
173   /**
174   * @dev Gets the balance of the specified address.
175   * @param _owner The address to query the the balance of.
176   * @return An uint256 representing the amount owned by the passed address.
177   */
178   function balanceOf(address _owner) public constant returns (uint256 balance) {
179     return balances[_owner];
180   }
181 
182 }
183 
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public constant returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 library SafeERC20 {
192   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
193     assert(token.transfer(to, value));
194   }
195 
196   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
197     assert(token.transferFrom(from, to, value));
198   }
199 
200   function safeApprove(ERC20 token, address spender, uint256 value) internal {
201     assert(token.approve(spender, value));
202   }
203 }
204 
205 contract CanReclaimToken is Ownable {
206   using SafeERC20 for ERC20Basic;
207 
208   /**
209    * @dev Reclaim all ERC20Basic compatible tokens
210    * @param token ERC20Basic The address of the token contract
211    */
212   function reclaimToken(ERC20Basic token) external onlyOwner {
213     uint256 balance = token.balanceOf(this);
214     token.safeTransfer(owner, balance);
215   }
216 
217 }
218 
219 contract HasNoTokens is CanReclaimToken {
220 
221  /**
222   * @dev Reject all ERC23 compatible tokens
223   * @param from_ address The address that is transferring the tokens
224   * @param value_ uint256 the amount of the specified token
225   * @param data_ Bytes The data passed from the caller.
226   */
227   function tokenFallback(address from_, uint256 value_, bytes data_) external {
228     revert();
229   }
230 
231 }
232 
233 contract StandardToken is ERC20, BasicToken {
234 
235   mapping (address => mapping (address => uint256)) allowed;
236 
237 
238   /**
239    * @dev Transfer tokens from one address to another
240    * @param _from address The address which you want to send tokens from
241    * @param _to address The address which you want to transfer to
242    * @param _value uint256 the amount of tokens to be transferred
243    */
244   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
245     require(_to != address(0));
246 
247     uint256 _allowance = allowed[_from][msg.sender];
248 
249     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
250     // require (_value <= _allowance);
251 
252     balances[_from] = balances[_from].sub(_value);
253     balances[_to] = balances[_to].add(_value);
254     allowed[_from][msg.sender] = _allowance.sub(_value);
255     Transfer(_from, _to, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261    *
262    * Beware that changing an allowance with this method brings the risk that someone may use both the old
263    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
264    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
265    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266    * @param _spender The address which will spend the funds.
267    * @param _value The amount of tokens to be spent.
268    */
269   function approve(address _spender, uint256 _value) public returns (bool) {
270     allowed[msg.sender][_spender] = _value;
271     Approval(msg.sender, _spender, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Function to check the amount of tokens that an owner allowed to a spender.
277    * @param _owner address The address which owns the funds.
278    * @param _spender address The address which will spend the funds.
279    * @return A uint256 specifying the amount of tokens still available for the spender.
280    */
281   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
282     return allowed[_owner][_spender];
283   }
284 
285   /**
286    * approve should be called when allowed[_spender] == 0. To increment
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    */
291   function increaseApproval (address _spender, uint _addedValue)
292     returns (bool success) {
293     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298   function decreaseApproval (address _spender, uint _subtractedValue)
299     returns (bool success) {
300     uint oldValue = allowed[msg.sender][_spender];
301     if (_subtractedValue > oldValue) {
302       allowed[msg.sender][_spender] = 0;
303     } else {
304       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305     }
306     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310 }
311 
312 contract MintableToken is StandardToken, Ownable {
313   event Mint(address indexed to, uint256 amount);
314   event MintFinished();
315 
316   bool public mintingFinished = false;
317 
318 
319   modifier canMint() {
320     require(!mintingFinished);
321     _;
322   }
323 
324   /**
325    * @dev Function to mint tokens
326    * @param _to The address that will receive the minted tokens.
327    * @param _amount The amount of tokens to mint.
328    * @return A boolean that indicates if the operation was successful.
329    */
330   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
331     totalSupply = totalSupply.add(_amount);
332     balances[_to] = balances[_to].add(_amount);
333     Mint(_to, _amount);
334     Transfer(0x0, _to, _amount);
335     return true;
336   }
337 
338   /**
339    * @dev Function to stop minting new tokens.
340    * @return True if the operation was successful.
341    */
342   function finishMinting() onlyOwner public returns (bool) {
343     mintingFinished = true;
344     MintFinished();
345     return true;
346   }
347 }
348 
349 contract PausableToken is StandardToken, Pausable {
350 
351   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
352     return super.transfer(_to, _value);
353   }
354 
355   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
356     return super.transferFrom(_from, _to, _value);
357   }
358 
359   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
360     return super.approve(_spender, _value);
361   }
362 
363   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
364     return super.increaseApproval(_spender, _addedValue);
365   }
366 
367   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
368     return super.decreaseApproval(_spender, _subtractedValue);
369   }
370 }
371 
372 contract FlipToken is Contactable, HasNoTokens, HasNoEther, MintableToken, PausableToken {
373 
374     string public constant name = "FLIP Token";
375     string public constant symbol = "FLP";
376     uint8 public constant decimals = 18;
377 
378     uint256 public constant ONE_TOKENS = (10 ** uint256(decimals));
379     uint256 public constant MILLION_TOKENS = (10**6) * ONE_TOKENS;
380     uint256 public constant TOTAL_TOKENS = 100 * MILLION_TOKENS;
381 
382     function FlipToken()
383     Ownable()
384     Contactable()
385     HasNoTokens()
386     HasNoEther()
387     MintableToken()
388     PausableToken()
389     {
390         contactInformation = 'https://tokensale.gameflip.com/';
391     }
392 
393     // cap minting so that totalSupply <= TOTAL_TOKENS
394     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
395         require(totalSupply.add(_amount) <= TOTAL_TOKENS);
396         return super.mint(_to, _amount);
397     }
398 
399 
400     /**
401     * @dev Allows the current owner to transfer control of the contract to a newOwner.
402     * @param newOwner The address to transfer ownership to.
403     */
404     function transferOwnership(address newOwner) onlyOwner public {
405         // do not allow self ownership
406         require(newOwner != address(this));
407         super.transferOwnership(newOwner);
408     }
409 }