1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36   /**
37   * @dev Multiplies two numbers, throws on overflow.
38   */
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     if (a == 0) {
41       return 0;
42     }
43     uint256 c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers, truncating the quotient.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   /**
59   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60   */
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   /**
67   * @dev Adds two numbers, throws on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   uint256 totalSupply_;
89 
90   /**
91   * @dev total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 
222 
223 
224 
225 /**
226  * @title Ownable
227  * @dev The Ownable contract has an owner address, and provides basic authorization control
228  * functions, this simplifies the implementation of "user permissions".
229  */
230 contract Ownable {
231   address public owner;
232 
233 
234   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236 
237   /**
238    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
239    * account.
240    */
241   function Ownable() public {
242     owner = msg.sender;
243   }
244 
245   /**
246    * @dev Throws if called by any account other than the owner.
247    */
248   modifier onlyOwner() {
249     require(msg.sender == owner);
250     _;
251   }
252 
253   /**
254    * @dev Allows the current owner to transfer control of the contract to a newOwner.
255    * @param newOwner The address to transfer ownership to.
256    */
257   function transferOwnership(address newOwner) public onlyOwner {
258     require(newOwner != address(0));
259     OwnershipTransferred(owner, newOwner);
260     owner = newOwner;
261   }
262 
263 }
264 
265 
266 
267 
268 /**
269  * @title Burnable Token
270  * @dev Token that can be irreversibly burned (destroyed).
271  */
272 contract BurnableToken is BasicToken {
273 
274   event Burn(address indexed burner, uint256 value);
275 
276   /**
277    * @dev Burns a specific amount of tokens.
278    * @param _value The amount of token to be burned.
279    */
280   function burn(uint256 _value) public {
281     require(_value <= balances[msg.sender]);
282     // no need to require value <= totalSupply, since that would imply the
283     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
284 
285     address burner = msg.sender;
286     balances[burner] = balances[burner].sub(_value);
287     totalSupply_ = totalSupply_.sub(_value);
288     Burn(burner, _value);
289     Transfer(burner, address(0), _value);
290   }
291 }
292 
293 
294 /**
295  * @title TokenRDC
296  *  
297  */
298  contract TokenRDC is BurnableToken, StandardToken, Ownable  { 
299     
300   string public constant name = "ROOMDAO COIN (RDC)";
301    
302   string public constant symbol = "RDC";
303     
304   uint32 public constant decimals = 18;
305 
306   uint256 public INITIAL_SUPPLY = 60000000 * (10 ** uint256(decimals));
307   
308   address public currentCrowdsale;
309 
310   function TokenRDC( address _foundation, address _team, address _BAP ) public {
311     require( _foundation != address(0x0));
312     require( _team != address(0x0));  
313     require( _BAP != address(0x0));  
314     
315     uint256 dec = 10 ** uint256(decimals); //1000000000000000000;
316     totalSupply_ = INITIAL_SUPPLY;
317     
318 	balances[msg.sender] = INITIAL_SUPPLY;
319 	transfer( _foundation, 12000000 * dec ); 	// Foundation 20%
320 	transfer( _team, 6000000 * dec );			// Team 10%
321 	transfer(  _BAP, 2400000 * dec );			// Bounty, Advisor, Partnership 4%
322   }
323   
324   /**
325   * @dev transfer token to crowdsale's contract / переводим токены на адрес контратракта распродажи
326   * @param _crowdsale The address of crowdsale's contract.
327   */  
328   function startCrowdsale0( address _crowdsale ) onlyOwner public {
329       _startCrowdsale( _crowdsale, 4500000 );
330   }
331   
332   /**
333   * @dev transfer token to crowdsale's contract / переводим токены на адрес контратракта распродажи
334   * @param _crowdsale The address of crowdsale's contract.
335   */  
336   function startCrowdsale1( address _crowdsale ) onlyOwner public {
337       _startCrowdsale( _crowdsale, 7920000 );
338   }
339   
340   /**
341   * @dev transfer token to crowdsale's contract / переводим токены на адрес контратракта распродажи
342   * @param _crowdsale The address of crowdsale's contract.
343   */  
344   function startCrowdsale2( address _crowdsale ) onlyOwner public {
345       _startCrowdsale( _crowdsale, balances[owner] );
346   }
347   
348   /**
349   * @dev transfer token to crowdsale's contract / переводим токены на адрес контратракта распродажи
350   * @param _crowdsale The address of crowdsale's contract.
351   * @param _value The amount to be transferred.
352   */  
353   function _startCrowdsale( address _crowdsale, uint256 _value ) onlyOwner internal {
354       require(currentCrowdsale == address(0));
355       currentCrowdsale = _crowdsale;
356       uint256 dec = 10 ** uint256(decimals);
357       uint256 val = _value * dec;
358       if( val > balances[owner] ) {
359           val = balances[ owner ];
360       }
361       transfer( _crowdsale, val );
362   }
363   
364   /**
365   * @dev transfer token back to owner / переводим токены обратно владельцу контнракта
366   * 
367   */
368   function finishCrowdsale() onlyOwner public returns (bool) {
369     require(currentCrowdsale != address(0));
370     require( balances[currentCrowdsale] > 0 );
371     
372     uint256 value = balances[ currentCrowdsale ];
373     balances[currentCrowdsale] = 0;
374     balances[owner] = balances[owner].add(value);
375     Transfer(currentCrowdsale, owner, value);
376     
377     currentCrowdsale = address(0);
378     return true;
379   }
380   
381   
382    /**
383    * @dev Change ownershipment and move all tokens from old owner to new owner
384    * @param newOwner The address to transfer ownership to.
385    */
386   function transferOwnership(address newOwner) public {
387 	super.transferOwnership( newOwner );
388 	uint256 value = balances[msg.sender];
389 	transfer( newOwner, value );    
390   }
391 
392 }