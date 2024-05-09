1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title SafeERC20
51  * @dev Wrappers around ERC20 operations that throw on failure.
52  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
53  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
54  */
55 library SafeERC20 {
56   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
57     assert(token.transfer(to, value));
58   }
59 
60   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
61     assert(token.transferFrom(from, to, value));
62   }
63 
64   function safeApprove(ERC20 token, address spender, uint256 value) internal {
65     assert(token.approve(spender, value));
66   }
67 }
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address who) public view returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public view returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   uint256 totalSupply_;
102 
103   /**
104   * @dev total number of tokens in existence
105   */
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     // SafeMath.sub will throw if there is not enough balance.
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
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
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   /**
210    * @dev Decrease the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _subtractedValue The amount of tokens to decrease the allowance by.
218    */
219   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230 }
231 
232 /**
233  * @title Ownable
234  * @dev The Ownable contract has an owner address, and provides basic authorization control
235  * functions, this simplifies the implementation of "user permissions".
236  */
237 contract Ownable {
238   address public owner;
239 
240 
241   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243 
244   /**
245    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
246    * account.
247    */
248   function Ownable() public {
249     owner = msg.sender;
250   }
251 
252   /**
253    * @dev Throws if called by any account other than the owner.
254    */
255   modifier onlyOwner() {
256     require(msg.sender == owner);
257     _;
258   }
259 
260   /**
261    * @dev Allows the current owner to transfer control of the contract to a newOwner.
262    * @param newOwner The address to transfer ownership to.
263    */
264   function transferOwnership(address newOwner) public onlyOwner {
265     require(newOwner != address(0));
266     OwnershipTransferred(owner, newOwner);
267     owner = newOwner;
268   }
269 
270 }
271 
272 /**
273  * @title Mintable token
274  * @dev Simple ERC20 Token example, with mintable token creation
275  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
276  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
277  */
278 contract MintableToken is StandardToken, Ownable {
279   event Mint(address indexed to, uint256 amount);
280   event MintFinished();
281 
282   bool public mintingFinished = false;
283 
284 
285   modifier canMint() {
286     require(!mintingFinished);
287     _;
288   }
289 
290   /**
291    * @dev Function to mint tokens
292    * @param _to The address that will receive the minted tokens.
293    * @param _amount The amount of tokens to mint.
294    * @return A boolean that indicates if the operation was successful.
295    */
296   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
297     totalSupply_ = totalSupply_.add(_amount);
298     balances[_to] = balances[_to].add(_amount);
299     Mint(_to, _amount);
300     Transfer(address(0), _to, _amount);
301     return true;
302   }
303 
304   /**
305    * @dev Function to stop minting new tokens.
306    * @return True if the operation was successful.
307    */
308   function finishMinting() onlyOwner canMint public returns (bool) {
309     mintingFinished = true;
310     MintFinished();
311     return true;
312   }
313 }
314 
315 /**
316  * @title TokenTimelock
317  * @dev TokenTimelock is a token holder contract that will allow a
318  * beneficiary to extract the tokens after a given release time
319  */
320 contract TokenTimelock {
321   using SafeERC20 for ERC20Basic;
322 
323   // ERC20 basic token contract being held
324   ERC20Basic public token;
325 
326   // beneficiary of tokens after they are released
327   address public beneficiary;
328 
329   // timestamp when token release is enabled
330   uint256 public releaseTime;
331 
332   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
333     require(_releaseTime > now);
334     token = _token;
335     beneficiary = _beneficiary;
336     releaseTime = _releaseTime;
337   }
338 
339   /**
340    * @notice Transfers tokens held by timelock to beneficiary.
341    */
342   function release() public {
343     require(now >= releaseTime);
344 
345     uint256 amount = token.balanceOf(this);
346     require(amount > 0);
347 
348     token.safeTransfer(beneficiary, amount);
349   }
350 }
351 
352 contract ChineseDragonToken is MintableToken {
353 
354     string public name = 'Chinese Dragon';
355     string public symbol = 'CDG';
356     uint8 public decimals = 18;
357 
358     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public onlyOwner canMint returns (TokenTimelock) {
359         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
360         mint(timelock, (_amount * (10 ** uint256(decimals))));
361         return timelock;
362     }
363 
364 }