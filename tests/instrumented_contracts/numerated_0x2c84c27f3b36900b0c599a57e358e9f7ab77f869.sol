1 pragma solidity ^0.4.18;
2 
3 // File: contracts\zeppelin-solidity\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts\zeppelin-solidity\token\ERC20\ERC20Basic.sol
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 // File: contracts\zeppelin-solidity\lifecycle\TokenDestructible.sol
60 
61 /**
62  * @title TokenDestructible:
63  * @author Remco Bloemen <remco@2π.com>
64  * @dev Base contract that can be destroyed by owner. All funds in contract including
65  * listed tokens will be sent to the owner.
66  */
67 contract TokenDestructible is Ownable {
68 
69   function TokenDestructible() public payable { }
70 
71   /**
72    * @notice Terminate contract and refund to owner
73    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
74    refund.
75    * @notice The called token contracts could try to re-enter this contract. Only
76    supply token contracts you trust.
77    */
78   function destroy(address[] tokens) onlyOwner public {
79 
80     // Transfer tokens to owner
81     for (uint256 i = 0; i < tokens.length; i++) {
82       ERC20Basic token = ERC20Basic(tokens[i]);
83       uint256 balance = token.balanceOf(this);
84       token.transfer(owner, balance);
85     }
86 
87     // Transfer Eth to owner and terminate contract
88     selfdestruct(owner);
89   }
90 }
91 
92 // File: contracts\zeppelin-solidity\math\SafeMath.sol
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath {
99 
100   /**
101   * @dev Multiplies two numbers, throws on overflow.
102   */
103   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104     if (a == 0) {
105       return 0;
106     }
107     uint256 c = a * b;
108     assert(c / a == b);
109     return c;
110   }
111 
112   /**
113   * @dev Integer division of two numbers, truncating the quotient.
114   */
115   function div(uint256 a, uint256 b) internal pure returns (uint256) {
116     // assert(b > 0); // Solidity automatically throws when dividing by 0
117     uint256 c = a / b;
118     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119     return c;
120   }
121 
122   /**
123   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
124   */
125   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126     assert(b <= a);
127     return a - b;
128   }
129 
130   /**
131   * @dev Adds two numbers, throws on overflow.
132   */
133   function add(uint256 a, uint256 b) internal pure returns (uint256) {
134     uint256 c = a + b;
135     assert(c >= a);
136     return c;
137   }
138 }
139 
140 // File: contracts\zeppelin-solidity\token\ERC20\BasicToken.sol
141 
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) balances;
150 
151   uint256 totalSupply_;
152 
153   /**
154   * @dev total number of tokens in existence
155   */
156   function totalSupply() public view returns (uint256) {
157     return totalSupply_;
158   }
159 
160   /**
161   * @dev transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[msg.sender]);
168 
169     // SafeMath.sub will throw if there is not enough balance.
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256 balance) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 // File: contracts\zeppelin-solidity\token\ERC20\BurnableToken.sol
188 
189 /**
190  * @title Burnable Token
191  * @dev Token that can be irreversibly burned (destroyed).
192  */
193 contract BurnableToken is BasicToken {
194 
195   event Burn(address indexed burner, uint256 value);
196 
197   /**
198    * @dev Burns a specific amount of tokens.
199    * @param _value The amount of token to be burned.
200    */
201   function burn(uint256 _value) public {
202     require(_value <= balances[msg.sender]);
203     // no need to require value <= totalSupply, since that would imply the
204     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
205 
206     address burner = msg.sender;
207     balances[burner] = balances[burner].sub(_value);
208     totalSupply_ = totalSupply_.sub(_value);
209     Burn(burner, _value);
210     Transfer(burner, address(0), _value);
211   }
212 }
213 
214 // File: contracts\zeppelin-solidity\token\ERC20\ERC20.sol
215 
216 /**
217  * @title ERC20 interface
218  * @dev see https://github.com/ethereum/EIPs/issues/20
219  */
220 contract ERC20 is ERC20Basic {
221   function allowance(address owner, address spender) public view returns (uint256);
222   function transferFrom(address from, address to, uint256 value) public returns (bool);
223   function approve(address spender, uint256 value) public returns (bool);
224   event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 // File: contracts\zeppelin-solidity\token\ERC20\StandardToken.sol
228 
229 /**
230  * @title Standard ERC20 token
231  *
232  * @dev Implementation of the basic standard token.
233  * @dev https://github.com/ethereum/EIPs/issues/20
234  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
235  */
236 contract StandardToken is ERC20, BasicToken {
237 
238   mapping (address => mapping (address => uint256)) internal allowed;
239 
240 
241   /**
242    * @dev Transfer tokens from one address to another
243    * @param _from address The address which you want to send tokens from
244    * @param _to address The address which you want to transfer to
245    * @param _value uint256 the amount of tokens to be transferred
246    */
247   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
248     require(_to != address(0));
249     require(_value <= balances[_from]);
250     require(_value <= allowed[_from][msg.sender]);
251 
252     balances[_from] = balances[_from].sub(_value);
253     balances[_to] = balances[_to].add(_value);
254     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
255     Transfer(_from, _to, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261    *
262    * Beware that changing an allowance with this method brings the risk that someone may use both the old
263    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
264    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
265    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266    * @param _spender The address which will spend the funds.
267    * @param _value The amount of tokens to be spent.
268    */
269   function approve(address _spender, uint256 _value) public returns (bool) {
270     allowed[msg.sender][_spender] = _value;
271     Approval(msg.sender, _spender, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Function to check the amount of tokens that an owner allowed to a spender.
277    * @param _owner address The address which owns the funds.
278    * @param _spender address The address which will spend the funds.
279    * @return A uint256 specifying the amount of tokens still available for the spender.
280    */
281   function allowance(address _owner, address _spender) public view returns (uint256) {
282     return allowed[_owner][_spender];
283   }
284 
285   /**
286    * @dev Increase the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To increment
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _addedValue The amount of tokens to increase the allowance by.
294    */
295   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
296     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
297     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301   /**
302    * @dev Decrease the amount of tokens that an owner allowed to a spender.
303    *
304    * approve should be called when allowed[_spender] == 0. To decrement
305    * allowed value is better to use this function to avoid 2 calls (and wait until
306    * the first transaction is mined)
307    * From MonolithDAO Token.sol
308    * @param _spender The address which will spend the funds.
309    * @param _subtractedValue The amount of tokens to decrease the allowance by.
310    */
311   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
312     uint oldValue = allowed[msg.sender][_spender];
313     if (_subtractedValue > oldValue) {
314       allowed[msg.sender][_spender] = 0;
315     } else {
316       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
317     }
318     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322 }
323 
324 // File: contracts\zeppelin-solidity\token\ERC20\MintableToken.sol
325 
326 /**
327  * @title Mintable token
328  * @dev Simple ERC20 Token example, with mintable token creation
329  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
330  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
331  */
332 contract MintableToken is StandardToken, Ownable {
333   event Mint(address indexed to, uint256 amount);
334   event MintFinished();
335 
336   bool public mintingFinished = false;
337 
338 
339   modifier canMint() {
340     require(!mintingFinished);
341     _;
342   }
343 
344   /**
345    * @dev Function to mint tokens
346    * @param _to The address that will receive the minted tokens.
347    * @param _amount The amount of tokens to mint.
348    * @return A boolean that indicates if the operation was successful.
349    */
350   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
351     totalSupply_ = totalSupply_.add(_amount);
352     balances[_to] = balances[_to].add(_amount);
353     Mint(_to, _amount);
354     Transfer(address(0), _to, _amount);
355     return true;
356   }
357 
358   /**
359    * @dev Function to stop minting new tokens.
360    * @return True if the operation was successful.
361    */
362   function finishMinting() onlyOwner canMint public returns (bool) {
363     mintingFinished = true;
364     MintFinished();
365     return true;
366   }
367 }
368 
369 // File: contracts\DemeterToken.sol
370 
371 /**
372  * @title Demeter Token.
373  * @dev Specific Demeter token.
374  */
375 contract DemeterToken is TokenDestructible, BurnableToken, MintableToken
376 {
377   string public name = "Demeter.life";
378   string public symbol = "DME";
379   uint256 public decimals = 18;
380 
381   /**
382   * @dev transfer the same amount of tokens to up to 100 specified addresses.
383   * If the sender runs out of balance then the entire transaction fails.
384   * @param _to The addresses to transfer to.
385   * @param _value The amount to be transferred to each address.
386   */
387   function airdrop(address[] _to, uint256 _value) public
388   {
389     require(_to.length <= 100);
390     require(balanceOf(msg.sender) >= _value.mul(_to.length));
391 
392     for (uint i = 0; i < _to.length; i++)
393     {
394       if (!transfer(_to[i], _value))
395       {
396         revert();
397       }
398     }
399   }
400 
401 }