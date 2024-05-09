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
18 pragma solidity ^0.4.11;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal constant returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal constant returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title Math
53  * @dev Assorted math operations
54  */
55 
56 library Math {
57   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
58     return a >= b ? a : b;
59   }
60 
61   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
62     return a < b ? a : b;
63   }
64 
65   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
66     return a >= b ? a : b;
67   }
68 
69   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
70     return a < b ? a : b;
71   }
72 }
73 
74 // Abstract contract for the full ERC 20 Token standard
75 // https://github.com/ethereum/EIPs/issues/20
76 
77 contract Token {
78     /* This is a slight change to the ERC20 base standard.
79     function totalSupply() constant returns (uint256 supply);
80     is replaced with:
81     uint256 public totalSupply;
82     This automatically creates a getter function for the totalSupply.
83     This is moved to the base contract since public getter functions are not
84     currently recognised as an implementation of the matching abstract
85     function by the compiler.
86     */
87     /// total amount of tokens
88     uint256 public totalSupply;
89 
90     /// @param _owner The address from which the balance will be retrieved
91     /// @return The balance
92     function balanceOf(address _owner) constant returns (uint256 balance);
93 
94     /// @notice send `_value` token to `_to` from `msg.sender`
95     /// @param _to The address of the recipient
96     /// @param _value The amount of token to be transferred
97     /// @return Whether the transfer was successful or not
98     function transfer(address _to, uint256 _value) returns (bool success);
99 
100     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
101     /// @param _from The address of the sender
102     /// @param _to The address of the recipient
103     /// @param _value The amount of token to be transferred
104     /// @return Whether the transfer was successful or not
105     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
106 
107     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
108     /// @param _spender The address of the account able to transfer the tokens
109     /// @param _value The amount of tokens to be approved for transfer
110     /// @return Whether the approval was successful or not
111     function approve(address _spender, uint256 _value) returns (bool success);
112 
113     /// @param _owner The address of the account owning tokens
114     /// @param _spender The address of the account able to transfer the tokens
115     /// @return Amount of remaining tokens allowed to spent
116     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
117 
118     event Transfer(address indexed _from, address indexed _to, uint256 _value);
119     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
120 }
121 
122 
123 /// @title Mid-Team Holding Incentive Program
124 /// @author Daniel Wang - <daniel@loopring.org>, Kongliang Zhong - <kongliang@loopring.org>.
125 /// For more information, please visit https://loopring.org.
126 contract LRCMidTermHoldingContract {
127     using SafeMath for uint;
128     using Math for uint;
129 
130     // During the first 60 days of deployment, this contract opens for deposit of LRC
131     // in exchange of ETH.
132     uint public constant DEPOSIT_WINDOW                 = 60 days;
133 
134     // For each address, its LRC can only be withdrawn between 180 and 270 days after LRC deposit,
135     // which means:
136     //    1) LRC are locked during the first 180 days,
137     //    2) LRC will be sold to the `owner` with the specified `RATE` 270 days after the deposit.
138     uint public constant WITHDRAWAL_DELAY               = 180 days;
139     uint public constant WITHDRAWAL_WINDOW              = 90  days;
140 
141     uint public constant MAX_LRC_DEPOSIT_PER_ADDRESS    = 150000 ether; // = 20 ETH * 7500
142 
143     // 7500 LRC for 1 ETH. This is the best token sale rate ever.
144     uint public constant RATE       = 7500;
145 
146     address public lrcTokenAddress  = 0x0;
147     address public owner            = 0x0;
148 
149     // Some stats
150     uint public lrcReceived         = 0;
151     uint public lrcSent             = 0;
152     uint public ethReceived         = 0;
153     uint public ethSent             = 0;
154 
155     uint public depositStartTime    = 0;
156     uint public depositStopTime     = 0;
157 
158     bool public closed              = false;
159 
160     struct Record {
161         uint lrcAmount;
162         uint timestamp;
163     }
164 
165     mapping (address => Record) records;
166 
167     /*
168      * EVENTS
169      */
170     /// Emitted when program starts.
171     event Started(uint _time);
172 
173     /// Emitted for each sucuessful deposit.
174     uint public depositId = 0;
175     event Deposit(uint _depositId, address indexed _addr, uint _ethAmount, uint _lrcAmount);
176 
177     /// Emitted for each sucuessful withdrawal.
178     uint public withdrawId = 0;
179     event Withdrawal(uint _withdrawId, address indexed _addr, uint _ethAmount, uint _lrcAmount);
180 
181     /// Emitted when this contract is closed.
182     event Closed(uint _ethAmount, uint _lrcAmount);
183 
184     /// Emitted when ETH are drained.
185     event Drained(uint _ethAmount);
186 
187     /// CONSTRUCTOR
188     /// @dev Initialize and start the contract.
189     /// @param _lrcTokenAddress LRC ERC20 token address
190     /// @param _owner Owner of this contract
191     function LRCMidTermHoldingContract(address _lrcTokenAddress, address _owner) {
192         require(_lrcTokenAddress != address(0));
193         require(_owner != address(0));
194 
195         lrcTokenAddress = _lrcTokenAddress;
196         owner = _owner;
197     }
198 
199     /*
200      * PUBLIC FUNCTIONS
201      */
202 
203     /// @dev Get back ETH to `owner`.
204     /// @param ethAmount Amount of ETH to drain back to owner
205     function drain(uint ethAmount) public payable {
206         require(!closed);
207         require(msg.sender == owner);
208 
209         uint amount = ethAmount.min256(this.balance);
210         require(amount > 0);
211         owner.transfer(amount);
212 
213         Drained(amount);
214     }
215 
216     /// @dev Set depositStartTime
217     function start() public {
218         require(msg.sender == owner);
219         require(depositStartTime == 0);
220 
221         depositStartTime = now;
222         depositStopTime  = now + DEPOSIT_WINDOW;
223 
224         Started(depositStartTime);
225     }
226 
227     /// @dev Get all ETH and LRC back to `owner`.
228     function close() public payable {
229         require(!closed);
230         require(msg.sender == owner);
231         require(now > depositStopTime + WITHDRAWAL_DELAY + WITHDRAWAL_WINDOW);
232 
233         uint ethAmount = this.balance;
234         if (ethAmount > 0) {
235             owner.transfer(ethAmount);
236         }
237 
238         var lrcToken = Token(lrcTokenAddress);
239         uint lrcAmount = lrcToken.balanceOf(address(this));
240         if (lrcAmount > 0) {
241             require(lrcToken.transfer(owner, lrcAmount));
242         }
243 
244         closed = true;
245         Closed(ethAmount, lrcAmount);
246     }
247 
248     /// @dev This default function allows simple usage.
249     function () payable {
250         require(!closed);
251 
252         if (msg.sender != owner) {
253             if (now <= depositStopTime) depositLRC();
254             else withdrawLRC();
255         }
256     }
257 
258 
259     /// @dev Deposit LRC for ETH.
260     /// If user send x ETH, this method will try to transfer `x * 100 * 6500` LRC from
261     /// the user's address and send `x * 100` ETH to the user.
262     function depositLRC() payable {
263         require(!closed && msg.sender != owner);
264         require(now <= depositStopTime);
265         require(msg.value == 0);
266 
267         var record = records[msg.sender];
268         var lrcToken = Token(lrcTokenAddress);
269 
270         uint lrcAmount = this.balance.mul(RATE)
271             .min256(lrcToken.balanceOf(msg.sender))
272             .min256(lrcToken.allowance(msg.sender, address(this)))
273             .min256(MAX_LRC_DEPOSIT_PER_ADDRESS - record.lrcAmount);
274 
275         uint ethAmount = lrcAmount.div(RATE);
276         lrcAmount = ethAmount.mul(RATE);
277 
278         require(lrcAmount > 0 && ethAmount > 0);
279 
280         record.lrcAmount += lrcAmount;
281         record.timestamp = now;
282         records[msg.sender] = record;
283 
284         lrcReceived += lrcAmount;
285         ethSent += ethAmount;
286 
287 
288         Deposit(
289                 depositId++,
290                 msg.sender,
291                 ethAmount,
292                 lrcAmount
293                 );
294         require(lrcToken.transferFrom(msg.sender, address(this), lrcAmount));
295         msg.sender.transfer(ethAmount);
296     }
297 
298     /// @dev Withdrawal LRC with ETH transfer.
299     function withdrawLRC() payable {
300         require(!closed && msg.sender != owner);
301         require(now > depositStopTime);
302         require(msg.value > 0);
303 
304         var record = records[msg.sender];
305         require(now >= record.timestamp + WITHDRAWAL_DELAY);
306         require(now <= record.timestamp + WITHDRAWAL_DELAY + WITHDRAWAL_WINDOW);
307 
308         uint ethAmount = msg.value.min256(record.lrcAmount.div(RATE));
309         uint lrcAmount = ethAmount.mul(RATE);
310 
311         record.lrcAmount -= lrcAmount;
312         if (record.lrcAmount == 0) {
313             delete records[msg.sender];
314         } else {
315             records[msg.sender] = record;
316         }
317 
318         lrcSent += lrcAmount;
319         ethReceived += ethAmount;
320 
321         Withdrawal(
322                    withdrawId++,
323                    msg.sender,
324                    ethAmount,
325                    lrcAmount
326                    );
327 
328         require(Token(lrcTokenAddress).transfer(msg.sender, lrcAmount));
329 
330         uint ethRefund = msg.value - ethAmount;
331         if (ethRefund > 0) {
332             msg.sender.transfer(ethRefund);
333         }
334     }
335 
336     function getLRCAmount(address addr) public constant returns (uint) {
337         return records[addr].lrcAmount;
338     }
339 
340     function getTimestamp(address addr) public constant returns (uint) {
341         return records[addr].timestamp;
342     }
343 }