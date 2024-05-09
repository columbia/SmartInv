1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'ZeroXCoin'
5 //
6 // NAME     : ZeroXCoin
7 // Symbol   : ZXC
8 // Total supply: 3,000,000,000
9 // Decimals    : 8
10 // PLEASE SUPPORT THIS PROJECT
11 //
12 // (c) ZeroXCoin TEAM 2018 .The MIT Licence.
13 // -----------------=-----------------------------------------------------------
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 
39     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
40         return a >= b ? a : b;
41     }
42 
43     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
44         return a < b ? a : b;
45     }
46 
47     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a >= b ? a : b;
49     }
50 
51     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a < b ? a : b;
53     }
54 }
55 
56 contract ERC20Basic {
57     uint256 public totalSupply;
58 
59     bool public transfersEnabled;
60 
61     function balanceOf(address who) public view returns (uint256);
62 
63     function transfer(address to, uint256 value) public returns (bool);
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 {
69     uint256 public totalSupply;
70 
71     bool public transfersEnabled;
72 
73     function balanceOf(address _owner) public constant returns (uint256 balance);
74 
75     function transfer(address _to, uint256 _value) public returns (bool success);
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
78 
79     function approve(address _spender, uint256 _value) public returns (bool success);
80 
81     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
82 
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 }
86 
87 contract BasicToken is ERC20Basic {
88     using SafeMath for uint256;
89 
90     mapping(address => uint256) balances;
91 
92     /**
93     * @dev protection against short address attack
94     */
95     modifier onlyPayloadSize(uint numwords) {
96         assert(msg.data.length == numwords * 32 + 4);
97         _;
98     }
99 
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
203 contract ZeroXCoin is StandardToken {
204 
205     string public constant name = "ZeroXCoin";
206     string public constant symbol = "ZXC";
207     uint8 public constant decimals = 8;
208     uint256 public constant INITIAL_SUPPLY = 3 * 10**9 * (10**uint256(decimals));
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
219     function ZeroXCoin() public {
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
259     * If the user sends 0 ether, he receives 5,000 
260     * If he sends 0.001 ether, he receives 50,000 
261     * If he sends 0.005 ether, he receives 250,000 +20%
262     * If he sends 0.01 ether, he receives 500,000 +40%
263     * If he sends 0.1 ether he receives 5,000,000 +60%
264     * If he sends 1 ether, he receives 50,000,000 +90%
265     */
266     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
267         uint256 amountOfTokens = 0;
268         if(_weiAmount == 0){
269             amountOfTokens = 5000 * (10**uint256(decimals));
270         }
271         if( _weiAmount == 0.001 ether){
272             amountOfTokens = 50 * 10**3 * (10**uint256(decimals));
273         }
274         if( _weiAmount == 0.002 ether){
275             amountOfTokens = 100 * 10**3 * (10**uint256(decimals));
276         }
277         if( _weiAmount == 0.003 ether){
278             amountOfTokens = 150 * 10**3 * (10**uint256(decimals));
279         }
280         if( _weiAmount == 0.004 ether){
281             amountOfTokens = 200 * 10**3 * (10**uint256(decimals));
282         }
283         if( _weiAmount == 0.005 ether){
284             amountOfTokens = 300000 * (10**uint256(decimals));
285         }
286         if( _weiAmount == 0.006 ether){
287             amountOfTokens = 360000 * (10**uint256(decimals));
288         }
289         if( _weiAmount == 0.007 ether){
290             amountOfTokens = 420000 * (10**uint256(decimals));
291         }
292         if( _weiAmount == 0.008 ether){
293             amountOfTokens = 480000 * (10**uint256(decimals));
294         }
295         if( _weiAmount == 0.009 ether){
296             amountOfTokens = 540000 * (10**uint256(decimals));
297         }
298         if( _weiAmount == 0.01 ether){
299             amountOfTokens = 700 * 10**3 * (10**uint256(decimals));
300         }
301         if( _weiAmount == 0.02 ether){
302             amountOfTokens = 1400 * 10**3 * (10**uint256(decimals));
303         }
304         if( _weiAmount == 0.03 ether){
305             amountOfTokens = 2100 * 10**3 * (10**uint256(decimals));
306         }
307         if( _weiAmount == 0.04 ether){
308             amountOfTokens = 2800 * 10**3 * (10**uint256(decimals));
309         }
310         if( _weiAmount == 0.05 ether){
311             amountOfTokens = 3500 * 10**3 * (10**uint256(decimals));
312         }
313         if( _weiAmount == 0.06 ether){
314             amountOfTokens = 4200 * 10**3 * (10**uint256(decimals));
315         }
316         if( _weiAmount == 0.07 ether){
317             amountOfTokens = 4900 * 10**3 * (10**uint256(decimals));
318         }
319         if( _weiAmount == 0.08 ether){
320             amountOfTokens = 5600 * 10**3 * (10**uint256(decimals));
321         }
322         if( _weiAmount == 0.09 ether){
323             amountOfTokens = 6300 * 10**3 * (10**uint256(decimals));
324         }
325         if( _weiAmount == 0.1 ether){
326             amountOfTokens = 8000 * 10**3 * (10**uint256(decimals));
327         }
328         if( _weiAmount == 0.2 ether){
329             amountOfTokens = 16000 * 10**3 * (10**uint256(decimals));
330         }
331         if( _weiAmount == 0.3 ether){
332             amountOfTokens = 24000 * 10**3 * (10**uint256(decimals));
333         }
334         if( _weiAmount == 0.4 ether){
335             amountOfTokens = 32000 * 10**3 * (10**uint256(decimals));
336         }
337         if( _weiAmount == 0.5 ether){
338             amountOfTokens = 40000 * 10**3 * (10**uint256(decimals));
339         }
340         if( _weiAmount == 0.6 ether){
341             amountOfTokens = 48000 * 10**3 * (10**uint256(decimals));
342         }
343         if( _weiAmount == 0.7 ether){
344             amountOfTokens = 56000 * 10**3 * (10**uint256(decimals));
345         }
346         if( _weiAmount == 0.8 ether){
347             amountOfTokens = 64000 * 10**3 * (10**uint256(decimals));
348         }
349         if( _weiAmount == 0.9 ether){
350             amountOfTokens = 79000 * 10**3 * (10**uint256(decimals));
351         }
352         if( _weiAmount == 1 ether){
353             amountOfTokens = 95000 * 10**3 * (10**uint256(decimals));
354         }
355         return amountOfTokens;
356     }
357 
358 
359     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
360         require(_to != address(0));
361         require(_amount <= balances[_owner]);
362 
363         balances[_to] = balances[_to].add(_amount);
364         balances[_owner] = balances[_owner].sub(_amount);
365         Transfer(_owner, _to, _amount);
366         return true;
367     }
368 
369     modifier onlyOwner() {
370         require(msg.sender == owner);
371         _;
372     }
373 
374     function changeOwner(address _newOwner) onlyOwner public returns (bool){
375         require(_newOwner != address(0));
376         OwnerChanged(owner, _newOwner);
377         owner = _newOwner;
378         return true;
379     }
380 
381     function startSale() public onlyOwner {
382         saleToken = true;
383     }
384 
385     function stopSale() public onlyOwner {
386         saleToken = false;
387     }
388 
389     function enableTransfers(bool _transfersEnabled) onlyOwner public {
390         transfersEnabled = _transfersEnabled;
391     }
392 
393     /**
394      * Peterson's Law Protection
395      * Claim tokens
396      */
397     function claimTokens() public onlyOwner {
398         owner.transfer(this.balance);
399         uint256 balance = balanceOf(this);
400         transfer(owner, balance);
401         Transfer(this, owner, balance);
402     }
403 }