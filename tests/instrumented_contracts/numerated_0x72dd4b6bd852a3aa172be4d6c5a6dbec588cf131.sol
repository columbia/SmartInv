1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63     if (a == 0) {
64       return 0;
65     }
66     uint256 c = a * b;
67     assert(c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances.
93  */
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     // SafeMath.sub will throw if there is not enough balance.
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256 balance) {
121     return balances[_owner];
122   }
123 
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public view returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206     uint oldValue = allowed[msg.sender][_spender];
207     if (_subtractedValue > oldValue) {
208       allowed[msg.sender][_spender] = 0;
209     } else {
210       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211     }
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216 }
217 
218 /**
219  * @title Mintable token
220  * @dev Simple ERC20 Token example, with mintable token creation
221  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
222  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
223  */
224 
225 contract MintableToken is StandardToken, Ownable {
226   event Mint(address indexed to, uint256 amount);
227   event MintFinished();
228 
229   bool public mintingFinished = false;
230 
231 
232   modifier canMint() {
233     require(!mintingFinished);
234     _;
235   }
236 
237   /**
238    * @dev Function to mint tokens
239    * @param _to The address that will receive the minted tokens.
240    * @param _amount The amount of tokens to mint.
241    * @return A boolean that indicates if the operation was successful.
242    */
243   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
244     totalSupply = totalSupply.add(_amount);
245     balances[_to] = balances[_to].add(_amount);
246     Mint(_to, _amount);
247     Transfer(address(0), _to, _amount);
248     return true;
249   }
250 
251   /**
252    * @dev Function to stop minting new tokens.
253    * @return True if the operation was successful.
254    */
255   function finishMinting() onlyOwner canMint public returns (bool) {
256     mintingFinished = true;
257     MintFinished();
258     return true;
259   }
260 }
261 
262 /**
263  * @title SafeERC20
264  * @dev Wrappers around ERC20 operations that throw on failure.
265  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
266  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
267  */
268 library SafeERC20 {
269   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
270     assert(token.transfer(to, value));
271   }
272 
273   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
274     assert(token.transferFrom(from, to, value));
275   }
276 
277   function safeApprove(ERC20 token, address spender, uint256 value) internal {
278     assert(token.approve(spender, value));
279   }
280 }
281 
282 /**
283  * @title Contracts that should be able to recover tokens
284  * @author SylTi
285  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
286  * This will prevent any accidental loss of tokens.
287  */
288 contract CanReclaimToken is Ownable {
289   using SafeERC20 for ERC20Basic;
290 
291   /**
292    * @dev Reclaim all ERC20Basic compatible tokens
293    * @param token ERC20Basic The address of the token contract
294    */
295   function reclaimToken(ERC20Basic token) external onlyOwner {
296     uint256 balance = token.balanceOf(this);
297     token.safeTransfer(owner, balance);
298   }
299 
300 }
301 
302 /**
303  * @title Contracts that should not own Ether
304  * @author Remco Bloemen <remco@2π.com>
305  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
306  * in the contract, it will allow the owner to reclaim this ether.
307  * @notice Ether can still be send to this contract by:
308  * calling functions labeled `payable`
309  * `selfdestruct(contract_address)`
310  * mining directly to the contract address
311 */
312 contract HasNoEther is Ownable {
313 
314   /**
315   * @dev Constructor that rejects incoming Ether
316   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
317   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
318   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
319   * we could use assembly to access msg.value.
320   */
321   function HasNoEther() public payable {
322     require(msg.value == 0);
323   }
324 
325   /**
326    * @dev Disallows direct send by settings a default function without the `payable` flag.
327    */
328   function() external {
329   }
330 
331   /**
332    * @dev Transfer all Ether held by the contract to the owner.
333    */
334   function reclaimEther() external onlyOwner {
335     assert(owner.send(this.balance));
336   }
337 }
338 
339 /**
340  * @title Contracts that should not own Tokens
341  * @author Remco Bloemen <remco@2π.com>
342  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
343  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
344  * owner to reclaim the tokens.
345  */
346 contract HasNoTokens is CanReclaimToken {
347 
348  /**
349   * @dev Reject all ERC23 compatible tokens
350   * @param from_ address The address that is transferring the tokens
351   * @param value_ uint256 the amount of the specified token
352   * @param data_ Bytes The data passed from the caller.
353   */
354   function tokenFallback(address from_, uint256 value_, bytes data_) external {
355     from_;
356     value_;
357     data_;
358     revert();
359   }
360 
361 }
362 
363 /**
364  * @title Contracts that should not own Contracts
365  * @author Remco Bloemen <remco@2π.com>
366  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
367  * of this contract to reclaim ownership of the contracts.
368  */
369 contract HasNoContracts is Ownable {
370 
371   /**
372    * @dev Reclaim ownership of Ownable contracts
373    * @param contractAddr The address of the Ownable to be reclaimed.
374    */
375   function reclaimContract(address contractAddr) external onlyOwner {
376     Ownable contractInst = Ownable(contractAddr);
377     contractInst.transferOwnership(owner);
378   }
379 }
380 
381 /**
382  * @title Base contract for contracts that should not own things.
383  * @author Remco Bloemen <remco@2π.com>
384  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
385  * Owned contracts. See respective base contracts for details.
386  */
387 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
388 }
389 
390 
391 contract NAGACoin is MintableToken, NoOwner {
392     string public constant name = "NAGA Coin";
393     string public constant symbol = "NGC";
394     uint8 public constant decimals = 18;
395 
396     mapping (address => uint256) public releaseTimes;
397 
398     function mintWithTimeLock(address _to, uint256 _amount, uint256 _releaseTime) public returns (bool) {
399         if (_releaseTime > releaseTimes[_to]) {
400             releaseTimes[_to] = _releaseTime;
401         }
402 
403         return mint(_to, _amount);
404     }
405 
406     function transfer(address _to, uint256 _value) public returns (bool) {
407         // Transfer of time-locked funds is forbidden
408         require(!timeLocked(msg.sender));
409 
410         return super.transfer(_to, _value);
411     }
412 
413     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
414         // Transfer of time-locked funds is forbidden
415         require(!timeLocked(_from));
416 
417         return super.transferFrom(_from, _to, _value);
418     }
419 
420     // Checks if funds of a given address are time-locked
421     function timeLocked(address _spender) public returns (bool) {
422         if (releaseTimes[_spender] == 0) {
423             return false;
424         }
425 
426         // If time-lock is expired, delete it
427         // We consider timestamp dependency to be safe enough in this application
428         if (releaseTimes[_spender] <= block.timestamp) {
429             delete releaseTimes[_spender];
430             return false;
431         }
432 
433         return true;
434     }
435 }