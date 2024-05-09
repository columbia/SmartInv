1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29 }
30 
31 
32 contract Base {
33 
34     uint private bitlocks = 0;
35 
36     modifier noAnyReentrancy {
37         uint _locks = bitlocks;
38         require(_locks <= 0);
39         bitlocks = uint(-1);
40         _;
41         bitlocks = _locks;
42     }
43 
44     modifier only(address allowed) {
45         require(msg.sender == allowed);
46         _;
47     }
48 
49     modifier onlyPayloadSize(uint size) {
50         assert(msg.data.length == size + 4);
51         _;
52     } 
53 
54 }
55 
56 
57 contract ERC20 is Base {
58     
59     mapping (address => uint) balances;
60     mapping (address => mapping (address => uint)) allowed;
61     using SafeMath for uint;
62     uint public totalSupply;
63     bool public isFrozen = false;
64     event Transfer(address indexed _from, address indexed _to, uint _value);
65     event Approval(address indexed _owner, address indexed _spender, uint _value);
66     
67     function transferFrom(address _from, address _to, uint _value) public isNotFrozenOnly onlyPayloadSize(3 * 32) returns (bool success) {
68         require(_to != address(0));
69         require(_to != address(this));
70         balances[_from] = balances[_from].sub(_value);
71         balances[_to] = balances[_to].add(_value);
72         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
73         Transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function balanceOf(address _owner) public view returns (uint balance) {
78         return balances[_owner];
79     }
80 
81     function approve_fixed(address _spender, uint _currentValue, uint _value) public isNotFrozenOnly onlyPayloadSize(3 * 32) returns (bool success) {
82         if(allowed[msg.sender][_spender] == _currentValue){
83             allowed[msg.sender][_spender] = _value;
84             Approval(msg.sender, _spender, _value);
85             return true;
86         } else {
87             return false;
88         }
89     }
90 
91     function approve(address _spender, uint _value) public isNotFrozenOnly onlyPayloadSize(2 * 32) returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
98         return allowed[_owner][_spender];
99     }
100 
101     modifier isNotFrozenOnly() {
102         require(!isFrozen);
103         _;
104     }
105 
106     modifier isFrozenOnly(){
107         require(isFrozen);
108         _;
109     }
110 
111 }
112 
113 
114 contract Token is ERC20 {
115 
116     string public name = "Array.io Token";
117     string public symbol = "eRAY";
118     uint8 public decimals = 18;
119     uint public constant BIT = 10**18;
120     bool public tgeLive = false;
121     uint public tgeStartBlock;
122     uint public tgeSettingsAmount;
123     uint public tgeSettingsPartInvestor;
124     uint public tgeSettingsPartProject;
125     uint public tgeSettingsPartFounders;
126     uint public tgeSettingsBlocksPerStage;
127     uint public tgeSettingsPartInvestorIncreasePerStage;
128     uint public tgeSettingsAmountCollect;
129     uint public tgeSettingsMaxStages;
130     address public projectWallet;
131     address public foundersWallet;
132     address constant public burnAddress = address(0);
133     mapping (address => uint) public invBalances;
134     uint public totalInvSupply;
135 
136     modifier isTgeLive(){
137         require(tgeLive);
138         _;
139     }
140 
141     modifier isNotTgeLive(){
142         require(!tgeLive);
143         _;
144     }
145 
146     modifier maxStagesIsNotAchieved() {
147         if (totalSupply > BIT) {
148             uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);
149             require(stage < tgeSettingsMaxStages);
150         }
151         _;
152     }
153 
154     modifier targetIsNotAchieved(){
155         require(tgeSettingsAmountCollect < tgeSettingsAmount);
156         _;
157     }
158 
159     event Burn(address indexed _owner,  uint _value);
160 
161     function transfer(address _to, uint _value) public isNotFrozenOnly onlyPayloadSize(2 * 32) returns (bool success) {
162         require(_to != address(0));
163         require(_to != address(this));
164         balances[msg.sender] = balances[msg.sender].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166         if(balances[projectWallet] < 1 * BIT && !tgeLive){
167             _internalTgeSetLive();
168         }
169         Transfer(msg.sender, _to, _value);
170         return true;
171     }
172 
173     /// @dev Constructor
174     /// @param _projectWallet Wallet of project
175     /// @param _foundersWallet Wallet of founders
176     function Token(address _projectWallet, address _foundersWallet) public {
177         projectWallet = _projectWallet;
178         foundersWallet = _foundersWallet;
179     }
180 
181     /// @dev Fallback function allows to buy tokens
182     function ()
183     public
184     payable
185     isTgeLive
186     isNotFrozenOnly
187     targetIsNotAchieved
188     maxStagesIsNotAchieved
189     noAnyReentrancy
190     {
191         require(msg.value > 0);
192         if(tgeSettingsAmountCollect.add(msg.value) >= tgeSettingsAmount){
193             tgeLive = false;
194         }
195         uint refundAmount = 0;
196         uint senderAmount = msg.value;
197         if(tgeSettingsAmountCollect.add(msg.value) >= tgeSettingsAmount){
198             refundAmount = tgeSettingsAmountCollect.add(msg.value).sub(tgeSettingsAmount);
199             senderAmount = (msg.value).sub(refundAmount);
200         }
201         uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);        
202         
203         uint currentPartInvestor = tgeSettingsPartInvestor.add(stage.mul(tgeSettingsPartInvestorIncreasePerStage));
204         uint allStakes = currentPartInvestor.add(tgeSettingsPartProject).add(tgeSettingsPartFounders);
205         uint amountProject = senderAmount.mul(tgeSettingsPartProject).div(allStakes);
206         uint amountFounders = senderAmount.mul(tgeSettingsPartFounders).div(allStakes);
207         uint amountSender = senderAmount.sub(amountProject).sub(amountFounders);
208         _mint(amountProject, amountFounders, amountSender);
209         msg.sender.transfer(refundAmount);
210         this.updateStatus();
211     }
212 
213     function setFinished() public only(projectWallet) isNotFrozenOnly isTgeLive {
214         if(balances[projectWallet] > 1*BIT){
215             tgeLive = false;
216         }
217     }
218 
219     function updateStatus() public {
220         if (totalSupply > BIT) {
221             uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);
222             if (stage > tgeSettingsMaxStages) {
223                 tgeLive = false;
224             }
225         }
226     }
227 
228     /// @dev Start new tge stage
229     function tgeSetLive() public only(projectWallet) isNotTgeLive isNotFrozenOnly {
230         _internalTgeSetLive();
231     }
232 
233     /// @dev Burn tokens to burnAddress from msg.sender wallet
234     /// @param _amount Amount of tokens
235     function burn(uint _amount) public isNotFrozenOnly noAnyReentrancy returns(bool _success) {
236         balances[msg.sender] = balances[msg.sender].sub(_amount);
237         balances[burnAddress] = balances[burnAddress].add(_amount);
238         totalSupply = totalSupply.sub(_amount);
239         msg.sender.transfer(_amount);
240         Transfer(msg.sender, burnAddress, _amount);
241         Burn(burnAddress, _amount);
242         return true;
243     }
244 
245     /// @dev _foundersWallet Wallet of founders
246     /// @param dests array of addresses 
247     /// @param values array amount of tokens to transfer    
248     function multiTransfer(address[] dests, uint[] values) public isNotFrozenOnly returns(uint) {
249         uint i = 0;
250         while (i < dests.length) {
251            transfer(dests[i], values[i]);
252            i += 1;
253         }
254         return i;
255     }
256 
257     //---------------- FROZEN -----------------
258 
259     /// @dev Allows an owner to confirm freezeng process
260     function setFreeze() public only(projectWallet) isNotFrozenOnly returns (bool) {
261         isFrozen = true;
262         totalInvSupply = address(this).balance;
263         return true;
264     }
265 
266     /// @dev Allows to users withdraw eth in frozen stage 
267     function withdrawFrozen() public isFrozenOnly noAnyReentrancy {
268         require(invBalances[msg.sender] > 0);
269 
270         uint amountWithdraw = totalSupply.mul(invBalances[msg.sender]).div(totalInvSupply);
271         // fix possible rounding errors for last withdrawal:
272         if (amountWithdraw > address(this).balance) {
273             amountWithdraw = address(this).balance;
274         }
275         invBalances[msg.sender] = 0;
276         msg.sender.transfer(amountWithdraw);
277     }
278 
279     /// @dev Allows an owner to confirm a change settings request.
280     function executeSettingsChange(
281         uint amount, 
282         uint partInvestor,
283         uint partProject, 
284         uint partFounders, 
285         uint blocksPerStage, 
286         uint partInvestorIncreasePerStage,
287         uint maxStages
288     ) 
289     public
290     only(projectWallet)
291     isNotTgeLive 
292     isNotFrozenOnly
293     returns(bool success) 
294     {
295         tgeSettingsAmount = amount;
296         tgeSettingsPartInvestor = partInvestor;
297         tgeSettingsPartProject = partProject;
298         tgeSettingsPartFounders = partFounders;
299         tgeSettingsBlocksPerStage = blocksPerStage;
300         tgeSettingsPartInvestorIncreasePerStage = partInvestorIncreasePerStage;
301         tgeSettingsMaxStages = maxStages;
302         return true;
303     }
304 
305     //---------------- GETTERS ----------------
306     /// @dev Amount of blocks left to the end of this stage of TGE 
307     function tgeStageBlockLeft() public view isTgeLive returns(uint) {
308         uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);
309         return tgeStartBlock.add(stage.mul(tgeSettingsBlocksPerStage)).sub(block.number);
310     }
311 
312     function tgeCurrentPartInvestor() public view isTgeLive returns(uint) {
313         uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);
314         return tgeSettingsPartInvestor.add(stage.mul(tgeSettingsPartInvestorIncreasePerStage));
315     }
316 
317     function tgeNextPartInvestor() public view isTgeLive returns(uint) {
318         uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage).add(1);        
319         return tgeSettingsPartInvestor.add(stage.mul(tgeSettingsPartInvestorIncreasePerStage));
320     }
321 
322     //---------------- INTERNAL ---------------
323     function _mint(uint _amountProject, uint _amountFounders, uint _amountSender) internal {
324         balances[projectWallet] = balances[projectWallet].add(_amountProject);
325         balances[foundersWallet] = balances[foundersWallet].add(_amountFounders);
326         balances[msg.sender] = balances[msg.sender].add(_amountSender);
327         invBalances[msg.sender] = invBalances[msg.sender].add(_amountSender).add(_amountFounders).add(_amountProject);
328         tgeSettingsAmountCollect = tgeSettingsAmountCollect.add(_amountProject+_amountFounders+_amountSender);
329         totalSupply = totalSupply.add(_amountProject+_amountFounders+_amountSender);
330         Transfer(0x0, msg.sender, _amountSender);
331         Transfer(0x0, projectWallet, _amountProject);
332         Transfer(0x0, foundersWallet, _amountFounders);
333     }
334 
335     function _internalTgeSetLive() internal {
336         tgeLive = true;
337         tgeStartBlock = block.number;
338         tgeSettingsAmountCollect = 0;
339     }
340 
341 }