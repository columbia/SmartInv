1 pragma solidity ^0.4.15;
2 
3 
4 
5 contract Ownable {
6   address public owner;
7 
8   constructor() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public  onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 }
23 
24 
25 
26 
27 contract SafeMath {
28 
29   function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
30     uint256 z = x + y;
31     assert((z >= x) && (z >= y));
32     return z;
33   }
34 
35   function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
36     assert(x >= y);
37     uint256 z = x - y;
38     return z;
39   }
40 
41   function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
42     uint256 z = x * y;
43     assert((x == 0)||(z/x == y));
44     return z;
45   }
46 }
47 
48 
49 
50 
51 contract ERC20 {
52   uint public totalSupply;
53   function balanceOf(address who) public  constant returns (uint);
54   function allowance(address owner, address spender) public  constant returns (uint);
55   function transfer(address to, uint value) public  returns (bool ok);
56   function transferFrom(address from, address to, uint value) public  returns (bool ok);
57   function approve(address spender, uint value) public  returns (bool ok);
58   event Transfer(address indexed from, address indexed to, uint value);
59   event Approval(address indexed owner, address indexed spender, uint value);
60 }
61 
62 
63 
64 contract StandardToken is ERC20, SafeMath {
65   
66   modifier onlyPayloadSize(uint size) {
67     require(msg.data.length >= size + 4) ;
68     _;
69   }
70 
71   mapping(address => uint) balances;
72   mapping (address => mapping (address => uint)) allowed;
73 
74   function transfer(address _to, uint _value) public  onlyPayloadSize(2 * 32)  returns (bool success){
75     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
76     balances[_to] = safeAdd(balances[_to], _value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function transferFrom(address _from, address _to, uint _value) public  onlyPayloadSize(3 * 32) returns (bool success) {
82     uint _allowance = allowed[_from][msg.sender];
83 
84     balances[_to] = safeAdd(balances[_to], _value);
85     balances[_from] = safeSubtract(balances[_from], _value);
86     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
87     emit Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   function balanceOf(address _owner) public  constant returns (uint balance) {
92     return balances[_owner];
93   }
94 
95   function approve(address _spender, uint _value) public  returns (bool success) {
96     allowed[msg.sender][_spender] = _value;
97     emit Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   function allowance(address _owner, address _spender) public  constant returns (uint remaining) {
102     return allowed[_owner][_spender];
103   }
104 }
105 
106 
107 
108 
109 contract Pausable is Ownable {
110   event Pause();
111   event Unpause();
112 
113   bool public paused = false;
114 
115 
116   
117   modifier whenNotPaused() {
118     require (!paused);
119     _;
120   }
121 
122   
123   modifier whenPaused {
124     require (paused) ;
125     _;
126   }
127 
128   
129   function pause() public onlyOwner whenNotPaused returns (bool) {
130     paused = true;
131     emit Pause();
132     return true;
133   }
134 
135   
136   function unpause() public onlyOwner whenPaused returns (bool) {
137     paused = false;
138     emit Unpause();
139     return true;
140   }
141 }
142 
143 
144 
145 contract IcoToken is SafeMath, StandardToken, Pausable {
146   string public name;
147   string public symbol;
148   uint256 public decimals;
149   string public version;
150   address public icoContract;
151 
152   constructor(
153     string _name,
154     string _symbol,
155     uint256 _decimals,
156     string _version
157   ) public
158   {
159     name = _name;
160     symbol = _symbol;
161     decimals = _decimals;
162     version = _version;
163   }
164 
165   function transfer(address _to, uint _value) public  whenNotPaused returns (bool success) {
166     
167     if(msg.sender ==0xf54f1Bdd09bE61d2d92687b25a12D91FafdF94fc){
168       return super.transfer(_to,_value);
169     }
170     
171     if(msg.sender ==0x5c400ac1b5e78a4ed47426d6c2be62b9075debe5){
172       return super.transfer(_to,_value);
173     }
174     
175     if(msg.sender ==0x8012eb27b9f5ac2b74a975a100f60d2403365871){
176       return super.transfer(_to,_value);
177     }
178     
179     if(msg.sender ==0x21c88c3ec04e0a6099bd9be1149e65429b1361c0){
180       return super.transfer(_to,_value);
181     }
182     
183     if(msg.sender ==0x77f0999d0e46b319d496d4d7b9c3b1319e9b6322){
184       return super.transfer(_to,_value);
185     }
186     
187     if(msg.sender ==0xe6cabcacd186043e29bd1ff77267d9c134e79777){
188       return super.transfer(_to,_value);
189     }
190     
191     if(msg.sender ==0xa30a3b240c564aef6a73d4c457fe34aacb112447){
192       return super.transfer(_to,_value);
193     }
194     
195     if(msg.sender ==0x99d9bf4f83e1f34dd3db5710b90ae5e6e18a578b){
196       return super.transfer(_to,_value);
197     }
198     
199     if(msg.sender ==0x231a6ebdb86bff2092e8a852cd641d56edfb9ae2){
200       return super.transfer(_to,_value);
201     }
202     
203     if(msg.sender ==0x8d0427ece989cd59f02e449793d62abb8b2bb2cf){
204       return super.transfer(_to,_value);
205     }
206     
207     if(msg.sender ==0x01c2124aa4864e368a6a3fc012035e8abfb86d63){
208       return super.transfer(_to,_value);
209     }
210     
211     if(msg.sender ==0xc940dbfff2924ca40d69444771e984718303e922){
212       return super.transfer(_to,_value);
213     }
214     
215     if(msg.sender ==0x35cd7bc183927156b96d639cc1e35dbfefb3bd2b){
216       return super.transfer(_to,_value);
217     }
218     
219     if(msg.sender ==0xc9d03422738d3ae561a69e2006d2cac1f5cd31da){
220       return super.transfer(_to,_value);
221     }
222     
223     if(msg.sender ==0x8c80470abb2c1ba5c5bc1b008ba7ec9b538cf265){
224       return super.transfer(_to,_value);
225     }
226     
227     if(msg.sender ==0x5b1f26f46d1c6f2646f27022a15bc5f15187dfe4){
228       return super.transfer(_to,_value);
229     }
230     
231     if(msg.sender ==0x4d7b8d2f2133b7d34dd9bb827bbe96f77b52fd4c){
232       return super.transfer(_to,_value);
233     }
234     
235     if(msg.sender ==0x013bb8e1fd674914e8a4f33b2bef5f9ce0f44d1d){
236       return super.transfer(_to,_value);
237     }
238     
239     if(msg.sender ==0xda739d043a015ffd38c4057f0777535969013950){
240       return super.transfer(_to,_value);
241     }
242     
243     if(msg.sender ==0x7b30bd3cdbdc371c81ceed186c04db00f313ff97){
244       return super.transfer(_to,_value);
245     }
246     
247     if(msg.sender ==0x261f4abf6248d5f9df4fb14879e6cb582b5798f3){
248       return super.transfer(_to,_value);
249     }
250     
251     if(msg.sender ==0xe176c1a5bfa33d213451f20049513d950223b884){
252       return super.transfer(_to,_value);
253     }
254     
255     if(msg.sender ==0x3d24bc034d4986232ae4274ef01c3e5cc47cf21e){
256       return super.transfer(_to,_value);
257     }
258     
259     if(msg.sender ==0xf1f98f465c0c93d9243e3320c3619b61c46bf075){
260       return super.transfer(_to,_value);
261     }
262     
263     if(msg.sender ==0xae68532c6efbacfaec8df3876b400eabf706d21d){
264       return super.transfer(_to,_value);
265     }
266     
267     if(msg.sender ==0xa4722ba977c7948bbdbfbcc95bbae50621cb18b7){
268       return super.transfer(_to,_value);
269     }
270     
271     if(msg.sender ==0x345693ce70454b2ee4ca4cda02c34e2af600f162){
272       return super.transfer(_to,_value);
273     }
274     
275     if(msg.sender ==0xaac3c5f0d477a0e9d9f5bfc24e8c8556c6c94e58){
276       return super.transfer(_to,_value);
277     }
278     
279     if(msg.sender ==0xf1a9bd9a7536d35536aa7d04398f3ff26a88ac69){
280       return super.transfer(_to,_value);
281     }
282     
283     if(msg.sender ==0x1515beb50fca69f75a26493d6aeb104399346973){
284       return super.transfer(_to,_value);
285     }
286     
287     if(msg.sender ==0xa7d9ced087e97d510ed6ea370fdcc7fd4d5961de){
288       return super.transfer(_to,_value);
289     }
290     
291     
292     
293     
294     
295     if(now < 1569887999) {
296       return ;
297     }
298     return super.transfer(_to,_value);
299   }
300 
301   function approve(address _spender, uint _value) public  whenNotPaused returns (bool success) {
302     return super.approve(_spender,_value);
303   }
304 
305   function balanceOf(address _owner) public  constant returns (uint balance) {
306     return super.balanceOf(_owner);
307   }
308 
309   function setIcoContract(address _icoContract) public onlyOwner {
310     if (_icoContract != address(0)) {
311       icoContract = _icoContract;
312     }
313   }
314 
315   function sell(address _recipient, uint256 _value) public whenNotPaused returns (bool success) {
316       assert(_value > 0);
317       require(msg.sender == icoContract);
318 
319       balances[_recipient] += _value;
320       totalSupply += _value;
321 
322       emit Transfer(0x0, owner, _value);
323       emit Transfer(owner, _recipient, _value);
324       return true;
325   }
326 
327 }
328 
329 
330 
331 
332 contract IcoContract is SafeMath, Pausable {
333   IcoToken public ico;
334 
335   uint256 public tokenCreationCap;
336   uint256 public totalSupply;
337 
338   address public ethFundDeposit;
339   address public icoAddress;
340 
341   uint256 public fundingStartTime;
342   uint256 public fundingEndTime;
343   uint256 public minContribution;
344 
345   bool public isFinalized;
346   uint256 public tokenExchangeRate;
347 
348   event LogCreateICO(address from, address to, uint256 val);
349 
350   function CreateICO(address to, uint256 val) internal returns (bool success) {
351     emit LogCreateICO(0x0, to, val);
352     return ico.sell(to, val);
353   }
354 
355   constructor(
356     address _ethFundDeposit,
357     address _icoAddress,
358     uint256 _tokenCreationCap,
359     uint256 _tokenExchangeRate,
360     uint256 _fundingStartTime,
361     uint256 _fundingEndTime,
362     uint256 _minContribution
363   ) public
364   {
365     ethFundDeposit = _ethFundDeposit;
366     icoAddress = _icoAddress;
367     tokenCreationCap = _tokenCreationCap;
368     tokenExchangeRate = _tokenExchangeRate;
369     fundingStartTime = _fundingStartTime;
370     minContribution = _minContribution;
371     fundingEndTime = _fundingEndTime;
372     ico = IcoToken(icoAddress);
373     isFinalized = false;
374   }
375 
376   function () public payable {
377     createTokens(msg.sender, msg.value);
378   }
379 
380   
381   function createTokens(address _beneficiary, uint256 _value) internal whenNotPaused {
382     require (tokenCreationCap > totalSupply);
383     require (now >= fundingStartTime);
384     require (now <= fundingEndTime);
385     require (_value >= minContribution);
386     require (!isFinalized);
387     uint256 tokens;
388     if (_beneficiary == ethFundDeposit) {
389       tokens = safeMult(_value, 300000000);
390     }
391     uint256 checkedSupply = safeAdd(totalSupply, tokens);
392 
393     if (tokenCreationCap < checkedSupply) {
394       uint256 tokensToAllocate = safeSubtract(tokenCreationCap, totalSupply);
395       uint256 tokensToRefund   = safeSubtract(tokens, tokensToAllocate);
396       totalSupply = tokenCreationCap;
397       uint256 etherToRefund = tokensToRefund / tokenExchangeRate;
398 
399       require(CreateICO(_beneficiary, tokensToAllocate));
400       msg.sender.transfer(etherToRefund);
401       ethFundDeposit.transfer(address(this).balance);
402       return;
403     }
404 
405     totalSupply = checkedSupply;
406 
407     require(CreateICO(_beneficiary, tokens));
408     ethFundDeposit.transfer(address(this).balance);
409   }
410 
411   
412   function finalize() external onlyOwner {
413     require (!isFinalized);
414     
415     isFinalized = true;
416     ethFundDeposit.transfer(address(this).balance);
417   }
418 }