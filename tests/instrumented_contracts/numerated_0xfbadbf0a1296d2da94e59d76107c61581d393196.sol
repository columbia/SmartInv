1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeERC20
28  * @dev Wrappers around ERC20 operations that throw on failure.
29  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
30  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
31  */
32 library SafeERC20 {
33   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
34     assert(token.transfer(to, value));
35   }
36 
37   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
38     assert(token.transferFrom(from, to, value));
39   }
40 
41   function safeApprove(ERC20 token, address spender, uint256 value) internal {
42     assert(token.approve(spender, value));
43   }
44 }
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) onlyOwner public {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 /**
89  * @title Math
90  * @dev Assorted math operations
91  */
92 
93 library Math {
94   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
95     return a >= b ? a : b;
96   }
97 
98   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
99     return a < b ? a : b;
100   }
101 
102   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
103     return a >= b ? a : b;
104   }
105 
106   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
107     return a < b ? a : b;
108   }
109 }
110 
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that throw on error
114  */
115 library SafeMath {
116   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
117     uint256 c = a * b;
118     assert(a == 0 || c / a == b);
119     return c;
120   }
121 
122   function div(uint256 a, uint256 b) internal constant returns (uint256) {
123     // assert(b > 0); // Solidity automatically throws when dividing by 0
124     uint256 c = a / b;
125     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126     return c;
127   }
128 
129   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   function add(uint256 a, uint256 b) internal constant returns (uint256) {
135     uint256 c = a + b;
136     assert(c >= a);
137     return c;
138   }
139 }
140 
141 /**
142  * @title GreedVesting
143  * @dev A vesting contract for greed tokens that can release its token balance gradually like a
144  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
145  * owner. In this contract, you add vesting to a particular wallet, release and revoke the vesting.
146  */
147  
148 contract GreedVesting is Ownable {
149   using SafeMath for uint256;
150   using SafeERC20 for ERC20Basic;
151 
152   event Released(address beneficiary, uint256 amount);
153   event Revoked(address beneficiary);
154 
155   uint256 public totalVesting;
156   mapping (address => uint256) public released;
157   mapping (address => bool) public revoked;
158   mapping (address => bool) public revocables;
159   mapping (address => uint256) public durations;
160   mapping (address => uint256) public starts;
161   mapping (address => uint256) public cliffs; 
162   mapping (address => uint256) public amounts; 
163   mapping (address => uint256) public refunded; 
164        
165   /**
166    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
167    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
168    * of the balance will have vested.
169    * @param greed address of greed token contract
170    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
171    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
172    * @param _duration duration in seconds of the period in which the tokens will vest
173    * @param _amount amount to be vested
174    * @param _revocable whether the vesting is revocable or not
175    */
176   function addVesting(ERC20Basic greed, address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _amount, bool _revocable) public onlyOwner {
177     require(_beneficiary != 0x0);
178     require(_amount > 0);
179     // Make sure that a single address can be granted tokens only once.
180     require(starts[_beneficiary] == 0);
181     // Check for date inconsistencies that may cause unexpected behavior.
182     require(_cliff <= _duration);
183     // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
184     require(totalVesting.add(_amount) <= greed.balanceOf(address(this)));
185 
186 	revocables[_beneficiary] = _revocable;
187     durations[_beneficiary] = _duration;
188     cliffs[_beneficiary] = _start.add(_cliff);
189     starts[_beneficiary] = _start;
190     amounts[_beneficiary] = _amount;
191     totalVesting = totalVesting.add(_amount);
192   }
193 
194   /**
195    * @notice Transfers vested tokens to beneficiary.
196    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
197    * @param greed address of greed token contract
198    */
199   function release(address beneficiary, ERC20Basic greed) public {
200       
201     require(msg.sender == beneficiary || msg.sender == owner);
202 
203     uint256 unreleased = releasableAmount(beneficiary);
204     
205     require(unreleased > 0);
206 
207     released[beneficiary] = released[beneficiary].add(unreleased);
208 
209     greed.safeTransfer(beneficiary, unreleased);
210 
211     Released(beneficiary, unreleased);
212   }
213 
214   /**
215    * @notice Allows the owner to revoke the vesting. Tokens already vested
216    * remain in the contract, the rest are returned to the owner.
217    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
218    * @param greed address of greed token contract
219     */
220   function revoke(address beneficiary, ERC20Basic greed) public onlyOwner {
221     require(revocables[beneficiary]);
222     require(!revoked[beneficiary]);
223 
224     uint256 balance = amounts[beneficiary].sub(released[beneficiary]);
225 
226     uint256 unreleased = releasableAmount(beneficiary);
227     uint256 refund = balance.sub(unreleased);
228 
229     revoked[beneficiary] = true;
230     if (refund != 0) { 
231 		greed.safeTransfer(owner, refund);
232 		refunded[beneficiary] = refunded[beneficiary].add(refund);
233 	}
234     Revoked(beneficiary);
235   }
236 
237   /**
238    * @dev Calculates the amount that has already vested but hasn't been released yet.
239    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
240    * 
241    */
242   function releasableAmount(address beneficiary) public constant returns (uint256) {
243     return vestedAmount(beneficiary).sub(released[beneficiary]);
244   }
245 
246   /**
247    * @dev Calculates the amount that has already vested.
248    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
249    */
250   function vestedAmount(address beneficiary) public constant returns (uint256) {
251     uint256 totalBalance = amounts[beneficiary].sub(refunded[beneficiary]);
252 
253     if (now < cliffs[beneficiary]) {
254       return 0;
255     } else if (now >= starts[beneficiary] + durations[beneficiary] || revoked[beneficiary]) {
256       return totalBalance;
257     } else {
258       return totalBalance.mul(now - starts[beneficiary]).div(durations[beneficiary]);
259     }
260   }
261 }