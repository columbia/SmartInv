1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title Ownable
29  * @dev Owner validator
30  */
31 contract Ownable {
32     address public owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     /**
37     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38     * account.
39     */
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     /**
45     * @dev Throws if called by any account other than the owner.
46     */
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     /**
53     * @dev Allows the current owner to transfer control of the contract to a newOwner.
54     * @param newOwner The address to transfer ownership to.
55     */
56     function transferOwnership(address newOwner) public onlyOwner {
57         require(newOwner != address(0));
58         
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 }
63 
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     if (a == 0) {
76       return 0;
77     }
78     c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   /**
84   * @dev Integer division of two numbers, truncating the quotient.
85   */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     // uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return a / b;
91   }
92 
93   /**
94   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95   */
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   /**
102   * @dev Adds two numbers, throws on overflow.
103   */
104   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
105     c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 
112 /**
113  * @title BasicToken
114  * @dev Implementation of ERC20Basic
115  */
116 contract BasicToken is ERC20Basic {
117     using SafeMath for uint256;
118 
119     mapping(address => uint256) balances;
120 
121     uint256 totalSupply_;
122 
123     /**
124     * @dev total number of tokens in exsitence
125     */
126     function totalSupply() public view returns (uint256) {
127         return totalSupply_;
128     }
129 
130     function msgSender() 
131         public
132         view
133         returns (address)
134     {
135         return msg.sender;
136     }
137 
138     function transfer(
139         address _to, 
140         uint256 _value
141     ) 
142         public 
143         returns (bool) 
144     {
145         require(_to != address(0));
146         require(_to != msg.sender);
147         require(_value <= balances[msg.sender]);
148         
149         _preValidateTransfer(msg.sender, _to, _value);
150 
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         emit Transfer(msg.sender, _to, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Gets the balance of the specified address.
159      * @return An uint256 representing the amount owned by the passed address.
160      */
161     function balanceOf(address _owner) public view returns (uint256) {
162         return balances[_owner];
163     }
164 
165     function _preValidateTransfer(
166         address _from, 
167         address _to, 
168         uint256 _value
169     ) 
170         internal 
171     {
172 
173     }
174 }
175 
176 /**
177  * @title StandardToken
178  * @dev Base Of token
179  */
180 contract StandardToken is ERC20, BasicToken, Ownable {
181 
182     mapping (address => mapping (address => uint256)) internal allowed;
183 
184     /**
185     * @dev Transfer tokens from one address to another
186     * @param _from address The address which you want to send tokens from
187     * @param _to address the address which you want to transfer to
188     * @param _value uint256 the amount of tokens to be transferred
189     */
190     function transferFrom(
191         address _from, 
192         address _to, 
193         uint256 _value
194     ) 
195         public 
196         returns (bool) 
197     {
198         require(_to != address(0));
199         require(_value <= balances[_from]);
200         require(_value <= allowed[_from][msg.sender]);
201 
202         _preValidateTransfer(_from, _to, _value);
203 
204         balances[_from] = balances[_from].sub(_value);
205         balances[_to] = balances[_to].sub(_value);  
206         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207         emit Transfer(_from, _to, _value);
208         return true; 
209     } 
210 
211     /**
212     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
213 .   * @param _spender The address which will spend the funds.
214     */
215     function approve(address _spender, uint256 _value) public returns (bool) {
216         allowed[msg.sender][_spender] = _value;
217         emit Approval(msg.sender, _spender, _value);
218         return true;
219     }
220 
221     /**
222      * @dev Function to check the amount of tokens that an owner allowed jto a spender. 
223      */
224     function allowance(address _owner, address _spender) public view returns (uint256) {
225         return allowed[_owner][_spender];
226     }
227 
228 /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
239         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
240         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241         return true;
242     }
243 
244 
245     function decreseApproval(address _spender, uint _subtractedValue) public returns (bool) {
246         uint oldValue = allowed[msg.sender][_spender];
247         if (_subtractedValue > oldValue) {
248             allowed[msg.sender][_spender] = 0;
249         } else {
250             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251         }
252 
253         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254         return true;
255     }
256 
257 }
258 
259 /**
260  * @title MintableToken
261  * @dev Minting of total balance 
262  */
263 contract MintableToken is StandardToken {
264     event Mint(address indexed to, uint256 amount);
265     event MintFinished();
266 
267     bool public mintingFinished = false;
268 
269     modifier canMint() {
270         require(!mintingFinished);
271         _;
272     }
273    
274     /**
275     * @dev Function to mint tokens
276     * @param _to The address that will receive the minted tokens.
277     * @param _amount The amount of tokens to mint
278     * @return A boolean that indicated if the operation was successful.
279     */
280     function mint(address _to, uint256 _amount) onlyOwner   canMint public returns (bool) {
281         totalSupply_ = totalSupply_.add(_amount);
282         balances[_to] = balances[_to].add(_amount);
283         emit Mint(_to, _amount);
284         emit Transfer(address(0), _to, _amount);
285         return true;
286     }
287 
288     /**
289      * @dev Function to stop minting new tokens.
290      * @return True if the operation was successful. 
291      */
292     function finishMinting() onlyOwner canMint public returns (bool) {
293         mintingFinished = true;
294         emit MintFinished();
295         return true;
296     }
297 }
298 
299 
300 /**
301  * @title LockableToken
302  * @dev locking of granted balance
303  */
304 contract LockableToken is MintableToken {
305 
306     using SafeMath for uint256;
307 
308     /**
309      * @dev Lock defines a lock of token
310      */
311     struct Lock {
312         uint256 amount;
313         uint256 expiresAt;
314     }
315 
316     // granted to locks;
317     mapping (address => Lock[]) public grantedLocks;
318 
319     function addLock(
320         address _granted, 
321         uint256 _amount, 
322         uint256 _expiresAt
323     ) 
324         public 
325         onlyOwner 
326     {
327         require(_amount > 0);
328         require(_expiresAt > now);
329 
330         grantedLocks[_granted].push(Lock(_amount, _expiresAt));
331     }
332 
333     function deleteLock(
334         address _granted, 
335         uint8 _index
336     ) 
337         public 
338         onlyOwner 
339     {
340         Lock storage lock = grantedLocks[_granted][_index];
341 
342         delete grantedLocks[_granted][_index];
343         for (uint i = _index; i < grantedLocks[_granted].length - 1; i++) {
344             grantedLocks[_granted][i] = grantedLocks[_granted][i+1];
345         }
346         grantedLocks[_granted].length--;
347 
348         if (grantedLocks[_granted].length == 0)
349             delete grantedLocks[_granted];
350     }
351 
352     function transferWithLock(
353         address _to, 
354         uint256 _value,
355         uint256[] _expiresAtList
356     ) 
357         public 
358         onlyOwner
359         returns (bool) 
360     {
361         require(_to != address(0));
362         require(_to != msg.sender);
363         require(_value <= balances[msg.sender]);
364 
365         uint256 count = _expiresAtList.length;
366         if (count > 0) {
367             uint256 devidedValue = _value.div(count);
368             for (uint i = 0; i < count; i++) {
369                 addLock(_to, devidedValue, _expiresAtList[i]);  
370             }
371         }
372 
373         return transfer(_to, _value);
374     }
375 
376     /**
377         @param _from - _granted
378         @param _to - no usable
379         @param _value - amount of transfer
380      */
381     function _preValidateTransfer(
382         address _from, 
383         address _to, 
384         uint256 _value
385     ) 
386         internal
387     {
388         super._preValidateTransfer(_from, _to, _value);
389         
390         uint256 lockedAmount = getLockedAmount(_from);
391         uint256 balanceAmount = balanceOf(_from);
392 
393         require(balanceAmount.sub(lockedAmount) >= _value);
394     }
395 
396 
397     function getLockedAmount(
398         address _granted
399     ) 
400         public
401         view
402         returns(uint256)
403     {
404 
405         uint256 lockedAmount = 0;
406 
407         Lock[] storage locks = grantedLocks[_granted];
408         for (uint i = 0; i < locks.length; i++) {
409             if (now < locks[i].expiresAt) {
410                 lockedAmount = lockedAmount.add(locks[i].amount);
411             }
412         }
413         //uint256 balanceAmount = balanceOf(_granted);
414         //return balanceAmount.sub(lockedAmount);
415 
416         return lockedAmount;
417     }
418     
419 }
420 
421 
422 contract BPXToken is LockableToken {
423 
424   string public constant name = "Bitcoin Pay";
425   string public constant symbol = "BPX";
426   uint32 public constant decimals = 18;
427 
428   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
429 
430   /**
431   * @dev Constructor that gives msg.sender all of existing tokens.
432   */
433   constructor() public {
434     totalSupply_ = INITIAL_SUPPLY;
435     balances[msg.sender] = INITIAL_SUPPLY;
436     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
437   }
438 }