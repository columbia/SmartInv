1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public view returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   /**
76   * @dev transfer token for a specified address
77   * @param _to The address to transfer to.
78   * @param _value The amount to be transferred.
79   */
80   function transfer(address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[msg.sender]);
83 
84     // SafeMath.sub will throw if there is not enough balance.
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public view returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * @dev Increase the amount of tokens that an owner allowed to a spender.
162    *
163    * approve should be called when allowed[_spender] == 0. To increment
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * From MonolithDAO Token.sol
167    * @param _spender The address which will spend the funds.
168    * @param _addedValue The amount of tokens to increase the allowance by.
169    */
170   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   /**
177    * @dev Decrease the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To decrement
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _subtractedValue The amount of tokens to decrease the allowance by.
185    */
186   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
187     uint oldValue = allowed[msg.sender][_spender];
188     if (_subtractedValue > oldValue) {
189       allowed[msg.sender][_spender] = 0;
190     } else {
191       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192     }
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197 }
198 
199 
200 
201 /**
202  * @title Ownable
203  * @dev The Ownable contract has an owner address, and provides basic authorization control
204  * functions, this simplifies the implementation of "user permissions".
205  */
206 contract Ownable {
207   address public owner;
208 
209 
210   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
211 
212 
213   /**
214    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
215    * account.
216    */
217   function Ownable() public {
218     owner = msg.sender;
219   }
220 
221 
222   /**
223    * @dev Throws if called by any account other than the owner.
224    */
225   modifier onlyOwner() {
226     require(msg.sender == owner);
227     _;
228   }
229 
230 
231   /**
232    * @dev Allows the current owner to transfer control of the contract to a newOwner.
233    * @param newOwner The address to transfer ownership to.
234    */
235   function transferOwnership(address newOwner) public onlyOwner {
236     require(newOwner != address(0));
237     OwnershipTransferred(owner, newOwner);
238     owner = newOwner;
239   }
240 
241 }
242 
243 
244 /**
245  * @title GSCToken
246  * @dev Global Social Chain.
247  */
248 contract GSCToken is StandardToken, Ownable {
249 
250   string public constant name = "Global Social Chain";
251   string public constant symbol = "GSC";
252   uint8 public constant decimals = 18;
253 
254   uint256 private constant TOKEN_UNIT = 10 ** uint256(decimals);
255   uint256 private constant INITIAL_SUPPLY = (10 ** 9) * TOKEN_UNIT;
256 
257   uint256 private constant PRIVATE_SUPPLY              = INITIAL_SUPPLY * 30 / 100;  // 30% for private sale
258   uint256 private constant RESERVED_FOR_TEAM            = INITIAL_SUPPLY * 10 / 100;  // 10% for team
259   uint256 private constant COMMERCIAL_PLAN             = INITIAL_SUPPLY * 20 / 100; // 20% for commercial plan
260   uint256 private constant RESERVED_FOR_FOUNDATION     = INITIAL_SUPPLY * 15 / 100; // 15% for foundation
261   uint256 private constant COMMUNITY_REWARDS	     	= INITIAL_SUPPLY * 25 / 100; // 25% for community rewards
262 
263   uint256 private constant PRIVATE_SUPPLY_VESTING       = PRIVATE_SUPPLY * 50 / 100;  // 50% of private sale
264 
265 
266   struct VestingGrant {
267         address beneficiary;
268         uint256 start;
269         uint256 duration; //duration for each release
270         uint256 amount; //total grant amount
271         uint256 transfered; // transfered amount
272         uint8 releaseCount; // schedule release count
273   }
274 
275 
276   address public constant PRIVATE_SUPPLY_ADDRESS = 0xd509bE99995A24e089C9789ed69B08031F830615; //private sale vesting beneficiary address
277   VestingGrant privsteSupplyVestingGrant;
278 
279   address public constant TEAM_ADDRESS = 0x9C99b03224122b419a84a6bD7A609f7288d65Eb9; //team vesting  beneficiary address
280   VestingGrant teamVestingGrant;
281 
282   /**
283    * @dev Constructor that gives msg.sender all of existing tokens.
284    */
285   function GSCToken() public {
286     uint256 senderBalance = COMMERCIAL_PLAN.add(RESERVED_FOR_FOUNDATION).add(COMMUNITY_REWARDS);
287     uint256 privateSupplyBalance = PRIVATE_SUPPLY.sub(PRIVATE_SUPPLY_VESTING);
288     totalSupply = senderBalance + privateSupplyBalance;
289     balances[msg.sender] = senderBalance;
290 	  balances[PRIVATE_SUPPLY_ADDRESS] = privateSupplyBalance;
291 
292     privsteSupplyVestingGrant = makeGrant(PRIVATE_SUPPLY_ADDRESS, now, (30 days), PRIVATE_SUPPLY_VESTING, 10);
293     teamVestingGrant = makeGrant(TEAM_ADDRESS, now, (182 days), RESERVED_FOR_TEAM, 4);
294   }
295 
296   function makeGrant(address _beneficiary, uint256 _start, uint256 _duration, uint256 _amount, uint8 _releaseCount)
297     internal pure returns  (VestingGrant) {
298       return VestingGrant({ beneficiary : _beneficiary, start: _start, duration:_duration, amount:_amount, transfered:0, releaseCount:_releaseCount});
299   }
300 
301 
302 
303   function releasePrivateSupplyVested() public onlyOwner {
304       relaseVestingGrant(privsteSupplyVestingGrant);
305   }
306 
307   function releaseTeamVested() public onlyOwner {
308       relaseVestingGrant(teamVestingGrant);
309   }
310 
311   function releasableAmount(uint256 time, VestingGrant grant) internal pure returns (uint256) {
312       if (grant.amount == grant.transfered) {
313           return 0;
314       }
315       uint256 amountPerRelease = grant.amount.div(grant.releaseCount);
316       uint256 amount = amountPerRelease.mul((time.sub(grant.start)).div(grant.duration));
317       if (amount > grant.amount) {
318         amount = grant.amount;
319       }
320       amount = amount.sub(grant.transfered);
321       return amount;
322   }
323 
324   function relaseVestingGrant(VestingGrant storage grant) internal {
325       uint256 amount = releasableAmount(now, grant);
326       require(amount > 0);
327 
328       grant.transfered = grant.transfered.add(amount);
329       totalSupply = totalSupply.add(amount);
330       balances[grant.beneficiary] = balances[grant.beneficiary].add(amount);
331       Transfer(address(0), grant.beneficiary, amount);
332     }
333 }