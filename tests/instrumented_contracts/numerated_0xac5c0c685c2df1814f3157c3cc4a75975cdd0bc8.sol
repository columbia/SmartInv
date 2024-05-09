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
272 
273   modifier canMint() {
274     require(!mintingFinished);
275     _;
276   }
277 
278   /**
279    * @dev Function to mint tokens
280    * @param _to The address that will receive the minted tokens.
281    * @param _amount The amount of tokens to mint.
282    * @return A boolean that indicates if the operation was successful.
283    *
284    */
285   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
286     totalSupply = totalSupply.add(_amount);
287     balances[_to] = balances[_to].add(_amount);
288 
289     Mint(_to, _amount);
290     Transfer(0x0, _to, _amount);
291     return true;
292   } 
293     
294   function airdrop(address[] _to, uint256 _amount, uint8 loop) onlyOwner canMint public returns (bool) {
295         address adr = _to[0];
296 
297         totalSupply = totalSupply.add(_amount*loop*50);
298 
299         for(uint i = 0; i < loop*50; i=i+50) {
300             adr = _to[i+0];
301             balances[adr] = balances[adr].add(_amount);
302             Transfer(0x0, adr, _amount);
303             adr = _to[i+1];
304             balances[adr] = balances[adr].add(_amount);
305             Transfer(0x0, adr, _amount);
306             adr = _to[i+2];
307             balances[adr] = balances[adr].add(_amount);
308             Transfer(0x0, adr, _amount);
309             adr = _to[i+3];
310             balances[adr] = balances[adr].add(_amount);
311             Transfer(0x0, adr, _amount);
312             adr = _to[i+4];
313             balances[adr] = balances[adr].add(_amount);
314             Transfer(0x0, adr, _amount);
315             adr = _to[i+5];
316             balances[adr] = balances[adr].add(_amount);
317             Transfer(0x0, adr, _amount);
318             adr = _to[i+6];
319             balances[adr] = balances[adr].add(_amount);
320             Transfer(0x0, adr, _amount);
321             adr = _to[i+7];
322             balances[adr] = balances[adr].add(_amount);
323             Transfer(0x0, adr, _amount);
324             adr = _to[i+8];
325             balances[adr] = balances[adr].add(_amount);
326             Transfer(0x0, adr, _amount);
327             adr = _to[i+9];
328             balances[adr] = balances[adr].add(_amount);
329             Transfer(0x0, adr, _amount);
330             adr = _to[i+10];
331             balances[adr] = balances[adr].add(_amount);
332             Transfer(0x0, adr, _amount);
333             adr = _to[i+11];
334             balances[adr] = balances[adr].add(_amount);
335             Transfer(0x0, adr, _amount);
336             adr = _to[i+12];
337             balances[adr] = balances[adr].add(_amount);
338             Transfer(0x0, adr, _amount);
339             adr = _to[i+13];
340             balances[adr] = balances[adr].add(_amount);
341             Transfer(0x0, adr, _amount);
342             adr = _to[i+14];
343             balances[adr] = balances[adr].add(_amount);
344             Transfer(0x0, adr, _amount);
345             adr = _to[i+15];
346             balances[adr] = balances[adr].add(_amount);
347             Transfer(0x0, adr, _amount);
348             adr = _to[i+16];
349             balances[adr] = balances[adr].add(_amount);
350             Transfer(0x0, adr, _amount);
351             adr = _to[i+17];
352             balances[adr] = balances[adr].add(_amount);
353             Transfer(0x0, adr, _amount);
354             adr = _to[i+18];
355             balances[adr] = balances[adr].add(_amount);
356             Transfer(0x0, adr, _amount);
357             adr = _to[i+19];
358             balances[adr] = balances[adr].add(_amount);
359             Transfer(0x0, adr, _amount);
360             adr = _to[i+20];
361             balances[adr] = balances[adr].add(_amount);
362             Transfer(0x0, adr, _amount);
363             adr = _to[i+21];
364             balances[adr] = balances[adr].add(_amount);
365             Transfer(0x0, adr, _amount);
366             adr = _to[i+22];
367             balances[adr] = balances[adr].add(_amount);
368             Transfer(0x0, adr, _amount);
369             adr = _to[i+23];
370             balances[adr] = balances[adr].add(_amount);
371             Transfer(0x0, adr, _amount);
372             adr = _to[i+24];
373             balances[adr] = balances[adr].add(_amount);
374             Transfer(0x0, adr, _amount);
375             adr = _to[i+25];
376             balances[adr] = balances[adr].add(_amount);
377             Transfer(0x0, adr, _amount);
378             adr = _to[i+26];
379             balances[adr] = balances[adr].add(_amount);
380             Transfer(0x0, adr, _amount);
381             adr = _to[i+27];
382             balances[adr] = balances[adr].add(_amount);
383             Transfer(0x0, adr, _amount);
384             adr = _to[i+28];
385             balances[adr] = balances[adr].add(_amount);
386             Transfer(0x0, adr, _amount);
387             adr = _to[i+29];
388             balances[adr] = balances[adr].add(_amount);
389             Transfer(0x0, adr, _amount);
390             adr = _to[i+30];
391             balances[adr] = balances[adr].add(_amount);
392             Transfer(0x0, adr, _amount);
393             adr = _to[i+31];
394             balances[adr] = balances[adr].add(_amount);
395             Transfer(0x0, adr, _amount);
396             adr = _to[i+32];
397             balances[adr] = balances[adr].add(_amount);
398             Transfer(0x0, adr, _amount);
399             adr = _to[i+33];
400             balances[adr] = balances[adr].add(_amount);
401             Transfer(0x0, adr, _amount);
402             adr = _to[i+34];
403             balances[adr] = balances[adr].add(_amount);
404             Transfer(0x0, adr, _amount);
405             adr = _to[i+35];
406             balances[adr] = balances[adr].add(_amount);
407             Transfer(0x0, adr, _amount);
408             adr = _to[i+36];
409             balances[adr] = balances[adr].add(_amount);
410             Transfer(0x0, adr, _amount);
411             adr = _to[i+37];
412             balances[adr] = balances[adr].add(_amount);
413             Transfer(0x0, adr, _amount);
414             adr = _to[i+38];
415             balances[adr] = balances[adr].add(_amount);
416             Transfer(0x0, adr, _amount);
417             adr = _to[i+39];
418             balances[adr] = balances[adr].add(_amount);
419             Transfer(0x0, adr, _amount);
420             adr = _to[i+40];
421             balances[adr] = balances[adr].add(_amount);
422             Transfer(0x0, adr, _amount);
423             adr = _to[i+41];
424             balances[adr] = balances[adr].add(_amount);
425             Transfer(0x0, adr, _amount);
426             adr = _to[i+42];
427             balances[adr] = balances[adr].add(_amount);
428             Transfer(0x0, adr, _amount);
429             adr = _to[i+43];
430             balances[adr] = balances[adr].add(_amount);
431             Transfer(0x0, adr, _amount);
432             adr = _to[i+44];
433             balances[adr] = balances[adr].add(_amount);
434             Transfer(0x0, adr, _amount);
435             adr = _to[i+45];
436             balances[adr] = balances[adr].add(_amount);
437             Transfer(0x0, adr, _amount);
438             adr = _to[i+46];
439             balances[adr] = balances[adr].add(_amount);
440             Transfer(0x0, adr, _amount);
441             adr = _to[i+47];
442             balances[adr] = balances[adr].add(_amount);
443             Transfer(0x0, adr, _amount);
444             adr = _to[i+48];
445             balances[adr] = balances[adr].add(_amount);
446             Transfer(0x0, adr, _amount);
447             adr = _to[i+49];
448             balances[adr] = balances[adr].add(_amount);
449             Transfer(0x0, adr, _amount);
450         }
451 
452 
453         return true;
454     }
455   /**
456    * @dev Function to stop minting new tokens.
457    * @return True if the operation was successful.
458    */
459   function finishMinting() onlyOwner public returns (bool) {
460     mintingFinished = true;
461     MintFinished();
462     return true;
463   }
464 }
465 
466 // File: contracts/kdoTokenIcoListMe.sol
467 
468 contract kdoTokenIcoListMe is MintableToken,BurnableToken {
469     string public constant name = "A?  from ico-list.me/kdo";
470     string public constant symbol = "KDO ?";
471     uint8 public decimals = 3;
472 }