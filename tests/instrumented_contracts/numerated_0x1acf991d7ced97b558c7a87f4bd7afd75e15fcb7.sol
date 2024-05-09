1 pragma solidity ^0.4.18;
2 
3 /*
4 TTTTTTTTTTTTTTTTTTTTTTT  iiii                                                                                              
5 T:::::::::::::::::::::T i::::i                                                                                             
6 T:::::::::::::::::::::T  iiii                                                                                              
7 T:::::TT:::::::TT:::::T                                                                                                    
8 TTTTTT  T:::::T  TTTTTTiiiiiii xxxxxxx      xxxxxxxggggggggg   ggggguuuuuu    uuuuuu rrrrr   rrrrrrrrr   uuuuuu    uuuuuu  
9         T:::::T        i:::::i  x:::::x    x:::::xg:::::::::ggg::::gu::::u    u::::u r::::rrr:::::::::r  u::::u    u::::u  
10         T:::::T         i::::i   x:::::x  x:::::xg:::::::::::::::::gu::::u    u::::u r:::::::::::::::::r u::::u    u::::u  
11         T:::::T         i::::i    x:::::xx:::::xg::::::ggggg::::::ggu::::u    u::::u rr::::::rrrrr::::::ru::::u    u::::u  
12         T:::::T         i::::i     x::::::::::x g:::::g     g:::::g u::::u    u::::u  r:::::r     r:::::ru::::u    u::::u  
13         T:::::T         i::::i      x::::::::x  g:::::g     g:::::g u::::u    u::::u  r:::::r     rrrrrrru::::u    u::::u  
14         T:::::T         i::::i      x::::::::x  g:::::g     g:::::g u::::u    u::::u  r:::::r            u::::u    u::::u  
15         T:::::T         i::::i     x::::::::::x g::::::g    g:::::g u:::::uuuu:::::u  r:::::r            u:::::uuuu:::::u  
16       TT:::::::TT      i::::::i   x:::::xx:::::xg:::::::ggggg:::::g u:::::::::::::::uur:::::r            u:::::::::::::::uu
17       T:::::::::T      i::::::i  x:::::x  x:::::xg::::::::::::::::g  u:::::::::::::::ur:::::r             u:::::::::::::::u
18       T:::::::::T      i::::::i x:::::x    x:::::xgg::::::::::::::g   uu::::::::uu:::ur:::::r              uu::::::::uu:::u
19       TTTTTTTTTTT      iiiiiiiixxxxxxx      xxxxxxx gggggggg::::::g     uuuuuuuu  uuuurrrrrrr                uuuuuuuu  uuuu
20                                                             g:::::g                                                        
21                                                 gggggg      g:::::g                                                        
22                                                 g:::::gg   gg:::::g                                                        
23                                                  g::::::ggg:::::::g                                                        
24                                                   gg:::::::::::::g                                                         
25                                                     ggg::::::ggg                                                           
26                                                        gggggg                                                              
27 */
28 
29 library SafeMath {
30 
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a / b;
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   function getOwner() public view returns (address) {
65     return owner;
66   }
67 
68   function Ownable() public {
69     owner = msg.sender;
70   }
71 
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 }
83 
84 contract ERC20Basic {
85   function totalSupply() public view returns (uint256);
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public view returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   uint256 totalSupply_;
104 
105   function totalSupply() public view returns (uint256) {
106     return totalSupply_;
107   }
108 
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[msg.sender]);
112 
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   function balanceOf(address _owner) public view returns (uint256 balance) {
120     return balances[_owner];
121   }
122 }
123 
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[_from]);
132     require(_value <= allowed[_from][msg.sender]);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
152     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
153     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
158     uint oldValue = allowed[msg.sender][_spender];
159     if (_subtractedValue > oldValue) {
160       allowed[msg.sender][_spender] = 0;
161     } else {
162       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163     }
164     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 }
168 
169 contract TIX is StandardToken, Ownable {
170 
171   using SafeMath for uint256;
172 
173   string public constant name = "Tixguru Token";
174   string public constant symbol = "TIX";
175   uint256 public constant decimals = 3;
176   uint256 internal constant wei_to_token = 10 ** 15;
177 
178   uint256 public rate = 10000;
179   uint256 public minimum = 1 * 10 ** 11;
180   uint256 public wei_raised = 0;
181   uint256 public token_issued = 0;
182   uint256 public start_time = 0;
183   uint256 public end_time = 0;
184   uint256 public period = 0;
185   uint256[] public discount_period;
186   uint256[] public discount;
187   bool public tradeable = false;
188   bool public issuable = false;
189 
190   address internal vault;
191 
192 
193   event LogTokenBought(address indexed sender, address indexed buyer, uint256 value, uint256 tokens, uint256 timestamp);
194   event LogVaultChanged(address indexed new_vault, uint256 timestamp);
195   event LogStarted(uint256 timestamp);
196   event LogTradingEnabled(uint256 timestamp);
197   event LogTradingDisabled(uint256 timestamp);
198   event LogTokenBurned(address indexed burner, uint256 indexed tokens, uint256 timestamp);
199   event LogPreSaled(address indexed buyer, uint256 tokens, uint256 timestamp);
200   event LogDiscountSet(uint256[] indexed period, uint256[] indexed discount, uint256 timestamp);
201 
202 
203   modifier validAddress(address addr) {
204     require(addr != address(0));
205     _;
206   }
207 
208   function disableTrading() external onlyOwner returns (bool) {
209     tradeable = false;
210     LogTradingDisabled(now);
211     return true;
212   }
213 
214 
215   function TIX(uint256 cap, address _vault, uint256[] _period, uint256[] _discount)
216   public
217   validAddress(_vault)
218   validArray(_period)
219   validArray(_discount) {
220 
221     uint256 decimal_unit = 10 ** 3;
222     totalSupply_ = cap.mul(decimal_unit);
223     vault = _vault;
224     discount_period = _period;
225     discount = _discount;
226 
227     balances[0x8b26E715fF12B0Bf37D504f7Bf0ee918Cd83C67B] = totalSupply_.mul(3).div(10);
228     balances[owner] = totalSupply_.mul(7).div(10);
229 
230     for (uint256 i = 0; i < discount_period.length; i++) {
231       period = period.add(discount_period[i]);
232     }
233   }
234 
235   function deposit() internal {
236     vault.transfer(msg.value);
237   }
238 
239   modifier validArray(uint[] array) {
240     require(array.length > 0);
241     _;
242   }
243 
244   function () external payable {
245     buyTokens(msg.sender);
246   }
247 
248   function buyTokens(address buyer) public validAddress(buyer) payable {
249     require(issuable);
250 
251     uint256 tokens = getTokenAmount(msg.value);
252 
253     require(canIssue(tokens));
254 
255     wei_raised = wei_raised.add(msg.value);
256     token_issued = token_issued.add(tokens);
257     balances[owner] = balances[owner].sub(tokens);
258     balances[buyer] = balances[buyer].add(tokens);
259 
260     LogTokenBought(msg.sender, buyer, msg.value, tokens, now);
261 
262     deposit();
263   }
264 
265   function setDiscount(uint256[] _period, uint256[] _discount)
266   external
267   onlyVault
268   validArray(_period)
269   validArray(_discount)
270   returns (bool) {
271 
272     discount_period = _period;
273     discount = _discount;
274 
275     period = 0;
276     for (uint256 i = 0; i < discount_period.length; i++) {
277       period = period.add(discount_period[i]);
278     }
279 
280     if (start_time != 0) {
281       uint256 time_point = now;
282       start_time = time_point;
283       end_time = time_point + period;
284 
285       uint256 tmp_time = time_point;
286       for (i = 0; i < discount_period.length; i++) {
287         tmp_time = tmp_time.add(discount_period[i]);
288         discount_period[i] = tmp_time;
289       }
290     }
291 
292     LogDiscountSet( _period, _discount, time_point);
293     return true;
294   }
295 
296   function getTokenAmount(uint256 _value) public view returns (uint256) {
297     require(_value >= minimum);
298 
299     uint256 buy_time = now;
300     uint256 numerator = 0;
301 
302     for (uint256 i = 0; i < discount_period.length; i++) {
303       if (buy_time <= discount_period[i]) {
304         numerator = discount[i];
305         break;
306       }
307     }
308 
309     if (numerator == 0) {
310       numerator = 100;
311     }
312 
313     return _value.mul(rate).mul(numerator).div(100).div(wei_to_token);
314   }
315 
316   function enableTrading() external onlyOwner returns (bool) {
317     tradeable = true;
318     LogTradingEnabled(now);
319     return true;
320   }
321 
322   function transferOwnership(address newOwner) public onlyOwner {
323 
324     balances[newOwner] = balances[owner];
325     delete balances[owner];
326     super.transferOwnership(newOwner);
327   }
328 
329   function start() external onlyOwner returns (bool) {
330     require(start_time == 0);
331 
332     uint256 time_point = now;
333 
334     start_time = time_point;
335     end_time = time_point + period;
336 
337     for (uint256 i = 0; i < discount_period.length; i++) {
338       time_point = time_point.add(discount_period[i]);
339       discount_period[i] = time_point;
340     }
341 
342     issuable = true;
343 
344     LogStarted(start_time);
345 
346     return true;
347   }
348 
349 
350   function changeVault(address _vault) external onlyVault returns (bool) {
351     vault = _vault;
352     LogVaultChanged(_vault, now);
353     return true;
354   }
355 
356   function burnTokens(uint256 tokens) external onlyVault returns (bool) {
357     balances[owner] = balances[owner].sub(tokens);
358     totalSupply_ = totalSupply_.sub(tokens);
359     LogTokenBurned(owner, tokens, now);
360     return true;
361   }
362   function transferFrom(address _from, address _to, uint256 tokens) public returns (bool) {
363     require(tradeable == true);
364     return super.transferFrom(_from, _to, tokens);
365   }
366 
367 
368   function transfer(address _to, uint256 tokens) public returns (bool) {
369     require(tradeable == true);
370     return super.transfer(_to, tokens);
371   }
372 
373 
374   function canIssue(uint256 tokens) internal returns (bool){
375     if (start_time == 0 || end_time <= now) {
376       issuable = false;
377       return false;
378     }
379     if (token_issued.add(tokens) > balances[owner]) {
380       issuable = false;
381       return false;
382     }
383 
384     return true;
385   }
386   modifier onlyVault() {
387     require(msg.sender == vault);
388     _;
389   }
390 }