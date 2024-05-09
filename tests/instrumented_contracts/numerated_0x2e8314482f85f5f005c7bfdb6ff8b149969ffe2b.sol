1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // NAME     : Fresh Token
5 // Symbol   : FREX
6 // Total supply: 5,000,000,000
7 // Decimals    : 8
8 //
9 // Enjoy.
10 //
11 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
12 // ----------------------------------------------------------------------------
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 
38     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
39         return a >= b ? a : b;
40     }
41 
42     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
43         return a < b ? a : b;
44     }
45 
46     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
47         return a >= b ? a : b;
48     }
49 
50     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a < b ? a : b;
52     }
53 }
54 
55 contract ERC20Basic {
56     uint256 public totalSupply;
57 
58     bool public transfersEnabled;
59 
60     function balanceOf(address who) public view returns (uint256);
61 
62     function transfer(address to, uint256 value) public returns (bool);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract ERC20 {
68     uint256 public totalSupply;
69 
70     bool public transfersEnabled;
71 
72     function balanceOf(address _owner) public constant returns (uint256 balance);
73 
74     function transfer(address _to, uint256 _value) public returns (bool success);
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
77 
78     function approve(address _spender, uint256 _value) public returns (bool success);
79 
80     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84 }
85 
86 contract BasicToken is ERC20Basic {
87     using SafeMath for uint256;
88 
89     mapping(address => uint256) balances;
90 
91     /**
92     * @dev protection against short address attack
93     */
94     modifier onlyPayloadSize(uint numwords) {
95         assert(msg.data.length == numwords * 32 + 4);
96         _;
97     }
98 
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[msg.sender]);
108         require(transfersEnabled);
109 
110         // SafeMath.sub will throw if there is not enough balance.
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param _owner The address to query the the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address _owner) public constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126 }
127 
128 contract StandardToken is ERC20, BasicToken {
129 
130     mapping(address => mapping(address => uint256)) internal allowed;
131 
132     /**
133      * @dev Transfer tokens from one address to another
134      * @param _from address The address which you want to send tokens from
135      * @param _to address The address which you want to transfer to
136      * @param _value uint256 the amount of tokens to be transferred
137      */
138     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
139         require(_to != address(0));
140         require(_value <= balances[_from]);
141         require(_value <= allowed[_from][msg.sender]);
142         require(transfersEnabled);
143 
144         balances[_from] = balances[_from].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147         Transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      *
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param _spender The address which will spend the funds.
159      * @param _value The amount of tokens to be spent.
160      */
161     function approve(address _spender, uint256 _value) public returns (bool) {
162         allowed[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Function to check the amount of tokens that an owner allowed to a spender.
169      * @param _owner address The address which owns the funds.
170      * @param _spender address The address which will spend the funds.
171      * @return A uint256 specifying the amount of tokens still available for the spender.
172      */
173     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
174         return allowed[_owner][_spender];
175     }
176 
177     /**
178      * approve should be called when allowed[_spender] == 0. To increment
179      * allowed value is better to use this function to avoid 2 calls (and wait until
180      * the first transaction is mined)
181      * From MonolithDAO Token.sol
182      */
183     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
184         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186         return true;
187     }
188 
189     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
190         uint oldValue = allowed[msg.sender][_spender];
191         if (_subtractedValue > oldValue) {
192             allowed[msg.sender][_spender] = 0;
193         } else {
194             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195         }
196         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 
200 }
201 
202 contract FREX is StandardToken {
203 
204     string public constant name = "Fresh Token";
205     string public constant symbol = "FREX";
206     uint8 public constant decimals = 8;
207     uint256 public constant INITIAL_SUPPLY = 50 * 10**9 * (10**uint256(decimals));
208     uint256 public weiRaised;
209     uint256 public tokenAllocated;
210     address public owner;
211     bool public saleToken = true;
212 
213     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
214     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
215     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
216     event Transfer(address indexed _from, address indexed _to, uint256 _value);
217 
218     function FREX() public {
219         totalSupply = INITIAL_SUPPLY;
220         owner = msg.sender;
221         //owner = msg.sender; // for testing
222         balances[owner] = INITIAL_SUPPLY;
223         tokenAllocated = 0;
224         transfersEnabled = true;
225     }
226 
227     // fallback function can be used to buy tokens
228     function() payable public {
229         buyTokens(msg.sender);
230     }
231 
232     function buyTokens(address _investor) public payable returns (uint256){
233         require(_investor != address(0));
234         require(saleToken == true);
235         address wallet = owner;
236         uint256 weiAmount = msg.value;
237         uint256 tokens = validPurchaseTokens(weiAmount);
238         if (tokens == 0) {revert();}
239         weiRaised = weiRaised.add(weiAmount);
240         tokenAllocated = tokenAllocated.add(tokens);
241         mint(_investor, tokens, owner);
242 
243         TokenPurchase(_investor, weiAmount, tokens);
244         wallet.transfer(weiAmount);
245         return tokens;
246     }
247 
248     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
249         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
250         if (addTokens > balances[owner]) {
251             TokenLimitReached(tokenAllocated, addTokens);
252             return 0;
253         }
254         return addTokens;
255     }
256 
257     /**
258     * If the user sends 0 ether, he receives 25,000
259     * If he sends 0.001 ether, he receives 150,000 
260     * If he sends 0.01 ether, he receives 1,500,000 +100%
261     * If he sends 0.05 ether, he receives 7,500,000
262     * If he sends 0.1 ether he receives 15,000,000
263     * If he sends 1 ether, he receives 150,000,000
264     */
265     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
266         uint256 amountOfTokens = 0;
267         if(_weiAmount == 0){
268             amountOfTokens = 25000 * (10**uint256(decimals));
269         }
270         if( _weiAmount == 0.001 ether){
271             amountOfTokens = 150 * 10**3 * (10**uint256(decimals));
272         }
273         if( _weiAmount == 0.002 ether){
274             amountOfTokens = 300 * 10**3 * (10**uint256(decimals));
275         }
276         if( _weiAmount == 0.003 ether){
277             amountOfTokens = 450 * 10**3 * (10**uint256(decimals));
278         }
279         if( _weiAmount == 0.004 ether){
280             amountOfTokens = 600 * 10**3 * (10**uint256(decimals));
281         }
282         if( _weiAmount == 0.005 ether){
283             amountOfTokens = 750000 * (10**uint256(decimals));
284         }
285         if( _weiAmount == 0.006 ether){
286             amountOfTokens = 900000 * (10**uint256(decimals));
287         }
288         if( _weiAmount == 0.007 ether){
289             amountOfTokens = 1050000 * (10**uint256(decimals));
290         }
291         if( _weiAmount == 0.008 ether){
292             amountOfTokens = 1200000 * (10**uint256(decimals));
293         }
294         if( _weiAmount == 0.009 ether){
295             amountOfTokens = 1350000 * (10**uint256(decimals));
296         }
297         if( _weiAmount == 0.01 ether){
298             amountOfTokens = 3000 * 10**3 * (10**uint256(decimals));
299         }
300         if( _weiAmount == 0.02 ether){
301             amountOfTokens = 6000 * 10**3 * (10**uint256(decimals));
302         }
303         if( _weiAmount == 0.03 ether){
304             amountOfTokens = 9000 * 10**3 * (10**uint256(decimals));
305         }
306         if( _weiAmount == 0.04 ether){
307             amountOfTokens = 12000 * 10**3 * (10**uint256(decimals));
308         }
309         if( _weiAmount == 0.05 ether){
310             amountOfTokens = 15000 * 10**3 * (10**uint256(decimals));
311         }
312         if( _weiAmount == 0.06 ether){
313             amountOfTokens = 18000 * 10**3 * (10**uint256(decimals));
314         }
315         if( _weiAmount == 0.07 ether){
316             amountOfTokens = 21000 * 10**3 * (10**uint256(decimals));
317         }
318         if( _weiAmount == 0.08 ether){
319             amountOfTokens = 24000 * 10**3 * (10**uint256(decimals));
320         }
321         if( _weiAmount == 0.09 ether){
322             amountOfTokens = 27000 * 10**3 * (10**uint256(decimals));
323         }
324         if( _weiAmount == 0.1 ether){
325             amountOfTokens = 30000 * 10**3 * (10**uint256(decimals));
326         }
327         if( _weiAmount == 0.2 ether){
328             amountOfTokens = 60000 * 10**3 * (10**uint256(decimals));
329         }
330         if( _weiAmount == 0.3 ether){
331             amountOfTokens = 90000 * 10**3 * (10**uint256(decimals));
332         }
333         if( _weiAmount == 0.4 ether){
334             amountOfTokens = 120000 * 10**3 * (10**uint256(decimals));
335         }
336         if( _weiAmount == 0.5 ether){
337             amountOfTokens = 150000 * 10**3 * (10**uint256(decimals));
338         }
339         if( _weiAmount == 0.6 ether){
340             amountOfTokens = 118000 * 10**3 * (10**uint256(decimals));
341         }
342         if( _weiAmount == 0.7 ether){
343             amountOfTokens = 210000 * 10**3 * (10**uint256(decimals));
344         }
345         if( _weiAmount == 0.8 ether){
346             amountOfTokens = 240000 * 10**3 * (10**uint256(decimals));
347         }
348         if( _weiAmount == 0.9 ether){
349             amountOfTokens = 270000 * 10**3 * (10**uint256(decimals));
350         }
351         if( _weiAmount == 1 ether){
352             amountOfTokens = 300000 * 10**3 * (10**uint256(decimals));
353         }
354         return amountOfTokens;
355     }
356 
357 
358     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
359         require(_to != address(0));
360         require(_amount <= balances[_owner]);
361 
362         balances[_to] = balances[_to].add(_amount);
363         balances[_owner] = balances[_owner].sub(_amount);
364         Transfer(_owner, _to, _amount);
365         return true;
366     }
367 
368     modifier onlyOwner() {
369         require(msg.sender == owner);
370         _;
371     }
372 
373     function changeOwner(address _newOwner) onlyOwner public returns (bool){
374         require(_newOwner != address(0));
375         OwnerChanged(owner, _newOwner);
376         owner = _newOwner;
377         return true;
378     }
379 
380     function startSale() public onlyOwner {
381         saleToken = true;
382     }
383 
384     function stopSale() public onlyOwner {
385         saleToken = false;
386     }
387 
388     function enableTransfers(bool _transfersEnabled) onlyOwner public {
389         transfersEnabled = _transfersEnabled;
390     }
391 
392     /**
393      * Peterson's Law Protection
394      * Claim tokens
395      */
396     function claimTokens() public onlyOwner {
397         owner.transfer(this.balance);
398         uint256 balance = balanceOf(this);
399         transfer(owner, balance);
400         Transfer(this, owner, balance);
401     }
402 }