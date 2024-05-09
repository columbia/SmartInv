1 pragma solidity 0.4.24;
2  
3 
4 interface IArbitrage {
5     function executeArbitrage(
6       address token,
7       uint256 amount,
8       address dest,
9       bytes data
10     )
11       external
12       returns (bool);
13 }
14 
15 pragma solidity 0.4.24;
16 
17 
18 contract IBank {
19     function totalSupplyOf(address token) public view returns (uint256 balance);
20     function borrowFor(address token, address borrower, uint256 amount) public;
21     function repay(address token, uint256 amount) external payable;
22 }
23 
24 
25 /**
26  * @title Helps contracts guard agains reentrancy attacks.
27  * @author Remco Bloemen <remco@2π.com>
28  * @notice If you mark a function `nonReentrant`, you should also
29  * mark it `external`.
30  */
31 contract ReentrancyGuard {
32 
33   /**
34    * @dev We use a single lock for the whole contract.
35    */
36   bool private reentrancyLock = false;
37 
38   /**
39    * @dev Prevents a contract from calling itself, directly or indirectly.
40    * @notice If you mark a function `nonReentrant`, you should also
41    * mark it `external`. Calling one nonReentrant function from
42    * another is not supported. Instead, you can implement a
43    * `private` function doing the actual work, and a `external`
44    * wrapper marked as `nonReentrant`.
45    */
46   modifier nonReentrant() {
47     require(!reentrancyLock);
48     reentrancyLock = true;
49     _;
50     reentrancyLock = false;
51   }
52 
53 }
54 
55 
56 /**
57  * @title SafeMath
58  * @dev Math operations with safety checks that throw on error
59  */
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
67     // benefit is lost if 'b' is also tested.
68     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
69     if (a == 0) {
70       return 0;
71     }
72 
73     c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     // uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return a / b;
86   }
87 
88   /**
89   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
100     c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 
107 /**
108  * @title Ownable
109  * @dev The Ownable contract has an owner address, and provides basic authorization control
110  * functions, this simplifies the implementation of "user permissions".
111  */
112 contract Ownable {
113   address public owner;
114 
115 
116   event OwnershipRenounced(address indexed previousOwner);
117   event OwnershipTransferred(
118     address indexed previousOwner,
119     address indexed newOwner
120   );
121 
122 
123   /**
124    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
125    * account.
126    */
127   constructor() public {
128     owner = msg.sender;
129   }
130 
131   /**
132    * @dev Throws if called by any account other than the owner.
133    */
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138 
139   /**
140    * @dev Allows the current owner to relinquish control of the contract.
141    */
142   function renounceOwnership() public onlyOwner {
143     emit OwnershipRenounced(owner);
144     owner = address(0);
145   }
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param _newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address _newOwner) public onlyOwner {
152     _transferOwnership(_newOwner);
153   }
154 
155   /**
156    * @dev Transfers control of the contract to a newOwner.
157    * @param _newOwner The address to transfer ownership to.
158    */
159   function _transferOwnership(address _newOwner) internal {
160     require(_newOwner != address(0));
161     emit OwnershipTransferred(owner, _newOwner);
162     owner = _newOwner;
163   }
164 }
165 
166 
167 /**
168  * @title ERC20Basic
169  * @dev Simpler version of ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/179
171  */
172 contract ERC20Basic {
173   function totalSupply() public view returns (uint256);
174   function balanceOf(address who) public view returns (uint256);
175   function transfer(address to, uint256 value) public returns (bool);
176   event Transfer(address indexed from, address indexed to, uint256 value);
177 }
178 
179 
180 /**
181  * @title ERC20 interface
182  * @dev see https://github.com/ethereum/EIPs/issues/20
183  */
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender)
186     public view returns (uint256);
187 
188   function transferFrom(address from, address to, uint256 value)
189     public returns (bool);
190 
191   function approve(address spender, uint256 value) public returns (bool);
192   event Approval(
193     address indexed owner,
194     address indexed spender,
195     uint256 value
196   );
197 }
198 
199 
200 /*
201 
202   Copyright 2018 Contra Labs Inc.
203 
204   Licensed under the Apache License, Version 2.0 (the "License");
205   you may not use this file except in compliance with the License.
206   You may obtain a copy of the License at
207 
208   http://www.apache.org/licenses/LICENSE-2.0
209 
210   Unless required by applicable law or agreed to in writing, software
211   distributed under the License is distributed on an "AS IS" BASIS,
212   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
213   See the License for the specific language governing permissions and
214   limitations under the License.
215 
216 */
217 
218 pragma solidity 0.4.24;
219 
220 // @title FlashLender: Borrow from the bank and enforce repayment by the end of transaction execution.
221 // @author Rich McAteer <rich@marble.org>, Max Wolff <max@marble.org>
222 contract FlashLender is ReentrancyGuard, Ownable {
223     using SafeMath for uint256;
224 
225     string public version = '0.1';
226     address public bank;
227     uint256 public fee;
228     
229     /**
230     * @dev Verify that the borrowed tokens are returned to the bank plus a fee by the end of transaction execution.
231     * @param token Address of the token to for arbitrage. 0x0 for Ether.
232     * @param amount Amount borrowed.
233     */
234     modifier isArbitrage(address token, uint256 amount) {
235         uint256 balance = IBank(bank).totalSupplyOf(token);
236         uint256 feeAmount = amount.mul(fee).div(10 ** 18); 
237         _;
238         require(IBank(bank).totalSupplyOf(token) >= (balance.add(feeAmount)));
239     }
240 
241     constructor(address _bank, uint256 _fee) public {
242         bank = _bank;
243         fee = _fee;
244     }
245 
246     /**
247     * @dev Borrow from the bank on behalf of an arbitrage contract and execute the arbitrage contract's callback function.
248     * @param token Address of the token to borrow. 0x0 for Ether.
249     * @param amount Amount to borrow.
250     * @param dest Address of the account to receive arbitrage profits.
251     * @param data The data to execute the arbitrage trade.
252     */
253     function borrow(
254         address token,
255         uint256 amount,
256         address dest,
257         bytes data
258     )
259         external
260         nonReentrant
261         isArbitrage(token, amount)
262         returns (bool)
263     {
264         // Borrow from the bank and send to the arbitrageur.
265         IBank(bank).borrowFor(token, msg.sender, amount);
266         // Call the arbitrageur's execute arbitrage method.
267         return IArbitrage(msg.sender).executeArbitrage(token, amount, dest, data);
268     }
269 
270     /**
271     * @dev Allow the owner to set the bank address.
272     * @param _bank Address of the bank.
273     */
274     function setBank(address _bank) external onlyOwner {
275         bank = _bank;
276     }
277 
278     /**
279     * @dev Allow the owner to set the fee.
280     * @param _fee Fee to borrow, as a percentage of principal borrowed. 18 decimals of precision (e.g., 10^18 = 100% fee).
281     */
282     function setFee(uint256 _fee) external onlyOwner {
283         fee = _fee;
284     }
285 
286 }