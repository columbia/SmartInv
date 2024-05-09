1 pragma solidity ^0.4.23;
2 
3 // File: contracts/LegalDocument.sol
4 
5 /**
6  * @title LegalDocument
7  * @dev Basic version of a legal contract, allowing the owner to save a legal document and associate the governing law
8  * contact information.
9  */
10 contract LegalDocument {
11 
12     string public documentIPFSHash;
13     string public governingLaw;
14 
15     /**
16       * @dev Constructs a document
17       * @param ipfsHash The IPFS hash to the human readable legal contract.
18       * @param law The governing law
19       */
20     constructor(string ipfsHash, string law) public {
21         documentIPFSHash = ipfsHash;
22         governingLaw = law;
23     }
24 
25 }
26 
27 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   constructor() public {
46     owner = msg.sender;
47   }
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     emit OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath {
76 
77   /**
78   * @dev Multiplies two numbers, throws on overflow.
79   */
80   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
81     if (a == 0) {
82       return 0;
83     }
84     c = a * b;
85     assert(c / a == b);
86     return c;
87   }
88 
89   /**
90   * @dev Integer division of two numbers, truncating the quotient.
91   */
92   function div(uint256 a, uint256 b) internal pure returns (uint256) {
93     // assert(b > 0); // Solidity automatically throws when dividing by 0
94     // uint256 c = a / b;
95     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96     return a / b;
97   }
98 
99   /**
100   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
101   */
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   /**
108   * @dev Adds two numbers, throws on overflow.
109   */
110   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
111     c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 
117 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
118 
119 /**
120  * @title ERC20Basic
121  * @dev Simpler version of ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/179
123  */
124 contract ERC20Basic {
125   function totalSupply() public view returns (uint256);
126   function balanceOf(address who) public view returns (uint256);
127   function transfer(address to, uint256 value) public returns (bool);
128   event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
132 
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic {
138   using SafeMath for uint256;
139 
140   mapping(address => uint256) balances;
141 
142   uint256 totalSupply_;
143 
144   /**
145   * @dev total number of tokens in existence
146   */
147   function totalSupply() public view returns (uint256) {
148     return totalSupply_;
149   }
150 
151   /**
152   * @dev transfer token for a specified address
153   * @param _to The address to transfer to.
154   * @param _value The amount to be transferred.
155   */
156   function transfer(address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[msg.sender]);
159 
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     emit Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param _owner The address to query the the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address _owner) public view returns (uint256) {
172     return balances[_owner];
173   }
174 
175 }
176 
177 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
178 
179 /**
180  * @title ERC20 interface
181  * @dev see https://github.com/ethereum/EIPs/issues/20
182  */
183 contract ERC20 is ERC20Basic {
184   function allowance(address owner, address spender) public view returns (uint256);
185   function transferFrom(address from, address to, uint256 value) public returns (bool);
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
191 
192 /**
193  * @title Standard ERC20 token
194  *
195  * @dev Implementation of the basic standard token.
196  * @dev https://github.com/ethereum/EIPs/issues/20
197  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
198  */
199 contract StandardToken is ERC20, BasicToken {
200 
201   mapping (address => mapping (address => uint256)) internal allowed;
202 
203 
204   /**
205    * @dev Transfer tokens from one address to another
206    * @param _from address The address which you want to send tokens from
207    * @param _to address The address which you want to transfer to
208    * @param _value uint256 the amount of tokens to be transferred
209    */
210   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[_from]);
213     require(_value <= allowed[_from][msg.sender]);
214 
215     balances[_from] = balances[_from].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218     emit Transfer(_from, _to, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224    *
225    * Beware that changing an allowance with this method brings the risk that someone may use both the old
226    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229    * @param _spender The address which will spend the funds.
230    * @param _value The amount of tokens to be spent.
231    */
232   function approve(address _spender, uint256 _value) public returns (bool) {
233     allowed[msg.sender][_spender] = _value;
234     emit Approval(msg.sender, _spender, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Function to check the amount of tokens that an owner allowed to a spender.
240    * @param _owner address The address which owns the funds.
241    * @param _spender address The address which will spend the funds.
242    * @return A uint256 specifying the amount of tokens still available for the spender.
243    */
244   function allowance(address _owner, address _spender) public view returns (uint256) {
245     return allowed[_owner][_spender];
246   }
247 
248   /**
249    * @dev Increase the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To increment
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _addedValue The amount of tokens to increase the allowance by.
257    */
258   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
259     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
260     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264   /**
265    * @dev Decrease the amount of tokens that an owner allowed to a spender.
266    *
267    * approve should be called when allowed[_spender] == 0. To decrement
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param _spender The address which will spend the funds.
272    * @param _subtractedValue The amount of tokens to decrease the allowance by.
273    */
274   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
275     uint oldValue = allowed[msg.sender][_spender];
276     if (_subtractedValue > oldValue) {
277       allowed[msg.sender][_spender] = 0;
278     } else {
279       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
280     }
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285 }
286 
287 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
288 
289 /**
290  * @title Mintable token
291  * @dev Simple ERC20 Token example, with mintable token creation
292  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
293  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
294  */
295 contract MintableToken is StandardToken, Ownable {
296   event Mint(address indexed to, uint256 amount);
297   event MintFinished();
298 
299   bool public mintingFinished = false;
300 
301 
302   modifier canMint() {
303     require(!mintingFinished);
304     _;
305   }
306 
307   /**
308    * @dev Function to mint tokens
309    * @param _to The address that will receive the minted tokens.
310    * @param _amount The amount of tokens to mint.
311    * @return A boolean that indicates if the operation was successful.
312    */
313   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
314     totalSupply_ = totalSupply_.add(_amount);
315     balances[_to] = balances[_to].add(_amount);
316     emit Mint(_to, _amount);
317     emit Transfer(address(0), _to, _amount);
318     return true;
319   }
320 
321   /**
322    * @dev Function to stop minting new tokens.
323    * @return True if the operation was successful.
324    */
325   function finishMinting() onlyOwner canMint public returns (bool) {
326     mintingFinished = true;
327     emit MintFinished();
328     return true;
329   }
330 }
331 
332 // File: contracts/P4RTYToken.sol
333 
334 /**
335  * @dev Very simple ERC20 Token that can be minted.
336  * It is meant to be used in a crowdsale contract.
337  */
338 contract P4RTYToken is MintableToken {
339 
340     // solium-disable-next-line uppercase
341     string public constant name = "P4RTY";
342     string public constant symbol = "P4RTY"; // solium-disable-line uppercase
343     uint8 public constant decimals = 18; // solium-disable-line uppercase
344     address public legalContract;
345 
346     /**
347      * Burnable Token
348      * @dev Token that can be irreversibly burned (destroyed).
349      */
350     event Burn(address indexed burner, uint256 value);
351 
352 
353     /**
354      * @dev Legal disclaimer/agreement associated with token
355      * @param legal Address of the legal contract
356      */
357     constructor(address legal) Ownable() public {
358         legalContract = legal;
359     }
360 
361     /**
362      * @dev Burns a specific amount of tokens.
363      * @param _value The amount of token to be burned.
364      */
365     function burn(uint256 _value) public {
366         _burn(msg.sender, _value);
367     }
368 
369     function _burn(address _who, uint256 _value) internal {
370         require(_value <= balances[_who]);
371         // no need to require value <= totalSupply, since that would imply the
372         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
373 
374         balances[_who] = balances[_who].sub(_value);
375         totalSupply_ = totalSupply_.sub(_value);
376         emit Burn(_who, _value);
377         emit Transfer(_who, address(0), _value);
378     }
379 
380     /**
381      * @dev Override so that minting cannot be accidentally terminated
382      */
383     function finishMinting() onlyOwner canMint public returns (bool) {
384         return false;
385     }
386 
387 }