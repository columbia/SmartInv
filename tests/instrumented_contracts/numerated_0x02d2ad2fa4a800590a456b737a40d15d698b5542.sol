1 /**
2  *Submitted for verification at Etherscan.io on 2018-12-01
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 // ----------------------------------------------------------------------------
8 // 'Sisu Financial'
9 //
10 // NAME     : Sisu Financial
11 // Symbol   : SISU
12 // Total supply: 500,000,000
13 // Decimals    : 8
14 //
15 // Enjoy.
16 //
17 // Design(c) by Pilvia team. The MIT Licence.
18 // ----------------------------------------------------------------------------
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a * b;
22         assert(a == 0 || c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 
44     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
45         return a >= b ? a : b;
46     }
47 
48     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
49         return a < b ? a : b;
50     }
51 
52     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
53         return a >= b ? a : b;
54     }
55 
56     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
57         return a < b ? a : b;
58     }
59 }
60 
61 contract ERC20Basic {
62     uint256 public totalSupply;
63 
64     bool public transfersEnabled;
65 
66     function balanceOf(address who) public view returns (uint256);
67 
68     function transfer(address to, uint256 value) public returns (bool);
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract ERC20 {
74     uint256 public totalSupply;
75 
76     bool public transfersEnabled;
77 
78     function balanceOf(address _owner) public constant returns (uint256 balance);
79 
80     function transfer(address _to, uint256 _value) public returns (bool success);
81 
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
83 
84     function approve(address _spender, uint256 _value) public returns (bool success);
85 
86     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
87 
88     event Transfer(address indexed _from, address indexed _to, uint256 _value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 }
91 
92 contract BasicToken is ERC20Basic {
93     using SafeMath for uint256;
94 
95     mapping(address => uint256) balances;
96 
97     /**
98     * @dev protection against short address attack
99     */
100     modifier onlyPayloadSize(uint numwords) {
101         assert(msg.data.length == numwords * 32 + 4);
102         _;
103     }
104 
105 
106     /**
107     * @dev transfer token for a specified address
108     * @param _to The address to transfer to.
109     * @param _value The amount to be transferred.
110     */
111     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[msg.sender]);
114         require(transfersEnabled);
115 
116         // SafeMath.sub will throw if there is not enough balance.
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param _owner The address to query the the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address _owner) public constant returns (uint256 balance) {
129         return balances[_owner];
130     }
131 
132 }
133 
134 contract StandardToken is ERC20, BasicToken {
135 
136     mapping(address => mapping(address => uint256)) internal allowed;
137 
138     /**
139      * @dev Transfer tokens from one address to another
140      * @param _from address The address which you want to send tokens from
141      * @param _to address The address which you want to transfer to
142      * @param _value uint256 the amount of tokens to be transferred
143      */
144     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
145         require(_to != address(0));
146         require(_value <= balances[_from]);
147         require(_value <= allowed[_from][msg.sender]);
148         require(transfersEnabled);
149 
150         balances[_from] = balances[_from].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153         Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159      *
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param _spender The address which will spend the funds.
165      * @param _value The amount of tokens to be spent.
166      */
167     function approve(address _spender, uint256 _value) public returns (bool) {
168         allowed[msg.sender][_spender] = _value;
169         Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /**
174      * @dev Function to check the amount of tokens that an owner allowed to a spender.
175      * @param _owner address The address which owns the funds.
176      * @param _spender address The address which will spend the funds.
177      * @return A uint256 specifying the amount of tokens still available for the spender.
178      */
179     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
180         return allowed[_owner][_spender];
181     }
182 
183     /**
184      * approve should be called when allowed[_spender] == 0. To increment
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      */
189     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
190         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 
195     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
196         uint oldValue = allowed[msg.sender][_spender];
197         if (_subtractedValue > oldValue) {
198             allowed[msg.sender][_spender] = 0;
199         } else {
200             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201         }
202         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 
206 }
207 
208 contract SisuFinancial is StandardToken {
209 
210     string public constant name = "Sisu Financial";
211     string public constant symbol = "SISU";
212     uint8 public constant decimals = 8;
213     uint256 public constant INITIAL_SUPPLY = 50 * 10**7 * (10**uint256(decimals));
214     uint256 public weiRaised;
215     uint256 public tokenAllocated;
216     address public owner;
217     bool public saleToken = true;
218 
219     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
220     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
221     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
222     event Transfer(address indexed _from, address indexed _to, uint256 _value);
223 
224     function SisuFinancial() public {
225         totalSupply = INITIAL_SUPPLY;
226         owner = msg.sender;
227         //owner = msg.sender; // for testing
228         balances[owner] = INITIAL_SUPPLY;
229         tokenAllocated = 0;
230         transfersEnabled = true;
231     }
232 
233     // fallback function can be used to buy tokens
234     function() payable public {
235         buyTokens(msg.sender);
236     }
237 
238     function buyTokens(address _investor) public payable returns (uint256){
239         require(_investor != address(0));
240         require(saleToken == true);
241         address wallet = owner;
242         uint256 weiAmount = msg.value;
243         uint256 tokens = validPurchaseTokens(weiAmount);
244         if (tokens == 0) {revert();}
245         weiRaised = weiRaised.add(weiAmount);
246         tokenAllocated = tokenAllocated.add(tokens);
247         mint(_investor, tokens, owner);
248 
249         TokenPurchase(_investor, weiAmount, tokens);
250         wallet.transfer(weiAmount);
251         return tokens;
252     }
253 
254     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
255         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
256         if (addTokens > balances[owner]) {
257             TokenLimitReached(tokenAllocated, addTokens);
258             return 0;
259         }
260         return addTokens;
261     }
262 
263     /**
264     * If the user sends 0 ether, he receives 222
265     * If he sends 0.001 ether, he receives 300 
266     * If he sends 0.005 ether, he receives 1500
267     * If he sends 0.01 ether, he receives 3000
268     * If he sends 0.1 ether he receives 30000
269     * If he sends 1 ether, he receives 300,000 +100%
270     */
271     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
272         uint256 amountOfTokens = 0;
273         if(_weiAmount == 0){
274             amountOfTokens = 222 * (10**uint256(decimals));
275         }
276         if( _weiAmount == 0.001 ether){
277             amountOfTokens = 300 * (10**uint256(decimals));
278         }
279         if( _weiAmount == 0.002 ether){
280             amountOfTokens = 600 * (10**uint256(decimals));
281         }
282         if( _weiAmount == 0.003 ether){
283             amountOfTokens = 900 * (10**uint256(decimals));
284         }
285         if( _weiAmount == 0.004 ether){
286             amountOfTokens = 1200 * (10**uint256(decimals));
287         }
288         if( _weiAmount == 0.005 ether){
289             amountOfTokens = 1500 * (10**uint256(decimals));
290         }
291         if( _weiAmount == 0.006 ether){
292             amountOfTokens = 1800 * (10**uint256(decimals));
293         }
294         if( _weiAmount == 0.007 ether){
295             amountOfTokens = 2100 * (10**uint256(decimals));
296         }
297         if( _weiAmount == 0.008 ether){
298             amountOfTokens = 2400 * (10**uint256(decimals));
299         }
300         if( _weiAmount == 0.009 ether){
301             amountOfTokens = 2700 * (10**uint256(decimals));
302         }
303         if( _weiAmount == 0.01 ether){
304             amountOfTokens = 3000 * (10**uint256(decimals));
305         }
306         if( _weiAmount == 0.02 ether){
307             amountOfTokens = 6000 * (10**uint256(decimals));
308         }
309         if( _weiAmount == 0.03 ether){
310             amountOfTokens = 9000 * (10**uint256(decimals));
311         }
312         if( _weiAmount == 0.04 ether){
313             amountOfTokens = 12000 * (10**uint256(decimals));
314         }
315         if( _weiAmount == 0.05 ether){
316             amountOfTokens = 15000 * (10**uint256(decimals));
317         }
318         if( _weiAmount == 0.06 ether){
319             amountOfTokens = 18000 * (10**uint256(decimals));
320         }
321         if( _weiAmount == 0.07 ether){
322             amountOfTokens = 21000 * (10**uint256(decimals));
323         }
324         if( _weiAmount == 0.08 ether){
325             amountOfTokens = 24000 * (10**uint256(decimals));
326         }
327         if( _weiAmount == 0.09 ether){
328             amountOfTokens = 27000 * (10**uint256(decimals));
329         }
330         if( _weiAmount == 0.1 ether){
331             amountOfTokens = 30 * 10**3 * (10**uint256(decimals));
332         }
333         if( _weiAmount == 0.2 ether){
334             amountOfTokens = 60 * 10**3 * (10**uint256(decimals));
335         }
336         if( _weiAmount == 0.3 ether){
337             amountOfTokens = 90 * 10**3 * (10**uint256(decimals));
338         }
339         if( _weiAmount == 0.4 ether){
340             amountOfTokens = 120 * 10**3 * (10**uint256(decimals));
341         }
342         if( _weiAmount == 0.5 ether){
343             amountOfTokens = 225 * 10**3 * (10**uint256(decimals));
344         }
345         if( _weiAmount == 0.6 ether){
346             amountOfTokens = 180 * 10**3 * (10**uint256(decimals));
347         }
348         if( _weiAmount == 0.7 ether){
349             amountOfTokens = 210 * 10**3 * (10**uint256(decimals));
350         }
351         if( _weiAmount == 0.8 ether){
352             amountOfTokens = 240 * 10**3 * (10**uint256(decimals));
353         }
354         if( _weiAmount == 0.9 ether){
355             amountOfTokens = 270 * 10**3 * (10**uint256(decimals));
356         }
357         if( _weiAmount == 1 ether){
358             amountOfTokens = 600 * 10**3 * (10**uint256(decimals));
359         }
360         return amountOfTokens;
361     }
362 
363 
364     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
365         require(_to != address(0));
366         require(_amount <= balances[_owner]);
367 
368         balances[_to] = balances[_to].add(_amount);
369         balances[_owner] = balances[_owner].sub(_amount);
370         Transfer(_owner, _to, _amount);
371         return true;
372     }
373 
374     modifier onlyOwner() {
375         require(msg.sender == owner);
376         _;
377     }
378 
379     function changeOwner(address _newOwner) onlyOwner public returns (bool){
380         require(_newOwner != address(0));
381         OwnerChanged(owner, _newOwner);
382         owner = _newOwner;
383         return true;
384     }
385 
386     function startSale() public onlyOwner {
387         saleToken = true;
388     }
389 
390     function stopSale() public onlyOwner {
391         saleToken = false;
392     }
393 
394     function enableTransfers(bool _transfersEnabled) onlyOwner public {
395         transfersEnabled = _transfersEnabled;
396     }
397 
398     /**
399      * Peterson's Law Protection
400      * Claim tokens
401      */
402     function claimTokens() public onlyOwner {
403         owner.transfer(this.balance);
404         uint256 balance = balanceOf(this);
405         transfer(owner, balance);
406         Transfer(this, owner, balance);
407     }
408 }