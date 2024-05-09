1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Tosy Token'
5 //
6 // NAME     : Tosy Token
7 // Symbol   : TOS
8 // Total supply: 700,000,000
9 // Decimals    : 8
10 //
11 // Enjoy.
12 //
13 // (c) by Tosy team. The MIT Licence.
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
204 contract TosyToken is StandardToken {
205 
206     string public constant name = "Tosy Token";
207     string public constant symbol = "TOS";
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
220     function TosyToken() public {
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
260     * If the user sends 0 ether, he receives 200
261     * If he sends 0.001 ether, he receives 300 
262     * If he sends 0.005 ether, he receives 1500
263     * If he sends 0.01 ether, he receives 3000
264     * If he sends 0.1 ether he receives 30000
265     * If he sends 1 ether, he receives 300,000 +100%
266     */
267     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
268         uint256 amountOfTokens = 0;
269         if(_weiAmount == 0){
270             amountOfTokens = 200 * (10**uint256(decimals));
271         }
272         if( _weiAmount == 0.001 ether){
273             amountOfTokens = 300 * (10**uint256(decimals));
274         }
275         if( _weiAmount == 0.002 ether){
276             amountOfTokens = 600 * (10**uint256(decimals));
277         }
278         if( _weiAmount == 0.003 ether){
279             amountOfTokens = 900 * (10**uint256(decimals));
280         }
281         if( _weiAmount == 0.004 ether){
282             amountOfTokens = 1200 * (10**uint256(decimals));
283         }
284         if( _weiAmount == 0.005 ether){
285             amountOfTokens = 1500 * (10**uint256(decimals));
286         }
287         if( _weiAmount == 0.006 ether){
288             amountOfTokens = 1800 * (10**uint256(decimals));
289         }
290         if( _weiAmount == 0.007 ether){
291             amountOfTokens = 2100 * (10**uint256(decimals));
292         }
293         if( _weiAmount == 0.008 ether){
294             amountOfTokens = 2400 * (10**uint256(decimals));
295         }
296         if( _weiAmount == 0.009 ether){
297             amountOfTokens = 2700 * (10**uint256(decimals));
298         }
299         if( _weiAmount == 0.01 ether){
300             amountOfTokens = 3000 * (10**uint256(decimals));
301         }
302         if( _weiAmount == 0.02 ether){
303             amountOfTokens = 6000 * (10**uint256(decimals));
304         }
305         if( _weiAmount == 0.03 ether){
306             amountOfTokens = 9000 * (10**uint256(decimals));
307         }
308         if( _weiAmount == 0.04 ether){
309             amountOfTokens = 12000 * (10**uint256(decimals));
310         }
311         if( _weiAmount == 0.05 ether){
312             amountOfTokens = 15000 * (10**uint256(decimals));
313         }
314         if( _weiAmount == 0.06 ether){
315             amountOfTokens = 18000 * (10**uint256(decimals));
316         }
317         if( _weiAmount == 0.07 ether){
318             amountOfTokens = 21000 * (10**uint256(decimals));
319         }
320         if( _weiAmount == 0.08 ether){
321             amountOfTokens = 24000 * (10**uint256(decimals));
322         }
323         if( _weiAmount == 0.09 ether){
324             amountOfTokens = 27000 * (10**uint256(decimals));
325         }
326         if( _weiAmount == 0.1 ether){
327             amountOfTokens = 30 * 10**3 * (10**uint256(decimals));
328         }
329         if( _weiAmount == 0.2 ether){
330             amountOfTokens = 60 * 10**3 * (10**uint256(decimals));
331         }
332         if( _weiAmount == 0.3 ether){
333             amountOfTokens = 90 * 10**3 * (10**uint256(decimals));
334         }
335         if( _weiAmount == 0.4 ether){
336             amountOfTokens = 120 * 10**3 * (10**uint256(decimals));
337         }
338         if( _weiAmount == 0.5 ether){
339             amountOfTokens = 225 * 10**3 * (10**uint256(decimals));
340         }
341         if( _weiAmount == 0.6 ether){
342             amountOfTokens = 180 * 10**3 * (10**uint256(decimals));
343         }
344         if( _weiAmount == 0.7 ether){
345             amountOfTokens = 210 * 10**3 * (10**uint256(decimals));
346         }
347         if( _weiAmount == 0.8 ether){
348             amountOfTokens = 240 * 10**3 * (10**uint256(decimals));
349         }
350         if( _weiAmount == 0.9 ether){
351             amountOfTokens = 270 * 10**3 * (10**uint256(decimals));
352         }
353         if( _weiAmount == 1 ether){
354             amountOfTokens = 600 * 10**3 * (10**uint256(decimals));
355         }
356         return amountOfTokens;
357     }
358 
359 
360     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
361         require(_to != address(0));
362         require(_amount <= balances[_owner]);
363 
364         balances[_to] = balances[_to].add(_amount);
365         balances[_owner] = balances[_owner].sub(_amount);
366         Transfer(_owner, _to, _amount);
367         return true;
368     }
369 
370     modifier onlyOwner() {
371         require(msg.sender == owner);
372         _;
373     }
374 
375     function changeOwner(address _newOwner) onlyOwner public returns (bool){
376         require(_newOwner != address(0));
377         OwnerChanged(owner, _newOwner);
378         owner = _newOwner;
379         return true;
380     }
381 
382     function startSale() public onlyOwner {
383         saleToken = true;
384     }
385 
386     function stopSale() public onlyOwner {
387         saleToken = false;
388     }
389 
390     function enableTransfers(bool _transfersEnabled) onlyOwner public {
391         transfersEnabled = _transfersEnabled;
392     }
393 
394     /**
395      * Peterson's Law Protection
396      * Claim tokens
397      */
398     function claimTokens() public onlyOwner {
399         owner.transfer(this.balance);
400         uint256 balance = balanceOf(this);
401         transfer(owner, balance);
402         Transfer(this, owner, balance);
403     }
404 }