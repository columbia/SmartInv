1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 
16 
17 
18 
19 
20 /**
21  * @title ERC20Basic
22  * @dev Simpler version of ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/179
24  */
25 contract ERC20Basic {
26   function totalSupply() public view returns (uint256);
27   function balanceOf(address who) public view returns (uint256);
28   function transfer(address to, uint256 value) public returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 
32 
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  */
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   uint256 totalSupply_;
92 
93   /**
94   * @dev total number of tokens in existence
95   */
96   function totalSupply() public view returns (uint256) {
97     return totalSupply_;
98   }
99 
100   /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     require(_to != address(0));
107     require(_value <= balances[msg.sender]);
108 
109     // SafeMath.sub will throw if there is not enough balance.
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public view returns (uint256 balance) {
122     return balances[_owner];
123   }
124 
125 }
126 
127 
128 
129 
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender) public view returns (uint256);
137   function transferFrom(address from, address to, uint256 value) public returns (bool);
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * @dev Increase the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227     uint oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue > oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 /**
240  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
241  *
242  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
243  */
244 
245 
246 
247 
248 /**
249  * @title Ownable
250  * @dev The Ownable contract has an owner address, and provides basic authorization control
251  * functions, this simplifies the implementation of "user permissions".
252  */
253 contract Ownable {
254   address public owner;
255 
256 
257   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
258 
259 
260   /**
261    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
262    * account.
263    */
264   function Ownable() public {
265     owner = msg.sender;
266   }
267 
268   /**
269    * @dev Throws if called by any account other than the owner.
270    */
271   modifier onlyOwner() {
272     require(msg.sender == owner);
273     _;
274   }
275 
276   /**
277    * @dev Allows the current owner to transfer control of the contract to a newOwner.
278    * @param newOwner The address to transfer ownership to.
279    */
280   function transferOwnership(address newOwner) public onlyOwner {
281     require(newOwner != address(0));
282     OwnershipTransferred(owner, newOwner);
283     owner = newOwner;
284   }
285 
286 }
287 
288 
289 
290 contract Recoverable is Ownable {
291 
292   /// @dev Empty constructor (for now)
293   function Recoverable() {
294   }
295 
296   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
297   /// @param token Token which will we rescue to the owner from the contract
298   function recoverTokens(ERC20Basic token) onlyOwner public {
299     token.transfer(owner, tokensToBeReturned(token));
300   }
301 
302   /// @dev Interface function, can be overwritten by the superclass
303   /// @param token Token which balance we will check and return
304   /// @return The amount of tokens (in smallest denominator) the contract owns
305   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
306     return token.balanceOf(this);
307   }
308 }
309 
310 
311 
312 /**
313  * Standard EIP-20 token with an interface marker.
314  *
315  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
316  *
317  */
318 contract StandardTokenExt is StandardToken, Recoverable {
319 
320   /* Interface declaration */
321   function isToken() public constant returns (bool weAre) {
322     return true;
323   }
324 }
325 
326 
327 
328 /**
329  * Issuer manages token distribution after the crowdsale.
330  *
331  * This contract is fed a CSV file with Ethereum addresses and their
332  * issued token balances.
333  *
334  * Issuer act as a gate keeper to ensure there is no double issuance
335  * per address, in the case we need to do several issuance batches,
336  * there is a race condition or there is a fat finger error.
337  *
338  * Issuer contract gets allowance from the team multisig to distribute tokens.
339  *
340  */
341 contract Issuer is Ownable {
342 
343   /** Map addresses whose tokens we have already issued. */
344   mapping(address => bool) public issued;
345 
346   /** Centrally issued token we are distributing to our contributors */
347   StandardTokenExt public token;
348 
349   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
350   address public allower;
351 
352   /** How many addresses have received their tokens. */
353   uint public issuedCount;
354 
355   function Issuer(address _owner, address _allower, StandardTokenExt _token) {
356     owner = _owner;
357     allower = _allower;
358     token = _token;
359   }
360 
361   function issue(address benefactor, uint amount) onlyOwner {
362     if(issued[benefactor]) throw;
363     token.transferFrom(allower, benefactor, amount);
364     issued[benefactor] = true;
365     issuedCount += amount;
366   }
367 
368 }