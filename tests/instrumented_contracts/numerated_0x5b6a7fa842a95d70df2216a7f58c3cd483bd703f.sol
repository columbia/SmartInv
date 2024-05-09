1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipRenounced(address indexed previousOwner);
12     event OwnershipTransferred(
13         address indexed previousOwner,
14         address indexed newOwner
15     );
16 
17     /**
18     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19     * account.
20     */
21     constructor() public {
22         owner = msg.sender;
23     }
24 
25     /**
26     * @dev Throws if called by any account other than the owner.
27     */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     /**
34     * @dev Allows the current owner to transfer control of the contract to a newOwner.
35     * @param newOwner The address to transfer ownership to.
36     */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43     /**
44     * @dev Allows the current owner to relinquish control of the contract.
45     */
46     function renounceOwnership() public onlyOwner {
47         emit OwnershipRenounced(owner);
48         owner = address(0);
49     }
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57 
58     /**
59     * @dev Multiplies two numbers, throws on overflow.
60     */
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a * b;
63         assert(a == 0 || c / a == b);
64         return c;
65     }
66 
67     /**
68     * @dev Integer division of two numbers, truncating the quotient.
69     */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         assert(b > 0);
72         uint256 c = a / b;
73         assert(a == b * c + a % b);
74         return c;
75     }
76 
77     /**
78     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79     */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     /**
86     * @dev Adds two numbers, throws on overflow.
87     */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         assert(c>=a && c>=b);
91         return c;
92     }
93 }
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101     function totalSupply() public view returns (uint256);
102     function balanceOf(address who) public view returns (uint256);
103     function transfer(address to, uint256 value) public returns (bool);
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112     function allowance(address owner, address spender) public view returns (uint256);
113     function transferFrom(address from, address to, uint256 value) public returns (bool);
114     function approve(address spender, uint256 value) public returns (bool);
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 contract BasicToken is ERC20Basic {
119     using SafeMath for uint256;
120 
121     mapping(address => uint256) balances;
122 
123     uint256 totalSupply_;
124 
125     /**
126     * @dev total number of tokens in existence
127     */
128     function totalSupply() public view returns (uint256) {
129         return totalSupply_;
130     }
131 
132     /**
133     * @dev transfer token for a specified address
134     * @param _to The address to transfer to.
135     * @param _value The amount to be transferred.
136     */
137     function transfer(address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[msg.sender]);
140 
141         balances[msg.sender] = balances[msg.sender].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         emit Transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148     * @dev Gets the balance of the specified address.
149     * @param _owner The address to query the the balance of.
150     * @return An uint256 representing the amount owned by the passed address.
151     */
152     function balanceOf(address _owner) public view returns (uint256) {
153         return balances[_owner];
154     }
155 
156 }
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166     mapping (address => mapping (address => uint256)) allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176         require(_to != address(0));
177         require(_value <= balances[_from]);
178         require(_value <= allowed[_from][msg.sender]);
179 
180         balances[_from] = balances[_from].sub(_value);
181         balances[_to] = balances[_to].add(_value);
182         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183         emit Transfer(_from, _to, _value);
184         return true;
185     }
186 
187     /**
188     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189     *
190     * Beware that changing an allowance with this method brings the risk that someone may use both the old
191     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194     * @param _spender The address which will spend the funds.
195     * @param _value The amount of tokens to be spent.
196     */
197     function approve(address _spender, uint256 _value) public returns (bool) {
198         allowed[msg.sender][_spender] = _value;
199         emit Approval(msg.sender, _spender, _value);
200         return true;
201     }
202 
203     /**
204     * @dev Function to check the amount of tokens that an owner allowed to a spender.
205     * @param _owner address The address which owns the funds.
206     * @param _spender address The address which will spend the funds.
207     * @return A uint256 specifying the amount of tokens still available for the spender.
208     */
209     function allowance(address _owner, address _spender) public view returns (uint256) {
210         return allowed[_owner][_spender];
211     }
212 
213     /**
214     * @dev Increase the amount of tokens that an owner allowed to a spender.
215     *
216     * approve should be called when allowed[_spender] == 0. To increment
217     * allowed value is better to use this function to avoid 2 calls (and wait until
218     * the first transaction is mined)
219     * From MonolithDAO Token.sol
220     * @param _spender The address which will spend the funds.
221     * @param _addedValue The amount of tokens to increase the allowance by.
222     */
223     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
224         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229     /**
230     * @dev Decrease the amount of tokens that an owner allowed to a spender.
231     *
232     * approve should be called when allowed[_spender] == 0. To decrement
233     * allowed value is better to use this function to avoid 2 calls (and wait until
234     * the first transaction is mined)
235     * From MonolithDAO Token.sol
236     * @param _spender The address which will spend the funds.
237     * @param _subtractedValue The amount of tokens to decrease the allowance by.
238     */
239     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
240         uint oldValue = allowed[msg.sender][_spender];
241         if (_subtractedValue > oldValue) {
242             allowed[msg.sender][_spender] = 0;
243         } else {
244             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245         }
246         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247         return true;
248     }
249 
250 }
251 
252 contract Pausable is Ownable {
253     event Pause();
254     event Unpause();
255 
256     bool public paused = false;
257 
258 
259     /**
260     * @dev Modifier to make a function callable only when the contract is not paused.
261     */
262     modifier whenNotPaused() {
263         require(!paused);
264         _;
265     }
266 
267     /**
268     * @dev Modifier to make a function callable only when the contract is paused.
269     */
270     modifier whenPaused() {
271         require(paused);
272         _;
273     }
274 
275     /**
276     * @dev called by the owner to pause, triggers stopped state
277     */
278     function pause() onlyOwner whenNotPaused public {
279         paused = true;
280         emit Pause();
281     }
282 
283     /**
284     * @dev called by the owner to unpause, returns to normal state
285     */
286     function unpause() onlyOwner whenPaused public {
287         paused = false;
288         emit Unpause();
289     }
290 }
291 
292 contract PausableToken is StandardToken, Pausable {
293 
294     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
295         return super.transfer(_to, _value);
296     }
297 
298     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
299         return super.transferFrom(_from, _to, _value);
300     }
301 
302     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
303         return super.approve(_spender, _value);
304     }
305 
306     function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
307         return super.increaseApproval(_spender, _addedValue);
308     }
309 
310     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
311         return super.decreaseApproval(_spender, _subtractedValue);
312     }
313 }
314 
315 contract FFToken is PausableToken {
316     string public constant name = "Fifty Five Token"; 
317     string public constant symbol = "FF";
318     uint256 public constant decimals = 18;
319 
320     mapping (address => uint256) freezes;
321 
322     /* This notifies clients about the amount burnt */
323     event Burn(address indexed from, uint256 value);
324 	
325 	/* This notifies clients about the amount frozen */
326     event Freeze(address indexed from, uint256 value);
327 	
328 	/* This notifies clients about the amount unfrozen */
329     event Unfreeze(address indexed from, uint256 value);
330 
331     constructor() public {
332         totalSupply_ = 10000000000 * (10 ** uint256(decimals));
333         balances[msg.sender] = totalSupply_;
334     }
335     
336     function freezeOf(address _owner) public view returns (uint256) {
337         return freezes[_owner];
338     }
339 
340     function burn(uint256 _value) whenNotPaused public returns (bool) {
341         require(_value <= balances[msg.sender]);
342         
343         balances[msg.sender] = balances[msg.sender].sub(_value);
344         totalSupply_ = totalSupply_.sub(_value);
345         emit Burn(msg.sender, _value);
346         return true;
347     }
348 	
349 	function freeze(uint256 _value) whenNotPaused public returns (bool) {
350         require(_value <= balances[msg.sender]);
351         
352         balances[msg.sender] = balances[msg.sender].sub(_value);
353         freezes[msg.sender] = freezes[msg.sender].add(_value);
354         emit Freeze(msg.sender, _value);
355         return true;
356     }
357 	
358 	function unfreeze(uint256 _value) whenNotPaused public returns (bool) {
359         require(_value <= freezes[msg.sender]);
360         
361         freezes[msg.sender] = freezes[msg.sender].sub(_value);
362 		balances[msg.sender] = balances[msg.sender].add(_value);
363         emit Unfreeze(msg.sender, _value);
364         return true;
365     }
366     
367     /**
368     * @dev Allows the current owner to transfer control of the contract to a newOwner.
369     * @param newOwner The address to transfer ownership to.
370     */
371     function transferOwnership(address newOwner) onlyOwner whenNotPaused public {
372         super.transferOwnership(newOwner);
373     }
374 
375     /**
376     * The fallback function.
377     */
378     function() payable external {
379         revert();
380     }
381 }