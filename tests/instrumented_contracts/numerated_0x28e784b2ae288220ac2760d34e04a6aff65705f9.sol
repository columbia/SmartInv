1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipRenounced(address indexed previousOwner);
76   event OwnershipTransferred(
77     address indexed previousOwner,
78     address indexed newOwner
79   );
80 
81 
82   /**
83    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84    * account.
85    */
86   constructor() public {
87     owner = msg.sender;
88   }
89 
90   /**
91    * @dev Throws if called by any account other than the owner.
92    */
93   modifier onlyOwner() {
94     require(msg.sender == owner);
95     _;
96   }
97 
98   /**
99    * @dev Allows the current owner to relinquish control of the contract.
100    * @notice Renouncing to ownership will leave the contract without an owner.
101    * It will not be possible to call the functions with the `onlyOwner`
102    * modifier anymore.
103    */
104   function renounceOwnership() public onlyOwner {
105     emit OwnershipRenounced(owner);
106     owner = address(0);
107   }
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address _newOwner) public onlyOwner {
114     _transferOwnership(_newOwner);
115   }
116 
117   /**
118    * @dev Transfers control of the contract to a newOwner.
119    * @param _newOwner The address to transfer ownership to.
120    */
121   function _transferOwnership(address _newOwner) internal {
122     require(_newOwner != address(0));
123     emit OwnershipTransferred(owner, _newOwner);
124     owner = _newOwner;
125   }
126 }
127 
128 
129 /**
130  * @title SafeERC20
131  * @dev Wrappers around ERC20 operations that throw on failure.
132  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
133  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
134  */
135 library SafeERC20 {
136   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
137     require(token.transfer(to, value));
138   }
139 
140   function safeTransferFrom(
141     ERC20 token,
142     address from,
143     address to,
144     uint256 value
145   )
146     internal
147   {
148     require(token.transferFrom(from, to, value));
149   }
150 
151   function safeApprove(ERC20 token, address spender, uint256 value) internal {
152     require(token.approve(spender, value));
153   }
154 }
155 
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender)
163     public view returns (uint256);
164 
165   function transferFrom(address from, address to, uint256 value)
166     public returns (bool);
167 
168   function approve(address spender, uint256 value) public returns (bool);
169   event Approval(
170     address indexed owner,
171     address indexed spender,
172     uint256 value
173   );
174 }
175 
176 /**
177  * @title DKE hedge contract
178  */
179 contract DKEHedge is Ownable {
180   using SafeMath for uint256;
181   using SafeERC20 for ERC20Basic;
182 
183   event Released(uint256 amount);
184   event Revoked();
185 
186   // beneficiary of tokens after they are released
187   address public beneficiary;
188   // start timestamp
189   uint256 public start;
190   // mt (cd or qt)
191   uint256 public mt;
192   // released list
193   uint256[] public released = new uint256[](39);
194 
195   /**
196    * @dev DKE linear cycle release
197    * @param _beneficiary address of the beneficiary to whom vested DKE are transferred
198    * @param _mt MT，minimum value of 1
199    */
200   constructor(
201     address _beneficiary,
202     uint256 _mt
203   )
204     public
205   {
206     require(_beneficiary != address(0));
207     // require(_mt >= 100000000000);
208     require(_mt >= 100000000);
209 
210     beneficiary = _beneficiary;
211     mt = _mt;
212     start = block.timestamp;
213   }
214 
215   /**
216    * @notice Release record every day
217    */
218   function release(uint16 price) public onlyOwner {
219     uint256 idx = getCycleIndex();
220     // 39 days (39 * 24 * 3600) 3369600
221     require(idx >= 1 && idx <= 39);
222 
223     // dke = mt / 39 * 0.13 / price
224     uint256 dke = mt.mul(1300).div(39).div(price);
225     released[idx.sub(1)] = dke;
226 
227     emit Released(dke);
228   }
229 
230   /**
231    * @notice release and revoke
232    * @param token DKEToken address
233    */
234   function revoke(uint16 price, ERC20Basic token) public onlyOwner {
235     uint256 income = getIncome(price);
236     uint256 balance = token.balanceOf(this);
237     if (balance <= income) {
238       token.safeTransfer(beneficiary, balance);
239     } else {
240       token.safeTransfer(beneficiary, income);
241       token.safeTransfer(owner, balance.sub(income));
242     }
243 
244     emit Revoked();
245   }
246 
247   /**
248    * @dev get cycle index
249    */
250   function getCycleIndex() public view returns (uint256) {
251     // 1 days （24 * 3600） 86400
252     return block.timestamp.sub(start).div(1800);
253   }
254 
255   /**
256    * @dev get released list in 39 days
257    */
258   function getReleased() public view returns (uint256[]) {
259     return released;
260   }
261 
262   /**
263    * @dev get income for DKE
264    */
265   function getIncome(uint16 price) public view returns (uint256) {
266     uint256 idx = getCycleIndex();
267     require(idx >= 39);
268 
269     uint256 origin = mt.mul(13).div(100);
270 
271     uint256 total = 0;
272 
273     for(uint8 i = 0; i < released.length; i++) {
274       uint256 item = released[i];
275       total = total.add(item);
276     }
277 
278     uint256 current = total.mul(price).div(10000);
279     if (current <= origin) {
280       current = origin;
281     } else {
282       current = current.add(current.sub(origin).mul(5).div(100));
283     }
284 
285     return current.mul(10000).div(price);
286   }
287 }