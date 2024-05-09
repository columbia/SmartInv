1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() {
56     owner = msg.sender;
57   }
58 
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) onlyOwner public {
74     require(newOwner != address(0));
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) public constant returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public constant returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   mapping(address => uint256) balances;
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[msg.sender]);
122 
123     // SafeMath.sub will throw if there is not enough balance.
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public constant returns (uint256 balance) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, BasicToken {
150 
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint256 the amount of tokens to be transferred
159    */
160   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161     require(_to != address(0));
162     require(_value <= balances[_from]);
163     require(_value <= allowed[_from][msg.sender]);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    */
204   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
205     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 /**
224  * @title Burnable Token
225  * @dev Token that can be irreversibly burned (destroyed).
226  */
227 contract BurnableToken is StandardToken {
228 
229     address public constant BURN_ADDRESS = 0;
230 
231     event Burn(address indexed burner, uint256 value);
232 
233 	
234 	function burnTokensInternal(address _address, uint256 _value) internal {
235         require(_value > 0);
236         require(_value <= balances[_address]);
237         // no need to require value <= totalSupply, since that would imply the
238         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
239 
240         address burner = _address;
241         balances[burner] = balances[burner].sub(_value);
242         totalSupply = totalSupply.sub(_value);
243         Burn(burner, _value);
244 		Transfer(burner, BURN_ADDRESS, _value);
245 		
246 	}
247 		
248 }
249 
250 /**
251  * @title Handelion Token
252  * @dev Main token used for Handelion crowdsale
253  */
254  contract HIONToken is BurnableToken, Ownable
255  {
256 	
257 	/** Handelion token name official name. */
258 	string public constant name = "HION Token by Handelion"; 
259 	 
260 	 /** Handelion token official symbol.*/
261 	string public constant symbol = "HION"; 
262 
263 	/** Number of decimal units for Handelion token */
264 	uint256 public constant decimals = 18;
265 
266 	/* Preissued token amount */
267 	uint256 public constant PREISSUED_AMOUNT = 29750000 * 1 ether;
268 			
269 	/** 
270 	 * Indicates wheather token transfer is allowed. Token transfer is allowed after crowdsale is over. 
271 	 * Before crowdsale is over only token owner is allowed to transfer tokens to investors.
272 	 */
273 	bool public transferAllowed = false;
274 			
275 	/** Raises when initial amount of tokens is preissued */
276 	event LogTokenPreissued(address ownereAddress, uint256 amount);
277 	
278 	
279 	modifier canTransfer(address sender)
280 	{
281 		require(transferAllowed || sender == owner);
282 		
283 		_;
284 	}
285 	
286 	/**
287 	 * Creates and initializes Handelion token
288 	 */
289 	function HIONToken()
290 	{
291 		// Address of token creator. The creator of this token is major holder of all preissued tokens before crowdsale starts
292 		owner = msg.sender;
293 	 
294 		// Send all pre-created tokens to token creator address
295 		totalSupply = totalSupply.add(PREISSUED_AMOUNT);
296 		balances[owner] = balances[owner].add(PREISSUED_AMOUNT);
297 		
298 		LogTokenPreissued(owner, PREISSUED_AMOUNT);
299 	}
300 	
301 	/**
302 	 * Returns Token creator address
303 	 */
304 	function getCreatorAddress() public constant returns(address creatorAddress)
305 	{
306 		return owner;
307 	}
308 	
309 	/**
310 	 * Gets total supply of Handelion token
311 	 */
312 	function getTotalSupply() public constant returns(uint256)
313 	{
314 		return totalSupply;
315 	}
316 	
317 	/**
318 	 * Gets number of remaining tokens
319 	 */
320 	function getRemainingTokens() public constant returns(uint256)
321 	{
322 		return balanceOf(owner);
323 	}	
324 	
325 	/**
326 	 * Allows token transfer. Should be called after crowdsale is over
327 	 */
328 	function allowTransfer() onlyOwner public
329 	{
330 		transferAllowed = true;
331 	}
332 	
333 	
334 	/**
335 	 * Overrides transfer function by adding check whether transfer is allwed
336 	 */
337 	function transfer(address _to, uint256 _value) canTransfer(msg.sender) public returns (bool)	
338 	{
339 		super.transfer(_to, _value);
340 	}
341 
342 	/**
343 	 * Override transferFrom function and adds a check whether transfer is allwed
344 	 */
345 	function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) public returns (bool) {	
346 		super.transferFrom(_from, _to, _value);
347 	}
348 	
349 	/**
350      * @dev Burns a specific amount of tokens.
351      * @param _value The amount of token to be burned.
352      */
353     function burn(uint256 _value) public {
354 		burnTokensInternal(msg.sender, _value);
355     }
356 
357     /**
358      * @dev Burns a specific amount of tokens for specific address. Can be called only by token owner.
359 	 * @param _address 
360      * @param _value The amount of token to be burned.
361      */
362     function burn(address _address, uint256 _value) public onlyOwner {
363 		burnTokensInternal(_address, _value);
364     }
365 }