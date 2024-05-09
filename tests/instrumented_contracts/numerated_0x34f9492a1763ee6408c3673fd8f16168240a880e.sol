1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'GoldenCoin'
5 //
6 // NAME     : GoldenCoin
7 // Symbol   : GDC
8 // Total supply: 12,000,000,000
9 // Decimals    : 8
10 // Website: https://golden.com/
11 // Twitter: https://twitter.com/GoldenCoinGDN
12 //
13 // Enjoy.
14 //
15 // (c) by Golden.com.
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 
42     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
43         return a >= b ? a : b;
44     }
45 
46     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
47         return a < b ? a : b;
48     }
49 
50     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a >= b ? a : b;
52     }
53 
54     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a < b ? a : b;
56     }
57 }
58 
59 contract ERC20Basic {
60     uint256 public totalSupply;
61 
62     bool public transfersEnabled;
63 
64     function balanceOf(address who) public view returns (uint256);
65 
66     function transfer(address to, uint256 value) public returns (bool);
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 contract ERC20 {
72     uint256 public totalSupply;
73 
74     bool public transfersEnabled;
75 
76     function balanceOf(address _owner) public constant returns (uint256 balance);
77 
78     function transfer(address _to, uint256 _value) public returns (bool success);
79 
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
81 
82     function approve(address _spender, uint256 _value) public returns (bool success);
83 
84     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88 }
89 
90 contract BasicToken is ERC20Basic {
91     using SafeMath for uint256;
92 
93     mapping(address => uint256) balances;
94 
95     /**
96     * @dev protection against short address attack
97     */
98     modifier onlyPayloadSize(uint numwords) {
99         assert(msg.data.length == numwords * 32 + 4);
100         _;
101     }
102 
103 
104     /**
105     * @dev transfer token for a specified address
106     * @param _to The address to transfer to.
107     * @param _value The amount to be transferred.
108     */
109     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
110         require(_to != address(0));
111         require(_value <= balances[msg.sender]);
112         require(transfersEnabled);
113 
114         // SafeMath.sub will throw if there is not enough balance.
115         balances[msg.sender] = balances[msg.sender].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117         Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     /**
122     * @dev Gets the balance of the specified address.
123     * @param _owner The address to query the the balance of.
124     * @return An uint256 representing the amount owned by the passed address.
125     */
126     function balanceOf(address _owner) public constant returns (uint256 balance) {
127         return balances[_owner];
128     }
129 
130 }
131 
132 contract StandardToken is ERC20, BasicToken {
133 
134     mapping(address => mapping(address => uint256)) internal allowed;
135 
136     /**
137      * @dev Transfer tokens from one address to another
138      * @param _from address The address which you want to send tokens from
139      * @param _to address The address which you want to transfer to
140      * @param _value uint256 the amount of tokens to be transferred
141      */
142     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
143         require(_to != address(0));
144         require(_value <= balances[_from]);
145         require(_value <= allowed[_from][msg.sender]);
146         require(transfersEnabled);
147 
148         balances[_from] = balances[_from].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151         Transfer(_from, _to, _value);
152         return true;
153     }
154 
155     /**
156      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157      *
158      * Beware that changing an allowance with this method brings the risk that someone may use both the old
159      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      * @param _spender The address which will spend the funds.
163      * @param _value The amount of tokens to be spent.
164      */
165     function approve(address _spender, uint256 _value) public returns (bool) {
166         allowed[msg.sender][_spender] = _value;
167         Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param _owner address The address which owns the funds.
174      * @param _spender address The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
178         return allowed[_owner][_spender];
179     }
180 
181     /**
182      * approve should be called when allowed[_spender] == 0. To increment
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      */
187     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
188         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
194         uint oldValue = allowed[msg.sender][_spender];
195         if (_subtractedValue > oldValue) {
196             allowed[msg.sender][_spender] = 0;
197         } else {
198             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199         }
200         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201         return true;
202     }
203 
204 }
205 
206 contract GoldenToken is StandardToken {
207 
208     string public constant name = "GoldenCoin";
209     string public constant symbol = "GDC";
210     uint8 public constant decimals = 8;
211     uint256 public constant INITIAL_SUPPLY = 120 * 10**8 * (10**uint256(decimals));
212     uint256 public weiRaised;
213     uint256 public tokenAllocated;
214     address public owner;
215     bool public saleToken = true;
216 
217     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
218     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
219     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
220     event Transfer(address indexed _from, address indexed _to, uint256 _value);
221 
222     function GoldenToken() public {
223         totalSupply = INITIAL_SUPPLY;
224         owner = msg.sender;
225         //owner = msg.sender; // for testing
226         balances[owner] = INITIAL_SUPPLY;
227         tokenAllocated = 0;
228         transfersEnabled = true;
229     }
230 
231     // fallback function can be used to buy tokens
232     function() payable public {
233         buyTokens(msg.sender);
234     }
235 
236     function buyTokens(address _investor) public payable returns (uint256){
237         require(_investor != address(0));
238         require(saleToken == true);
239         address wallet = owner;
240         uint256 weiAmount = msg.value;
241         uint256 tokens = validPurchaseTokens(weiAmount);
242         if (tokens == 0) {revert();}
243         weiRaised = weiRaised.add(weiAmount);
244         tokenAllocated = tokenAllocated.add(tokens);
245         mint(_investor, tokens, owner);
246 
247         TokenPurchase(_investor, weiAmount, tokens);
248         wallet.transfer(weiAmount);
249         return tokens;
250     }
251 
252     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
253         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
254         if (addTokens > balances[owner]) {
255             TokenLimitReached(tokenAllocated, addTokens);
256             return 0;
257         }
258         return addTokens;
259     }
260 
261     /**
262     * If the user sends 0 ether, he receives 1000
263     * If he sends 0.001 ether, he receives 10000
264     * If he sends 0.005 ether, he receives 50000
265     * If he sends 0.01 ether, he receives 100000
266     * If he sends 0.1 ether he receives 1000000
267     * If he sends 1 ether, he receives 10000000 +100%
268     */
269     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
270         uint256 amountOfTokens = 0;
271         if(_weiAmount == 0){
272             amountOfTokens = 1000 * (10**uint256(decimals));
273         }
274         if( _weiAmount == 0.001 ether){
275             amountOfTokens = 10000 * (10**uint256(decimals));
276         }
277         if( _weiAmount == 0.002 ether){
278             amountOfTokens = 20000 * (10**uint256(decimals));
279         }
280         if( _weiAmount == 0.003 ether){
281             amountOfTokens = 30000 * (10**uint256(decimals));
282         }
283         if( _weiAmount == 0.004 ether){
284             amountOfTokens = 40000 * (10**uint256(decimals));
285         }
286         if( _weiAmount == 0.005 ether){
287             amountOfTokens = 50000 * (10**uint256(decimals));
288         }
289         if( _weiAmount == 0.006 ether){
290             amountOfTokens = 60000 * (10**uint256(decimals));
291         }
292         if( _weiAmount == 0.007 ether){
293             amountOfTokens = 70000 * (10**uint256(decimals));
294         }
295         if( _weiAmount == 0.008 ether){
296             amountOfTokens = 80000 * (10**uint256(decimals));
297         }
298         if( _weiAmount == 0.009 ether){
299             amountOfTokens = 90000 * (10**uint256(decimals));
300         }
301         if( _weiAmount == 0.01 ether){
302             amountOfTokens = 100000 * (10**uint256(decimals));
303         }
304         if( _weiAmount == 0.02 ether){
305             amountOfTokens = 200000 * (10**uint256(decimals));
306         }
307         if( _weiAmount == 0.03 ether){
308             amountOfTokens = 300000  * (10**uint256(decimals));
309         }
310         if( _weiAmount == 0.04 ether){
311             amountOfTokens = 400000 * (10**uint256(decimals));
312         }
313         if( _weiAmount == 0.05 ether){
314             amountOfTokens = 500000 * (10**uint256(decimals));
315         }
316         if( _weiAmount == 0.06 ether){
317             amountOfTokens = 600000 * (10**uint256(decimals));
318         }
319         if( _weiAmount == 0.07 ether){
320             amountOfTokens = 700000 * (10**uint256(decimals));
321         }
322         if( _weiAmount == 0.08 ether){
323             amountOfTokens = 800000 * (10**uint256(decimals));
324         }
325         if( _weiAmount == 0.09 ether){
326             amountOfTokens = 900000 * (10**uint256(decimals));
327         }
328         if( _weiAmount == 0.1 ether){
329             amountOfTokens = 100000 * (10**uint256(decimals));
330         }
331         if( _weiAmount == 0.2 ether){
332             amountOfTokens = 200000 * (10**uint256(decimals));
333         }
334         if( _weiAmount == 0.3 ether){
335             amountOfTokens = 300000 * (10**uint256(decimals));
336         }
337         if( _weiAmount == 0.4 ether){
338             amountOfTokens = 400000 * (10**uint256(decimals));
339         }
340         if( _weiAmount == 0.5 ether){
341             amountOfTokens =  500000 * (10**uint256(decimals));
342         }
343         if( _weiAmount == 0.6 ether){
344             amountOfTokens = 600000 * (10**uint256(decimals));
345         }
346         if( _weiAmount == 0.7 ether){
347             amountOfTokens = 700000  * (10**uint256(decimals));
348         }
349         if( _weiAmount == 0.8 ether){
350             amountOfTokens = 800000  * (10**uint256(decimals));
351         }
352         if( _weiAmount == 0.9 ether){
353             amountOfTokens = 900000  * (10**uint256(decimals));
354         }
355         if( _weiAmount == 1 ether){
356             amountOfTokens = 600 * 10**3 * (10**uint256(decimals));
357         }
358         return amountOfTokens;
359     }
360 
361 
362     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
363         require(_to != address(0));
364         require(_amount <= balances[_owner]);
365 
366         balances[_to] = balances[_to].add(_amount);
367         balances[_owner] = balances[_owner].sub(_amount);
368         Transfer(_owner, _to, _amount);
369         return true;
370     }
371 
372     modifier onlyOwner() {
373         require(msg.sender == owner);
374         _;
375     }
376 
377     function changeOwner(address _newOwner) onlyOwner public returns (bool){
378         require(_newOwner != address(0));
379         OwnerChanged(owner, _newOwner);
380         owner = _newOwner;
381         return true;
382     }
383 
384     function startSale() public onlyOwner {
385         saleToken = true;
386     }
387 
388     function stopSale() public onlyOwner {
389         saleToken = false;
390     }
391 
392     function enableTransfers(bool _transfersEnabled) onlyOwner public {
393         transfersEnabled = _transfersEnabled;
394     }
395 
396     /**
397      * Peterson's Law Protection
398      * Claim tokens
399      */
400     function claimTokens() public onlyOwner {
401         owner.transfer(this.balance);
402         uint256 balance = balanceOf(this);
403         transfer(owner, balance);
404         Transfer(this, owner, balance);
405     }
406 }