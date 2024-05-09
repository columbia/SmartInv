1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin-solidity/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: contracts/zeppelin-solidity/token/ERC20Basic.sol
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public constant returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: contracts/zeppelin-solidity/token/BasicToken.sol
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70 
71     // SafeMath.sub will throw if there is not enough balance.
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 // File: contracts/zeppelin-solidity/token/ERC20.sol
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public constant returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 // File: contracts/zeppelin-solidity/token/StandardToken.sol
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124 
125     uint256 _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue) public
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue) public
177     returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 // File: contracts/zeppelin-solidity/token/BurnableToken.sol
191 
192 /**
193  * @title Burnable Token
194  * @dev Token that can be irreversibly burned (destroyed).
195  */
196 contract BurnableToken is StandardToken {
197 
198     event Burn(address indexed burner, uint256 value);
199 
200     /**
201      * @dev Burns a specific amount of tokens.
202      * @param _value The amount of token to be burned.
203      */
204     function burn(uint256 _value) public {
205         require(_value > 0);
206 
207         address burner = msg.sender;
208         balances[burner] = balances[burner].sub(_value);
209         totalSupply = totalSupply.sub(_value);
210         Burn(burner, _value);
211     }
212 }
213 
214 // File: contracts/zeppelin-solidity/ownership/Ownable.sol
215 
216 /**
217  * @title Ownable
218  * @dev The Ownable contract has an owner address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  */
221 contract Ownable {
222   address public owner;
223 
224 
225   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
226 
227 
228   /**
229    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
230    * account.
231    */
232   function Ownable() public {
233     owner = msg.sender;
234   }
235 
236 
237   /**
238    * @dev Throws if called by any account other than the owner.
239    */
240   modifier onlyOwner() {
241     require(msg.sender == owner);
242     _;
243   }
244 
245 
246   /**
247    * @dev Allows the current owner to transfer control of the contract to a newOwner.
248    * @param newOwner The address to transfer ownership to.
249    */
250   function transferOwnership(address newOwner) onlyOwner public {
251     require(newOwner != address(0));
252     OwnershipTransferred(owner, newOwner);
253     owner = newOwner;
254   }
255 
256 }
257 
258 // File: contracts/zeppelin-solidity/token/MintableToken.sol
259 
260 /**
261  * @title Mintable token
262  * @dev Simple ERC20 Token example, with mintable token creation
263  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
264  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
265  */
266 
267 contract MintableToken is StandardToken, Ownable {
268   event Mint(address indexed to, uint256 amount);
269   event MintFinished();
270 
271   bool public mintingFinished = false;
272   mapping (address => bool) internal userAddr;
273 
274   /**
275   *
276   * Add adresses that can run an airdrop 
277   *
278   */
279   function whitelistAddressArray (address[] users) onlyOwner public {
280       for (uint i = 0; i < users.length; i++) {
281           userAddr[users[i]] = true;
282       }
283   }
284 
285   /**
286   *
287   * only whitelisted address can airdrop  
288   *
289   */
290 
291   modifier canAirDrop() {
292     require(userAddr[msg.sender]);
293     _;
294   }
295 
296   modifier canMint() {
297     require(!mintingFinished);
298     _;
299   }
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    *
307    */
308   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
309     totalSupply = totalSupply.add(_amount);
310     balances[_to] = balances[_to].add(_amount);
311 
312     Mint(_to, _amount);
313     Transfer(0x0, _to, _amount);
314     return true;
315   }
316   /**
317   *
318   * Run air drop, only from whitelisted adresses ( can run multiple pending transactions at a time )
319   * the granularity is 50 adresses at a time for the same amount, saving a good amount of gaz 
320   *
321   */
322 
323   function airdrop(address[] _to, uint256[] _amountList, uint8 loop) canAirDrop canMint public {
324       address adr;
325       uint256 _amount;
326       uint8 linc = 0;
327       for( uint i = 0; i < loop*50; i=i+50 ) {
328           adr = _to[i];
329           _amount = _amountList[linc++];
330           totalSupply = totalSupply.add(_amount*50);
331 
332           balances[adr] = balances[adr].add(_amount);
333           Transfer(0x0, adr, _amount);
334           adr = _to[i+1];
335           balances[adr] = balances[adr].add(_amount);
336           Transfer(0x0, adr, _amount);
337           adr = _to[i+2];
338           balances[adr] = balances[adr].add(_amount);
339           Transfer(0x0, adr, _amount);
340           adr = _to[i+3];
341           balances[adr] = balances[adr].add(_amount);
342           Transfer(0x0, adr, _amount);
343           adr = _to[i+4];
344           balances[adr] = balances[adr].add(_amount);
345           Transfer(0x0, adr, _amount);
346           adr = _to[i+5];
347           balances[adr] = balances[adr].add(_amount);
348           Transfer(0x0, adr, _amount);
349           adr = _to[i+6];
350           balances[adr] = balances[adr].add(_amount);
351           Transfer(0x0, adr, _amount);
352           adr = _to[i+7];
353           balances[adr] = balances[adr].add(_amount);
354           Transfer(0x0, adr, _amount);
355           adr = _to[i+8];
356           balances[adr] = balances[adr].add(_amount);
357           Transfer(0x0, adr, _amount);
358           adr = _to[i+9];
359           balances[adr] = balances[adr].add(_amount);
360           Transfer(0x0, adr, _amount);
361           adr = _to[i+10];
362           balances[adr] = balances[adr].add(_amount);
363           Transfer(0x0, adr, _amount);
364           adr = _to[i+11];
365           balances[adr] = balances[adr].add(_amount);
366           Transfer(0x0, adr, _amount);
367           adr = _to[i+12];
368           balances[adr] = balances[adr].add(_amount);
369           Transfer(0x0, adr, _amount);
370           adr = _to[i+13];
371           balances[adr] = balances[adr].add(_amount);
372           Transfer(0x0, adr, _amount);
373           adr = _to[i+14];
374           balances[adr] = balances[adr].add(_amount);
375           Transfer(0x0, adr, _amount);
376           adr = _to[i+15];
377           balances[adr] = balances[adr].add(_amount);
378           Transfer(0x0, adr, _amount);
379           adr = _to[i+16];
380           balances[adr] = balances[adr].add(_amount);
381           Transfer(0x0, adr, _amount);
382           adr = _to[i+17];
383           balances[adr] = balances[adr].add(_amount);
384           Transfer(0x0, adr, _amount);
385           adr = _to[i+18];
386           balances[adr] = balances[adr].add(_amount);
387           Transfer(0x0, adr, _amount);
388           adr = _to[i+19];
389           balances[adr] = balances[adr].add(_amount);
390           Transfer(0x0, adr, _amount);
391           adr = _to[i+20];
392           balances[adr] = balances[adr].add(_amount);
393           Transfer(0x0, adr, _amount);
394           adr = _to[i+21];
395           balances[adr] = balances[adr].add(_amount);
396           Transfer(0x0, adr, _amount);
397           adr = _to[i+22];
398           balances[adr] = balances[adr].add(_amount);
399           Transfer(0x0, adr, _amount);
400           adr = _to[i+23];
401           balances[adr] = balances[adr].add(_amount);
402           Transfer(0x0, adr, _amount);
403           adr = _to[i+24];
404           balances[adr] = balances[adr].add(_amount);
405           Transfer(0x0, adr, _amount);
406           adr = _to[i+25];
407           balances[adr] = balances[adr].add(_amount);
408           Transfer(0x0, adr, _amount);
409           adr = _to[i+26];
410           balances[adr] = balances[adr].add(_amount);
411           Transfer(0x0, adr, _amount);
412           adr = _to[i+27];
413           balances[adr] = balances[adr].add(_amount);
414           Transfer(0x0, adr, _amount);
415           adr = _to[i+28];
416           balances[adr] = balances[adr].add(_amount);
417           Transfer(0x0, adr, _amount);
418           adr = _to[i+29];
419           balances[adr] = balances[adr].add(_amount);
420           Transfer(0x0, adr, _amount);
421           adr = _to[i+30];
422           balances[adr] = balances[adr].add(_amount);
423           Transfer(0x0, adr, _amount);
424           adr = _to[i+31];
425           balances[adr] = balances[adr].add(_amount);
426           Transfer(0x0, adr, _amount);
427           adr = _to[i+32];
428           balances[adr] = balances[adr].add(_amount);
429           Transfer(0x0, adr, _amount);
430           adr = _to[i+33];
431           balances[adr] = balances[adr].add(_amount);
432           Transfer(0x0, adr, _amount);
433           adr = _to[i+34];
434           balances[adr] = balances[adr].add(_amount);
435           Transfer(0x0, adr, _amount);
436           adr = _to[i+35];
437           balances[adr] = balances[adr].add(_amount);
438           Transfer(0x0, adr, _amount);
439           adr = _to[i+36];
440           balances[adr] = balances[adr].add(_amount);
441           Transfer(0x0, adr, _amount);
442           adr = _to[i+37];
443           balances[adr] = balances[adr].add(_amount);
444           Transfer(0x0, adr, _amount);
445           adr = _to[i+38];
446           balances[adr] = balances[adr].add(_amount);
447           Transfer(0x0, adr, _amount);
448           adr = _to[i+39];
449           balances[adr] = balances[adr].add(_amount);
450           Transfer(0x0, adr, _amount);
451           adr = _to[i+40];
452           balances[adr] = balances[adr].add(_amount);
453           Transfer(0x0, adr, _amount);
454           adr = _to[i+41];
455           balances[adr] = balances[adr].add(_amount);
456           Transfer(0x0, adr, _amount);
457           adr = _to[i+42];
458           balances[adr] = balances[adr].add(_amount);
459           Transfer(0x0, adr, _amount);
460           adr = _to[i+43];
461           balances[adr] = balances[adr].add(_amount);
462           Transfer(0x0, adr, _amount);
463           adr = _to[i+44];
464           balances[adr] = balances[adr].add(_amount);
465           Transfer(0x0, adr, _amount);
466           adr = _to[i+45];
467           balances[adr] = balances[adr].add(_amount);
468           Transfer(0x0, adr, _amount);
469           adr = _to[i+46];
470           balances[adr] = balances[adr].add(_amount);
471           Transfer(0x0, adr, _amount);
472           adr = _to[i+47];
473           balances[adr] = balances[adr].add(_amount);
474           Transfer(0x0, adr, _amount);
475           adr = _to[i+48];
476           balances[adr] = balances[adr].add(_amount);
477           Transfer(0x0, adr, _amount);
478           adr = _to[i+49];
479           balances[adr] = balances[adr].add(_amount);
480           Transfer(0x0, adr, _amount);
481       }
482     }
483   /**
484    * @dev Function to stop minting new tokens.
485    * @return True if the operation was successful.
486    */
487   function finishMinting() onlyOwner public returns (bool) {
488     mintingFinished = true;
489     MintFinished();
490     return true;
491   }
492 }
493 
494 // File: contracts/kdoTokenIcoListMe.sol
495 
496 contract kdoTokenIcoListMe is MintableToken,BurnableToken {
497     string public constant name = "A ? from ico-list.me/kdo";
498     string public constant symbol = "KDO ?";
499     uint8 public decimals = 3;
500 }