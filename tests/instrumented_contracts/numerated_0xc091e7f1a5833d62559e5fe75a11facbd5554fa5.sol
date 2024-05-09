1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12   address public owner;
13   address public ownerCandidate;
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Delegate contract to another person.
33    * @param candidate New owner address
34    */
35   function setOwnerCandidate(address candidate) external onlyOwner {
36     ownerCandidate = candidate;
37   }
38 
39   /**
40    * @dev Person should decide does he want to became a new owner. It is necessary
41    * to protect that some contract or stranger became new owner.
42    */
43   function approveNewOwner() external {
44     address candidate = ownerCandidate;
45     require(msg.sender == candidate, "Only owner candidate can use this function");
46     emit OwnershipTransferred(owner, candidate);
47     owner = candidate;
48     ownerCandidate = 0x0;
49   }
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that revert on error
55  */
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, reverts on overflow.
60   */
61   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
62     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63     // benefit is lost if 'b' is also tested.
64     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
65     if (_a == 0) {
66       return 0;
67     }
68 
69     uint256 c = _a * _b;
70     require(c / _a == _b);
71 
72     return c;
73   }
74 
75   /**
76   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
77   */
78   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
79     require(_b > 0); // Solidity only automatically asserts when dividing by 0
80     uint256 c = _a / _b;
81     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
82 
83     return c;
84   }
85 
86   /**
87   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
90     require(_b <= _a);
91     uint256 c = _a - _b;
92 
93     return c;
94   }
95 
96   /**
97   * @dev Adds two numbers, reverts on overflow.
98   */
99   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
100     uint256 c = _a + _b;
101     require(c >= _a);
102 
103     return c;
104   }
105 
106   /**
107   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
108   * reverts when dividing by zero.
109   */
110   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111     require(b != 0);
112     return a % b;
113   }
114 }
115 
116 contract IERC20Token {
117   function totalSupply() public view returns (uint256);
118   function balanceOf(address _who) public view returns (uint256);
119   function allowance(address _owner, address _spender) public view returns (uint256);
120   function transfer(address _to, uint256 _value) public returns (bool);
121   function approve(address _spender, uint256 _value) public returns (bool);
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
123 
124   event Transfer(
125     address indexed from,
126     address indexed to,
127     uint256 value
128   );
129 
130   event Approval(
131     address indexed owner,
132     address indexed spender,
133     uint256 value
134   );
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
142  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract CFGToken is IERC20Token, Ownable {
145 
146   using SafeMath for uint256;
147 
148   mapping(address => uint256) private balances;
149   mapping(address => mapping(address => uint256)) private allowed;
150 
151   string public symbol;
152   string public name;
153   uint8 public decimals;
154   uint256 private totalSupply_;
155 
156   bool public initialized = false;
157   uint256 public lockedUntil;
158   address public hotWallet;
159   address public reserveWallet;
160   address public teamWallet;
161   address public advisersWallet;
162 
163   constructor() public {
164     symbol = "CFGT";
165     name = "Cardonio Financial Group Token";
166     decimals = 18;
167   }
168 
169   function init(address _hotWallet, address _reserveWallet, address _teamWallet, address _advisersWallet) external onlyOwner {
170     require(!initialized, "Already initialized");
171 
172     lockedUntil = now + 730 days; // 2 years
173     hotWallet = _hotWallet;
174     reserveWallet = _reserveWallet;
175     teamWallet = _teamWallet;
176     advisersWallet = _advisersWallet;
177 
178     uint256 hotSupply      = 380000000e18;
179     uint256 reserveSupply  = 100000000e18;
180     uint256 teamSupply     =  45000000e18;
181     uint256 advisersSupply =  25000000e18;
182 
183     balances[hotWallet] = hotSupply;
184     balances[reserveWallet] = reserveSupply;
185     balances[teamWallet] = teamSupply;
186     balances[advisersWallet] = advisersSupply;
187 
188     totalSupply_ = hotSupply.add(reserveSupply).add(teamSupply).add(advisersSupply);
189     initialized = true;
190   }
191 
192   /**
193   * @dev Total number of tokens in existence
194   */
195   function totalSupply() public view returns (uint256) {
196     return totalSupply_;
197   }
198 
199   /**
200   * @dev Gets the balance of the specified address.
201   * @param _owner The address to query the the balance of.
202   * @return An uint256 representing the amount owned by the passed address.
203   */
204   function balanceOf(address _owner) public view returns (uint256) {
205     return balances[_owner];
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(address _owner, address _spender) public view returns (uint256) {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219   * @dev Transfer token for a specified address
220   * @param _to The address to transfer to.
221   * @param _value The amount to be transferred.
222   */
223   function transfer(address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0), "Receiver address should be specified");
225     require(initialized, "Not initialized yet");
226     require(_value <= balances[msg.sender], "Not enough funds");
227 
228     if (teamWallet == msg.sender && lockedUntil > now) {
229       revert("Tokens locked");
230     }
231 
232     balances[msg.sender] = balances[msg.sender].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     emit Transfer(msg.sender, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    * Beware that changing an allowance with this method brings the risk that someone may use both the old
241    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public returns (bool) {
248     require(msg.sender != _spender, "Owner can not approve to himself");
249     require(initialized, "Not initialized yet");
250 
251     allowed[msg.sender][_spender] = _value;
252     emit Approval(msg.sender, _spender, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Transfer tokens from one address to another
258    * @param _from address The address which you want to send tokens from
259    * @param _to address The address which you want to transfer to
260    * @param _value uint256 the amount of tokens to be transferred
261    */
262   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
263     require(_to != address(0), "Receiver address should be specified");
264     require(initialized, "Not initialized yet");
265     require(_value <= balances[_from], "Not enough funds");
266     require(_value <= allowed[_from][msg.sender], "Not enough allowance");
267 
268     if (teamWallet == _from && lockedUntil > now) {
269       revert("Tokens locked");
270     }
271 
272     balances[_from] = balances[_from].sub(_value);
273     balances[_to] = balances[_to].add(_value);
274     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
275     emit Transfer(_from, _to, _value);
276     return true;
277   }
278 
279   /**
280    * @dev Restricted access function that mints an amount of the token and assigns it to
281    * a specified account. This encapsulates the modification of balances such that the
282    * proper events are emitted.
283    * @param _to The account that will receive the created tokens.
284    * @param _amount The amount that will be created.
285    */
286   function mint(address _to, uint256 _amount) external {
287     address source = hotWallet;
288     require(msg.sender == source, "You are not allowed withdraw tokens");
289     withdraw(source, _to, _amount);
290   }
291 
292   /**
293    * @dev Internal function to withdraw tokens from special wallets.
294    * @param _from The address of special wallet.
295    * @param _to The address of receiver.
296    * @param _amount The amount of tokens which will be sent to receiver's address.
297    */
298   function withdraw(address _from, address _to, uint256 _amount) private {
299     require(_to != address(0), "Receiver address should be specified");
300     require(initialized, "Not initialized yet");
301     require(_amount > 0, "Amount should be more than zero");
302     require(_amount <= balances[_from], "Not enough funds");
303 
304     balances[_from] = balances[_from].sub(_amount);
305     balances[_to] = balances[_to].add(_amount);
306 
307     emit Transfer(_from, _to, _amount);
308   }
309 
310   /**
311    * @dev Restricted access function to withdraw tokens from reserve wallet.
312    * @param _to The address of receiver.
313    * @param _amount The amount of tokens which will be sent to receiver's address.
314    */
315   function withdrawFromReserveWallet(address _to, uint256 _amount) external {
316     address source = reserveWallet;
317     require(msg.sender == source, "You are not allowed withdraw tokens");
318     withdraw(source, _to, _amount);
319   }
320 
321   /**
322    * @dev Restricted access function to withdraw tokens from team wallet.
323    * But tokens can be withdraw only after lock period end.
324    * @param _to The address of receiver.
325    * @param _amount The amount of tokens which will be sent to receiver's address.
326    */
327   function withdrawFromTeamWallet(address _to, uint256 _amount) external {
328     address source = teamWallet;
329     require(msg.sender == source, "You are not allowed withdraw tokens");
330     require(lockedUntil <= now, "Tokens locked");
331     withdraw(source, _to, _amount);
332   }
333 
334   /**
335    * @dev Restricted access function to withdraw tokens from advisers wallet.
336    * @param _to The address of receiver.
337    * @param _amount The amount of tokens which will be sent to receiver's address.
338    */
339   function withdrawFromAdvisersWallet(address _to, uint256 _amount) external {
340     address source = advisersWallet;
341     require(msg.sender == source, "You are not allowed withdraw tokens");
342     withdraw(source, _to, _amount);
343   }
344 }