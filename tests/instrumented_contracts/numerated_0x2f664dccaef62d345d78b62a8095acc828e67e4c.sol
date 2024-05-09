1 pragma solidity ^0.4.19;
2 
3 // File: contracts/utility/ContractReceiverInterface.sol
4 
5 contract ContractReceiverInterface {
6     function receiveApproval(
7         address from,
8         uint256 _amount,
9         address _token,
10         bytes _data) public;
11 }
12 
13 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: contracts/utility/SafeContract.sol
70 
71 contract SafeContract is Ownable {
72 
73     /**
74      * @notice Owner can transfer out any accidentally sent ERC20 tokens
75      */
76     function transferAnyERC20Token(address _tokenAddress, uint256 _tokens, address _beneficiary) public onlyOwner returns (bool success) {
77         return ERC20Basic(_tokenAddress).transfer(_beneficiary, _tokens);
78     }
79 }
80 
81 // File: zeppelin-solidity/contracts/math/SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0) {
94       return 0;
95     }
96     uint256 c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers, truncating the quotient.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   /**
112   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   uint256 totalSupply_;
141 
142   /**
143   * @dev total number of tokens in existence
144   */
145   function totalSupply() public view returns (uint256) {
146     return totalSupply_;
147   }
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[msg.sender]);
157 
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256 balance) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
177 
178 /**
179  * @title Burnable Token
180  * @dev Token that can be irreversibly burned (destroyed).
181  */
182 contract BurnableToken is BasicToken {
183 
184   event Burn(address indexed burner, uint256 value);
185 
186   /**
187    * @dev Burns a specific amount of tokens.
188    * @param _value The amount of token to be burned.
189    */
190   function burn(uint256 _value) public {
191     require(_value <= balances[msg.sender]);
192     // no need to require value <= totalSupply, since that would imply the
193     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
194 
195     address burner = msg.sender;
196     balances[burner] = balances[burner].sub(_value);
197     totalSupply_ = totalSupply_.sub(_value);
198     Burn(burner, _value);
199   }
200 }
201 
202 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
203 
204 /**
205  * @title ERC20 interface
206  * @dev see https://github.com/ethereum/EIPs/issues/20
207  */
208 contract ERC20 is ERC20Basic {
209   function allowance(address owner, address spender) public view returns (uint256);
210   function transferFrom(address from, address to, uint256 value) public returns (bool);
211   function approve(address spender, uint256 value) public returns (bool);
212   event Approval(address indexed owner, address indexed spender, uint256 value);
213 }
214 
215 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
216 
217 contract DetailedERC20 is ERC20 {
218   string public name;
219   string public symbol;
220   uint8 public decimals;
221 
222   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
223     name = _name;
224     symbol = _symbol;
225     decimals = _decimals;
226   }
227 }
228 
229 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
230 
231 /**
232  * @title Standard ERC20 token
233  *
234  * @dev Implementation of the basic standard token.
235  * @dev https://github.com/ethereum/EIPs/issues/20
236  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
237  */
238 contract StandardToken is ERC20, BasicToken {
239 
240   mapping (address => mapping (address => uint256)) internal allowed;
241 
242 
243   /**
244    * @dev Transfer tokens from one address to another
245    * @param _from address The address which you want to send tokens from
246    * @param _to address The address which you want to transfer to
247    * @param _value uint256 the amount of tokens to be transferred
248    */
249   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
250     require(_to != address(0));
251     require(_value <= balances[_from]);
252     require(_value <= allowed[_from][msg.sender]);
253 
254     balances[_from] = balances[_from].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257     Transfer(_from, _to, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263    *
264    * Beware that changing an allowance with this method brings the risk that someone may use both the old
265    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271   function approve(address _spender, uint256 _value) public returns (bool) {
272     allowed[msg.sender][_spender] = _value;
273     Approval(msg.sender, _spender, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Function to check the amount of tokens that an owner allowed to a spender.
279    * @param _owner address The address which owns the funds.
280    * @param _spender address The address which will spend the funds.
281    * @return A uint256 specifying the amount of tokens still available for the spender.
282    */
283   function allowance(address _owner, address _spender) public view returns (uint256) {
284     return allowed[_owner][_spender];
285   }
286 
287   /**
288    * @dev Increase the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To increment
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _addedValue The amount of tokens to increase the allowance by.
296    */
297   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
298     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
299     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    *
306    * approve should be called when allowed[_spender] == 0. To decrement
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param _spender The address which will spend the funds.
311    * @param _subtractedValue The amount of tokens to decrease the allowance by.
312    */
313   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
314     uint oldValue = allowed[msg.sender][_spender];
315     if (_subtractedValue > oldValue) {
316       allowed[msg.sender][_spender] = 0;
317     } else {
318       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
319     }
320     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321     return true;
322   }
323 
324 }
325 
326 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
327 
328 /**
329  * @title Mintable token
330  * @dev Simple ERC20 Token example, with mintable token creation
331  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
332  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
333  */
334 contract MintableToken is StandardToken, Ownable {
335   event Mint(address indexed to, uint256 amount);
336   event MintFinished();
337 
338   bool public mintingFinished = false;
339 
340 
341   modifier canMint() {
342     require(!mintingFinished);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
353     totalSupply_ = totalSupply_.add(_amount);
354     balances[_to] = balances[_to].add(_amount);
355     Mint(_to, _amount);
356     Transfer(address(0), _to, _amount);
357     return true;
358   }
359 
360   /**
361    * @dev Function to stop minting new tokens.
362    * @return True if the operation was successful.
363    */
364   function finishMinting() onlyOwner canMint public returns (bool) {
365     mintingFinished = true;
366     MintFinished();
367     return true;
368   }
369 }
370 
371 // File: contracts/token/FriendsFingersToken.sol
372 
373 /**
374  * @title FriendsFingersToken
375  */
376 contract FriendsFingersToken is DetailedERC20, MintableToken, BurnableToken, SafeContract {
377 
378     address public builder;
379 
380     modifier canTransfer() {
381         require(mintingFinished);
382         _;
383     }
384 
385     function FriendsFingersToken(
386         string _name,
387         string _symbol,
388         uint8 _decimals
389     )
390     DetailedERC20 (_name, _symbol, _decimals)
391     public
392     {
393         builder = owner;
394     }
395 
396     function transfer(address _to, uint _value) canTransfer public returns (bool) {
397         return super.transfer(_to, _value);
398     }
399 
400     function transferFrom(address _from, address _to, uint _value) canTransfer public returns (bool) {
401         return super.transferFrom(_from, _to, _value);
402     }
403 
404     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
405         require(approve(_spender, _amount));
406 
407         ContractReceiverInterface(_spender).receiveApproval(
408             msg.sender,
409             _amount,
410             this,
411             _extraData
412         );
413 
414         return true;
415     }
416 
417 }