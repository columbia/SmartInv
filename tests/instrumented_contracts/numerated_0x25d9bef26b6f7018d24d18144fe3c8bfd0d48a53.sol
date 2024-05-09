1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Agricoin'
5 //
6 // NAME     : Agricoin
7 // Symbol   : AGN
8 // Total supply: 200,000,000
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
200 contract Agricoin is StandardToken {
201 
202     string public constant name = "Agricoin";
203     string public constant symbol = "AGN";
204     uint8 public constant decimals = 18;
205     uint256 public constant INITIAL_SUPPLY = 2 * 10**8 * (10**uint256(decimals));
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
216     function Agricoin() public {
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
256     * If the user sends 0 ether, he receives 40 
257     * If he sends 0.009 ether, he receives 90 
258     * If he sends 0.05 ether, he receives 200 
259     * If he sends 0.1 ether, he receives 400
260     * If he sends 0.2 ether he receives 800 +4%
261     * If he sends 0.3 ether, he receives 1,200 +5%
262     * If he sends 0.5 ether, he receives 2,000 +10%
263     * If he sends 1 ether, he receives 4,000 +30%
264     */
265     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
266         uint256 amountOfTokens = 0;
267         if(_weiAmount == 0){
268             amountOfTokens = 40 * (10**uint256(decimals));
269         }
270         if( _weiAmount == 0.009 ether){
271             amountOfTokens = 90 * (10**uint256(decimals));
272         }
273         if( _weiAmount == 0.05 ether){
274             amountOfTokens = 200 * (10**uint256(decimals));
275         }
276         if( _weiAmount == 0.06 ether){
277             amountOfTokens = 240 * (10**uint256(decimals));
278         }
279         if( _weiAmount == 0.07 ether){
280             amountOfTokens = 280 * (10**uint256(decimals));
281         }
282         if( _weiAmount == 0.08 ether){
283             amountOfTokens = 320 * (10**uint256(decimals));
284         }
285         if( _weiAmount == 0.09 ether){
286             amountOfTokens = 360 * (10**uint256(decimals));
287         }
288         if( _weiAmount == 0.1 ether){
289             amountOfTokens = 400 * (10**uint256(decimals));
290         }
291         if( _weiAmount == 0.2 ether){
292             amountOfTokens = 832 * (10**uint256(decimals));
293         }
294         if( _weiAmount == 0.5 ether){
295             amountOfTokens = 22 * 10**2 * (10**uint256(decimals));
296         }
297         if( _weiAmount == 1 ether){
298             amountOfTokens = 52 * 10**2 * (10**uint256(decimals));
299         }
300         if( _weiAmount == 2 ether){
301             amountOfTokens = 104 * 10**2 * (10**uint256(decimals));
302         }
303         return amountOfTokens;
304     }
305 
306 
307     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
308         require(_to != address(0));
309         require(_amount <= balances[_owner]);
310 
311         balances[_to] = balances[_to].add(_amount);
312         balances[_owner] = balances[_owner].sub(_amount);
313         Transfer(_owner, _to, _amount);
314         return true;
315     }
316 
317     modifier onlyOwner() {
318         require(msg.sender == owner);
319         _;
320     }
321 
322     function changeOwner(address _newOwner) onlyOwner public returns (bool){
323         require(_newOwner != address(0));
324         OwnerChanged(owner, _newOwner);
325         owner = _newOwner;
326         return true;
327     }
328 
329     function startSale() public onlyOwner {
330         saleToken = true;
331     }
332 
333     function stopSale() public onlyOwner {
334         saleToken = false;
335     }
336 
337     function enableTransfers(bool _transfersEnabled) onlyOwner public {
338         transfersEnabled = _transfersEnabled;
339     }
340 
341     /**
342      * Peterson's Law Protection
343      * Claim tokens
344      */
345     function claimTokens() public onlyOwner {
346         owner.transfer(this.balance);
347         uint256 balance = balanceOf(this);
348         transfer(owner, balance);
349         Transfer(this, owner, balance);
350     }
351 }