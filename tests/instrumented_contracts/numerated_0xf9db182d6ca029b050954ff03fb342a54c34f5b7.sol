1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     Unpause();
87   }
88 }
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   uint256 public totalSupply;
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 pragma solidity ^0.4.18;
114 
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  */
120 library SafeMath {
121   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122     if (a == 0) {
123       return 0;
124     }
125     uint256 c = a * b;
126     assert(c / a == b);
127     return c;
128   }
129 
130   function div(uint256 a, uint256 b) internal pure returns (uint256) {
131     // assert(b > 0); // Solidity automatically throws when dividing by 0
132     uint256 c = a / b;
133     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134     return c;
135   }
136 
137   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138     assert(b <= a);
139     return a - b;
140   }
141 
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149 
150 /**
151  * @title Basic token
152  * @dev Basic version of StandardToken, with no allowances.
153  */
154 contract BasicToken is ERC20Basic {
155   using SafeMath for uint256;
156 
157   mapping(address => uint256) balances;
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
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
269     uint oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280 
281 /**
282  * @title Mintable token
283  * @dev Simple ERC20 Token example, with mintable token creation
284  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
285  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
286  */
287 
288 contract MintableToken is StandardToken, Ownable {
289   event Mint(address indexed to, uint256 amount);
290   event MintFinished();
291 
292   bool public mintingFinished = false;
293 
294 
295   modifier canMint() {
296     require(!mintingFinished);
297     _;
298   }
299 
300   /**
301    * @dev Function to mint tokens
302    * @param _to The address that will receive the minted tokens.
303    * @param _amount The amount of tokens to mint.
304    * @return A boolean that indicates if the operation was successful.
305    */
306   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
307     totalSupply = totalSupply.add(_amount);
308     balances[_to] = balances[_to].add(_amount);
309     Mint(_to, _amount);
310     Transfer(address(0), _to, _amount);
311     return true;
312   }
313 
314   /**
315    * @dev Function to stop minting new tokens.
316    * @return True if the operation was successful.
317    */
318   function finishMinting() onlyOwner canMint public returns (bool) {
319     mintingFinished = true;
320     MintFinished();
321     return true;
322   }
323 }
324 
325 /**
326  * @title ICOToken
327  * @dev Very simple ERC20 Token example.
328  * `StandardToken` functions.
329  */
330 contract ICOToken is MintableToken, Pausable {
331 
332   string public constant name = "IPCHAIN Token";
333   string public constant symbol = "IP";
334   uint8 public constant decimals = 18;
335 
336 
337   /**
338    * @dev Constructor that gives msg.sender all of existing tokens.
339    */
340   function ICOToken() public {
341   }
342 }