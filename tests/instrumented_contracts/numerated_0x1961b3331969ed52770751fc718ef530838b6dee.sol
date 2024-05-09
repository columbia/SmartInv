1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42     uint256 public totalSupply;
43     function balanceOf(address who) public view returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public view returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64     using SafeMath for uint256;
65 
66     mapping(address => uint256) balances;
67 
68     /**
69     * @dev transfer token for a specified address
70     * @param _to The address to transfer to.
71     * @param _value The amount to be transferred.
72     */
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         require(_to != address(0));
75         require(_value <= balances[msg.sender]);
76 
77         // SafeMath.sub will throw if there is not enough balance.
78         balances[msg.sender] = balances[msg.sender].sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     /**
85     * @dev Gets the balance of the specified address.
86     * @param _owner The address to query the the balance of.
87     * @return An uint256 representing the amount owned by the passed address.
88     */
89     function balanceOf(address _owner) public view returns (uint256 balance) {
90         return balances[_owner];
91     }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104     mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107     /**
108      * @dev Transfer tokens from one address to another
109      * @param _from address The address which you want to send tokens from
110      * @param _to address The address which you want to transfer to
111      * @param _value uint256 the amount of tokens to be transferred
112      */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[_from]);
116         require(_value <= allowed[_from][msg.sender]);
117 
118         balances[_from] = balances[_from].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121         Transfer(_from, _to, _value);
122         return true;
123     }
124 
125     /**
126      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127      *
128      * Beware that changing an allowance with this method brings the risk that someone may use both the old
129      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      * @param _spender The address which will spend the funds.
133      * @param _value The amount of tokens to be spent.
134      */
135     function approve(address _spender, uint256 _value) public returns (bool) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     /**
142      * @dev Function to check the amount of tokens that an owner allowed to a spender.
143      * @param _owner address The address which owns the funds.
144      * @param _spender address The address which will spend the funds.
145      * @return A uint256 specifying the amount of tokens still available for the spender.
146      */
147     function allowance(address _owner, address _spender) public view returns (uint256) {
148         return allowed[_owner][_spender];
149     }
150 
151     /**
152      * approve should be called when allowed[_spender] == 0. To increment
153      * allowed value is better to use this function to avoid 2 calls (and wait until
154      * the first transaction is mined)
155      * From MonolithDAO Token.sol
156      */
157     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 
163     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164         uint oldValue = allowed[msg.sender][_spender];
165         if (_subtractedValue > oldValue) {
166             allowed[msg.sender][_spender] = 0;
167         } else {
168             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169         }
170         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 
174 }
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182     address public owner;
183 
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187 
188     /**
189      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190      * account.
191      */
192     function Ownable() public {
193         owner = msg.sender;
194     }
195 
196 
197     /**
198      * @dev Throws if called by any account other than the owner.
199      */
200     modifier onlyOwner() {
201         require(msg.sender == owner);
202         _;
203     }
204 
205 
206     /**
207      * @dev Allows the current owner to transfer control of the contract to a newOwner.
208      * @param newOwner The address to transfer ownership to.
209      */
210     function transferOwnership(address newOwner) public onlyOwner {
211         require(newOwner != address(0));
212         OwnershipTransferred(owner, newOwner);
213         owner = newOwner;
214     }
215 
216 }
217 
218 /**
219  * @title Pausable
220  * @dev Base contract which allows children to implement an emergency stop mechanism.
221  */
222 contract Pausable is Ownable {
223     event Pause();
224     event Unpause();
225 
226     bool public paused = false;
227 
228 
229     /**
230      * @dev Modifier to make a function callable only when the contract is not paused.
231      */
232     modifier whenNotPaused() {
233         require(!paused);
234         _;
235     }
236 
237     /**
238      * @dev Modifier to make a function callable only when the contract is paused.
239      */
240     modifier whenPaused() {
241         require(paused);
242         _;
243     }
244 
245     /**
246      * @dev called by the owner to pause, triggers stopped state
247      */
248     function pause() onlyOwner whenNotPaused public {
249         paused = true;
250         Pause();
251     }
252 
253     /**
254      * @dev called by the owner to unpause, returns to normal state
255      */
256     function unpause() onlyOwner whenPaused public {
257         paused = false;
258         Unpause();
259     }
260 }
261 
262 /**
263  * @title Pausable token
264  *
265  * @dev StandardToken modified with pausable transfers.
266  **/
267 contract PausableToken is StandardToken, Pausable {
268 
269     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
270         return super.transfer(_to, _value);
271     }
272 
273     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
274         return super.transferFrom(_from, _to, _value);
275     }
276 
277     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
278         return super.approve(_spender, _value);
279     }
280 
281     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
282         return super.increaseApproval(_spender, _addedValue);
283     }
284 
285     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
286         return super.decreaseApproval(_spender, _subtractedValue);
287     }
288 }
289 
290 
291 contract BitDegreeToken is PausableToken {
292     string public constant name = "BitDegree Token";
293     string public constant symbol = "BDG";
294     uint8 public constant decimals = 18;
295 
296     uint256 private constant TOKEN_UNIT = 10 ** uint256(decimals);
297 
298     uint256 public constant totalSupply = 660000000 * TOKEN_UNIT;
299     uint256 public constant publicAmount = 336600000 * TOKEN_UNIT; // Tokens for public
300 
301     uint public startTime;
302     address public crowdsaleAddress;
303 
304     struct TokenLock { uint256 amount; uint duration; bool withdrawn; }
305 
306     TokenLock public foundationLock = TokenLock({
307         amount: 66000000 * TOKEN_UNIT,
308         duration: 360 days,
309         withdrawn: false
310     });
311 
312     TokenLock public teamLock = TokenLock({
313         amount: 66000000 * TOKEN_UNIT,
314         duration: 720 days,
315         withdrawn: false
316     });
317 
318     TokenLock public advisorLock = TokenLock({
319         amount: 13200000 * TOKEN_UNIT,
320         duration: 160 days,
321         withdrawn: false
322     });
323 
324     function BitDegreeToken() public {
325         startTime = now + 70 days;
326 
327         balances[owner] = totalSupply;
328         Transfer(address(0), owner, balances[owner]);
329 
330         lockTokens(foundationLock);
331         lockTokens(teamLock);
332         lockTokens(advisorLock);
333     }
334 
335     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
336         crowdsaleAddress = _crowdsaleAddress;
337         assert(approve(crowdsaleAddress, publicAmount));
338     }
339 
340     function withdrawLocked() external onlyOwner {
341         if(unlockTokens(foundationLock)) foundationLock.withdrawn = true;
342         if(unlockTokens(teamLock)) teamLock.withdrawn = true;
343         if(unlockTokens(advisorLock)) advisorLock.withdrawn = true;
344     }
345 
346     function lockTokens(TokenLock lock) internal {
347         balances[owner] = balances[owner].sub(lock.amount);
348         balances[address(0)] = balances[address(0)].add(lock.amount);
349         Transfer(owner, address(0), lock.amount);
350     }
351 
352     function unlockTokens(TokenLock lock) internal returns (bool) {
353         uint lockReleaseTime = startTime + lock.duration;
354 
355         if(lockReleaseTime < now && lock.withdrawn == false) {
356             balances[owner] = balances[owner].add(lock.amount);
357             balances[address(0)] = balances[address(0)].sub(lock.amount);
358             Transfer(address(0), owner, lock.amount);
359             return true;
360         }
361 
362         return false;
363     }
364 
365     function setStartTime(uint _startTime) external {
366         require(msg.sender == crowdsaleAddress);
367         if(_startTime < startTime) {
368             startTime = _startTime;
369         }
370     }
371 
372     function transfer(address _to, uint _value) public returns (bool) {
373         // Only possible after ICO ends
374         require(now >= startTime);
375 
376         return super.transfer(_to, _value);
377     }
378 
379     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
380         // Only owner's tokens can be transferred before ICO ends
381         if (now < startTime)
382             require(_from == owner);
383 
384         return super.transferFrom(_from, _to, _value);
385     }
386 
387     function transferOwnership(address newOwner) public onlyOwner {
388         require(now >= startTime);
389         super.transferOwnership(newOwner);
390     }
391 }