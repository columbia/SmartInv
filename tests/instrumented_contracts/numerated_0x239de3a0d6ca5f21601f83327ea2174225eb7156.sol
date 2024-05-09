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
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal constant returns (uint256) {
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
56   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
57     return a >= b ? a : b;
58   }
59 
60   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
61     return a < b ? a : b;
62   }
63 
64   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
65     return a >= b ? a : b;
66   }
67 
68   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
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
91     function balanceOf(address _owner) constant returns (uint256 balance);
92 
93     /// @notice send `_value` token to `_to` from `msg.sender`
94     /// @param _to The address of the recipient
95     /// @param _value The amount of token to be transferred
96     /// @return Whether the transfer was successful or not
97     function transfer(address _to, uint256 _value) returns (bool success);
98 
99     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
100     /// @param _from The address of the sender
101     /// @param _to The address of the recipient
102     /// @param _value The amount of token to be transferred
103     /// @return Whether the transfer was successful or not
104     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
105 
106     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
107     /// @param _spender The address of the account able to transfer the tokens
108     /// @param _value The amount of tokens to be approved for transfer
109     /// @return Whether the approval was successful or not
110     function approve(address _spender, uint256 _value) returns (bool success);
111 
112     /// @param _owner The address of the account owning tokens
113     /// @param _spender The address of the account able to transfer the tokens
114     /// @return Amount of remaining tokens allowed to spent
115     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
116 
117     event Transfer(address indexed _from, address indexed _to, uint256 _value);
118     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
119 }
120 
121 
122 
123 /// @title Long-Team Holding Incentive Program
124 /// @author Daniel Wang - <daniel@loopring.org>, Kongliang Zhong - <kongliang@loopring.org>.
125 /// For more information, please visit https://loopring.org.
126 contract LRCLongTermHoldingContract {
127     using SafeMath for uint;
128     using Math for uint;
129     
130     // During the first 60 days of deployment, this contract opens for deposit of LRC.
131     uint public constant DEPOSIT_PERIOD             = 60 days; // = 2 months
132 
133     // 18 months after deposit, user can withdrawal all or part of his/her LRC with bonus.
134     // The bonus is this contract's initial LRC balance.
135     uint public constant WITHDRAWAL_DELAY           = 540 days; // = 1 year and 6 months
136 
137     // Send 0.001ETH per 10000 LRC partial withdrawal, or 0 for a once-for-all withdrawal.
138     // All ETH will be returned.
139     uint public constant WITHDRAWAL_SCALE           = 1E7; // 1ETH for withdrawal of 10,000,000 LRC.
140 
141     // Ower can drain all remaining LRC after 3 years.
142     uint public constant DRAIN_DELAY                = 1080 days; // = 3 years.
143     
144     address public lrcTokenAddress  = 0x0;
145     address public owner            = 0x0;
146 
147     uint public lrcDeposited        = 0;
148     uint public depositStartTime    = 0;
149     uint public depositStopTime     = 0;
150 
151     struct Record {
152         uint lrcAmount;
153         uint timestamp;
154     }
155 
156     mapping (address => Record) records;
157     
158     /* 
159      * EVENTS
160      */
161 
162     /// Emitted when program starts.
163     event Started(uint _time);
164 
165     /// Emitted when all LRC are drained.
166     event Drained(uint _lrcAmount);
167 
168     /// Emitted for each sucuessful deposit.
169     uint public depositId = 0;
170     event Deposit(uint _depositId, address indexed _addr, uint _lrcAmount);
171 
172     /// Emitted for each sucuessful deposit.
173     uint public withdrawId = 0;
174     event Withdrawal(uint _withdrawId, address indexed _addr, uint _lrcAmount);
175 
176     /// @dev Initialize the contract
177     /// @param _lrcTokenAddress LRC ERC20 token address
178     function LRCLongTermHoldingContract(address _lrcTokenAddress, address _owner) {
179         require(_lrcTokenAddress != address(0));
180         require(_owner != address(0));
181 
182         lrcTokenAddress = _lrcTokenAddress;
183         owner = _owner;
184     }
185 
186     /*
187      * PUBLIC FUNCTIONS
188      */
189 
190     /// @dev start the program.
191     function start() public {
192         require(msg.sender == owner);
193         require(depositStartTime == 0);
194 
195         depositStartTime = now;
196         depositStopTime  = depositStartTime + DEPOSIT_PERIOD;
197 
198         Started(depositStartTime);
199     }
200 
201 
202     /// @dev drain LRC.
203     function drain() public {
204         require(msg.sender == owner);
205         require(depositStartTime > 0 && now >= depositStartTime + DRAIN_DELAY);
206 
207         uint balance = lrcBalance();
208         require(balance > 0);
209 
210         require(Token(lrcTokenAddress).transfer(owner, balance));
211 
212         Drained(balance);
213     }
214 
215     function () payable {
216         require(depositStartTime > 0);
217 
218         if (now >= depositStartTime && now <= depositStopTime) {
219             depositLRC();
220         } else if (now > depositStopTime){
221             withdrawLRC();
222         } else {
223             revert();
224         }
225     }
226 
227     /// @return Current LRC balance.
228     function lrcBalance() public constant returns (uint) {
229         return Token(lrcTokenAddress).balanceOf(address(this));
230     }
231 
232     /// @dev Deposit LRC.
233     function depositLRC() payable {
234         require(depositStartTime > 0);
235         require(msg.value == 0);
236         require(now >= depositStartTime && now <= depositStopTime);
237         
238         var lrcToken = Token(lrcTokenAddress);
239         uint lrcAmount = lrcToken
240             .balanceOf(msg.sender)
241             .min256(lrcToken.allowance(msg.sender, address(this)));
242 
243         require(lrcAmount > 0);
244 
245         var record = records[msg.sender];
246         record.lrcAmount += lrcAmount;
247         record.timestamp = now;
248         records[msg.sender] = record;
249 
250         lrcDeposited += lrcAmount;
251 
252         Deposit(depositId++, msg.sender, lrcAmount);
253         
254         require(lrcToken.transferFrom(msg.sender, address(this), lrcAmount));
255     }
256 
257     /// @dev Withdrawal LRC.
258     function withdrawLRC() payable {
259         require(depositStartTime > 0);
260         require(lrcDeposited > 0);
261 
262         var record = records[msg.sender];
263         require(now >= record.timestamp + WITHDRAWAL_DELAY);
264         require(record.lrcAmount > 0);
265 
266         uint lrcWithdrawalBase = record.lrcAmount;
267         if (msg.value > 0) {
268             lrcWithdrawalBase = lrcWithdrawalBase
269                 .min256(msg.value.mul(WITHDRAWAL_SCALE));
270         }
271 
272         uint lrcBonus = getBonus(lrcWithdrawalBase);
273         uint balance = lrcBalance();
274         uint lrcAmount = balance.min256(lrcWithdrawalBase + lrcBonus);
275         
276         lrcDeposited -= lrcWithdrawalBase;
277         record.lrcAmount -= lrcWithdrawalBase;
278 
279         if (record.lrcAmount == 0) {
280             delete records[msg.sender];
281         } else {
282             records[msg.sender] = record;
283         }
284 
285         Withdrawal(withdrawId++, msg.sender, lrcAmount);
286 
287         require(Token(lrcTokenAddress).transfer(msg.sender, lrcAmount));
288         if (msg.value > 0) {
289             msg.sender.transfer(msg.value);
290         }
291     }
292 
293     function getBonus(uint _lrcWithdrawalBase) constant returns (uint) {
294         return internalCalculateBonus(lrcBalance() - lrcDeposited,lrcDeposited, _lrcWithdrawalBase);
295     }
296 
297     function internalCalculateBonus(uint _totalBonusRemaining, uint _lrcDeposited, uint _lrcWithdrawalBase) internal constant returns (uint) {
298         require(_lrcDeposited > 0);
299         require(_totalBonusRemaining >= 0);
300 
301         // The bonus is non-linear function to incentivize later withdrawal.
302         // bonus = _totalBonusRemaining * power(_lrcWithdrawalBase/_lrcDeposited, 1.0625)
303         return _totalBonusRemaining
304             .mul(_lrcWithdrawalBase.mul(sqrt(sqrt(sqrt(sqrt(_lrcWithdrawalBase))))))
305             .div(_lrcDeposited.mul(sqrt(sqrt(sqrt(sqrt(_lrcDeposited))))));
306     }
307 
308     function sqrt(uint x) internal constant returns (uint) {
309         uint y = x;
310         while (true) {
311             uint z = (y + (x / y)) / 2;
312             uint w = (z + (x / z)) / 2;
313             if (w == y) {
314                 if (w < y) return w;
315                 else return y;
316             }
317             y = w;
318         }
319     }
320 }