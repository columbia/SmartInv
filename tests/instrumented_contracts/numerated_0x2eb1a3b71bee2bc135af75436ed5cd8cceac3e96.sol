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
71         modifier canReleaseToken {
72             if (IsSaleEnabled == true || IsPreSaleEnabled == true) 
73                 _;
74             else
75                 revert();
76         }
77 
78         modifier onlyairDropManager { 
79             require(msg.sender == airDropManager); _; 
80         }
81 
82         function KayoToken(
83             address _tokenFactory,
84             address _parentToken,
85             uint _parentSnapShotBlock,
86             string _tokenName,
87             uint8 _decimalUnits,
88             string _tokenSymbol,
89             bool _transfersEnabled
90         ) public {
91             owner = _tokenFactory;
92             name = _tokenName;                                 
93             decimals = _decimalUnits;                          
94             symbol = _tokenSymbol;                             
95             parentToken = KayoToken(_parentToken);
96             parentSnapShotBlock = _parentSnapShotBlock;
97             transfersEnabled = _transfersEnabled;
98             creationBlock = block.number;
99         }
100 
101         function transfer(address _to, uint256 _amount) public returns (bool success) {
102             require(transfersEnabled);
103             transferFrom(msg.sender, _to, _amount);
104             return true;
105         }
106 
107         function freezeAccount(address target, bool freeze) onlyOwner public{
108             frozenAccount[target] = freeze;
109             FrozenFunds(target, freeze);
110         }
111 
112         function setPreSale (bool _value) onlyOwner public {
113             IsPreSaleEnabled = _value;
114         }
115 
116         function setSale (bool _value) onlyOwner public {
117             IsSaleEnabled = _value;
118         }
119 
120         function setAirDrop (bool _value) onlyOwner public {
121             IsAirDropEnabled = _value;
122         }
123 
124         function setAirDropManager (address _address) onlyOwner public{
125             airDropManager = _address;
126         }
127 
128         function setairDropManagerLimit(uint _amount) onlyOwner public returns (bool success){
129             allowedAirDropTokens = _amount;
130             approve(airDropManager, _amount);
131             return true;
132         }
133 
134         function airDrop(address _to, uint256 _amount) onlyairDropManager public returns (bool success){
135             
136             require((_to != 0) && (_to != address(this)));
137             require(IsAirDropEnabled);
138             
139             require(allowed[owner][msg.sender] >= _amount);
140             allowed[owner][msg.sender] -= _amount;
141             Transfer(owner, _to, _amount);
142             return true;
143         }
144 
145         function invest(address _to, uint256 _amount) canReleaseToken onlyOwner public returns (bool success) {
146             
147             require((_to != 0) && (_to != address(this)));
148 
149             bool IsTransferAllowed = false;
150 
151             if(IsPreSaleEnabled){
152                 require(preSaleTokenBalances >= _amount);
153                 IsTransferAllowed = true;
154                 preSaleTokenBalances = preSaleTokenBalances - _amount;
155             }
156             else if(IsSaleEnabled){
157                 IsTransferAllowed = true;
158             }
159             else{
160                 revert();
161             }
162 
163             require(IsTransferAllowed);
164             var previousBalanceFrom = balanceOfAt(msg.sender, block.number);
165             require(previousBalanceFrom >= _amount);
166             updateValueAtNow(balances[msg.sender], previousBalanceFrom - _amount);
167 
168             var previousBalanceTo = balanceOfAt(_to, block.number);
169             require(previousBalanceTo + _amount >= previousBalanceTo);
170             updateValueAtNow(balances[_to], previousBalanceTo + _amount);
171 
172             transferFrom(msg.sender, _to, _amount); //Owner sending tokens
173             return true;
174         }
175 
176         function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
177 
178             require(IsSaleEnabled && !IsPreSaleEnabled);
179 
180             if (_amount == 0) {
181                 Transfer(_from, _to, _amount);
182                 return;
183             }
184 
185             if (msg.sender != owner) {
186                 require(allowed[_from][msg.sender] >= _amount);
187                 allowed[_from][msg.sender] -= _amount;
188             }
189 
190             Transfer(_from, _to, _amount);
191 
192             return true;
193         }
194 
195         function balanceOf(address _owner) public constant returns (uint256 tokenBalance) {
196             return balanceOfAt(_owner, block.number);
197         }
198 
199         function approve(address _spender, uint256 _amount) public returns (bool success) {
200 
201             require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
202 
203             if (isValidAddress(owner)) {
204                 require(TokenController(owner).onApprove(msg.sender, _spender, _amount));
205             }
206 
207             allowed[msg.sender][_spender] = _amount;
208             Approval(msg.sender, _spender, _amount);
209             return true;
210         }
211 
212         function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
213             return allowed[_owner][_spender];
214         }
215 
216         function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
217 
218             require(approve(_spender, _amount));
219             ApproveAndCallFallBack(_spender).receiveApproval(msg.sender,_amount,this,_extraData);
220             return true;
221         }
222 
223         function totalSupply() public constant returns (uint) {
224             return totalSupplyAt(block.number);
225         }
226 
227         function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
228 
229             if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
230                 if (address(parentToken) != 0) {
231                     return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
232                 } else {
233                     return 0;
234                 }
235 
236             } else {
237                 return getValueAt(balances[_owner], _blockNumber);
238             }
239         }
240 
241         function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
242 
243             if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
244                 if (address(parentToken) != 0) {
245                     return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
246                 } else {
247                     return 0;
248                 }
249 
250             } else {
251                 return getValueAt(totalSupplyHistory, _blockNumber);
252             }
253         }
254 
255         function generateTokens(address _owner, uint _amount) public onlyOwner returns (bool) {
256             uint curTotalSupply = totalSupply();
257             require(curTotalSupply + _amount >= curTotalSupply);
258             uint previousBalanceTo = balanceOf(_owner);
259             require(previousBalanceTo + _amount >= previousBalanceTo);
260 
261             updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
262             updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
263 
264             uint256 _bal = _amount * 30;
265             preSaleTokenBalances = preSaleTokenBalances + _bal / 100;
266             Transfer(0, _owner, _amount);
267             return true;
268         }
269 
270         function destroyTokens(address _owner, uint _amount) onlyOwner public returns (bool) {
271             uint curTotalSupply = totalSupply();
272             require(curTotalSupply >= _amount);
273             uint previousBalanceFrom = balanceOf(_owner);
274             require(previousBalanceFrom >= _amount);
275             updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
276             updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
277             Transfer(_owner, 0, _amount);
278             return true;
279         }
280         
281         function destroyAllTokens(address _owner) onlyOwner public returns (bool) {
282             updateValueAtNow(totalSupplyHistory, 0);
283             updateValueAtNow(balances[_owner], 0);
284             Transfer(_owner, 0, 0);
285             return true;
286         }
287 
288         function enableTransfers(bool _transfersEnabled) public onlyOwner {
289             transfersEnabled = _transfersEnabled;
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