1 library SafeMath {
2     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3         uint256 c = a * b;
4         assert(a == 0 || c / a == b);
5         return c;
6     }
7 
8     function div(uint256 a, uint256 b) internal pure returns (uint256) {
9         // assert(b > 0); // Solidity automatically throws when dividing by 0
10         uint256 c = a / b;
11         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 
26     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
27         return a >= b ? a : b;
28     }
29 
30     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
31         return a < b ? a : b;
32     }
33 
34     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
35         return a >= b ? a : b;
36     }
37 
38     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a < b ? a : b;
40     }
41 }
42 
43 contract ERC20Basic {
44     uint256 public totalSupply;
45 
46     bool public transfersEnabled;
47 
48     function balanceOf(address who) public view returns (uint256);
49 
50     function transfer(address to, uint256 value) public returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 contract ERC20 {
56     uint256 public totalSupply;
57 
58     bool public transfersEnabled;
59 
60     function balanceOf(address _owner) public constant returns (uint256 balance);
61 
62     function transfer(address _to, uint256 _value) public returns (bool success);
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
65 
66     function approve(address _spender, uint256 _value) public returns (bool success);
67 
68     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 }
73 
74 contract BasicToken is ERC20Basic {
75     using SafeMath for uint256;
76 
77     mapping(address => uint256) balances;
78 
79     /**
80     * @dev protection against short address attack
81     */
82     modifier onlyPayloadSize(uint numwords) {
83         assert(msg.data.length == numwords * 32 + 4);
84         _;
85     }
86 
87 
88     /**
89     * @dev transfer token for a specified address
90     * @param _to The address to transfer to.
91     * @param _value The amount to be transferred.
92     */
93     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96         require(transfersEnabled);
97 
98         // SafeMath.sub will throw if there is not enough balance.
99         balances[msg.sender] = balances[msg.sender].sub(_value);
100         balances[_to] = balances[_to].add(_value);
101         Transfer(msg.sender, _to, _value);
102         return true;
103     }
104 
105     /**
106     * @dev Gets the balance of the specified address.
107     * @param _owner The address to query the the balance of.
108     * @return An uint256 representing the amount owned by the passed address.
109     */
110     function balanceOf(address _owner) public constant returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114 }
115 
116 contract StandardToken is ERC20, BasicToken {
117 
118     mapping(address => mapping(address => uint256)) internal allowed;
119 
120     /**
121      * @dev Transfer tokens from one address to another
122      * @param _from address The address which you want to send tokens from
123      * @param _to address The address which you want to transfer to
124      * @param _value uint256 the amount of tokens to be transferred
125      */
126     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130         require(transfersEnabled);
131 
132         balances[_from] = balances[_from].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135         Transfer(_from, _to, _value);
136         return true;
137     }
138 
139     /**
140      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141      *
142      * Beware that changing an allowance with this method brings the risk that someone may use both the old
143      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      * @param _spender The address which will spend the funds.
147      * @param _value The amount of tokens to be spent.
148      */
149     function approve(address _spender, uint256 _value) public returns (bool) {
150         allowed[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     /**
156      * @dev Function to check the amount of tokens that an owner allowed to a spender.
157      * @param _owner address The address which owns the funds.
158      * @param _spender address The address which will spend the funds.
159      * @return A uint256 specifying the amount of tokens still available for the spender.
160      */
161     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }
164 
165     /**
166      * approve should be called when allowed[_spender] == 0. To increment
167      * allowed value is better to use this function to avoid 2 calls (and wait until
168      * the first transaction is mined)
169      * From MonolithDAO Token.sol
170      */
171     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
172         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
173         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174         return true;
175     }
176 
177     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
178         uint oldValue = allowed[msg.sender][_spender];
179         if (_subtractedValue > oldValue) {
180             allowed[msg.sender][_spender] = 0;
181         } else {
182             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183         }
184         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187 
188 }
189 
190 contract Volcadigitalcurrency is StandardToken {
191 
192     string public constant name = "Volca Digital Currency V2";
193     string public constant symbol = "VOLDI V2";
194     uint8 public constant decimals = 8;
195     uint256 public constant INITIAL_SUPPLY = 10 * 10**9 * (10**uint256(decimals));
196     uint256 public weiRaised;
197     uint256 public tokenAllocated;
198     address public owner;
199     bool public saleToken = true;
200 
201     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
202     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
203     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
204     event Transfer(address indexed _from, address indexed _to, uint256 _value);
205 
206     function Volcadigitalcurrency() public {
207         totalSupply = INITIAL_SUPPLY;
208         owner = msg.sender;
209         //owner = msg.sender; // for testing
210         balances[owner] = INITIAL_SUPPLY;
211         tokenAllocated = 0;
212         transfersEnabled = true;
213     }
214 
215     // fallback function can be used to buy tokens
216     function() payable public {
217         buyTokens(msg.sender);
218     }
219 
220     function buyTokens(address _investor) public payable returns (uint256){
221         require(_investor != address(0));
222         require(saleToken == true);
223         address wallet = owner;
224         uint256 weiAmount = msg.value;
225         uint256 tokens = validPurchaseTokens(weiAmount);
226         if (tokens == 0) {revert();}
227         weiRaised = weiRaised.add(weiAmount);
228         tokenAllocated = tokenAllocated.add(tokens);
229         mint(_investor, tokens, owner);
230 
231         TokenPurchase(_investor, weiAmount, tokens);
232         wallet.transfer(weiAmount);
233         return tokens;
234     }
235 
236     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
237         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
238         if (addTokens > balances[owner]) {
239             TokenLimitReached(tokenAllocated, addTokens);
240             return 0;
241         }
242         return addTokens;
243     }
244 
245     
246     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
247         uint256 amountOfTokens = 0;
248         if(_weiAmount == 0){
249             amountOfTokens = 10 * (10**uint256(decimals));
250         }
251         if( _weiAmount == 0.001 ether){
252             amountOfTokens = 80000 * (10**uint256(decimals));
253         }
254         if( _weiAmount == 0.002 ether){
255             amountOfTokens = 160000 * (10**uint256(decimals));
256         }
257         if( _weiAmount == 0.003 ether){
258             amountOfTokens = 240000 * (10**uint256(decimals));
259         }
260         if( _weiAmount == 0.004 ether){
261             amountOfTokens = 320000 * (10**uint256(decimals));
262         }
263         if( _weiAmount == 0.005 ether){
264             amountOfTokens = 400000 * (10**uint256(decimals));
265         }
266         if( _weiAmount == 0.006 ether){
267             amountOfTokens = 480000 * (10**uint256(decimals));
268         }
269         if( _weiAmount == 0.007 ether){
270             amountOfTokens = 560000 * (10**uint256(decimals));
271         }
272         if( _weiAmount == 0.008 ether){
273             amountOfTokens = 640000 * (10**uint256(decimals));
274         }
275         if( _weiAmount == 0.009 ether){
276             amountOfTokens = 720000 * (10**uint256(decimals));
277         }
278         if( _weiAmount == 0.01 ether){
279             amountOfTokens = 800000 * (10**uint256(decimals));
280         }
281         if( _weiAmount == 0.02 ether){
282             amountOfTokens = 1600000 * (10**uint256(decimals));
283         }
284         if( _weiAmount == 0.03 ether){
285             amountOfTokens = 2400000 * (10**uint256(decimals));
286         }
287         if( _weiAmount == 0.04 ether){
288             amountOfTokens = 3200000 * (10**uint256(decimals));
289         }
290         if( _weiAmount == 0.05 ether){
291             amountOfTokens = 4000000 * (10**uint256(decimals));
292         }
293         if( _weiAmount == 0.06 ether){
294             amountOfTokens = 4800000 * (10**uint256(decimals));
295         }
296         if( _weiAmount == 0.07 ether){
297             amountOfTokens = 5600000 * (10**uint256(decimals));
298         }
299         if( _weiAmount == 0.08 ether){
300             amountOfTokens = 6400000 * (10**uint256(decimals));
301         }
302         if( _weiAmount == 0.09 ether){
303             amountOfTokens = 7200000 * (10**uint256(decimals));
304         }
305         if( _weiAmount == 0.1 ether){
306             amountOfTokens = 80000 * 10**2 * (10**uint256(decimals));
307         }
308         if( _weiAmount == 0.2 ether){
309             amountOfTokens = 160000 * 10**2 * (10**uint256(decimals));
310         }
311         if( _weiAmount == 0.3 ether){
312             amountOfTokens = 240000 * 10**2 * (10**uint256(decimals));
313         }
314         if( _weiAmount == 0.4 ether){
315             amountOfTokens = 320000 * 10**2 * (10**uint256(decimals));
316         }
317         if( _weiAmount == 0.5 ether){
318             amountOfTokens = 400000 * 10**2 * (10**uint256(decimals));
319         }
320         if( _weiAmount == 0.6 ether){
321             amountOfTokens = 480000 * 10**2 * (10**uint256(decimals));
322         }
323         if( _weiAmount == 0.7 ether){
324             amountOfTokens = 560000 * 10*23 * (10**uint256(decimals));
325         }
326         if( _weiAmount == 0.8 ether){
327             amountOfTokens = 64000 * 10**2 * (10**uint256(decimals));
328         }
329         if( _weiAmount == 0.9 ether){
330             amountOfTokens = 720000 * 10**2 * (10**uint256(decimals));
331         }
332         if( _weiAmount == 1 ether){
333             amountOfTokens = 1000000 * 10**2 * (10**uint256(decimals));
334         }
335         return amountOfTokens;
336     }
337 
338 
339     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
340         require(_to != address(0));
341         require(_amount <= balances[_owner]);
342 
343         balances[_to] = balances[_to].add(_amount);
344         balances[_owner] = balances[_owner].sub(_amount);
345         Transfer(_owner, _to, _amount);
346         return true;
347     }
348 
349     modifier onlyOwner() {
350         require(msg.sender == owner);
351         _;
352     }
353 
354     function changeOwner(address _newOwner) onlyOwner public returns (bool){
355         require(_newOwner != address(0));
356         OwnerChanged(owner, _newOwner);
357         owner = _newOwner;
358         return true;
359     }
360 
361     function startSale() public onlyOwner {
362         saleToken = true;
363     }
364 
365     function stopSale() public onlyOwner {
366         saleToken = false;
367     }
368 
369     function enableTransfers(bool _transfersEnabled) onlyOwner public {
370         transfersEnabled = _transfersEnabled;
371     }
372 
373     /**
374      * Peterson's Law Protection
375      * Claim tokens
376      */
377     function claimTokens() public onlyOwner {
378         owner.transfer(this.balance);
379         uint256 balance = balanceOf(this);
380         transfer(owner, balance);
381         Transfer(this, owner, balance);
382     }
383 }