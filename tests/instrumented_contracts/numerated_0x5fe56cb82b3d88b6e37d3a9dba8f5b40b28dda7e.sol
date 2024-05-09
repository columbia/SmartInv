1 pragma solidity ^0.4.19;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract OwnedInterface {
33     function getOwner() public view returns(address);
34     function changeOwner(address) public returns (bool);
35 }
36 
37 contract Owned is OwnedInterface {
38     
39     address private contractOwner;
40   
41     event LogOwnerChanged(
42         address oldOwner, 
43         address newOwner);
44 
45     modifier onlyOwner {
46         require(msg.sender == contractOwner);
47         _;
48     } 
49    
50     function Owned() public {
51         contractOwner = msg.sender;
52     }
53     
54     function getOwner() public view returns(address owner) {
55         return contractOwner;
56     }
57   
58     function changeOwner(address newOwner) 
59         public 
60         onlyOwner 
61         returns(bool success) 
62     {
63         require(newOwner != 0);
64         LogOwnerChanged(contractOwner, newOwner);
65         contractOwner = newOwner;
66         return true;
67     }
68 }
69 
70 contract TimeLimitedStoppableInterface is OwnedInterface 
71 {
72   function isRunning() public view returns(bool contractRunning);
73   function setRunSwitch(bool) public returns(bool onOff);
74 }
75 
76 contract TimeLimitedStoppable is TimeLimitedStoppableInterface, Owned 
77 {
78   bool private running;
79   uint private finalBlock;
80 
81   modifier onlyIfRunning
82   {
83     require(running);
84     _;
85   }
86   
87   event LogSetRunSwitch(address sender, bool isRunning);
88   event LogSetFinalBlock(address sender, uint lastBlock);
89 
90   function TimeLimitedStoppable() public {
91     running = true;
92     finalBlock = now + 390 days;
93     LogSetRunSwitch(msg.sender, true);
94     LogSetFinalBlock(msg.sender, finalBlock);
95   }
96 
97   function isRunning() 
98     public
99     view 
100     returns(bool contractRunning) 
101   {
102     return running && now <= finalBlock;
103   }
104 
105   function getLastBlock() public view returns(uint lastBlock) {
106     return finalBlock;
107   }
108 
109   function setRunSwitch(bool onOff) 
110     public
111     onlyOwner
112     returns(bool success)
113   {
114     LogSetRunSwitch(msg.sender, onOff);
115     running = onOff;
116     return true;
117   }
118 
119   function SetFinalBlock(uint lastBlock) 
120     public 
121     onlyOwner 
122     returns(bool success) 
123   {
124     finalBlock = lastBlock;
125     LogSetFinalBlock(msg.sender, finalBlock);
126     return true;
127   }
128 
129 }
130 
131 contract Ownable {
132   address public owner;
133 
134 
135   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137   function Ownable() public {
138     owner = msg.sender;
139   }
140 
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146   function transferOwnership(address newOwner) public onlyOwner {
147     require(newOwner != address(0));
148     OwnershipTransferred(owner, newOwner);
149     owner = newOwner;
150   }
151 
152 }
153 
154 contract ERC20Basic {
155   function totalSupply() public view returns (uint256);
156   function balanceOf(address who) public view returns (uint256);
157   function transfer(address to, uint256 value) public returns (bool);
158   event Transfer(address indexed from, address indexed to, uint256 value);
159 }
160 
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender) public view returns (uint256);
163   function transferFrom(address from, address to, uint256 value) public returns (bool);
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 contract BasicToken is ERC20Basic {
169   using SafeMath for uint256;
170 
171   mapping(address => uint256) balances;
172 
173   uint256 totalSupply_;
174 
175   function totalSupply() public view returns (uint256) {
176     return totalSupply_;
177   }
178 
179   function transfer(address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[msg.sender]);
182 
183     // SafeMath.sub will throw if there is not enough balance.
184     balances[msg.sender] = balances[msg.sender].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     Transfer(msg.sender, _to, _value);
187     return true;
188   }
189 
190   function balanceOf(address _owner) public view returns (uint256 balance) {
191     return balances[_owner];
192   }
193 
194 }
195 
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208     Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   function approve(address _spender, uint256 _value) public returns (bool) {
213     allowed[msg.sender][_spender] = _value;
214     Approval(msg.sender, _spender, _value);
215     return true;
216   }
217 
218   function allowance(address _owner, address _spender) public view returns (uint256) {
219     return allowed[_owner][_spender];
220   }
221 
222   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229     uint oldValue = allowed[msg.sender][_spender];
230     if (_subtractedValue > oldValue) {
231       allowed[msg.sender][_spender] = 0;
232     } else {
233       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234     }
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239 }
240 
241 library SafeERC20 {
242   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
243     assert(token.transfer(to, value));
244   }
245 
246   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
247     assert(token.transferFrom(from, to, value));
248   }
249 
250   function safeApprove(ERC20 token, address spender, uint256 value) internal {
251     assert(token.approve(spender, value));
252   }
253 }
254 
255 contract CanReclaimToken is Ownable {
256   using SafeERC20 for ERC20Basic;
257 
258   function reclaimToken(ERC20Basic token) external onlyOwner {
259     uint256 balance = token.balanceOf(this);
260     token.safeTransfer(owner, balance);
261   }
262 
263 }
264 
265 contract CMCTInterface is ERC20 {
266   function isCMCT() public pure returns(bool isIndeed);
267 }
268 
269 contract CMCT is CMCTInterface, StandardToken, CanReclaimToken {
270   string public name = "Crowd Machine Compute Token";
271   string public symbol = "CMCT";
272   uint8  public decimals = 8;
273   uint256 public INITIAL_SUPPLY = uint(2000000000) * (10 ** uint256(decimals));
274 
275   function CMCT() public {
276     totalSupply_ = INITIAL_SUPPLY;
277     balances[msg.sender] = INITIAL_SUPPLY;
278   }
279    
280   function isCMCT() public pure returns(bool isIndeed) {
281       return true;
282   }
283 }
284 
285 contract CmctSaleInterface is TimeLimitedStoppableInterface, CanReclaimToken {
286   
287   struct FunderStruct {
288     bool registered;
289     bool approved;
290   }
291   
292   mapping(address => FunderStruct) public funderStructs;
293   
294   function isUser(address user) public view returns(bool isIndeed);
295   function isApproved(address user) public view returns(bool isIndeed);
296   function registerSelf(bytes32 uid) public returns(bool success);
297   function registerUser(address user, bytes32 uid) public returns(bool success);
298   function approveUser(address user, bytes32 uid) public returns(bool success);
299   function disapproveUser(address user, bytes32 uid) public returns(bool success);
300   function withdrawEth(uint amount, address to, bytes32 uid) public returns(bool success);
301   function relayCMCT(address receiver, uint amount, bytes32 uid) public returns(bool success);
302   function bulkRelayCMCT(address[] receivers, uint[] amounts, bytes32 uid) public returns(bool success);
303   function () public payable;
304 }
305 
306 contract CmctSale is CmctSaleInterface, TimeLimitedStoppable {
307   
308   CMCTInterface cmctToken;
309   
310   event LogSetTokenAddress(address sender, address cmctContract);
311   event LogUserRegistered(address indexed sender, address indexed user, bytes32 indexed uid);
312   event LogUserApproved(address indexed sender, address user, bytes32 indexed uid);
313   event LogUserDisapproved(address indexed sender, address user, bytes32 indexed uid);
314   event LogEthWithdrawn(address indexed sender, address indexed to, uint amount, bytes32 indexed uid);
315   event LogCMCTRelayFailed(address indexed sender, address indexed receiver, uint amount, bytes32 indexed uid);
316   event LogCMCTRelayed(address indexed sender, address indexed receiver, uint amount, bytes32 indexed uid);
317   event LogEthReceived(address indexed sender, uint amount);
318   
319   modifier onlyifInitialized {
320       require(cmctToken.isCMCT());
321       _;
322   }
323 
324   function 
325     CmctSale(address cmctContract) 
326     public 
327   {
328     require(cmctContract != 0);
329     cmctToken = CMCTInterface(cmctContract);
330     LogSetTokenAddress(msg.sender, cmctContract);
331    }
332 
333   function setTokenAddress(address cmctContract) public onlyOwner returns(bool success) {
334       require(cmctContract != 0);
335       cmctToken = CMCTInterface(cmctContract);
336       LogSetTokenAddress(msg.sender, cmctContract);
337       return true;
338   }
339 
340   function getTokenAddress() public view returns(address cmctContract) {
341     return cmctToken;
342   }
343 
344   function isUser(address user) public view returns(bool isIndeed) {
345       return funderStructs[user].registered;
346   }
347 
348   function isApproved(address user) public view returns(bool isIndeed) {
349       if(!isUser(user)) return false;
350       return(funderStructs[user].approved);
351   }
352 
353   function registerSelf(bytes32 uid) public onlyIfRunning returns(bool success) {
354       require(!isUser(msg.sender));
355       funderStructs[msg.sender].registered = true;
356       LogUserRegistered(msg.sender, msg.sender, uid);
357       return true;
358   }
359 
360   function registerUser(address user, bytes32 uid) public onlyOwner onlyIfRunning returns(bool success) {
361       require(!isUser(user));
362       funderStructs[user].registered = true;
363       LogUserRegistered(msg.sender, user, uid);
364       return true;      
365   }
366 
367   function approveUser(address user, bytes32 uid) public onlyOwner onlyIfRunning returns(bool success) {
368       require(isUser(user));
369       require(!isApproved(user));
370       funderStructs[user].approved = true;
371       LogUserApproved(msg.sender, user, uid);
372       return true;
373   }
374 
375   function disapproveUser(address user, bytes32 uid) public onlyOwner onlyIfRunning returns(bool success) {
376       require(isUser(user));
377       require(isApproved(user));
378       funderStructs[user].approved = false;
379       LogUserDisapproved(msg.sender, user, uid);
380       return true;      
381   }
382 
383   function withdrawEth(uint amount, address to, bytes32 uid) public onlyOwner returns(bool success) {
384       LogEthWithdrawn(msg.sender, to, amount, uid);
385       to.transfer(amount);
386       return true;
387   }
388 
389   function relayCMCT(address receiver, uint amount, bytes32 uid) public onlyOwner onlyIfRunning onlyifInitialized returns(bool success) {
390     if(!isApproved(receiver)) {
391       LogCMCTRelayFailed(msg.sender, receiver, amount, uid);
392       return false;
393     } else {
394       LogCMCTRelayed(msg.sender, receiver, amount, uid);
395       require(cmctToken.transfer(receiver, amount));
396       return true;
397     }
398   }
399  
400   function bulkRelayCMCT(address[] receivers, uint[] amounts, bytes32 uid) public onlyOwner onlyIfRunning onlyifInitialized returns(bool success) {
401     for(uint i=0; i<receivers.length; i++) {
402       if(!isApproved(receivers[i])) {
403         LogCMCTRelayFailed(msg.sender, receivers[i], amounts[i], uid);
404       } else {
405         LogCMCTRelayed(msg.sender, receivers[i], amounts[i], uid);
406         require(cmctToken.transfer(receivers[i], amounts[i]));
407       } 
408     }
409     return true;
410   }
411 
412   function () public onlyIfRunning payable {
413     require(isApproved(msg.sender));
414     LogEthReceived(msg.sender, msg.value);
415   }
416 }