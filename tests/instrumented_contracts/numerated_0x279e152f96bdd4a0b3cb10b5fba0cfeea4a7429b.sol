1 pragma solidity ^0.4.18;
2 
3 
4 
5 /* ********** Zeppelin Solidity - v1.3.0 ********** */
6 
7 
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   uint256 public totalSupply;
16   function balanceOf(address who) public constant returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81 
82     // SafeMath.sub will throw if there is not enough balance.
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of.
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public constant returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121 
122     uint256 _allowance = allowed[_from][msg.sender];
123 
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // require (_value <= _allowance);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval (address _spender, uint _addedValue)
167     returns (bool success) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   function decreaseApproval (address _spender, uint _subtractedValue)
174     returns (bool success) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 
188 
189 /* ********** RxEAL Token Contract ********** */
190 
191 
192 
193 /**
194  * @title RxEALTokenContract
195  * @author RxEAL.com
196  *
197  * ERC20 Compatible token
198  * Zeppelin Solidity - v1.3.0
199  */
200 
201 contract RxEALTokenContract is StandardToken {
202 
203   /* ********** Token Predefined Information ********** */
204 
205   // Predefine token info
206   string public constant name = "RxEAL";
207   string public constant symbol = "RXL";
208   uint256 public constant decimals = 18;
209 
210   /* ********** Defined Variables ********** */
211 
212   // Total tokens supply 96 000 000
213   // For ethereum wallets we added decimals constant
214   uint256 public constant INITIAL_SUPPLY = 96000000 * (10 ** decimals);
215   // Vault where tokens are stored
216   address public vault = this;
217   // Sale agent who has permissions to sell tokens
218   address public salesAgent;
219   // Array of token owners
220   mapping (address => bool) public owners;
221 
222   /* ********** Events ********** */
223 
224   // Contract events
225   event OwnershipGranted(address indexed _owner, address indexed revoked_owner);
226   event OwnershipRevoked(address indexed _owner, address indexed granted_owner);
227   event SalesAgentPermissionsTransferred(address indexed previousSalesAgent, address indexed newSalesAgent);
228   event SalesAgentRemoved(address indexed currentSalesAgent);
229   event Burn(uint256 value);
230 
231   /* ********** Modifiers ********** */
232 
233   // Throws if called by any account other than the owner
234   modifier onlyOwner() {
235     require(owners[msg.sender] == true);
236     _;
237   }
238 
239   /* ********** Functions ********** */
240 
241   // Constructor
242   function RxEALTokenContract() {
243     owners[msg.sender] = true;
244     totalSupply = INITIAL_SUPPLY;
245     balances[vault] = totalSupply;
246   }
247 
248   // Allows the current owner to grant control of the contract to another account
249   function grantOwnership(address _owner) onlyOwner public {
250     require(_owner != address(0));
251     owners[_owner] = true;
252     OwnershipGranted(msg.sender, _owner);
253   }
254 
255   // Allow the current owner to revoke control of the contract from another owner
256   function revokeOwnership(address _owner) onlyOwner public {
257     require(_owner != msg.sender);
258     owners[_owner] = false;
259     OwnershipRevoked(msg.sender, _owner);
260   }
261 
262   // Transfer sales agent permissions to another account
263   function transferSalesAgentPermissions(address _salesAgent) onlyOwner public {
264     SalesAgentPermissionsTransferred(salesAgent, _salesAgent);
265     salesAgent = _salesAgent;
266   }
267 
268   // Remove sales agent from token
269   function removeSalesAgent() onlyOwner public {
270     SalesAgentRemoved(salesAgent);
271     salesAgent = address(0);
272   }
273 
274   // Transfer tokens from vault to account if sales agent is correct
275   function transferTokensFromVault(address _from, address _to, uint256 _amount) public {
276     require(salesAgent == msg.sender);
277     balances[vault] = balances[vault].sub(_amount);
278     balances[_to] = balances[_to].add(_amount);
279     Transfer(_from, _to, _amount);
280   }
281 
282   // Allow the current owner to burn a specific amount of tokens from the vault
283   function burn(uint256 _value) onlyOwner public {
284     require(_value > 0);
285     balances[vault] = balances[vault].sub(_value);
286     totalSupply = totalSupply.sub(_value);
287     Burn(_value);
288   }
289 
290 }
291 
292 
293 
294 /* ********** RxEAL Presale Contract ********** */
295 
296 
297 
298 contract RxEALPresaleContract {
299   // Extend uint256 to use SafeMath functions
300   using SafeMath for uint256;
301 
302   /* ********** Defined Variables ********** */
303 
304   // The token being sold
305   RxEALTokenContract public token;
306   // Start and end timestamps where sales are allowed (both inclusive)
307   uint256 public startTime = 1516017600;
308   uint256 public endTime = 1517832000;
309   // Address where funds are collected
310   address public wallet1 = 0x56E4e5d451dF045827e214FE10bBF99D730d9683;
311   address public wallet2 = 0x8C0988711E60CfF153359Ab6CFC8d45565C6ce79;
312   address public wallet3 = 0x0EdF5c34ddE2573f162CcfEede99EeC6aCF1c2CB;
313   address public wallet4 = 0xcBdC5eE000f77f3bCc0eFeF0dc47d38911CBD45B;
314   // How many token units a buyer gets per wei
315   // Rate per ether equals rate * (10 ** token.decimals())
316   uint256 public rate = 2400;
317   // Cap in ethers
318   uint256 public cap = 2400 * 1 ether;
319   // Amount of raised money in wei
320   uint256 public weiRaised;
321 
322   /* ********** Events ********** */
323 
324   // Event for token purchase logging
325   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens);
326 
327   /* ********** Functions ********** */
328 
329   // Constructor
330   function RxEALPresaleContract() {
331     token = RxEALTokenContract(0xD6682Db9106e0cfB530B697cA0EcDC8F5597CD15);
332   }
333 
334   // Fallback function can be used to buy tokens
335   function () payable {
336     buyTokens(msg.sender);
337   }
338 
339   // Low level token purchase function
340   function buyTokens(address beneficiary) public payable {
341     require(beneficiary != address(0));
342     require(validPurchase());
343 
344     uint256 weiAmount = msg.value;
345 
346     // Send spare wei back if investor sent more that cap
347     uint256 tempWeiRaised = weiRaised.add(weiAmount);
348     if (tempWeiRaised > cap) {
349       uint256 spareWeis = tempWeiRaised.sub(cap);
350       weiAmount = weiAmount.sub(spareWeis);
351       beneficiary.transfer(spareWeis);
352     }
353 
354     // Calculate token amount to be sold
355     uint256 tokens = weiAmount.mul(rate);
356 
357     // Update state
358     weiRaised = weiRaised.add(weiAmount);
359 
360     // Tranfer tokens from vault
361     token.transferTokensFromVault(msg.sender, beneficiary, tokens);
362     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
363 
364     forwardFunds(weiAmount);
365   }
366 
367   // Send wei to the fund collection wallets
368   function forwardFunds(uint256 weiAmount) internal {
369     uint256 value = weiAmount.div(4);
370 
371     wallet1.transfer(value);
372     wallet2.transfer(value);
373     wallet3.transfer(value);
374     wallet4.transfer(value);
375   }
376 
377   // Validate if the transaction can buy tokens
378   function validPurchase() internal constant returns (bool) {
379     bool withinCap = weiRaised < cap;
380     bool withinPeriod = now >= startTime && now <= endTime;
381     bool nonZeroPurchase = msg.value != 0;
382     return withinPeriod && nonZeroPurchase && withinCap;
383   }
384 
385   // Validate if crowdsale event has ended
386   function hasEnded() public constant returns (bool) {
387     bool capReached = weiRaised >= cap;
388     return now > endTime || capReached;
389   }
390 }