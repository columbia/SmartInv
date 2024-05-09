1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner {
66     require(newOwner != address(0));      
67     owner = newOwner;
68   }
69 
70 }
71 
72 
73 /**
74  * @title Claimable
75  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
76  * This allows the new owner to accept the transfer.
77  */
78 contract Claimable is Ownable {
79   address public pendingOwner;
80 
81   /**
82    * @dev Modifier throws if called by any account other than the pendingOwner.
83    */
84   modifier onlyPendingOwner() {
85     require(msg.sender == pendingOwner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to set the pendingOwner address.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) onlyOwner {
94     pendingOwner = newOwner;
95   }
96 
97   /**
98    * @dev Allows the pendingOwner address to finalize the transfer.
99    */
100   function claimOwnership() onlyPendingOwner {
101     owner = pendingOwner;
102     pendingOwner = 0x0;
103   }
104 }
105 
106 pragma solidity ^0.4.11;
107 
108 
109 /**
110  * @title ERC20Basic
111  * @dev Simpler version of ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/179
113  */
114 contract ERC20Basic {
115   uint256 public totalSupply;
116   function balanceOf(address who) constant returns (uint256);
117   function transfer(address to, uint256 value) returns (bool);
118   event Transfer(address indexed from, address indexed to, uint256 value);
119 }
120 
121 pragma solidity ^0.4.11;
122 
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) constant returns (uint256);
130   function transferFrom(address from, address to, uint256 value) returns (bool);
131   function approve(address spender, uint256 value) returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 
136 /**
137  * @title Basic token
138  * @dev Basic version of StandardToken, with no allowances. 
139  */
140 contract BasicToken is ERC20Basic {
141   using SafeMath for uint256;
142 
143   mapping(address => uint256) balances;
144 
145   /**
146   * @dev transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) returns (bool) {
151     require(_to != address(0));
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of. 
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) constant returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 /**
172  * @title Standard ERC20 token
173  *
174  * @dev Implementation of the basic standard token.
175  * @dev https://github.com/ethereum/EIPs/issues/20
176  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
177  */
178 contract StandardToken is ERC20, BasicToken {
179 
180   mapping (address => mapping (address => uint256)) allowed;
181 
182 
183   /**
184    * @dev Transfer tokens from one address to another
185    * @param _from address The address which you want to send tokens from
186    * @param _to address The address which you want to transfer to
187    * @param _value uint256 the amount of tokens to be transferred
188    */
189   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
190     require(_to != address(0));
191 
192     var _allowance = allowed[_from][msg.sender];
193 
194     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
195     // require (_value <= _allowance);
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = _allowance.sub(_value);
200     Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) returns (bool) {
210 
211     // To change the approve amount you first have to reduce the addresses`
212     //  allowance to zero by calling `approve(_spender, 0)` if it is not
213     //  already 0 to mitigate the race condition described here:
214     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
216 
217     allowed[msg.sender][_spender] = _value;
218     Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint256 specifying the amount of tokens still available for the spender.
227    */
228   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
229     return allowed[_owner][_spender];
230   }
231   
232   /**
233    * approve should be called when allowed[_spender] == 0. To increment
234    * allowed value is better to use this function to avoid 2 calls (and wait until 
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    */
238   function increaseApproval (address _spender, uint _addedValue) 
239     returns (bool success) {
240     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
241     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245   function decreaseApproval (address _spender, uint _subtractedValue) 
246     returns (bool success) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 
260 /**
261  * @title Mintable token
262  * @dev Simple ERC20 Token example, with mintable token creation
263  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
264  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
265  */
266 
267 contract MintableToken is StandardToken, Ownable {
268   event Mint(address indexed to, uint256 amount);
269   event MintFinished();
270 
271   bool public mintingFinished = false;
272 
273 
274   modifier canMint() {
275     require(!mintingFinished);
276     _;
277   }
278 
279   /**
280    * @dev Function to mint tokens
281    * @param _to The address that will receive the minted tokens.
282    * @param _amount The amount of tokens to mint.
283    * @return A boolean that indicates if the operation was successful.
284    */
285   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
286     totalSupply = totalSupply.add(_amount);
287     balances[_to] = balances[_to].add(_amount);
288     Mint(_to, _amount);
289     Transfer(0x0, _to, _amount);
290     return true;
291   }
292 
293   /**
294    * @dev Function to stop minting new tokens.
295    * @return True if the operation was successful.
296    */
297   function finishMinting() onlyOwner returns (bool) {
298     mintingFinished = true;
299     MintFinished();
300     return true;
301   }
302 }
303 
304 contract EnergiToken is MintableToken, Claimable {
305 
306   using SafeMath for uint256;
307 
308   string public constant name = "EnergiToken";
309   string public constant symbol = "ETK";
310   string public constant version = "1.0";
311   uint8 public constant decimals = 2;
312 
313   mapping(address => uint256) frozen;
314 
315   function EnergiToken() MintableToken() {
316     owner = msg.sender;
317   }
318 
319  /**
320   * @dev transfer token for a specified address method overridden to support freezing accounts
321   * @param _to The address to transfer to.
322   * @param _value The amount to be transferred.
323   */
324   function transfer(address _to, uint256 _value) returns (bool) {
325     require(_to != address(0));
326     require(frozen[msg.sender] == 0); // I.e. is not frozen
327 
328     // SafeMath.sub will throw if there is not enough balance.
329     balances[msg.sender] = balances[msg.sender].sub(_value);
330     balances[_to] = balances[_to].add(_value);
331     Transfer(msg.sender, _to, _value);
332     return true;
333   }
334 
335   /**
336    * @dev Transfer tokens from one address to another
337    * @param _from address The address which you want to send tokens from
338    * @param _to address The address which you want to transfer to
339    * @param _value uint256 the amount of tokens to be transferred
340    */
341   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
342     require(_to != address(0));
343     require(frozen[_from] == 0); // I.e. is not frozen
344 
345     var _allowance = allowed[_from][msg.sender];
346 
347     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
348     // require (_value <= _allowance);
349 
350     balances[_from] = balances[_from].sub(_value);
351     balances[_to] = balances[_to].add(_value);
352     allowed[_from][msg.sender] = _allowance.sub(_value);
353     Transfer(_from, _to, _value);
354     return true;
355   }
356 
357   /**
358   * @dev Checks if an address is frozen
359   * @param _addr The address to query
360   * @return An uint256 representing frozen or not. 0 = Unfrozen, 1 = Frozen
361   */
362   function isFrozen(address _addr) onlyOwner returns (uint256) {
363     return frozen[_addr];
364   }
365 
366   /**
367    * @dev Freeze an account - Frozen accounts are not allowed to transfer
368    * @param _addr address The address to freeze
369    */
370   function freezeAddress (address _addr) onlyOwner returns (bool) {
371     require(_addr != address(0));
372     frozen[_addr] = 1;
373     return true;
374   }
375 
376   /**
377    * @dev Thaw an account - Un-freeze a previously frozen account
378    * @param _addr address The address to thaw
379    */
380   function thawAddress (address _addr) onlyOwner returns (bool) {
381     require(_addr != address(0));
382     frozen[_addr] = 0;
383     return true;
384   }
385 
386 }