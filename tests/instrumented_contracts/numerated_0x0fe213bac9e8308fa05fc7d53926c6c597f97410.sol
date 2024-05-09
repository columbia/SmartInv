1 pragma solidity ^0.4.18;
2 
3 /*
4     This program is free software: you can redistribute it and/or modify
5     it under the terms of the GNU General Public License as published by
6     the Free Software Foundation, either version 3 of the License, or
7     (at your option) any later version.
8 
9     This program is distributed in the hope that it will be useful,
10     but WITHOUT ANY WARRANTY; without even the implied warranty of
11     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12     GNU General Public License for more details.
13 
14     You should have received a copy of the GNU General Public License
15     along with this program.  If not, see <http://www.gnu.org/licenses/>.
16  */
17 
18 contract Controlled {
19     modifier onlyController { require(msg.sender == controller); _; }
20 
21     address public controller;
22 
23     function Controlled() public { controller = msg.sender;}
24 
25     function changeController(address _newController) public onlyController {
26         controller = _newController;
27     }
28 }
29 
30 contract TokenController {
31     function proxyPayment(address _owner) public payable returns(bool);
32 
33     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
34 
35     function onApprove(address _owner, address _spender, uint _amount) public
36         returns(bool);
37 }
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
41 }
42 
43 contract ERC223ReceivingContract {
44     function tokenFallback(address _from, uint _value, bytes _data) public;
45 }
46 
47 contract SignalToken is Controlled {
48     string public name;                     // Full token name
49     uint8 public decimals;                  // Number of decimal places (usually 18)
50     string public symbol;                   // Token ticker symbol
51     string public version = "STV_0.1";      // Arbitrary versioning scheme
52     address public peg;                     // Address of peg contract (to reject direct transfers)
53 
54     struct Checkpoint {
55         uint128 fromBlock;
56         uint128 value;
57     }
58 
59     SignalToken public parentToken;
60     uint public parentSnapShotBlock;
61     uint public creationBlock;
62     mapping (address => Checkpoint[]) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     Checkpoint[] totalSupplyHistory;
65     bool public transfersEnabled;
66     SignalTokenFactory public tokenFactory;
67 
68     function SignalToken(
69         address _tokenFactory,
70         address _parentToken,
71         uint _parentSnapShotBlock,
72         string _tokenName,
73         uint8 _decimalUnits,
74         string _tokenSymbol,
75         bool _transfersEnabled,
76         address _peg
77     ) public {
78         tokenFactory = SignalTokenFactory(_tokenFactory);
79         name = _tokenName;
80         decimals = _decimalUnits;
81         symbol = _tokenSymbol;
82         parentToken = SignalToken(_parentToken);
83         parentSnapShotBlock = _parentSnapShotBlock;
84         transfersEnabled = _transfersEnabled;
85         creationBlock = block.number;
86         peg = _peg;
87     }
88 
89     function transfer(address _to, uint256 _amount, bytes _data) public returns (bool success) {
90         require(transfersEnabled);
91         doTransfer(msg.sender, _to, _amount, _data);
92         return true;
93     }
94 
95     function transfer(address _to, uint256 _amount) public returns (bool success) {
96         bytes memory empty;
97         require(transfersEnabled);
98         doTransfer(msg.sender, _to, _amount, empty);
99         return true;
100     }
101 
102     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
103         bytes memory empty;
104         if (msg.sender != controller) {
105             require(transfersEnabled);
106 
107             if (msg.sender != peg || _to != peg) {
108                 require(allowed[_from][msg.sender] >= _amount);
109                 allowed[_from][msg.sender] -= _amount;
110             }
111         }
112         doTransfer(_from, _to, _amount, empty);
113         return true;
114     }
115 
116     function doTransfer(address _from, address _to, uint _amount, bytes _data) internal {
117            if (_amount == 0) {
118                Transfer(_from, _to, _amount);    // Follow the spec (fire event when transfer 0)
119                return;
120            }
121 
122            require(parentSnapShotBlock < block.number);
123 
124            require((_to != 0) && (_to != address(this)));
125 
126            var previousBalanceFrom = balanceOfAt(_from, block.number);
127            require(previousBalanceFrom >= _amount);
128 
129            if (isContract(controller)) {
130                require(TokenController(controller).onTransfer(_from, _to, _amount));
131            }
132 
133            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
134 
135            var previousBalanceTo = balanceOfAt(_to, block.number);
136            require(previousBalanceTo + _amount >= previousBalanceTo);
137            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
138 
139            if (isContract(_to)) {
140                ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
141                receiver.tokenFallback(_from, _amount, _data);
142            }
143 
144            Transfer(_from, _to, _amount);
145     }
146 
147     function balanceOf(address _owner) public constant returns (uint256 balance) {
148         return balanceOfAt(_owner, block.number);
149     }
150 
151     function approve(address _spender, uint256 _amount) public returns (bool success) {
152         require(transfersEnabled);
153 
154         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
155 
156         if (isContract(controller)) {
157             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
158         }
159 
160         allowed[msg.sender][_spender] = _amount;
161         Approval(msg.sender, _spender, _amount);
162         return true;
163     }
164 
165     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
166         return allowed[_owner][_spender];
167     }
168 
169     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
170         require(approve(_spender, _amount));
171 
172         ApproveAndCallFallBack(_spender).receiveApproval(
173             msg.sender,
174             _amount,
175             this,
176             _extraData
177         );
178 
179         return true;
180     }
181 
182     function totalSupply() public constant returns (uint) {
183         return totalSupplyAt(block.number);
184     }
185 
186     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
187         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
188             if (address(parentToken) != 0) {
189                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
190             } else {
191                 return 0;
192             }
193         } else {
194             return getValueAt(balances[_owner], _blockNumber);
195         }
196     }
197 
198     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
199         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
200             if (address(parentToken) != 0) {
201                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
202             } else {
203                 return 0;
204             }
205 
206         } else {
207             return getValueAt(totalSupplyHistory, _blockNumber);
208         }
209     }
210 
211     function createCloneToken(
212         string _cloneTokenName,
213         uint8 _cloneDecimalUnits,
214         string _cloneTokenSymbol,
215         uint _snapshotBlock,
216         bool _transfersEnabled,
217 		address _peg
218         ) public returns(address) {
219         if (_snapshotBlock == 0) {
220 			_snapshotBlock = block.number;
221 		}
222         SignalToken cloneToken = tokenFactory.createCloneToken(
223             this,
224             _snapshotBlock,
225             _cloneTokenName,
226             _cloneDecimalUnits,
227             _cloneTokenSymbol,
228             _transfersEnabled,
229 			_peg
230             );
231 
232         cloneToken.changeController(msg.sender);
233 
234         NewCloneToken(address(cloneToken), _snapshotBlock);
235         return address(cloneToken);
236     }
237 
238     function generateTokens(address _owner, uint _amount
239     ) public onlyController returns (bool) {
240         uint curTotalSupply = totalSupply();
241         require(curTotalSupply + _amount >= curTotalSupply);
242         uint previousBalanceTo = balanceOf(_owner);
243         require(previousBalanceTo + _amount >= previousBalanceTo);
244         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
245         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
246         Transfer(0, _owner, _amount);
247         return true;
248     }
249 
250     function destroyTokens(address _owner, uint _amount
251     ) onlyController public returns (bool) {
252         uint curTotalSupply = totalSupply();
253         require(curTotalSupply >= _amount);
254         uint previousBalanceFrom = balanceOf(_owner);
255         require(previousBalanceFrom >= _amount);
256         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
257         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
258         Transfer(_owner, 0, _amount);
259         return true;
260     }
261 
262     function enableTransfers(bool _transfersEnabled) public onlyController {
263         transfersEnabled = _transfersEnabled;
264     }
265 
266     function getValueAt(Checkpoint[] storage checkpoints, uint _block
267     ) constant internal returns (uint) {
268         if (checkpoints.length == 0) {
269 			return 0;
270 		}
271 
272         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
273             return checkpoints[checkpoints.length-1].value;
274 		}
275         if (_block < checkpoints[0].fromBlock) {
276 			return 0;
277 		}
278 
279         uint min = 0;
280         uint max = checkpoints.length-1;
281         while (max > min) {
282             uint mid = (max + min + 1)/ 2;
283             if (checkpoints[mid].fromBlock<=_block) {
284                 min = mid;
285             } else {
286                 max = mid-1;
287             }
288         }
289         return checkpoints[min].value;
290     }
291 
292     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
293         if ((checkpoints.length == 0)
294         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
295                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
296                newCheckPoint.fromBlock =  uint128(block.number);
297                newCheckPoint.value = uint128(_value);
298            } else {
299                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
300                oldCheckPoint.value = uint128(_value);
301            }
302     }
303 
304     function isContract(address _addr) constant internal returns(bool) {
305         uint size;
306         if (_addr == 0) {
307 			return false;
308 		}
309         assembly {
310             size := extcodesize(_addr)
311         }
312         return size>0;
313     }
314 
315     function min(uint a, uint b) pure internal returns (uint) {
316         return a < b ? a : b;
317     }
318 
319     function () public payable {
320         require(isContract(controller));
321         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
322     }
323 
324     function claimTokens(address _token) public onlyController {
325         if (_token == 0x0) {
326             controller.transfer(this.balance);
327             return;
328         }
329 
330         SignalToken token = SignalToken(_token);
331         uint balance = token.balanceOf(this);
332         token.transfer(controller, balance);
333         ClaimedTokens(_token, controller, balance);
334     }
335 
336     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
337     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
338     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
339     event Approval(
340         address indexed _owner,
341         address indexed _spender,
342         uint256 _amount
343         );
344 
345 }
346 
347 contract SignalTokenFactory {
348 	event NewTokenFromFactory(address indexed _tokenAddress, address _factoryAddress, uint _snapshotBlock);
349 
350     function createCloneToken(
351         address _parentToken,
352         uint _snapshotBlock,
353         string _tokenName,
354         uint8 _decimalUnits,
355         string _tokenSymbol,
356         bool _transfersEnabled,
357 		address _peg
358     ) public returns (SignalToken) {
359         SignalToken newToken = new SignalToken(
360             this,
361             _parentToken,
362             _snapshotBlock,
363             _tokenName,
364             _decimalUnits,
365             _tokenSymbol,
366             _transfersEnabled,
367             _peg
368             );
369 
370         NewTokenFromFactory(newToken, this, _snapshotBlock);
371         newToken.changeController(msg.sender);
372         return newToken;
373     }
374 }