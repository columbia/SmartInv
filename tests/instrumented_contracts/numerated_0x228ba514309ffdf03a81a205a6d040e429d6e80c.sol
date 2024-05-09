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
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) internal allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) public view returns (uint256) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * @dev Increase the amount of tokens that an owner allowed to a spender.
156    *
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    * @param _spender The address which will spend the funds.
162    * @param _addedValue The amount of tokens to increase the allowance by.
163    */
164   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
165     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
166     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   /**
171    * @dev Decrease the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To decrement
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _subtractedValue The amount of tokens to decrease the allowance by.
179    */
180   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
181     uint oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 
193 
194 /**
195  * @title Ownable
196  * @dev The Ownable contract has an owner address, and provides basic authorization control
197  * functions, this simplifies the implementation of "user permissions".
198  */
199 contract Ownable {
200   address public owner;
201 
202 
203   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205 
206   /**
207    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
208    * account.
209    */
210   function Ownable() public {
211     owner = msg.sender;
212   }
213 
214 
215   /**
216    * @dev Throws if called by any account other than the owner.
217    */
218   modifier onlyOwner() {
219     require(msg.sender == owner);
220     _;
221   }
222 
223 
224   /**
225    * @dev Allows the current owner to transfer control of the contract to a newOwner.
226    * @param newOwner The address to transfer ownership to.
227    */
228   function transferOwnership(address newOwner) public onlyOwner {
229     require(newOwner != address(0));
230     OwnershipTransferred(owner, newOwner);
231     owner = newOwner;
232   }
233 
234 }
235 
236 
237 /**
238  * @title GSCToken
239  * @dev Global Social Chain.
240  */
241 contract GSCToken is StandardToken, Ownable {
242 
243   string public constant name = "Global Social Chain";
244   string public constant symbol = "GSC";
245   uint8 public constant decimals = 18;
246 
247   uint256 private constant TOKEN_UNIT = 10 ** uint256(decimals);
248   uint256 private constant INITIAL_SUPPLY = (10 ** 9) * TOKEN_UNIT;
249 
250   uint256 private constant PRIVATE_SALE_SUPPLY = INITIAL_SUPPLY * 35 / 100;  // 35% for private sale
251   uint256 private constant COMMUNITY_REWARDS_SUPPLY = INITIAL_SUPPLY * 20 / 100;  // 20% for community rewards
252   uint256 private constant COMMERCIAL_PLAN_SUPPLY = INITIAL_SUPPLY * 20 / 100;  // 20% for commercial plan
253   uint256 private constant FOUNDATION_SUPPLY = INITIAL_SUPPLY * 15 / 100;  // 15% for foundation
254   uint256 private constant TEAM_SUPPLY = INITIAL_SUPPLY * 10 / 100;  // 10% for team
255 
256   struct VestingGrant {
257         address beneficiary;
258         uint256 start;
259         uint256 duration; //duration for each release
260         uint256 amount; //total grant amount
261         uint256 transfered; // transfered amount
262         uint8 releaseCount; // schedule release count
263   }
264 
265   address private constant PRIVAYE_SALE_ADDRESS = 0x9C99b03224122b419a84a6bD7A609f7288d65Eb9; //team vesting  beneficiary address
266   address private constant COMMUNITY_REWARDS_ADDRESS = 0xc6b41984F90958750780AE034Ab2Ac6328386942; //community rewards wallet address
267   address private constant COMMERCIAL_PLAN_ADDRESS = 0x1222cdceE3D244933AAc7ec37B0313741C406f82; //commercial plan wallet address
268   address private constant FOUNDATION_ADDRESS = 0xB892F6224991717c9aC27eA1b67A05909f664724; //foundation wallet address
269 
270   VestingGrant teamVestingGrant;
271 
272   /**
273    * @dev Constructor that gives msg.sender all of existing tokens.
274    */
275   function GSCToken() public {
276     totalSupply =  INITIAL_SUPPLY;
277 
278     balances[PRIVAYE_SALE_ADDRESS] = PRIVATE_SALE_SUPPLY;
279     balances[COMMUNITY_REWARDS_ADDRESS] = COMMUNITY_REWARDS_SUPPLY;
280     balances[COMMERCIAL_PLAN_ADDRESS] = COMMERCIAL_PLAN_SUPPLY;
281     balances[FOUNDATION_ADDRESS] = FOUNDATION_SUPPLY;
282 
283     teamVestingGrant = makeGrant(msg.sender, now, (182 days), TEAM_SUPPLY, 4); // The owner address is reserved for the Team Wallet
284   }
285 
286   function makeGrant(address _beneficiary, uint256 _start, uint256 _duration, uint256 _amount, uint8 _releaseCount)
287     internal pure returns  (VestingGrant) {
288       return VestingGrant({ beneficiary : _beneficiary, start: _start, duration:_duration, amount:_amount, transfered:0, releaseCount:_releaseCount});
289   }
290 
291   function releaseTeamVested() public onlyOwner {
292       relaseVestingGrant(teamVestingGrant);
293   }
294 
295   function releasableAmount(uint256 time, VestingGrant grant) internal pure returns (uint256) {
296       if (grant.amount == grant.transfered) {
297           return 0;
298       }
299       uint256 amountPerRelease = grant.amount.div(grant.releaseCount);
300       uint256 amount = amountPerRelease.mul((time.sub(grant.start)).div(grant.duration));
301       if (amount > grant.amount) {
302         amount = grant.amount;
303       }
304       amount = amount.sub(grant.transfered);
305       return amount;
306   }
307 
308   function relaseVestingGrant(VestingGrant storage grant) internal {
309       uint256 amount = releasableAmount(now, grant);
310       require(amount > 0);
311 
312       grant.transfered = grant.transfered.add(amount);
313       totalSupply = totalSupply.add(amount);
314       balances[grant.beneficiary] = balances[grant.beneficiary].add(amount);
315       Transfer(address(0), grant.beneficiary, amount);
316     }
317 }