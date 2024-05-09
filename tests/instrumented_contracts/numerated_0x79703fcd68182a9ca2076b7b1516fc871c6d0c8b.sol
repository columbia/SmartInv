1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to relinquish control of the contract.
34    * @notice Renouncing to ownership will leave the contract without an owner.
35    * It will not be possible to call the functions with the `onlyOwner`
36    * modifier anymore.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (a == 0) {
79       return 0;
80     }
81 
82     c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return a / b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 }
114 
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender)
117     public view returns (uint256);
118 
119   function transferFrom(address from, address to, uint256 value)
120     public returns (bool);
121 
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(
124     address indexed owner,
125     address indexed spender,
126     uint256 value
127   );
128 }
129 
130 
131 library SafeERC20 {
132   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
133     require(token.transfer(to, value));
134   }
135 
136   function safeTransferFrom(
137     ERC20 token,
138     address from,
139     address to,
140     uint256 value
141   )
142     internal
143   {
144     require(token.transferFrom(from, to, value));
145   }
146 
147   function safeApprove(ERC20 token, address spender, uint256 value) internal {
148     require(token.approve(spender, value));
149   }
150 }
151 
152 contract BasicToken is ERC20Basic {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   uint256 totalSupply_;
158 
159   /**
160   * @dev Total number of tokens in existence
161   */
162   function totalSupply() public view returns (uint256) {
163     return totalSupply_;
164   }
165 
166   /**
167   * @dev Transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[msg.sender]);
174 
175     balances[msg.sender] = balances[msg.sender].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     emit Transfer(msg.sender, _to, _value);
178     return true;
179   }
180 
181   /**
182   * @dev Gets the balance of the specified address.
183   * @param _owner The address to query the the balance of.
184   * @return An uint256 representing the amount owned by the passed address.
185   */
186   function balanceOf(address _owner) public view returns (uint256) {
187     return balances[_owner];
188   }
189 
190 }
191 
192 contract StandardToken is ERC20, BasicToken {
193 
194   mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(
204     address _from,
205     address _to,
206     uint256 _value
207   )
208     public
209     returns (bool)
210   {
211     require(_to != address(0));
212     require(_value <= balances[_from]);
213     require(_value <= allowed[_from][msg.sender]);
214 
215     balances[_from] = balances[_from].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218     emit Transfer(_from, _to, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     emit Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(
244     address _owner,
245     address _spender
246    )
247     public
248     view
249     returns (uint256)
250   {
251     return allowed[_owner][_spender];
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    * approve should be called when allowed[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseApproval(
264     address _spender,
265     uint256 _addedValue
266   )
267     public
268     returns (bool)
269   {
270     allowed[msg.sender][_spender] = (
271       allowed[msg.sender][_spender].add(_addedValue));
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276   /**
277    * @dev Decrease the amount of tokens that an owner allowed to a spender.
278    * approve should be called when allowed[_spender] == 0. To decrement
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseApproval(
286     address _spender,
287     uint256 _subtractedValue
288   )
289     public
290     returns (bool)
291   {
292     uint256 oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue > oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302 }
303 
304 contract BurnableToken is BasicToken {
305 
306   event Burn(address indexed burner, uint256 value);
307 
308   /**
309    * @dev Burns a specific amount of tokens.
310    * @param _value The amount of token to be burned.
311    */
312   function burn(uint256 _value) public {
313     _burn(msg.sender, _value);
314   }
315 
316   function _burn(address _who, uint256 _value) internal {
317     require(_value <= balances[_who]);
318     // no need to require value <= totalSupply, since that would imply the
319     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
320 
321     balances[_who] = balances[_who].sub(_value);
322     totalSupply_ = totalSupply_.sub(_value);
323     emit Burn(_who, _value);
324     emit Transfer(_who, address(0), _value);
325   }
326 }
327 
328 contract StrayToken is StandardToken, BurnableToken, Ownable {
329 	using SafeERC20 for ERC20;
330 	
331 	uint256 public INITIAL_SUPPLY = 1000000000;
332 	
333 	string public name = "Stray";
334 	string public symbol = "ST";
335 	uint8 public decimals = 18;
336 
337 	address public companyWallet;
338 	address public privateWallet;
339 	address public fund;
340 	
341 	/**
342 	 * @param _companyWallet The company wallet which reserves 15% of the token.
343 	 * @param _privateWallet Private wallet which reservers 25% of the token.
344 	 */
345 	constructor(address _companyWallet, address _privateWallet) public {
346 		require(_companyWallet != address(0));
347 		require(_privateWallet != address(0));
348 		
349 		totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
350 		companyWallet = _companyWallet;
351 		privateWallet = _privateWallet;
352 		
353 		// 15% of tokens for company reserved.
354 		_preSale(companyWallet, totalSupply_.mul(15).div(100));
355 		
356 		// 25% of tokens for private funding.
357 		_preSale(privateWallet, totalSupply_.mul(25).div(100));
358 		
359 		// 60% of tokens for crowdsale.
360 		uint256 sold = balances[companyWallet].add(balances[privateWallet]);
361 	    balances[msg.sender] = balances[msg.sender].add(totalSupply_.sub(sold));
362 	    emit Transfer(address(0), msg.sender, balances[msg.sender]);
363 	}
364 	
365 	/**
366 	 * @param _fund The DAICO fund contract address.
367 	 */
368 	function setFundContract(address _fund) onlyOwner public {
369 	    require(_fund != address(0));
370 	    //require(_fund != owner);
371 	    //require(_fund != msg.sender);
372 	    require(_fund != address(this));
373 	    
374 	    fund = _fund;
375 	}
376 	
377 	/**
378 	 * @dev The DAICO fund contract calls this function to burn the user's token
379 	 * to avoid over refund.
380 	 * @param _from The address which just took its refund.
381 	 */
382 	function burnAll(address _from) public {
383 	    require(fund == msg.sender);
384 	    require(0 != balances[_from]);
385 	    
386 	    _burn(_from, balances[_from]);
387 	}
388 	
389 	/**
390 	 * @param _to The address which will get the token.
391 	 * @param _value The token amount.
392 	 */
393 	function _preSale(address _to, uint256 _value) internal onlyOwner {
394 		balances[_to] = _value;
395 		emit Transfer(address(0), _to, _value);
396 	}
397 	
398 }