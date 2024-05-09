1 pragma solidity ^0.4.19;
2 
3 // File: contracts/ApproveAndCallFallBack.sol
4 
5 contract ApproveAndCallFallBack {
6     function receiveApproval(
7         address from,
8         uint256 tokens,
9         address token,
10         bytes data) public;
11 }
12 
13 // File: zeppelin-solidity/contracts/math/SafeMath.sol
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
62 
63 /**
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Basic {
69   function totalSupply() public view returns (uint256);
70   function balanceOf(address who) public view returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
123 
124 /**
125  * @title Burnable Token
126  * @dev Token that can be irreversibly burned (destroyed).
127  */
128 contract BurnableToken is BasicToken {
129 
130   event Burn(address indexed burner, uint256 value);
131 
132   /**
133    * @dev Burns a specific amount of tokens.
134    * @param _value The amount of token to be burned.
135    */
136   function burn(uint256 _value) public {
137     require(_value <= balances[msg.sender]);
138     // no need to require value <= totalSupply, since that would imply the
139     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
140 
141     address burner = msg.sender;
142     balances[burner] = balances[burner].sub(_value);
143     totalSupply_ = totalSupply_.sub(_value);
144     Burn(burner, _value);
145   }
146 }
147 
148 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender) public view returns (uint256);
156   function transferFrom(address from, address to, uint256 value) public returns (bool);
157   function approve(address spender, uint256 value) public returns (bool);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
162 
163 contract DetailedERC20 is ERC20 {
164   string public name;
165   string public symbol;
166   uint8 public decimals;
167 
168   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
169     name = _name;
170     symbol = _symbol;
171     decimals = _decimals;
172   }
173 }
174 
175 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183   address public owner;
184 
185 
186   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() public {
194     owner = msg.sender;
195   }
196 
197   /**
198    * @dev Throws if called by any account other than the owner.
199    */
200   modifier onlyOwner() {
201     require(msg.sender == owner);
202     _;
203   }
204 
205   /**
206    * @dev Allows the current owner to transfer control of the contract to a newOwner.
207    * @param newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address newOwner) public onlyOwner {
210     require(newOwner != address(0));
211     OwnershipTransferred(owner, newOwner);
212     owner = newOwner;
213   }
214 
215 }
216 
217 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
218 
219 /**
220  * @title Standard ERC20 token
221  *
222  * @dev Implementation of the basic standard token.
223  * @dev https://github.com/ethereum/EIPs/issues/20
224  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
225  */
226 contract StandardToken is ERC20, BasicToken {
227 
228   mapping (address => mapping (address => uint256)) internal allowed;
229 
230 
231   /**
232    * @dev Transfer tokens from one address to another
233    * @param _from address The address which you want to send tokens from
234    * @param _to address The address which you want to transfer to
235    * @param _value uint256 the amount of tokens to be transferred
236    */
237   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
238     require(_to != address(0));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(address _owner, address _spender) public view returns (uint256) {
272     return allowed[_owner][_spender];
273   }
274 
275   /**
276    * @dev Increase the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To increment
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _addedValue The amount of tokens to increase the allowance by.
284    */
285   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
286     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
287     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312 }
313 
314 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
315 
316 /**
317  * @title Mintable token
318  * @dev Simple ERC20 Token example, with mintable token creation
319  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
320  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
321  */
322 contract MintableToken is StandardToken, Ownable {
323   event Mint(address indexed to, uint256 amount);
324   event MintFinished();
325 
326   bool public mintingFinished = false;
327 
328 
329   modifier canMint() {
330     require(!mintingFinished);
331     _;
332   }
333 
334   /**
335    * @dev Function to mint tokens
336    * @param _to The address that will receive the minted tokens.
337    * @param _amount The amount of tokens to mint.
338    * @return A boolean that indicates if the operation was successful.
339    */
340   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
341     totalSupply_ = totalSupply_.add(_amount);
342     balances[_to] = balances[_to].add(_amount);
343     Mint(_to, _amount);
344     Transfer(address(0), _to, _amount);
345     return true;
346   }
347 
348   /**
349    * @dev Function to stop minting new tokens.
350    * @return True if the operation was successful.
351    */
352   function finishMinting() onlyOwner canMint public returns (bool) {
353     mintingFinished = true;
354     MintFinished();
355     return true;
356   }
357 }
358 
359 // File: contracts/SkillChainToken.sol
360 
361 contract SkillChainToken is DetailedERC20, MintableToken, BurnableToken {
362 
363     modifier canTransfer() {
364         require(mintingFinished);
365         _;
366     }
367 
368     function SkillChainToken() DetailedERC20("Skillchain", "SKI", 18) public {}
369 
370     function transfer(address _to, uint _value) canTransfer public returns (bool) {
371         return super.transfer(_to, _value);
372     }
373 
374     function transferFrom(address _from, address _to, uint _value) canTransfer public returns (bool) {
375         return super.transferFrom(_from, _to, _value);
376     }
377 
378     function approveAndCall(address _spender, uint256 _tokens, bytes _data) public returns (bool success) {
379         approve(_spender, _tokens);
380         ApproveAndCallFallBack(_spender).receiveApproval(
381             msg.sender,
382             _tokens,
383             this,
384             _data
385         );
386         return true;
387     }
388 
389     function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) {
390         return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
391     }
392 }