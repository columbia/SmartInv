1 pragma solidity ^0.5.2;
2 /**
3  * Data Revolution Technologies PTY LTD
4  * Touch Smart Token (TST)
5  */
6  
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a * b;
18         assert(a == 0 || c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b > 0);
27         uint256 c = a / b;
28         assert(a == b * c + a % b);
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c>=a && c>=b);
46         return c;
47     }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipRenounced(address indexed previousOwner);
59     event OwnershipTransferred(
60         address indexed previousOwner,
61         address indexed newOwner
62     );
63 
64     /**
65     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66     * account.
67     */
68     constructor() public {
69         owner = msg.sender;
70     }
71 
72     /**
73     * @dev Throws if called by any account other than the owner.
74     */
75     modifier onlyOwner() {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     /**
81     * @dev Allows the current owner to transfer control of the contract to a newOwner.
82     * @param newOwner The address to transfer ownership to.
83     */
84     function transferOwnership(address newOwner) public onlyOwner {
85         require(newOwner != address(0));
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 
90     /**
91     * @dev Allows the current owner to relinquish control of the contract.
92     */
93     function renounceOwnership() public onlyOwner {
94         emit OwnershipRenounced(owner);
95         owner = address(0);
96     }
97 }
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105     function totalSupply() public view returns (uint256);
106     function balanceOf(address who) public view returns (uint256);
107     function transfer(address to, uint256 value) public returns (bool);
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116     function allowance(address owner, address spender) public view returns (uint256);
117     function transferFrom(address from, address to, uint256 value) public returns (bool);
118     function approve(address spender, uint256 value) public returns (bool);
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 contract BasicToken is ERC20Basic {
123     using SafeMath for uint256;
124 
125     mapping(address => uint256) balances;
126 
127     uint256 totalSupply_;
128 
129     /**
130     * @dev total number of tokens in existence
131     */
132     function totalSupply() public view returns (uint256) {
133         return totalSupply_;
134     }
135 
136     /**
137     * @dev transfer token for a specified address
138     * @param _to The address to transfer to.
139     * @param _value The amount to be transferred.
140     */
141     function transfer(address _to, uint256 _value) public returns (bool) {
142         require(_to != address(0));
143         require(_value <= balances[msg.sender]);
144 
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         emit Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     /**
152     * @dev Gets the balance of the specified address.
153     * @param _owner The address to query the the balance of.
154     * @return An uint256 representing the amount owned by the passed address.
155     */
156     function balanceOf(address _owner) public view returns (uint256) {
157         return balances[_owner];
158     }
159 
160 }
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170     mapping (address => mapping (address => uint256)) allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180         require(_to != address(0));
181         require(_value <= balances[_from]);
182         require(_value <= allowed[_from][msg.sender]);
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     /**
192     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193     *
194     * Beware that changing an allowance with this method brings the risk that someone may use both the old
195     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198     * @param _spender The address which will spend the funds.
199     * @param _value The amount of tokens to be spent.
200     */
201     function approve(address _spender, uint256 _value) public returns (bool) {
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208     * @dev Function to check the amount of tokens that an owner allowed to a spender.
209     * @param _owner address The address which owns the funds.
210     * @param _spender address The address which will spend the funds.
211     * @return A uint256 specifying the amount of tokens still available for the spender.
212     */
213     function allowance(address _owner, address _spender) public view returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216 
217     /**
218     * @dev Increase the amount of tokens that an owner allowed to a spender.
219     *
220     * approve should be called when allowed[_spender] == 0. To increment
221     * allowed value is better to use this function to avoid 2 calls (and wait until
222     * the first transaction is mined)
223     * From MonolithDAO Token.sol
224     * @param _spender The address which will spend the funds.
225     * @param _addedValue The amount of tokens to increase the allowance by.
226     */
227     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     /**
234     * @dev Decrease the amount of tokens that an owner allowed to a spender.
235     *
236     * approve should be called when allowed[_spender] == 0. To decrement
237     * allowed value is better to use this function to avoid 2 calls (and wait until
238     * the first transaction is mined)
239     * From MonolithDAO Token.sol
240     * @param _spender The address which will spend the funds.
241     * @param _subtractedValue The amount of tokens to decrease the allowance by.
242     */
243     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
244         uint oldValue = allowed[msg.sender][_spender];
245         if (_subtractedValue > oldValue) {
246             allowed[msg.sender][_spender] = 0;
247         } else {
248             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249         }
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254 }
255 
256 contract Pausable is Ownable {
257     event Pause();
258     event Unpause();
259 
260     bool public paused = false;
261 
262 
263     /**
264     * @dev Modifier to make a function callable only when the contract is not paused.
265     */
266     modifier whenNotPaused() {
267         require(!paused);
268         _;
269     }
270 
271     /**
272     * @dev Modifier to make a function callable only when the contract is paused.
273     */
274     modifier whenPaused() {
275         require(paused);
276         _;
277     }
278 
279     /**
280     * @dev called by the owner to pause, triggers stopped state
281     */
282     function pause() onlyOwner whenNotPaused public {
283         paused = true;
284         emit Pause();
285     }
286 
287     /**
288     * @dev called by the owner to unpause, returns to normal state
289     */
290     function unpause() onlyOwner whenPaused public {
291         paused = false;
292         emit Unpause();
293     }
294 }
295 
296 contract PausableToken is StandardToken, Pausable {
297 
298     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
299         return super.transfer(_to, _value);
300     }
301 
302     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
303         return super.transferFrom(_from, _to, _value);
304     }
305 
306     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
307         return super.approve(_spender, _value);
308     }
309 
310     function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
311         return super.increaseApproval(_spender, _addedValue);
312     }
313 
314     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
315         return super.decreaseApproval(_spender, _subtractedValue);
316     }
317 }
318 
319 contract TSToken is PausableToken {
320     string public constant name = "Touch Smart Token"; 
321     string public constant symbol = "TST";
322     uint256 public constant decimals = 18;
323 
324     mapping (address => uint256) freezes;
325 
326     /* This notifies clients about the amount burnt */
327     event Burn(address indexed from, uint256 value);
328 	
329 	/* This notifies clients about the amount frozen */
330     event Freeze(address indexed from, uint256 value);
331 	
332 	/* This notifies clients about the amount unfrozen */
333     event Unfreeze(address indexed from, uint256 value);
334 
335     constructor() public {
336         totalSupply_ = 1000000000 * (10 ** uint256(decimals));
337         balances[msg.sender] = totalSupply_;
338     }
339     
340     function freezeOf(address _owner) public view returns (uint256) {
341         return freezes[_owner];
342     }
343 
344     function burn(uint256 _value) whenNotPaused public returns (bool) {
345         require(_value <= balances[msg.sender]);
346         
347         balances[msg.sender] = balances[msg.sender].sub(_value);
348         totalSupply_ = totalSupply_.sub(_value);
349         emit Burn(msg.sender, _value);
350         return true;
351     }
352 	
353 	function freeze(uint256 _value) whenNotPaused public returns (bool) {
354         require(_value <= balances[msg.sender]);
355         
356         balances[msg.sender] = balances[msg.sender].sub(_value);
357         freezes[msg.sender] = freezes[msg.sender].add(_value);
358         emit Freeze(msg.sender, _value);
359         return true;
360     }
361 	
362 	function unfreeze(uint256 _value) whenNotPaused public returns (bool) {
363         require(_value <= freezes[msg.sender]);
364         
365         freezes[msg.sender] = freezes[msg.sender].sub(_value);
366 		balances[msg.sender] = balances[msg.sender].add(_value);
367         emit Unfreeze(msg.sender, _value);
368         return true;
369     }
370     
371     /**
372     * @dev Allows the current owner to transfer control of the contract to a newOwner.
373     * @param newOwner The address to transfer ownership to.
374     */
375     function transferOwnership(address newOwner) onlyOwner whenNotPaused public {
376         super.transferOwnership(newOwner);
377     }
378 
379     /**
380     * The fallback function.
381     */
382     function() payable external {
383         revert();
384     }
385 }