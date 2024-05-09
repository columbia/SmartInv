1 pragma solidity ^0.4.24;
2 
3 ///////////////////////////////////////////////////////////////////////////////////////////////////
4 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
5 //
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * See https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13     function totalSupply() public view returns (uint256);
14     function balanceOf(address who) public view returns (uint256);
15     function transfer(address to, uint256 value) public returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 ///////////////////////////////////////////////////////////////////////////////////////////////////
20 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
21 //
22 
23 /**
24  * @title ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/20
26  */
27 contract ERC20 is ERC20Basic {
28     function allowance(address owner, address spender) public view returns (uint256);
29     function transferFrom(address from, address to, uint256 value) public returns (bool);
30     function approve(address spender, uint256 value) public returns (bool);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 ///////////////////////////////////////////////////////////////////////////////////////////////////
35 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
36 //
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44     /**
45     * @dev Multiplies two numbers, throws on overflow.
46     */
47     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51         if (a == 0) {
52             return 0;
53         }
54 
55         c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two numbers, truncating the quotient.
62     */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // assert(b > 0); // Solidity automatically throws when dividing by 0
65         // uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67         return a / b;
68     }
69 
70     /**
71     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         assert(b <= a);
75         return a - b;
76     }
77 
78     /**
79     * @dev Adds two numbers, throws on overflow.
80     */
81     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
82         c = a + b;
83         assert(c >= a);
84         return c;
85     }
86 }
87 
88 ///////////////////////////////////////////////////////////////////////////////////////////////////
89 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
90 //
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97 
98     using SafeMath for uint256;
99 
100     mapping(address => uint256) balances;
101 
102     uint256 totalSupply_;
103 
104     /**
105     * @dev Total number of tokens in existence
106     */
107     function totalSupply() public view returns (uint256) {
108         return totalSupply_;
109     }
110 
111     /**
112     * @dev Transfer token for a specified address
113     * @param _to The address to transfer to.
114     * @param _value The amount to be transferred.
115     */
116     function transfer(address _to, uint256 _value) public returns (bool) {
117         require(_to != address(0));
118         require(_value <= balances[msg.sender]);
119 
120         balances[msg.sender] = balances[msg.sender].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         emit Transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127     * @dev Gets the balance of the specified address.
128     * @param _owner The address to query the the balance of.
129     * @return An uint256 representing the amount owned by the passed address.
130     */
131     function balanceOf(address _owner) public view returns (uint256) {
132         return balances[_owner];
133     }
134 }
135 
136 ///////////////////////////////////////////////////////////////////////////////////////////////////
137 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
138 //
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * https://github.com/ethereum/EIPs/issues/20
145  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149     mapping (address => mapping (address => uint256)) internal allowed;
150 
151     /**
152     * @dev Transfer tokens from one address to another
153     * @param _from address The address which you want to send tokens from
154     * @param _to address The address which you want to transfer to
155     * @param _value uint256 the amount of tokens to be transferred
156     */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         require(_to != address(0));
159         require(_value <= balances[_from]);
160         require(_value <= allowed[_from][msg.sender]);
161 
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165         emit Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     /**
170     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171     * Beware that changing an allowance with this method brings the risk that someone may use both the old
172     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175     * @param _spender The address which will spend the funds.
176     * @param _value The amount of tokens to be spent.
177     */
178     function approve(address _spender, uint256 _value) public returns (bool) {
179         allowed[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     /**
185     * @dev Function to check the amount of tokens that an owner allowed to a spender.
186     * @param _owner address The address which owns the funds.
187     * @param _spender address The address which will spend the funds.
188     * @return A uint256 specifying the amount of tokens still available for the spender.
189     */
190     function allowance(address _owner, address _spender) public view returns (uint256) {
191         return allowed[_owner][_spender];
192     }
193 
194     /**
195     * @dev Increase the amount of tokens that an owner allowed to a spender.
196     * approve should be called when allowed[_spender] == 0. To increment
197     * allowed value is better to use this function to avoid 2 calls (and wait until
198     * the first transaction is mined)
199     * From MonolithDAO Token.sol
200     * @param _spender The address which will spend the funds.
201     * @param _addedValue The amount of tokens to increase the allowance by.
202     */
203     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
204         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
205         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206         return true;
207     }
208 
209     /**
210     * @dev Decrease the amount of tokens that an owner allowed to a spender.
211     * approve should be called when allowed[_spender] == 0. To decrement
212     * allowed value is better to use this function to avoid 2 calls (and wait until
213     * the first transaction is mined)
214     * From MonolithDAO Token.sol
215     * @param _spender The address which will spend the funds.
216     * @param _subtractedValue The amount of tokens to decrease the allowance by.
217     */
218     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
219         uint256 oldValue = allowed[msg.sender][_spender];
220         if (_subtractedValue > oldValue) {
221             allowed[msg.sender][_spender] = 0;
222         } else {
223             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224         }
225         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 }
229 
230 ///////////////////////////////////////////////////////////////////////////////////////////////////
231 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
232 //
233 
234 /**
235  * @title Ownable
236  * @dev The Ownable contract has an owner address, and provides basic authorization control
237  * functions, this simplifies the implementation of "user permissions".
238  */
239 contract Ownable {
240 
241     address public owner;
242 
243     event OwnershipRenounced(address indexed previousOwner);
244 
245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
246 
247     /**
248     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
249     * account.
250     */
251     constructor() public {
252         owner = msg.sender;
253     }
254 
255     /**
256     * @dev Throws if called by any account other than the owner.
257     */
258     modifier onlyOwner() {
259         require(msg.sender == owner);
260         _;
261     }
262 
263     /**
264     * @dev Allows the current owner to relinquish control of the contract.
265     * @notice Renouncing to ownership will leave the contract without an owner.
266     * It will not be possible to call the functions with the `onlyOwner`
267     * modifier anymore.
268     */
269     function renounceOwnership() public onlyOwner {
270         emit OwnershipRenounced(owner);
271         owner = address(0);
272     }
273 
274     /**
275     * @dev Allows the current owner to transfer control of the contract to a newOwner.
276     * @param _newOwner The address to transfer ownership to.
277     */
278     function transferOwnership(address _newOwner) public onlyOwner {
279         _transferOwnership(_newOwner);
280     }
281 
282     /**
283     * @dev Transfers control of the contract to a newOwner.
284     * @param _newOwner The address to transfer ownership to.
285     */
286     function _transferOwnership(address _newOwner) internal {
287         require(_newOwner != address(0));
288         emit OwnershipTransferred(owner, _newOwner);
289         owner = _newOwner;
290     }
291 }
292 
293 ///////////////////////////////////////////////////////////////////////////////////////////////////
294 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
295 //
296 
297 /**
298  * @title Pausable
299  * @dev Base contract which allows children to implement an emergency stop mechanism.
300  */
301 contract Pausable is Ownable {
302 
303     event Pause();
304 
305     event Unpause();
306 
307     bool public paused = false;
308 
309     /**
310     * @dev Modifier to make a function callable only when the contract is not paused.
311     */
312     modifier whenNotPaused() {
313         require(!paused);
314         _;
315     }
316 
317     /**
318     * @dev Modifier to make a function callable only when the contract is paused.
319     */
320     modifier whenPaused() {
321         require(paused);
322         _;
323     }
324 
325     /**
326     * @dev called by the owner to pause, triggers stopped state
327     */
328     function pause() onlyOwner whenNotPaused public {
329         paused = true;
330         emit Pause();
331     }
332 
333     /**
334     * @dev called by the owner to unpause, returns to normal state
335     */
336     function unpause() onlyOwner whenPaused public {
337         paused = false;
338         emit Unpause();
339     }
340 }
341 
342 ///////////////////////////////////////////////////////////////////////////////////////////////////
343 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/PausableToken.sol
344 //
345 
346 /**
347  * @title Pausable token
348  * @dev StandardToken modified with pausable transfers.
349  **/
350 contract PausableToken is StandardToken, Pausable {
351 
352     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
353         return super.transfer(_to, _value);
354     }
355 
356     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
357         return super.transferFrom(_from, _to, _value);
358     }
359 
360     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
361         return super.approve(_spender, _value);
362     }
363 
364     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
365         return super.increaseApproval(_spender, _addedValue);
366     }
367 
368     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
369         return super.decreaseApproval(_spender, _subtractedValue);
370     }
371 }
372 
373 ///////////////////////////////////////////////////////////////////////////////////////////////////
374 
375 contract ClockworkToken is PausableToken {
376     string public name = "clockworkPi";
377     string public symbol = "CPI";
378     uint public decimals = 18;
379     uint public initialSupply = 31415926;
380 
381     constructor() public {
382         totalSupply_ = initialSupply * (10 ** decimals);
383         balances[msg.sender] = totalSupply_;
384         emit Transfer(address(0), msg.sender, totalSupply_);
385     }
386 }