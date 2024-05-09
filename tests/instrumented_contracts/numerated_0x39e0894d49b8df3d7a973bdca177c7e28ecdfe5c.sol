1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
45 // File: contracts/Distributable.sol
46 
47 /**
48  * @title Distributable
49  * @dev The Distribution contract has multi dealer address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Distributable is Ownable {
53   mapping(address => bool) public dealership;
54   event Trust(address dealer);
55   event Distrust(address dealer);
56 
57   modifier onlyDealers() {
58     require(dealership[msg.sender]);
59     _;
60   }
61 
62   function trust(address newDealer) public onlyOwner {
63     require(newDealer != address(0));
64     require(!dealership[newDealer]);
65     dealership[newDealer] = true;
66     Trust(newDealer);
67   }
68 
69   function distrust(address dealer) public onlyOwner {
70     require(dealership[dealer]);
71     dealership[dealer] = false;
72     Distrust(dealer);
73   }
74 
75 }
76 
77 // File: zeppelin-solidity/contracts/math/SafeMath.sol
78 
79 /**
80  * @title SafeMath
81  * @dev Math operations with safety checks that throw on error
82  */
83 library SafeMath {
84 
85   /**
86   * @dev Multiplies two numbers, throws on overflow.
87   */
88   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89     if (a == 0) {
90       return 0;
91     }
92     uint256 c = a * b;
93     assert(c / a == b);
94     return c;
95   }
96 
97   /**
98   * @dev Integer division of two numbers, truncating the quotient.
99   */
100   function div(uint256 a, uint256 b) internal pure returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return c;
105   }
106 
107   /**
108   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
109   */
110   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111     assert(b <= a);
112     return a - b;
113   }
114 
115   /**
116   * @dev Adds two numbers, throws on overflow.
117   */
118   function add(uint256 a, uint256 b) internal pure returns (uint256) {
119     uint256 c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
126 
127 /**
128  * @title ERC20Basic
129  * @dev Simpler version of ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/179
131  */
132 contract ERC20Basic {
133   function totalSupply() public view returns (uint256);
134   function balanceOf(address who) public view returns (uint256);
135   function transfer(address to, uint256 value) public returns (bool);
136   event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
140 
141 /**
142  * @title Basic token
143  * @dev Basic version of StandardToken, with no allowances.
144  */
145 contract BasicToken is ERC20Basic {
146   using SafeMath for uint256;
147 
148   mapping(address => uint256) balances;
149 
150   uint256 totalSupply_;
151 
152   /**
153   * @dev total number of tokens in existence
154   */
155   function totalSupply() public view returns (uint256) {
156     return totalSupply_;
157   }
158 
159   /**
160   * @dev transfer token for a specified address
161   * @param _to The address to transfer to.
162   * @param _value The amount to be transferred.
163   */
164   function transfer(address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[msg.sender]);
167 
168     // SafeMath.sub will throw if there is not enough balance.
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     Transfer(msg.sender, _to, _value);
172     return true;
173   }
174 
175   /**
176   * @dev Gets the balance of the specified address.
177   * @param _owner The address to query the the balance of.
178   * @return An uint256 representing the amount owned by the passed address.
179   */
180   function balanceOf(address _owner) public view returns (uint256 balance) {
181     return balances[_owner];
182   }
183 
184 }
185 
186 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
187 
188 /**
189  * @title ERC20 interface
190  * @dev see https://github.com/ethereum/EIPs/issues/20
191  */
192 contract ERC20 is ERC20Basic {
193   function allowance(address owner, address spender) public view returns (uint256);
194   function transferFrom(address from, address to, uint256 value) public returns (bool);
195   function approve(address spender, uint256 value) public returns (bool);
196   event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * @dev https://github.com/ethereum/EIPs/issues/20
206  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207  */
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212 
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 // File: contracts/DistributionToken.sol
297 
298 contract DistributionToken is StandardToken, Distributable {
299   uint256 public decimals = 18;
300   
301   event Mint(address indexed dealer, address indexed to, uint256 value);
302   event Burn(address indexed dealer, address indexed from, uint256 value);
303 
304    /**
305    * @dev to mint tokens
306    * @param _to The address that will recieve the minted tokens.
307    * @param _value The amount of tokens to mint.
308    * @return A boolean that indicates if the operation was successful.
309    */
310   function mint(address _to, uint256 _value) public onlyDealers returns (bool) {
311     totalSupply_ = totalSupply_.add(_value);
312     balances[_to] = balances[_to].add(_value);
313     Mint(msg.sender, _to, _value);
314     Transfer(address(0), _to, _value);
315     return true;
316   }
317 
318    /**
319    * @dev to burn tokens
320    * @param _from The address that will decrease tokens for burn.
321    * @param _value The amount of tokens to burn.
322    * @return A boolean that indicates if the operation was successful.
323    */
324   function burn(address _from, uint256 _value) public onlyDealers returns (bool) {
325     totalSupply_ = totalSupply_.sub(_value);
326     balances[_from] = balances[_from].sub(_value);
327     Burn(msg.sender, _from, _value);
328     Transfer(_from, address(0), _value);
329     return true;
330   }
331 
332 }
333 
334 // File: contracts/deploy/LeCarboneInitialToken.sol
335 
336 contract LeCarboneInitialToken is Ownable {
337   using SafeMath for uint256;
338 
339   DistributionToken public token;
340   bool public initiated = false;
341   address public privateSaleAddress = 0x2F196AdBeD104ceB69C86BCD06625a9F1A6cb1aF;
342   uint256 public privateSaleAmount = 1800000;
343 
344   address public publicSaleAddress = 0xC99c001a806015a1CEa0c9B5e7f72c3d05f2a7b6;
345   uint256 public publicSaleAmount = 7200000;
346 
347   function LeCarboneInitialToken(DistributionToken _token) public {
348     require(_token != address(0));
349     token = _token;
350   }
351 
352   function initial() onlyOwner public {
353     require(!initiated);
354     initiated = true;
355     uint256 decimals = token.decimals();
356     uint256 unitRatio = 10**decimals;
357 
358     token.mint(privateSaleAddress, privateSaleAmount.mul(unitRatio));
359     token.mint(publicSaleAddress, publicSaleAmount.mul(unitRatio));
360   }
361 }