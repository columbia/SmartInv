1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
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
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     emit Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     emit Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     emit Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public view returns (uint256) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * @dev Increase the amount of tokens that an owner allowed to a spender.
152    *
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    * @param _spender The address which will spend the funds.
158    * @param _addedValue The amount of tokens to increase the allowance by.
159    */
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   /**
167    * @dev Decrease the amount of tokens that an owner allowed to a spender.
168    *
169    * approve should be called when allowed[_spender] == 0. To decrement
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    * @param _spender The address which will spend the funds.
174    * @param _subtractedValue The amount of tokens to decrease the allowance by.
175    */
176   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
177     uint oldValue = allowed[msg.sender][_spender];
178     if (_subtractedValue > oldValue) {
179       allowed[msg.sender][_spender] = 0;
180     } else {
181       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182     }
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187 }
188 
189 /**
190  * @title Ownable
191  * @dev The Ownable contract has an owner address, and provides basic authorization control
192  * functions, this simplifies the implementation of "user permissions".
193  */
194 contract Ownable {
195   address public owner;
196 
197   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199   /**
200    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
201    * account.
202    */
203   function Ownable() public {
204     owner = msg.sender;
205   }
206 
207   /**
208    * @dev Throws if called by any account other than the owner.
209    */
210   modifier onlyOwner() {
211     require(msg.sender == owner);
212     _;
213   }
214 
215   /**
216    * @dev Allows the current owner to transfer control of the contract to a newOwner.
217    * @param newOwner The address to transfer ownership to.
218    */
219   function transferOwnership(address newOwner) public onlyOwner {
220     require(newOwner != address(0));
221     emit OwnershipTransferred(owner, newOwner);
222     owner = newOwner;
223   }
224 }
225 
226 /**
227  * @title YOUToken
228  * @dev YOUChain.
229  */
230 contract YOUToken is StandardToken, Ownable {
231 
232   string public constant name = "YOU Chain";
233   string public constant symbol = "YOU";
234   uint8 public constant decimals = 18;
235 
236   uint256 private constant TOKEN_UNIT = 10 ** uint256(decimals);
237   uint256 private constant INITIAL_SUPPLY = 32 * (10 ** 8) * TOKEN_UNIT;
238 
239   uint256 private constant ANGEL_SUPPLY                 = INITIAL_SUPPLY * 10 / 100;  // 10% for angel sale
240   uint256 private constant PRIVATE_SUPPLY               = INITIAL_SUPPLY * 20 / 100;  // 20% for private sale
241   uint256 private constant TEAM_SUPPLY                  = INITIAL_SUPPLY * 15 / 100;  // 15% for team
242   uint256 private constant FOUNDATION_SUPPLY            = INITIAL_SUPPLY * 25 / 100;  // 25% for foundation
243   uint256 private constant COMMUNITY_SUPPLY	            = INITIAL_SUPPLY * 30 / 100;  // 30% for community rewards
244   
245   uint256 private constant ANGEL_SUPPLY_VESTING         = ANGEL_SUPPLY * 80 / 100;    // 50% of angel sale
246   struct VestingGrant {
247         address beneficiary;
248         uint256 start;
249         uint256 duration; //duration for each release
250         uint256 amount; //total grant amount
251         uint256 transfered; // transfered amount
252         uint8 releaseCount; // schedule release count
253   }
254 
255   address public constant ANGEL_ADDRESS = 0xAe195643020657B00d7DE6Cb98dE091A856059Cf; // angel sale vesting beneficiary address
256   address public constant PRIVATE_ADDRESS = 0x3C69915E58b972e4D17cc1e657b834EB7E9127A8; // private sale vesting beneficiary address
257   address public constant TEAM_ADDRESS = 0x781204E71681D2d70b3a46201c6e60Af93372a31; // team vesting beneficiary address
258   address public constant FOUNDATION_ADDRESS = 0xFC6423B399fC99E6ED044Ab5E872cAA915845A6f; // foundation vesting beneficiary address
259   address public constant COMMUNITY_ADDRESS = 0x790F7bd778d5c81aaD168598004728Ca8AF1b0A0; // community vesting beneficiary address
260 
261   VestingGrant angelVestingGrant;
262   VestingGrant teamVestingGrant;
263   bool angelFirstVested = false;
264 
265   function YOUToken() public {
266 
267     totalSupply = PRIVATE_SUPPLY.add(FOUNDATION_SUPPLY).add(COMMUNITY_SUPPLY);
268     balances[PRIVATE_ADDRESS] = PRIVATE_SUPPLY;
269     balances[FOUNDATION_ADDRESS] = FOUNDATION_SUPPLY;
270     balances[COMMUNITY_ADDRESS] = COMMUNITY_SUPPLY;
271 
272     angelVestingGrant = makeGrant(ANGEL_ADDRESS, now + 1 days, (30 days), ANGEL_SUPPLY_VESTING, 4);
273     teamVestingGrant = makeGrant(TEAM_ADDRESS, now + 1 days, (30 days), TEAM_SUPPLY, 60);
274   }
275 
276   function releaseAngelFirstVested() public onlyOwner {
277     require(!angelFirstVested && now >= angelVestingGrant.start);
278     uint256 angelFirstSupplyBalance = ANGEL_SUPPLY.sub(ANGEL_SUPPLY_VESTING);
279     totalSupply = totalSupply.add(angelFirstSupplyBalance);
280     balances[angelVestingGrant.beneficiary] = angelFirstSupplyBalance;
281     angelFirstVested = true;
282     emit Transfer(address(0), angelVestingGrant.beneficiary, angelFirstSupplyBalance);
283   }
284 
285   function releaseAngelVested() public onlyOwner {
286      releaseVestingGrant(angelVestingGrant);
287   }
288 
289   function releaseTeamVested() public onlyOwner {
290      releaseVestingGrant(teamVestingGrant);
291   }
292 
293   function makeGrant(address _beneficiary, uint256 _start, uint256 _duration, uint256 _amount, uint8 _releaseCount)
294     internal pure returns (VestingGrant) 
295     {
296     return VestingGrant({beneficiary : _beneficiary, start: _start, duration:_duration, amount:_amount, transfered:0, releaseCount:_releaseCount});
297   }
298 
299   function releasableAmount(uint256 time, VestingGrant grant) internal pure returns (uint256) {
300     if (grant.amount == grant.transfered) {
301         return 0;
302     }
303     uint256 amountPerRelease = grant.amount.div(grant.releaseCount);
304     uint256 amount = amountPerRelease.mul((time.sub(grant.start)).div(grant.duration));
305     if (amount > grant.amount) {
306     amount = grant.amount;
307     }
308     amount = amount.sub(grant.transfered);
309     return amount;
310   }
311 
312   function releaseVestingGrant(VestingGrant storage grant) internal {
313     uint256 amount = releasableAmount(now, grant);
314     require(amount > 0);
315 
316     grant.transfered = grant.transfered.add(amount);
317     totalSupply = totalSupply.add(amount);
318     balances[grant.beneficiary] = balances[grant.beneficiary].add(amount);
319     emit Transfer(address(0), grant.beneficiary, amount);
320   }
321 }