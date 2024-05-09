1 pragma solidity 0.4.25;
2 
3 /// @dev It is ERC20 compliant, but still needs to under go further testing.
4 
5 contract Ownable {
6     address public owner;
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     /**
10      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11      * account.
12      */
13     constructor () public {
14         owner = msg.sender;
15     }
16 
17     /**
18      * @dev Throws if called by any account other than the owner.
19      */
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     /**
26      * @dev Allows the current owner to transfer control of the contract to a newOwner.
27      * @param _newOwner The address to transfer ownership to.
28      */
29     function transferOwnership(address _newOwner) external onlyOwner {
30         require(_newOwner != address(0));
31         owner = _newOwner;
32         emit OwnershipTransferred(owner, _newOwner);
33     }
34 }
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) external;
38 }
39 
40 /// @dev The actual token contract, the default owner is the msg.sender
41 contract SNKToken is Ownable {
42 
43     string public name;                //The Token's name: e.g. DigixDAO Tokens
44     uint8 public decimals;             //Number of decimals of the smallest unit
45     string public symbol;              //An identifier: e.g. REP
46 
47     /// @dev `Checkpoint` is the structure that attaches a block number to a
48     ///  given value, the block number attached is the one that last changed the
49     ///  value
50     struct  Checkpoint {
51 
52         // `fromBlock` is the block number that the value was generated from
53         uint128 fromBlock;
54 
55         // `value` is the amount of tokens at a specific block number
56         uint128 value;
57     }
58 
59     // `creationBlock` is the block number that the Clone Token was created
60     uint public creationBlock;
61 
62     // Flag that determines if the token is transferable or not.
63     bool public transfersEnabled;
64 
65     // `balances` is the map that tracks the balance of each address, in this
66     //  contract when the balance changes the block number that the change
67     //  occurred is also included in the map
68     mapping (address => Checkpoint[]) balances;
69 
70     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
71     mapping (address => mapping (address => uint256)) allowed;
72 
73     // Tracks the history of the `totalSupply` of the token
74     Checkpoint[] totalSupplyHistory;
75 
76     ////////////////
77     // Events
78     ////////////////
79     event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
80     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
82 
83 
84     modifier whenTransfersEnabled() {
85         require(transfersEnabled);
86         _;
87     }
88 
89     ////////////////
90     // Constructor
91     ////////////////
92 
93 
94     constructor () public {
95         name = "SNK";
96         symbol = "SNK";
97         decimals = 18;
98         creationBlock = block.number;
99         transfersEnabled = true;
100 
101         //initial emission
102         uint _amount = 7000000 * (10 ** uint256(decimals));
103         updateValueAtNow(totalSupplyHistory, _amount);
104         updateValueAtNow(balances[msg.sender], _amount);
105         emit Transfer(0, msg.sender, _amount);
106     }
107 
108 
109     /// @notice The fallback function
110     function () public payable {}
111 
112     ///////////////////
113     // ERC20 Methods
114     ///////////////////
115 
116     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
117     /// @param _to The address of the recipient
118     /// @param _amount The amount of tokens to be transferred
119     /// @return Whether the transfer was successful or not
120     function transfer(address _to, uint256 _amount) whenTransfersEnabled external returns (bool) {
121         doTransfer(msg.sender, _to, _amount);
122         return true;
123     }
124 
125     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
126     ///  is approved by `_from`
127     /// @param _from The address holding the tokens being transferred
128     /// @param _to The address of the recipient
129     /// @param _amount The amount of tokens to be transferred
130     /// @return True if the transfer was successful
131     function transferFrom(address _from, address _to, uint256 _amount) whenTransfersEnabled external returns (bool) {
132         // The standard ERC 20 transferFrom functionality
133         require(allowed[_from][msg.sender] >= _amount);
134         allowed[_from][msg.sender] -= _amount;
135         doTransfer(_from, _to, _amount);
136         return true;
137     }
138 
139     /// @dev This is the actual transfer function in the token contract, it can
140     ///  only be called by other functions in this contract.
141     /// @param _from The address holding the tokens being transferred
142     /// @param _to The address of the recipient
143     /// @param _amount The amount of tokens to be transferred
144     /// @return True if the transfer was successful
145     function doTransfer(address _from, address _to, uint _amount) internal {
146 
147         if (_amount == 0) {
148             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
149             return;
150         }
151 
152         // Do not allow transfer to 0x0 or the token contract itself
153         require((_to != 0) && (_to != address(this)));
154 
155         // If the amount being transfered is more than the balance of the
156         //  account the transfer throws
157         uint previousBalanceFrom = balanceOfAt(_from, block.number);
158 
159         require(previousBalanceFrom >= _amount);
160 
161         // First update the balance array with the new value for the address
162         //  sending the tokens
163         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
164 
165         // Then update the balance array with the new value for the address
166         //  receiving the tokens
167         uint previousBalanceTo = balanceOfAt(_to, block.number);
168         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
169         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
170 
171         // An event to make the transfer easy to find on the blockchain
172         emit Transfer(_from, _to, _amount);
173 
174     }
175 
176     /// @param _owner The address that's balance is being requested
177     /// @return The balance of `_owner` at the current block
178     function balanceOf(address _owner) external view returns (uint256 balance) {
179         return balanceOfAt(_owner, block.number);
180     }
181 
182     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
183     ///  its behalf. This is a modified version of the ERC20 approve function
184     ///  to be a little bit safer
185     /// @param _spender The address of the account able to transfer the tokens
186     /// @param _amount The amount of tokens to be approved for transfer
187     /// @return True if the approval was successful
188     function approve(address _spender, uint256 _amount) whenTransfersEnabled public returns (bool) {
189         // To change the approve amount you first have to reduce the addresses`
190         //  allowance to zero by calling `approve(_spender,0)` if it is not
191         //  already 0 to mitigate the race condition described here:
192         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
194 
195         allowed[msg.sender][_spender] = _amount;
196         emit Approval(msg.sender, _spender, _amount);
197         return true;
198     }
199 
200     /**
201      * @dev Increase the amount of tokens that an owner allowed to a spender.
202      *
203      * approve should be called when allowance[_spender] == 0. To increment
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * @param _spender The address which will spend the funds.
208      * @param _addedAmount The amount of tokens to increase the allowance by.
209      */
210     function increaseApproval(address _spender, uint _addedAmount) external returns (bool) {
211         require(allowed[msg.sender][_spender] + _addedAmount >= allowed[msg.sender][_spender]); // Check for overflow
212         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedAmount;
213         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217     /**
218      * @dev Decrease the amount of tokens that an owner allowed to a spender.
219      *
220      * approve should be called when allowance[_spender] == 0. To decrement
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _subtractedAmount The amount of tokens to decrease the allowance by.
226      */
227     function decreaseApproval(address _spender, uint _subtractedAmount) external returns (bool)
228     {
229         uint oldValue = allowed[msg.sender][_spender];
230         if (_subtractedAmount >= oldValue) {
231             allowed[msg.sender][_spender] = 0;
232         } else {
233             allowed[msg.sender][_spender] = oldValue - _subtractedAmount;
234         }
235         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236         return true;
237     }
238 
239 
240     /// @dev This function makes it easy to read the `allowed[]` map
241     /// @param _owner The address of the account that owns the token
242     /// @param _spender The address of the account able to transfer the tokens
243     /// @return Amount of remaining tokens of _owner that _spender is allowed
244     ///  to spend
245     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
246         return allowed[_owner][_spender];
247     }
248 
249     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
250     ///  its behalf, and then a function is triggered in the contract that is
251     ///  being approved, `_spender`. This allows users to use their tokens to
252     ///  interact with contracts in one function call instead of two
253     /// @param _spender The address of the contract able to transfer the tokens
254     /// @param _amount The amount of tokens to be approved for transfer
255     /// @return True if the function call was successful
256     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) external returns (bool) {
257         require(approve(_spender, _amount));
258 
259         ApproveAndCallFallBack(_spender).receiveApproval(
260             msg.sender,
261             _amount,
262             this,
263             _extraData
264         );
265 
266         return true;
267     }
268 
269     /// @dev This function makes it easy to get the total number of tokens
270     /// @return The total number of tokens
271     function totalSupply() external view returns (uint) {
272         return totalSupplyAt(block.number);
273     }
274 
275 
276     ////////////////
277     // Query balance and totalSupply in History
278     ////////////////
279 
280     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
281     /// @param _owner The address from which the balance will be retrieved
282     /// @param _blockNumber The block number when the balance is queried
283     /// @return The balance at `_blockNumber`
284     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
285         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
286             return 0;
287             // This will return the expected balance during normal situations
288         } else {
289             return getValueAt(balances[_owner], _blockNumber);
290         }
291     }
292 
293     /// @notice Total amount of tokens at a specific `_blockNumber`.
294     /// @param _blockNumber The block number when the totalSupply is queried
295     /// @return The total amount of tokens at `_blockNumber`
296     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
297         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
298             return 0;
299             // This will return the expected totalSupply during normal situations
300         } else {
301             return getValueAt(totalSupplyHistory, _blockNumber);
302         }
303     }
304 
305 
306     ////////////////
307     // Enable tokens transfers
308     ////////////////
309 
310 
311     /// @notice Enables token holders to transfer their tokens freely if true
312     /// @param _transfersEnabled True if transfers are allowed in the clone
313     function enableTransfers(bool _transfersEnabled) public onlyOwner {
314         transfersEnabled = _transfersEnabled;
315     }
316 
317     ////////////////
318     // Internal helper functions to query and set a value in a snapshot array
319     ////////////////
320 
321     /// @dev `getValueAt` retrieves the number of tokens at a given block number
322     /// @param checkpoints The history of values being queried
323     /// @param _block The block number to retrieve the value at
324     /// @return The number of tokens being queried
325     function getValueAt(Checkpoint[] storage checkpoints, uint _block) view internal returns (uint) {
326         if (checkpoints.length == 0) return 0;
327 
328         // Shortcut for the actual value
329         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
330             return checkpoints[checkpoints.length-1].value;
331         if (_block < checkpoints[0].fromBlock) return 0;
332 
333         // Binary search of the value in the array
334         uint min = 0;
335         uint max = checkpoints.length-1;
336         while (max > min) {
337             uint mid = (max + min + 1)/ 2;
338             if (checkpoints[mid].fromBlock<=_block) {
339                 min = mid;
340             } else {
341                 max = mid-1;
342             }
343         }
344         return checkpoints[min].value;
345     }
346 
347     /// @dev `updateValueAtNow` used to update the `balances` map and the
348     ///  `totalSupplyHistory`
349     /// @param checkpoints The history of data being updated
350     /// @param _value The new number of tokens
351     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {
352         if ((checkpoints.length == 0)
353             || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
354             Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
355             newCheckPoint.fromBlock =  uint128(block.number);
356             newCheckPoint.value = uint128(_value);
357         } else {
358             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
359             oldCheckPoint.value = uint128(_value);
360         }
361     }
362 
363 
364     /// @dev Helper function to return a min betwen the two uints
365     function min(uint a, uint b) pure internal returns (uint) {
366         return a < b ? a : b;
367     }
368 
369 
370 
371     //////////
372     // Safety Methods
373     //////////
374 
375     /// @notice This method can be used by the owner to extract mistakenly
376     ///  sent tokens to this contract.
377     /// @param _token The address of the token contract that you want to recover
378     ///  set to 0 in case you want to extract ether.
379     function claimTokens(address _token) external onlyOwner {
380         if (_token == 0x0) {
381             owner.transfer(address(this).balance);
382             return;
383         }
384 
385         SNKToken token = SNKToken(_token);
386         uint balance = token.balanceOf(this);
387         token.transfer(owner, balance);
388         emit ClaimedTokens(_token, owner, balance);
389     }
390 }