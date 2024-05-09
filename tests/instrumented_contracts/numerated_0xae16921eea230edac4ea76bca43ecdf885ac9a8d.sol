1 pragma solidity ^0.4.20;
2 
3 contract SONICToken {
4     /* ERC20 Public variables of the token */
5     string public constant version = 'SONIC 0.1';
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10 
11     /* ERC20 This creates an array with all balances */
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15 
16     /* store the block number when a withdrawal has been requested*/
17     mapping (address => withdrawalRequest) public withdrawalRequests;
18     struct withdrawalRequest {
19     uint sinceTime;
20     uint256 amount;
21     }
22 
23     /**
24      * feePot collects fees from quick withdrawals. This gets re-distributed to slow-withdrawals
25     */
26     uint256 public feePot;
27 
28     uint public timeWait = 30 days;
29    // uint public timeWait = 10 minutes; // uncomment for TestNet
30 
31     uint256 public constant initialSupply = 6000500;
32 
33     /**
34      * ERC20 events these generate a public event on the blockchain that will notify clients
35     */
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39     event WithdrawalQuick(address indexed by, uint256 amount, uint256 fee); // quick withdrawal done
40     event IncorrectFee(address indexed by, uint256 feeRequired);  // incorrect fee paid for quick withdrawal
41     event WithdrawalStarted(address indexed by, uint256 amount);
42     event WithdrawalDone(address indexed by, uint256 amount, uint256 reward); // amount is the amount that was used to calculate reward
43     event WithdrawalPremature(address indexed by, uint timeToWait); // Needs to wait timeToWait before withdrawal unlocked
44     event Deposited(address indexed by, uint256 amount);
45 
46     /**
47      * Initializes contract with initial supply tokens to the creator of the contract
48      * In our case, there's no initial supply. Tokens will be created as ether is sent
49      * to the fall-back function. Then tokens are burned when ether is withdrawn.
50      */
51     function SONICToken(
52     string tokenName,
53     uint8 decimalUnits,
54     string tokenSymbol
55     ) {
56 
57         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens (0 in this case)
58         totalSupply = initialSupply;                        // Update total supply (0 in this case)
59         name = tokenName;                                   // Set the name for display purposes
60         symbol = tokenSymbol;                               // Set the symbol for display purposes
61         decimals = decimalUnits;                            // Amount of decimals for display purposes
62     }
63 
64     /**
65      * notPendingWithdrawal modifier guards the function from executing when a
66      * withdrawal has been requested and is currently pending
67      */
68     modifier notPendingWithdrawal {
69         if (withdrawalRequests[msg.sender].sinceTime > 0) throw;
70         _;
71     }
72 
73     /** ERC20 - transfer sends tokens
74      * @notice send `_value` token to `_to` from `msg.sender`
75      * @param _to The address of the recipient
76      * @param _value The amount of token to be transferred
77      * @return Whether the transfer was successful or not
78      */
79     function transfer(address _to, uint256 _value) notPendingWithdrawal {
80         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
82         if (withdrawalRequests[_to].sinceTime > 0) throw;    // can't move tokens when _to is pending withdrawal
83         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
84         balanceOf[_to] += _value;                            // Add the same to the recipient
85         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
86     }
87 
88     /** ERC20 approve allows another contract to spend some tokens in your behalf
89      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
90      * @param _spender The address of the account able to transfer the tokens
91      * @param _value The amount of tokens to be approved for transfer
92      * @return Whether the approval was successful or not
93      */
94     function approve(address _spender, uint256 _value) notPendingWithdrawal
95     returns (bool success) {
96         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) throw;
97         allowance[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         return true;                                      // we must return a bool as part of the ERC20
100     }
101 
102 
103     /**
104      * ERC-20 Approves and then calls the receiving contract
105     */
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData) notPendingWithdrawal
107     returns (bool success) {
108 
109         if (!approve(_spender, _value)) return false;
110 
111         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
112             throw;
113         }
114         return true;
115     }
116 
117     /**
118      * ERC20 A contract attempts to get the coins. Note: We are not allowing a transfer if
119      * either the from or to address is pending withdrawal
120      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
121      * @param _from The address of the sender
122      * @param _to The address of the recipient
123      * @param _value The amount of token to be transferred
124      * @return Whether the transfer was successful or not
125      */
126     function transferFrom(address _from, address _to, uint256 _value)
127     returns (bool success) {
128         // note that we can't use notPendingWithdrawal modifier here since this function does a transfer
129         // on the behalf of _from
130         if (withdrawalRequests[_from].sinceTime > 0) throw;   // can't move tokens when _from is pending withdrawal
131         if (withdrawalRequests[_to].sinceTime > 0) throw;     // can't move tokens when _to is pending withdrawal
132         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
133         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
134         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
135         balanceOf[_from] -= _value;                           // Subtract from the sender
136         balanceOf[_to] += _value;                             // Add the same to the recipient
137         allowance[_from][msg.sender] -= _value;
138         Transfer(_from, _to, _value);
139         return true;
140     }
141 
142     /**
143      * withdrawalInitiate initiates the withdrawal by going into a waiting period
144      * It remembers the block number & amount held at the time of request.
145      * Tokens cannot be moved out during the waiting period, locking the tokens until then.
146      * After the waiting period finishes, the call withdrawalComplete
147      *
148      * Gas: 64490
149      *
150      */
151     function withdrawalInitiate() notPendingWithdrawal {
152         WithdrawalStarted(msg.sender, balanceOf[msg.sender]);
153         withdrawalRequests[msg.sender] = withdrawalRequest(now, balanceOf[msg.sender]);
154     }
155 
156     /**
157      * withdrawalComplete is called after the waiting period. The ether will be
158      * returned to the caller and the tokens will be burned.
159      * A reward will be issued based on the current amount in the feePot, relative to the
160      * amount that was requested for withdrawal when withdrawalInitiate() was called.
161      *
162      * Gas: 30946
163      */
164     function withdrawalComplete() returns (bool) {
165         withdrawalRequest r = withdrawalRequests[msg.sender];
166         if (r.sinceTime == 0) throw;
167         if ((r.sinceTime + timeWait) > now) {
168             // holder needs to wait some more blocks
169             WithdrawalPremature(msg.sender, r.sinceTime + timeWait - now);
170             return false;
171         }
172         uint256 amount = withdrawalRequests[msg.sender].amount;
173         uint256 reward = calculateReward(r.amount);
174         withdrawalRequests[msg.sender].sinceTime = 0;   // This will unlock the holders tokens
175         withdrawalRequests[msg.sender].amount = 0;      // clear the amount that was requested
176 
177         if (reward > 0) {
178             if (feePot - reward > feePot) {             // underflow check
179                 feePot = 0;
180             } else {
181                 feePot -= reward;
182             }
183         }
184         doWithdrawal(reward);                           // burn the tokens and send back the ether
185         WithdrawalDone(msg.sender, amount, reward);
186         return true;
187 
188     }
189 
190     /**
191      * Reward is based on the amount held, relative to total supply of tokens.
192      */
193     function calculateReward(uint256 v) constant returns (uint256) {
194         uint256 reward = 0;
195         if (feePot > 0) {
196             reward = feePot * v / totalSupply; // assuming that if feePot > 0 then also totalSupply > 0
197         }
198         return reward;
199     }
200 
201     /** calculate the fee for quick withdrawal
202      */
203     function calculateFee(uint256 v) constant returns  (uint256) {
204         uint256 feeRequired = v / 100; // 1%
205         return feeRequired;
206     }
207 
208     /**
209      * Quick withdrawal, needs to send ether to this function for the fee.
210      *
211      * Gas use: ? (including call to processWithdrawal)
212     */
213     function quickWithdraw() payable notPendingWithdrawal returns (bool) {
214         uint256 amount = balanceOf[msg.sender];
215         if (amount == 0) throw;
216         // calculate required fee
217         uint256 feeRequired = calculateFee(amount);
218         if (msg.value != feeRequired) {
219             IncorrectFee(msg.sender, feeRequired);   // notify the exact fee that needs to be sent
220             throw;
221         }
222         feePot += msg.value;                         // add fee to the feePot
223         doWithdrawal(0);                             // withdraw, 0 reward
224         WithdrawalDone(msg.sender, amount, 0);
225         return true;
226     }
227 
228     /**
229      * do withdrawal
230      */
231     function doWithdrawal(uint256 extra) internal {
232         uint256 amount = balanceOf[msg.sender];
233         if (amount == 0) throw;                      // cannot withdraw
234         if (amount + extra > this.balance) {
235             throw;                                   // contract doesn't have enough balance
236         }
237 
238         balanceOf[msg.sender] = 0;
239         if (totalSupply < totalSupply - amount) {
240             throw;                                   // don't let it underflow (should not happen since amount <= totalSupply)
241         } else {
242             totalSupply -= amount;                   // deflate the supply!
243         }
244         Transfer(msg.sender, 0, amount);             // burn baby burn
245         if (!msg.sender.send(amount + extra)) throw; // return back the ether or rollback if failed
246     }
247 
248 
249     /**
250      * Fallback function when sending ether to the contract
251      * Gas use: 65051
252     */
253     function () payable notPendingWithdrawal {
254         uint256 amount = msg.value;         // amount that was sent
255         if (amount == 0) throw;             // need to send some ETH
256         balanceOf[msg.sender] += amount;    // mint new tokens
257         totalSupply += amount;              // track the supply
258         Transfer(0, msg.sender, amount);    // notify of the event
259         Deposited(msg.sender, amount);
260     }
261 }