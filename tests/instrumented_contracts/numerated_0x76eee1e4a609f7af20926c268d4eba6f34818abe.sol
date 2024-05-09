1 pragma solidity ^0.4.13;
2 
3 interface tokenRecipient { 
4 
5     function receiveApproval(
6 
7         address _from, 
8 
9         uint256 _value,
10 
11         address _token, 
12 
13         bytes _extraData
14 
15     ) public; 
16 
17 }
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
60     owner = msg.sender;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 contract Pausable is Ownable {
86   event Pause();
87   event Unpause();
88 
89   bool public paused = false;
90 
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     Unpause();
122   }
123 }
124 
125 contract ERC20Basic {
126   uint256 public totalSupply;
127   function balanceOf(address who) public view returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 contract BurnableToken is BasicToken {
165 
166     event Burn(address indexed burner, uint256 value);
167 
168     /**
169      * @dev Burns a specific amount of tokens.
170      * @param _value The amount of token to be burned.
171      */
172     function burn(uint256 _value) public {
173         require(_value <= balances[msg.sender]);
174         // no need to require value <= totalSupply, since that would imply the
175         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
176 
177         address burner = msg.sender;
178         balances[burner] = balances[burner].sub(_value);
179         totalSupply = totalSupply.sub(_value);
180         Burn(burner, _value);
181     }
182 }
183 
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
267     uint oldValue = allowed[msg.sender][_spender];
268     if (_subtractedValue > oldValue) {
269       allowed[msg.sender][_spender] = 0;
270     } else {
271       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272     }
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277 }
278 
279 contract MintableToken is StandardToken, Ownable {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282 
283   bool public mintingFinished = false;
284 
285 
286   modifier canMint() {
287     require(!mintingFinished);
288     _;
289   }
290 
291   /**
292    * @dev Function to mint tokens
293    * @param _to The address that will receive the minted tokens.
294    * @param _amount The amount of tokens to mint.
295    * @return A boolean that indicates if the operation was successful.
296    */
297   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
298     totalSupply = totalSupply.add(_amount);
299     balances[_to] = balances[_to].add(_amount);
300     Mint(_to, _amount);
301     Transfer(address(0), _to, _amount);
302     return true;
303   }
304 
305   /**
306    * @dev Function to stop minting new tokens.
307    * @return True if the operation was successful.
308    */
309   function finishMinting() onlyOwner canMint public returns (bool) {
310     mintingFinished = true;
311     MintFinished();
312     return true;
313   }
314 }
315 
316 contract PausableToken is StandardToken, Pausable {
317 
318   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transfer(_to, _value);
320   }
321 
322   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
323     return super.transferFrom(_from, _to, _value);
324   }
325 
326   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
327     return super.approve(_spender, _value);
328   }
329 
330   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
331     return super.increaseApproval(_spender, _addedValue);
332   }
333 
334   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
335     return super.decreaseApproval(_spender, _subtractedValue);
336   }
337 }
338 
339 contract DRCTestToken is BurnableToken, MintableToken, PausableToken {    
340 
341     string public name = 'DRC Test Token 1';
342 
343     string public symbol = 'DRC1';
344 
345     uint8 public decimals = 18;
346 
347     uint256 public INITIAL_SUPPLY = 1000000000000000000000000000;
348 
349 
350 
351     /**
352 
353      * contruct the token by total amount 
354 
355      *
356 
357      * there are 3 phases for releasing the tokens, initial balance is set. 
358 
359      */
360 
361     function DRCTestToken() public {
362 
363         totalSupply = INITIAL_SUPPLY;
364 
365         balances[msg.sender] = totalSupply;
366 
367     }
368 
369 
370 
371     /**
372 
373      * Destroy tokens from other account
374 
375      *
376 
377      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
378 
379      *
380 
381      * @param _from the address of the sender
382 
383      * @param _value the amount of money to burn
384 
385      */
386 
387     function burnFrom(address _from, uint256 _value) public returns (bool success) {
388 
389         require(balances[_from] >= _value);                // Check if the targeted balance is enough
390 
391         require(_value <= allowed[_from][msg.sender]);    // Check allowance
392 
393         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
394 
395         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
396 
397         totalSupply = totalSupply.sub(_value);
398 
399         Burn(_from, _value);
400 
401         return true;
402 
403     }
404 
405     
406 
407     /**
408 
409      * Set allowance for other address and notify
410 
411      *
412 
413      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
414 
415      *
416 
417      * @param _spender The address authorized to spend
418 
419      * @param _value the max amount they can spend
420 
421      * @param _extraData some extra information to send to the approved contract
422 
423      */
424 
425     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
426 
427         tokenRecipient spender = tokenRecipient(_spender);
428 
429         if (approve(_spender, _value)) {
430 
431             spender.receiveApproval(msg.sender, _value, this, _extraData);
432 
433             return true;
434 
435         }
436 
437     }
438 
439 }