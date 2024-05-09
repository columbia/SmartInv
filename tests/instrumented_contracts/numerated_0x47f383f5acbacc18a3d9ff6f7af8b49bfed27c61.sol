1 pragma solidity ^0.4.11;
2 /**
3 * Eth Hodler (f.k.a. Hodl DAO) and ERC20 token
4 * Author: CurrencyTycoon on GitHub
5 * License: MIT
6 * Date: 2017
7 *
8 * Deploy with the following args:
9 * "Eth Hodler", 18, "EHDL"
10 *
11 */
12 contract EthHodler {
13     /* ERC20 Public variables of the token */
14     string public constant version = 'HDAO 0.7';
15     string public name;
16     string public symbol;
17     uint8 public decimals;
18     uint256 public totalSupply;
19 
20     /* ERC20 This creates an array with all balances */
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowance;
23 
24 
25     /* store the block number when a withdrawal has been requested*/
26     mapping (address => withdrawalRequest) public withdrawalRequests;
27     struct withdrawalRequest {
28     uint sinceTime;
29     uint256 amount;
30     }
31 
32     /**
33      * feePot collects fees from quick withdrawals. This gets re-distributed to slow-withdrawals
34     */
35     uint256 public feePot;
36 
37     uint public timeWait = 30 days;
38     //uint public timeWait = 1 minutes; // uncomment for TestNet
39 
40     uint256 public constant initialSupply = 0;
41 
42     /**
43      * ERC20 events these generate a public event on the blockchain that will notify clients
44     */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 
48     event WithdrawalQuick(address indexed by, uint256 amount, uint256 fee); // quick withdrawal done
49     event IncorrectFee(address indexed by, uint256 feeRequired);  // incorrect fee paid for quick withdrawal
50     event WithdrawalStarted(address indexed by, uint256 amount);
51     event WithdrawalDone(address indexed by, uint256 amount, uint256 reward); // amount is the amount that was used to calculate reward
52     event WithdrawalPremature(address indexed by, uint timeToWait); // Needs to wait timeToWait before withdrawal unlocked
53     event Deposited(address indexed by, uint256 amount);
54 
55     /**
56      * Initializes contract with initial supply tokens to the creator of the contract
57      * In our case, there's no initial supply. Tokens will be created as ether is sent
58      * to the fall-back function. Then tokens are burned when ether is withdrawn.
59      */
60     function EthHodler(
61     string tokenName,
62     uint8 decimalUnits,
63     string tokenSymbol
64     ) {
65 
66         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens (0 in this case)
67         totalSupply = initialSupply;                        // Update total supply (0 in this case)
68         name = tokenName;                                   // Set the name for display purposes
69         symbol = tokenSymbol;                               // Set the symbol for display purposes
70         decimals = decimalUnits;                            // Amount of decimals for display purposes
71     }
72 
73     /**
74      * notPendingWithdrawal modifier guards the function from executing when a
75      * withdrawal has been requested and is currently pending
76      */
77     modifier notPendingWithdrawal {
78         if (withdrawalRequests[msg.sender].sinceTime > 0) throw;
79         _;
80     }
81 
82     /** ERC20 - transfer sends tokens
83      * @notice send `_value` token to `_to` from `msg.sender`
84      * @param _to The address of the recipient
85      * @param _value The amount of token to be transferred
86      * @return Whether the transfer was successful or not
87      */
88     function transfer(address _to, uint256 _value) notPendingWithdrawal {
89         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
90         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
91         if (withdrawalRequests[_to].sinceTime > 0) throw;    // can't move tokens when _to is pending withdrawal
92         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
93         balanceOf[_to] += _value;                            // Add the same to the recipient
94         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
95     }
96 
97     /** ERC20 approve allows another contract to spend some tokens in your behalf
98      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
99      * @param _spender The address of the account able to transfer the tokens
100      * @param _value The amount of tokens to be approved for transfer
101      * @return Whether the approval was successful or not
102      *
103      *
104      * Note, there are some edge-cases with the ERC-20 approve mechanism. In this case a 'bounds check'
105      * was added to make sure Alice cant' approve Bob for more tokens than she has.
106      * The assumptions are that these scenarios could still happen if not mitigated by Alice:
107      *
108      * Scenario 1:
109      *
110      * The following scenario could be the expected outcome by Alice, but if not, Alice would need to set
111      * her approval to Bob to 0 before Alice purchases more tokens.
112      *
113      *  1. Alice has 100 tokens.
114      *  2. Alice approves 50 tokens for Bob.
115      *  3. Alice approves 100 tokens for Charles
116      *  4. Bob calls transferFrom and receives his 50 tokens.
117      *  5. Charles calls transferFrom and receives the remaining 50 tokens
118      *  6. Charles still has an approval for 50 more tokens from Alice, even though she now owns 0 tokens.
119      *  7. Alice purchases 50 more tokens
120      *  8. Charles sees this, and immediately calls transferFrom and receives those 50 tokens.
121      *
122      * Scenario 2:
123      *
124      * This is a race condition. To mitigate this problem, Alice should set the allowance to 0 in step 2,
125      * then wait until it's mined, then if Bob didn't take the 100 she can set to 50. (Otherwise Bob may
126      * potentially get 150 tokens)
127      *
128      *
129      *  1. Alice approves Bob for 100,
130      *  2. Alice changes it to 50
131      *  3. Bob sees the change in the mempool before it's mined, and sends a new transaction
132      *     that will hopefully win the race and withdraw the 100 first, meanwhile the 50 will
133      *     be mined after and allow Bob to withdraw another 50.
134      *
135      *
136      */
137     function approve(address _spender, uint256 _value) notPendingWithdrawal
138     returns (bool success) {
139 
140         // The following line has been commented out after peer review #2
141         // It may be possible that Alice can pre-approve the recipient in advance, before she has a balance.
142         // eg. Alice may approve a total lifetime amount for her child to spend, but only fund her account monthly.
143         // It also allows her to have multiple equal approvees
144 
145         //if (balanceOf[msg.sender] < _value) return false; // Don't allow more than they currently have (bounds check)
146 
147         // To change the approve amount you first have to reduce the addresses´
148         //  allowance to zero by calling `approve(_spender,0)` if it is not
149         //  already 0 to mitigate the race condition described here:
150         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) throw;
152         allowance[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;                                      // we must return a bool as part of the ERC20
155     }
156 
157 
158     /**
159      * ERC-20 Approves and then calls the receiving contract
160     */
161     function approveAndCall(address _spender, uint256 _value, bytes _extraData) notPendingWithdrawal
162     returns (bool success) {
163 
164         if (!approve(_spender, _value)) return false;
165 
166         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
167         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
168         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
169         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
170             throw;
171         }
172         return true;
173     }
174 
175     /**
176      * ERC20 A contract attempts to get the coins. Note: We are not allowing a transfer if
177      * either the from or to address is pending withdrawal
178      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
179      * @param _from The address of the sender
180      * @param _to The address of the recipient
181      * @param _value The amount of token to be transferred
182      * @return Whether the transfer was successful or not
183      */
184     function transferFrom(address _from, address _to, uint256 _value)
185     returns (bool success) {
186         // note that we can't use notPendingWithdrawal modifier here since this function does a transfer
187         // on the behalf of _from
188         if (withdrawalRequests[_from].sinceTime > 0) throw;   // can't move tokens when _from is pending withdrawal
189         if (withdrawalRequests[_to].sinceTime > 0) throw;     // can't move tokens when _to is pending withdrawal
190         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
191         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
192         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
193         balanceOf[_from] -= _value;                           // Subtract from the sender
194         balanceOf[_to] += _value;                             // Add the same to the recipient
195         allowance[_from][msg.sender] -= _value;
196         Transfer(_from, _to, _value);
197         return true;
198     }
199 
200     /**
201      * withdrawalInitiate initiates the withdrawal by going into a waiting period
202      * It remembers the block number & amount held at the time of request.
203      * Tokens cannot be moved out during the waiting period, locking the tokens until then.
204      * After the waiting period finishes, the call withdrawalComplete
205      *
206      * Gas: 64490
207      *
208      */
209     function withdrawalInitiate() notPendingWithdrawal {
210         WithdrawalStarted(msg.sender, balanceOf[msg.sender]);
211         withdrawalRequests[msg.sender] = withdrawalRequest(now, balanceOf[msg.sender]);
212     }
213 
214     /**
215      * withdrawalComplete is called after the waiting period. The ether will be
216      * returned to the caller and the tokens will be burned.
217      * A reward will be issued based on the current amount in the feePot, relative to the
218      * amount that was requested for withdrawal when withdrawalInitiate() was called.
219      *
220      * Gas: 30946
221      */
222     function withdrawalComplete() returns (bool) {
223         withdrawalRequest r = withdrawalRequests[msg.sender];
224         if (r.sinceTime == 0) throw;
225         if ((r.sinceTime + timeWait) > now) {
226             // holder needs to wait some more blocks
227             WithdrawalPremature(msg.sender, r.sinceTime + timeWait - now);
228             return false;
229         }
230         uint256 amount = withdrawalRequests[msg.sender].amount;
231         uint256 reward = calculateReward(r.amount);
232         withdrawalRequests[msg.sender].sinceTime = 0;   // This will unlock the holders tokens
233         withdrawalRequests[msg.sender].amount = 0;      // clear the amount that was requested
234 
235         if (reward > 0) {
236             if (feePot - reward > feePot) {             // underflow check
237                 feePot = 0;
238             } else {
239                 feePot -= reward;
240             }
241         }
242         doWithdrawal(reward);                           // burn the tokens and send back the ether
243         WithdrawalDone(msg.sender, amount, reward);
244         return true;
245 
246     }
247 
248     /**
249      * Reward is based on the amount held, relative to total supply of tokens.
250      */
251     function calculateReward(uint256 v) constant returns (uint256) {
252         uint256 reward = 0;
253         if (feePot > 0) {
254             reward = feePot * v / totalSupply; // assuming that if feePot > 0 then also totalSupply > 0
255         }
256         return reward;
257     }
258 
259     /** calculate the fee for quick withdrawal
260      */
261     function calculateFee(uint256 v) constant returns  (uint256) {
262         uint256 feeRequired = v / 100; // 1%
263         return feeRequired;
264     }
265 
266     /**
267      * Quick withdrawal, needs to send ether to this function for the fee.
268      *
269      * Gas use: ? (including call to processWithdrawal)
270     */
271     function quickWithdraw() payable notPendingWithdrawal returns (bool) {
272         uint256 amount = balanceOf[msg.sender];
273         if (amount == 0) throw;
274         // calculate required fee
275         uint256 feeRequired = calculateFee(amount);
276         if (msg.value != feeRequired) {
277             IncorrectFee(msg.sender, feeRequired);   // notify the exact fee that needs to be sent
278             throw;
279         }
280         feePot += msg.value;                         // add fee to the feePot
281         doWithdrawal(0);                             // withdraw, 0 reward
282         WithdrawalDone(msg.sender, amount, 0);
283         return true;
284     }
285 
286     /**
287      * do withdrawal
288      */
289     function doWithdrawal(uint256 extra) internal {
290         uint256 amount = balanceOf[msg.sender];
291         if (amount == 0) throw;                      // cannot withdraw
292         if (amount + extra > this.balance) {
293             throw;                                   // contract doesn't have enough balance
294         }
295 
296         balanceOf[msg.sender] = 0;
297         if (totalSupply < totalSupply - amount) {
298             throw;                                   // don't let it underflow (should not happen since amount <= totalSupply)
299         } else {
300             totalSupply -= amount;                   // deflate the supply!
301         }
302         Transfer(msg.sender, 0, amount);             // burn baby burn
303         if (!msg.sender.send(amount + extra)) throw; // return back the ether or rollback if failed
304     }
305 
306 
307     /**
308      * Fallback function when sending ether to the contract
309      * Gas use: 65051
310     */
311     function () payable notPendingWithdrawal {
312         uint256 amount = msg.value;         // amount that was sent
313         if (amount == 0) throw;             // need to send some ETH
314         balanceOf[msg.sender] += amount;    // mint new tokens
315         totalSupply += amount;              // track the supply
316         Transfer(0, msg.sender, amount);    // notify of the event
317         Deposited(msg.sender, amount);
318     }
319 }