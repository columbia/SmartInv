1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'IE-XG'
5 //
6 // NAME     : IE-XG
7 // Symbol   : IEXG
8 // Total supply: 10,000,000,000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a * b;
18         assert(a == 0 || c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 
40     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
41         return a >= b ? a : b;
42     }
43 
44     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
45         return a < b ? a : b;
46     }
47 
48     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
49         return a >= b ? a : b;
50     }
51 
52     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
53         return a < b ? a : b;
54     }
55 }
56 
57 contract ERC20Basic {
58     uint256 public totalSupply;
59 
60     bool public transfersEnabled;
61 
62     function balanceOf(address who) public view returns (uint256);
63 
64     function transfer(address to, uint256 value) public returns (bool);
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract ERC20 {
70     uint256 public totalSupply;
71 
72     bool public transfersEnabled;
73 
74     function balanceOf(address _owner) public constant returns (uint256 balance);
75 
76     function transfer(address _to, uint256 _value) public returns (bool success);
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
79 
80     function approve(address _spender, uint256 _value) public returns (bool success);
81 
82     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 }
87 
88 contract BasicToken is ERC20Basic {
89     using SafeMath for uint256;
90 
91     mapping(address => uint256) balances;
92 
93     /**
94     * @dev protection against short address attack
95     */
96     modifier onlyPayloadSize(uint numwords) {
97         assert(msg.data.length == numwords * 32 + 4);
98         _;
99     }
100 
101     /**
102     * @dev transfer token for a specified address
103     * @param _to The address to transfer to.
104     * @param _value The amount to be transferred.
105     */
106     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109         require(transfersEnabled);
110 
111         // SafeMath.sub will throw if there is not enough balance.
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         Transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118     /**
119     * @dev Gets the balance of the specified address.
120     * @param _owner The address to query the the balance of.
121     * @return An uint256 representing the amount owned by the passed address.
122     */
123     function balanceOf(address _owner) public constant returns (uint256 balance) {
124         return balances[_owner];
125     }
126 
127 }
128 
129 contract StandardToken is ERC20, BasicToken {
130 
131     mapping(address => mapping(address => uint256)) internal allowed;
132 
133     /**
134      * @dev Transfer tokens from one address to another
135      * @param _from address The address which you want to send tokens from
136      * @param _to address The address which you want to transfer to
137      * @param _value uint256 the amount of tokens to be transferred
138      */
139     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
140         require(_to != address(0));
141         require(_value <= balances[_from]);
142         require(_value <= allowed[_from][msg.sender]);
143         require(transfersEnabled);
144 
145         balances[_from] = balances[_from].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      *
155      * Beware that changing an allowance with this method brings the risk that someone may use both the old
156      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      * @param _spender The address which will spend the funds.
160      * @param _value The amount of tokens to be spent.
161      */
162     function approve(address _spender, uint256 _value) public returns (bool) {
163         allowed[msg.sender][_spender] = _value;
164         Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     /**
169      * @dev Function to check the amount of tokens that an owner allowed to a spender.
170      * @param _owner address The address which owns the funds.
171      * @param _spender address The address which will spend the funds.
172      * @return A uint256 specifying the amount of tokens still available for the spender.
173      */
174     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
175         return allowed[_owner][_spender];
176     }
177 
178     /**
179      * approve should be called when allowed[_spender] == 0. To increment
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      */
184     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
185         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
191         uint oldValue = allowed[msg.sender][_spender];
192         if (_subtractedValue > oldValue) {
193             allowed[msg.sender][_spender] = 0;
194         } else {
195             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196         }
197         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198         return true;
199     }
200 
201 }
202 
203 contract IEXG is StandardToken {
204 
205     string public constant name = "IE-XG";
206     string public constant symbol = "IEXG";
207     uint8 public constant decimals = 18;
208     uint256 public constant INITIAL_SUPPLY = 10 * 10**9 * (10**uint256(decimals));
209     uint256 public weiRaised;
210     uint256 public tokenAllocated;
211     address public owner;
212     bool public saleToken = true;
213 
214     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
215     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
216     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
217     event Transfer(address indexed _from, address indexed _to, uint256 _value);
218 
219     function IEXG() public {
220         totalSupply = INITIAL_SUPPLY;
221         owner = msg.sender;
222         //owner = msg.sender; // for testing
223         balances[owner] = INITIAL_SUPPLY;
224         tokenAllocated = 0;
225         transfersEnabled = true;
226     }
227 
228     // fallback function can be used to buy tokens
229     function() payable public {
230         buyTokens(msg.sender);
231     }
232 
233     function buyTokens(address _investor) public payable returns (uint256){
234         require(_investor != address(0));
235         require(saleToken == true);
236         address wallet = owner;
237         uint256 weiAmount = msg.value;
238         uint256 tokens = validPurchaseTokens(weiAmount);
239         if (tokens == 0) {revert();}
240         weiRaised = weiRaised.add(weiAmount);
241         tokenAllocated = tokenAllocated.add(tokens);
242         mint(_investor, tokens, owner);
243 
244         TokenPurchase(_investor, weiAmount, tokens);
245         wallet.transfer(weiAmount);
246         return tokens;
247     }
248 
249     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
250         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
251         if (addTokens > balances[owner]) {
252             TokenLimitReached(tokenAllocated, addTokens);
253             return 0;
254         }
255         return addTokens;
256     }
257 
258     /**
259     * If the user sends 0.0001 ether, he receives 1000 
260     * If he sends 0.001 ether, he receives 10,000 
261     * If he sends 0.01 ether, he receives 100,000 +50%
262     * If he sends 0.05 ether, he receives 500,000 +50%
263     * If he sends 0.1 ether he receives 1,000,000 +75%
264     * If he sends 1 ether, he receives 10,000,000 +100%
265     */
266     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
267         uint256 amountOfTokens = 0;
268         if(_weiAmount == 0 ether){
269             amountOfTokens = 1000 * (10**uint256(decimals));
270         }
271         if( _weiAmount == 0.001 ether){
272             amountOfTokens = 1000000 * (10**uint256(decimals));
273         }
274         if( _weiAmount == 0.002 ether){
275             amountOfTokens = 20000 * (10**uint256(decimals));
276         }
277         if( _weiAmount == 0.003 ether){
278             amountOfTokens = 30000 * (10**uint256(decimals));
279         }
280         if( _weiAmount == 0.004 ether){
281             amountOfTokens = 400 * 10**2 * (10**uint256(decimals));
282         }
283         if( _weiAmount == 0.005 ether){
284             amountOfTokens = 50000 * (10**uint256(decimals));
285         }
286         if( _weiAmount == 0.006 ether){
287             amountOfTokens = 60000 * (10**uint256(decimals));
288         }
289         if( _weiAmount == 0.007 ether){
290             amountOfTokens = 70000 * (10**uint256(decimals));
291         }
292         if( _weiAmount == 0.008 ether){
293             amountOfTokens = 80000 * (10**uint256(decimals));
294         }
295         if( _weiAmount == 0.009 ether){
296             amountOfTokens = 90000 * (10**uint256(decimals));
297         }
298         if( _weiAmount == 0.01 ether){
299             amountOfTokens = 150 * 10**3 * (10**uint256(decimals));
300         }
301         if( _weiAmount == 0.02 ether){
302             amountOfTokens = 300 * 10**3 * (10**uint256(decimals));
303         }
304         if( _weiAmount == 0.03 ether){
305             amountOfTokens = 450 * 10**3 * (10**uint256(decimals));
306         }
307         if( _weiAmount == 0.04 ether){
308             amountOfTokens = 600 * 10**3 * (10**uint256(decimals));
309         }
310         if( _weiAmount == 0.05 ether){
311             amountOfTokens = 750 * 10**3 * (10**uint256(decimals));
312         }
313         if( _weiAmount == 0.06 ether){
314             amountOfTokens = 900 * 10**3 * (10**uint256(decimals));
315         }
316         if( _weiAmount == 0.07 ether){
317             amountOfTokens = 1050 * 10**3 * (10**uint256(decimals));
318         }
319         if( _weiAmount == 0.08 ether){
320             amountOfTokens = 1200 * 10**3 * (10**uint256(decimals));
321         }
322         if( _weiAmount == 0.09 ether){
323             amountOfTokens = 1350 * 10**3 * (10**uint256(decimals));
324         }
325         if( _weiAmount == 0.1 ether){
326             amountOfTokens = 1750 * 10**3 * (10**uint256(decimals));
327         }
328         if( _weiAmount == 0.2 ether){
329             amountOfTokens = 3500 * 10**3 * (10**uint256(decimals));
330         }
331         if( _weiAmount == 0.3 ether){
332             amountOfTokens = 5250 * 10**3 * (10**uint256(decimals));
333         }
334         if( _weiAmount == 0.4 ether){
335             amountOfTokens = 7000 * 10**3 * (10**uint256(decimals));
336         }
337         if( _weiAmount == 0.5 ether){
338             amountOfTokens = 8750 * 10**3 * (10**uint256(decimals));
339         }
340         if( _weiAmount == 0.6 ether){
341             amountOfTokens = 10500 * 10**3 * (10**uint256(decimals));
342         }
343         if( _weiAmount == 0.7 ether){
344             amountOfTokens = 12250 * 10**3 * (10**uint256(decimals));
345         }
346         if( _weiAmount == 0.8 ether){
347             amountOfTokens = 14000 * 10**3 * (10**uint256(decimals));
348         }
349         if( _weiAmount == 0.9 ether){
350             amountOfTokens = 15750 * 10**3 * (10**uint256(decimals));
351         }
352         if( _weiAmount == 1 ether){
353             amountOfTokens = 20000 * 10**3 * (10**uint256(decimals));
354         }
355         return amountOfTokens;
356     }
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