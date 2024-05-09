1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/Ownership/Ownable.sol
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
45 // File: zeppelin-solidity/contracts/Ownership/Contactable.sol
46 
47 /**
48  * @title Contactable token
49  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
50  * contact information.
51  */
52 contract Contactable is Ownable {
53 
54   string public contactInformation;
55 
56   /**
57     * @dev Allows the owner to set a string with their contact information.
58     * @param info The contact information to attach to the contract.
59     */
60   function setContactInformation(string info) onlyOwner public {
61     contactInformation = info;
62   }
63 }
64 
65 // File: zeppelin-solidity/contracts/math/SafeMath.sol
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, throws on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0;
79     }
80     uint256 c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return c;
93   }
94 
95   /**
96   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256) {
107     uint256 c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances.
132  */
133 contract BasicToken is ERC20Basic {
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) balances;
137 
138   uint256 totalSupply_;
139 
140   /**
141   * @dev total number of tokens in existence
142   */
143   function totalSupply() public view returns (uint256) {
144     return totalSupply_;
145   }
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[msg.sender]);
155 
156     // SafeMath.sub will throw if there is not enough balance.
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256 balance) {
169     return balances[_owner];
170   }
171 
172 }
173 
174 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
175 
176 /**
177  * @title ERC20 interface
178  * @dev see https://github.com/ethereum/EIPs/issues/20
179  */
180 contract ERC20 is ERC20Basic {
181   function allowance(address owner, address spender) public view returns (uint256);
182   function transferFrom(address from, address to, uint256 value) public returns (bool);
183   function approve(address spender, uint256 value) public returns (bool);
184   event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 
187 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _value uint256 the amount of tokens to be transferred
206    */
207   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
208     require(_to != address(0));
209     require(_value <= balances[_from]);
210     require(_value <= allowed[_from][msg.sender]);
211 
212     balances[_from] = balances[_from].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
215     Transfer(_from, _to, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    *
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param _spender The address which will spend the funds.
227    * @param _value The amount of tokens to be spent.
228    */
229   function approve(address _spender, uint256 _value) public returns (bool) {
230     allowed[msg.sender][_spender] = _value;
231     Approval(msg.sender, _spender, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Function to check the amount of tokens that an owner allowed to a spender.
237    * @param _owner address The address which owns the funds.
238    * @param _spender address The address which will spend the funds.
239    * @return A uint256 specifying the amount of tokens still available for the spender.
240    */
241   function allowance(address _owner, address _spender) public view returns (uint256) {
242     return allowed[_owner][_spender];
243   }
244 
245   /**
246    * @dev Increase the amount of tokens that an owner allowed to a spender.
247    *
248    * approve should be called when allowed[_spender] == 0. To increment
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _addedValue The amount of tokens to increase the allowance by.
254    */
255   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
256     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Decrease the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To decrement
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _subtractedValue The amount of tokens to decrease the allowance by.
270    */
271   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
272     uint oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue > oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
285 
286 /**
287  * @title Mintable token
288  * @dev Simple ERC20 Token example, with mintable token creation
289  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
290  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
291  */
292 contract MintableToken is StandardToken, Ownable {
293   event Mint(address indexed to, uint256 amount);
294   event MintFinished();
295 
296   bool public mintingFinished = false;
297 
298 
299   modifier canMint() {
300     require(!mintingFinished);
301     _;
302   }
303 
304   /**
305    * @dev Function to mint tokens
306    * @param _to The address that will receive the minted tokens.
307    * @param _amount The amount of tokens to mint.
308    * @return A boolean that indicates if the operation was successful.
309    */
310   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
311     totalSupply_ = totalSupply_.add(_amount);
312     balances[_to] = balances[_to].add(_amount);
313     Mint(_to, _amount);
314     Transfer(address(0), _to, _amount);
315     return true;
316   }
317 
318   /**
319    * @dev Function to stop minting new tokens.
320    * @return True if the operation was successful.
321    */
322   function finishMinting() onlyOwner canMint public returns (bool) {
323     mintingFinished = true;
324     MintFinished();
325     return true;
326   }
327 }
328 
329 // File: contracts/RootsSaleToken.sol
330 
331 contract RootsSaleToken is Contactable, MintableToken {
332 
333     string constant public name = "ROOTS Sale Token";
334     string constant public symbol = "ROOTSSale";
335     uint constant public decimals = 18;
336 
337     bool public isTransferable = false;
338 
339     function transfer(address _to, uint _value) public returns (bool) {
340         require(isTransferable);
341         return false;
342     }
343 
344     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
345         require(isTransferable);
346         return false;
347     }
348 
349     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
350         require(isTransferable);
351         return false;
352     }
353 
354     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {
355         require(isTransferable);
356         return false;
357     }
358 }