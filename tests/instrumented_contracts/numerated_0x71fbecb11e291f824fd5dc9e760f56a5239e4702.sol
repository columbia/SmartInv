1 pragma solidity ^0.4.11;
2 /**
3 * Hodld DAO and ERC20 token
4 * Author: CurrencyTycoon on GitHub
5 * License: MIT
6 * Date: 2017
7 *
8 * Deploy with the following args:
9 * "Hodl DAO", 18, "HODL"
10 *
11 */
12 contract HodlDAO {
13     /* ERC20 Public variables of the token */
14     string public version = 'HDAO 0.5';
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
52     event WithdrawalPremature(address indexed by, uint blocksToWait); // Needs to wait blocksToWait before withdrawal unlocked
53     event Deposited(address indexed by, uint256 amount);
54 
55     /**
56      * Initializes contract with initial supply tokens to the creator of the contract
57      * In our case, there's no initial supply. Tokens will be created as ether is sent
58      * to the fall-back function. Then tokens are burned when ether is withdrawn.
59      */
60     function HodlDAO(
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
91         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
92         balanceOf[_to] += _value;                            // Add the same to the recipient
93         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
94     }
95 
96     /** ERC20 approve allows another contract to spend some tokens in your behalf
97      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
98      * @param _spender The address of the account able to transfer the tokens
99      * @param _value The amount of tokens to be approved for transfer
100      * @return Whether the approval was successful or not
101      *
102      *
103      * Note, there are some edge-cases with the ERC-20 approve mechanism. In this case a 'bounds check'
104      * was added to make sure Alice cant' approve Bob for more tokens than she has.
105      * The assumptions are that these scenarios could still happen if not mitigated by Alice:
106      *
107      * Scenario 1:
108      *
109      * The following scenario could be the expected outcome by Alice, but if not, Alice would need to set
110      * her approval to Bob to 0 before Alice purchases more tokens.
111      *
112      *  1. Alice has 100 tokens.
113      *  2. Alice approves 50 tokens for Bob.
114      *  3. Alice approves 100 tokens for Charles
115      *  4. Bob calls transferFrom and receives his 50 tokens.
116      *  5. Charles calls transferFrom and receives the remaining 50 tokens
117      *  6. Charles still has an approval for 50 more tokens from Alice, even though she now owns 0 tokens.
118      *  7. Alice purchases 50 more tokens
119      *  8. Charles sees this, and immediately calls transferFrom and receives those 50 tokens.
120      *
121      * Scenario 2:
122      *
123      * This is a race condition. To mitigate this problem, Alice should set the allowance to 0 in step 2,
124      * then wait until it's mined, then if Bob didn't take the 100 she can set to 50. (Otherwise Bob may
125      * potentially get 150 tokens)
126      *
127      *
128      *  1. Alice approves Bob for 100,
129      *  2. Alice changes it to 50
130      *  3. Bob sees the change in the mempool before it's mined, and sends a new transaction
131      *     that will hopefully win the race and withdraw the 100 first, meanwhile the 50 will
132      *     be mined after and allow Bob to withdraw another 50.
133      *
134      *
135      */
136     function approve(address _spender, uint256 _value) notPendingWithdrawal
137     returns (bool success) {
138 
139         // The following line has been commented out after peer review #2
140         // It may be possible that Alice can pre-approve the recipient in advance, before she has a balance.
141         // eg. Alice may approve a total lifetime amount for her child to spend, but only fund her account monthly.
142         // It also allows her to have multiple equal approvees
143 
144         //if (balanceOf[msg.sender] < _value) return false; // Don't allow more than they currently have (bounds check)
145 
146         // To change the approve amount you first have to reduce the addresses´
147         //  allowance to zero by calling `approve(_spender,0)` if it is not
148         //  already 0 to mitigate the race condition described here:
149         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) throw;
151         allowance[msg.sender][_spender] = _value;
152         Approval(msg.sender, _spender, _value);
153         return true;                                      // we must return a bool as part of the ERC20
154     }
155 
156 
157     /**
158      * ERC-20 Approves and then calls the receiving contract
159     */
160     function approveAndCall(address _spender, uint256 _value, bytes _extraData) notPendingWithdrawal
161     returns (bool success) {
162 
163         if (!approve(_spender, _value)) return false;
164 
165         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
166         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
167         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
168         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
169             throw;
170         }
171         return true;
172     }
173 
174     /**
175      * ERC20 A contract attempts to get the coins. Note: We are not allowing a transfer if
176      * either the from or to address is pending withdrawal
177      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
178      * @param _from The address of the sender
179      * @param _to The address of the recipient
180      * @param _value The amount of token to be transferred
181      * @return Whether the transfer was successful or not
182      */
183     function transferFrom(address _from, address _to, uint256 _value)
184     returns (bool success) {
185         // note that we can't use notPendingWithdrawal modifier here since this function does a transfer
186         // on the behalf of _from
187         if (withdrawalRequests[_from].sinceTime > 0) throw;   // can't move tokens when _from is pending withdrawal
188         if (withdrawalRequests[_to].sinceTime > 0) throw;     // can't move tokens when _to is pending withdrawal
189         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
190         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
191         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
192         balanceOf[_from] -= _value;                           // Subtract from the sender
193         balanceOf[_to] += _value;                             // Add the same to the recipient
194         allowance[_from][msg.sender] -= _value;
195         Transfer(_from, _to, _value);
196         return true;
197     }
198 
199     /**
200      * withdrawalInitiate initiates the withdrawal by going into a waiting period
201      * It remembers the block number & amount held at the time of request.
202      * Tokens cannot be moved out during the waiting period, locking the tokens until then.
203      * After the waiting period finishes, the call withdrawalComplete
204      *
205      * Gas: 64490
206      *
207      */
208     function withdrawalInitiate() notPendingWithdrawal {
209         WithdrawalStarted(msg.sender, balanceOf[msg.sender]);
210         withdrawalRequests[msg.sender] = withdrawalRequest(now, balanceOf[msg.sender]);
211     }
212 
213     /**
214      * withdrawalComplete is called after the waiting period. The ether will be
215      * returned to the caller and the tokens will be burned.
216      * A reward will be issued based on the current amount in the feePot, relative to the
217      * amount that was requested for withdrawal when withdrawalInitiate() was called.
218      *
219      * Gas: 30946
220      */
221     function withdrawalComplete() returns (bool) {
222         withdrawalRequest r = withdrawalRequests[msg.sender];
223         if (r.sinceTime == 0) throw;
224         if ((r.sinceTime + timeWait) > now) {
225             // holder needs to wait some more blocks
226             WithdrawalPremature(msg.sender, r.sinceTime + timeWait - now);
227             return false;
228         }
229         uint256 amount = withdrawalRequests[msg.sender].amount;
230         uint256 reward = calculateReward(r.amount);
231         withdrawalRequests[msg.sender].sinceTime = 0;   // This will unlock the holders tokens
232         withdrawalRequests[msg.sender].amount = 0;      // clear the amount that was requested
233 
234         if (reward > 0) {
235             if (feePot - reward > feePot) {
236                 feePot = 0; // overflow
237             } else {
238                 feePot -= reward;
239             }
240         }
241         doWithdrawal(reward);                           // burn the tokens and send back the ether
242         WithdrawalDone(msg.sender, amount, reward);
243         return true;
244 
245     }
246 
247     /**
248      * Reward is based on the amount held, relative to total supply of tokens.
249      */
250     function calculateReward(uint256 v) constant returns (uint256) {
251         uint256 reward = 0;
252         if (feePot > 0) {
253             reward = feePot * v / totalSupply;
254         }
255         return reward;
256     }
257 
258     /** calculate the fee for quick withdrawal
259      */
260     function calculateFee(uint256 v) constant returns  (uint256) {
261         uint256 feeRequired = v / 100; // 1%
262         return feeRequired;
263     }
264 
265     /**
266      * Quick withdrawal, needs to send ether to this function for the fee.
267      *
268      * Gas use: ? (including call to processWithdrawal)
269     */
270     function quickWithdraw() payable notPendingWithdrawal returns (bool) {
271         uint256 amount = balanceOf[msg.sender];
272         if (amount <= 0) throw;
273         // calculate required fee
274         uint256 feeRequired = calculateFee(amount);
275         if (msg.value != feeRequired) {
276             IncorrectFee(msg.sender, feeRequired);   // notify the exact fee that needs to be sent
277             throw;
278         }
279         feePot += msg.value;                         // add fee to the feePot
280         doWithdrawal(0);                             // withdraw, 0 reward
281         WithdrawalDone(msg.sender, amount, 0);
282         return true;
283     }
284 
285     /**
286      * do withdrawal
287      */
288     function doWithdrawal(uint256 extra) internal {
289         uint256 amount = balanceOf[msg.sender];
290         if (amount <= 0) throw;                      // cannot withdraw
291         if (amount + extra > this.balance) {
292             throw;                                   // contract doesn't have enough balance
293         }
294         balanceOf[msg.sender] = 0;
295         if (totalSupply > totalSupply - amount) {
296             totalSupply = 0;                         // don't let it overflow
297         } else {
298             totalSupply -= amount;                   // deflate the supply!
299         }
300         Transfer(msg.sender, 0, amount);             // burn baby burn
301         if (!msg.sender.send(amount + extra)) throw; // return back the ether or rollback if failed
302     }
303 
304 
305     /**
306      * Fallback function when sending ether to the contract
307      * Gas use: 65051
308     */
309     function () payable notPendingWithdrawal {
310         uint256 amount = msg.value;         // amount that was sent
311         if (amount <= 0) throw;             // need to send some ETH
312         balanceOf[msg.sender] += amount;    // mint new tokens
313         totalSupply += amount;              // track the supply
314         Transfer(0, msg.sender, amount);    // notify of the event
315         Deposited(msg.sender, amount);
316     }
317 }