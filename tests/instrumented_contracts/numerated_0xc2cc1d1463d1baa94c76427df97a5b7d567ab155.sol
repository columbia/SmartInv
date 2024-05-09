1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10 
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18 
19     }
20 
21  
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27 
28         uint256 c = a / b;
29         return c;
30 
31     }
32 
33  
34     /**
35     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39 
40         assert(b <= a);
41         return a - b;
42 
43     }
44 
45  
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49 
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51 
52         uint256 c = a + b;
53         assert(c >= a);
54         return c;
55 
56     }
57 
58 }
59 
60  
61 
62 contract Ownable {
63 
64     address public owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
70      */
71 
72     function Ownable() public {
73 
74         owner = msg.sender;
75 
76     }
77 
78  
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82 
83     modifier onlyOwner() {
84 
85         require(msg.sender == owner);
86         _;
87 
88     }
89 
90  
91     /**
92      * @dev Allows the current owner to transfer control of the contract to a newOwner.
93      * @param newOwner The address to transfer ownership to.
94      */
95 
96     function transferOwnership(address newOwner) public onlyOwner {
97 
98         require(newOwner != address(0));
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101 
102     }
103 
104 }
105 
106  
107 contract ERC20Basic {
108 
109     function totalSupply() public view returns (uint256);
110 
111     function balanceOf(address who) public view returns (uint256);
112 
113     function transfer(address to, uint256 value) public returns (bool);
114 
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117 }
118 
119 
120 contract BasicToken is ERC20Basic {
121 
122     using SafeMath for uint256;
123 
124     mapping(address => uint256) public balances;
125 
126     uint256 totalSupply_;
127 
128     /**
129     * @dev total number of tokens in existence
130     */
131 
132     function totalSupply() public view returns (uint256) {
133 
134         return totalSupply_;
135 
136     }
137 
138  
139     /**
140     * @dev transfer token for a specified address
141     * @param _to The address to transfer to.
142     * @param _value The amount to be transferred.
143     */
144 
145    function transfer(address _to, uint256 _value) public returns (bool) {
146 
147         require(_to != address(0));
148 
149         require(_value <= balances[msg.sender]);
150 
151         // SafeMath.sub will throw if there is not enough balance.
152 
153         balances[msg.sender] = balances[msg.sender].sub(_value);
154 
155         balances[_to] = balances[_to].add(_value);
156 
157         emit Transfer(msg.sender, _to, _value);
158 
159         return true;
160 
161     }
162 
163     /**
164     * @dev Gets the balance of the specified address.
165     * @param _owner The address to query the the balance of.
166     * @return An uint256 representing the amount owned by the passed address.
167     */
168 
169     function balanceOf(address _owner) public view returns (uint256 balance) {
170 
171         return balances[_owner];
172 
173     }
174 
175 }
176 
177  
178 
179 contract BurnableToken is BasicToken {
180 
181     event Burn(address indexed burner, uint256 value);
182 
183     /**
184      * @dev Burns a specific amount of tokens.
185      * @param _value The amount of token to be burned.
186      */
187 
188     function burn(uint256 _value) public {
189 
190         require(_value <= balances[msg.sender]);
191 
192         address burner = msg.sender;
193 
194         balances[burner] = balances[burner].sub(_value);
195 
196         totalSupply_ = totalSupply_.sub(_value);
197 
198         emit Burn(burner, _value);
199 
200     }
201 
202 }
203 
204  
205 
206 contract ERC20 is ERC20Basic {
207 
208     function allowance(address owner, address spender) public view returns (uint256);
209 
210     function transferFrom(address from, address to, uint256 value) public returns (bool);
211 
212     function approve(address spender, uint256 value) public returns (bool);
213 
214     event Approval(address indexed owner, address indexed spender, uint256 value);
215 
216 }
217 
218  
219 
220 library SafeERC20 {
221 
222     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
223 
224         assert(token.transfer(to, value));
225 
226     }
227 
228  
229 
230     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
231 
232         assert(token.transferFrom(from, to, value));
233 
234     }
235 
236  
237 
238     function safeApprove(ERC20 token, address spender, uint256 value) internal {
239 
240         assert(token.approve(spender, value));
241 
242    }
243 
244 }
245 
246  
247 
248 contract StandardToken is ERC20, BasicToken {
249 
250  
251     mapping (address => mapping (address => uint256)) internal allowed;
252 
253 
254     /**
255      * @dev Transfer tokens from one address to another
256      * @param _from address The address which you want to send tokens from
257      * @param _to address The address which you want to transfer to
258      * @param _value uint256 the amount of tokens to be transferred
259      */
260 
261     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
262 
263         require(_to != address(0));
264 
265         require(_value <= balances[_from]);
266 
267         require(_value <= allowed[_from][msg.sender]);
268 
269         balances[_from] = balances[_from].sub(_value);
270 
271         balances[_to] = balances[_to].add(_value);
272 
273         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
274 
275         emit Transfer(_from, _to, _value);
276 
277         return true;
278 
279     }
280 
281     /**
282      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
283      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284      * @param _spender The address which will spend the funds.
285      * @param _value The amount of tokens to be spent.
286      */
287 
288    function approve(address _spender, uint256 _value) public returns (bool) {
289 
290         allowed[msg.sender][_spender] = _value;
291 
292         emit Approval(msg.sender, _spender, _value);
293 
294         return true;
295 
296     }
297 
298     /**
299      * @dev Function to check the amount of tokens that an owner allowed to a spender.
300      * @param _owner address The address which owns the funds.
301      * @param _spender address The address which will spend the funds.
302      * @return A uint256 specifying the amount of tokens still available for the spender.
303      */
304 
305     function allowance(address _owner, address _spender) public view returns (uint256) {
306 
307         return allowed[_owner][_spender];
308 
309     }
310 
311  
312 }
313 
314  
315 contract WMCToken is StandardToken, BurnableToken, Ownable {
316 
317     using SafeMath for uint;
318 
319  
320 
321     string constant public symbol = "WMC";
322     string constant public name = "World Masonic Coin";
323     uint8 constant public decimals = 18;
324     
325     uint public totalSoldTokens = 0;
326 
327     uint public constant TOTAL_SUPPLY = 33000000 * (1 ether / 1 wei);
328 
329     uint public constant DEVELOPER_supply = 1650000 * (1 ether / 1 wei);
330 
331     uint public constant MARKETING_supply =  1650000 * (1 ether / 1 wei);
332 
333     uint public constant PROVISIONING_supply =  3300000 * (1 ether / 1 wei);
334 
335     uint constant PSMTime = 1529798401; // Sunday, June 24, 2018 12:00:01 AM
336 
337     uint public constant PSM_PRICE = 29;  // per 1 Ether
338 
339     uint constant PSTime = 1532476801; // Wednesday, July 25, 2018 12:00:01 AM
340 
341     uint public constant PS_PRICE = 27;    // per 1 Ether
342 
343     uint constant PINTime = 1535241601; //Sunday, August 26, 2018 12:00:01 AM
344 
345     uint public constant PIN_PRICE = 25;    // per 1 Ether
346 
347     uint constant ICOTime = 1574640001; // Monday, November 25, 2019 12:00:01 AM
348 
349     uint public constant ICO_PRICE = 23;    // per 1 Ether
350 
351     uint public constant TOTAL_TOKENs_SUPPLY = 26400000 * (1 ether / 1 wei); //TOTAL_SUPPLY – DEVELOPERS_supply – MARKETING_supply – PROVISIONING_supply;
352 
353  
354     address beneficiary = 0xef18F44049b0685AbaA63fe3Db43A0bE262453CE;
355     address developer = 0x311F0e3Ec7876679A2C4F4BaC6102fCB03536984;
356     address marketing = 0xba48AD5BBFA3C66743C269550e468479710084Dd;
357     address provisioning = 0xa1905B711D31B0646359Cd6393D7293dC0a5DFDf;
358 
359  bool public enableTransfers = true;
360  
361     /**
362     * @dev Send intial amounts for marketing development and provisioning
363     */
364     
365     function WMCToken() public {
366 
367     balances[provisioning] = balances[provisioning].add(PROVISIONING_supply);
368     balances[developer] = balances[developer].add(DEVELOPER_supply);
369     balances[marketing] = balances[marketing].add(MARKETING_supply);
370     
371     }
372 
373 
374     function transfer(address _to, uint256 _value) public returns (bool) {
375 
376         require(enableTransfers);
377         super.transfer(_to, _value);
378 
379     }
380 
381  
382    function approve(address _spender, uint256 _value) public returns (bool) {
383 
384         require(enableTransfers);
385         return super.approve(_spender,_value);
386 
387     }
388 
389  
390 
391     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
392 
393         require(enableTransfers);
394         super.transferFrom(_from, _to, _value);
395 
396     }
397 
398 
399     /**
400     * @dev fallback function
401     */
402     
403     function () public payable {
404 
405         require(enableTransfers);
406         uint256 amount = msg.value * getPrice();
407         require(totalSoldTokens + amount <= TOTAL_TOKENs_SUPPLY);
408         require(msg.value >= ((1 ether / 1 wei) / 100)); // min amount 0,01 ether
409         uint256 amount_marketing = msg.value * 5 /100;
410         uint256 amount_development = msg.value * 5 /100 ;
411         uint256 amount_masonic_project = msg.value * 90 /100;
412         beneficiary.transfer(amount_masonic_project);
413         developer.transfer(amount_development);
414         marketing.transfer(amount_marketing);
415         balances[msg.sender] = balances[msg.sender].add(amount);
416         totalSoldTokens+= amount;
417         emit Transfer(this, msg.sender, amount);                         
418 
419     }
420 
421     /**
422     * @dev get price depending on time
423     */
424      function getPrice()constant public returns(uint)
425 
426     {
427 
428         if (now < PSMTime) return PSM_PRICE;
429         else if (now < PSTime) return PS_PRICE;
430         else if (now < PINTime) return PIN_PRICE;
431         else if (now < ICOTime) return ICO_PRICE;
432         else return ICO_PRICE; // fallback
433 
434     }
435     
436     /**
437     * @dev stop transfers
438     */ 
439     
440     function DisableTransfer() public onlyOwner
441     {
442         enableTransfers = false;
443     }
444     
445     /**
446     * @dev resume transfers
447     */    
448     
449     function EnableTransfer() public onlyOwner
450     {
451         enableTransfers = true;
452     }
453     
454     /**
455     * @dev update beneficiarry adress only by contract owner
456     */    
457     
458         function UpdateBeneficiary(address _beneficiary) public onlyOwner returns(bool)
459     {
460         beneficiary = _beneficiary;
461     }
462 
463 }