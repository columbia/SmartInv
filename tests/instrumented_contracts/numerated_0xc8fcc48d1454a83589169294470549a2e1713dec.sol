1 /*
2 
3   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9   http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 pragma solidity 0.5.7;
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Math
52  * @dev Assorted math operations
53  */
54 
55 library Math {
56   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
57     return a >= b ? a : b;
58   }
59 
60   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
61     return a < b ? a : b;
62   }
63 
64   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
65     return a >= b ? a : b;
66   }
67 
68   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
69     return a < b ? a : b;
70   }
71 }
72 
73 // Abstract contract for the full ERC 20 Token standard
74 // https://github.com/ethereum/EIPs/issues/20
75 
76 contract Token {
77     /* This is a slight change to the ERC20 base standard.
78     function totalSupply() constant returns (uint256 supply);
79     is replaced with:
80     uint256 public totalSupply;
81     This automatically creates a getter function for the totalSupply.
82     This is moved to the base contract since public getter functions are not
83     currently recognised as an implementation of the matching abstract
84     function by the compiler.
85     */
86     /// total amount of tokens
87     uint256 public totalSupply;
88 
89     /// @param _owner The address from which the balance will be retrieved
90     /// @return The balance
91     function balanceOf(address _owner) view public returns (uint256 balance);
92 
93     /// @notice send `_value` token to `_to` from `msg.sender`
94     /// @param _to The address of the recipient
95     /// @param _value The amount of token to be transferred
96     /// @return Whether the transfer was successful or not
97     function transfer(address _to, uint256 _value) public returns (bool success);
98 
99     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
100     /// @param _from The address of the sender
101     /// @param _to The address of the recipient
102     /// @param _value The amount of token to be transferred
103     /// @return Whether the transfer was successful or not
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
105 
106     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
107     /// @param _spender The address of the account able to transfer the tokens
108     /// @param _value The amount of tokens to be approved for transfer
109     /// @return Whether the approval was successful or not
110     function approve(address _spender, uint256 _value) public returns (bool success);
111 
112     /// @param _owner The address of the account owning tokens
113     /// @param _spender The address of the account able to transfer the tokens
114     /// @return Amount of remaining tokens allowed to spent
115     function allowance(address _owner, address _spender) view public returns (uint256 remaining);
116 
117     event Transfer(address indexed _from, address indexed _to, uint256 _value);
118     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
119 }
120 
121 /// @title Ownable
122 /// @dev The Ownable contract has an owner address, and provides basic
123 ///      authorization control functions, this simplifies the implementation of
124 ///      "user permissions".
125 contract Ownable {
126     address public owner;
127 
128     event OwnershipTransferred(
129         address indexed previousOwner,
130         address indexed newOwner
131     );
132 
133     /// @dev The Ownable constructor sets the original `owner` of the contract
134     ///      to the sender.
135     constructor()
136         public
137     {
138         owner = msg.sender;
139     }
140 
141     /// @dev Throws if called by any account other than the owner.
142     modifier onlyOwner()
143     {
144         require(msg.sender == owner, "NOT_OWNER");
145         _;
146     }
147 
148     /// @dev Allows the current owner to transfer control of the contract to a
149     ///      newOwner.
150     /// @param newOwner The address to transfer ownership to.
151     function transferOwnership(
152         address newOwner
153         )
154         public
155         onlyOwner
156     {
157         require(newOwner != address(0x0), "ZERO_ADDRESS");
158         emit OwnershipTransferred(owner, newOwner);
159         owner = newOwner;
160     }
161 }
162 
163 contract Claimable is Ownable {
164     address public pendingOwner;
165 
166     /// @dev Modifier throws if called by any account other than the pendingOwner.
167     modifier onlyPendingOwner() {
168         require(msg.sender == pendingOwner, "UNAUTHORIZED");
169         _;
170     }
171 
172     /// @dev Allows the current owner to set the pendingOwner address.
173     /// @param newOwner The address to transfer ownership to.
174     function transferOwnership(
175         address newOwner
176         )
177         public
178         onlyOwner
179     {
180         require(newOwner != address(0x0) && newOwner != owner, "INVALID_ADDRESS");
181         pendingOwner = newOwner;
182     }
183 
184     /// @dev Allows the pendingOwner address to finalize the transfer.
185     function claimOwnership()
186         public
187         onlyPendingOwner
188     {
189         emit OwnershipTransferred(owner, pendingOwner);
190         owner = pendingOwner;
191         pendingOwner = address(0x0);
192     }
193 }
194 
195 
196 /// @title Long-Team Holding Incentive Program
197 /// @author Daniel Wang - <daniel@loopring.org>, Kongliang Zhong - <kongliang@loopring.org>.
198 /// For more information, please visit https://loopring.org.
199 contract NewLRCLongTermHoldingContract is Claimable {
200     using SafeMath for uint;
201     using Math for uint;
202 
203     // During the first 60 days of deployment, this contract opens for deposit of LRC.
204     uint public constant DEPOSIT_PERIOD             = 60 days; // = 2 months
205 
206     // 18 months after deposit, user can withdrawal all or part of his/her LRC with bonus.
207     // The bonus is this contract's initial LRC balance.
208     uint public constant WITHDRAWAL_DELAY           = 540 days; // = 1 year and 6 months
209 
210     // Send 0.001ETH per 10000 LRC partial withdrawal, or 0 for a once-for-all withdrawal.
211     // All ETH will be returned.
212     uint public constant WITHDRAWAL_SCALE           = 1E7; // 1ETH for withdrawal of 10,000,000 LRC.
213 
214     // Ower can drain all remaining LRC after 3 years.
215     uint public constant DRAIN_DELAY                = 1080 days; // = 3 years.
216 
217     address public lrcTokenAddress;
218 
219     uint public lrcDeposited        = 0;
220     uint public depositStartTime    = 1504076273;
221     uint public depositStopTime     = 1509260273;
222 
223     struct Record {
224         uint lrcAmount;
225         uint timestamp;
226     }
227 
228     mapping (address => Record) public records;
229 
230     /*
231      * EVENTS
232      */
233 
234     /// Emitted when program starts.
235     event Started(uint _time);
236 
237     /// Emitted when all LRC are drained.
238     event Drained(uint _lrcAmount);
239 
240     /// Emitted for each sucuessful deposit.
241     uint public depositId = 0;
242     event Deposit(uint _depositId, address indexed _addr, uint _lrcAmount);
243 
244     /// Emitted for each sucuessful deposit.
245     uint public withdrawId = 0;
246     event Withdrawal(uint _withdrawId, address indexed _addr, uint _lrcAmount);
247 
248     /// @dev Initialize the contract
249     /// @param _lrcTokenAddress LRC ERC20 token address
250     constructor(address _lrcTokenAddress) public {
251         require(_lrcTokenAddress != address(0));
252         lrcTokenAddress = _lrcTokenAddress;
253     }
254 
255     /*
256      * PUBLIC FUNCTIONS
257      */
258 
259     /* /// @dev start the program. */
260     /* function start() public onlyOwner { */
261     /*     require(depositStartTime == 0); */
262 
263     /*     depositStartTime = now; */
264     /*     depositStopTime  = depositStartTime + DEPOSIT_PERIOD; */
265 
266     /*     Started(depositStartTime); */
267     /* } */
268 
269 
270     /// @dev drain LRC.
271     function drain() onlyOwner public {
272         require(depositStartTime > 0 && now >= depositStartTime + DRAIN_DELAY);
273 
274         uint balance = lrcBalance();
275         require(balance > 0);
276 
277         require(Token(lrcTokenAddress).transfer(owner, balance));
278 
279         emit Drained(balance);
280     }
281 
282     function () payable external {
283         require(depositStartTime > 0);
284 
285         if (now >= depositStartTime && now <= depositStopTime) {
286             depositLRC();
287         } else if (now > depositStopTime){
288             withdrawLRC();
289         } else {
290             revert();
291         }
292     }
293 
294     /// @return Current LRC balance.
295     function lrcBalance() public view returns (uint) {
296         return Token(lrcTokenAddress).balanceOf(address(this));
297     }
298 
299     function batchAddDepositRecordsByOwner(address[] calldata users, uint[] calldata lrcAmounts, uint[] calldata timestamps) external onlyOwner {
300         require(users.length == lrcAmounts.length);
301         require(users.length == timestamps.length);
302         for (uint i = 0; i < users.length; i++) {
303             require(users[i] != address(0));
304             require(timestamps[i] >= depositStartTime && timestamps[i] <= depositStopTime);
305             Record memory record = Record(lrcAmounts[i], timestamps[i]);
306             records[users[i]] = record;
307 
308             lrcDeposited += lrcAmounts[i];
309 
310             emit Deposit(depositId++, users[i], lrcAmounts[i]);
311         }
312     }
313 
314     /// @dev Deposit LRC.
315     function depositLRC() payable public {
316         require(depositStartTime > 0, "program not started");
317         require(msg.value == 0, "no ether should be sent");
318         require(now >= depositStartTime && now <= depositStopTime, "beyond deposit time period");
319 
320         Token lrcToken = Token(lrcTokenAddress);
321         uint lrcAmount = lrcToken
322             .balanceOf(msg.sender)
323             .min256(lrcToken.allowance(msg.sender, address(this)));
324 
325         require(lrcAmount > 0, "lrc allowance is zero");
326 
327         Record memory record = records[msg.sender];
328         record.lrcAmount += lrcAmount;
329         record.timestamp = now;
330         records[msg.sender] = record;
331 
332         lrcDeposited += lrcAmount;
333 
334         emit Deposit(depositId++, msg.sender, lrcAmount);
335 
336         require(lrcToken.transferFrom(msg.sender, address(this), lrcAmount), "lrc transfer failed");
337     }
338 
339     /// @dev Withdrawal LRC.
340     function withdrawLRC() payable public {
341         require(depositStartTime > 0);
342         require(lrcDeposited > 0);
343 
344         Record memory record = records[msg.sender];
345         require(now >= record.timestamp + WITHDRAWAL_DELAY);
346         require(record.lrcAmount > 0);
347 
348         uint lrcWithdrawalBase = record.lrcAmount;
349         if (msg.value > 0) {
350             lrcWithdrawalBase = lrcWithdrawalBase
351                 .min256(msg.value.mul(WITHDRAWAL_SCALE));
352         }
353 
354         uint lrcBonus = getBonus(lrcWithdrawalBase);
355         uint balance = lrcBalance();
356         uint lrcAmount = balance.min256(lrcWithdrawalBase + lrcBonus);
357 
358         lrcDeposited -= lrcWithdrawalBase;
359         record.lrcAmount -= lrcWithdrawalBase;
360 
361         if (record.lrcAmount == 0) {
362             delete records[msg.sender];
363         } else {
364             records[msg.sender] = record;
365         }
366 
367         emit Withdrawal(withdrawId++, msg.sender, lrcAmount);
368 
369         require(Token(lrcTokenAddress).transfer(msg.sender, lrcAmount));
370         if (msg.value > 0) {
371             msg.sender.transfer(msg.value);
372         }
373     }
374 
375     function getBonus(uint _lrcWithdrawalBase) view public returns (uint) {
376         return internalCalculateBonus(lrcBalance() - lrcDeposited,lrcDeposited, _lrcWithdrawalBase);
377     }
378 
379     function internalCalculateBonus(uint _totalBonusRemaining, uint _lrcDeposited, uint _lrcWithdrawalBase) internal pure returns (uint) {
380         require(_lrcDeposited > 0);
381         require(_totalBonusRemaining >= 0);
382 
383         // The bonus is non-linear function to incentivize later withdrawal.
384         // bonus = _totalBonusRemaining * power(_lrcWithdrawalBase/_lrcDeposited, 1.0625)
385         return _totalBonusRemaining
386             .mul(_lrcWithdrawalBase.mul(sqrt(sqrt(sqrt(sqrt(_lrcWithdrawalBase))))))
387             .div(_lrcDeposited.mul(sqrt(sqrt(sqrt(sqrt(_lrcDeposited))))));
388     }
389 
390     function sqrt(uint x) internal pure returns (uint) {
391         uint y = x;
392         while (true) {
393             uint z = (y + (x / y)) / 2;
394             uint w = (z + (x / z)) / 2;
395             if (w == y) {
396                 if (w < y) return w;
397                 else return y;
398             }
399             y = w;
400         }
401     }
402 }