1 pragma solidity ^0.4.18;
2 
3 // Based on https://github.com/OpenZeppelin/zeppelin-solidity
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/179
43  */
44 contract ERC20Basic {
45     uint256 public totalSupply;
46     function balanceOf(address who) public view returns (uint256);
47     function transfer(address to, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57     function allowance(address owner, address spender) public view returns (uint256);
58     function transferFrom(address from, address to, uint256 value) public returns (bool);
59     function approve(address spender, uint256 value) public returns (bool);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69     using SafeMath for uint256;
70 
71     mapping(address => uint256) balances;
72 
73     /**
74     * @dev transfer token for a specified address
75     * @param _to The address to transfer to.
76     * @param _value The amount to be transferred.
77     */
78     function transfer(address _to, uint256 _value) public returns (bool) {
79         require(_to != address(0));
80         require(_value <= balances[msg.sender]);
81 
82         // SafeMath.sub will throw if there is not enough balance.
83         balances[msg.sender] = balances[msg.sender].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         Transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     /**
90     * @dev Gets the balance of the specified address.
91     * @param _owner The address to query the the balance of.
92     * @return An uint256 representing the amount owned by the passed address.
93     */
94     function balanceOf(address _owner) public view returns (uint256 balance) {
95         return balances[_owner];
96     }
97 
98 }
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110     mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113     /**
114      * @dev Transfer tokens from one address to another
115      * @param _from address The address which you want to send tokens from
116      * @param _to address The address which you want to transfer to
117      * @param _value uint256 the amount of tokens to be transferred
118      */
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120         require(_to != address(0));
121         require(_value <= balances[_from]);
122         require(_value <= allowed[_from][msg.sender]);
123 
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     /**
132      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133      *
134      * Beware that changing an allowance with this method brings the risk that someone may use both the old
135      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      * @param _spender The address which will spend the funds.
139      * @param _value The amount of tokens to be spent.
140      */
141     function approve(address _spender, uint256 _value) public returns (bool) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Function to check the amount of tokens that an owner allowed to a spender.
149      * @param _owner address The address which owns the funds.
150      * @param _spender address The address which will spend the funds.
151      * @return A uint256 specifying the amount of tokens still available for the spender.
152      */
153     function allowance(address _owner, address _spender) public view returns (uint256) {
154         return allowed[_owner][_spender];
155     }
156 
157     /**
158      * @dev Increase the amount of tokens that an owner allowed to a spender.
159      *
160      * approve should be called when allowed[_spender] == 0. To increment
161      * allowed value is better to use this function to avoid 2 calls (and wait until
162      * the first transaction is mined)
163      * From MonolithDAO Token.sol
164      * @param _spender The address which will spend the funds.
165      * @param _addedValue The amount of tokens to increase the allowance by.
166      */
167     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172 
173     /**
174      * @dev Decrease the amount of tokens that an owner allowed to a spender.
175      *
176      * approve should be called when allowed[_spender] == 0. To decrement
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * @param _spender The address which will spend the funds.
181      * @param _subtractedValue The amount of tokens to decrease the allowance by.
182      */
183     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184         uint oldValue = allowed[msg.sender][_spender];
185         if (_subtractedValue > oldValue) {
186             allowed[msg.sender][_spender] = 0;
187         } else {
188             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189         }
190         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193 
194 }
195 
196 
197 /**
198  * @title Ownable
199  * @dev The Ownable contract has an owner address, and provides basic authorization control
200  * functions, this simplifies the implementation of "user permissions".
201  */
202 contract Ownable {
203     address public owner;
204 
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208 
209     /**
210      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
211      * account.
212      */
213     function Ownable() public {
214         owner = msg.sender;
215     }
216 
217 
218     /**
219      * @dev Throws if called by any account other than the owner.
220      */
221     modifier onlyOwner() {
222         require(msg.sender == owner);
223         _;
224     }
225 
226 
227     /**
228      * @dev Allows the current owner to transfer control of the contract to a newOwner.
229      * @param newOwner The address to transfer ownership to.
230      */
231     function transferOwnership(address newOwner) public onlyOwner {
232         require(newOwner != address(0));
233         OwnershipTransferred(owner, newOwner);
234         owner = newOwner;
235     }
236 
237 }
238 
239 
240 /**
241  * @title Pausable
242  * @dev Base contract which allows children to implement an emergency stop mechanism.
243  */
244 contract Pausable is Ownable {
245     event Pause();
246     event Unpause();
247 
248     bool public paused = false;
249 
250 
251     /**
252      * @dev Modifier to make a function callable only when the contract is not paused.
253      */
254     modifier whenNotPaused() {
255         require(!paused);
256         _;
257     }
258 
259     /**
260      * @dev Modifier to make a function callable only when the contract is paused.
261      */
262     modifier whenPaused() {
263         require(paused);
264         _;
265     }
266 
267     /**
268      * @dev called by the owner to pause, triggers stopped state
269      */
270     function pause() onlyOwner whenNotPaused public {
271         paused = true;
272         Pause();
273     }
274 
275     /**
276      * @dev called by the owner to unpause, returns to normal state
277      */
278     function unpause() onlyOwner whenPaused public {
279         paused = false;
280         Unpause();
281     }
282 }
283 
284 /**
285  * @title Pausable token
286  *
287  * @dev StandardToken modified with pausable transfers.
288  **/
289 
290 contract PausableToken is StandardToken, Pausable {
291 
292     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
293         return super.transfer(_to, _value);
294     }
295 
296     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
297         return super.transferFrom(_from, _to, _value);
298     }
299 
300     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
301         return super.approve(_spender, _value);
302     }
303 
304     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
305         return super.increaseApproval(_spender, _addedValue);
306     }
307 
308     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
309         return super.decreaseApproval(_spender, _subtractedValue);
310     }
311 }
312 
313 
314 /**
315  * @title Mintable token
316  * @dev Simple ERC20 Token example, with mintable token creation
317  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
318  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
319  */
320 
321 contract MintableToken is StandardToken, Ownable {
322     event Mint(address indexed to, uint256 amount);
323     event MintFinished();
324 
325     bool public mintingFinished = false;
326 
327 
328     modifier canMint() {
329         require(!mintingFinished);
330         _;
331     }
332 
333     /**
334      * @dev Function to mint tokens
335      * @param _to The address that will receive the minted tokens.
336      * @param _amount The amount of tokens to mint.
337      * @return A boolean that indicates if the operation was successful.
338      */
339     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
340         totalSupply = totalSupply.add(_amount);
341         balances[_to] = balances[_to].add(_amount);
342         Mint(_to, _amount);
343         Transfer(address(0), _to, _amount);
344         return true;
345     }
346 
347     /**
348      * @dev Function to stop minting new tokens.
349      * @return True if the operation was successful.
350      */
351     function finishMinting() onlyOwner canMint public returns (bool) {
352         mintingFinished = true;
353         MintFinished();
354         return true;
355     }
356 }
357 
358 /**
359  * @title Burnable Token
360  * @dev Token that can be irreversibly burned (destroyed).
361  */
362 contract BurnableToken is BasicToken {
363 
364     event Burn(address indexed burner, uint256 value);
365 
366     /**
367      * @dev Burns a specific amount of tokens.
368      * @param _value The amount of token to be burned.
369      */
370     function burn(uint256 _value) public {
371         require(_value <= balances[msg.sender]);
372         // no need to require value <= totalSupply, since that would imply the
373         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
374 
375         address burner = msg.sender;
376         balances[burner] = balances[burner].sub(_value);
377         totalSupply = totalSupply.sub(_value);
378         Burn(burner, _value);
379     }
380 }
381 
382 
383 /**
384  * @title GEToken
385  * @dev GET Mintable Token with migration from legacy contract
386  */
387 contract GEToken is PausableToken, MintableToken, BurnableToken {
388     using SafeMath for uint256;
389 
390     // Public variables of the token
391     string public name;
392     string public symbol;
393     uint256 public decimals;
394 
395     // creator of contract
396     // will get init tokens when create contract
397     address public creator;
398 
399     /**
400      * Set up the initialization parameter
401      */
402     function GEToken (
403         string    _tokenName,
404         string    _tokenSymbol,
405         uint256   _tokenDecimals,
406         uint256   _totalSupply
407     ) public {
408 
409         // simple check
410         require(_totalSupply > 0);
411 
412         // init contract variables
413         name = _tokenName;
414         symbol = _tokenSymbol;
415         decimals = _tokenDecimals;
416         totalSupply = _totalSupply;
417 
418         // give all init tokens to creator
419         balances[msg.sender] = totalSupply;
420         creator = msg.sender;
421     }
422 }