1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMathForBoost {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       revert();
51     }
52   }
53 }
54 
55 
56 contract Boost {
57     using SafeMathForBoost for uint256;
58 
59     string public name = "Boost";         // トークン名
60     uint8 public decimals = 0;            // 小数点以下何桁か
61     string public symbol = "BST";         // トークンの単位
62     uint256 public totalSupply = 100000000;  // 総供給量
63 
64     // `balances` is the map that tracks the balance of each address, in this
65     //  contract when the balance changes the block number that the change
66     //  occurred is also included in the map
67     mapping (address => Checkpoint[]) balances;
68 
69     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
70     mapping (address => mapping (address => uint256)) allowed;
71 
72     /// @dev `Checkpoint` is the structure that attaches a block number to a
73     ///  given value, the block number attached is the one that last changed the
74     ///  value
75     struct  Checkpoint {
76 
77         // `fromBlock` is the block number that the value was generated from
78         uint256 fromBlock;
79 
80         // `value` is the amount of tokens at a specific block number
81         uint256 value;
82     }
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
86 
87     /// @notice constructor
88     function Boost() public {
89         balances[msg.sender].push(Checkpoint({
90             fromBlock:block.number,
91             value:totalSupply
92         }));
93     }
94 
95     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
96     /// @param _to The address of the recipient
97     /// @param _amount The amount of tokens to be transferred
98     /// @return Whether the transfer was successful or not
99     function transfer(address _to, uint256 _amount) public returns (bool success) {
100         doTransfer(msg.sender, _to, _amount);
101         return true;
102     }
103 
104     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
105     ///  is approved by `_from`
106     /// @param _from The address holding the tokens being transferred
107     /// @param _to The address of the recipient
108     /// @param _amount The amount of tokens to be transferred
109     /// @return True if the transfer was successful
110     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
111 
112         // The standard ERC 20 transferFrom functionality
113         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
114 
115         doTransfer(_from, _to, _amount);
116         return true;
117     }
118 
119     /// @param _owner The address that's balance is being requested
120     /// @return The balance of `_owner` at the current block
121     function balanceOf(address _owner) public view returns (uint256 balance) {
122         return balanceOfAt(_owner, block.number);
123     }
124 
125     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
126     ///  its behalf. This is a modified version of the ERC20 approve function
127     ///  to be a little bit safer
128     /// @param _spender The address of the account able to transfer the tokens
129     /// @param _amount The amount of tokens to be approved for transfer
130     /// @return True if the approval was successful
131     function approve(address _spender, uint256 _amount) public returns (bool success) {
132 
133         // To change the approve amount you first have to reduce the addresses`
134         //  allowance to zero by calling `approve(_spender,0)` if it is not
135         //  already 0 to mitigate the race condition described here:
136         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
138 
139         allowed[msg.sender][_spender] = _amount;
140         Approval(msg.sender, _spender, _amount);
141         return true;
142     }
143 
144     /// @dev This function makes it easy to read the `allowed[]` map
145     /// @param _owner The address of the account that owns the token
146     /// @param _spender The address of the account able to transfer the tokens
147     /// @return Amount of remaining tokens of _owner that _spender is allowed
148     ///  to spend
149     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
150         return allowed[_owner][_spender];
151     }
152 
153     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
154     /// @param _owner The address from which the balance will be retrieved
155     /// @param _blockNumber The block number when the balance is queried
156     /// @return The balance at `_blockNumber`
157     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
158         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
159             return 0;
160         } else {
161             return getValueAt(balances[_owner], _blockNumber);
162         }
163     }
164 
165     /// @dev This is the actual transfer function in the token contract, it can
166     ///  only be called by other functions in this contract.
167     /// @param _from The address holding the tokens being transferred
168     /// @param _to The address of the recipient
169     /// @param _amount The amount of tokens to be transferred
170     /// @return True if the transfer was successful
171     function doTransfer(address _from, address _to, uint _amount) internal {
172 
173         // Do not allow transfer to 0x0 or the token contract itself
174         require((_to != 0) && (_to != address(this)) && (_amount != 0));
175 
176         // First update the balance array with the new value for the address
177         // sending the tokens
178         var previousBalanceFrom = balanceOfAt(_from, block.number);
179         updateValueAtNow(balances[_from], previousBalanceFrom.sub(_amount));
180 
181         // Then update the balance array with the new value for the address
182         // receiving the tokens
183         var previousBalanceTo = balanceOfAt(_to, block.number);
184         updateValueAtNow(balances[_to], previousBalanceTo.add(_amount));
185 
186         // An event to make the transfer easy to find on the blockchain
187         Transfer(_from, _to, _amount);
188 
189     }
190 
191     /// @dev `getValueAt` retrieves the number of tokens at a given block number
192     /// @param checkpoints The history of values being queried
193     /// @param _block The block number to retrieve the value at
194     /// @return The number of tokens being queried
195     function getValueAt(Checkpoint[] storage checkpoints, uint _block) internal view  returns (uint) {
196         if (checkpoints.length == 0) return 0;
197 
198         // Shortcut for the actual value
199         if (_block >= checkpoints[checkpoints.length - 1].fromBlock)
200             return checkpoints[checkpoints.length - 1].value;
201         if (_block < checkpoints[0].fromBlock) return 0;
202 
203         // Binary search of the value in the array
204         uint min = 0;
205         uint max = checkpoints.length - 1;
206         while (max > min) {
207             uint mid = (max + min + 1) / 2;
208             if (checkpoints[mid].fromBlock <= _block) {
209                 min = mid;
210             } else {
211                 max = mid - 1;
212             }
213         }
214         return checkpoints[min].value;
215     }
216 
217     /// @dev `updateValueAtNow` used to update the `balances` map and the
218     ///  `totalSupplyHistory`
219     /// @param checkpoints The history of data being updated
220     /// @param _value The new number of tokens
221     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
222         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
223             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
224             newCheckPoint.fromBlock = block.number;
225             newCheckPoint.value = _value;
226         } else {
227             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
228             oldCheckPoint.value = _value;
229         }
230     }
231 
232     /// @dev Helper function to return a min between the two uints
233     function min(uint a, uint b) internal pure returns (uint) {
234         return a < b ? a : b;
235     }
236 }
237 
238 
239 // @title EtherContainer to store ether for investor to withdraw
240 contract BoostContainer {
241     using SafeMathForBoost for uint256;
242 
243     // multiSigAddress
244     address public multiSigAddress;
245     bool public paused = false;
246 
247     // Boost token
248     Boost public boost;
249 
250     // Array about ether information per month for dividend
251     InfoForDeposit[] public arrayInfoForDeposit;
252 
253     // Mapping to check this account has already withdrawn
254     mapping(address => uint256) public mapCompletionNumberForWithdraw;
255 
256     // Event
257     event LogDepositForDividend(uint256 blockNumber, uint256 etherAountForDividend);
258     event LogWithdrawal(address indexed tokenHolder, uint256 etherValue);
259     event LogPause();
260     event LogUnpause();
261 
262     // Struct of deposit infomation for dividend
263     struct InfoForDeposit {
264         uint256 blockNumber;
265         uint256 depositedEther;
266     }
267 
268     // Check this msg.sender has right to withdraw
269     modifier isNotCompletedForWithdrawal(address _address) {
270         require(mapCompletionNumberForWithdraw[_address] != arrayInfoForDeposit.length);
271         _;
272     }
273 
274     // Check whether msg.sender is multiSig or not
275     modifier onlyMultiSig() {
276         require(msg.sender == multiSigAddress);
277         _;
278     }
279 
280     // Modifier to make a function callable only when the contract is not paused.
281     modifier whenNotPaused() {
282         require(!paused);
283         _;
284     }
285 
286     // Modifier to make a function callable only when the contract is paused.
287     modifier whenPaused() {
288         require(paused);
289         _;
290     }
291 
292     /// @dev constructor
293     /// @param _boostAddress The address of boost token
294     /// @param _multiSigAddress The address of multiSigWallet to send ether
295     function BoostContainer(address _boostAddress, address _multiSigAddress) public {
296         boost = Boost(_boostAddress);
297         multiSigAddress = _multiSigAddress;
298     }
299 
300     /// @dev Deposit `msg.value` in arrayInfoForDeposit
301     /// @param _blockNumber The blockNumber to specify the token amount that each address has at this blockNumber
302     function depositForDividend(uint256 _blockNumber) public payable onlyMultiSig whenNotPaused {
303         require(msg.value > 0);
304 
305         arrayInfoForDeposit.push(InfoForDeposit({blockNumber:_blockNumber, depositedEther:msg.value}));
306 
307         LogDepositForDividend(_blockNumber, msg.value);
308     }
309 
310     /// @dev Withdraw dividendEther
311     function withdraw() public isNotCompletedForWithdrawal(msg.sender) whenNotPaused {
312 
313         // get withdrawAmount that msg.sender can withdraw
314         uint256 withdrawAmount = getWithdrawValue(msg.sender);
315 
316         require(withdrawAmount > 0);
317 
318         // set the arrayInfoForDeposit.length to mapCompletionNumberForWithdraw
319         mapCompletionNumberForWithdraw[msg.sender] = arrayInfoForDeposit.length;
320 
321         // execute transfer
322         msg.sender.transfer(withdrawAmount);
323 
324         // send event
325         LogWithdrawal(msg.sender, withdrawAmount);
326     }
327 
328     /// @dev Change multiSigAddress
329     /// @param _address MultiSigAddress
330     function changeMultiSigAddress(address _address) public onlyMultiSig {
331         require(_address != address(0));
332         multiSigAddress = _address;
333     }
334 
335     /// @dev Get the row length of arrayInfoForDeposit
336     /// @return The length of arrayInfoForDeposit
337     function getArrayInfoForDepositCount() public view returns (uint256 result) {
338         return arrayInfoForDeposit.length;
339     }
340 
341     /// @dev Get withdraw value
342     /// @param _address The account that has this information
343     /// @return WithdrawAmount that account can withdraw
344     function getWithdrawValue(address _address) public view returns (uint256 withdrawAmount) {
345         uint256 validNumber = mapCompletionNumberForWithdraw[_address];
346         uint256 blockNumber;
347         uint256 depositedEther;
348         uint256 tokenAmount;
349 
350         for (uint256 i = 0; i < arrayInfoForDeposit.length; i++) {
351             if (i < validNumber) {
352                 continue;
353             }
354 
355             // get blockNumber and depositedEther based on the validNumber
356             blockNumber = arrayInfoForDeposit[i].blockNumber;
357             depositedEther = arrayInfoForDeposit[i].depositedEther;
358 
359             // get the amount of Boost token that msg.sender had based on blockNumber
360             tokenAmount = boost.balanceOfAt(_address, blockNumber);
361 
362             // tokenAmount * depositedEther / totalSupply(100,000,000)
363             withdrawAmount = withdrawAmount.add(tokenAmount.mul(depositedEther).div(boost.totalSupply()));
364         }
365     }
366 
367     /// @dev destroy this contract to return ether to multiSigAddress stored in this contract
368     function destroy() public onlyMultiSig whenPaused {
369         selfdestruct(multiSigAddress);
370     }
371 
372     /// @dev called by the multiSigWallet to pause, triggers stopped state
373     function pause() public onlyMultiSig whenNotPaused {
374         paused = true;
375         LogPause();
376     }
377 
378     /// @dev called by the multiSigWallet to unpause, returns to normal state
379     function unpause() public onlyMultiSig whenPaused {
380         paused = false;
381         LogUnpause();
382     }
383 
384     /// @dev send profit to investor when stack depth happened. This require multisig and paused state
385     /// @param _address The account receives eth
386     /// @param _amount ether value that investor will receive
387     function sendProfit(address _address, uint256 _amount) public isNotCompletedForWithdrawal(_address) onlyMultiSig whenPaused {
388         require(_address != address(0));
389         require(_amount > 0);
390 
391         mapCompletionNumberForWithdraw[_address] = arrayInfoForDeposit.length;
392 
393         // execute transfer
394         _address.transfer(_amount);
395 
396         // send event
397         LogWithdrawal(_address, _amount);
398     }
399 }