1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal constant returns (uint256) {
10         // assert(b > 0); // Solidity automatically throws when dividing by 0
11         uint256 c = a / b;
12         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal constant returns (uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 
26 contract Base {
27     modifier only(address allowed) {
28         require(msg.sender == allowed);
29         _;
30     }
31     modifier onlyPayloadSize(uint size) {
32         assert(msg.data.length == size + 4);
33         _;
34     } 
35     // *************************************************
36     // *          reentrancy handling                  *
37     // *************************************************
38     uint private bitlocks = 0;
39     modifier noReentrancy(uint m) {
40         var _locks = bitlocks;
41         require(_locks & m <= 0);
42         bitlocks |= m;
43         _;
44         bitlocks = _locks;
45     }
46     modifier noAnyReentrancy {
47         var _locks = bitlocks;
48         require(_locks <= 0);
49         bitlocks = uint(-1);
50         _;
51         bitlocks = _locks;
52     }
53     modifier reentrant { _; }
54 }
55 
56 
57 contract ERC20 is Base {
58     using SafeMath for uint;
59     uint public totalSupply;
60     bool public isFrozen = false;
61     event Transfer(address indexed _from, address indexed _to, uint _value);
62     event Approval(address indexed _owner, address indexed _spender, uint _value);
63     
64     function transferFrom(address _from, address _to, uint _value) public isNotFrozenOnly onlyPayloadSize(3 * 32) returns (bool success) {
65         require(_to != address(0));
66         require(_to != address(this));
67         balances[_from] = balances[_from].sub(_value);
68         balances[_to] = balances[_to].add(_value);
69         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
70         Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) public constant returns (uint balance) {
75         return balances[_owner];
76     }
77 
78     function approve_fixed(address _spender, uint _currentValue, uint _value) public isNotFrozenOnly onlyPayloadSize(3 * 32) returns (bool success) {
79         if(allowed[msg.sender][_spender] == _currentValue){
80             allowed[msg.sender][_spender] = _value;
81             Approval(msg.sender, _spender, _value);
82             return true;
83         } else {
84             return false;
85         }
86     }
87 
88     function approve(address _spender, uint _value) public isNotFrozenOnly onlyPayloadSize(2 * 32) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
95         return allowed[_owner][_spender];
96     }
97 
98     mapping (address => uint) balances;
99     mapping (address => mapping (address => uint)) allowed;
100     modifier isNotFrozenOnly() {
101         require(!isFrozen);
102         _;
103     }
104 
105     modifier isFrozenOnly(){
106         require(isFrozen);
107         _;
108     }
109 
110 }
111 
112 
113 contract Token is ERC20 {
114     string public name = "Array.io Token";
115     string public symbol = "eRAY";
116     uint8 public decimals = 18;
117     uint public constant BIT = 10**18;
118     uint public constant BASE = 10000 * BIT;
119     bool public tgeLive = false;
120     uint public tgeStartBlock;
121     uint public tgeSettingsAmount;
122     uint public tgeSettingsPartInvestor;
123     uint public tgeSettingsPartProject;
124     uint public tgeSettingsPartFounders;
125     uint public tgeSettingsBlocksPerStage;
126     uint public tgeSettingsPartInvestorIncreasePerStage;
127     uint public tgeSettingsAmountCollect;
128     uint public tgeSettingsMaxStages;
129     address public projectWallet;
130     address public foundersWallet;
131     address constant public burnAddress = address(0);
132     mapping (address => uint) public invBalances;
133     uint public totalInvSupply;
134 
135     modifier isTgeLive(){
136         require(tgeLive);
137         _;
138     }
139 
140     modifier isNotTgeLive(){
141         require(!tgeLive);
142         _;
143     }
144 
145     modifier maxStagesIsNotAchieved() {
146         if (totalSupply > BIT) {
147             uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);
148             require(stage < tgeSettingsMaxStages);
149         }
150         _;
151     }
152 
153     modifier targetIsNotAchieved(){
154         require(tgeSettingsAmountCollect < tgeSettingsAmount);
155         _;
156     }
157 
158     event Burn(address indexed _owner,  uint _value);
159 
160     function transfer(address _to, uint _value) public isNotFrozenOnly onlyPayloadSize(2 * 32) returns (bool success) {
161         require(_to != address(0));
162         require(_to != address(this));
163         balances[msg.sender] = balances[msg.sender].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         if(balances[projectWallet] < 1 * BIT){
166             _internalTgeSetLive();
167         }
168         Transfer(msg.sender, _to, _value);
169         return true;
170     }
171 
172     /// @dev Constructor
173     /// @param _projectWallet Wallet of project
174     /// @param _foundersWallet Wallet of founders
175     function Token(address _projectWallet, address _foundersWallet) public {
176         projectWallet = _projectWallet;
177         foundersWallet = _foundersWallet;
178     }
179 
180     /// @dev Fallback function allows to buy tokens
181     function ()
182     public
183     payable
184     isTgeLive
185     isNotFrozenOnly
186     targetIsNotAchieved
187     maxStagesIsNotAchieved
188     noAnyReentrancy
189     {
190         require(msg.value > 0);
191         if(tgeSettingsAmountCollect.add(msg.value) >= tgeSettingsAmount){
192             _finishTge();
193         }
194         uint refundAmount = 0;
195         uint senderAmount = msg.value;
196         if(tgeSettingsAmountCollect.add(msg.value) >= tgeSettingsAmount){
197             refundAmount = tgeSettingsAmountCollect.add(msg.value).sub(tgeSettingsAmount);
198             senderAmount = (msg.value).sub(refundAmount);
199         }
200         uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);        
201         
202         uint currentPartInvestor = tgeSettingsPartInvestor.add(stage.mul(tgeSettingsPartInvestorIncreasePerStage));
203         uint allStakes = currentPartInvestor.add(tgeSettingsPartProject).add(tgeSettingsPartFounders);
204         uint amountProject = senderAmount.mul(tgeSettingsPartProject).div(allStakes);
205         uint amountFounders = senderAmount.mul(tgeSettingsPartFounders).div(allStakes);
206         uint amountSender = senderAmount.sub(amountProject).sub(amountFounders);
207         _mint(amountProject, amountFounders, amountSender);
208         msg.sender.transfer(refundAmount);
209     }
210 
211     function setFinished()
212     public
213     only(projectWallet)
214     isNotFrozenOnly
215     isTgeLive
216     {
217         if(balances[projectWallet] > 1*BIT){
218             _finishTge();
219         }
220     }
221 
222     /// @dev Start new tge stage
223     function tgeSetLive()
224     public
225     only(projectWallet)
226     isNotTgeLive
227     isNotFrozenOnly
228     {
229         _internalTgeSetLive();
230     }
231 
232     /// @dev Burn tokens to burnAddress from msg.sender wallet
233     /// @param _amount Amount of tokens
234     function burn(uint _amount)
235     public 
236     isNotFrozenOnly
237     noAnyReentrancy    
238     returns(bool _success)
239     {
240         balances[msg.sender] = balances[msg.sender].sub(_amount);
241         balances[burnAddress] = balances[burnAddress].add(_amount);
242         totalSupply = totalSupply.sub(_amount);
243         msg.sender.transfer(_amount);
244         Transfer(msg.sender, burnAddress, _amount);
245         Burn(burnAddress, _amount);
246         return true;
247     }
248 
249     /// @dev _foundersWallet Wallet of founders
250     /// @param dests array of addresses 
251     /// @param values array amount of tokens to transfer    
252     function multiTransfer(address[] dests, uint[] values) 
253     public 
254     isNotFrozenOnly
255     returns(uint) 
256     {
257         uint i = 0;
258         while (i < dests.length) {
259            transfer(dests[i], values[i]);
260            i += 1;
261         }
262         return i;
263     }
264 
265     //---------------- FROZEN -----------------
266     /// @dev Allows an owner to confirm freezeng process
267     function setFreeze()
268     public
269     only(projectWallet)
270     isNotFrozenOnly
271     returns (bool)
272     {
273         isFrozen = true;
274         totalInvSupply = address(this).balance;
275         return true;
276     }
277 
278     /// @dev Allows to users withdraw eth in frozen stage 
279     function withdrawFrozen()
280     public
281     isFrozenOnly
282     noAnyReentrancy
283     {
284         require(invBalances[msg.sender] > 0);
285         
286         uint amountWithdraw = totalInvSupply.mul(invBalances[msg.sender]).div(totalSupply);        
287         invBalances[msg.sender] = 0;
288         msg.sender.transfer(amountWithdraw);
289     }
290 
291     /// @dev Allows an owner to confirm a change settings request.
292     function executeSettingsChange(
293         uint amount, 
294         uint partInvestor,
295         uint partProject, 
296         uint partFounders, 
297         uint blocksPerStage, 
298         uint partInvestorIncreasePerStage,
299         uint maxStages
300     ) 
301     public
302     only(projectWallet)
303     isNotTgeLive 
304     isNotFrozenOnly
305     returns(bool success) 
306     {
307         tgeSettingsAmount = amount;
308         tgeSettingsPartInvestor = partInvestor;
309         tgeSettingsPartProject = partProject;
310         tgeSettingsPartFounders = partFounders;
311         tgeSettingsBlocksPerStage = blocksPerStage;
312         tgeSettingsPartInvestorIncreasePerStage = partInvestorIncreasePerStage;
313         tgeSettingsMaxStages = maxStages;
314         return true;
315     }
316 
317     //---------------- GETTERS ----------------
318     /// @dev Amount of blocks left to the end of this stage of TGE 
319     function tgeStageBlockLeft() 
320     public 
321     view
322     isTgeLive
323     returns(uint)
324     {
325         uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);
326         return tgeStartBlock.add(stage.mul(tgeSettingsBlocksPerStage)).sub(block.number);
327     }
328 
329     function tgeCurrentPartInvestor()
330     public
331     view
332     isTgeLive
333     returns(uint)
334     {
335         uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);
336         return tgeSettingsPartInvestor.add(stage.mul(tgeSettingsPartInvestorIncreasePerStage));
337     }
338 
339     function tgeNextPartInvestor()
340     public
341     view
342     isTgeLive
343     returns(uint)
344     {
345         uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage).add(1);        
346         return tgeSettingsPartInvestor.add(stage.mul(tgeSettingsPartInvestorIncreasePerStage));
347     }
348 
349     //---------------- INTERNAL ---------------
350     function _finishTge()
351     internal
352     {
353         tgeLive = false;
354     }
355 
356     function _mint(uint _amountProject, uint _amountFounders, uint _amountSender)
357     internal
358     {
359         balances[projectWallet] = balances[projectWallet].add(_amountProject);
360         balances[foundersWallet] = balances[foundersWallet].add(_amountFounders);
361         balances[msg.sender] = balances[msg.sender].add(_amountSender);
362         invBalances[msg.sender] = invBalances[msg.sender].add(_amountSender);
363         tgeSettingsAmountCollect = tgeSettingsAmountCollect.add(_amountProject+_amountFounders+_amountSender);
364         totalSupply = totalSupply.add(_amountProject+_amountFounders+_amountSender);
365         Transfer(0x0, msg.sender, _amountSender);
366         Transfer(0x0, projectWallet, _amountProject);
367         Transfer(0x0, foundersWallet, _amountFounders);
368     }
369 
370     function _internalTgeSetLive()
371     internal
372     {
373         tgeLive = true;
374         tgeStartBlock = block.number;
375         tgeSettingsAmountCollect = 0;
376     }
377 }