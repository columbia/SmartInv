1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 // File: zeppelin-solidity/contracts/math/SafeMath.sol
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
75     // benefit is lost if 'b' is also tested.
76     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77     if (a == 0) {
78       return 0;
79     }
80 
81     c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     // uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return a / b;
94   }
95 
96   /**
97   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
115 
116 /**
117  * @title ERC20Basic
118  * @dev Simpler version of ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/179
120  */
121 contract ERC20Basic {
122   function totalSupply() public view returns (uint256);
123   function balanceOf(address who) public view returns (uint256);
124   function transfer(address to, uint256 value) public returns (bool);
125   event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   uint256 totalSupply_;
140 
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[msg.sender]);
156 
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     emit Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256) {
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
181   function allowance(address owner, address spender)
182     public view returns (uint256);
183 
184   function transferFrom(address from, address to, uint256 value)
185     public returns (bool);
186 
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(
189     address indexed owner,
190     address indexed spender,
191     uint256 value
192   );
193 }
194 
195 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203  */
204 contract StandardToken is ERC20, BasicToken {
205 
206   mapping (address => mapping (address => uint256)) internal allowed;
207 
208 
209   /**
210    * @dev Transfer tokens from one address to another
211    * @param _from address The address which you want to send tokens from
212    * @param _to address The address which you want to transfer to
213    * @param _value uint256 the amount of tokens to be transferred
214    */
215   function transferFrom(
216     address _from,
217     address _to,
218     uint256 _value
219   )
220     public
221     returns (bool)
222   {
223     require(_to != address(0));
224     require(_value <= balances[_from]);
225     require(_value <= allowed[_from][msg.sender]);
226 
227     balances[_from] = balances[_from].sub(_value);
228     balances[_to] = balances[_to].add(_value);
229     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
230     emit Transfer(_from, _to, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    *
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     allowed[msg.sender][_spender] = _value;
246     emit Approval(msg.sender, _spender, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Function to check the amount of tokens that an owner allowed to a spender.
252    * @param _owner address The address which owns the funds.
253    * @param _spender address The address which will spend the funds.
254    * @return A uint256 specifying the amount of tokens still available for the spender.
255    */
256   function allowance(
257     address _owner,
258     address _spender
259    )
260     public
261     view
262     returns (uint256)
263   {
264     return allowed[_owner][_spender];
265   }
266 
267   /**
268    * @dev Increase the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _addedValue The amount of tokens to increase the allowance by.
276    */
277   function increaseApproval(
278     address _spender,
279     uint _addedValue
280   )
281     public
282     returns (bool)
283   {
284     allowed[msg.sender][_spender] = (
285       allowed[msg.sender][_spender].add(_addedValue));
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290   /**
291    * @dev Decrease the amount of tokens that an owner allowed to a spender.
292    *
293    * approve should be called when allowed[_spender] == 0. To decrement
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _subtractedValue The amount of tokens to decrease the allowance by.
299    */
300   function decreaseApproval(
301     address _spender,
302     uint _subtractedValue
303   )
304     public
305     returns (bool)
306   {
307     uint oldValue = allowed[msg.sender][_spender];
308     if (_subtractedValue > oldValue) {
309       allowed[msg.sender][_spender] = 0;
310     } else {
311       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312     }
313     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317 }
318 
319 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
320 
321 /**
322  * @title Mintable token
323  * @dev Simple ERC20 Token example, with mintable token creation
324  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
325  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
326  */
327 contract MintableToken is StandardToken, Ownable {
328   event Mint(address indexed to, uint256 amount);
329   event MintFinished();
330 
331   bool public mintingFinished = false;
332 
333 
334   modifier canMint() {
335     require(!mintingFinished);
336     _;
337   }
338 
339   modifier hasMintPermission() {
340     require(msg.sender == owner);
341     _;
342   }
343 
344   /**
345    * @dev Function to mint tokens
346    * @param _to The address that will receive the minted tokens.
347    * @param _amount The amount of tokens to mint.
348    * @return A boolean that indicates if the operation was successful.
349    */
350   function mint(
351     address _to,
352     uint256 _amount
353   )
354     hasMintPermission
355     canMint
356     public
357     returns (bool)
358   {
359     totalSupply_ = totalSupply_.add(_amount);
360     balances[_to] = balances[_to].add(_amount);
361     emit Mint(_to, _amount);
362     emit Transfer(address(0), _to, _amount);
363     return true;
364   }
365 
366   /**
367    * @dev Function to stop minting new tokens.
368    * @return True if the operation was successful.
369    */
370   function finishMinting() onlyOwner canMint public returns (bool) {
371     mintingFinished = true;
372     emit MintFinished();
373     return true;
374   }
375 }
376 
377 // File: contracts/SitisTradeToken.sol
378 
379 contract SitisTradeToken is MintableToken {
380     string public constant name = "Sitis Trade Token";
381     string public constant symbol = "STT";
382     uint8 public constant decimals = 18;
383 }