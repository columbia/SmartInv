1 pragma solidity ^0.4.24;
2 
3 // 22.07.18
4 
5 
6 //*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/
7 //
8 //  Ethertote token contract
9 //
10 //  (parts of the token contract
11 //  are based on the 'MiniMeToken' - Jordi Baylina)
12 //
13 //  Fully ERC20 Compliant token
14 //
15 //  Name:            Ethertote
16 //  Symbol:          TOTE
17 //  Decimals:        0
18 //  Total supply:    10000000 (10 million tokens)
19 //
20 //*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/
21 
22 
23 // ----------------------------------------------------------------------------
24 // TokenController contract is called when `_owner` sends ether to the 
25 // Ethertote Token contract
26 // ----------------------------------------------------------------------------
27 contract TokenController {
28 
29     function proxyPayments(address _owner) public payable returns(bool);
30     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
31     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // ApproveAndCallFallBack
37 // ----------------------------------------------------------------------------
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // The main EthertoteToken contract, the default controller is the msg.sender
46 // that deploys the contract
47 // ----------------------------------------------------------------------------
48 contract EthertoteToken {
49 
50     // Variables to ensure contract is conforming to ERC220
51     string public name;                
52     uint8 public decimals;             
53     string public symbol;              
54     uint public _totalSupply;
55     
56     // Addtional variables 
57     string public version; 
58     address public contractOwner;
59     address public thisContractAddress;
60     address public EthertoteAdminAddress;
61     
62     bool public tokenGenerationLock;            // ensure tokens can only be minted once
63     
64     // the controller takes full control of the contract
65     address public controller;
66     
67     // null address which will be assigned as controller for security purposes
68     address public relinquishOwnershipAddress = 0x0000000000000000000000000000000000000000;
69     
70     
71     // Modifier to ensure generateTokens() is only ran once by the constructor
72     modifier onlyController { 
73         require(
74             msg.sender == controller
75             ); 
76             _; 
77     }
78     
79     
80     modifier onlyContract { 
81         require(
82             address(this) == thisContractAddress
83             
84         ); 
85         _; 
86     }
87     
88     
89     modifier EthertoteAdmin { 
90         require(
91             msg.sender == EthertoteAdminAddress
92             
93         ); 
94         _; 
95     }
96 
97 
98     // Checkpoint is the struct that attaches a block number to a
99     // given value, and the block number attached is the one that last changed the
100     // value
101     struct  Checkpoint {
102         uint128 fromBlock;
103         uint128 value;
104     }
105 
106     // parentToken will be 0x0 for the token unless cloned
107     EthertoteToken private parentToken;
108 
109     // parentSnapShotBlock is the block number from the Parent Token which will
110     // be 0x0 unless cloned
111     uint private parentSnapShotBlock;
112 
113     // creationBlock is the 'genesis' block number when contract is deployed
114     uint public creationBlock;
115 
116     // balances is the mapping which tracks the balance of each address
117     mapping (address => Checkpoint[]) balances;
118 
119     // allowed is the mapping which tracks any extra transfer rights 
120     // as per ERC20 token standards
121     mapping (address => mapping (address => uint256)) allowed;
122 
123     // Checkpoint array tracks the history of the totalSupply of the token
124     Checkpoint[] totalSupplyHistory;
125 
126     // needs to be set to 'true' to allow tokens to be transferred
127     bool public transfersEnabled;
128 
129 
130 // ----------------------------------------------------------------------------
131 // Constructor function initiated automatically when contract is deployed
132 // ----------------------------------------------------------------------------
133     constructor() public {
134         
135         controller = msg.sender;
136         EthertoteAdminAddress = msg.sender;
137         tokenGenerationLock = false;
138         
139     // --------------------------------------------------------------------
140     // set the following values prior to deployment
141     // --------------------------------------------------------------------
142     
143         name = "Ethertote";                                   // Set the name
144         symbol = "TOTE";                                 // Set the symbol
145         decimals = 0;                                       // Set the decimals
146         _totalSupply = 10000000 * 10**uint(decimals);       // 10,000,000 tokens
147         
148         version = "Ethertote Token contract - version 1.0";
149     
150     //---------------------------------------------------------------------
151 
152         // Additional variables set by the constructor
153         contractOwner = msg.sender;
154         thisContractAddress = address(this);
155 
156         transfersEnabled = true;                            // allows tokens to be traded
157         
158         creationBlock = block.number;                       // sets the genesis block
159 
160 
161         // Now call the internal generateTokens function to create the tokens 
162         // and send them to owner
163         generateTokens(contractOwner, _totalSupply);
164         
165         // Now that the tokens have been generated, finally reliquish 
166         // ownership of the token contract for security purposes
167         controller = relinquishOwnershipAddress;
168     }
169 
170 
171 // ----------------------------------------------------------------------------
172 // ERC Token Standard #20 Interface Methods for full compliance
173 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
174 // ----------------------------------------------------------------------------
175 
176     // totalSupply //
177     function totalSupply() public constant returns (uint) {
178         return totalSupplyAt(block.number);
179     }
180     
181     // balanceOf //
182     function balanceOf(address _owner) public constant returns (uint256 balance) {
183         return balanceOfAt(_owner, block.number);
184     }
185 
186     // allowance //
187     function allowance(address _owner, address _spender
188     ) public constant returns (uint256 remaining) {
189         return allowed[_owner][_spender];
190     }
191 
192     // transfer //
193     function transfer(address _to, uint256 _amount
194     ) public returns (bool success) {
195         
196         require(transfersEnabled);
197         
198         // prevent tokens from ever being sent back to the contract address 
199         require(_to != address(this) );
200         // prevent tokens from ever accidentally being sent to the nul (0x0) address
201         require(_to != 0x0);
202         doTransfer(msg.sender, _to, _amount);
203         return true;
204     }
205 
206     // approve //
207     function approve(address _spender, uint256 _amount) public returns (bool success) {
208         require(transfersEnabled);
209         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
210         if (isContract(controller)) {
211             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
212         }
213 
214         allowed[msg.sender][_spender] = _amount;
215         emit Approval(msg.sender, _spender, _amount);
216         return true;
217     }
218 
219     // transferFrom
220     function transferFrom(address _from, address _to, uint256 _amount
221     ) public returns (bool success) {
222         
223         // prevent tokens from ever being sent back to the contract address 
224         require(_to != address(this) );
225         // prevent tokens from ever accidentally being sent to the nul (0x0) address
226         require(_to != 0x0);
227         
228         if (msg.sender != controller) {
229             require(transfersEnabled);
230 
231             require(allowed[_from][msg.sender] >= _amount);
232             allowed[_from][msg.sender] -= _amount;
233         }
234         doTransfer(_from, _to, _amount);
235         return true;
236     }
237     
238 // ----------------------------------------------------------------------------
239 //  ERC20 compliant events
240 // ----------------------------------------------------------------------------
241 
242     event Transfer(
243         address indexed _from, address indexed _to, uint256 _amount
244         );
245     
246     event Approval(
247         address indexed _owner, address indexed _spender, uint256 _amount
248         );
249 
250 // ----------------------------------------------------------------------------
251 
252     // once constructor assigns control to 0x0 the contract cannot be changed
253     function changeController(address _newController) onlyController private {
254         controller = _newController;
255     }
256     
257     function doTransfer(address _from, address _to, uint _amount) internal {
258 
259            if (_amount == 0) {
260                emit Transfer(_from, _to, _amount); 
261                return;
262            }
263 
264            require(parentSnapShotBlock < block.number);
265 
266            // Do not allow transfer to 0x0 or the token contract itself
267            // require((_to != 0) && (_to != address(this)));
268            
269            require(_to != address(this));
270            
271            
272 
273            // If the amount being transfered is more than the balance of the
274            //  account, the transfer throws
275            uint previousBalanceFrom = balanceOfAt(_from, block.number);
276            require(previousBalanceFrom >= _amount);
277 
278            // Alerts the token controller of the transfer
279            if (isContract(controller)) {
280                require(TokenController(controller).onTransfer(_from, _to, _amount));
281            }
282 
283            // First update the balance array with the new value for the address
284            //  sending the tokens
285            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
286 
287            // Then update the balance array with the new value for the address
288            //  receiving the tokens
289            uint previousBalanceTo = balanceOfAt(_to, block.number);
290            
291            // Check for overflow
292            require(previousBalanceTo + _amount >= previousBalanceTo); 
293            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
294 
295            // An event to make the transfer easy to find on the blockchain
296            emit Transfer(_from, _to, _amount);
297 
298     }
299 
300 
301 // ----------------------------------------------------------------------------
302 // approveAndCall allows users to use their tokens to interact with contracts
303 // in a single function call
304 // msg.sender approves `_spender` to send an `_amount` of tokens on
305 // its behalf, and then a function is triggered in the contract that is
306 // being approved, `_spender`. This allows users to use their tokens to
307 // interact with contracts in one function call instead of two
308     
309 // _spender is the address of the contract able to transfer the tokens
310 // _amount is the amount of tokens to be approved for transfer
311 // return 'true' if the function call was successful
312 // ----------------------------------------------------------------------------    
313     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
314     ) public returns (bool success) {
315         require(approve(_spender, _amount));
316 
317         ApproveAndCallFallBack(_spender).receiveApproval(
318             msg.sender,
319             _amount,
320             this,
321             _extraData
322         );
323         return true;
324     }
325 
326 
327 
328 
329 // ----------------------------------------------------------------------------
330 // Query the balance of an address at a specific block number
331 // ----------------------------------------------------------------------------
332     function balanceOfAt(address _owner, uint _blockNumber) public constant
333         returns (uint) {
334 
335         if ((balances[_owner].length == 0)
336             || (balances[_owner][0].fromBlock > _blockNumber)) {
337             if (address(parentToken) != 0) {
338                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
339             } else {
340                 return 0;
341             }
342 
343         } 
344         
345         else {
346             return getValueAt(balances[_owner], _blockNumber);
347         }
348     }
349 
350 
351 // ----------------------------------------------------------------------------
352 // Queries the total supply of tokens at a specific block number
353 // will return 0 if called before the creationBlock value
354 // ----------------------------------------------------------------------------
355     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
356         if (
357             (totalSupplyHistory.length == 0) ||
358             (totalSupplyHistory[0].fromBlock > _blockNumber)
359             ) {
360             if (address(parentToken) != 0) {
361                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
362             } else {
363                 return 0;
364             }
365 
366         } 
367         else {
368             return getValueAt(totalSupplyHistory, _blockNumber);
369         }
370     }
371 
372 
373 // ----------------------------------------------------------------------------
374 // The generateTokens function will generate the initial supply of tokens
375 // Can only be called once during the constructor as it has the onlyContract
376 // modifier attached to the function
377 // ----------------------------------------------------------------------------
378     function generateTokens(address _owner, uint _theTotalSupply) 
379     private onlyContract returns (bool) {
380         require(tokenGenerationLock == false);
381         uint curTotalSupply = totalSupply();
382         require(curTotalSupply + _theTotalSupply >= curTotalSupply); // Check for overflow
383         uint previousBalanceTo = balanceOf(_owner);
384         require(previousBalanceTo + _totalSupply >= previousBalanceTo); // Check for overflow
385         updateValueAtNow(totalSupplyHistory, curTotalSupply + _totalSupply);
386         updateValueAtNow(balances[_owner], previousBalanceTo + _totalSupply);
387         emit Transfer(0, _owner, _totalSupply);
388         tokenGenerationLock = true;
389         return true;
390     }
391 
392 
393 // ----------------------------------------------------------------------------
394 // Enable tokens transfers to allow tokens to be traded
395 // ----------------------------------------------------------------------------
396 
397     function enableTransfers(bool _transfersEnabled) private onlyController {
398         transfersEnabled = _transfersEnabled;
399     }
400 
401 // ----------------------------------------------------------------------------
402 // Internal helper functions
403 // ----------------------------------------------------------------------------
404 
405     function getValueAt(Checkpoint[] storage checkpoints, uint _block
406     ) constant internal returns (uint) {
407         if (checkpoints.length == 0) return 0;
408 
409         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
410             return checkpoints[checkpoints.length-1].value;
411         if (_block < checkpoints[0].fromBlock) return 0;
412 
413         // Binary search of the value in the array
414         uint min = 0;
415         uint max = checkpoints.length-1;
416         while (max > min) {
417             uint mid = (max + min + 1)/ 2;
418             if (checkpoints[mid].fromBlock<=_block) {
419                 min = mid;
420             } else {
421                 max = mid-1;
422             }
423         }
424         return checkpoints[min].value;
425     }
426 
427 // ----------------------------------------------------------------------------
428 // function used to update the `balances` map and the `totalSupplyHistory`
429 // ----------------------------------------------------------------------------
430     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
431     ) internal  {
432         if ((checkpoints.length == 0)
433         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
434                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
435                newCheckPoint.fromBlock =  uint128(block.number);
436                newCheckPoint.value = uint128(_value);
437            } else {
438                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
439                oldCheckPoint.value = uint128(_value);
440            }
441     }
442 
443 // ----------------------------------------------------------------------------
444 // function to check if address is a contract
445 // ----------------------------------------------------------------------------
446     function isContract(address _addr) constant internal returns(bool) {
447         uint size;
448         if (_addr == 0) return false;
449         assembly {
450             size := extcodesize(_addr)
451         }
452         return size>0;
453     }
454 
455 // ----------------------------------------------------------------------------
456 // Helper function to return a min betwen the two uints
457 // ----------------------------------------------------------------------------
458     function min(uint a, uint b) pure internal returns (uint) {
459         return a < b ? a : b;
460     }
461 
462 // ----------------------------------------------------------------------------
463 // fallback function: If the contract's controller has not been set to 0, 
464 // then the `proxyPayment` method is called which relays the eth and creates 
465 // tokens as described in the token controller contract
466 // ----------------------------------------------------------------------------
467     function () public payable {
468         require(isContract(controller));
469         require(
470             TokenController(controller).proxyPayments.value(msg.value)(msg.sender)
471             );
472     }
473 
474 
475     event ClaimedTokens(
476         address indexed _token, address indexed _controller, uint _amount
477         );
478 
479 // ----------------------------------------------------------------------------
480 // This method can be used by the controller to extract other tokens accidentally 
481 // sent to this contract.
482 // _token is the address of the token contract to recover
483 //  can be set to 0 to extract eth
484 // ----------------------------------------------------------------------------
485     function withdrawOtherTokens(address _token) EthertoteAdmin public {
486         if (_token == 0x0) {
487             controller.transfer(address(this).balance);
488             return;
489         }
490         EthertoteToken token = EthertoteToken(_token);
491         uint balance = token.balanceOf(this);
492         token.transfer(controller, balance);
493         emit ClaimedTokens(_token, controller, balance);
494     }
495 
496 }