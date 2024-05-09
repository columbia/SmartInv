1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Apputoken'
5 //
6 // NAME     : Apputoken
7 // Symbol   : APT
8 // Total supply: 50,000,000,000
9 // Decimals    : 18
10 // Website : https://Apputoken.tech
11 // ----------------------------------------------------------------------------
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a * b;
15         assert(a == 0 || c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 
37     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
38         return a >= b ? a : b;
39     }
40 
41     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
42         return a < b ? a : b;
43     }
44 
45     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a >= b ? a : b;
47     }
48 
49     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
50         return a < b ? a : b;
51     }
52 }
53 
54 contract ERC20Basic {
55     uint256 public totalSupply;
56 
57     bool public transfersEnabled;
58 
59     function balanceOf(address who) public view returns (uint256);
60 
61     function transfer(address to, uint256 value) public returns (bool);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 contract ERC20 {
67     uint256 public totalSupply;
68 
69     bool public transfersEnabled;
70 
71     function balanceOf(address _owner) public constant returns (uint256 balance);
72 
73     function transfer(address _to, uint256 _value) public returns (bool success);
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
76 
77     function approve(address _spender, uint256 _value) public returns (bool success);
78 
79     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 }
84 
85 contract BasicToken is ERC20Basic {
86     using SafeMath for uint256;
87 
88     mapping(address => uint256) balances;
89 
90     /**
91     * @dev protection against short address attack
92     */
93     modifier onlyPayloadSize(uint numwords) {
94         assert(msg.data.length == numwords * 32 + 4);
95         _;
96     }
97 
98 
99     /**
100     * @dev transfer token for a specified address
101     * @param _to The address to transfer to.
102     * @param _value The amount to be transferred.
103     */
104     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[msg.sender]);
107         require(transfersEnabled);
108 
109         // SafeMath.sub will throw if there is not enough balance.
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param _owner The address to query the the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121     function balanceOf(address _owner) public constant returns (uint256 balance) {
122         return balances[_owner];
123     }
124 
125 }
126 
127 contract StandardToken is ERC20, BasicToken {
128 
129     mapping(address => mapping(address => uint256)) internal allowed;
130 
131     /**
132      * @dev Transfer tokens from one address to another
133      * @param _from address The address which you want to send tokens from
134      * @param _to address The address which you want to transfer to
135      * @param _value uint256 the amount of tokens to be transferred
136      */
137     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[_from]);
140         require(_value <= allowed[_from][msg.sender]);
141         require(transfersEnabled);
142 
143         balances[_from] = balances[_from].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146         Transfer(_from, _to, _value);
147         return true;
148     }
149 
150     /**
151      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152      *
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param _spender The address which will spend the funds.
158      * @param _value The amount of tokens to be spent.
159      */
160     function approve(address _spender, uint256 _value) public returns (bool) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     /**
167      * @dev Function to check the amount of tokens that an owner allowed to a spender.
168      * @param _owner address The address which owns the funds.
169      * @param _spender address The address which will spend the funds.
170      * @return A uint256 specifying the amount of tokens still available for the spender.
171      */
172     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
173         return allowed[_owner][_spender];
174     }
175 
176     /**
177      * approve should be called when allowed[_spender] == 0. To increment
178      * allowed value is better to use this function to avoid 2 calls (and wait until
179      * the first transaction is mined)
180      * From MonolithDAO Token.sol
181      */
182     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
183         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187 
188     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
189         uint oldValue = allowed[msg.sender][_spender];
190         if (_subtractedValue > oldValue) {
191             allowed[msg.sender][_spender] = 0;
192         } else {
193             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194         }
195         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199 }
200 
201 contract Apputoken is StandardToken {
202 
203     string public constant name = "Apputoken";
204     string public constant symbol = "APPU";
205     uint8 public constant decimals = 18;
206     uint256 public constant INITIAL_SUPPLY = 50 * 10**9 * (10**uint256(decimals));
207     uint256 public weiRaised;
208     uint256 public tokenAllocated;
209     address public owner;
210     bool public saleToken = true;
211 
212     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
213     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
214     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
215     event Transfer(address indexed _from, address indexed _to, uint256 _value);
216 
217     function Apputoken() public {
218         totalSupply = INITIAL_SUPPLY;
219         owner = msg.sender;
220         //owner = msg.sender; // for testing
221         balances[owner] = INITIAL_SUPPLY;
222         tokenAllocated = 0;
223         transfersEnabled = true;
224     }
225 
226     // fallback function can be used to buy tokens
227     function() payable public {
228         buyTokens(msg.sender);
229     }
230 
231     function buyTokens(address _investor) public payable returns (uint256){
232         require(_investor != address(0));
233         require(saleToken == true);
234         address wallet = owner;
235         uint256 weiAmount = msg.value;
236         uint256 tokens = validPurchaseTokens(weiAmount);
237         if (tokens == 0) {revert();}
238         weiRaised = weiRaised.add(weiAmount);
239         tokenAllocated = tokenAllocated.add(tokens);
240         mint(_investor, tokens, owner);
241 
242         TokenPurchase(_investor, weiAmount, tokens);
243         wallet.transfer(weiAmount);
244         return tokens;
245     }
246 
247     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
248         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
249         if (addTokens > balances[owner]) {
250             TokenLimitReached(tokenAllocated, addTokens);
251             return 0;
252         }
253         return addTokens;
254     }
255 
256     /**
257     * If the user sends 0 ether, he receives 30000
258      */
259     function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {
260         uint256 amountOfTokens = 0;
261         if(_weiAmount == 0){
262             amountOfTokens = 30000* (10**uint256(decimals));
263         }
264         
265         return amountOfTokens;
266     }
267 
268 
269     function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {
270         require(_to != address(0));
271         require(_amount <= balances[_owner]);
272 
273         balances[_to] = balances[_to].add(_amount);
274         balances[_owner] = balances[_owner].sub(_amount);
275         Transfer(_owner, _to, _amount);
276         return true;
277     }
278 
279     modifier onlyOwner() {
280         require(msg.sender == owner);
281         _;
282     }
283 
284     function changeOwner(address _newOwner) onlyOwner public returns (bool){
285         require(_newOwner != address(0));
286         OwnerChanged(owner, _newOwner);
287         owner = _newOwner;
288         return true;
289     }
290 
291     function startSale() public onlyOwner {
292         saleToken = true;
293     }
294 
295     function stopSale() public onlyOwner {
296         saleToken = false;
297     }
298 
299     function enableTransfers(bool _transfersEnabled) onlyOwner public {
300         transfersEnabled = _transfersEnabled;
301     }
302 
303     /**
304      * Peterson's Law Protection
305      * Claim tokens
306      */
307     function claimTokens() public onlyOwner {
308         owner.transfer(this.balance);
309         uint256 balance = balanceOf(this);
310         transfer(owner, balance);
311         Transfer(this, owner, balance);
312     }
313 }