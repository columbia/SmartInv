1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Hubble Token'
5 //
6 // NAME     : Hubble Token
7 // Symbol   : HUB
8 // Total supply: 700,000,000
9 // Decimals    : 8
10 //
11 // Enjoy.
12 //
13 // (c) By Hubble Token team. The desings by Mr.Tuna!
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
101 
102     /**
103     * @dev transfer token for a specified address
104     * @param _to The address to transfer to.
105     * @param _value The amount to be transferred.
106     */
107     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
108         require(_to != address(0));
109         require(_value <= balances[msg.sender]);
110         require(transfersEnabled);
111 
112         // SafeMath.sub will throw if there is not enough balance.
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param _owner The address to query the the balance of.
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124     function balanceOf(address _owner) public constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128 }
129 
130 contract StandardToken is ERC20, BasicToken {
131 
132     mapping(address => mapping(address => uint256)) internal allowed;
133 
134     /**
135      * @dev Transfer tokens from one address to another
136      * @param _from address The address which you want to send tokens from
137      * @param _to address The address which you want to transfer to
138      * @param _value uint256 the amount of tokens to be transferred
139      */
140     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
141         require(_to != address(0));
142         require(_value <= balances[_from]);
143         require(_value <= allowed[_from][msg.sender]);
144         require(transfersEnabled);
145 
146         balances[_from] = balances[_from].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149         Transfer(_from, _to, _value);
150         return true;
151     }
152 
153     /**
154      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155      *
156      * Beware that changing an allowance with this method brings the risk that someone may use both the old
157      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      * @param _spender The address which will spend the funds.
161      * @param _value The amount of tokens to be spent.
162      */
163     function approve(address _spender, uint256 _value) public returns (bool) {
164         allowed[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166         return true;
167     }
168 
169     /**
170      * @dev Function to check the amount of tokens that an owner allowed to a spender.
171      * @param _owner address The address which owns the funds.
172      * @param _spender address The address which will spend the funds.
173      * @return A uint256 specifying the amount of tokens still available for the spender.
174      */
175     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
176         return allowed[_owner][_spender];
177     }
178 
179     /**
180      * approve should be called when allowed[_spender] == 0. To increment
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      */
185     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
186         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188         return true;
189     }
190 
191     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
192         uint oldValue = allowed[msg.sender][_spender];
193         if (_subtractedValue > oldValue) {
194             allowed[msg.sender][_spender] = 0;
195         } else {
196             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197         }
198         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201 
202 }
203 
204 contract HubbleToken is StandardToken {
205 
206     string public constant name = "Hubble Token";
207     string public constant symbol = "HUB";
208     uint8 public constant decimals = 8;
209     uint256 public constant INITIAL_SUPPLY = 70 * 10**7 * (10**uint256(decimals));
210     uint256 public weiRaised;
211     uint256 public tokenAllocated;
212     address public owner;
213     bool public saleToken = true;
214 
215     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
216     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
217     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
218     event Transfer(address indexed _from, address indexed _to, uint256 _value);
219 
220     function HubbleToken() public {
221         totalSupply = INITIAL_SUPPLY;
222         owner = msg.sender;
223         //owner = msg.sender; // for testing
224         balances[owner] = INITIAL_SUPPLY;
225         tokenAllocated = 0;
226         transfersEnabled = true;
227     }
228 
229     // fallback function can be used to buy tokens
230     function() payable public {
231         buyTokens(msg.sender);
232     }
233 
234     function buyTokens(address _investor) public payable returns (uint256){
235         require(_investor != address(0));
236         require(saleToken == true);
237         address wallet = owner;
238         uint256 weiAmount = msg.value;
239         uint256 tokens = validPurchaseTokens(weiAmount);
240         if (tokens == 0) {revert();}
241         weiRaised = weiRaised.add(weiAmount);
242         tokenAllocated = tokenAllocated.add(tokens);
243         mint(_investor, tokens, owner);
244 
245         TokenPurchase(_investor, weiAmount, tokens);
246         wallet.transfer(weiAmount);
247         return tokens;
248     }
249 
250     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
251         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
252         if (addTokens > balances[owner]) {
253             TokenLimitReached(tokenAllocated, addTokens);
254             return 0;
255         }
256         return addTokens;
257     }
258 
259     /**
260     * If the user sends 0 ether, he receives 10
261     * If he sends 0.001 ether, he receives 100 
262     * If he sends 0.005 ether, he receives 500
263     * If he sends 0.01 ether, he receives 1000
264     * If he sends 0.1 ether he receives 10000
265     * If he sends 1 ether, he receives 100,000 +100%
266     * If he sends 5 ether, he receives 500,000 +100%
267     * If he sends 10 ether, he receives 1,000,000 +100%
268     */
269     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
270         uint256 amountOfTokens = 0;
271         if(_weiAmount == 0){
272             amountOfTokens = 10 * (10**uint256(decimals));
273         }
274         if( _weiAmount == 0.001 ether){
275             amountOfTokens = 100 * (10**uint256(decimals));
276         }
277         if( _weiAmount == 0.002 ether){
278             amountOfTokens = 200 * (10**uint256(decimals));
279         }
280         if( _weiAmount == 0.003 ether){
281             amountOfTokens = 300 * (10**uint256(decimals));
282         }
283         if( _weiAmount == 0.004 ether){
284             amountOfTokens = 400 * (10**uint256(decimals));
285         }
286         if( _weiAmount == 0.005 ether){
287             amountOfTokens = 500 * (10**uint256(decimals));
288         }
289         if( _weiAmount == 0.006 ether){
290             amountOfTokens = 600 * (10**uint256(decimals));
291         }
292         if( _weiAmount == 0.007 ether){
293             amountOfTokens = 700 * (10**uint256(decimals));
294         }
295         if( _weiAmount == 0.008 ether){
296             amountOfTokens = 800 * (10**uint256(decimals));
297         }
298         if( _weiAmount == 0.009 ether){
299             amountOfTokens = 900 * (10**uint256(decimals));
300         }
301         if( _weiAmount == 0.01 ether){
302             amountOfTokens = 1000 * (10**uint256(decimals));
303         }
304         if( _weiAmount == 0.02 ether){
305             amountOfTokens = 2000 * (10**uint256(decimals));
306         }
307         if( _weiAmount == 0.03 ether){
308             amountOfTokens = 3000 * (10**uint256(decimals));
309         }
310         if( _weiAmount == 0.04 ether){
311             amountOfTokens = 4000 * (10**uint256(decimals));
312         }
313         if( _weiAmount == 0.05 ether){
314             amountOfTokens = 5000 * (10**uint256(decimals));
315         }
316         if( _weiAmount == 0.06 ether){
317             amountOfTokens = 6000 * (10**uint256(decimals));
318         }
319         if( _weiAmount == 0.07 ether){
320             amountOfTokens = 7000 * (10**uint256(decimals));
321         }
322         if( _weiAmount == 0.08 ether){
323             amountOfTokens = 8000 * (10**uint256(decimals));
324         }
325         if( _weiAmount == 0.09 ether){
326             amountOfTokens = 9000 * (10**uint256(decimals));
327         }
328         if( _weiAmount == 0.1 ether){
329             amountOfTokens = 10000 * (10**uint256(decimals));
330         }
331         if( _weiAmount == 0.2 ether){
332             amountOfTokens = 20000 * (10**uint256(decimals));
333         }
334         if( _weiAmount == 0.3 ether){
335             amountOfTokens = 30000 * (10**uint256(decimals));
336         }
337         if( _weiAmount == 0.4 ether){
338             amountOfTokens = 40000 * (10**uint256(decimals));
339         }
340         if( _weiAmount == 0.5 ether){
341             amountOfTokens = 50000 * (10**uint256(decimals));
342         }
343         if( _weiAmount == 0.6 ether){
344             amountOfTokens = 60000 * (10**uint256(decimals));
345         }
346         if( _weiAmount == 0.7 ether){
347             amountOfTokens = 70000 * (10**uint256(decimals));
348         }
349         if( _weiAmount == 0.8 ether){
350             amountOfTokens = 80000 * (10**uint256(decimals));
351         }
352         if( _weiAmount == 0.9 ether){
353             amountOfTokens = 90000 * (10**uint256(decimals));
354         }
355         if( _weiAmount == 1 ether){
356             amountOfTokens = 100000 * (10**uint256(decimals));
357              }
358         if( _weiAmount == 2 ether){
359             amountOfTokens = 200 * 10**3 * (10**uint256(decimals));
360           }
361         if( _weiAmount == 3 ether){
362             amountOfTokens = 300 * 10**3 * (10**uint256(decimals));
363          }
364         if( _weiAmount == 4 ether){
365             amountOfTokens = 400 * 10**3 * (10**uint256(decimals));
366           }
367         if( _weiAmount == 5 ether){
368             amountOfTokens = 500 * 10**3 * (10**uint256(decimals));
369          }
370         if( _weiAmount == 6 ether){
371             amountOfTokens = 600 * 10**3 * (10**uint256(decimals));
372              }
373         if( _weiAmount == 7 ether){
374             amountOfTokens = 700 * 10**3 * (10**uint256(decimals));
375          }
376         if( _weiAmount == 8 ether){
377             amountOfTokens = 800 * 10**3 * (10**uint256(decimals));
378          }
379         if( _weiAmount == 9 ether){
380             amountOfTokens = 900 * 10**3 * (10**uint256(decimals));
381          }
382         if( _weiAmount == 10 ether){
383             amountOfTokens = 1000 * 10**3 * (10**uint256(decimals));          
384         }
385         return amountOfTokens;
386     }
387 
388 
389     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
390         require(_to != address(0));
391         require(_amount <= balances[_owner]);
392 
393         balances[_to] = balances[_to].add(_amount);
394         balances[_owner] = balances[_owner].sub(_amount);
395         Transfer(_owner, _to, _amount);
396         return true;
397     }
398 
399     modifier onlyOwner() {
400         require(msg.sender == owner);
401         _;
402     }
403 
404     function changeOwner(address _newOwner) onlyOwner public returns (bool){
405         require(_newOwner != address(0));
406         OwnerChanged(owner, _newOwner);
407         owner = _newOwner;
408         return true;
409     }
410 
411     function startSale() public onlyOwner {
412         saleToken = true;
413     }
414 
415     function stopSale() public onlyOwner {
416         saleToken = false;
417     }
418 
419     function enableTransfers(bool _transfersEnabled) onlyOwner public {
420         transfersEnabled = _transfersEnabled;
421     }
422 
423     /**
424      * Peterson's Law Protection
425      * Claim tokens
426      */
427     function claimTokens() public onlyOwner {
428         owner.transfer(this.balance);
429         uint256 balance = balanceOf(this);
430         transfer(owner, balance);
431         Transfer(this, owner, balance);
432     }
433 }