1 pragma solidity ^0.4.24;
2 interface Interfacemc {
3   
4   function balanceOf(address who) external view returns (uint256);
5   
6   function allowance(address owner, address spender)
7     external view returns (uint256);
8 
9   function transfer(address to, uint256 value) external returns (bool);
10   
11   function approve(address spender, uint256 value)
12     external returns (bool);
13 
14   function transferFrom(address from, address to, uint256 value)
15     external returns (bool);
16   
17   event Transfer(
18     address indexed from,
19     address indexed to,
20     uint256 value
21   );
22   
23   event Approval(
24     address indexed owner,
25     address indexed spender,
26     uint256 value
27   );
28   
29 }
30 
31 library SafeMath {
32 
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) {
35             return 0;
36         }
37         uint256 c = a * b;
38         require(c / a == b);
39         return c;
40     }
41 
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b > 0);
44         uint256 c = a / b;
45         return c;
46     }
47 
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b <= a);
51         uint256 c = a - b;
52 
53         return c;
54     }
55 
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a);
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 contract Mundicoin is Interfacemc{
70     using SafeMath for uint256;
71     uint256 constant private MAX_UINT256 = 2**256 - 1;
72     mapping (address => uint256) private _balances;
73     mapping (address => mapping (address => uint256)) private _allowed;
74     uint256 public totalSupply;
75     string public name = "Mundicoin"; 
76     uint8 public decimals = 8; 
77     string public symbol = "MC";
78     address private _owner;
79     
80     mapping (address => bool) public _notransferible;
81     mapping (address => bool) private _administradores; 
82     
83     constructor() public{
84         _owner = msg.sender;
85         _balances[_owner] = totalSupply;
86         totalSupply = 10000000000000000;
87         _administradores[_owner] = true;
88     }
89 
90     function isAdmin(address dir) public view returns(bool){
91         return _administradores[dir];
92     }
93     
94     modifier OnlyOwner(){
95         require(msg.sender == _owner, "Not an admin");
96         _;
97     }
98 
99     function balanceOf(address owner) public view returns (uint256) {
100         return _balances[owner];
101     }
102     
103     function allowance(
104         address owner,
105         address spender
106     )
107       public
108       view
109       returns (uint256)
110     {
111         return _allowed[owner][spender];
112     }
113 
114     function transfer(address to, uint256 value) public returns (bool) {
115         _transfer(msg.sender, to, value);
116         return true;
117     }
118 
119     function _transfer(address from, address to, uint256 value) internal {
120         require(!_notransferible[from], "No authorized ejecutor");
121         require(value <= _balances[from], "Not enough balance");
122         require(to != address(0), "Invalid account");
123 
124         _balances[from] = _balances[from].sub(value);
125         _balances[to] = _balances[to].add(value);
126         emit Transfer(from, to, value);
127     }
128     
129     function approve(address spender, uint256 value) public returns (bool) {
130         require(spender != address(0), "Invalid account");
131 
132         _allowed[msg.sender][spender] = value;
133         emit Approval(msg.sender, spender, value);
134         return true;
135     }
136 
137     function transferFrom(
138         address from,
139         address to,
140         uint256 value
141     )
142       public
143       returns (bool)
144     {   
145         require(value <= _allowed[from][msg.sender], "Not enough approved ammount");
146         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
147         _transfer(from, to, value);
148         return true;
149     }
150     
151     function increaseAllowance(
152         address spender,
153         uint256 addedValue
154     )
155       public
156       returns (bool)
157     {
158         require(spender != address(0), "Invalid account");
159 
160         _allowed[msg.sender][spender] = (
161         _allowed[msg.sender][spender].add(addedValue));
162         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
163         return true;
164     }
165 
166     function decreaseAllowance(
167         address spender,
168         uint256 subtractedValue
169     )
170       public
171       returns (bool)
172     {
173         require(spender != address(0), "Invalid account");
174 
175         _allowed[msg.sender][spender] = (
176         _allowed[msg.sender][spender].sub(subtractedValue));
177         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178         return true;
179     }
180 
181     function _burn(address account, uint256 value) internal {
182         require(account != 0, "Invalid account");
183         require(value <= _balances[account], "Not enough balance");
184 
185         totalSupply = totalSupply.sub(value);
186         _balances[account] = _balances[account].sub(value);
187         emit Transfer(account, address(0), value);
188     }
189 
190     function _burnFrom(address account, uint256 value) internal {
191         require(value <= _allowed[account][msg.sender], "No enough approved ammount");
192         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
193         _burn(account, value);
194     }
195 
196     function setTransferible(address admin, address sujeto, bool state) public returns (bool) {
197         require(_administradores[admin], "Not an admin");
198         _notransferible[sujeto] = state;
199         return true;
200     }
201 
202     function setNewAdmin(address admin)public OnlyOwner returns(bool){
203         _administradores[admin] = true;
204         return true;
205     }  
206 
207 }
208 
209 library SafeMundicoin {
210 
211     using SafeMath for uint256;
212 
213     function safeSetTransferible(
214         Mundicoin token,
215         address authorizer,
216         address to,
217         bool state
218     )
219         internal
220     {
221         require(token.setTransferible(authorizer, to, state));
222     }
223 
224     function safeTransfer(
225         Mundicoin token,
226         address to,
227         uint256 value
228     )
229         internal
230     {
231         require(token.transfer(to, value));
232     }
233 
234     function safeTransferFrom(
235         Mundicoin token,
236         address from,
237         address to,
238         uint256 value
239     )
240         internal
241     {
242         require(token.transferFrom(from, to, value));
243     }
244 
245     function safeApprove(
246         Mundicoin token,
247         address spender,
248         uint256 value
249     )
250         internal
251     {
252         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
253         require(token.approve(spender, value));
254     }
255 
256     function safeIncreaseAllowance(
257         Mundicoin token,
258         address spender,
259         uint256 value
260     )
261         internal
262     {
263         uint256 newAllowance = token.allowance(address(this), spender).add(value);
264         require(token.approve(spender, newAllowance));
265     }
266 
267     function safeDecreaseAllowance(
268         Mundicoin token,
269         address spender,
270         uint256 value
271     )
272         internal
273     {
274         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
275         require(token.approve(spender, newAllowance));
276     }
277 }
278 
279 pragma solidity ^0.4.24;
280 contract ReentradaProteccion {
281 
282     uint256 private _guardCounter;
283     constructor() public {
284         // Inicia en 1 para ahorrar gas
285         _guardCounter = 1;
286     }
287 
288     modifier nonReentrant() {
289         _guardCounter += 1;
290         uint256 localCounter = _guardCounter;
291         _;
292         require(localCounter == _guardCounter, "No double");
293     }
294 
295 }
296 
297 contract Venta is ReentradaProteccion{
298     using SafeMath for uint256;
299     mapping(address => uint256) private _contributions;
300     mapping(uint => address[]) private _contributors;
301     uint128 public _campaign;
302     bool private _state;
303     address private _custodian;
304     address private _owner;
305     uint256 private _rate;
306     uint256 private _weiRaised;
307     using SafeMundicoin for Mundicoin;
308     Mundicoin private _token;
309     
310     event TokensPurchased(
311       address indexed purchaser,
312       address indexed beneficiary,
313       uint256 value,
314       uint256 amount
315     );
316     
317     constructor(Mundicoin token) public {
318         require(token != address(0),"Invalid address");
319         _token = token;
320         _owner = msg.sender;
321     }
322 
323     modifier OnlyOwner(){
324         require(msg.sender == _owner, "Not an admin");
325         _;
326     }
327     
328     function setCampaign(uint256 rate, uint128 campaign, bool state) public OnlyOwner returns(bool){
329         require(rate > 0, "Invalid rate");
330         _rate = rate;
331         _campaign = campaign;
332         _state = state;
333         return true;
334     }
335 
336     function getRate() public view returns(uint256){
337         return _rate;
338     }
339     
340     function updateCustodian(address custodian) public OnlyOwner returns(bool) {
341         require(custodian != address(0), "invalid address");
342         _custodian = custodian;
343         return true;
344     }
345     
346     function getCustodian()public view OnlyOwner returns(address){
347         return _custodian;
348     }
349     
350     function getOwner()public view returns(address){
351         return _owner;
352     }
353 
354     
355     function () external payable {
356         buyTokens(msg.sender);
357     }
358     
359     function buyTokens(address beneficiary) public nonReentrant payable {
360         uint256 weiAmount = msg.value;
361         _preValidatePurchase(beneficiary, weiAmount);
362         _weiRaised = _weiRaised.add(weiAmount);
363         uint256 tokens = _getTokenAmount(weiAmount);
364         _processPurchase(beneficiary, tokens);
365         emit TokensPurchased(
366             msg.sender,
367             beneficiary,
368             weiAmount,
369             tokens
370         );
371         _updatePurchasingState(this, beneficiary, weiAmount);
372         _forwardFunds();
373 
374     }
375    
376     function _preValidatePurchase(
377         address beneficiary,
378         uint256 weiAmount
379     )
380       internal
381       pure
382     {
383         require(beneficiary != address(0), "Invalid address");
384         require(weiAmount != 0, "Invalid ammount");
385     }
386 
387     function _deliverTokens(
388         address beneficiary,
389         uint256 tokenAmount
390     )
391       internal
392     {  
393         _token.safeTransfer(beneficiary, tokenAmount);
394     }
395 
396     function _processPurchase(
397         address beneficiary,
398         uint256 tokenAmount
399     )
400       internal
401     {
402         _deliverTokens(beneficiary, tokenAmount);
403     }
404 
405     function _updatePurchasingState(
406         address ejecutor,
407         address beneficiary,
408         uint256 weiAmount
409     )
410       internal
411     {
412         _contributions[beneficiary] = _contributions[beneficiary].add(
413         weiAmount);
414         _contributors[_campaign].push(beneficiary);
415         _token.safeSetTransferible(ejecutor, beneficiary, _state);
416     }
417 
418     function _getTokenAmount(uint256 weiAmount)
419       internal view returns (uint256)
420     {
421         return weiAmount.div(_rate);
422     }
423 
424     function _forwardFunds() internal {
425         _custodian.transfer(msg.value);
426     }
427 
428     function getContribution(address beneficiary)
429         public view returns (uint256)
430     {
431         return _contributions[beneficiary];
432     }
433 
434     function freedom(bool state, uint campaign) 
435         public OnlyOwner returns(bool)
436     {
437         address[] memory array = _contributors[campaign];
438         uint256 n = array.length;
439 
440         for(uint256 i = 0; i < n; i++ ){
441             _token.safeSetTransferible(this, array[i], state);
442         }
443         return true;
444     }
445 }