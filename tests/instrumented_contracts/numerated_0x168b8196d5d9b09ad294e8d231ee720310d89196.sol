1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
29         return a >= b ? a : b;
30     }
31 
32     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a < b ? a : b;
34     }
35 
36     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
37         return a >= b ? a : b;
38     }
39 
40     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a < b ? a : b;
42     }
43 }
44 
45 contract ERC20Basic {
46     uint256 public totalSupply;
47 
48     bool public transfersEnabled;
49 
50     function balanceOf(address who) public view returns (uint256);
51 
52     function transfer(address to, uint256 value) public returns (bool);
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 {
58     uint256 public totalSupply;
59 
60     bool public transfersEnabled;
61 
62     function balanceOf(address _owner) public constant returns (uint256 balance);
63 
64     function transfer(address _to, uint256 _value) public returns (bool success);
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
67 
68     function approve(address _spender, uint256 _value) public returns (bool success);
69 
70     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 }
75 
76 contract BasicToken is ERC20Basic {
77     using SafeMath for uint256;
78 
79     mapping(address => uint256) balances;
80 
81     /**
82     * @dev protection against short address attack
83     */
84     modifier onlyPayloadSize(uint numwords) {
85         assert(msg.data.length == numwords * 32 + 4);
86         _;
87     }
88 
89 
90     /**
91     * @dev transfer token for a specified address
92     * @param _to The address to transfer to.
93     * @param _value The amount to be transferred.
94     */
95     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
96         require(_to != address(0));
97         require(_value <= balances[msg.sender]);
98         require(transfersEnabled);
99 
100         // SafeMath.sub will throw if there is not enough balance.
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         Transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     /**
108     * @dev Gets the balance of the specified address.
109     * @param _owner The address to query the the balance of.
110     * @return An uint256 representing the amount owned by the passed address.
111     */
112     function balanceOf(address _owner) public constant returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116 }
117 
118 contract StandardToken is ERC20, BasicToken {
119 
120     mapping(address => mapping(address => uint256)) internal allowed;
121 
122     /**
123      * @dev Transfer tokens from one address to another
124      * @param _from address The address which you want to send tokens from
125      * @param _to address The address which you want to transfer to
126      * @param _value uint256 the amount of tokens to be transferred
127      */
128     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[_from]);
131         require(_value <= allowed[_from][msg.sender]);
132         require(transfersEnabled);
133 
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137         Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143      *
144      * Beware that changing an allowance with this method brings the risk that someone may use both the old
145      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      * @param _spender The address which will spend the funds.
149      * @param _value The amount of tokens to be spent.
150      */
151     function approve(address _spender, uint256 _value) public returns (bool) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Function to check the amount of tokens that an owner allowed to a spender.
159      * @param _owner address The address which owns the funds.
160      * @param _spender address The address which will spend the funds.
161      * @return A uint256 specifying the amount of tokens still available for the spender.
162      */
163     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
164         return allowed[_owner][_spender];
165     }
166 
167     /**
168      * approve should be called when allowed[_spender] == 0. To increment
169      * allowed value is better to use this function to avoid 2 calls (and wait until
170      * the first transaction is mined)
171      * From MonolithDAO Token.sol
172      */
173     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
174         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
180         uint oldValue = allowed[msg.sender][_spender];
181         if (_subtractedValue > oldValue) {
182             allowed[msg.sender][_spender] = 0;
183         } else {
184             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185         }
186         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190 }
191 
192 contract KYRO is StandardToken {
193 
194     string public constant name = "KYRO";
195     string public constant symbol = "KR";
196     uint8 public constant decimals = 18;
197     uint256 public constant INITIAL_SUPPLY = 3 * 10**9 * (10**uint256(decimals));
198     uint256 public weiRaised;
199     uint256 public tokenAllocated;
200     address public owner;
201     bool public saleToken = true;
202 
203     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
204     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
205     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
206     event Transfer(address indexed _from, address indexed _to, uint256 _value);
207 
208     function KYRO() public {
209         totalSupply = INITIAL_SUPPLY;
210         owner = msg.sender;
211         //owner = msg.sender; // for testing
212         balances[owner] = INITIAL_SUPPLY;
213         tokenAllocated = 0;
214         transfersEnabled = true;
215     }
216 
217     // fallback function can be used to buy tokens
218     function() payable public {
219         buyTokens(msg.sender);
220     }
221 
222     function buyTokens(address _investor) public payable returns (uint256){
223         require(_investor != address(0));
224         require(saleToken == true);
225         address wallet = owner;
226         uint256 weiAmount = msg.value;
227         uint256 tokens = validPurchaseTokens(weiAmount);
228         if (tokens == 0) {revert();}
229         weiRaised = weiRaised.add(weiAmount);
230         tokenAllocated = tokenAllocated.add(tokens);
231         mint(_investor, tokens, owner);
232 
233         TokenPurchase(_investor, weiAmount, tokens);
234         wallet.transfer(weiAmount);
235         return tokens;
236     }
237 
238     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
239         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
240         if (addTokens > balances[owner]) {
241             TokenLimitReached(tokenAllocated, addTokens);
242             return 0;
243         }
244         return addTokens;
245     }
246 
247     /**
248     * If the user sends 0 ether, he receives 500tokens.
249     * If he sends 0.001 ether, he receives 2000tokens
250     * If he sends 0.005 ether he receives 22,000tokens
251     * If he sends 0.01ether, he receives 48,000 tokens
252     * If he sends 0.02ether he receives 100000tokens
253     * If he sends 0.05ether, he receives 270,000tokens
254     */
255     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
256         uint256 amountOfTokens = 0;
257         if(_weiAmount == 0){
258             amountOfTokens = 500 * (10**uint256(decimals));
259         }
260         if( _weiAmount == 0.001 ether){
261             amountOfTokens = 2000 * 10**3 * (10**uint256(decimals));
262         }
263         if( _weiAmount == 0.005 ether){
264             amountOfTokens = 22 * 10**3 * (10**uint256(decimals));
265         }
266         if( _weiAmount == 0.01 ether){
267             amountOfTokens = 48 * 10**3 * (10**uint256(decimals));
268         }
269         if( _weiAmount == 0.02 ether){
270             amountOfTokens = 100 * 10**3 * (10**uint256(decimals));
271         }
272         if( _weiAmount == 0.05 ether){
273             amountOfTokens = 270 * 10**3 * (10**uint256(decimals));
274         }
275         return amountOfTokens;
276     }
277 
278 
279     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
280         require(_to != address(0));
281         require(_amount <= balances[_owner]);
282 
283         balances[_to] = balances[_to].add(_amount);
284         balances[_owner] = balances[_owner].sub(_amount);
285         Transfer(_owner, _to, _amount);
286         return true;
287     }
288 
289     modifier onlyOwner() {
290         require(msg.sender == owner);
291         _;
292     }
293 
294     function changeOwner(address _newOwner) onlyOwner public returns (bool){
295         require(_newOwner != address(0));
296         OwnerChanged(owner, _newOwner);
297         owner = _newOwner;
298         return true;
299     }
300 
301     function startSale() public onlyOwner {
302         saleToken = true;
303     }
304 
305     function stopSale() public onlyOwner {
306         saleToken = false;
307     }
308 
309     function enableTransfers(bool _transfersEnabled) onlyOwner public {
310         transfersEnabled = _transfersEnabled;
311     }
312 
313     /**
314      * Peterson's Law Protection
315      * Claim tokens
316      */
317     function claimTokens() public onlyOwner {
318         owner.transfer(this.balance);
319         uint256 balance = balanceOf(this);
320         transfer(owner, balance);
321         Transfer(this, owner, balance);
322     }
323 }