1 pragma solidity ^0.4.10;
2 /**
3 * Hodld DAO and ERC20 token
4 * Author: CurrencyTycoon on GitHub
5 * License: MIT
6 * Date: 2017
7 *
8 * Deploy with the following args:
9 * 0, "Hodl DAO", 18, "HODL"
10 *
11 */
12 contract HodlDAO {
13     /* ERC20 Public variables of the token */
14     string public version = 'HDAO 0.2';
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
28     uint sinceBlock;
29     uint256 amount;
30 }
31 
32     /**
33      * feePot collects fees from quick withdrawals. This gets re-distributed to slow-withdrawals
34     */
35     uint256 public feePot;
36 
37     uint32 public constant blockWait = 172800; // roughly 30 days,  (2592000 / 15) - assuming block time is ~15 sec.
38     //uint public constant blockWait = 8; // roughly assuming block time is ~15 sec.
39 
40 
41     /**
42      * ERC20 events these generate a public event on the blockchain that will notify clients
43     */
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47     event WithdrawalQuick(address indexed by, uint256 amount, uint256 fee); // quick withdrawal done
48     event InsufficientFee(address indexed by, uint256 feeRequired);  // not enough fee paid for quick withdrawal
49     event WithdrawalStarted(address indexed by, uint256 amount);
50     event WithdrawalDone(address indexed by, uint256 amount, uint256 reward); // amount is the amount that was used to calculate reward
51     event WithdrawalPremature(address indexed by, uint blocksToWait); // Needs to wait blocksToWait before withdrawal unlocked
52     event Deposited(address indexed by, uint256 amount);
53 
54     /**
55      * Initializes contract with initial supply tokens to the creator of the contract
56      * In our case, there's no initial supply. Tokens will be created as ether is sent
57      * to the fall-back function. Then tokens are burned when ether is withdrawn.
58      */
59     function HodlDAO(
60     uint256 initialSupply,
61     string tokenName,
62     uint8 decimalUnits,
63     string tokenSymbol
64     ) {
65 
66         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
67         totalSupply = initialSupply;                        // Update total supply
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
78         if (withdrawalRequests[msg.sender].sinceBlock > 0) throw;
79         _;
80     }
81 
82 
83     /** ERC20 - transfer sends tokens
84      * @notice send `_value` token to `_to` from `msg.sender`
85      * @param _to The address of the recipient
86      * @param _value The amount of token to be transferred
87      * @return Whether the transfer was successful or not
88      */
89     function transfer(address _to, uint256 _value) notPendingWithdrawal {
90         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
91         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
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
102      */
103     function approve(address _spender, uint256 _value) notPendingWithdrawal
104     returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         return true;
107     }
108 
109 
110     /**
111      * ERC-20 Approves and then calls the receiving contract
112     */
113     function approveAndCall(address _spender, uint256 _value, bytes _extraData) notPendingWithdrawal
114     returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117 
118     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
119     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
120     //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
121         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
122         return true;
123     }
124 
125     /**
126      * ERC20 A contract attempts to get the coins
127      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
128      * @param _from The address of the sender
129      * @param _to The address of the recipient
130      * @param _value The amount of token to be transferred
131      * @return Whether the transfer was successful or not
132      */
133     function transferFrom(address _from, address _to, uint256 _value)  notPendingWithdrawal
134     returns (bool success) {
135         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
136         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
137         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
138         balanceOf[_from] -= _value;                           // Subtract from the sender
139         balanceOf[_to] += _value;                             // Add the same to the recipient
140         allowance[_from][msg.sender] -= _value;
141         Transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /**
146      * withdrawalInitiate initiates the withdrawal by going into a waiting period
147      * It remembers the block number & amount held at the time of request.
148      * After the waiting period finishes, the call withdrawalComplete
149      */
150     function withdrawalInitiate() notPendingWithdrawal {
151         WithdrawalStarted(msg.sender, balanceOf[msg.sender]);
152         withdrawalRequests[msg.sender] = withdrawalRequest(block.number, balanceOf[msg.sender]);
153     }
154 
155     /**
156      * withdrawalComplete is called after the waiting period. The ether will be
157      * returned to the caller and the tokens will be burned.
158      * A reward will be issued based on the amount in the feePot relative to the
159      * amount held when the withdrawal request was made.
160      *
161      * Gas: 17008
162      */
163     function withdrawalComplete() returns (bool) {
164         withdrawalRequest r = withdrawalRequests[msg.sender];
165         if (r.sinceBlock == 0) throw;
166         if ((r.sinceBlock + blockWait) > block.number) {
167             WithdrawalPremature(msg.sender, r.sinceBlock + blockWait - block.number);
168             return false;
169         }
170         uint256 amount = withdrawalRequests[msg.sender].amount;
171         uint256 reward = calculateReward(r.amount);
172         withdrawalRequests[msg.sender].sinceBlock = 0;
173         withdrawalRequests[msg.sender].amount = 0;
174 
175         if (reward > 0) {
176             if (feePot - reward > feePot) {
177                 feePot = 0; // overflow
178             } else {
179                 feePot -= reward;
180             }
181         }
182         doWithdrawal(reward);
183         WithdrawalDone(msg.sender, amount, reward);
184         return true;
185 
186     }
187 
188     /**
189      * Reward is based on the amount held, relative to total supply of tokens.
190      */
191     function calculateReward(uint256 v) constant returns (uint256) {
192         uint256 reward = 0;
193         if (feePot > 0) {
194             reward = v / totalSupply * feePot;
195         }
196         return reward;
197     }
198 
199     /** calculate the fee for quick withdrawal
200      */
201     function calculateFee(uint256 v) constant returns  (uint256) {
202         uint256 feeRequired = v / (1 wei * 100);
203         return feeRequired;
204     }
205 
206     /**
207      * Quick withdrawal, needs to send ether to this function for the fee.
208      *
209      * Gas use: 44129 (including call to processWithdrawal)
210     */
211     function quickWithdraw() payable notPendingWithdrawal returns (bool) {
212         // calculate required fee
213         uint256 amount = balanceOf[msg.sender];
214         if (amount <= 0) throw;
215         uint256 feeRequired = calculateFee(amount);
216         if (msg.value < feeRequired) {
217             // not enough fees sent
218             InsufficientFee(msg.sender, feeRequired);
219             return false;
220         }
221         uint256 overAmount = msg.value - feeRequired; // calculate any over-payment
222         // add fee to the feePot, excluding any over-payment
223 
224         if (overAmount > 0) {
225             feePot += msg.value - overAmount;
226         } else {
227             feePot += msg.value;
228         }
229 
230         doWithdrawal(overAmount); // withdraw + return any over payment
231         WithdrawalDone(msg.sender, amount, 0);
232         return true;
233     }
234 
235     /**
236      * do withdrawal
237      * Gas: 62483
238      */
239     function doWithdrawal(uint256 extra) internal {
240         uint256 amount = balanceOf[msg.sender];
241 
242         if (amount <= 0) throw;                 // cannot withdraw
243         balanceOf[msg.sender] = 0;
244         if (totalSupply > totalSupply - amount) {
245             totalSupply = 0; // don't let it overflow
246         } else {
247             totalSupply -= amount; // deflate the supply!
248         }
249         Transfer(msg.sender, 0, amount); // burn baby burn
250         if (!msg.sender.send(amount + extra)) throw; // return back the ether or rollback if failed
251     }
252 
253 
254     /**
255      * Fallback function when sending ether to the contract
256      * Gas use: 65051
257     */
258     function () payable notPendingWithdrawal {
259         uint256 amount = msg.value;  // amount that was sent
260         if (amount <= 0) throw; // need to send some ETH
261         balanceOf[msg.sender] += amount; // mint new tokens
262         totalSupply += amount; // track the supply
263         Transfer(0, msg.sender, amount); // notify of the event
264         Deposited(msg.sender, amount);
265     }
266 }