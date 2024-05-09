1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint a, uint b) internal pure returns (uint) {
17         if (a == 0) {
18             return 0;
19         }
20         uint c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint a, uint b) internal pure returns (uint) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint a, uint b) internal pure returns (uint) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint a, uint b) internal pure returns (uint) {
47         uint c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   uint256 public totalSupply;
61   function balanceOf(address who) public constant returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     emit Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) public constant returns (uint256);
105   function transferFrom(address from, address to, uint256 value) public returns (bool);
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 /**
111  * @title Ownable
112  * @dev The Ownable contract has an owner address, and provides basic authorization control
113  * functions, this simplifies the implementation of "user permissions".
114  */
115 contract Ownable {
116   address public owner;
117 
118 
119   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121 
122   /**
123    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
124    * account.
125    */
126   constructor() public {
127     owner = msg.sender;
128   }
129 
130 
131   /**
132    * @dev Throws if called by any account other than the owner.
133    */
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138 
139 
140   /**
141    * @dev Allows the current owner to transfer control of the contract to a newOwner.
142    * @param newOwner The address to transfer ownership to.
143    */
144   function transferOwnership(address newOwner) onlyOwner public {
145     require(newOwner != address(0));
146     emit OwnershipTransferred(owner, newOwner);
147     owner = newOwner;
148   }
149 
150 }
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * @dev https://github.com/ethereum/EIPs/issues/20
157  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is ERC20, BasicToken {
160 
161   mapping (address => mapping (address => uint256)) allowed;
162 
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172 
173     uint256 _allowance = allowed[_from][msg.sender];
174 
175     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
176     // require (_value <= _allowance);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = _allowance.sub(_value);
181     emit Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    *
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     emit Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    */
217   function increaseApproval (address _spender, uint _addedValue) public
218     returns (bool success) {
219     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224   function decreaseApproval (address _spender, uint _subtractedValue) public
225     returns (bool success) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236 }
237 
238 
239 contract Rockwood is StandardToken, Ownable{
240     
241     string public name = "Rockwood";
242     string public symbol = "RWD";
243     uint8 public  decimals = 18;
244 
245     mapping(address=>uint256)  lockedBalance;
246     mapping(address=>uint)     timeRelease;
247     
248     uint256 internal constant INITIAL_SUPPLY = 300 * (10**8) * (10**18);
249     
250     //address public developer;
251     //uint256 internal crowdsaleAvaible;
252 
253 
254     event Burn(address indexed burner, uint256 value);
255     event Lock(address indexed locker, uint256 value, uint releaseTime);
256     event UnLock(address indexed unlocker, uint256 value);
257     
258 
259     // constructor
260     constructor() public { 
261         address onwer = msg.sender;
262         balances[onwer] = INITIAL_SUPPLY;
263         totalSupply = INITIAL_SUPPLY;
264     }
265     function() payable public {
266         owner.transfer(msg.value);
267     }
268     function ownerSetName(string newName) public onlyOwner{
269         name = newName;
270     }
271     function ownerSetSymbol(string newSymbol) public onlyOwner{
272         symbol = newSymbol;
273     }
274     function ownerSetDecimals(uint8 newDecimals) public onlyOwner{
275         decimals = newDecimals;
276     }
277     function ownerSetTotalSupply(uint newTotalSupply) public onlyOwner{
278         balances[msg.sender] = balances[msg.sender].add(newTotalSupply).sub(totalSupply);
279         totalSupply = newTotalSupply;
280     } 
281    function ownerUnlock(address tokenHolder) public onlyOwner returns (bool success){
282         uint256 amount = lockedBalance[tokenHolder];
283         require(amount > 0);
284 
285         balances[tokenHolder] = balances[tokenHolder].add(amount);
286         lockedBalance[tokenHolder] = 0;
287         timeRelease[tokenHolder] = 0;
288 
289         emit Transfer(0x0, tokenHolder, amount);
290         emit UnLock(tokenHolder, amount);
291 
292         return true;
293 
294     }
295     function ownerKill(bool isKill) public onlyOwner{
296         require(isKill);
297         selfdestruct(owner);
298     }    
299     //balance of locked
300     function lockedOf(address _owner) public constant returns (uint256 balance) {
301         return lockedBalance[_owner];
302     }
303 
304     //release time of locked
305     function unlockTimeOf(address _owner) public constant returns (uint timelimit) {
306         return timeRelease[_owner];
307     }
308 
309 
310     // transfer to and lock it
311     function transferAndLock(address _to, uint256 _value, uint _releaseTime) public returns (bool success) {
312         require(_to != 0x0);
313         require(_value <= balances[msg.sender]);
314         require(_value > 0);
315         require(_releaseTime > now && _releaseTime <= now + 60*60*24*365*5);
316 
317         // SafeMath.sub will throw if there is not enough balance.
318         balances[msg.sender] = balances[msg.sender].sub(_value);
319        
320         //if preLock can release 
321         uint preRelease = timeRelease[_to];
322         if (preRelease <= now && preRelease != 0x0) {
323             balances[_to] = balances[_to].add(lockedBalance[_to]);
324             lockedBalance[_to] = 0;
325         }
326 
327         lockedBalance[_to] = lockedBalance[_to].add(_value);
328         timeRelease[_to] =  _releaseTime >= timeRelease[_to] ? _releaseTime : timeRelease[_to]; 
329         emit Transfer(msg.sender, _to, _value);
330         emit Lock(_to, _value, _releaseTime);
331         return true;
332     }
333 
334     function transferFromAndLock(address _from, address _to, uint256 _value, uint _releaseTime) public returns (bool success) {
335         require(_to != 0x0);
336         require(_value <= balances[_from]);
337         require(_value > 0);
338         require(_releaseTime > now && _releaseTime <= now + 60*60*24*365*5);
339 
340         // SafeMath.sub will throw if there is not enough balance.
341         balances[_from] = balances[_from].sub(_value);
342        
343         //if preLock can release 
344         uint preRelease = timeRelease[_to];
345         if (preRelease <= now && preRelease != 0x0) {
346             balances[_to] = balances[_to].add(lockedBalance[_to]);
347             lockedBalance[_to] = 0;
348         }
349 
350         lockedBalance[_to] = lockedBalance[_to].add(_value);
351         timeRelease[_to] =  _releaseTime >= timeRelease[_to] ? _releaseTime : timeRelease[_to]; 
352         emit Transfer(_from, _to, _value);
353         emit Lock(_to, _value, _releaseTime);
354         return true;
355     }
356 
357 
358    /**
359    * @notice Transfers tokens held by lock.
360    */
361    function unlock() public returns (bool success){
362         uint256 amount = lockedBalance[msg.sender];
363         require(amount > 0);
364         require(now >= timeRelease[msg.sender]);
365 
366         balances[msg.sender] = balances[msg.sender].add(amount);
367         lockedBalance[msg.sender] = 0;
368         timeRelease[msg.sender] = 0;
369 
370         emit Transfer(0x0, msg.sender, amount);
371         emit UnLock(msg.sender, amount);
372 
373         return true;
374 
375     }
376 
377 
378     /**
379      * @dev Burns a specific amount of tokens.
380      * @param _value The amount of token to be burned.
381      */
382     function burn(uint256 _value) public returns (bool success) {
383         require(_value > 0);
384         require(_value <= balances[msg.sender]);
385     
386         address burner = msg.sender;
387         balances[burner] = balances[burner].sub(_value);
388         totalSupply = totalSupply.sub(_value);
389         emit Burn(burner, _value);
390         return true;
391     }
392 
393 
394 
395 }