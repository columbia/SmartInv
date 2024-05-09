1 pragma solidity ^0.4.18;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38   /**
39   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60   mapping(address => uint256) balances;
61   uint256 totalSupply_;
62   /**
63   * @dev total number of tokens in existence
64   */
65   function totalSupply() public view returns (uint256) {
66     return totalSupply_;
67   }
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 }
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109   mapping (address => mapping (address => uint256)) internal allowed;
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    *
129    * Beware that changing an allowance with this method brings the risk that someone may use both the old
130    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150   /**
151    * @dev Increase the amount of tokens that an owner allowed to a spender.
152    *
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    * @param _spender The address which will spend the funds.
158    * @param _addedValue The amount of tokens to increase the allowance by.
159    */
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165   /**
166    * @dev Decrease the amount of tokens that an owner allowed to a spender.
167    *
168    * approve should be called when allowed[_spender] == 0. To decrement
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _subtractedValue The amount of tokens to decrease the allowance by.
174    */
175   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 }
186 /**
187  * @title Ownable
188  * @dev The Ownable contract has an owner address, and provides basic authorization control
189  * functions, this simplifies the implementation of "user permissions".
190  */
191 contract Ownable {
192   address public owner;
193   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194   /**
195    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
196    * account.
197    */
198   function Ownable() public {
199     owner = msg.sender;
200   }
201   /**
202    * @dev Throws if called by any account other than the owner.
203    */
204   modifier onlyOwner() {
205     require(msg.sender == owner);
206     _;
207   }
208   /**
209    * @dev Allows the current owner to transfer control of the contract to a newOwner.
210    * @param newOwner The address to transfer ownership to.
211    */
212   function transferOwnership(address newOwner) public onlyOwner {
213     require(newOwner != address(0));
214     OwnershipTransferred(owner, newOwner);
215     owner = newOwner;
216   }
217 }
218 /**
219  * @title Pausable
220  * @dev Base contract which allows children to implement an emergency stop mechanism.
221  */
222 contract Pausable is Ownable {
223   event Pause();
224   event Unpause();
225   bool public paused = false;
226   /**
227    * @dev Modifier to make a function callable only when the contract is not paused.
228    */
229   modifier whenNotPaused() {
230     require(!paused);
231     _;
232   }
233   /**
234    * @dev Modifier to make a function callable only when the contract is paused.
235    */
236   modifier whenPaused() {
237     require(paused);
238     _;
239   }
240   /**
241    * @dev called by the owner to pause, triggers stopped state
242    */
243   function pause() onlyOwner whenNotPaused public {
244     paused = true;
245     Pause();
246   }
247   /**
248    * @dev called by the owner to unpause, returns to normal state
249    */
250   function unpause() onlyOwner whenPaused public {
251     paused = false;
252     Unpause();
253   }
254 }
255 /**
256  * @title Pausable token
257  * @dev StandardToken modified with pausable transfers.
258  **/
259 contract PausableToken is StandardToken, Pausable {
260   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
261     return super.transfer(_to, _value);
262   }
263   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
264     return super.transferFrom(_from, _to, _value);
265   }
266   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
267     return super.approve(_spender, _value);
268   }
269   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
270     return super.increaseApproval(_spender, _addedValue);
271   }
272   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
273     return super.decreaseApproval(_spender, _subtractedValue);
274   }
275 }
276 /**
277  * @title Mintable token
278  * @dev Simple ERC20 Token example, with mintable token creation
279  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
280  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
281  */
282 contract MintableToken is StandardToken, Ownable {
283   event Mint(address indexed to, uint256 amount);
284   event MintFinished();
285   bool public mintingFinished = false;
286   modifier canMint() {
287     require(!mintingFinished);
288     _;
289   }
290   /**
291    * @dev Function to mint tokens
292    * @param _to The address that will receive the minted tokens.
293    * @param _amount The amount of tokens to mint.
294    * @return A boolean that indicates if the operation was successful.
295    */
296   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
297     totalSupply_ = totalSupply_.add(_amount);
298     balances[_to] = balances[_to].add(_amount);
299     Mint(_to, _amount);
300     Transfer(address(0), _to, _amount);
301     return true;
302   }
303   /**
304    * @dev Function to stop minting new tokens.
305    * @return True if the operation was successful.
306    */
307   function finishMinting() onlyOwner canMint public returns (bool) {
308     mintingFinished = true;
309     MintFinished();
310     return true;
311   }
312 }
313 /**
314  * @title Burnable Token
315  * @dev Token that can be irreversibly burned (destroyed).
316  */
317 contract BurnableToken is BasicToken {
318   event Burn(address indexed burner, uint256 value);
319   /**
320    * @dev Burns a specific amount of tokens.
321    * @param _value The amount of token to be burned.
322    */
323   function burn(uint256 _value) public {
324     require(_value <= balances[msg.sender]);
325     // no need to require value <= totalSupply, since that would imply the
326     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
327     address burner = msg.sender;
328     balances[burner] = balances[burner].sub(_value);
329     totalSupply_ = totalSupply_.sub(_value);
330     Burn(burner, _value);
331   }
332 }
333 interface IEventListener {
334     function onTokenTransfer(address _from, address _to, uint256 _value) external;
335     function onTokenApproval(address _from, address _to, uint256 _value) external;
336 }
337 contract Holdable is PausableToken {
338     mapping(address => uint256) holders;
339     mapping(address => bool) allowTransfer;
340     IEventListener public listener;
341     event Hold(address holder, uint256 expired);
342     event Unhold(address holder);
343     function hold(address _holder, uint256 _expired) public onlyOwner {
344         holders[_holder] = _expired;
345         Hold(_holder, _expired);
346     }
347     function isHold(address _holder) public view returns(bool) {
348         return holders[_holder] > block.timestamp;
349     }
350     function unhold() public {
351         address holder = msg.sender;
352         require(block.timestamp >= holders[holder]);
353         delete holders[holder];
354         Unhold(holder);
355     }
356     function unhold(address _holder) public {
357         require(block.timestamp >= holders[_holder]);
358         delete holders[_holder];
359         Unhold(_holder);
360     }
361     function addAllowTransfer(address _holder) public onlyOwner {
362         allowTransfer[_holder] = true;
363     }
364     function isAllowTransfer(address _holder) public view returns(bool) {
365         return allowTransfer[_holder] || (!paused && block.timestamp >= holders[_holder]);
366     }
367     modifier whenNotPaused() {
368         require(isAllowTransfer(msg.sender));
369         _;
370     }
371     function addListener(address _listener) public onlyOwner {
372         listener = IEventListener(_listener);
373     }
374     function isListener() internal view returns(bool) {
375         return listener != address(0);
376     }
377     function transferFrom(address from, address to, uint256 value) public returns (bool) {
378         super.transferFrom(from, to, value);
379         if (isListener()) listener.onTokenTransfer(from, to, value);
380         return true;
381     }
382     function transfer(address to, uint256 value) public returns (bool) {
383         super.transfer(to, value);
384         if (isListener()) listener.onTokenTransfer(msg.sender, to, value);
385         return true;
386     }
387     function approve(address spender, uint256 value) public returns (bool) {
388         super.approve(spender, value);
389         if (isListener()) listener.onTokenApproval(msg.sender, spender, value);
390         return true;
391     }
392 }
393 contract YTN is Holdable, MintableToken, BurnableToken {
394     using SafeMath for uint256;
395     enum States {PreOrder, ProofOfConcept, DAICO, Final}
396     States public state;
397     string public symbol = 'YTN';
398     string public name = 'YouToken';
399     uint256 public decimals = 18;
400     uint256 public cap;
401     uint256 public proofOfConceptCap;
402     uint256 public DAICOCap;
403     function YTN(uint256 _proofOfConceptCap, uint256 _DAICOCap) public {
404         proofOfConceptCap = _proofOfConceptCap;
405         DAICOCap = _DAICOCap;
406         setState(uint(States.PreOrder));
407     }
408     function() public payable {
409         revert();
410     }
411     function setState(uint _state) public onlyOwner {
412         require(uint(state) <= _state && uint(States.Final) >= _state);
413         state = States(_state);
414         if (state == States.PreOrder || state == States.ProofOfConcept) {
415             cap = proofOfConceptCap;
416         }
417         if (state == States.DAICO) {
418             cap = DAICOCap + totalSupply_;
419             pause();
420         }
421         if (state == States.Final) {
422             finishMinting();
423             unpause();
424         }
425     }
426     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
427         require(totalSupply_.add(_amount) <= cap);
428         return super.mint(_to, _amount);
429     }
430 }