1 pragma solidity 0.5.9;
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
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     address payable public owner;
38     address public dividendManagerAddress;
39     address payable public devWallet;
40     address payable public ownerWallet1;
41     address payable public ownerWallet2;
42     address payable public ownerWallet3;
43 
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49 
50     constructor() public {
51         owner = msg.sender;
52         devWallet = msg.sender;
53         ownerWallet1 = 0x9a965e5e9c3A0F062C80a7f3d1B0972201b2F19f;
54         ownerWallet2 = 0x9e8eA15006CfF425dEa3BC3874a78faba32F7C48;
55         ownerWallet3 = 0xef1069A39219C35db16c41D7470F76B065c24064;
56         dividendManagerAddress = 0x7FE18FA204e0920daa53A5F3014Fdc441b6aBbA4;
57     }
58 
59 
60     function setOwnerWallet(address payable _wallet1, address payable _wallet2, address payable _wallet3) onlyOwner public {
61         require(_wallet1 != address(0) );
62         require(_wallet2 != address(0) );
63         require(_wallet3 != address(0) );
64         ownerWallet1 = _wallet1;
65         ownerWallet2 = _wallet2;
66         ownerWallet3 = _wallet3;
67     }
68 
69 
70     function setDividendManager(address _dividendManagerAddress) onlyOwner external  {
71         require(_dividendManagerAddress != address(0));
72         dividendManagerAddress = _dividendManagerAddress;
73     }
74 
75 }
76 
77 
78 contract ERC20 {
79     function allowance(address owner, address spender) public view returns (uint256);
80     function transferFrom(address from, address to, uint256 value) public returns (bool);
81     function totalSupply() public view returns (uint256);
82     function balanceOf(address who) public view returns (uint256);
83     function transfer(address to, uint256 value) public returns (bool);
84     function ownerTransfer(address to, uint256 value) public returns (bool);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     function approve(address spender, uint256 value) public returns (bool);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 contract DividendManagerInterface {
93     function depositDividend() external payable;
94 }
95 
96 
97 contract EtherWin is EtherWinAccessControl {
98     using SafeMath for uint256;
99 
100     event NewTicket(address indexed owner, uint indexed blockNum, address indexed referrer, uint value);
101     event NewPrice(uint minWei,uint maxWei);
102     event NewWeiPerBlock(uint newWeiPerBlock);
103     event SendPrize(address indexed owner, uint indexed blockNum, uint value);
104     event FundsTransferred(address dividendManager, uint value);
105     event WinBlockAdded(uint indexed blockNum);
106 
107     uint public minWei = 5000000000000000;
108     uint public maxWei = 50000000000000000;
109     uint public maxWeiPerBlock = 500000000000000000;
110     uint public ownersWeis;  // reserved weis for owners
111     uint public depositWeis;  // reserved weis for return deposit
112     uint public prizePercent = 91875;
113     uint public ownersPercent = 8125;
114     uint public refPercent = 1000;
115 
116 
117     struct Ticket {
118         uint value;
119         bool executed;
120     }
121 
122     struct WinBlock {
123         bool exists;
124         uint8 lastByte;
125         uint8 rate;
126         bool jp;
127         uint value;
128     }
129 
130     mapping (address => mapping (uint => Ticket)) public tickets; // user addr -> block number -> ticket
131 
132     mapping (uint => uint) public blocks; //blicknum -> weis in block
133     mapping (uint8 => uint8) rates;
134 
135     mapping (uint => WinBlock) public winBlocks;
136 
137     uint public allTicketsPrice;
138     mapping (uint => uint) public allTicketsForBlock; //block num -> allTicketsPrice needs for JP
139     uint[] public JPBlocks;
140     mapping (address => uint) public refs;
141     mapping (address => address) public userRefs;
142 
143 
144     uint divider = 5;
145     uint public lastPayout;
146 
147 
148     constructor() public {
149         rates[10] = 15; //a
150         rates[11] = 15; //b
151         rates[12] = 15; //c
152 
153         rates[13] = 20; //d
154         rates[14] = 20; //e
155 
156         rates[15] = 30; //f
157 
158         rates[153] = 99; //99
159     }
160 
161 
162     function () external payable {
163         play(address(0));
164     }
165 
166 
167     function play(address _ref) public payable {
168         Ticket storage t = tickets[msg.sender][block.number];
169 
170         require(t.value.add(msg.value) >= minWei && t.value.add(msg.value) <= maxWei);
171         require(blocks[block.number].add(msg.value) <= maxWeiPerBlock);
172 
173         t.value = t.value.add(msg.value);
174 
175         blocks[block.number] = blocks[block.number].add(msg.value);
176 
177         if (_ref != address(0) && _ref != msg.sender) {
178             userRefs[msg.sender] = _ref;
179         }
180 
181         //need for JP
182         allTicketsPrice = allTicketsPrice.add(msg.value);
183         allTicketsForBlock[block.number] = allTicketsPrice;
184 
185         if (userRefs[msg.sender] != address(0)) {
186             refs[_ref] = refs[_ref].add(valueFromPercent(msg.value, refPercent));
187             ownersWeis = ownersWeis.add(valueFromPercent(msg.value, ownersPercent.sub(refPercent)));
188         } else {
189             ownersWeis = ownersWeis.add(valueFromPercent(msg.value,ownersPercent));
190         }
191 
192         emit NewTicket(msg.sender, block.number, _ref, t.value);
193     }
194 
195 
196     function addWinBlock(uint _blockNum) public  {
197         require( (_blockNum.add(6) < block.number) && (_blockNum > block.number - 256) );
198         require(!winBlocks[_blockNum].exists);
199         require(blocks[_blockNum-1] > 0);
200 
201         bytes32 bhash = blockhash(_blockNum);
202         uint8 lastByte = uint8(bhash[31]);
203 
204         require( ((rates[lastByte % 16]) > 0) || (rates[lastByte] > 0) );
205 
206         _addWinBlock(_blockNum, lastByte);
207     }
208 
209 
210     function _addWinBlock(uint _blockNum, uint8 _lastByte) internal {
211         WinBlock storage wBlock = winBlocks[_blockNum];
212         wBlock.exists = true;
213         wBlock.lastByte = _lastByte;
214         wBlock.rate = rates[_lastByte % 16];
215 
216         //JP
217         if (_lastByte == 153) {
218             wBlock.jp = true;
219 
220             if (JPBlocks.length > 0) {
221                 wBlock.value = allTicketsForBlock[_blockNum-1].sub(allTicketsForBlock[JPBlocks[JPBlocks.length-1]-1]);
222             } else {
223                 wBlock.value = allTicketsForBlock[_blockNum-1];
224             }
225 
226             JPBlocks.push(_blockNum);
227         }
228 
229         emit WinBlockAdded(_blockNum);
230     }
231 
232 
233     function getPrize(uint _blockNum) public {
234         Ticket storage t = tickets[msg.sender][_blockNum-1];
235         require(t.value > 0);
236         require(!t.executed);
237 
238         if (!winBlocks[_blockNum].exists) {
239             addWinBlock(_blockNum);
240         }
241 
242         require(winBlocks[_blockNum].exists);
243 
244         uint winValue = 0;
245 
246         if (winBlocks[_blockNum].jp) {
247             winValue = getJPValue(_blockNum,t.value);
248         } else {
249             winValue = t.value.mul(winBlocks[_blockNum].rate).div(10);
250         }
251 
252 
253         require(address(this).balance >= winValue);
254 
255         t.executed = true;
256         msg.sender.transfer(winValue);
257         emit SendPrize(msg.sender, _blockNum, winValue);
258     }
259 
260 
261     function minJackpotValue(uint _blockNum) public view returns (uint){
262         uint value = 0;
263         if (JPBlocks.length > 0) {
264             value = allTicketsForBlock[_blockNum].sub(allTicketsForBlock[JPBlocks[JPBlocks.length-1]-1]);
265         } else {
266             value = allTicketsForBlock[_blockNum];
267         }
268 
269         return _calcJP(minWei, minWei, value);
270     }
271 
272 
273     function jackpotValue(uint _blockNum, uint _ticketPrice) public view returns (uint){
274         uint value = 0;
275         if (JPBlocks.length > 0) {
276             value = allTicketsForBlock[_blockNum].sub(allTicketsForBlock[JPBlocks[JPBlocks.length-1]-1]);
277         } else {
278             value = allTicketsForBlock[_blockNum];
279         }
280 
281         return _calcJP(_ticketPrice, _ticketPrice, value);
282     }
283 
284 
285     function getJPValue(uint _blockNum, uint _ticketPrice) internal view returns (uint) {
286         return _calcJP(_ticketPrice, blocks[_blockNum-1], winBlocks[_blockNum].value);
287     }
288 
289 
290     function _calcJP(uint _ticketPrice, uint _varB, uint _varX) internal view returns (uint) {
291         uint varA = _ticketPrice;
292         uint varB = _varB; //blocks[blockNum-1]
293         uint varX = _varX; //winBlocks[blockNum].value
294 
295         uint varL = varA.mul(1000).div(divider).div(1000000000000000000);
296         uint minjp = minWei.mul(25);
297         varL = varL.mul(minjp);
298 
299         uint varR = varA.mul(10000).div(varB);
300         uint varX1 = varX.mul(1023);
301         varR = varR.mul(varX1).div(100000000);
302 
303         return varL.add(varR);
304     }
305 
306 
307     function changeTicketWeiLimit(uint _minWei, uint _maxWei, uint _divider) onlyOwner public {
308         minWei = _minWei;
309         maxWei = _maxWei;
310         divider = _divider;
311         emit NewPrice(minWei,maxWei);
312     }
313 
314 
315     function changeWeiPerBlock(uint _value) onlyOwner public {
316         maxWeiPerBlock = _value;
317         emit NewWeiPerBlock(maxWeiPerBlock);
318     }
319 
320 
321     function returnDeposit() onlyOwner public {
322         require(address(this).balance >= depositWeis);
323         uint deposit = depositWeis;
324         depositWeis = 0;
325         owner.transfer(deposit);
326     }
327 
328 
329     function transferEthersToDividendManager() public {
330         require(now >= lastPayout.add(7 days) );
331         require(address(this).balance >= ownersWeis);
332         require(ownersWeis > 0);
333         lastPayout = now;
334         uint dividends = ownersWeis;
335         ownersWeis = 0;
336 
337         devWallet.transfer(valueFromPercent(dividends,15000));
338         ownerWallet1.transfer(valueFromPercent(dividends,5000));
339         ownerWallet2.transfer(valueFromPercent(dividends,30000));
340         ownerWallet3.transfer(valueFromPercent(dividends,35000));
341 
342         DividendManagerInterface dividendManager = DividendManagerInterface(dividendManagerAddress);
343         dividendManager.depositDividend.value(valueFromPercent(dividends,15000))();
344 
345         emit FundsTransferred(dividendManagerAddress, dividends);
346     }
347 
348 
349     function addEth() public payable {
350         depositWeis = depositWeis.add(msg.value);
351     }
352 
353 
354     function fromHexChar(uint8 _c) internal pure returns (uint8) {
355         return _c - (_c < 58 ? 48 : (_c < 97 ? 55 : 87));
356     }
357 
358 
359     function getByte(bytes memory res) internal pure returns (uint8) {
360         return fromHexChar(uint8(res[62])) << 4 | fromHexChar(uint8(res[63]));
361     }
362 
363 
364     function withdrawRefsPercent() external {
365         require(refs[msg.sender] > 0);
366         require(address(this).balance >= refs[msg.sender]);
367         uint val = refs[msg.sender];
368         refs[msg.sender] = 0;
369         msg.sender.transfer(val);
370     }
371 
372 
373     function valueFromPercent(uint _value, uint _percent) internal pure returns(uint quotient) {
374         uint _quotient = _value.mul(_percent).div(100000);
375         return ( _quotient);
376     }
377 
378     /// @notice This method can be used by the owner to extract mistakenly
379     ///  sent tokens to this contract.
380     /// @param _token The address of the token contract that you want to recover
381     ///  set to 0 in case you want to extract ether.
382     function claimTokens(address _token) onlyOwner external {
383         ERC20 token = ERC20(_token);
384         uint balance = token.balanceOf(address(this));
385         token.transfer(owner, balance);
386     }
387 }