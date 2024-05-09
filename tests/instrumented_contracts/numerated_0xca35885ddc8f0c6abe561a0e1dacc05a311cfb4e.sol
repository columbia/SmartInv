1 //File: contracts/common/Controlled.sol
2 pragma solidity ^0.4.21;
3 
4 contract Controlled {
5     modifier onlyController { require(msg.sender == controller); _; }
6 
7     address public controller;
8 
9     function Controlled() public { controller = msg.sender;}
10 
11     function changeController(address _newController) public onlyController {
12         controller = _newController;
13     }
14 }
15 
16 //File: contracts/common/TokenController.sol
17 pragma solidity ^0.4.21;
18 
19 contract TokenController {
20     function proxyPayment(address _owner) public payable returns(bool);
21 
22     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
23 
24     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
25 }
26 
27 //File: contracts/common/ApproveAndCallFallBack.sol
28 pragma solidity ^0.4.21;
29 
30 contract ApproveAndCallFallBack {
31     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
32 }
33 
34 //File: contracts/Token.sol
35 pragma solidity ^0.4.21;
36 
37 
38 
39 
40 
41 
42 contract Token is Controlled {
43 
44     string public name = "ShineCoin";
45     uint8 public decimals = 9;
46     string public symbol = "SHINE";
47 
48     struct  Checkpoint {
49         uint128 fromBlock;
50         uint128 value;
51     }
52 
53     uint public creationBlock;
54 
55     mapping (address => Checkpoint[]) balances;
56 
57     mapping (address => mapping (address => uint256)) allowed;
58 
59     Checkpoint[] totalSupplyHistory;
60 
61     bool public transfersEnabled = true;
62 
63     address public frozenReserveTeamWallet;
64 
65     uint public unfreezeTeamWalletBlock;
66 
67     function Token(address _frozenReserveTeamWallet) public {
68         creationBlock = block.number;
69         frozenReserveTeamWallet = _frozenReserveTeamWallet;
70         unfreezeTeamWalletBlock = block.number + ((365 * 24 * 3600) / 15); // ~ 396 days
71     }
72 
73 
74 ///////////////////
75 // ERC20 Methods
76 ///////////////////
77 
78     function transfer(address _to, uint256 _amount) public returns (bool success) {
79         require(transfersEnabled);
80 
81         if (address(msg.sender) == frozenReserveTeamWallet) {
82             require(block.number > unfreezeTeamWalletBlock);
83         }
84 
85         doTransfer(msg.sender, _to, _amount);
86         return true;
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
90         if (msg.sender != controller) {
91             require(transfersEnabled);
92 
93             require(allowed[_from][msg.sender] >= _amount);
94             allowed[_from][msg.sender] -= _amount;
95         }
96         doTransfer(_from, _to, _amount);
97         return true;
98     }
99 
100 
101     function doTransfer(address _from, address _to, uint _amount) internal {
102 
103            if (_amount <= 0) {
104                emit Transfer(_from, _to, _amount);
105                return;
106            }
107 
108            require((_to != 0) && (_to != address(this)));
109 
110            uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
111 
112            require(previousBalanceFrom >= _amount);
113 
114            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
115 
116            uint256 previousBalanceTo = balanceOfAt(_to, block.number);
117            require(previousBalanceTo + _amount >= previousBalanceTo);
118            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
119 
120            emit Transfer(_from, _to, _amount);
121 
122     }
123 
124     function balanceOf(address _owner) public constant returns (uint256 balance) {
125         return balanceOfAt(_owner, block.number);
126     }
127 
128     function approve(address _spender, uint256 _amount) public returns (bool success) {
129         require(transfersEnabled);
130 
131         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
132 
133         if (isContract(controller)) {
134             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
135         }
136 
137         allowed[msg.sender][_spender] = _amount;
138         emit Approval(msg.sender, _spender, _amount);
139         return true;
140     }
141 
142     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
143         return allowed[_owner][_spender];
144     }
145 
146     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
147     ) public returns (bool success) {
148         require(approve(_spender, _amount));
149 
150         ApproveAndCallFallBack(_spender).receiveApproval(
151             msg.sender,
152             _amount,
153             this,
154             _extraData
155         );
156 
157         return true;
158     }
159 
160     function totalSupply() public constant returns (uint) {
161         return totalSupplyAt(block.number);
162     }
163 
164     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
165 
166         if ((balances[_owner].length == 0)
167             || (balances[_owner][0].fromBlock > _blockNumber)) {
168             return 0;
169         } else {
170             return getValueAt(balances[_owner], _blockNumber);
171         }
172     }
173 
174     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
175 
176         if ((totalSupplyHistory.length == 0)
177             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
178             return 0;
179 
180         } else {
181             return getValueAt(totalSupplyHistory, _blockNumber);
182         }
183     }
184 
185     function generateTokens(address _owner, uint _amount) public onlyController returns (bool) {
186         uint curTotalSupply = totalSupply();
187         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
188         uint previousBalanceTo = balanceOf(_owner);
189         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
190         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
191         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
192         emit Transfer(0, _owner, _amount);
193         return true;
194     }
195 
196     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
197         uint curTotalSupply = totalSupply();
198         require(curTotalSupply >= _amount);
199         uint previousBalanceFrom = balanceOf(_owner);
200         require(previousBalanceFrom >= _amount);
201         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
202         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
203         emit Transfer(_owner, 0, _amount);
204         return true;
205     }
206 
207     function enableTransfers(bool _transfersEnabled) public onlyController {
208         transfersEnabled = _transfersEnabled;
209     }
210 
211 
212     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
213         if (checkpoints.length == 0) return 0;
214 
215         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
216             return checkpoints[checkpoints.length-1].value;
217         if (_block < checkpoints[0].fromBlock) return 0;
218 
219         uint min = 0;
220         uint max = checkpoints.length-1;
221         while (max > min) {
222             uint mid = (max + min + 1)/ 2;
223             if (checkpoints[mid].fromBlock<=_block) {
224                 min = mid;
225             } else {
226                 max = mid-1;
227             }
228         }
229         return checkpoints[min].value;
230     }
231 
232     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {
233         if ((checkpoints.length == 0)
234         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
235                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
236                newCheckPoint.fromBlock =  uint128(block.number);
237                newCheckPoint.value = uint128(_value);
238            } else {
239                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
240                oldCheckPoint.value = uint128(_value);
241            }
242     }
243 
244     function isContract(address _addr) constant internal returns(bool) {
245         uint size;
246         if (_addr == 0) return false;
247         assembly {
248             size := extcodesize(_addr)
249         }
250         return size>0;
251     }
252 
253     function min(uint a, uint b) pure internal returns (uint) {
254         return a < b ? a : b;
255     }
256 
257     function () public payable {
258         require(isContract(controller));
259         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
260     }
261 
262     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
263     event Approval(
264         address indexed _owner,
265         address indexed _spender,
266         uint256 _amount
267         );
268 
269 }
270 //File: ./contracts/PreCrowdFunder.sol
271 pragma solidity ^0.4.21;
272 
273 
274 
275 
276 contract PreCrowdFunder is Controlled {
277     address public creator;
278     address public fundRecipient;
279     uint public currentBalance;
280     uint public tokensIssued;
281     uint public capTokenAmount;
282     uint public tokenExchangeRate;
283     Token public exchangeToken;
284     enum State {
285         Wait,
286         Fundraising,
287         Successful,
288         Closed
289     }
290     State public state = State.Wait;
291 
292     // Events
293     event GoalReached(address fundRecipient, uint amountRaised);
294     event FundTransfer(address backer, uint amount, bool isContribution);
295     event FrozenFunds(address target, bool frozen);
296     event LogFundingReceived(address addr, uint amount, uint currentTotal);
297 
298     // Maps
299     mapping (address => uint256) private balanceOf;
300     mapping (address => bool) private frozenAccount;
301 
302     // Modifiers
303     modifier inState(State _state) {
304         require(state == _state);
305         _;
306     }
307     modifier accountNotFrozen() {
308         require(!(frozenAccount[msg.sender] == true));
309         _;
310     }
311     modifier minInvestment() {
312         // User has to send at least 0.01 Eth
313         require(msg.value >= 10 ** 16);
314         _;
315     }
316 
317     // Constructor
318     function PreCrowdFunder(address _fundRecipient, Token _addressOfExchangeToken) public {
319         creator = msg.sender;
320         fundRecipient = _fundRecipient;
321         capTokenAmount = 10000000 * 10 ** 9;
322         state = State.Wait;
323         currentBalance = 0;
324         tokensIssued = 0;
325         tokenExchangeRate = 1000 * 10 ** 9;
326         exchangeToken = Token(_addressOfExchangeToken);
327     }
328 
329     function startFundraising() public inState(State.Wait) onlyController {
330         state = State.Fundraising;
331         tokensIssued = exchangeToken.totalSupply();
332     }
333 
334     function endFundraising() public onlyController {
335         require(state == State.Fundraising || state == State.Successful);
336         fundRecipient.transfer(currentBalance);
337         currentBalance = 0;
338         state = State.Closed;
339         exchangeToken.changeController(controller);
340     }
341 
342     function freezeAccount(address target, bool freeze) public onlyController {
343         frozenAccount[target] = freeze;
344         emit FrozenFunds(target, freeze);
345     }
346 
347     function getExchangeRate(uint amount) public constant returns (uint) {
348         return tokenExchangeRate * amount / 1 ether;
349     }
350 
351     function investment() public inState(State.Fundraising) accountNotFrozen minInvestment payable returns (uint)  {
352         uint amount = msg.value;
353 
354         balanceOf[msg.sender] += amount;
355         currentBalance += amount;
356 
357         uint tokenAmount = getExchangeRate(amount);
358         exchangeToken.generateTokens(msg.sender, tokenAmount);
359         tokensIssued += tokenAmount;
360 
361         emit FundTransfer(msg.sender, amount, true);
362         emit LogFundingReceived(msg.sender, tokenAmount, tokensIssued);
363 
364         if (tokensIssued >= capTokenAmount) {
365             state = State.Successful;
366             emit GoalReached(fundRecipient, currentBalance);
367         }
368 
369         return balanceOf[msg.sender];
370     }
371 
372     function removeContract() public inState(State.Closed) onlyController {
373         selfdestruct(msg.sender);
374     }
375 
376     function() inState(State.Fundraising) public accountNotFrozen minInvestment payable {
377         investment();
378     }
379 
380 }