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
54         bool public tradeEnabled;
55         
56         bool public IsPreSaleEnabled = false;
57 
58         bool public IsSaleEnabled = false;
59 
60         bool public IsAirDropEnabled = false;
61         
62         address public owner;
63 
64         address public airDropManager;
65         
66         uint public allowedAirDropTokens;
67 
68         mapping (address => bool) public frozenAccount;
69         event FrozenFunds(address target, bool frozen);
70         
71         function KayoToken(
72             address _tokenFactory,
73             address _parentToken,
74             uint _parentSnapShotBlock,
75             string _tokenName,
76             uint8 _decimalUnits,
77             string _tokenSymbol,
78             bool _tradeEnabled
79         ) public {
80             owner = _tokenFactory;
81             name = _tokenName;                                 
82             decimals = _decimalUnits;                          
83             symbol = _tokenSymbol;                             
84             parentToken = KayoToken(_parentToken);
85             parentSnapShotBlock = _parentSnapShotBlock;
86             tradeEnabled = _tradeEnabled;
87             creationBlock = block.number;
88         }
89 
90         function IsAirdrop() public view returns (bool result){
91             if(msg.sender == airDropManager)
92                 return true;
93             else
94                 return false;
95         }
96 
97         function IsReleaseToken() public view returns(bool result){
98             if ((IsSaleEnabled == true || IsPreSaleEnabled == true) && msg.sender == owner)
99                 return true;
100             else
101                 return false;
102         }
103 
104 
105         function transfer(address _to, uint256 _amount) public returns (bool success) {
106             require(tradeEnabled);
107             transferFrom(msg.sender, _to, _amount);
108             return true;
109         }
110 
111         function freezeAccount(address target, bool freeze) onlyOwner public{
112             frozenAccount[target] = freeze;
113             FrozenFunds(target, freeze);
114         }
115 
116         function setPreSale (bool _value) onlyOwner public {
117             IsPreSaleEnabled = _value;
118         }
119 
120         function setSale (bool _value) onlyOwner public {
121             IsSaleEnabled = _value;
122         }
123 
124         function setAirDrop (bool _value) onlyOwner public {
125             IsAirDropEnabled = _value;
126         }
127 
128         function setAirDropManager (address _address) onlyOwner public{
129             airDropManager = _address;
130         }
131 
132         function setairDropManagerLimit(uint _amount) onlyOwner public returns (bool success){
133             allowedAirDropTokens = _amount;
134             approve(airDropManager, _amount);
135             return true;
136         }
137 
138         function airDrop(address _to, uint256 _amount) public returns (bool success){
139             
140             require(IsAirDropEnabled);
141             require((_to != 0) && (_to != address(this)));
142 
143             transferFrom(owner, _to, _amount);
144             return true;
145         }
146 
147         function invest(address _to, uint256 _amount) public returns (bool success) {
148             
149             require((_to != 0) && (_to != address(this)));
150 
151             if(IsPreSaleEnabled){
152                 require(preSaleTokenBalances >= _amount);
153                 preSaleTokenBalances = preSaleTokenBalances - _amount;
154             }
155             else if(!IsSaleEnabled){
156                 revert();
157             }
158             
159             transferFrom(msg.sender, _to, _amount);
160             return true;
161         }
162 
163         function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
164 
165             if(IsReleaseToken() || IsAirdrop() || tradeEnabled == true){
166                 if (_amount == 0) {
167                     Transfer(_from, _to, _amount);
168                     return;
169                 }
170 
171                 if (msg.sender != owner) {
172                     require(allowed[_from][msg.sender] >= _amount);
173                     allowed[_from][msg.sender] -= _amount;
174                 }
175 
176                 var previousBalanceFrom = balanceOfAt(_from, block.number);
177                 var previousBalanceTo = balanceOfAt(_to, block.number);
178 
179                 require(previousBalanceFrom >= _amount);
180                 require(previousBalanceTo + _amount >= previousBalanceTo);
181 
182                 updateValueAtNow(balances[msg.sender], previousBalanceFrom - _amount);
183                 updateValueAtNow(balances[_to], previousBalanceTo + _amount);
184 
185                 Transfer(_from, _to, _amount);
186 
187                 return true;
188             }
189             else
190                 revert();
191         }
192 
193         function balanceOf(address _owner) public constant returns (uint256 tokenBalance) {
194             return balanceOfAt(_owner, block.number);
195         }
196 
197         function approve(address _spender, uint256 _amount) public returns (bool success) {
198 
199             require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
200 
201             if (isValidAddress(owner)) {
202                 require(TokenController(owner).onApprove(msg.sender, _spender, _amount));
203             }
204 
205             allowed[msg.sender][_spender] = _amount;
206             Approval(msg.sender, _spender, _amount);
207             return true;
208         }
209 
210         function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
211             return allowed[_owner][_spender];
212         }
213 
214         function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
215 
216             require(approve(_spender, _amount));
217             ApproveAndCallFallBack(_spender).receiveApproval(msg.sender,_amount,this,_extraData);
218             return true;
219         }
220 
221         function totalSupply() public constant returns (uint) {
222             return totalSupplyAt(block.number);
223         }
224 
225         function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
226 
227             if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
228                 if (address(parentToken) != 0) {
229                     return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
230                 } else {
231                     return 0;
232                 }
233 
234             } else {
235                 return getValueAt(balances[_owner], _blockNumber);
236             }
237         }
238 
239         function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
240 
241             if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
242                 if (address(parentToken) != 0) {
243                     return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
244                 } else {
245                     return 0;
246                 }
247 
248             } else {
249                 return getValueAt(totalSupplyHistory, _blockNumber);
250             }
251         }
252 
253         function generateTokens(address _owner, uint _amount) public onlyOwner returns (bool) {
254             uint curTotalSupply = totalSupply();
255             require(curTotalSupply + _amount >= curTotalSupply);
256             uint previousBalanceTo = balanceOf(_owner);
257             require(previousBalanceTo + _amount >= previousBalanceTo);
258 
259             updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
260             updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
261 
262             uint256 _bal = _amount * 30;
263             preSaleTokenBalances = preSaleTokenBalances + _bal / 100;
264             Transfer(0, _owner, _amount);
265             return true;
266         }
267 
268         function destroyTokens(address _address, uint _amount) onlyOwner public returns (bool) {
269             uint curTotalSupply = totalSupply();
270             require(curTotalSupply >= _amount);
271             uint previousBalanceFrom = balanceOf(_address);
272             require(previousBalanceFrom >= _amount);
273             updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
274             updateValueAtNow(balances[_address], previousBalanceFrom - _amount);
275             Transfer(_address, owner, _amount);
276             return true;
277         }
278         
279         function destroyAllTokens() onlyOwner public returns (bool) {
280             uint curBalance = balanceOfAt(msg.sender, block.number);
281             updateValueAtNow(totalSupplyHistory, 0);
282             updateValueAtNow(balances[msg.sender], 0);
283             preSaleTokenBalances = 0;
284             Transfer(msg.sender, 0, curBalance);
285             return true;
286         }
287 
288         function enableTransfers(bool _tradeEnabled) public onlyOwner {
289             tradeEnabled = _tradeEnabled;
290         }
291 
292         function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
293             
294             if (checkpoints.length == 0) return 0;
295 
296             if (_block >= checkpoints[checkpoints.length-1].fromBlock)
297                 return checkpoints[checkpoints.length-1].value;
298 
299             if (_block < checkpoints[0].fromBlock) return 0;
300 
301             uint minValue = 0;
302             uint maximum = checkpoints.length-1;
303             while (maximum > minValue) {
304                 uint midddle = (maximum + minValue + 1)/ 2;
305                 if (checkpoints[midddle].fromBlock<=_block) {
306                     minValue = midddle;
307                 } else {
308                     maximum = midddle-1;
309                 }
310             }
311             return checkpoints[minValue].value;
312         }
313 
314         function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {
315             if ((checkpoints.length == 0) || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
316                 Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
317                 newCheckPoint.fromBlock =  uint128(block.number);
318                 newCheckPoint.value = uint128(_value);
319             } else {
320                 Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
321                 oldCheckPoint.value = uint128(_value);
322             }
323         }
324 
325         function isValidAddress(address _addr) constant internal returns(bool) {
326             uint size;
327             if (_addr == 0) return false;
328             assembly {
329                 size := extcodesize(_addr)
330             }
331             return size > 0;
332         }
333 
334         function min(uint a, uint b) pure internal returns (uint) {
335             return a < b ? a : b;
336         }
337 
338         event Transfer(address indexed _from, address indexed _to, uint256 _amount);
339         event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
340 
341     }