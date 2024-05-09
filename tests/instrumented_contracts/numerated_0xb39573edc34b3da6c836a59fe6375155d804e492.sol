1 pragma solidity ^0.4.22;
2 
3 // File: contracts/ERC223/ERC223_receiving_contract.sol
4 
5 /**
6 * @title Contract that will work with ERC223 tokens.
7 */
8 
9 contract ERC223ReceivingContract {
10     /**
11      * @dev Standard ERC223 function that will handle incoming token transfers.
12      *
13      * @param _from  Token sender address.
14      * @param _value Amount of tokens.
15      * @param _data  Transaction metadata.
16      */
17     function tokenFallback(address _from, uint _value, bytes _data);
18 }
19 
20 // File: zeppelin-solidity/contracts/math/SafeMath.sol
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/179
74  */
75 contract ERC20Basic {
76   function totalSupply() public view returns (uint256);
77   function balanceOf(address who) public view returns (uint256);
78   function transfer(address to, uint256 value) public returns (bool);
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   uint256 totalSupply_;
94 
95   /**
96   * @dev total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[msg.sender]);
110 
111     // SafeMath.sub will throw if there is not enough balance.
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public view returns (uint256 balance) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender) public view returns (uint256);
137   function transferFrom(address from, address to, uint256 value) public returns (bool);
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * @dev Increase the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227     uint oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue > oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 // File: contracts/ERC223/ERC223.sol
240 
241 /**
242  * @title Reference implementation of the ERC223 standard token.
243  */
244 contract ERC223 is StandardToken {
245 
246     event Transfer(address indexed from, address indexed to, uint value, bytes data);
247 
248     /**
249     * @dev transfer token for a specified address
250     * @param _to The address to transfer to.
251     * @param _value The amount to be transferred.
252     */
253     function transfer(address _to, uint _value) public returns (bool) {
254         bytes memory empty;
255         return transfer(_to, _value, empty);
256     }
257 
258     /**
259     * @dev transfer token for a specified address
260     * @param _to The address to transfer to.
261     * @param _value The amount to be transferred.
262     * @param _data Optional metadata.
263     */
264     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
265         super.transfer(_to, _value);
266 
267         if (isContract(_to)) {
268             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
269             receiver.tokenFallback(msg.sender, _value, _data);
270             Transfer(msg.sender, _to, _value, _data);
271         }
272 
273         return true;
274     }
275 
276     /**
277      * @dev Transfer tokens from one address to another
278      * @param _from address The address which you want to send tokens from
279      * @param _to address The address which you want to transfer to
280      * @param _value uint the amount of tokens to be transferred
281      */
282     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
283         bytes memory empty;
284         return transferFrom(_from, _to, _value, empty);
285     }
286 
287     /**
288      * @dev Transfer tokens from one address to another
289      * @param _from address The address which you want to send tokens from
290      * @param _to address The address which you want to transfer to
291      * @param _value uint the amount of tokens to be transferred
292      * @param _data Optional metadata.
293      */
294     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {
295         super.transferFrom(_from, _to, _value);
296 
297         if (isContract(_to)) {
298             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
299             receiver.tokenFallback(_from, _value, _data);
300         }
301 
302         Transfer(_from, _to, _value, _data);
303         return true;
304     }
305 
306     function isContract(address _addr) private view returns (bool) {
307         uint length;
308         assembly {
309             //retrieve the size of the code on target address, this needs assembly
310             length := extcodesize(_addr)
311         }
312         return (length>0);
313     }
314 }
315 
316 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
317 
318 /**
319  * @title Ownable
320  * @dev The Ownable contract has an owner address, and provides basic authorization control
321  * functions, this simplifies the implementation of "user permissions".
322  */
323 contract Ownable {
324   address public owner;
325 
326 
327   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
328 
329 
330   /**
331    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
332    * account.
333    */
334   function Ownable() public {
335     owner = msg.sender;
336   }
337 
338   /**
339    * @dev Throws if called by any account other than the owner.
340    */
341   modifier onlyOwner() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Allows the current owner to transfer control of the contract to a newOwner.
348    * @param newOwner The address to transfer ownership to.
349    */
350   function transferOwnership(address newOwner) public onlyOwner {
351     require(newOwner != address(0));
352     OwnershipTransferred(owner, newOwner);
353     owner = newOwner;
354   }
355 
356 }
357 
358 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
359 
360 /**
361  * @title Mintable token
362  * @dev Simple ERC20 Token example, with mintable token creation
363  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
364  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
365  */
366 contract MintableToken is StandardToken, Ownable {
367   event Mint(address indexed to, uint256 amount);
368   event MintFinished();
369 
370   bool public mintingFinished = false;
371 
372 
373   modifier canMint() {
374     require(!mintingFinished);
375     _;
376   }
377 
378   /**
379    * @dev Function to mint tokens
380    * @param _to The address that will receive the minted tokens.
381    * @param _amount The amount of tokens to mint.
382    * @return A boolean that indicates if the operation was successful.
383    */
384   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
385     totalSupply_ = totalSupply_.add(_amount);
386     balances[_to] = balances[_to].add(_amount);
387     Mint(_to, _amount);
388     Transfer(address(0), _to, _amount);
389     return true;
390   }
391 
392   /**
393    * @dev Function to stop minting new tokens.
394    * @return True if the operation was successful.
395    */
396   function finishMinting() onlyOwner canMint public returns (bool) {
397     mintingFinished = true;
398     MintFinished();
399     return true;
400   }
401 }
402 
403 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
404 
405 /**
406  * @title Capped token
407  * @dev Mintable token with a token cap.
408  */
409 contract CappedToken is MintableToken {
410 
411   uint256 public cap;
412 
413   function CappedToken(uint256 _cap) public {
414     require(_cap > 0);
415     cap = _cap;
416   }
417 
418   /**
419    * @dev Function to mint tokens
420    * @param _to The address that will receive the minted tokens.
421    * @param _amount The amount of tokens to mint.
422    * @return A boolean that indicates if the operation was successful.
423    */
424   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
425     require(totalSupply_.add(_amount) <= cap);
426 
427     return super.mint(_to, _amount);
428   }
429 
430 }
431 
432 // File: contracts/RootsToken.sol
433 
434 contract RootsToken is CappedToken, ERC223 {
435 
436     string constant public name = "ROOTS Token";
437     string constant public symbol = "ROOTS";
438     uint constant public decimals = 18;
439 
440     function RootsToken() public CappedToken(1e10 * 1e18) {}
441 
442     function mintlist(address[] _to, uint256[] _amount) onlyOwner canMint public {
443         require(_to.length == _amount.length);
444 
445         for (uint256 i = 0; i < _to.length; i++) {
446             mint(_to[i], _amount[i]);
447         }
448     }
449 }