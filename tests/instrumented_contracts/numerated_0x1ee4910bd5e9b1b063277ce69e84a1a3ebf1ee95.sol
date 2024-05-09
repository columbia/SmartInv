1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66     function allowance(address owner, address spender) public view returns (uint256);
67     function transferFrom(address from, address to, uint256 value) public returns (bool);
68     function approve(address spender, uint256 value) public returns (bool);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77     using SafeMath for uint256;
78 
79     mapping(address => uint256) balances;
80 
81     uint256 totalSupply_;
82 
83     /**
84     * @dev total number of tokens in existence
85     */
86     function totalSupply() public view returns (uint256) {
87         return totalSupply_;
88     }
89 
90     /**
91     * @dev transfer token for a specified address
92     * @param _to The address to transfer to.
93     * @param _value The amount to be transferred.
94     */
95     function transfer(address _to, uint256 _value) public returns (bool) {
96         require(_to != address(0));
97         require(_value <= balances[msg.sender]);
98 
99         // SafeMath.sub will throw if there is not enough balance.
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         Transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     /**
107     * @dev Gets the balance of the specified address.
108     * @param _owner The address to query the the balance of.
109     * @return An uint256 representing the amount owned by the passed address.
110     */
111     function balanceOf(address _owner) public view returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115 }
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125     mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128     /**
129      * @dev Transfer tokens from one address to another
130      * @param _from address The address which you want to send tokens from
131      * @param _to address The address which you want to transfer to
132      * @param _value uint256 the amount of tokens to be transferred
133      */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param _owner address The address which owns the funds.
165      * @param _spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address _owner, address _spender) public view returns (uint256) {
169         return allowed[_owner][_spender];
170     }
171 
172     /**
173      * @dev Increase the amount of tokens that an owner allowed to a spender.
174      *
175      * approve should be called when allowed[_spender] == 0. To increment
176      * allowed value is better to use this function to avoid 2 calls (and wait until
177      * the first transaction is mined)
178      * From MonolithDAO Token.sol
179      * @param _spender The address which will spend the funds.
180      * @param _addedValue The amount of tokens to increase the allowance by.
181      */
182     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187 
188     /**
189      * @dev Decrease the amount of tokens that an owner allowed to a spender.
190      *
191      * approve should be called when allowed[_spender] == 0. To decrement
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * @param _spender The address which will spend the funds.
196      * @param _subtractedValue The amount of tokens to decrease the allowance by.
197      */
198     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199         uint oldValue = allowed[msg.sender][_spender];
200         if (_subtractedValue > oldValue) {
201             allowed[msg.sender][_spender] = 0;
202         } else {
203             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204         }
205         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206         return true;
207     }
208 
209 }
210 
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218     address public owner;
219 
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224     /**
225      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226      * account.
227      */
228     function Ownable() public {
229         owner = msg.sender;
230     }
231 
232     /**
233      * @dev Throws if called by any account other than the owner.
234      */
235     modifier onlyOwner() {
236         require(msg.sender == owner);
237         _;
238     }
239 
240     /**
241      * @dev Allows the current owner to transfer control of the contract to a newOwner.
242      * @param newOwner The address to transfer ownership to.
243      */
244     function transferOwnership(address newOwner) public onlyOwner {
245         require(newOwner != address(0));
246         OwnershipTransferred(owner, newOwner);
247         owner = newOwner;
248     }
249 
250 }
251 /**
252  * @title Pausable
253  * @dev Base contract which allows children to implement an emergency stop mechanism.
254  */
255 contract Pausable is Ownable {
256     event Pause();
257     event Unpause();
258 
259     bool public paused = false;
260 
261 
262     /**
263      * @dev Modifier to make a function callable only when the contract is not paused.
264      */
265     modifier whenNotPaused() {
266         require(!paused);
267         _;
268     }
269 
270     /**
271      * @dev Modifier to make a function callable only when the contract is paused.
272      */
273     modifier whenPaused() {
274         require(paused);
275         _;
276     }
277 
278     /**
279      * @dev called by the owner to pause, triggers stopped state
280      */
281     function pause() onlyOwner whenNotPaused public {
282         paused = true;
283         Pause();
284     }
285 
286     /**
287      * @dev called by the owner to unpause, returns to normal state
288      */
289     function unpause() onlyOwner whenPaused public {
290         paused = false;
291         Unpause();
292     }
293 }
294 
295 /**
296  * @title Pausable token
297  * @dev StandardToken modified with pausable transfers.
298  **/
299 contract PausableToken is StandardToken, Pausable {
300 
301     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
302         return super.transfer(_to, _value);
303     }
304 
305     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
306         return super.transferFrom(_from, _to, _value);
307     }
308 
309     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
310         return super.approve(_spender, _value);
311     }
312 
313     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
314         return super.increaseApproval(_spender, _addedValue);
315     }
316 
317     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
318         return super.decreaseApproval(_spender, _subtractedValue);
319     }
320 }
321 
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330     event Mint(address indexed to, uint256 amount);
331     event MintFinished();
332 
333     bool public mintingFinished = false;
334 
335 
336     modifier canMint() {
337         require(!mintingFinished);
338         _;
339     }
340 
341     /**
342      * @dev Function to mint tokens
343      * @param _to The address that will receive the minted tokens.
344      * @param _amount The amount of tokens to mint.
345      * @return A boolean that indicates if the operation was successful.
346      */
347     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348         totalSupply_ = totalSupply_.add(_amount);
349         balances[_to] = balances[_to].add(_amount);
350         Mint(_to, _amount);
351         Transfer(address(0), _to, _amount);
352         return true;
353     }
354 
355     /**
356      * @dev Function to stop minting new tokens.
357      * @return True if the operation was successful.
358      */
359     function finishMinting() onlyOwner canMint public returns (bool) {
360         mintingFinished = true;
361         MintFinished();
362         return true;
363     }
364 }
365 /**
366  * @title Burnable Token
367  * @dev Token that can be irreversibly burned (destroyed).
368  */
369 contract BurnableToken is BasicToken {
370 
371     event Burn(address indexed burner, uint256 value);
372 
373     /**
374      * @dev Burns a specific amount of tokens.
375      * @param _value The amount of token to be burned.
376      */
377     function burn(uint256 _value) public {
378         require(_value <= balances[msg.sender]);
379         // no need to require value <= totalSupply, since that would imply the
380         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
381 
382         address burner = msg.sender;
383         balances[burner] = balances[burner].sub(_value);
384         totalSupply_ = totalSupply_.sub(_value);
385         Burn(burner, _value);
386     }
387 }
388 
389 contract UPXToken is MintableToken, PausableToken, BurnableToken  {
390     string public name = "UPCoin Token";
391     string public symbol = "UPX";
392     uint8 public decimals = 8;
393 
394     uint256 public constant INITIAL_SUPPLY = 30000000000000000;
395 
396     /**
397      * @dev Constructor that gives msg.sender all of existing tokens.
398      */
399     function UPXToken() public {
400         totalSupply_ = INITIAL_SUPPLY;
401         balances[msg.sender] = INITIAL_SUPPLY;
402         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
403     }
404 }