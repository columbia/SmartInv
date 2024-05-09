1 pragma solidity ^0.4.18;
2 
3     contract Owned {
4 
5         modifier onlyOwner { require(msg.sender == owner); _; }
6 
7         address public owner;
8 
9         function Owned() public { owner = msg.sender;}
10 
11         function changeOwner(address _newOwner) public onlyOwner {
12             owner = _newOwner;
13         }
14     }
15 
16     contract TokenController {
17 
18         function onTransfer(address _from, address _to, uint _amount) public returns(bool);
19 
20         function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
21     }
22 
23     contract ApproveAndCallFallBack {
24         function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
25     }
26 
27     contract KayoToken is Owned {
28 
29         string public name;                
30         uint8 public decimals;             
31         string public symbol;              
32 
33         struct  Checkpoint {
34 
35             uint128 fromBlock;
36 
37             uint128 value;
38         }
39 
40         KayoToken public parentToken;
41 
42         uint public parentSnapShotBlock;
43 
44         uint public creationBlock;
45 
46         mapping (address => Checkpoint[]) balances;
47 
48         uint public preSaleTokenBalances;
49 
50         mapping (address => mapping (address => uint256)) allowed;
51 
52         Checkpoint[] totalSupplyHistory;
53 
54         bool public transfersEnabled;
55         
56         bool public IsPreSaleEnabled = false;
57 
58         bool public IsSaleEnabled = false;
59         
60         address public owner;
61 
62         address public rewardManager;
63         
64         uint public allowedRewardTokens;
65 
66         mapping (address => bool) public frozenAccount;
67         event FrozenFunds(address target, bool frozen);
68         
69         modifier canReleaseToken {
70             if (IsSaleEnabled == true || IsPreSaleEnabled == true) 
71                 _;
72             else
73                 revert();
74         }
75 
76         modifier onlyRewardManager { 
77             require(msg.sender == rewardManager || owner == msg.sender); _; 
78         }
79 
80         function KayoToken(
81             address _tokenFactory,
82             address _parentToken,
83             uint _parentSnapShotBlock,
84             string _tokenName,
85             uint8 _decimalUnits,
86             string _tokenSymbol,
87             bool _transfersEnabled
88         ) public {
89             owner = _tokenFactory;
90             name = _tokenName;                                 
91             decimals = _decimalUnits;                          
92             symbol = _tokenSymbol;                             
93             parentToken = KayoToken(_parentToken);
94             parentSnapShotBlock = _parentSnapShotBlock;
95             transfersEnabled = _transfersEnabled;
96             creationBlock = block.number;
97         }
98 
99         function transfer(address _to, uint256 _amount) public returns (bool success) {
100             require(transfersEnabled);
101             transferFrom(msg.sender, _to, _amount);
102             return true;
103         }
104 
105         function freezeAccount(address target, bool freeze) onlyOwner public{
106             frozenAccount[target] = freeze;
107             FrozenFunds(target, freeze);
108         }
109 
110         function setPreSale (bool _value) onlyOwner public {
111             IsPreSaleEnabled = _value;
112         }
113 
114         function setSale (bool _value) onlyOwner public {
115             IsSaleEnabled = _value;
116         }
117 
118         function setRewardManger (address _address) onlyOwner public{
119             rewardManager = _address;
120         }
121 
122         function setRewardManagerLimit(uint _amount) onlyOwner public returns (bool success){
123             allowedRewardTokens = _amount;
124             approve(rewardManager, _amount);
125             return true;
126         }
127 
128         function invest(address _to, uint256 _amount) canReleaseToken onlyRewardManager public returns (bool success) {
129             
130             require((_to != 0) && (_to != address(this)));
131 
132             bool IsTransferAllowed = false;
133 
134             if(IsPreSaleEnabled){
135                 require(preSaleTokenBalances >= _amount);
136                 IsTransferAllowed = true;
137                 preSaleTokenBalances = preSaleTokenBalances - _amount;
138 
139                 return true;
140             }
141             else if(IsSaleEnabled){
142                 IsTransferAllowed = true;
143             }
144             else{
145                 revert();
146             }
147 
148             require(IsTransferAllowed);
149             var previousBalanceFrom = balanceOfAt(msg.sender, block.number);
150             require(previousBalanceFrom >= _amount);
151             updateValueAtNow(balances[msg.sender], previousBalanceFrom - _amount);
152 
153             var previousBalanceTo = balanceOfAt(_to, block.number);
154             require(previousBalanceTo + _amount >= previousBalanceTo);
155             updateValueAtNow(balances[_to], previousBalanceTo + _amount);
156 
157             if(msg.sender == rewardManager){
158                 transferFrom(owner, _to, _amount);      //Reward manager sending tokens 
159             }
160             else{
161                 transferFrom(msg.sender, _to, _amount); //Owner sending tokens
162             }
163         }
164 
165         function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
166 
167             require(IsSaleEnabled && !IsPreSaleEnabled);
168 
169             if (_amount == 0) {
170                 Transfer(_from, _to, _amount);
171                 return;
172             }
173 
174             if (msg.sender != owner) {
175                 require(allowed[_from][msg.sender] >= _amount);
176                 allowed[_from][msg.sender] -= _amount;
177             }
178 
179             Transfer(_from, _to, _amount);
180 
181             return true;
182         }
183 
184         function balanceOf(address _owner) public constant returns (uint256 tokenBalance) {
185             return balanceOfAt(_owner, block.number);
186         }
187 
188         function approve(address _spender, uint256 _amount) public returns (bool success) {
189 
190             require(transfersEnabled);
191             require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
192 
193             if (isValidAddress(owner)) {
194                 require(TokenController(owner).onApprove(msg.sender, _spender, _amount));
195             }
196 
197             allowed[msg.sender][_spender] = _amount;
198             Approval(msg.sender, _spender, _amount);
199             return true;
200         }
201 
202         function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
203             return allowed[_owner][_spender];
204         }
205 
206         function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
207 
208             require(approve(_spender, _amount));
209             ApproveAndCallFallBack(_spender).receiveApproval(msg.sender,_amount,this,_extraData);
210             return true;
211         }
212 
213         function totalSupply() public constant returns (uint) {
214             return totalSupplyAt(block.number);
215         }
216 
217         function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
218 
219             if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
220                 if (address(parentToken) != 0) {
221                     return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
222                 } else {
223                     return 0;
224                 }
225 
226             } else {
227                 return getValueAt(balances[_owner], _blockNumber);
228             }
229         }
230 
231         function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
232 
233             if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
234                 if (address(parentToken) != 0) {
235                     return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
236                 } else {
237                     return 0;
238                 }
239 
240             } else {
241                 return getValueAt(totalSupplyHistory, _blockNumber);
242             }
243         }
244 
245         function generateTokens(address _owner, uint _amount) public onlyOwner returns (bool) {
246             uint curTotalSupply = totalSupply();
247             require(curTotalSupply + _amount >= curTotalSupply);
248             uint previousBalanceTo = balanceOf(_owner);
249             require(previousBalanceTo + _amount >= previousBalanceTo);
250 
251             updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
252             updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
253 
254             uint256 _bal = _amount * 30;
255             preSaleTokenBalances = preSaleTokenBalances + _bal / 100;
256             Transfer(0, _owner, _amount);
257             return true;
258         }
259 
260         function destroyTokens(address _owner, uint _amount) onlyOwner public returns (bool) {
261             uint curTotalSupply = totalSupply();
262             require(curTotalSupply >= _amount);
263             uint previousBalanceFrom = balanceOf(_owner);
264             require(previousBalanceFrom >= _amount);
265             updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
266             updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
267             Transfer(_owner, 0, _amount);
268             return true;
269         }
270         
271         function destroyAllTokens(address _owner) onlyOwner public returns (bool) {
272             updateValueAtNow(totalSupplyHistory, 0);
273             updateValueAtNow(balances[_owner], 0);
274             Transfer(_owner, 0, 0);
275             return true;
276         }
277 
278         function enableTransfers(bool _transfersEnabled) public onlyOwner {
279             transfersEnabled = _transfersEnabled;
280         }
281 
282 
283         function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
284             
285             if (checkpoints.length == 0) return 0;
286 
287             if (_block >= checkpoints[checkpoints.length-1].fromBlock)
288                 return checkpoints[checkpoints.length-1].value;
289 
290             if (_block < checkpoints[0].fromBlock) return 0;
291 
292             uint minValue = 0;
293             uint maximum = checkpoints.length-1;
294             while (maximum > minValue) {
295                 uint midddle = (maximum + minValue + 1)/ 2;
296                 if (checkpoints[midddle].fromBlock<=_block) {
297                     minValue = midddle;
298                 } else {
299                     maximum = midddle-1;
300                 }
301             }
302             return checkpoints[minValue].value;
303         }
304 
305         function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {
306             if ((checkpoints.length == 0) || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
307                 Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
308                 newCheckPoint.fromBlock =  uint128(block.number);
309                 newCheckPoint.value = uint128(_value);
310             } else {
311                 Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
312                 oldCheckPoint.value = uint128(_value);
313             }
314         }
315 
316         function isValidAddress(address _addr) constant internal returns(bool) {
317             uint size;
318             if (_addr == 0) return false;
319             assembly {
320                 size := extcodesize(_addr)
321             }
322             return size > 0;
323         }
324 
325         function min(uint a, uint b) pure internal returns (uint) {
326             return a < b ? a : b;
327         }
328 
329         event Transfer(address indexed _from, address indexed _to, uint256 _amount);
330         event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
331 
332     }