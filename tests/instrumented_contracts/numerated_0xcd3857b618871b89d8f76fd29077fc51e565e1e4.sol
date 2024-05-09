1 pragma solidity 0.4.25;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract EtherWinAccessControl {
35     event GamePaused();
36     event GameResumed();
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     address public owner;
41     address public manager;
42 
43     address public dividendManagerAddress;
44     address public wallet;
45 
46     bool public paused = false;
47     bool public locked = false;
48 
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     modifier onlyManager() {
56         require(msg.sender == owner || msg.sender == manager);
57         _;
58     }
59 
60     modifier whenUnlocked() {
61         require(!locked);
62         _;
63     }
64 
65     modifier whenNotPaused() {
66         require(!paused);
67         _;
68     }
69 
70     modifier whenPaused {
71         require(paused);
72         _;
73     }
74 
75 
76     constructor() public {
77         owner = msg.sender;
78         manager = msg.sender;
79         wallet = msg.sender;
80     }
81 
82 
83     function setManager(address _managerAddress) onlyManager external {
84         require(_managerAddress != address(0));
85         manager = _managerAddress;
86     }
87 
88 
89     function setWallet(address _newWallet) onlyManager external {
90         require(_newWallet != address(0));
91         wallet = _newWallet;
92     }
93 
94 
95     function setDividendManager(address _dividendManagerAddress) whenUnlocked onlyManager external  {
96         require(_dividendManagerAddress != address(0));
97         dividendManagerAddress = _dividendManagerAddress;
98     }
99 
100 
101     function pause() onlyManager whenNotPaused public {
102         paused = true;
103         emit GamePaused();
104     }
105 
106 
107     function unpause() onlyManager whenPaused public {
108         paused = false;
109         emit GameResumed();
110     }
111 
112 
113     function lock() onlyOwner whenUnlocked external {
114         locked = true;
115     }
116 
117 }
118 
119 
120 contract ERC20 {
121     function allowance(address owner, address spender) public view returns (uint256);
122     function transferFrom(address from, address to, uint256 value) public returns (bool);
123     function totalSupply() public view returns (uint256);
124     function balanceOf(address who) public view returns (uint256);
125     function transfer(address to, uint256 value) public returns (bool);
126     function ownerTransfer(address to, uint256 value) public returns (bool);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     function approve(address spender, uint256 value) public returns (bool);
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 
134 contract DividendManagerInterface {
135     function depositDividend() external payable;
136 }
137 
138 
139 contract EtherWin is EtherWinAccessControl {
140     using SafeMath for uint256;
141 
142     event NewTicket(address indexed owner, uint indexed blockNum, address indexed referrer, uint value);
143     event NewPrice(uint minWei,uint maxWei);
144     event NewWeiPerBlock(uint newWeiPerBlock);
145     event SendPrize(address indexed owner, uint indexed blockNum, uint value);
146     event FundsTransferred(address dividendManager, uint value);
147     event WinBlockAdded(uint indexed blockNum);
148 
149     uint public minWei = 5000000000000000;
150     uint public maxWei = 50000000000000000;
151     uint public maxWeiPerBlock = 500000000000000000;
152     uint public ownersWeis;  // reserved weis for owners
153     uint public depositWeis;  // reserved weis for return deposit
154     uint public prizePercent = 91875;
155     uint public ownersPercent = 8125;
156     uint public refPercent = 1000;
157 
158 
159     struct Ticket {
160         uint value;
161         bool executed;
162     }
163 
164     struct WinBlock {
165         bool exists;
166         uint8 lastByte;
167         uint8 rate;
168         bool jp;
169         uint value;
170     }
171 
172     mapping (address => mapping (uint => Ticket)) public tickets; // user addr -> block number -> ticket
173 
174     mapping (uint => uint) public blocks; //blicknum -> weis in block
175     mapping (uint8 => uint8) rates;
176 
177     mapping (uint => WinBlock) public winBlocks;
178 
179     uint public allTicketsPrice;
180     mapping (uint => uint) public allTicketsForBlock; //block num -> allTicketsPrice needs for JP
181     uint[] public JPBlocks;
182     mapping (address => uint) public refs;
183     mapping (address => address) public userRefs;
184 
185 
186     uint divider = 5;
187     uint public lastPayout;
188 
189 
190     constructor() public {
191         rates[10] = 15; //a
192         rates[11] = 15; //b
193         rates[12] = 15; //c
194 
195         rates[13] = 20; //d
196         rates[14] = 20; //e
197 
198         rates[15] = 30; //f
199 
200         rates[153] = 99; //99
201     }
202 
203 
204     function () public payable {
205         play(address(0));
206     }
207 
208 
209     function play(address _ref) whenNotPaused public payable {
210         Ticket storage t = tickets[msg.sender][block.number];
211 
212         require(t.value.add(msg.value) >= minWei && t.value.add(msg.value) <= maxWei);
213         require(blocks[block.number].add(msg.value) <= maxWeiPerBlock);
214 
215         t.value = t.value.add(msg.value);
216 
217         blocks[block.number] = blocks[block.number].add(msg.value);
218 
219         if (_ref != address(0) && _ref != msg.sender) {
220             userRefs[msg.sender] = _ref;
221         }
222 
223         //need for JP
224         allTicketsPrice = allTicketsPrice.add(msg.value);
225         allTicketsForBlock[block.number] = allTicketsPrice;
226 
227         if (userRefs[msg.sender] != address(0)) {
228             refs[_ref] = refs[_ref].add(valueFromPercent(msg.value, refPercent));
229             ownersWeis = ownersWeis.add(valueFromPercent(msg.value, ownersPercent.sub(refPercent)));
230         } else {
231             ownersWeis = ownersWeis.add(valueFromPercent(msg.value,ownersPercent));
232         }
233 
234         emit NewTicket(msg.sender, block.number, _ref, t.value);
235     }
236 
237 
238     function addWinBlock(uint _blockNum) public  {
239         require( (_blockNum.add(12) < block.number) && (_blockNum > block.number - 256) );
240         require(!winBlocks[_blockNum].exists);
241         require(blocks[_blockNum-1] > 0);
242 
243         bytes32 bhash = blockhash(_blockNum);
244         uint8 lastByte = uint8(bhash[31]);
245 
246         require( ((rates[lastByte % 16]) > 0) || (rates[lastByte] > 0) );
247 
248         _addWinBlock(_blockNum, lastByte);
249     }
250 
251 
252     function _addWinBlock(uint _blockNum, uint8 _lastByte) internal {
253         WinBlock storage wBlock = winBlocks[_blockNum];
254         wBlock.exists = true;
255         wBlock.lastByte = _lastByte;
256         wBlock.rate = rates[_lastByte % 16];
257 
258         //JP
259         if (_lastByte == 153) {
260             wBlock.jp = true;
261 
262             if (JPBlocks.length > 0) {
263                 wBlock.value = allTicketsForBlock[_blockNum-1].sub(allTicketsForBlock[JPBlocks[JPBlocks.length-1]-1]);
264             } else {
265                 wBlock.value = allTicketsForBlock[_blockNum-1];
266             }
267 
268             JPBlocks.push(_blockNum);
269         }
270 
271         emit WinBlockAdded(_blockNum);
272     }
273 
274 
275     function getPrize(uint _blockNum) public {
276         Ticket storage t = tickets[msg.sender][_blockNum-1];
277         require(t.value > 0);
278         require(!t.executed);
279 
280         if (!winBlocks[_blockNum].exists) {
281             addWinBlock(_blockNum);
282         }
283 
284         require(winBlocks[_blockNum].exists);
285 
286         uint winValue = 0;
287 
288         if (winBlocks[_blockNum].jp) {
289             winValue = getJPValue(_blockNum,t.value);
290         } else {
291             winValue = t.value.mul(winBlocks[_blockNum].rate).div(10);
292         }
293 
294 
295         require(address(this).balance >= winValue);
296 
297         t.executed = true;
298         msg.sender.transfer(winValue);
299         emit SendPrize(msg.sender, _blockNum, winValue);
300     }
301 
302 
303     function minJackpotValue(uint _blockNum) public view returns (uint){
304         uint value = 0;
305         if (JPBlocks.length > 0) {
306             value = allTicketsForBlock[_blockNum].sub(allTicketsForBlock[JPBlocks[JPBlocks.length-1]-1]);
307         } else {
308             value = allTicketsForBlock[_blockNum];
309         }
310 
311         return _calcJP(minWei, minWei, value);
312     }
313 
314 
315     function jackpotValue(uint _blockNum, uint _ticketPrice) public view returns (uint){
316         uint value = 0;
317         if (JPBlocks.length > 0) {
318             value = allTicketsForBlock[_blockNum].sub(allTicketsForBlock[JPBlocks[JPBlocks.length-1]-1]);
319         } else {
320             value = allTicketsForBlock[_blockNum];
321         }
322 
323         return _calcJP(_ticketPrice, _ticketPrice, value);
324     }
325 
326 
327     function getJPValue(uint _blockNum, uint _ticketPrice) internal view returns (uint) {
328         return _calcJP(_ticketPrice, blocks[_blockNum-1], winBlocks[_blockNum].value);
329     }
330 
331 
332     function _calcJP(uint _ticketPrice, uint _varB, uint _varX) internal view returns (uint) {
333         uint varA = _ticketPrice;
334         uint varB = _varB; //blocks[blockNum-1]
335         uint varX = _varX; //winBlocks[blockNum].value
336 
337         uint varL = varA.mul(1000).div(divider).div(1000000000000000000);
338         uint minjp = minWei.mul(25);
339         varL = varL.mul(minjp);
340 
341         uint varR = varA.mul(10000).div(varB);
342         uint varX1 = varX.mul(1023);
343         varR = varR.mul(varX1).div(100000000);
344 
345         return varL.add(varR);
346     }
347 
348 
349     function changeTicketWeiLimit(uint _minWei, uint _maxWei, uint _divider) onlyManager public {
350         minWei = _minWei;
351         maxWei = _maxWei;
352         divider = _divider;
353         emit NewPrice(minWei,maxWei);
354     }
355 
356 
357     function changeWeiPerBlock(uint _value) onlyManager public {
358         maxWeiPerBlock = _value;
359         emit NewWeiPerBlock(maxWeiPerBlock);
360     }
361 
362 
363     function returnDeposit() onlyManager public {
364         require(address(this).balance >= depositWeis);
365         uint deposit = depositWeis;
366         depositWeis = 0;
367         wallet.transfer(deposit);
368     }
369 
370 
371     function transferEthersToDividendManager() public {
372         require(now >= lastPayout.add(7 days) );
373         require(address(this).balance >= ownersWeis);
374         require(ownersWeis > 0);
375         lastPayout = now;
376         uint dividends = ownersWeis;
377         ownersWeis = 0;
378 
379         wallet.transfer(valueFromPercent(dividends,15000));
380 
381         DividendManagerInterface dividendManager = DividendManagerInterface(dividendManagerAddress);
382         dividendManager.depositDividend.value(valueFromPercent(dividends,85000))();
383 
384         emit FundsTransferred(dividendManagerAddress, dividends);
385     }
386 
387 
388     function addEth() public payable {
389         depositWeis = depositWeis.add(msg.value);
390     }
391 
392 
393     function fromHexChar(uint8 _c) internal pure returns (uint8) {
394         return _c - (_c < 58 ? 48 : (_c < 97 ? 55 : 87));
395     }
396 
397 
398     function getByte(bytes res) internal pure returns (uint8) {
399         return fromHexChar(uint8(res[62])) << 4 | fromHexChar(uint8(res[63]));
400     }
401 
402 
403     function withdrawRefsPercent() external {
404         require(refs[msg.sender] > 0);
405         require(address(this).balance >= refs[msg.sender]);
406         uint val = refs[msg.sender];
407         refs[msg.sender] = 0;
408         msg.sender.transfer(val);
409     }
410 
411 
412     function valueFromPercent(uint _value, uint _percent) internal pure returns(uint quotient) {
413         uint _quotient = _value.mul(_percent).div(100000);
414         return ( _quotient);
415     }
416 
417     /// @notice This method can be used by the owner to extract mistakenly
418     ///  sent tokens to this contract.
419     /// @param _token The address of the token contract that you want to recover
420     ///  set to 0 in case you want to extract ether.
421     function claimTokens(address _token) onlyManager external {
422         ERC20 token = ERC20(_token);
423         uint balance = token.balanceOf(this);
424         token.transfer(owner, balance);
425     }
426 }