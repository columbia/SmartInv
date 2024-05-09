1 pragma solidity ^0.4.21;
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
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
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
27         assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     constructor() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 
90 }
91 
92 
93 
94 /**
95  * @title ERC20Basic
96  * @dev Simpler version of ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/179
98  */
99 contract ERC20Basic {
100     function totalSupply() public view returns (uint256);
101     function balanceOf(address who) public view returns (uint256);
102     function transfer(address to, uint256 value) public returns (bool);
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113     function allowance(address owner, address spender) public view returns (uint256);
114     function transferFrom(address from, address to, uint256 value) public returns (bool);
115     function approve(address spender, uint256 value) public returns (bool);
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125     using SafeMath for uint256;
126 
127     mapping(address => uint256) balances;
128 
129     uint256 totalSupply_;
130 
131     /**
132     * @dev total number of tokens in existence
133     */
134     function totalSupply() public view returns (uint256) {
135         return totalSupply_;
136     }
137 
138     /**
139     * @dev transfer token for a specified address
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143     function transfer(address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[msg.sender]);
146 
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         emit Transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153     /**
154     * @dev Gets the balance of the specified address.
155     * @param _owner The address to query the the balance of.
156     * @return An uint256 representing the amount owned by the passed address.
157     */
158     function balanceOf(address _owner) public view returns (uint256) {
159         return balances[_owner];
160     }
161 
162 }
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173     mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176     /**
177      * @dev Transfer tokens from one address to another
178      * @param _from address The address which you want to send tokens from
179      * @param _to address The address which you want to transfer to
180      * @param _value uint256 the amount of tokens to be transferred
181      */
182     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183         require(_to != address(0));
184         require(_value <= balances[_from]);
185         require(_value <= allowed[_from][msg.sender]);
186 
187         balances[_from] = balances[_from].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190         emit Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196      *
197      * Beware that changing an allowance with this method brings the risk that someone may use both the old
198      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      * @param _spender The address which will spend the funds.
202      * @param _value The amount of tokens to be spent.
203      */
204     function approve(address _spender, uint256 _value) public returns (bool) {
205         allowed[msg.sender][_spender] = _value;
206         emit Approval(msg.sender, _spender, _value);
207         return true;
208     }
209 
210     /**
211      * @dev Function to check the amount of tokens that an owner allowed to a spender.
212      * @param _owner address The address which owns the funds.
213      * @param _spender address The address which will spend the funds.
214      * @return A uint256 specifying the amount of tokens still available for the spender.
215      */
216     function allowance(address _owner, address _spender) public view returns (uint256) {
217         return allowed[_owner][_spender];
218     }
219 
220     /**
221      * @dev Increase the amount of tokens that an owner allowed to a spender.
222      *
223      * approve should be called when allowed[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * @param _spender The address which will spend the funds.
228      * @param _addedValue The amount of tokens to increase the allowance by.
229      */
230     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233         return true;
234     }
235 
236     /**
237      * @dev Decrease the amount of tokens that an owner allowed to a spender.
238      *
239      * approve should be called when allowed[_spender] == 0. To decrement
240      * allowed value is better to use this function to avoid 2 calls (and wait until
241      * the first transaction is mined)
242      * From MonolithDAO Token.sol
243      * @param _spender The address which will spend the funds.
244      * @param _subtractedValue The amount of tokens to decrease the allowance by.
245      */
246     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247         uint oldValue = allowed[msg.sender][_spender];
248         if (_subtractedValue > oldValue) {
249             allowed[msg.sender][_spender] = 0;
250         } else {
251             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252         }
253         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254         return true;
255     }
256 
257 }
258 
259 
260 contract Publyto is StandardToken, Ownable {
261 
262     using SafeMath for uint256;
263 
264     event Mint(address indexed to, uint256 amount);
265     event Burn(address indexed burner, uint256 value);
266     event BurnFinished();
267     event Retrieve(address indexed from, uint256 value);
268     event RetrieveFinished();
269 
270     string public constant name = "Publyto";
271     string public constant symbol = "PUB";
272     uint8 public constant decimals = 18;
273     uint256 public initialSupply = 1000000000; // 1 billion tokens
274     uint256 public totalSupply =  initialSupply.mul(10 ** uint256(decimals));
275 
276     bool public burnFinished = false;
277     bool public isLocked = true;
278     bool public retrieveFinished = false;
279 
280 
281     constructor() public {
282         totalSupply_ = totalSupply;
283         balances[msg.sender] = totalSupply;
284     }
285 
286 
287     modifier canBurn() {
288         require(!burnFinished);
289         _;
290     }
291 
292     /**
293      * @dev unlock the tokens. If token is unlocked, can transfer.
294      */
295     function unlock() external onlyOwner {
296         isLocked = false;
297     }
298 
299     /**
300      * @dev lock the tokens. If token is locked, cannot transfer
301      */
302     function lock() external onlyOwner {
303         isLocked = true;
304     }
305 
306 
307     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
308         require(!isLocked || msg.sender == owner);
309         return super.transferFrom(_from, _to, _value);
310     }
311 
312     function transfer(address _to, uint256 _value) public returns (bool) {
313         require(!isLocked || msg.sender == owner);
314         return super.transfer(_to, _value);
315     }
316 
317 
318     /**
319      * @dev Function to mint tokens
320      * @param _to The address that will receive the minted tokens.
321      * @param _amount The amount of tokens to mint.
322      * @return A boolean that indicates if the operation was successful.
323      */
324     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
325         totalSupply_ = totalSupply_.add(_amount);
326         totalSupply = totalSupply_;
327 
328         balances[_to] = balances[_to].add(_amount);
329 
330         emit Mint(_to, _amount);
331         emit Transfer(address(0), _to, _amount);
332         return true;
333     }
334 
335 
336     /**
337      * @dev Burns a specific amount of tokens.
338      * @param _value The amount of token to be burned.
339      */
340     function burn(uint256 _value) onlyOwner canBurn public {
341         _burn(msg.sender, _value);
342     }
343 
344 
345     function _burn(address _who, uint256 _value) internal {
346         require(_value <= balances[_who]);
347         // no need to require value <= totalSupply, since that would imply the
348         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
349 
350         balances[_who] = balances[_who].sub(_value);
351         totalSupply_ = totalSupply_.sub(_value);
352         totalSupply = totalSupply_;
353         emit Burn(_who, _value);
354         emit Transfer(_who, address(0), _value);
355     }
356 
357     /**
358      * @dev Function to stop burning tokens.
359      * @return True if the operation was successful.
360      */
361     function finishBurning() onlyOwner public returns (bool) {
362         burnFinished = true;
363         emit BurnFinished();
364         return true;
365     }
366 
367 
368     /**
369      * @dev Retrieve a specific amount of tokens.
370      * @param _who The address that will retrieve the tokens.
371      * @param _value The amount of token to be retrieved.
372      */
373     function retrieve(address _who, uint256 _value) onlyOwner public {
374         require(!retrieveFinished);
375         require(_who != address(0));
376         require(_value <= balances[_who]);
377         require(_value >= 0);
378 
379         balances[_who] = balances[_who].sub(_value);
380         balances[msg.sender] = balances[msg.sender].add(_value);
381 
382         emit Retrieve(_who, _value);
383         emit Transfer(_who, msg.sender, _value);
384     }
385 
386 
387     /**
388      * @dev Function to stop retrieving tokens.
389      * @return True if the operation was successful.
390      */
391     function finishRetrieving() onlyOwner public returns (bool) {
392         retrieveFinished = true;
393         emit RetrieveFinished();
394         return true;
395     }
396 
397 }