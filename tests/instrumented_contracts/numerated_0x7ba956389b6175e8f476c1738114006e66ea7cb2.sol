1 pragma solidity ^0.4.23;
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
72     constructor() public {
73         owner = 0xef18F44049b0685AbaA63fe3Db43A0bE262453CE;
74     }
75 
76  
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80 
81     modifier onlyOwner() {
82 
83         require(msg.sender == owner);
84         _;
85 
86     }
87 
88  
89     /**
90      * @dev Allows the current owner to transfer control of the contract to a newOwner.
91      * @param newOwner The address to transfer ownership to.
92      */
93 
94     function transferOwnership(address newOwner) public onlyOwner {
95 
96         require(newOwner != address(0));
97         emit OwnershipTransferred(owner, newOwner);
98         owner = newOwner;
99 
100     }
101 
102 }
103 
104  
105 contract ERC20Basic {
106 
107     function totalSupply() public view returns (uint256);
108 
109     function balanceOf(address who) public view returns (uint256);
110 
111     function transfer(address to, uint256 value) public returns (bool);
112 
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115 }
116 
117 
118 contract BasicToken is ERC20Basic {
119 
120     using SafeMath for uint256;
121 
122     mapping(address => uint256) public balances;
123 
124     uint256 totalSupply_ = 33000000 * (1 ether / 1 wei);
125 
126 
127     /**
128     * @dev total number of tokens in existence
129     */
130 
131     function totalSupply() public view returns (uint256) {
132 
133         return totalSupply_;
134 
135     }
136 
137  
138     /**
139     * @dev transfer token for a specified address
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143 
144    function transfer(address _to, uint256 _value) public returns (bool) {
145 
146         require(_to != address(0));
147 
148         require(_value <= balances[msg.sender]);
149 
150         // SafeMath.sub will throw if there is not enough balance.
151 
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153 
154         balances[_to] = balances[_to].add(_value);
155 
156         emit Transfer(msg.sender, _to, _value);
157 
158         return true;
159 
160     }
161 
162     /**
163     * @dev Gets the balance of the specified address.
164     * @param _owner The address to query the the balance of.
165     * @return An uint256 representing the amount owned by the passed address.
166     */
167 
168     function balanceOf(address _owner) public view returns (uint256 balance) {
169 
170         return balances[_owner];
171 
172     }
173 
174 }
175 
176  
177 
178 contract BurnableToken is BasicToken {
179 
180     event Burn(address indexed burner, uint256 value);
181 
182     /**
183      * @dev Burns a specific amount of tokens.
184      * @param _value The amount of token to be burned.
185      */
186 
187     function burn(uint256 _value) public {
188 
189         require(_value <= balances[msg.sender]);
190 
191         address burner = msg.sender;
192 
193         balances[burner] = balances[burner].sub(_value);
194 
195         totalSupply_ = totalSupply_.sub(_value);
196 
197         emit Burn(burner, _value);
198 
199     }
200 
201 }
202 
203  
204 
205 contract ERC20 is ERC20Basic {
206 
207     function allowance(address owner, address spender) public view returns (uint256);
208 
209     function transferFrom(address from, address to, uint256 value) public returns (bool);
210 
211     function approve(address spender, uint256 value) public returns (bool);
212 
213     event Approval(address indexed owner, address indexed spender, uint256 value);
214 
215 }
216 
217  
218 
219 library SafeERC20 {
220 
221     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
222 
223         assert(token.transfer(to, value));
224 
225     }
226 
227  
228 
229     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
230 
231         assert(token.transferFrom(from, to, value));
232 
233     }
234 
235  
236 
237     function safeApprove(ERC20 token, address spender, uint256 value) internal {
238 
239         assert(token.approve(spender, value));
240 
241    }
242 
243 }
244 
245  
246 
247 contract StandardToken is ERC20, BasicToken {
248 
249  
250     mapping (address => mapping (address => uint256)) internal allowed;
251 
252 
253     /**
254      * @dev Transfer tokens from one address to another
255      * @param _from address The address which you want to send tokens from
256      * @param _to address The address which you want to transfer to
257      * @param _value uint256 the amount of tokens to be transferred
258      */
259 
260     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
261 
262         require(_to != address(0));
263 
264         require(_value <= balances[_from]);
265 
266         require(_value <= allowed[_from][msg.sender]);
267 
268         balances[_from] = balances[_from].sub(_value);
269 
270         balances[_to] = balances[_to].add(_value);
271 
272         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273 
274         emit Transfer(_from, _to, _value);
275 
276         return true;
277 
278     }
279 
280     /**
281      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
282      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
283      * @param _spender The address which will spend the funds.
284      * @param _value The amount of tokens to be spent.
285      */
286 
287    function approve(address _spender, uint256 _value) public returns (bool) {
288 
289         allowed[msg.sender][_spender] = _value;
290 
291         emit Approval(msg.sender, _spender, _value);
292 
293         return true;
294 
295     }
296 
297     /**
298      * @dev Function to check the amount of tokens that an owner allowed to a spender.
299      * @param _owner address The address which owns the funds.
300      * @param _spender address The address which will spend the funds.
301      * @return A uint256 specifying the amount of tokens still available for the spender.
302      */
303 
304     function allowance(address _owner, address _spender) public view returns (uint256) {
305 
306         return allowed[_owner][_spender];
307 
308     }
309 
310  
311 }
312 
313  
314 contract WMCSToken is StandardToken, BurnableToken, Ownable {
315 
316     using SafeMath for uint;
317 
318     string constant public symbol = "WMCS";
319     string constant public name = "World Masonic Coin Solidus";
320     uint8 constant public decimals = 18;
321 	uint constant INITIAL_TRANSFER = 32999000 * (1 ether / 1 wei);
322 	
323 	uint public totalSoldTokens;
324 
325     uint constant June_Time = 1560124801; //Monday, 10-Jun-19 00:00:01 UTC
326 
327     uint public constant June_PRICE = 11;    // per 1 Ether
328 
329     uint public constant Rest_PRICE = 9;    // per 1 Ether
330 
331     uint public constant TOTAL_TOKENs_SUPPLY = 33000000 * (1 ether / 1 wei);
332  
333     address beneficiary = 0xef18F44049b0685AbaA63fe3Db43A0bE262453CE;
334 
335  bool public enableTransfers = true;
336  
337     /**
338     * @dev Send intial amounts for marketing development and provisioning
339     */
340     
341     constructor() public {
342         
343         totalSoldTokens = INITIAL_TRANSFER;
344         balances[beneficiary] = balances[beneficiary].add(INITIAL_TRANSFER);
345     }
346 
347     function transfer(address _to, uint256 _value) public returns (bool) {
348 
349         require(enableTransfers);
350         super.transfer(_to, _value);
351 
352     }
353 
354  
355    function approve(address _spender, uint256 _value) public returns (bool) {
356 
357         require(enableTransfers);
358         return super.approve(_spender,_value);
359 
360     }
361 
362  
363 
364     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
365 
366         require(enableTransfers);
367         super.transferFrom(_from, _to, _value);
368 
369     }
370 
371 
372     /**
373     * @dev fallback function
374     */
375     
376     function () public payable {       
377 	
378         require(enableTransfers);
379         uint256 amount = msg.value * getPrice();
380         require(totalSoldTokens + amount <= TOTAL_TOKENs_SUPPLY);
381         require(msg.value >= ((1 ether / 1 wei) / 100)); // min amount 0,01 ether
382         uint256 amount_masonic_project = msg.value;
383         beneficiary.transfer(amount_masonic_project);
384         balances[msg.sender] = balances[msg.sender].add(amount);
385         totalSoldTokens+= amount;
386         emit Transfer(this, msg.sender, amount);  
387     }
388 
389     /**
390     * @dev get price depending on time
391     */
392      function getPrice()constant public returns(uint)
393 
394     {
395 
396         if (now < June_Time ) return June_PRICE;
397         else return Rest_PRICE; // fallback
398 
399     }
400     
401     /**
402     * @dev stop transfers
403     */ 
404     
405     function DisableTransfer() public onlyOwner
406     {
407         enableTransfers = false;
408     }
409     
410     /**
411     * @dev resume transfers
412     */    
413     
414     function EnableTransfer() public onlyOwner
415     {
416         enableTransfers = true;
417     }
418     
419     /**
420     * @dev update beneficiarry adress only by contract owner
421     */    
422     
423         function UpdateBeneficiary(address _beneficiary) public onlyOwner returns(bool)
424     {
425         beneficiary = _beneficiary;
426     }
427 
428 }