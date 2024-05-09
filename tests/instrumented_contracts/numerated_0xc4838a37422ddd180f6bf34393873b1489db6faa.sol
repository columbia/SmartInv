1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Eliptic curve signature operations
5  *
6  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
7  *
8  * TODO Remove this library once solidity supports passing a signature to ecrecover.
9  * See https://github.com/ethereum/solidity/issues/864
10  *
11  */
12 
13 library ECRecoveryLibrary {
14 
15     /**
16      * @dev Recover signer address from a message by using their signature
17      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
18      * @param sig bytes signature, the signature is generated using web3.eth.sign()
19      */
20     function recover(bytes32 hash, bytes sig) internal pure returns (address) {
21         bytes32 r;
22         bytes32 s;
23         uint8 v;
24 
25         // Check the signature length
26         if (sig.length != 65) {
27             return (address(0));
28         }
29 
30         // Divide the signature in r, s and v variables
31         // ecrecover takes the signature parameters, and the only way to get them
32         // currently is to use assembly.
33         // solium-disable-next-line security/no-inline-assembly
34         assembly {
35             r := mload(add(sig, 32))
36             s := mload(add(sig, 64))
37             v := byte(0, mload(add(sig, 96)))
38         }
39 
40         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
41         if (v < 27) {
42             v += 27;
43         }
44 
45         // If the version is correct return the signer address
46         if (v != 27 && v != 28) {
47             return (address(0));
48         } else {
49             // solium-disable-next-line arg-overflow
50             return ecrecover(hash, v, r, s);
51         }
52     }
53 
54     /**
55      * toEthSignedMessageHash
56      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
57      * @dev and hash the result
58      */
59     function toEthSignedMessageHash(bytes32 hash)
60     internal
61     pure
62     returns (bytes32)
63     {
64         // 32 is the length in bytes of hash,
65         // enforced by the type signature above
66         return keccak256(
67             "\x19Ethereum Signed Message:\n32",
68             hash
69         );
70     }
71 }
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMathLibrary {
78 
79     function max(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a >= b ? a : b;
81     }
82 
83     function min(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a < b ? a : b;
85     }
86 
87     /**
88     * @dev Multiplies two numbers, throws on overflow.
89     */
90     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
91         if (a == 0) {
92             return 0;
93         }
94         c = a * b;
95         assert(c / a == b);
96         return c;
97     }
98 
99     /**
100     * @dev Integer division of two numbers, truncating the quotient.
101     */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         // assert(b > 0); // Solidity automatically throws when dividing by 0
104         // uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106         return a / b;
107     }
108 
109     /**
110     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111     */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         assert(b <= a);
114         return a - b;
115     }
116 
117     /**
118     * @dev Adds two numbers, throws on overflow.
119     */
120     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
121         c = a + b;
122         assert(c >= a);
123         return c;
124     }
125 }
126 
127 /**
128  * @title Ownable
129  * @dev The Ownable contract has an owner address, and provides basic authorization control
130  * functions, this simplifies the implementation of "user permissions".
131  */
132 contract Ownable {
133     address public owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     /**
138      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
139      * account.
140      */
141     constructor() public {
142         owner = msg.sender;
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(msg.sender == owner);
150         _;
151     }
152 
153     /**
154      * @dev Allows the current owner to transfer control of the contract to a newOwner.
155      * @param _newOwner The address to transfer ownership to.
156      */
157     function transferOwnership(address _newOwner) onlyOwner public {
158         require(_newOwner != address(0));
159         emit OwnershipTransferred(owner, _newOwner);
160         owner = _newOwner;
161     }
162 }
163 
164 /**
165  * @title Pausable
166  * @dev Base contract which allows children to implement an emergency stop mechanism.
167  */
168 contract Pausable is Ownable {
169     bool public paused = false;
170 
171     event Pause();
172 
173     event Unpause();
174 
175     /**
176      * @dev Modifier to make a function callable only when the contract is not paused.
177      */
178     modifier whenNotPaused() {
179         require(!paused);
180         _;
181     }
182 
183     /**
184      * @dev Modifier to make a function callable only when the contract is paused.
185      */
186     modifier whenPaused() {
187         require(paused);
188         _;
189     }
190 
191     /**
192      * @dev called by the owner to pause, triggers stopped state
193      */
194     function pause() onlyOwner whenNotPaused public {
195         paused = true;
196         emit Pause();
197     }
198 
199     /**
200      * @dev called by the owner to unpause, returns to normal state
201      */
202     function unpause() onlyOwner whenPaused public {
203         paused = false;
204         emit Unpause();
205     }
206 }
207 
208 interface TokenReceiver {
209     function tokenFallback(address _from, uint _value) external returns(bool);
210 }
211 
212 contract Token is Pausable {
213     using SafeMathLibrary for uint;
214 
215     using ECRecoveryLibrary for bytes32;
216 
217     uint public decimals = 18;
218 
219     mapping (address => uint) balances;
220 
221     mapping (address => mapping (address => uint)) allowed;
222 
223     mapping(bytes => bool) signatures;
224 
225     event Transfer(address indexed from, address indexed to, uint value);
226 
227     event Approval(address indexed owner, address indexed spender, uint value);
228 
229     event DelegatedTransfer(address indexed from, address indexed to, address indexed delegate, uint amount, uint fee);
230 
231     function () {
232         revert();
233     }
234 
235     /**
236     * @dev Gets the balance of the specified address.
237     *
238     * @param _owner The address to query the the balance of.
239     * @return An uint256 representing the amount owned by the passed address.
240     */
241     function balanceOf(address _owner) constant public returns (uint) {
242         return balances[_owner];
243     }
244 
245     /**
246     * @dev transfer token for a specified address
247     *
248     * @param _to The address to transfer to.
249     * @param _value The amount to be transferred.
250     */
251     function transfer(address _to, uint _value) whenNotPaused public returns (bool) {
252         require(_to != address(0) && _value <= balances[msg.sender]);
253 
254         balances[msg.sender] = balances[msg.sender].sub(_value);
255         balances[_to] = balances[_to].add(_value);
256 
257         callTokenFallback(_to, msg.sender, _value);
258 
259         emit Transfer(msg.sender, _to, _value);
260         return true;
261     }
262 
263     function delegatedTransfer(bytes _signature, address _to, uint _value, uint _fee, uint _nonce) whenNotPaused public returns (bool) {
264         require(_to != address(0) && signatures[_signature] == false);
265 
266         bytes32 hashedTx = hashDelegatedTransfer(_to, _value, _fee, _nonce);
267         address from = hashedTx.recover(_signature);
268 
269         require(from != address(0) && _value.add(_fee) <= balances[from]);
270 
271         balances[from] = balances[from].sub(_value).sub(_fee);
272         balances[_to] = balances[_to].add(_value);
273         balances[msg.sender] = balances[msg.sender].add(_fee);
274 
275         signatures[_signature] = true;
276 
277         callTokenFallback(_to, from, _value);
278 
279         emit Transfer(from, _to, _value);
280         emit Transfer(from, msg.sender, _fee);
281         emit DelegatedTransfer(from, _to, msg.sender, _value, _fee);
282         return true;
283     }
284 
285     function hashDelegatedTransfer(address _to, uint _value, uint _fee, uint _nonce) public view returns (bytes32) {
286         /* “45b56ba6”: delegatedTransfer(bytes,address,uint,uint,uint) */ // orig: 48664c16
287         return keccak256(bytes4(0x45b56ba6), address(this), _to, _value, _fee, _nonce);
288     }
289 
290     /**
291      * @dev Transfer tokens from one address to another
292      *
293      * @param _from The address which you want to send tokens from
294      * @param _to The address which you want to transfer to
295      * @param _value the amount of tokens to be transferred
296      */
297     function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool ok) {
298         require(_to != address(0));
299         require(_value <= balances[_from]);
300         require(_value <= allowed[_from][msg.sender]);
301 
302         balances[_from] = balances[_from].sub(_value);
303         balances[_to] = balances[_to].add(_value);
304         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
305 
306         callTokenFallback(_to, _from, _value);
307 
308         emit Transfer(_from, _to, _value);
309         return true;
310     }
311 
312     /**
313      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
314      *
315      * Beware that changing an allowance with this method brings the risk that someone may use both the old
316      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
317      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
318      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
319      * @param _spender The address which will spend the funds.
320      * @param _value The amount of tokens to be spent.
321      */
322     function approve(address _spender, uint _value) whenNotPaused public returns (bool ok) {
323         allowed[msg.sender][_spender] = _value;
324         emit Approval(msg.sender, _spender, _value);
325         return true;
326     }
327 
328     /**
329      * @dev Function to check the amount of tokens that an owner allowed to a spender.
330      * @param _owner address The address which owns the funds.
331      * @param _spender address The address which will spend the funds.
332      * @return A uint256 specifying the amount of tokens still available for the spender.
333      */
334     function allowance(address _owner, address _spender) constant public returns (uint) {
335         return allowed[_owner][_spender];
336     }
337 
338     /**
339      * @dev Increase the amount of tokens that an owner allowed to a spender.
340      *
341      * approve should be called when allowed[_spender] == 0. To increment
342      * allowed value is better to use this function to avoid 2 calls (and wait until
343      * the first transaction is mined)
344      * From MonolithDAO Token.sol
345      * @param _spender The address which will spend the funds.
346      * @param _addedValue The amount of tokens to increase the allowance by.
347      */
348     function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool success) {
349         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
350         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351         return true;
352     }
353 
354     /**
355      * @dev Decrease the amount of tokens that an owner allowed to a spender.
356      *
357      * approve should be called when allowed[_spender] == 0. To decrement
358      * allowed value is better to use this function to avoid 2 calls (and wait until
359      * the first transaction is mined)
360      * From MonolithDAO Token.sol
361      * @param _spender The address which will spend the funds.
362      * @param _subtractedValue The amount of tokens to decrease the allowance by.
363      */
364     function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool success) {
365         uint oldValue = allowed[msg.sender][_spender];
366         if (_subtractedValue > oldValue) {
367             allowed[msg.sender][_spender] = 0;
368         } else {
369             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
370         }
371         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
372         return true;
373     }
374 
375     function callTokenFallback(address _contract, address _from, uint _value) internal {
376         if (isContract(_contract)) {
377             require(contracts[_contract] != address(0) && balances[_contract] >= contractHoldBalance);
378             TokenReceiver receiver = TokenReceiver(_contract);
379             require(receiver.tokenFallback(_from, _value));
380         }
381     }
382 
383     function isContract(address _address) internal view returns(bool) {
384         uint length;
385         assembly {
386             length := extcodesize(_address)
387         }
388         return (length > 0);
389     }
390 
391     // contract => owner
392     mapping (address => address) contracts;
393 
394     uint contractHoldBalance = 500 * 10 ** decimals;
395 
396     function setContractHoldBalance(uint _value) whenNotPaused onlyOwner public returns(bool) {
397         contractHoldBalance = _value;
398         return true;
399     }
400 
401     function register(address _contract) whenNotPaused public returns(bool) {
402         require(isContract(_contract) && contracts[_contract] == address(0) && balances[msg.sender] >= contractHoldBalance);
403         balances[msg.sender] = balances[msg.sender].sub(contractHoldBalance);
404         balances[_contract] = balances[_contract].add(contractHoldBalance);
405         contracts[_contract] = msg.sender;
406         return true;
407     }
408 
409     function unregister(address _contract) whenNotPaused public returns(bool) {
410         require(isContract(_contract) && contracts[_contract] == msg.sender);
411         balances[_contract] = balances[_contract].sub(contractHoldBalance);
412         balances[msg.sender] = balances[msg.sender].add(contractHoldBalance);
413         delete contracts[_contract];
414         return true;
415     }
416 }
417 
418 contract CATT is Token {
419     string public name = "Content Aggregation Transfer Token";
420 
421     string public symbol = "CATT";
422 
423     uint public totalSupply = 5000000000 * 10 ** decimals;
424 
425     constructor() public {
426         balances[owner] = totalSupply;
427     }
428 }