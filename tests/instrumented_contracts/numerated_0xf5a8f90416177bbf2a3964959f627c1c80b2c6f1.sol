1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) constant returns (uint256);
53   function transferFrom(address from, address to, uint256 value) returns (bool);
54   function approve(address spender, uint256 value) returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances. 
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of. 
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 }
89 
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) returns (bool) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifing the amount of tokens still avaible for the spender.
145    */
146   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 }
150 
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158   address public owner;
159 
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() {
166     owner = msg.sender;
167   }
168 
169 
170   /**
171    * @dev Throws if called by any account other than the owner.
172    */
173   modifier onlyOwner() {
174     require(msg.sender == owner);
175     _;
176   }
177 
178 
179   /**
180    * @dev Allows the current owner to transfer control of the contract to a newOwner.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) onlyOwner {
184     if (newOwner != address(0)) {
185       owner = newOwner;
186     }
187   }
188 }
189 
190 
191 
192 /**
193  * @title Pausable
194  * @dev Base contract which allows children to implement an emergency stop mechanism.
195  */
196 contract Pausable is Ownable {
197   event Pause();
198   event Unpause();
199 
200   bool public paused = false;
201 
202 
203   /**
204    * @dev modifier to allow actions only when the contract IS paused
205    */
206   modifier whenNotPaused() {
207     require(!paused);
208     _;
209   }
210 
211   /**
212    * @dev modifier to allow actions only when the contract IS NOT paused
213    */
214   modifier whenPaused {
215     require(paused);
216     _;
217   }
218 
219   /**
220    * @dev called by the owner to pause, triggers stopped state
221    */
222   function pause() onlyOwner whenNotPaused returns (bool) {
223     paused = true;
224     Pause();
225     return true;
226   }
227 
228   /**
229    * @dev called by the owner to unpause, returns to normal state
230    */
231   function unpause() onlyOwner whenPaused returns (bool) {
232     paused = false;
233     Unpause();
234     return true;
235   }
236 }
237 
238 
239 /**
240  * Pausable token
241  *
242  * Simple ERC20 Token example, with pausable token creation
243  **/
244 
245 contract PausableToken is StandardToken, Pausable {
246 
247   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
248     return super.transfer(_to, _value);
249   }
250 
251   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
252     return super.transferFrom(_from, _to, _value);
253   }
254 }
255 
256 
257 
258 contract UNLB is PausableToken {
259 
260   string public constant name = "UnolaboToken";
261   string public constant symbol = "UNLB";
262   uint256 public constant decimals = 18;
263 
264   function UNLB() {
265     owner = msg.sender;
266   }
267 
268   function mint(address _x, uint _v) public onlyOwner {
269     balances[_x] += _v;
270     totalSupply += _v;
271     Transfer(0x0, _x, _v);
272   }
273 }
274 
275 
276 
277 contract ICO is Pausable {
278 
279   uint public constant ICO_START_DATE = /*2017-11-27 17:00:00+8*/ 1511773200;
280   uint public constant ICO_END_DATE   = /*2018-04-30 00:17:00+8*/ 1525018620;
281 
282   address public constant admin      = 0xFeC0714C2eE71a486B679d4A3539FA875715e7d8;
283   address public constant teamWallet = 0xf16d5733A31D54e828460AFbf7D60aA803a61C51;
284 
285   UNLB public unlb;
286   bool public isFinished = false;
287 
288   event ForeignBuy(address investor, uint unlbValue, string txHash);
289   
290   function ICO() {
291     owner = admin;
292     unlb = new UNLB();
293     unlb.pause();
294   }
295 
296   function pricePerWei() public constant returns(uint) {
297     if     (now < /*2017-11-28 00:17:00+8*/ 1511799420) return 800.0 * 1 ether;
298     else if(now < /*2017-11-29 00:17:00+8*/ 1511885820) return 750.0 * 1 ether;
299     else if(now < /*2017-12-14 00:17:00+8*/ 1513181820) return 675.0 * 1 ether;
300     else if(now < /*2018-01-10 00:17:00+8*/ 1515514620) return 575.0 * 1 ether;
301     else if(now < /*2018-01-18 00:17:00+8*/ 1516205820) return 537.5 * 1 ether;
302     else                                                return 500.0 * 1 ether;
303   }
304 
305 
306   function() public payable {
307     require(!paused && now >= ICO_START_DATE && now < ICO_END_DATE);
308     uint _tokenVal = (msg.value * pricePerWei()) / 1 ether;
309     unlb.mint(msg.sender, _tokenVal);
310   }
311 
312   function foreignBuy(address _investor, uint _unlbValue, string _txHash) external onlyOwner {
313     require(!paused && now >= ICO_START_DATE && now < ICO_END_DATE);
314     require(_unlbValue > 0);
315     unlb.mint(_investor, _unlbValue);
316     ForeignBuy(_investor, _unlbValue, _txHash);
317   }
318   
319   function finish(address _team, address _fund, address _bounty, address _backers) external onlyOwner {
320     require(now >= ICO_END_DATE && !isFinished);
321     unlb.unpause();
322     isFinished = true;
323 
324     uint _total = unlb.totalSupply() * 100 / (100 - 12 - 15 - 5 - 3);
325     unlb.mint(_team,   (_total * 12) / 100);
326     unlb.mint(_fund,   (_total * 15) / 100);
327     unlb.mint(_bounty, (_total *  5) / 100);
328     unlb.mint(_backers, (_total *  3) / 100);
329   }
330 
331 
332   function withdraw() external onlyOwner {
333     teamWallet.transfer(this.balance);
334   }
335 }