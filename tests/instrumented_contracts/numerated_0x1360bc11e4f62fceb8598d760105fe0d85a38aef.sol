1 pragma solidity ^0.4.21;
2  
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */ 
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) returns (bool);
23   function approve(address spender, uint256 value) returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32     
33   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal constant returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56   
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances. 
62  */
63 contract BasicToken is ERC20Basic {
64     
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) returns (bool) {
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of. 
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99  
100 /**
101  * @title Burnable Token
102  * @dev Token that can be irreversibly burned (destroyed).
103  */
104 contract BurnableToken is BasicToken {
105 
106   event Burn(address indexed burner, uint256 value);
107 
108   /**
109    * @dev Burns a specific amount of tokens.
110    * @param _value The amount of token to be burned.
111    */
112   function burn(uint256 _value) public {
113     require(_value <= balances[msg.sender]);
114     // no need to require value <= totalSupply, since that would imply the
115     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
116 
117     address burner = msg.sender;
118     balances[burner] = balances[burner].sub(_value);
119     totalSupply = totalSupply.sub(_value);
120     Burn(burner, _value);
121     Transfer(burner, address(0), _value);
122   }
123 } 
124  
125 contract StandardToken is ERC20, BurnableToken {
126 
127   mapping (address => mapping (address => uint256)) allowed;
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amout of tokens to be transfered
134    */
135   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
136     var _allowance = allowed[_from][msg.sender];
137 
138     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139     // require (_value <= _allowance);
140 
141     balances[_to] = balances[_to].add(_value);
142     balances[_from] = balances[_from].sub(_value);
143     allowed[_from][msg.sender] = _allowance.sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) returns (bool) {
154 
155     // To change the approve amount you first have to reduce the addresses`
156     //  allowance to zero by calling `approve(_spender, 0)` if it is not
157     //  already 0 to mitigate the race condition described here:
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
160 
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifing the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176 }
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable {
184     
185   address public owner;
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() {
192     owner = msg.sender;
193   }
194 
195   /**
196    * @dev Throws if called by any account other than the owner.
197    */
198   modifier onlyOwner() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner {
208     require(newOwner != address(0));      
209     owner = newOwner;
210   }
211 
212 }
213 
214 /**
215  * @title Mintable token
216  * @dev Simple ERC20 Token example, with mintable token creation
217  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
218  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
219  */
220 
221 contract MintableToken is StandardToken, Ownable {
222     
223   event Mint(address indexed to, uint256 amount);
224   
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228 
229   modifier canMint() {
230     require(!mintingFinished);
231     _;
232   }
233 
234   /**
235    * @dev Function to mint tokens
236    * @param _to The address that will recieve the minted tokens.
237    * @param _amount The amount of tokens to mint.
238    * @return A boolean that indicates if the operation was successful.
239    */
240   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
241     totalSupply = totalSupply.add(_amount);
242     balances[_to] = balances[_to].add(_amount);
243     Mint(_to, _amount);
244     Transfer(address(0), _to, _amount);
245     return true;
246   }
247 
248   /**
249    * @dev Function to stop minting new tokens.
250    * @return True if the operation was successful.
251    */
252   function finishMinting() onlyOwner returns (bool) {
253     mintingFinished = true;
254     MintFinished();
255     return true;
256   }
257   
258 }
259 
260 contract SUCoin is MintableToken {
261     
262     string public constant name = "SU Coin";
263     
264     string public constant symbol = "SUCoin";
265     
266     uint32 public constant decimals = 18;
267     
268 }
269 
270 
271 contract SUTokenContract is Ownable  {
272     using SafeMath for uint;
273     
274     SUCoin public token = new SUCoin();
275     bool ifInit = false;
276     uint public tokenDec = 1000000000000000000; //18
277     address manager;
278     //uint public lastPeriod;
279     
280     
281     mapping (address => mapping (uint => bool)) idMap;
282     //mapping (address => mapping (bytes32 => bool)) hashMap;
283     //mapping(uint => bool) idMap;
284     mapping(bytes32 => bool) hashMap;
285     mapping (uint => uint) mintInPeriod;
286     uint public mintLimit = tokenDec.mul(10000);
287     uint public period = 30 * 1 days; // 30 дней
288     uint public startTime = now;
289     
290     
291     function SUTokenContract(){
292         owner = msg.sender;
293         manager = msg.sender;
294     }
295     
296     function initMinting() onlyOwner returns (bool) {
297         require(!ifInit);
298         require(token.mint(0x8f89FE2362C769B472F0e9496F5Ca86850BeE8D4, tokenDec.mul(50000)));
299         require(token.mint(address(this), tokenDec.mul(50000)));
300 
301         ifInit = true;
302         return true;
303     } 
304     
305     // Данная функция на тестовый период. Позволяет передать токен на новый контракт
306     function transferTokenOwnership(address _newOwner) onlyOwner {   
307         token.transferOwnership(_newOwner);
308     }
309     
310     function mint(address _to, uint _value) onlyOwner {
311         uint currPeriod = now.sub(startTime).div(period);
312         require(mintLimit>= _value.add(mintInPeriod[currPeriod]));
313         require(token.mint(_to, _value));
314         mintInPeriod[currPeriod] = mintInPeriod[currPeriod].add(_value);
315     }
316     
317     function burn(uint256 _value) onlyOwner {
318         token.burn(_value);
319     }
320     
321     function tokenTotalSupply() constant returns (uint256) {
322         return token.totalSupply();
323     }
324     
325     //Баланс токенов на данном контракте    
326     function tokenContractBalance() constant returns (uint256) {
327         return token.balanceOf(address(this));
328     }   
329     
330     function tokentBalance(address _address) constant returns (uint256) {
331         return token.balanceOf(_address);
332     }     
333     
334     
335     function transferToken(address _to, uint _value) onlyOwner returns (bool) {
336         return token.transfer(_to,  _value);
337     }    
338     
339     function allowance( address _spender) constant returns (uint256 remaining) {
340         return token.allowance(address(this),_spender);
341     }
342     
343     function allowanceAdd( address _spender, uint _value ) onlyOwner  returns (bool) {
344         uint currAllowance = allowance( _spender);
345         require(token.approve( _spender, 0));
346         require(token.approve( _spender, currAllowance.add(_value)));
347         return true;
348     } 
349     
350     function allowanceSub( address _spender, uint _value ) onlyOwner  returns (bool) {
351         uint currAllowance = allowance( _spender);
352         require(currAllowance>=_value);
353         require(token.approve( _spender, 0));
354         require(token.approve( _spender, currAllowance.sub(_value)));
355         return true;
356     }
357     
358     function allowanceSubId( address _spender, uint _value,   uint _id) onlyOwner  returns (bool) {
359         uint currAllowance = allowance( _spender);
360         require(currAllowance>=_value);
361         require(token.approve( _spender, 0));
362         require(token.approve( _spender, currAllowance.sub(_value)));
363         idMap[_spender][_id] = true;
364         return true;
365     }    
366 
367   function storeId(address _address, uint _id) onlyOwner {
368     idMap[_address][_id] = true;
369   } 
370   
371   function storeHash(bytes32 _hash) onlyOwner {
372     hashMap[_hash] = true;
373   } 
374      
375     
376   function idVerification(address _address, uint _id) constant returns (bool) {
377     return idMap[_address][_id];
378   } 
379   
380   function hashVerification(bytes32 _hash) constant returns (bool) {
381     return hashMap[_hash];
382   } 
383   
384   function mintInPeriodCount(uint _period) constant returns (uint) {
385     return mintInPeriod[_period];
386   }   
387   
388   function mintInCurrPeriodCount() constant returns (uint) {
389     uint currPeriod = now.sub(startTime).div(period);
390     return mintInPeriod[currPeriod];
391   }
392   
393 
394 }