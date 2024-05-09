1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts/TokenVesting.sol
97 
98 /**
99  * @title Vesting contract for SDT
100  * @dev see https://send.sd/token
101  */
102 contract TokenVesting is Ownable {
103   using SafeMath for uint256;
104 
105   address public ico;
106   bool public initialized;
107   bool public active;
108   ERC20Basic public token;
109   mapping (address => TokenGrant[]) public grants;
110 
111   uint256 public circulatingSupply = 0;
112 
113   struct TokenGrant {
114     uint256 value;
115     uint256 claimed;
116     uint256 vesting;
117     uint256 start;
118   }
119 
120   event NewTokenGrant (
121     address indexed to,
122     uint256 value,
123     uint256 start,
124     uint256 vesting
125   );
126 
127   event NewTokenClaim (
128     address indexed holder,
129     uint256 value
130   );
131 
132   modifier icoResticted() {
133     require(msg.sender == ico);
134     _;
135   }
136 
137   modifier isActive() {
138     require(active);
139     _;
140   }
141 
142   function TokenVesting() public {
143     active = false;
144   }
145 
146   function init(address _token, address _ico) public onlyOwner {
147     token = ERC20Basic(_token);
148     ico = _ico;
149     initialized = true;
150     active = true;
151   }
152 
153   function stop() public isActive onlyOwner {
154     active = false;
155   }
156 
157   function resume() public onlyOwner {
158     require(!active);
159     require(initialized);
160     active = true;
161   }
162 
163   /**
164   * @dev Grant vested tokens.
165   * @notice Only for ICO contract address.
166   * @param _to Addres to grant tokens to.
167   * @param _value Number of tokens granted.
168   * @param _vesting Vesting finish timestamp.
169   * @param _start Vesting start timestamp.
170   */
171   function grantVestedTokens(
172       address _to,
173       uint256 _value,
174       uint256 _start,
175       uint256 _vesting
176   ) public icoResticted isActive {
177     require(_value > 0);
178     require(_vesting > _start);
179     require(grants[_to].length < 10);
180 
181     TokenGrant memory grant = TokenGrant(_value, 0, _vesting, _start);
182     grants[_to].push(grant);
183 
184     NewTokenGrant(_to, _value, _start, _vesting);
185   }
186 
187   /**
188   * @dev Claim all vested tokens up to current date for myself
189   */
190   function claimTokens() public {
191     claim(msg.sender);
192   }
193 
194   /**
195   * @dev Claim all vested tokens up to current date in behaviour of an user
196   * @param _to address Addres to claim tokens
197   */
198   function claimTokensFor(address _to) public onlyOwner {
199     claim(_to);
200   }
201 
202   /**
203   * @dev Get claimable tokens
204   */
205   function claimableTokens() public constant returns (uint256) {
206     address _to = msg.sender;
207     uint256 numberOfGrants = grants[_to].length;
208 
209     if (numberOfGrants == 0) {
210       return 0;
211     }
212 
213     uint256 claimable = 0;
214     uint256 claimableFor = 0;
215     for (uint256 i = 0; i < numberOfGrants; i++) {
216       claimableFor = calculateVestedTokens(
217         grants[_to][i].value,
218         grants[_to][i].vesting,
219         grants[_to][i].start,
220         grants[_to][i].claimed
221       );
222       claimable = claimable.add(claimableFor);
223     }
224     return claimable;
225   }
226 
227   /**
228   * @dev Get all veted tokens
229   */
230   function totalVestedTokens() public constant returns (uint256) {
231     address _to = msg.sender;
232     uint256 numberOfGrants = grants[_to].length;
233 
234     if (numberOfGrants == 0) {
235       return 0;
236     }
237 
238     uint256 claimable = 0;
239     for (uint256 i = 0; i < numberOfGrants; i++) {
240       claimable = claimable.add(
241         grants[_to][i].value.sub(grants[_to][i].claimed)
242       );
243     }
244     return claimable;
245   }
246 
247   /**
248   * @dev Calculate vested claimable tokens on current time
249   * @param _tokens Number of tokens granted
250   * @param _vesting Vesting finish timestamp
251   * @param _start Vesting start timestamp
252   * @param _claimed Number of tokens already claimed
253   */
254   function calculateVestedTokens(
255       uint256 _tokens,
256       uint256 _vesting,
257       uint256 _start,
258       uint256 _claimed
259   ) internal constant returns (uint256) {
260     uint256 time = block.timestamp;
261 
262     if (time < _start) {
263       return 0;
264     }
265 
266     if (time >= _vesting) {
267       return _tokens.sub(_claimed);
268     }
269 
270     uint256 vestedTokens = _tokens.mul(time.sub(_start)).div(
271       _vesting.sub(_start)
272     );
273 
274     return vestedTokens.sub(_claimed);
275   }
276 
277   /**
278   * @dev Claim all vested tokens up to current date
279   */
280   function claim(address _to) internal {
281     uint256 numberOfGrants = grants[_to].length;
282 
283     if (numberOfGrants == 0) {
284       return;
285     }
286 
287     uint256 claimable = 0;
288     uint256 claimableFor = 0;
289     for (uint256 i = 0; i < numberOfGrants; i++) {
290       claimableFor = calculateVestedTokens(
291         grants[_to][i].value,
292         grants[_to][i].vesting,
293         grants[_to][i].start,
294         grants[_to][i].claimed
295       );
296       claimable = claimable.add(claimableFor);
297       grants[_to][i].claimed = grants[_to][i].claimed.add(claimableFor);
298     }
299 
300     token.transfer(_to, claimable);
301     circulatingSupply += claimable;
302 
303     NewTokenClaim(_to, claimable);
304   }
305 }