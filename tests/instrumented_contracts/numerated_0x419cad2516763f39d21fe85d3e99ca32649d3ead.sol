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
21  * Math operations with safety checks
22  */
23 library SafeMath {
24   function mul(uint a, uint b) internal returns (uint) {
25     uint c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint a, uint b) internal returns (uint) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint a, uint b) internal returns (uint) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint a, uint b) internal returns (uint) {
43     uint c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 
48   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
49     return a >= b ? a : b;
50   }
51 
52   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
53     return a < b ? a : b;
54   }
55 
56   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
57     return a >= b ? a : b;
58   }
59 
60   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
61     return a < b ? a : b;
62   }
63 
64   function assert(bool assertion) internal {
65     if (!assertion) {
66       throw;
67     }
68   }
69 }
70 
71 contract Token {
72 
73     /// @return total amount of tokens
74     function totalSupply() constant returns (uint supply) {}
75 
76     /// @param _owner The address from which the balance will be retrieved
77     /// @return The balance
78     function balanceOf(address _owner) constant returns (uint balance) {}
79 
80     /// @dev send `_value` token to `_to` from `msg.sender`
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     /// @return Whether the transfer was successful or not
84     function transfer(address _to, uint _value) returns (bool success) {}
85 
86     /// @dev send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
87     /// @param _from The address of the sender
88     /// @param _to The address of the recipient
89     /// @param _value The amount of token to be transferred
90     /// @return Whether the transfer was successful or not
91     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
92 
93     /// @dev `msg.sender` approves `_addr` to spend `_value` tokens
94     /// @param _spender The address of the account able to transfer the tokens
95     /// @param _value The amount of wei to be approved for transfer
96     /// @return Whether the approval was successful or not
97     function approve(address _spender, uint _value) returns (bool success) {}
98 
99     /// @param _owner The address of the account owning tokens
100     /// @param _spender The address of the account able to transfer the tokens
101     /// @return Amount of remaining tokens allowed to spent
102     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
103 
104     /// Event for a successful transfer.
105     event Transfer(address indexed _from, address indexed _to, uint _value);
106 
107     /// Event for a successful Approval.
108     event Approval(address indexed _owner, address indexed _spender, uint _value);
109 }
110 
111 
112 /// @title Mid-Team Holding Incentive Program
113 /// @author Daniel Wang - <daniel@loopring.org>, Kongliang Zhong - <kongliang@loopring.org>.
114 /// For more information, please visit https://loopring.org.
115 contract LRCMidTermHoldingContract {
116     using SafeMath for uint;
117 
118     address public lrcTokenAddress  = 0x0;
119     address public owner            = 0x0;
120     uint    public rate             = 7500; 
121 
122     // Some stats
123     uint public lrcReceived         = 0;
124     uint public lrcSent             = 0;
125     uint public ethReceived         = 0;
126     uint public ethSent             = 0;
127 
128     mapping (address => uint) lrcBalances; // each user's lrc balance
129     
130     /* 
131      * EVENTS
132      */
133     /// Emitted for each sucuessful deposit.
134     uint public depositId = 0;
135     event Deposit(uint _depositId, address _addr, uint _ethAmount, uint _lrcAmount);
136 
137     /// Emitted for each sucuessful withdrawal.
138     uint public withdrawId = 0;
139     event Withdrawal(uint _withdrawId, address _addr, uint _ethAmount, uint _lrcAmount);
140 
141     /// Emitted when ETH are drained and LRC are drained by owner.
142     event Drained(uint _ethAmount, uint _lrcAmount);
143 
144     /// Emitted when rate changed by owner.
145     event RateChanged(uint _oldRate, uint _newRate);
146 
147     /// CONSTRUCTOR 
148     /// @dev Initialize and start the contract.
149     /// @param _lrcTokenAddress LRC ERC20 token address
150     /// @param _owner Owner of this contract
151     function LRCMidTermHoldingContract(address _lrcTokenAddress, address _owner) {
152         require(_lrcTokenAddress != 0x0);
153         require(_owner != 0x0);
154 
155         lrcTokenAddress = _lrcTokenAddress;
156         owner = _owner;
157     }
158 
159     /*
160      * PUBLIC FUNCTIONS
161      */
162     /// @dev Get back ETH to `owner`.
163     /// @param _rate New rate
164     function setRate(uint _rate) public  {
165         require(msg.sender == owner);
166         require(rate > 0);
167         
168         RateChanged(rate, _rate);
169         rate = _rate;
170     }
171 
172     /// @dev Get back ETH to `owner`.
173     /// @param _ethAmount Amount of ETH to drain back to owner
174     function drain(uint _ethAmount) public payable {
175         require(msg.sender == owner);
176         require(_ethAmount >= 0);
177         
178         uint ethAmount = _ethAmount.min256(this.balance);
179         if (ethAmount > 0){
180             require(owner.send(ethAmount));
181         }
182 
183         var lrcToken = Token(lrcTokenAddress);
184         uint lrcAmount = lrcToken.balanceOf(address(this)) - lrcReceived + lrcSent;
185         if (lrcAmount > 0){
186             require(lrcToken.transfer(owner, lrcAmount));
187         }
188 
189         Drained(ethAmount, lrcAmount);
190     }
191 
192     /// @dev This default function allows simple usage.
193     function () payable {
194         if (msg.sender != owner) {
195             if (msg.value == 0) depositLRC();
196             else withdrawLRC();
197         }
198     }
199 
200   
201     /// @dev Deposit LRC for ETH.
202     /// If user send x ETH, this method will try to transfer `x * 100 * 6500` LRC from
203     /// the user's address and send `x * 100` ETH to the user.
204     function depositLRC() payable {
205         require(msg.sender != owner);
206         require(msg.value == 0);
207 
208         var lrcToken = Token(lrcTokenAddress);
209 
210         uint lrcAmount = this.balance.mul(rate)
211             .min256(lrcToken.balanceOf(msg.sender))
212             .min256(lrcToken.allowance(msg.sender, address(this)));
213 
214         uint ethAmount = lrcAmount.div(rate);
215 
216         require(lrcAmount > 0 && ethAmount > 0);
217         require(ethAmount.mul(rate) <= lrcAmount);
218 
219         lrcBalances[msg.sender] += lrcAmount;
220 
221         lrcReceived += lrcAmount;
222         ethSent += ethAmount;
223 
224         require(lrcToken.transferFrom(msg.sender, address(this), lrcAmount));
225         require(msg.sender.send(ethAmount));
226 
227         Deposit(
228              depositId++,
229              msg.sender,
230              ethAmount,
231              lrcAmount
232         );      
233     }
234 
235     /// @dev Withdrawal LRC with ETH transfer.
236     function withdrawLRC() payable {
237         require(msg.sender != owner);
238         require(msg.value > 0);
239 
240         uint lrcAmount = msg.value.mul(rate)
241             .min256(lrcBalances[msg.sender]);
242 
243         uint ethAmount = lrcAmount.div(rate);
244 
245         require(lrcAmount > 0 && ethAmount > 0);
246 
247         lrcBalances[msg.sender] -= lrcAmount;
248 
249         lrcSent += lrcAmount;
250         ethReceived += ethAmount;
251 
252         require(Token(lrcTokenAddress).transfer(msg.sender, lrcAmount));
253 
254         uint ethRefund = msg.value - ethAmount;
255         if (ethRefund > 0) {
256             require(msg.sender.send(ethRefund));
257         }
258 
259         Withdrawal(
260              withdrawId++,
261              msg.sender,
262              ethAmount,
263              lrcAmount
264         ); 
265     }
266 }