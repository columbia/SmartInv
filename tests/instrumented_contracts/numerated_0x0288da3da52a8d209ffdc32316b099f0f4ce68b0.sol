1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40   /**
41    * @dev Allows the current owner to relinquish control of the contract.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 }
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
54     if (a == 0) {
55       return 0;
56     }
57     c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return a / b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 contract Pausable is Ownable {
90   event Pause();
91   event Unpause();
92 
93   bool public paused = false;
94 
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is not paused.
98    */
99   modifier whenNotPaused() {
100     require(!paused);
101     _;
102   }
103 
104   /**
105    * @dev Modifier to make a function callable only when the contract is paused.
106    */
107   modifier whenPaused() {
108     require(paused);
109     _;
110   }
111 
112   /**
113    * @dev called by the owner to pause, triggers stopped state
114    */
115   function pause() onlyOwner whenNotPaused public {
116     paused = true;
117     emit Pause();
118   }
119 
120   /**
121    * @dev called by the owner to unpause, returns to normal state
122    */
123   function unpause() onlyOwner whenPaused public {
124     paused = false;
125     emit Unpause();
126   }
127 }
128 contract ERC20Basic {
129   function totalSupply() public view returns (uint256);
130   function balanceOf(address who) public view returns (uint256);
131   function transfer(address to, uint256 value) public returns (bool);
132   event Transfer(address indexed from, address indexed to, uint256 value);
133 }
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   uint256 totalSupply_;
140 
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[msg.sender]);
156 
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     emit Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256) {
169     return balances[_owner];
170   }
171 
172 }
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender)
175     public view returns (uint256);
176 
177   function transferFrom(address from, address to, uint256 value)
178     public returns (bool);
179 
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(
182     address indexed owner,
183     address indexed spender,
184     uint256 value
185   );
186 }
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) internal allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amount of tokens to be transferred
197    */
198   function transferFrom(
199     address _from,
200     address _to,
201     uint256 _value
202   )
203     public
204     returns (bool)
205   {
206     require(_to != address(0));
207     require(_value <= balances[_from]);
208     require(_value <= allowed[_from][msg.sender]);
209 
210     balances[_from] = balances[_from].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
213     emit Transfer(_from, _to, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219    *
220    * Beware that changing an allowance with this method brings the risk that someone may use both the old
221    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224    * @param _spender The address which will spend the funds.
225    * @param _value The amount of tokens to be spent.
226    */
227   function approve(address _spender, uint256 _value) public returns (bool) {
228     allowed[msg.sender][_spender] = _value;
229     emit Approval(msg.sender, _spender, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param _owner address The address which owns the funds.
236    * @param _spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239   function allowance(
240     address _owner,
241     address _spender
242    )
243     public
244     view
245     returns (uint256)
246   {
247     return allowed[_owner][_spender];
248   }
249 
250   /**
251    * @dev Increase the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To increment
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _addedValue The amount of tokens to increase the allowance by.
259    */
260   function increaseApproval(
261     address _spender,
262     uint _addedValue
263   )
264     public
265     returns (bool)
266   {
267     allowed[msg.sender][_spender] = (
268       allowed[msg.sender][_spender].add(_addedValue));
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(
284     address _spender,
285     uint _subtractedValue
286   )
287     public
288     returns (bool)
289   {
290     uint oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue > oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300 }
301 contract PausableToken is StandardToken, Pausable {
302 
303   function transfer(
304     address _to,
305     uint256 _value
306   )
307     public
308     whenNotPaused
309     returns (bool)
310   {
311     return super.transfer(_to, _value);
312   }
313 
314   function transferFrom(
315     address _from,
316     address _to,
317     uint256 _value
318   )
319     public
320     whenNotPaused
321     returns (bool)
322   {
323     return super.transferFrom(_from, _to, _value);
324   }
325 
326   function approve(
327     address _spender,
328     uint256 _value
329   )
330     public
331     whenNotPaused
332     returns (bool)
333   {
334     return super.approve(_spender, _value);
335   }
336 
337   function increaseApproval(
338     address _spender,
339     uint _addedValue
340   )
341     public
342     whenNotPaused
343     returns (bool success)
344   {
345     return super.increaseApproval(_spender, _addedValue);
346   }
347 
348   function decreaseApproval(
349     address _spender,
350     uint _subtractedValue
351   )
352     public
353     whenNotPaused
354     returns (bool success)
355   {
356     return super.decreaseApproval(_spender, _subtractedValue);
357   }
358 }
359 
360 contract Spider is PausableToken{
361     string public name;                   //fancy name: eg Simon Bucks
362     uint8 public decimals;                //How many decimals to show.
363     string public symbol;                 //An identifier: eg SBX
364     uint256 public exchangeRate;         //0.1 eth 
365     bool public sellPaused = false;
366 
367     constructor(
368         uint256 _initialAmount
369     ) public {
370         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
371         totalSupply_ = _initialAmount;                        // Update total supply
372         name = "Spider";                                   // Set the name for display purposes
373         decimals = 18;                            // Amount of decimals for display purposes
374         symbol = "SPB";                               // Set the symbol for display purposes
375         exchangeRate = 1000;
376     }
377     
378     function setExchangeRate(uint256 x) public onlyOwner {
379         exchangeRate = x;
380     }
381     
382     modifier whenSellNotPaused() {
383         require(!sellPaused);
384     _;
385   }
386 
387   /**
388    * @dev Modifier to make a function callable only when the contract is paused.
389    */
390   modifier whenSellPaused() {
391     require(sellPaused);
392     _;
393   }
394 
395   /**
396    * @dev called by the owner to pause, triggers stopped state
397    */
398   function sellpause() onlyOwner whenSellNotPaused public {
399     sellPaused = true;
400   }
401 
402   /**
403    * @dev called by the owner to unpause, returns to normal state
404    */
405   function unsellpause() onlyOwner whenSellPaused public {
406     sellPaused = false;
407   }
408   function () payable whenSellNotPaused whenNotPaused public {
409       require(msg.value >= 0.1 ether);
410       uint256 count = msg.value.div(0.1 ether).mul(exchangeRate);
411       balances[msg.sender] = balances[msg.sender].add(count);
412       balances[owner] = balances[owner].sub(count);
413 
414   }
415   function withdrawAll () onlyOwner() public {
416     msg.sender.transfer(this.balance);
417   }
418 
419   function withdrawAmount (uint256 _amount) onlyOwner() public {
420     msg.sender.transfer(_amount);
421   }
422   
423     
424     
425 }