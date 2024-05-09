1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   function Ownable() public {
45     owner = msg.sender;
46   }
47 
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(newOwner != address(0));
64     OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 
68 }
69 
70 
71 contract ERC20Basic {
72   uint256 public totalSupply;
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) public view returns (uint256);
81   function transferFrom(address from, address to, uint256 value) public returns (bool);
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     // SafeMath.sub will throw if there is not enough balance.
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256 balance) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 
120 
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public view returns (uint256) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * approve should be called when allowed[_spender] == 0. To increment
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    */
176   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
183     uint oldValue = allowed[msg.sender][_spender];
184     if (_subtractedValue > oldValue) {
185       allowed[msg.sender][_spender] = 0;
186     } else {
187       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188     }
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193 }
194 
195 contract Pausable is Ownable {
196   event Pause();
197   event Unpause();
198 
199   bool public paused = false;
200 
201 
202   /**
203    * @dev Modifier to make a function callable only when the contract is not paused.
204    */
205   modifier whenNotPaused() {
206     require(!paused);
207     _;
208   }
209 
210   /**
211    * @dev Modifier to make a function callable only when the contract is paused.
212    */
213   modifier whenPaused() {
214     require(paused);
215     _;
216   }
217 
218   /**
219    * @dev called by the owner to pause, triggers stopped state
220    */
221   function pause() onlyOwner whenNotPaused public {
222     paused = true;
223     Pause();
224   }
225 
226   /**
227    * @dev called by the owner to unpause, returns to normal state
228    */
229   function unpause() onlyOwner whenPaused public {
230     paused = false;
231     Unpause();
232   }
233 }
234 
235 
236 
237 contract MintableToken is StandardToken, Ownable {
238   event Mint(address indexed to, uint256 amount);
239   event MintFinished();
240 
241   bool public mintingFinished = false;
242 
243 
244   modifier canMint() {
245     require(!mintingFinished);
246     _;
247   }
248 
249   /**
250    * @dev Function to mint tokens
251    * @param _to The address that will receive the minted tokens.
252    * @param _amount The amount of tokens to mint.
253    * @return A boolean that indicates if the operation was successful.
254    */
255   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
256     totalSupply = totalSupply.add(_amount);
257     balances[_to] = balances[_to].add(_amount);
258     Mint(_to, _amount);
259     Transfer(address(0), _to, _amount);
260     return true;
261   }
262 
263   /**
264    * @dev Function to stop minting new tokens.
265    * @return True if the operation was successful.
266    */
267   function finishMinting() onlyOwner canMint public returns (bool) {
268     mintingFinished = true;
269     MintFinished();
270     return true;
271   }
272 }
273 
274 
275 contract BurnableToken is StandardToken {
276 
277     event Burn(address indexed burner, uint256 value);
278 
279     /**
280      * @dev Burns a specific amount of tokens.
281      * @param _value The amount of token to be burned.
282      */
283     function burn(uint256 _value) public {
284         require(_value > 0);
285         require(_value <= balances[msg.sender]);
286         // no need to require value <= totalSupply, since that would imply the
287         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
288 
289         address burner = msg.sender;
290         balances[burner] = balances[burner].sub(_value);
291         totalSupply = totalSupply.sub(_value);
292         Burn(burner, _value);
293     }
294 }
295 
296 
297 
298 contract PausableToken is StandardToken, Pausable {
299 
300   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
301     return super.transfer(_to, _value);
302   }
303 
304   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
305     return super.transferFrom(_from, _to, _value);
306   }
307 
308   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
309     return super.approve(_spender, _value);
310   }
311 
312   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
313     return super.increaseApproval(_spender, _addedValue);
314   }
315 
316   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
317     return super.decreaseApproval(_spender, _subtractedValue);
318   }
319 }
320 
321 
322 contract TokenRecipient {
323 
324     function tokenFallback(address sender, uint256 _value, bytes _extraData) returns (bool) {}
325 
326 }
327 
328 
329 
330 
331 
332 
333 
334 
335 
336 
337 
338 
339 
340 
341 contract FunctionXToken is MintableToken, BurnableToken, PausableToken {
342 
343     string public constant name = "Function X";
344     string public constant symbol = "FX";
345     uint8 public constant decimals = 18;
346 
347 
348     function FunctionXToken() {
349 
350     }
351 
352 
353     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
354         bool result = super.transferFrom(_from, _to, _value);
355         return result;
356     }
357 
358     mapping (address => bool) stopReceive;
359 
360     function setStopReceive(bool stop) {
361         stopReceive[msg.sender] = stop;
362     }
363 
364     function getStopReceive() constant public returns (bool) {
365         return stopReceive[msg.sender];
366     }
367 
368     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
369         require(!stopReceive[_to]);
370         bool result = super.transfer(_to, _value);
371         return result;
372     }
373 
374 
375     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
376         bool result = super.mint(_to, _amount);
377         return result;
378     }
379 
380     function burn(uint256 _value) public {
381         super.burn(_value);
382     }
383 
384 
385     function pause() onlyOwner whenNotPaused public {
386         super.pause();
387     }
388 
389 
390     function unpause() onlyOwner whenPaused public {
391         super.unpause();
392     }
393 
394     function transferAndCall(address _recipient, uint256 _amount, bytes _data) {
395         require(_recipient != address(0));
396         require(_amount <= balances[msg.sender]);
397 
398         balances[msg.sender] = balances[msg.sender].sub(_amount);
399         balances[_recipient] = balances[_recipient].add(_amount);
400 
401         require(TokenRecipient(_recipient).tokenFallback(msg.sender, _amount, _data));
402         Transfer(msg.sender, _recipient, _amount);
403     }
404 
405 
406     function transferERCToken(address _tokenContractAddress, address _to, uint256 _amount) onlyOwner {
407         require(ERC20(_tokenContractAddress).transfer(_to, _amount));
408     }
409 
410 }