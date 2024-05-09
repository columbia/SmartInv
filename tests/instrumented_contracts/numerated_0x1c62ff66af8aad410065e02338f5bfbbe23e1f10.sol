1 pragma solidity 0.6.4;
2 
3 
4 interface Token {
5 
6     /// @return supply total amount of tokens
7     function totalSupply() external view returns (uint256 supply);
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return balance The balance
11     function balanceOf(address _owner) external view returns (uint256 balance);
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return success Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) external returns (bool success);
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return success Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
25 
26     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return success Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) external returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return remaining Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     // Optionally implemented function to show the number of decimals for the token
41     function decimals() external view returns (uint8 decimals);
42 }
43 
44 /// @title Utils
45 /// @notice Utils contract for various helpers used by the Raiden Network smart
46 /// contracts.
47 contract Utils {
48     enum MessageTypeId {
49         None,
50         BalanceProof,
51         BalanceProofUpdate,
52         Withdraw,
53         CooperativeSettle,
54         IOU,
55         MSReward
56     }
57 
58     /// @notice Check if a contract exists
59     /// @param contract_address The address to check whether a contract is
60     /// deployed or not
61     /// @return True if a contract exists, false otherwise
62     function contractExists(address contract_address) public view returns (bool) {
63         uint size;
64 
65         assembly {
66             size := extcodesize(contract_address)
67         }
68 
69         return size > 0;
70     }
71 }
72 
73 contract UserDeposit is Utils {
74     uint constant public withdraw_delay = 100;  // time before withdraw is allowed in blocks
75 
76     // Token to be used for the deposit
77     Token public token;
78 
79     // Trusted contracts (can execute `transfer`)
80     address public msc_address;
81     address public one_to_n_address;
82 
83     // Total amount of tokens that have been deposited. This is monotonous and
84     // doing a transfer or withdrawing tokens will not decrease total_deposit!
85     mapping(address => uint256) public total_deposit;
86     // Current user's balance, ignoring planned withdraws
87     mapping(address => uint256) public balances;
88     mapping(address => WithdrawPlan) public withdraw_plans;
89 
90     // The sum of all balances
91     uint256 public whole_balance = 0;
92     // Deposit limit for this whole contract
93     uint256 public whole_balance_limit;
94 
95     /*
96      *  Structs
97      */
98     struct WithdrawPlan {
99         uint256 amount;
100         uint256 withdraw_block;  // earliest block at which withdraw is allowed
101     }
102 
103     /*
104      *  Events
105      */
106 
107     event BalanceReduced(address indexed owner, uint newBalance);
108     event WithdrawPlanned(address indexed withdrawer, uint plannedBalance);
109 
110     /*
111      *  Modifiers
112      */
113 
114     modifier canTransfer() {
115         require(msg.sender == msc_address || msg.sender == one_to_n_address, "unknown caller");
116         _;
117     }
118 
119     /*
120      *  Constructor
121      */
122 
123     /// @notice Set the default values for the smart contract
124     /// @param _token_address The address of the token to use for rewards
125     constructor(address _token_address, uint256 _whole_balance_limit)
126         public
127     {
128         // check token contract
129         require(_token_address != address(0x0), "token at address zero");
130         require(contractExists(_token_address), "token has no code");
131         token = Token(_token_address);
132         require(token.totalSupply() > 0, "token has no total supply"); // Check if the contract is indeed a token contract
133         // check and set the whole balance limit
134         require(_whole_balance_limit > 0, "whole balance limit is zero");
135         whole_balance_limit = _whole_balance_limit;
136     }
137 
138     /// @notice Specify trusted contracts. This has to be done outside of the
139     /// constructor to avoid cyclic dependencies.
140     /// @param _msc_address Address of the MonitoringService contract
141     /// @param _one_to_n_address Address of the OneToN contract
142     function init(address _msc_address, address _one_to_n_address)
143         external
144     {
145         // prevent changes of trusted contracts after initialization
146         require(msc_address == address(0x0) && one_to_n_address == address(0x0), "already initialized");
147 
148         // check monitoring service contract
149         require(_msc_address != address(0x0), "MS contract at address zero");
150         require(contractExists(_msc_address), "MS contract has no code");
151         msc_address = _msc_address;
152 
153         // check one to n contract
154         require(_one_to_n_address != address(0x0), "OneToN at address zero");
155         require(contractExists(_one_to_n_address), "OneToN has no code");
156         one_to_n_address = _one_to_n_address;
157     }
158 
159     /// @notice Deposit tokens. The amount of transferred tokens will be
160     /// `new_total_deposit - total_deposit[beneficiary]`. This makes the
161     /// function behavior predictable and idempotent. Can be called several
162     /// times and on behalf of other accounts.
163     /// @param beneficiary The account benefiting from the deposit
164     /// @param new_total_deposit The total sum of tokens that have been
165     /// deposited by the user by calling this function.
166     function deposit(address beneficiary, uint256 new_total_deposit)
167         external
168     {
169         require(new_total_deposit > total_deposit[beneficiary], "deposit not increasing");
170 
171         // Calculate the actual amount of tokens that will be transferred
172         uint256 added_deposit = new_total_deposit - total_deposit[beneficiary];
173 
174         balances[beneficiary] += added_deposit;
175         total_deposit[beneficiary] += added_deposit;
176 
177         // Update whole_balance, but take care against overflows.
178         require(whole_balance + added_deposit >= whole_balance, "overflowing deposit");
179         whole_balance += added_deposit;
180 
181         // Decline deposit if the whole balance is bigger than the limit.
182         require(whole_balance <= whole_balance_limit, "too much deposit");
183 
184         // Actual transfer.
185         require(token.transferFrom(msg.sender, address(this), added_deposit), "tokens didn't transfer");
186     }
187 
188     /// @notice Internally transfer deposits between two addresses.
189     /// Sender and receiver must be different or the transaction will fail.
190     /// @param sender Account from which the amount will be deducted
191     /// @param receiver Account to which the amount will be credited
192     /// @param amount Amount of tokens to be transferred
193     /// @return success true if transfer has been done successfully, otherwise false
194     function transfer(
195         address sender,
196         address receiver,
197         uint256 amount
198     )
199         canTransfer()
200         external
201         returns (bool success)
202     {
203         require(sender != receiver, "sender == receiver");
204         if (balances[sender] >= amount && amount > 0) {
205             balances[sender] -= amount;
206             balances[receiver] += amount;
207             emit BalanceReduced(sender, balances[sender]);
208             return true;
209         } else {
210             return false;
211         }
212     }
213 
214     /// @notice Announce intention to withdraw tokens.
215     /// Sets the planned withdraw amount and resets the withdraw_block.
216     /// There is only one planned withdrawal at a time, the old one gets overwritten.
217     /// @param amount Maximum amount of tokens to be withdrawn
218     function planWithdraw(uint256 amount)
219         external
220     {
221         require(amount > 0, "withdrawing zero");
222         require(balances[msg.sender] >= amount, "withdrawing too much");
223 
224         withdraw_plans[msg.sender] = WithdrawPlan({
225             amount: amount,
226             withdraw_block: block.number + withdraw_delay
227         });
228         emit WithdrawPlanned(msg.sender, balances[msg.sender] - amount);
229     }
230 
231     /// @notice Execute a planned withdrawal
232     /// Will only work after the withdraw_delay has expired.
233     /// An amount lower or equal to the planned amount may be withdrawn.
234     /// Removes the withdraw plan even if not the full amount has been
235     /// withdrawn.
236     /// @param amount Amount of tokens to be withdrawn
237     function withdraw(uint256 amount)
238         external
239     {
240         WithdrawPlan storage withdraw_plan = withdraw_plans[msg.sender];
241         require(amount <= withdraw_plan.amount, "withdrawing more than planned");
242         require(withdraw_plan.withdraw_block <= block.number, "withdrawing too early");
243         uint256 withdrawable = min(amount, balances[msg.sender]);
244         balances[msg.sender] -= withdrawable;
245 
246         // Update whole_balance, but take care against underflows.
247         require(whole_balance - withdrawable <= whole_balance, "underflow in whole_balance");
248         whole_balance -= withdrawable;
249 
250         emit BalanceReduced(msg.sender, balances[msg.sender]);
251         delete withdraw_plans[msg.sender];
252 
253         require(token.transfer(msg.sender, withdrawable), "tokens didn't transfer");
254     }
255 
256     /// @notice The owner's balance with planned withdrawals deducted
257     /// @param owner Address for which the balance should be returned
258     /// @return remaining_balance The remaining balance after planned withdrawals
259     function effectiveBalance(address owner)
260         external
261         view
262         returns (uint256 remaining_balance)
263     {
264         WithdrawPlan storage withdraw_plan = withdraw_plans[owner];
265         if (withdraw_plan.amount > balances[owner]) {
266             return 0;
267         }
268         return balances[owner] - withdraw_plan.amount;
269     }
270 
271     function min(uint256 a, uint256 b) pure internal returns (uint256)
272     {
273         return a > b ? b : a;
274     }
275 }
276 
277 
278 // MIT License
279 
280 // Copyright (c) 2018
281 
282 // Permission is hereby granted, free of charge, to any person obtaining a copy
283 // of this software and associated documentation files (the "Software"), to deal
284 // in the Software without restriction, including without limitation the rights
285 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
286 // copies of the Software, and to permit persons to whom the Software is
287 // furnished to do so, subject to the following conditions:
288 
289 // The above copyright notice and this permission notice shall be included in all
290 // copies or substantial portions of the Software.
291 
292 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
293 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
294 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
295 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
296 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
297 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
298 // SOFTWARE.