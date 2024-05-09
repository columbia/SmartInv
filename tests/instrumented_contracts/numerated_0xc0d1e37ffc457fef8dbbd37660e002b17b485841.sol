1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
38 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: zeppelin-solidity/contracts/token/BasicToken.sol
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
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
91 
92 /**
93  * @title Burnable Token
94  * @dev Token that can be irreversibly burned (destroyed).
95  */
96 contract BurnableToken is BasicToken {
97 
98     event Burn(address indexed burner, uint256 value);
99 
100     /**
101      * @dev Burns a specific amount of tokens.
102      * @param _value The amount of token to be burned.
103      */
104     function burn(uint256 _value) public {
105         require(_value <= balances[msg.sender]);
106         // no need to require value <= totalSupply, since that would imply the
107         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
108 
109         address burner = msg.sender;
110         balances[burner] = balances[burner].sub(_value);
111         totalSupply = totalSupply.sub(_value);
112         Burn(burner, _value);
113     }
114 }
115 
116 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
117 
118 /**
119  * @title Ownable
120  * @dev The Ownable contract has an owner address, and provides basic authorization control
121  * functions, this simplifies the implementation of "user permissions".
122  */
123 contract Ownable {
124   address public owner;
125 
126 
127   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   function Ownable() public {
135     owner = msg.sender;
136   }
137 
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address newOwner) public onlyOwner {
153     require(newOwner != address(0));
154     OwnershipTransferred(owner, newOwner);
155     owner = newOwner;
156   }
157 
158 }
159 
160 // File: zeppelin-solidity/contracts/token/ERC20.sol
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167   function allowance(address owner, address spender) public view returns (uint256);
168   function transferFrom(address from, address to, uint256 value) public returns (bool);
169   function approve(address spender, uint256 value) public returns (bool);
170   event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 // File: zeppelin-solidity/contracts/token/StandardToken.sol
174 
175 /**
176  * @title Standard ERC20 token
177  *
178  * @dev Implementation of the basic standard token.
179  * @dev https://github.com/ethereum/EIPs/issues/20
180  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
181  */
182 contract StandardToken is ERC20, BasicToken {
183 
184   mapping (address => mapping (address => uint256)) internal allowed;
185 
186 
187   /**
188    * @dev Transfer tokens from one address to another
189    * @param _from address The address which you want to send tokens from
190    * @param _to address The address which you want to transfer to
191    * @param _value uint256 the amount of tokens to be transferred
192    */
193   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
194     require(_to != address(0));
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    *
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217     Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Function to check the amount of tokens that an owner allowed to a spender.
223    * @param _owner address The address which owns the funds.
224    * @param _spender address The address which will spend the funds.
225    * @return A uint256 specifying the amount of tokens still available for the spender.
226    */
227   function allowance(address _owner, address _spender) public view returns (uint256) {
228     return allowed[_owner][_spender];
229   }
230 
231   /**
232    * @dev Increase the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To increment
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _addedValue The amount of tokens to increase the allowance by.
240    */
241   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
242     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
243     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To decrement
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _subtractedValue The amount of tokens to decrease the allowance by.
256    */
257   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
258     uint oldValue = allowed[msg.sender][_spender];
259     if (_subtractedValue > oldValue) {
260       allowed[msg.sender][_spender] = 0;
261     } else {
262       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263     }
264     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268 }
269 
270 // File: zeppelin-solidity/contracts/token/MintableToken.sol
271 
272 /**
273  * @title Mintable token
274  * @dev Simple ERC20 Token example, with mintable token creation
275  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
276  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
277  */
278 
279 contract MintableToken is StandardToken, Ownable {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282 
283   bool public mintingFinished = false;
284 
285 
286   modifier canMint() {
287     require(!mintingFinished);
288     _;
289   }
290 
291   /**
292    * @dev Function to mint tokens
293    * @param _to The address that will receive the minted tokens.
294    * @param _amount The amount of tokens to mint.
295    * @return A boolean that indicates if the operation was successful.
296    */
297   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
298     totalSupply = totalSupply.add(_amount);
299     balances[_to] = balances[_to].add(_amount);
300     Mint(_to, _amount);
301     Transfer(address(0), _to, _amount);
302     return true;
303   }
304 
305   /**
306    * @dev Function to stop minting new tokens.
307    * @return True if the operation was successful.
308    */
309   function finishMinting() onlyOwner canMint public returns (bool) {
310     mintingFinished = true;
311     MintFinished();
312     return true;
313   }
314 }
315 
316 // File: zeppelin-solidity/contracts/token/CappedToken.sol
317 
318 /**
319  * @title Capped token
320  * @dev Mintable token with a token cap.
321  */
322 
323 contract CappedToken is MintableToken {
324 
325   uint256 public cap;
326 
327   function CappedToken(uint256 _cap) public {
328     require(_cap > 0);
329     cap = _cap;
330   }
331 
332   /**
333    * @dev Function to mint tokens
334    * @param _to The address that will receive the minted tokens.
335    * @param _amount The amount of tokens to mint.
336    * @return A boolean that indicates if the operation was successful.
337    */
338   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
339     require(totalSupply.add(_amount) <= cap);
340 
341     return super.mint(_to, _amount);
342   }
343 
344 }
345 
346 // File: zeppelin-solidity/contracts/token/DetailedERC20.sol
347 
348 contract DetailedERC20 is ERC20 {
349   string public name;
350   string public symbol;
351   uint8 public decimals;
352 
353   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
354     name = _name;
355     symbol = _symbol;
356     decimals = _decimals;
357   }
358 }
359 
360 // File: contracts/YondToken.sol
361 
362 /**
363  * Use OpenZeppelin Libraries
364  */
365 
366 
367 
368 
369 
370 
371 contract YondToken is DetailedERC20, StandardToken, BurnableToken, CappedToken {
372   /**
373    * @dev Set the maximum issuance cap and token details.
374    */
375   function YondToken()
376     DetailedERC20('YOND', 'YOND', 18)
377     CappedToken( 50 * (10**9) * (10**18) )
378   public {
379 
380   }
381 }