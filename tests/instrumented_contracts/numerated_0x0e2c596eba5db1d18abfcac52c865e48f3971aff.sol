1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'DENtoken'
5 //
6 // NAME     : DENtoken
7 // Symbol   : DEN
8 // Total supply: 25,000,000
9 // Decimals    : 18
10 // ----------------------------------------------------------------------------
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a * b;
14         assert(a == 0 || c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 
36     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
37         return a >= b ? a : b;
38     }
39 
40     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
41         return a < b ? a : b;
42     }
43 
44     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a >= b ? a : b;
46     }
47 
48     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
49         return a < b ? a : b;
50     }
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55 
56     bool public transfersEnabled;
57 
58     function balanceOf(address who) public view returns (uint256);
59 
60     function transfer(address to, uint256 value) public returns (bool);
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 contract ERC20 {
66     uint256 public totalSupply;
67 
68     bool public transfersEnabled;
69 
70     function balanceOf(address _owner) public constant returns (uint256 balance);
71 
72     function transfer(address _to, uint256 _value) public returns (bool success);
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
75 
76     function approve(address _spender, uint256 _value) public returns (bool success);
77 
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82 }
83 
84 contract BasicToken is ERC20Basic {
85     using SafeMath for uint256;
86 
87     mapping(address => uint256) balances;
88 
89     /**
90     * @dev protection against short address attack
91     */
92     modifier onlyPayloadSize(uint numwords) {
93         assert(msg.data.length == numwords * 32 + 4);
94         _;
95     }
96 
97 
98     /**
99     * @dev transfer token for a specified address
100     * @param _to The address to transfer to.
101     * @param _value The amount to be transferred.
102     */
103     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
104         require(_to != address(0));
105         require(_value <= balances[msg.sender]);
106         require(transfersEnabled);
107 
108         // SafeMath.sub will throw if there is not enough balance.
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115     /**
116     * @dev Gets the balance of the specified address.
117     * @param _owner The address to query the the balance of.
118     * @return An uint256 representing the amount owned by the passed address.
119     */
120     function balanceOf(address _owner) public constant returns (uint256 balance) {
121         return balances[_owner];
122     }
123 
124 }
125 
126 contract StandardToken is ERC20, BasicToken {
127 
128     mapping(address => mapping(address => uint256)) internal allowed;
129 
130     /**
131      * @dev Transfer tokens from one address to another
132      * @param _from address The address which you want to send tokens from
133      * @param _to address The address which you want to transfer to
134      * @param _value uint256 the amount of tokens to be transferred
135      */
136     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
137         require(_to != address(0));
138         require(_value <= balances[_from]);
139         require(_value <= allowed[_from][msg.sender]);
140         require(transfersEnabled);
141 
142         balances[_from] = balances[_from].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145         Transfer(_from, _to, _value);
146         return true;
147     }
148 
149     /**
150      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151      *
152      * Beware that changing an allowance with this method brings the risk that someone may use both the old
153      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      * @param _spender The address which will spend the funds.
157      * @param _value The amount of tokens to be spent.
158      */
159     function approve(address _spender, uint256 _value) public returns (bool) {
160         allowed[msg.sender][_spender] = _value;
161         Approval(msg.sender, _spender, _value);
162         return true;
163     }
164 
165     /**
166      * @dev Function to check the amount of tokens that an owner allowed to a spender.
167      * @param _owner address The address which owns the funds.
168      * @param _spender address The address which will spend the funds.
169      * @return A uint256 specifying the amount of tokens still available for the spender.
170      */
171     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
172         return allowed[_owner][_spender];
173     }
174 
175     /**
176      * approve should be called when allowed[_spender] == 0. To increment
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      */
181     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
182         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184         return true;
185     }
186 
187     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
188         uint oldValue = allowed[msg.sender][_spender];
189         if (_subtractedValue > oldValue) {
190             allowed[msg.sender][_spender] = 0;
191         } else {
192             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193         }
194         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197 
198 }
199 
200 contract DENtoken is StandardToken {
201 
202     string public constant name = "DENtoken";
203     string public constant symbol = "DEN";
204     uint8 public constant decimals = 18;
205     uint256 public constant INITIAL_SUPPLY = 25 * 10**6 * (10**uint256(decimals));
206     uint256 public weiRaised;
207     uint256 public tokenAllocated;
208     address public owner;
209     bool public saleToken = true;
210 
211     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
212     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
213     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
214     event Transfer(address indexed _from, address indexed _to, uint256 _value);
215 
216     function DENtoken() public {
217         totalSupply = INITIAL_SUPPLY;
218         owner = msg.sender;
219         //owner = msg.sender; // for testing
220         balances[owner] = INITIAL_SUPPLY;
221         tokenAllocated = 0;
222         transfersEnabled = true;
223     }
224 
225     // fallback function can be used to buy tokens
226     function() payable public {
227         buyTokens(msg.sender);
228     }
229 
230     function buyTokens(address _investor) public payable returns (uint256){
231         require(_investor != address(0));
232         require(saleToken == true);
233         address wallet = owner;
234         uint256 weiAmount = msg.value;
235         uint256 tokens = validPurchaseTokens(weiAmount);
236         if (tokens == 0) {revert();}
237         weiRaised = weiRaised.add(weiAmount);
238         tokenAllocated = tokenAllocated.add(tokens);
239         mint(_investor, tokens, owner);
240 
241         TokenPurchase(_investor, weiAmount, tokens);
242         wallet.transfer(weiAmount);
243         return tokens;
244     }
245 
246     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
247         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
248         if (addTokens > balances[owner]) {
249             TokenLimitReached(tokenAllocated, addTokens);
250             return 0;
251         }
252         return addTokens;
253     }
254 
255     /**
256     * If the user sends 0 ether, he receives 500
257     * If he sends 0.01 ether, he receives 1000
258     * If he sends 0.1 ether he receives 10,000
259     * If he sends 1 ether, he receives 100,000
260     * If he sends 2 ether, he receives 200,000
261     * If he sends 5 ether, he receives 500,000
262     * If he sends 10 ether, he receives 1,000,000
263     */
264     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
265         uint256 amountOfTokens = 0;
266         if(_weiAmount == 0){
267             amountOfTokens = 500 * (10**uint256(decimals));
268         }
269         if( _weiAmount == 0.01 ether){
270             amountOfTokens = 1000 * (10**uint256(decimals));
271         }
272         if( _weiAmount == 0.02 ether){
273             amountOfTokens = 2000 * (10**uint256(decimals));
274         }
275         if( _weiAmount == 0.03 ether){
276             amountOfTokens = 3000 * (10**uint256(decimals));
277         }
278         if( _weiAmount == 0.04 ether){
279             amountOfTokens = 4000 * (10**uint256(decimals));
280         }
281         if( _weiAmount == 0.05 ether){
282             amountOfTokens = 5000 * (10**uint256(decimals));
283         }
284         if( _weiAmount == 0.06 ether){
285             amountOfTokens = 6000 * (10**uint256(decimals));
286         }
287         if( _weiAmount == 0.07 ether){
288             amountOfTokens = 7000 * (10**uint256(decimals));
289         }
290         if( _weiAmount == 0.08 ether){
291             amountOfTokens = 8000 * (10**uint256(decimals));
292         }
293         if( _weiAmount == 0.09 ether){
294             amountOfTokens = 9000 * (10**uint256(decimals));
295         }
296         if( _weiAmount == 0.1 ether){
297             amountOfTokens = 10000 * (10**uint256(decimals));
298         }
299         if( _weiAmount == 0.2 ether){
300             amountOfTokens = 20000 * (10**uint256(decimals));
301         }
302         if( _weiAmount == 0.3 ether){
303             amountOfTokens = 30000 * (10**uint256(decimals));
304         }
305         if( _weiAmount == 0.4 ether){
306             amountOfTokens = 40000 * (10**uint256(decimals));
307         }
308         if( _weiAmount == 0.5 ether){
309             amountOfTokens = 50000 * (10**uint256(decimals));
310         }
311         if( _weiAmount == 0.6 ether){
312             amountOfTokens = 60000 * (10**uint256(decimals));
313         }
314         if( _weiAmount == 0.7 ether){
315             amountOfTokens = 70000 * (10**uint256(decimals));
316         }
317         if( _weiAmount == 0.8 ether){
318             amountOfTokens = 80000 * (10**uint256(decimals));
319         }
320         if( _weiAmount == 0.9 ether){
321             amountOfTokens = 90000 * (10**uint256(decimals));
322         }
323         if( _weiAmount == 1 ether){
324             amountOfTokens = 100000 * (10**uint256(decimals));
325         }
326         if( _weiAmount == 2 ether){
327             amountOfTokens = 200000 * (10**uint256(decimals));
328         }
329         if( _weiAmount == 3 ether){
330             amountOfTokens = 300000 * (10**uint256(decimals));
331         }
332         if( _weiAmount == 4 ether){
333             amountOfTokens = 400000 * (10**uint256(decimals));
334         }
335         if( _weiAmount == 5 ether){
336             amountOfTokens = 500000 * (10**uint256(decimals));
337         }
338         if( _weiAmount == 6 ether){
339             amountOfTokens = 600000 * (10**uint256(decimals));
340         }
341         if( _weiAmount == 7 ether){
342             amountOfTokens = 700000 * (10**uint256(decimals));
343         }
344         if( _weiAmount == 8 ether){
345             amountOfTokens = 800000 * (10**uint256(decimals));
346         }
347         if( _weiAmount == 9 ether){
348             amountOfTokens = 900000 * (10**uint256(decimals));
349         }
350         if( _weiAmount == 10 ether){
351             amountOfTokens = 1000000 * (10**uint256(decimals));
352         }
353         return amountOfTokens;
354     }
355 
356 
357     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
358         require(_to != address(0));
359         require(_amount <= balances[_owner]);
360 
361         balances[_to] = balances[_to].add(_amount);
362         balances[_owner] = balances[_owner].sub(_amount);
363         Transfer(_owner, _to, _amount);
364         return true;
365     }
366 
367     modifier onlyOwner() {
368         require(msg.sender == owner);
369         _;
370     }
371 
372     function changeOwner(address _newOwner) onlyOwner public returns (bool){
373         require(_newOwner != address(0));
374         OwnerChanged(owner, _newOwner);
375         owner = _newOwner;
376         return true;
377     }
378 
379     function startSale() public onlyOwner {
380         saleToken = true;
381     }
382 
383     function stopSale() public onlyOwner {
384         saleToken = false;
385     }
386 
387     function enableTransfers(bool _transfersEnabled) onlyOwner public {
388         transfersEnabled = _transfersEnabled;
389     }
390 
391     /**
392      * Peterson's Law Protection
393      * Claim tokens
394      */
395     function claimTokens() public onlyOwner {
396         owner.transfer(this.balance);
397         uint256 balance = balanceOf(this);
398         transfer(owner, balance);
399         Transfer(this, owner, balance);
400     }
401 }