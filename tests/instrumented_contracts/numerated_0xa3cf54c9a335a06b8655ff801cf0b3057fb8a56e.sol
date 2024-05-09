1 /**
2     Copyright (c) 2018 Productivist
3 
4     Productivist.com / ERC20 token mechanism
5     Version 1.0
6     
7     Permission is hereby granted, free of charge, to any person obtaining a copy
8     of this software and associated documentation files (the "Software"), to deal
9     in the Software without restriction, including without limitation the rights
10     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11     copies of the Software, and to permit persons to whom the Software is
12     furnished to do so, subject to the following conditions:
13 
14     The above copyright notice and this permission notice shall be included in
15     all copies or substantial portions of the Software.
16 
17     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
18     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
19     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
20     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
21     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
22     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
23     THE SOFTWARE.
24 
25     based on the contracts of OpenZeppelin:
26     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
27 **/
28 
29 pragma solidity ^0.4.23;
30 
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations (only add and sub here) with safety checks that throw on error
35  */
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, throws on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43       return 0;
44     }
45     uint256 c = a * b;
46     assert(c / a == b);
47     return c;
48   }
49 
50   /**
51   * @dev Integer division of two numbers, truncating the quotient.
52   */
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   /**
61   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62   */
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   /**
69   * @dev Adds two numbers, throws on overflow.
70   */
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 
78 /**
79  * @title Ownable
80  * @dev The Ownable contract has an owner address, and provides basic authorization control
81  * functions, this simplifies the implementation of "user permissions".
82  */
83 contract Ownable {
84   address public owner;
85 
86 
87   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89 
90   /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94   constructor() public {
95     owner = msg.sender;
96   }
97 
98   /**
99    * @dev Throws if called by any account other than the owner.
100    */
101   modifier onlyOwner() {
102     require(msg.sender == owner);
103     _;
104   }
105 
106   /**
107    * @dev Allows the current owner to transfer control of the contract to a newOwner.
108    * @param newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address newOwner) public onlyOwner {
111     require(newOwner != address(0));
112     emit OwnershipTransferred(owner, newOwner);
113     owner = newOwner;
114   }
115 
116 }
117 
118 
119 /**
120  * @title Pausable
121  * @dev Base contract which allows children to implement an emergency stop mechanism.
122  */
123 contract Pausable is Ownable {
124   event Pause();
125   event Unpause();
126 
127   bool public paused = false;
128 
129 
130   /**
131    * @dev Modifier to make a function callable only when the contract is not paused.
132    */
133   modifier whenNotPaused() {
134     require(!paused);
135     _;
136   }
137 
138   /**
139    * @dev Modifier to make a function callable only when the contract is paused.
140    */
141   modifier whenPaused() {
142     require(paused);
143     _;
144   }
145 
146   /**
147    * @dev called by the owner to pause, triggers stopped state
148    */
149   function pause() onlyOwner whenNotPaused public {
150     paused = true;
151     emit Pause();
152   }
153 
154   /**
155    * @dev called by the owner to unpause, returns to normal state
156    */
157   function unpause() onlyOwner whenPaused public {
158     paused = false;
159     emit Unpause();
160   }
161 }
162 
163 
164 /**
165  * @title ERC20 interface
166  * @dev see https://github.com/ethereum/EIPs/issues/20
167  */
168 contract ERC20 {
169   function totalSupply() public view returns (uint256);
170   function balanceOf(address who) public view returns (uint256);
171   function transfer(address to, uint256 value) public returns (bool);
172   function allowance(address owner, address spender) public view returns (uint256);
173   function transferFrom(address from, address to, uint256 value) public returns (bool);
174   function approve(address spender, uint256 value) public returns (bool);
175   
176   event Transfer(address indexed from, address indexed to, uint256 value);
177   event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 
181 contract PRODToken is ERC20, Pausable {
182 
183   using SafeMath for uint256;
184     
185   string public name = "Productivist";      //  token name
186   string public symbol = "PROD";           //  token symbol
187   uint256 public decimals = 8;            //  token digit
188 
189 
190   // Token distribution, must sumup to 1000
191   uint256 public constant SHARE_PURCHASERS = 617;
192   uint256 public constant SHARE_FOUNDATION = 173;
193   uint256 public constant SHARE_TEAM = 160;
194   uint256 public constant SHARE_BOUNTY = 50;
195 
196   // Wallets addresses
197   address public foundationAddress = 0x0;
198   address public teamAddress = 0x0;
199   address public bountyAddress = 0x0;
200 
201   uint256 totalSupply_ = 0;
202   uint256 public cap = 385000000 * 10 ** decimals; // Max cap 385.000.000 token
203 
204   mapping(address => uint256) balances;
205   
206   mapping (address => mapping (address => uint256)) internal allowed;
207 
208   bool public mintingFinished = false;
209 
210   event Burn(address indexed burner, uint256 value);
211   event Mint(address indexed to, uint256 amount);
212   event MintFinished();
213 
214   modifier canMint() {
215     require(!mintingFinished);
216     _;
217   }
218 
219   /**
220     * @dev Change token name, Owner only.
221     * @param _name The name of the token.
222   */
223   function setName(string _name) onlyOwner public {
224     name = _name;
225   }
226   
227   function setWallets(address _foundation, address _team, address _bounty) public onlyOwner canMint {
228     require(_foundation != address(0) && _team != address(0) && _bounty != address(0));
229     foundationAddress = _foundation;
230     teamAddress = _team;
231     bountyAddress = _bounty;
232   } 
233   
234   /**
235     * @dev total number of tokens in existence
236   */
237   function totalSupply() public view returns (uint256) {
238     return totalSupply_;
239   }
240   
241   /**
242     * @dev Gets the balance of the specified address.
243     * @param _owner The address to query the the balance of.
244     * @return An uint256 representing the amount owned by the passed address.
245   */
246   function balanceOf(address _owner) public view returns (uint256 balance) {
247     return balances[_owner];
248   }
249   
250   /**
251     * @dev transfer token for a specified address
252     * @param _to The address to transfer to.
253     * @param _value The amount to be transferred.
254   */
255   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
256     require(_to != address(0));
257     require(_value <= balances[msg.sender]);
258     // SafeMath.sub will throw if there is not enough balance.
259     balances[msg.sender] = balances[msg.sender].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     emit Transfer(msg.sender, _to, _value);
262     return true;
263   }
264   
265   /**
266     * @dev Transfer tokens from one address to another
267     * @param _from address The address which you want to send tokens from
268     * @param _to address The address which you want to transfer to
269     * @param _value uint256 the amount of tokens to be transferred
270   */
271   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
272     require(_to != address(0));
273     require(_value <= balances[_from]);
274     require(_value <= allowed[_from][msg.sender]);
275 
276     balances[_from] = balances[_from].sub(_value);
277     balances[_to] = balances[_to].add(_value);
278     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
279     emit Transfer(_from, _to, _value);
280     return true;
281   }
282 
283   /**
284     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
285     *
286     * Beware that changing an allowance with this method brings the risk that someone may use both the old
287     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
288     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
289     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290     * @param _spender The address which will spend the funds.
291     * @param _value The amount of tokens to be spent.
292   */
293   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
294     allowed[msg.sender][_spender] = _value;
295     emit Approval(msg.sender, _spender, _value);
296     return true;
297   }
298 
299   /**
300     * @dev Function to check the amount of tokens that an owner allowed to a spender.
301     * @param _owner address The address which owns the funds.
302     * @param _spender address The address which will spend the funds.
303     * @return A uint256 specifying the amount of tokens still available for the spender.
304   */
305   function allowance(address _owner, address _spender) public view returns (uint256) {
306     return allowed[_owner][_spender];
307   }
308 
309   /**
310     * @dev Increase the amount of tokens that an owner allowed to a spender.
311     *
312     * approve should be called when allowed[_spender] == 0. To increment
313     * allowed value is better to use this function to avoid 2 calls (and wait until
314     * the first transaction is mined)
315     * From MonolithDAO Token.sol
316     * @param _spender The address which will spend the funds.
317     * @param _addedValue The amount of tokens to increase the allowance by.
318   */
319   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
320     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
321     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325   /**
326     * @dev Decrease the amount of tokens that an owner allowed to a spender.
327     *
328     * approve should be called when allowed[_spender] == 0. To decrement
329     * allowed value is better to use this function to avoid 2 calls (and wait until
330     * the first transaction is mined)
331     * From MonolithDAO Token.sol
332     * @param _spender The address which will spend the funds.
333     * @param _subtractedValue The amount of tokens to decrease the allowance by.
334   */
335   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
336     uint oldValue = allowed[msg.sender][_spender];
337     if (_subtractedValue > oldValue) {
338       allowed[msg.sender][_spender] = 0;
339     } else {
340       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
341     }
342     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343     return true;
344   }
345 
346   /**
347    * @dev Function to 	mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
353     require(totalSupply_.add(_amount) <= cap);
354     require(_to != address(0));
355     totalSupply_ = totalSupply_.add(_amount);
356     balances[_to] = balances[_to].add(_amount);
357     emit Mint(_to, _amount);
358     emit Transfer(address(0), _to, _amount);
359     return true;
360   }
361 
362   /**
363    * @dev Function to stop minting new tokens.
364    * @return True if the operation was successful.
365    */
366   function finishMinting() onlyOwner canMint public returns (bool) {
367 
368     require(foundationAddress != address(0) && teamAddress != address(0) && bountyAddress != address(0));
369     require(SHARE_PURCHASERS + SHARE_FOUNDATION + SHARE_TEAM + SHARE_BOUNTY == 1000);
370     require(totalSupply_ != 0);
371     
372     // before calling this method totalSupply includes only purchased tokens
373     uint256 onePerThousand = totalSupply_ / SHARE_PURCHASERS; //ignore (totalSupply mod 617) ~= 616e-8,
374     
375     uint256 foundationTokens = onePerThousand * SHARE_FOUNDATION;             
376     uint256 teamTokens = onePerThousand * SHARE_TEAM;   
377     uint256 bountyTokens = onePerThousand * SHARE_BOUNTY;
378       
379     mint(foundationAddress, foundationTokens);
380     mint(teamAddress, teamTokens);
381     mint(bountyAddress, bountyTokens);
382   
383     mintingFinished = true;
384     emit MintFinished();
385     return true;
386   }
387 
388 
389   /**
390     * @dev Burns a specific amount of tokens.
391     * @param _value The amount of token to be burned.
392   */
393   function burn(uint256 _value) public whenNotPaused {
394     require(_value <= balances[msg.sender]);
395     // no need to require value <= totalSupply, since that would imply the
396     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
397 
398     address burner = msg.sender;
399     balances[burner] = balances[burner].sub(_value);
400     totalSupply_ = totalSupply_.sub(_value);
401     emit Burn(burner, _value);
402     emit Transfer(burner, address(0), _value);
403   }
404   
405 
406   /**
407     * @dev This is an especial owner-only function to make massive tokens minting.
408     * @param _data is an array of addresses
409     * @param _amount is an array of uint256
410   */
411   function batchMint(address[] _data,uint256[] _amount) public onlyOwner canMint {
412     for (uint i = 0; i < _data.length; i++) {
413 	mint(_data[i],_amount[i]);
414     }
415   }
416 
417 }