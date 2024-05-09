1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12          // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13          // benefit is lost if 'b' is also tested.
14          // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15          if (a == 0) {
16                 return 0;
17          }
18 
19          c = a * b;
20          assert(c / a == b);
21          return c;
22     }
23 
24     /**
25      * @dev Integer division of two numbers, truncating the quotient.
26      */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28          // assert(b > 0); // Solidity automatically throws when dividing by 0
29          // uint256 c = a / b;
30          // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31          return a / b;
32     }
33 
34     /**
35      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36      */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38          assert(b <= a);
39          return a - b;
40     }
41 
42     /**
43      * @dev Adds two numbers, throws on overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46          c = a + b;
47          assert(c >= a);
48          return c;
49     }
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address public owner;
60     
61     event OwnershipRenounced(address indexed previousOwner);
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66      * account.
67      */
68     constructor() public {
69          owner = msg.sender;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76          require(msg.sender == owner);
77          _;
78     }
79 
80     /**
81      * @dev Allows the current owner to relinquish control of the contract.
82      * @notice Renouncing to ownership will leave the contract without an owner.
83      * It will not be possible to call the functions with the `onlyOwner`
84      * modifier anymore.
85      */
86     function renounceOwnership() public onlyOwner {
87          emit OwnershipRenounced(owner);
88          owner = address(0);
89     }
90 
91     /**
92      * @dev Allows the current owner to transfer control of the contract to a newOwner.
93      * @param _newOwner The address to transfer ownership to.
94      */
95     function transferOwnership(address _newOwner) public onlyOwner {
96          _transferOwnership(_newOwner);
97     }
98 
99     /**
100      * @dev Transfers control of the contract to a newOwner.
101      * @param _newOwner The address to transfer ownership to.
102      */
103     function _transferOwnership(address _newOwner) internal {
104          require(_newOwner != address(0));
105          emit OwnershipTransferred(owner, _newOwner);
106          owner = _newOwner;
107     }
108 }
109 
110 
111 /**
112  * @title ERC20Basic
113  * @dev Simpler version of ERC20 interface
114  * See https://github.com/ethereum/EIPs/issues/179
115  */
116 contract ERC20Basic {
117     function totalSupply() public view returns (uint256);
118     function balanceOf(address who) public view returns (uint256);
119     function transfer(address to, uint256 value) public returns (bool);
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 }
122 
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129     function allowance(address owner, address spender)
130          public view returns (uint256);
131 
132     function transferFrom(address from, address to, uint256 value)
133          public returns (bool);
134 
135     function approve(address spender, uint256 value) public returns (bool);
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 
140 /**
141  * @title Basic token
142  * @dev Basic version of StandardToken, with no allowances.
143  */
144 contract BasicToken is ERC20Basic {
145     using SafeMath for uint256;
146 
147     mapping(address => uint256) balances;
148 
149     uint256 totalSupply_;
150 
151     /**
152      * @dev Total number of tokens in existence
153      */
154     function totalSupply() public view returns (uint256) {
155          return totalSupply_;
156     }
157 
158     /**
159      * @dev Transfer token for a specified address
160      * @param _to The address to transfer to.
161      * @param _value The amount to be transferred.
162      */
163     function transfer(address _to, uint256 _value) public returns (bool) {
164          require(_to != address(0));
165          require(_value <= balances[msg.sender]);
166 
167          balances[msg.sender] = balances[msg.sender].sub(_value);
168          balances[_to] = balances[_to].add(_value);
169          emit Transfer(msg.sender, _to, _value);
170          return true;
171     }
172 
173     /**
174      * @dev Gets the balance of the specified address.
175      * @param _owner The address to query the the balance of.
176      * @return An uint256 representing the amount owned by the passed address.
177      */
178     function balanceOf(address _owner) public view returns (uint256) {
179          return balances[_owner];
180     }
181 
182 }
183 
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * https://github.com/ethereum/EIPs/issues/20
190  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194     mapping (address => mapping (address => uint256)) internal allowed;
195 
196     /**
197      * @dev Transfer tokens from one address to another
198      * @param _from address The address which you want to send tokens from
199      * @param _to address The address which you want to transfer to
200      * @param _value uint256 the amount of tokens to be transferred
201      */
202     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203          require(_to != address(0));
204          require(_value <= balances[_from]);
205          require(_value <= allowed[_from][msg.sender]);
206 
207          balances[_from] = balances[_from].sub(_value);
208          balances[_to] = balances[_to].add(_value);
209          allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210          emit Transfer(_from, _to, _value);
211          return true;
212     }
213 
214     /**
215      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216      * Beware that changing an allowance with this method brings the risk that someone may use both the old
217      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220      * @param _spender The address which will spend the funds.
221      * @param _value The amount of tokens to be spent.
222      */
223     function approve(address _spender, uint256 _value) public returns (bool) {
224          allowed[msg.sender][_spender] = _value;
225          emit Approval(msg.sender, _spender, _value);
226          return true;
227     }
228 
229     /**
230      * @dev Function to check the amount of tokens that an owner allowed to a spender.
231      * @param _owner address The address which owns the funds.
232      * @param _spender address The address which will spend the funds.
233      * @return A uint256 specifying the amount of tokens still available for the spender.
234      */
235     function allowance(address _owner, address _spender) public view returns (uint256) {
236          return allowed[_owner][_spender];
237     }
238 
239     /**
240      * @dev Increase the amount of tokens that an owner allowed to a spender.
241      * approve should be called when allowed[_spender] == 0. To increment
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      * @param _spender The address which will spend the funds.
246      * @param _addedValue The amount of tokens to increase the allowance by.
247      */
248     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
249          allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
250          emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251          return true;
252     }
253 
254     /**
255      * @dev Decrease the amount of tokens that an owner allowed to a spender.
256      * approve should be called when allowed[_spender] == 0. To decrement
257      * allowed value is better to use this function to avoid 2 calls (and wait until
258      * the first transaction is mined)
259      * From MonolithDAO Token.sol
260      * @param _spender The address which will spend the funds.
261      * @param _subtractedValue The amount of tokens to decrease the allowance by.
262      */
263     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
264          uint256 oldValue = allowed[msg.sender][_spender];
265          if (_subtractedValue > oldValue) {
266                 allowed[msg.sender][_spender] = 0;
267          } else {
268                 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269          }
270          emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271          return true;
272     }
273 }
274 
275 
276 /**
277  * @title Burnable Token
278  * @dev Token that can be irreversibly burned (destroyed).
279  */
280 contract BurnableToken is BasicToken {
281 
282     event Burn(address indexed burner, uint256 value);
283 
284     /**
285      * @dev Burns a specific amount of tokens.
286      * @param _value The amount of token to be burned.
287      */
288     function burn(uint256 _value) public {
289          _burn(msg.sender, _value);
290     }
291 
292     function _burn(address _who, uint256 _value) internal {
293          require(_value <= balances[_who]);
294          // no need to require value <= totalSupply, since that would imply the
295          // sender's balance is greater than the totalSupply, which *should* be an assertion failure
296 
297          balances[_who] = balances[_who].sub(_value);
298          totalSupply_ = totalSupply_.sub(_value);
299          emit Burn(_who, _value);
300          emit Transfer(_who, address(0), _value);
301     }
302 }
303 
304 
305 /**
306  * @title Standard Burnable Token
307  * @dev Adds burnFrom method to ERC20 implementations
308  */
309 contract StandardBurnableToken is BurnableToken, StandardToken {
310 
311     /**
312      * @dev Burns a specific amount of tokens from the target address and decrements allowance
313      * @param _from address The address which you want to send tokens from
314      * @param _value uint256 The amount of token to be burned
315      */
316     function burnFrom(address _from, uint256 _value) public {
317          require(_value <= allowed[_from][msg.sender]);
318          // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
319          // this function needs to emit an event with the updated approval.
320          allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
321          _burn(_from, _value);
322     }
323 }
324 
325 
326 /**
327  * @title Mintable token
328  * @dev Simple ERC20 Token example, with mintable token creation
329  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
330  */
331 contract MintableToken is StandardToken, Ownable {
332     event Mint(address indexed to, uint256 amount);
333     event MintFinished();
334 
335     bool public mintingFinished = false;
336 
337     modifier canMint() {
338         require(!mintingFinished);
339         _;
340     }
341 
342     modifier hasMintPermission() {
343         require(msg.sender == owner);
344         _;
345     }
346 
347     /**
348      * @dev Function to mint tokens
349      * @param _to The address that will receive the minted tokens.
350      * @param _amount The amount of tokens to mint.
351      * @return A boolean that indicates if the operation was successful.
352      */
353     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
354         totalSupply_ = totalSupply_.add(_amount);
355         balances[_to] = balances[_to].add(_amount);
356         emit Mint(_to, _amount);
357         emit Transfer(address(0), _to, _amount);
358         return true;
359     }
360 
361     /**
362      * @dev Function to stop minting new tokens.
363      * @return True if the operation was successful.
364      */
365     function finishMinting() onlyOwner canMint public returns (bool) {
366         mintingFinished = true;
367         emit MintFinished();
368         return true;
369     }
370 }
371 
372 
373 /**
374  * @title ABLE Dollar token
375  *
376  * @dev Implementation of the ABLE Dollar token 
377  */
378 contract AbleDollarToken is Ownable, StandardBurnableToken, MintableToken {
379 
380     string public name = "ABLE Dollar X Token";
381     string public symbol = "ABLD";
382     uint8 public decimals = 18;
383     uint public INITIAL_SUPPLY = 1000000000000000000000000000;
384 
385     mapping (address => bool) public frozenAccount;
386 
387     event Freeze(address target, bool freezed);
388     event UnFreeze(address target, bool freezed);
389 
390     /**
391      * @dev constructor for Able Dollar Token
392      */
393     constructor() public {
394         totalSupply_ = INITIAL_SUPPLY;
395         balances[msg.sender] = INITIAL_SUPPLY;
396     }
397 
398     /**
399      * @dev fallback function ***DO NOT OVERRIDE***
400      */
401     function () external payable {
402         revert();
403     }
404 
405     /**
406      * @dev Function to freeze address
407      * @param _target The address that will be freezed.
408      */
409     function freezeAccount(address _target) onlyOwner public {
410         require(_target != address(0));
411         frozenAccount[_target] = true;
412         emit Freeze(_target, true);
413     }
414     
415     /**
416      * @dev Function to freeze address
417      * @param _target The address that will be freezed.
418      */
419     function unfreezeAccount(address _target) onlyOwner public {
420         require(_target != address(0));
421         frozenAccount[_target] = false;
422         emit UnFreeze(_target, false);
423     }
424 
425     /**
426      * @dev Transfer token for a specified address
427      * @param _to The address to transfer to.
428      * @param _value The amount to be transferred.
429      */
430     function transfer(address _to, uint256 _value) public returns (bool) {
431         require(!frozenAccount[msg.sender]);        // Check if sender is frozen
432         require(!frozenAccount[_to]);               // Check if recipient is frozen
433         return super.transfer(_to,_value);
434     }
435 
436     /**
437      * @dev Transfer tokens from one address to another
438      * @param _from address The address which you want to send tokens from
439      * @param _to address The address which you want to transfer to
440      * @param _value uint256 the amount of tokens to be transferred
441      */
442     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
443         require(!frozenAccount[msg.sender]);        // Check if approved is frozen
444         require(!frozenAccount[_from]);             // Check if sender is frozen
445         require(!frozenAccount[_to]);               // Check if recipient is frozen
446         return super.transferFrom(_from, _to, _value);
447     }
448 }