1 pragma solidity ^0.4.18;
2 
3 
4 contract owned {
5     address public owner;
6     address private ownerCandidate;
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         assert(owner == msg.sender);
14         _;
15     }
16 
17     modifier onlyOwnerCandidate() {
18         assert(msg.sender == ownerCandidate);
19         _;
20     }
21 
22     function transferOwnership(address candidate) external onlyOwner {
23         ownerCandidate = candidate;
24     }
25 
26     function acceptOwnership() external onlyOwnerCandidate {
27         owner = ownerCandidate;
28     }
29 }
30 
31 
32 contract Random {
33     uint64 _seed = 0;
34 
35 
36     function random(uint64 upper) public returns (uint64 randomNumber) {
37         _seed = uint64(keccak256(keccak256(block.blockhash(block.number), _seed), now));
38         return _seed % upper;
39     }
40 }
41 
42 
43 
44 contract SafeMath {
45     function safeMul(uint a, uint b) pure internal returns (uint) {
46         uint c = a * b;
47         assert(a == 0 || c / a == b);
48         return c;
49     }
50 
51     function safeDiv(uint a, uint b) pure internal returns (uint) {
52         uint c = a / b;
53         assert(b == 0);
54         return c;
55     }
56 
57     function safeSub(uint a, uint b) pure internal returns (uint) {
58         assert(b <= a);
59         return a - b;
60     }
61 
62     function safeAdd(uint a, uint b) pure internal returns (uint) {
63         uint c = a + b;
64         assert(c >= a && c >= b);
65         return c;
66     }
67 }
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 
79 
80 contract Token is SafeMath, owned {
81 
82     string public name;
83     string public symbol;
84     uint public decimals = 8;
85 
86     mapping (address => uint) public balanceOf;
87     mapping (address => mapping (address => uint)) public allowance;
88     mapping (address => uint) public limitAddress;
89 
90     uint public totalSupply = 10 * 10000 * 10000 * 10 ** uint256(decimals);
91 
92     modifier validAddress(address _address) {
93         assert(0x0 != _address);
94         _;
95     }
96 
97     function addLimitAddress(address _a)
98         public
99         validAddress(_a)
100         onlyOwner
101     {
102         limitAddress[_a] = 1;
103     }
104 
105     function delLitAddress(address _a)
106         public
107         validAddress(_a)
108         onlyOwner
109     {
110         limitAddress[_a] = 0;
111     }
112 
113     function Token(string _name, string _symbol)
114         public
115     {
116         name = _name;
117         symbol = _symbol;
118         owner = msg.sender;
119         balanceOf[this] = totalSupply;
120         Transfer(0x0, this, totalSupply);
121     }
122 
123     function transfer(address _to, uint _value)
124         public
125         validAddress(_to)
126         returns (bool success)
127     {
128         require(balanceOf[msg.sender] >= _value);
129         require(balanceOf[_to] + _value >= balanceOf[_to]);
130         balanceOf[msg.sender] -= _value;
131         balanceOf[_to] += _value;
132         Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     function batchtransfer(address[] _to, uint256[] _amount) public returns(bool success) {
137         for(uint i = 0; i < _to.length; i++){
138             require(transfer(_to[i], _amount[i]));
139         }
140         return true;
141     }
142 
143     function transferInner(address _to, uint _value)
144         private
145         returns (bool success)
146     {
147         balanceOf[this] -= _value;
148         balanceOf[_to] += _value;
149         Transfer(this, _to, _value);
150         return true;
151     }
152 
153     function transferFrom(address _from, address _to, uint _value)
154         public
155         validAddress(_from)
156         validAddress(_to)
157         returns (bool success)
158     {
159         require(balanceOf[_from] >= _value);
160         require(balanceOf[_to] + _value >= balanceOf[_to]);
161         require(allowance[_from][msg.sender] >= _value);
162         balanceOf[_to] += _value;
163         balanceOf[_from] -= _value;
164         allowance[_from][msg.sender] -= _value;
165         Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     function approve(address _spender, uint _value)
170         public
171         validAddress(_spender)
172         returns (bool success)
173     {
174         require(_value == 0 || allowance[msg.sender][_spender] == 0);
175         allowance[msg.sender][_spender] = _value;
176         Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     function ()
181         public
182         payable
183     {
184 
185     }
186 
187     function mint(address _to, uint _amount) public validAddress(_to)
188     {
189         if(limitAddress[msg.sender] != 1) return;
190         if(balanceOf[this] == 0) return;
191 
192         uint supply = _amount;
193 
194         if(balanceOf[this] < supply) {
195             supply = balanceOf[this];
196         }
197         require(transferInner(_to, supply));
198         
199         Mint(_to, supply);
200     }
201 
202     function withdraw(uint amount)
203         public
204         onlyOwner
205     {
206         require(this.balance >= amount);
207         msg.sender.transfer(amount);
208     }
209 
210     event Mint(address _to, uint _amount);
211     event Transfer(address indexed _from, address indexed _to, uint _value);
212     event Approval(address indexed _owner, address indexed _spender, uint _value);
213 
214 }
215 
216 
217 contract GameOne is SafeMath, Random, owned {
218 
219     uint256 public createTime = 0;
220 
221 
222     uint public gameState = 0;
223     uint private constant GAME_RUNNING = 0;
224     uint private constant GAME_FINISHED = 2;
225     uint public gameCount = 0;
226 
227 
228     uint public minEth = 0.1 ether;
229     uint public maxEth = 100 ether;
230 
231     uint public cut = 10;
232     uint public ethQuantity = 0;
233 
234     address public opponent = 0x0;
235     uint public opponentAmount = 0;
236 
237     Token public tokenContract;
238 
239     event Bet(address a, uint av, address b, uint bv, uint apercent, uint rand, address winner, uint _now);
240 
241     modifier validAddress(address _address) {
242         assert(0x0 != _address);
243         _;
244     }
245 
246     modifier isOwner {
247         assert(owner == msg.sender);
248         _;
249     }
250 
251     modifier validEth {
252         assert(msg.value >= minEth && msg.value <= maxEth);
253         _;
254     }
255 
256     modifier validState {
257         assert(gameState == GAME_RUNNING);
258         _;
259     }
260 
261     function GameOne(address _tokenContract) public validAddress(_tokenContract) {
262         tokenContract = Token(_tokenContract);
263         createTime = now;
264     }
265 
266     
267     function () public payable {
268         bet();
269     }
270 
271     function setCut(uint newCut) public isOwner {
272         assert(newCut > 0 && newCut <= 20);
273         cut = newCut;
274     }
275 
276     function setMinEth(uint newMinEth) public isOwner {
277         assert(newMinEth >= 0.01 ether);
278         minEth = newMinEth;
279     }
280 
281     function setMaxEth(uint newMaxEth) public isOwner {
282         assert(newMaxEth >= 0.1 ether);
283         maxEth = newMaxEth;
284     }
285 
286     function setTokenAddress(address _addr) public isOwner {
287         tokenContract = Token(_addr);
288     }
289 
290 
291     function bet() public payable
292         validState
293         validEth
294     {
295         uint eth = msg.value;
296         uint bonus = 0;
297         uint amount = 0;
298         address winner;
299         address loser;
300         uint loserAmount = 0;
301         uint rate;
302         uint token = 0;
303 
304 
305         ethQuantity = safeAdd(ethQuantity, eth);
306 
307         if (opponent== 0x0) {
308             opponent = msg.sender;
309             opponentAmount = eth;
310         } else {
311             winner = randomaward(opponent, msg.sender, opponentAmount, eth);
312             if(winner == msg.sender) {
313                 loser = opponent;
314                 loserAmount = opponentAmount;
315                 rate = opponentAmount * cut/100;
316             }else{
317                 loser = msg.sender;
318                 loserAmount = eth;
319                 rate = eth * cut/100;
320             }
321 
322             token = loserAmount * 10000 / 10 ** 10;
323             tokenContract.mint(loser, token);
324 
325             gameCount = safeAdd(gameCount, 1);
326 
327             bonus = safeAdd(opponentAmount, eth);
328             amount = safeSub(bonus, rate);
329             require(transferInner(winner, amount));
330             reset();
331         }
332     }
333 
334     function reset () private {
335         opponent = 0x0;
336         opponentAmount = 0;
337     }
338 
339     function randomaward(address a, address b, uint av, uint bv) private returns (address win) {
340         uint bonus = safeAdd(av, bv);
341 
342         uint apercent = av * 10 ** 2 /bonus;
343         uint rand = random(100);
344         if (rand<=apercent) {
345             win = a;
346         } else {
347             win = b;
348         }
349         Bet(a, av, b, bv, apercent, rand, win, now);
350         return win;
351     }
352 
353     function withdraw (uint amount) public isOwner {
354         uint  lef = 0;
355         if (opponent != 0x0) {
356             lef = this.balance - opponentAmount;
357         } else {
358             lef = this.balance;
359         }
360         require(lef >= amount);
361 
362         msg.sender.transfer(amount);
363     }
364 
365 
366     function setFinished () public isOwner {
367         gameState = GAME_FINISHED;
368     }
369 
370     function setRunning () public isOwner {
371         gameState = GAME_RUNNING;
372     }
373 
374     function transferInner(address _to, uint _value)
375         private
376         returns (bool success)
377     {
378         require(this.balance >= _value);
379         _to.transfer(_value);
380         Transfer(this, _to, _value);
381         return true;
382     }
383 
384     event Transfer(address indexed _from, address indexed _to, uint _value);
385 }