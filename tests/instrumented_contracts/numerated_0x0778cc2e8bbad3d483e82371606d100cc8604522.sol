1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal returns (uint256) {
11         uint256 c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 contract ERC20Basic {
37     uint256 public totalSupply;
38 
39     function balanceOf(address who) constant returns (uint256);
40 
41     function transfer(address to, uint256 value);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     event Burn(address indexed from, uint256 value);
46 }
47 
48 
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) constant returns (uint256);
51 
52     function transferFrom(address from, address to, uint256 value);
53 
54     function approve(address spender, uint256 value);
55 
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 
60 contract BasicToken is ERC20Basic {
61     using SafeMath for uint256;
62 
63     mapping (address => uint256) public balances;
64     mapping (address => bool) public onChain;
65     address[] public ownersOfToken;
66 
67 
68     function ownersLen() constant returns (uint256) { return ownersOfToken.length; }
69     function ownerAddress(uint256 number) constant returns (address) { return ownersOfToken[number]; }
70 
71     /**
72     * @dev transfer token for a specified address
73     * @param _to The address to transfer to.
74     * @param _value The amount to be transferred.
75     */
76     function transfer(address _to, uint256 _value) {
77 
78         require(balances[msg.sender] >= _value);
79         // Check if the sender has enough
80         require(balances[_to] + _value >= balances[_to]);
81         // Check for overflows
82 
83         if (!onChain[_to]){
84             ownersOfToken.push(_to);
85             onChain[_to] = true;
86         }
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90     }
91 
92     // burn tokens from sender balance
93     function burn(uint256 _value) {
94 
95         require(balances[msg.sender] >= _value);
96         // Check if the sender has enough
97 
98         balances[msg.sender] = balances[msg.sender].sub(_value);
99         totalSupply.sub(_value);
100         Burn(msg.sender, _value);
101     }
102 
103 
104     /**
105     * @dev Gets the balance of the specified address.
106     * @param _owner The address to query the the balance of.
107     * @return An uint256 representing the amount owned by the passed address.
108     */
109     function balanceOf(address _owner) constant returns (uint256 balance) {
110         return balances[_owner];
111     }
112 
113 }
114 
115 
116 contract StandardToken is ERC20, BasicToken {
117 
118     mapping (address => mapping (address => uint256)) allowed;
119     address[] public ownersOfToken;
120 
121 
122     /**
123      * @dev Transfer tokens from one address to another
124      * @param _from address The address which you want to send tokens from
125      * @param _to address The address which you want to transfer to
126      * @param _value uint256 the amout of tokens to be transfered
127      */
128     function transferFrom(address _from, address _to, uint256 _value) {
129         var _allowance = allowed[_from][msg.sender];
130 
131         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
132         // if (_value > _allowance) throw;
133         if (!onChain[_to]){
134             ownersOfToken.push(_to);
135         }
136         balances[_to] = balances[_to].add(_value);
137         balances[_from] = balances[_from].sub(_value);
138         allowed[_from][msg.sender] = _allowance.sub(_value);
139         Transfer(_from, _to, _value);
140     }
141 
142     /**
143      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
144      * @param _spender The address which will spend the funds.
145      * @param _value The amount of tokens to be spent.
146      */
147     function approve(address _spender, uint256 _value) {
148 
149         // To change the approve amount you first have to reduce the addresses`
150         //  allowance to zero by calling `approve(_spender, 0)` if it is not
151         //  already 0 to mitigate the race condition described here:
152         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
154 
155         allowed[msg.sender][_spender] = _value;
156         Approval(msg.sender, _spender, _value);
157     }
158 
159     /**
160      * @dev Function to check the amount of tokens that an owner allowed to a spender.
161      * @param _owner address The address which owns the funds.
162      * @param _spender address The address which will spend the funds.
163      * @return A uint256 specifing the amount of tokens still avaible for the spender.
164      */
165     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
166         return allowed[_owner][_spender];
167     }
168 
169 }
170 
171 
172 contract Ownable {
173 
174     address public owner;
175     address public manager;
176 
177 
178     /**
179      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
180      * account.
181      */
182     function Ownable() {
183         owner = msg.sender;
184     }
185 
186 
187     /**
188      * @dev Throws if called by any account other than the owner.
189      */
190     modifier onlyOwner() {
191         require(msg.sender == owner);
192         _;
193     }
194 
195 
196     modifier onlyAdmin() {
197         require(msg.sender == owner || msg.sender == manager);
198         _;
199     }
200 
201 
202 
203     function setManager(address _manager) onlyOwner {
204         manager = _manager;
205     }
206 
207     /**
208      * @dev Allows the current owner to transfer control of the contract to a newOwner.
209      * @param newOwner The address to transfer ownership to.
210      */
211     function transferOwnership(address newOwner) onlyOwner {
212         if (newOwner != address(0)) {
213             owner = newOwner;
214         }
215     }
216 
217 }
218 
219 
220 contract MintableToken is StandardToken, Ownable {
221     event Mint(address indexed to, uint256 amount);
222 
223     event MintFinished();
224 
225     bool exchangeable;
226 
227     string public name = "LHCoin";
228 
229     string public symbol = "LHC";
230 
231     uint256 public decimals = 8;
232 
233     uint256 public decimalMultiplier = 100000000;
234 
235     bool public mintingFinished = false;
236 
237     address bountyCoin;
238 
239     modifier canMint() {
240         require(!mintingFinished);
241         _;
242     }
243 
244     function MintableToken(){
245         mint(msg.sender, 72000000 * decimalMultiplier);
246         finishMinting();
247     }
248 
249     /**
250      * @dev Function to mint tokens
251      * @param _to The address that will recieve the minted tokens.
252      * @param _amount The amount of tokens to mint.
253      * @return A boolean that indicates if the operation was successful.
254      */
255     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
256         totalSupply = totalSupply.add(_amount);
257         balances[_to] = balances[_to].add(_amount);
258         Mint(_to, _amount);
259         return true;
260     }
261 
262     /**
263      * @dev Function to stop minting new tokens.
264      * @return True if the operation was successful.
265      */
266     function finishMinting() onlyOwner returns (bool) {
267         mintingFinished = true;
268         MintFinished();
269         return true;
270     }
271 
272     function exchangeBounty(address user, uint amount) {
273         assert(msg.sender == bountyCoin);
274         assert(exchangeable);
275         balances[user] = amount;
276         totalSupply += amount;
277     }
278 
279     function setBountyCoin(address _bountyCoin) onlyAdmin {
280         bountyCoin = _bountyCoin;
281     }
282 
283     function setExchangeable(bool _exchangeable) onlyAdmin {
284         exchangeable = _exchangeable;
285     }
286 }
287 
288 
289 contract MintableTokenBounty is StandardToken, Ownable {
290 
291     event Mint(address indexed to, uint256 amount);
292 
293     event MintFinished();
294 
295     string public name = "LHBountyCoin";
296 
297     string public symbol = "LHBC";
298 
299     uint256 public decimals = 8;
300 
301     uint256 public decimalMultiplier = 100000000;
302 
303     bool public mintingFinished = false;
304 
305     MintableToken coin;
306 
307 
308     modifier canMint() {
309         require(!mintingFinished);
310         _;
311     }
312 
313     function MintableTokenBounty() {
314         mint(msg.sender, 30000000 * decimalMultiplier);
315     }
316 
317     /**
318      * @dev Function to mint tokens
319      * @param _to The address that will recieve the minted tokens.
320      * @param _amount The amount of tokens to mint.
321      * @return A boolean that indicates if the operation was successful.
322      */
323     function mint(address _to, uint256 _amount) onlyAdmin canMint returns (bool) {
324         totalSupply = totalSupply.add(_amount);
325         balances[_to] = balances[_to].add(_amount);
326         Mint(_to, _amount);
327         return true;
328     }
329 
330     /**
331      * @dev Function to stop minting new tokens.
332      * @return True if the operation was successful.
333      */
334     function finishMinting() onlyAdmin returns (bool) {
335         mintingFinished = true;
336         MintFinished();
337         return true;
338     }
339 
340     function setCoin(MintableToken _coin) onlyAdmin {
341         coin = _coin;
342     }
343 
344     function exchangeToken() {
345         coin.exchangeBounty(msg.sender, balances[msg.sender]);
346         totalSupply -= balances[msg.sender];
347         balances[msg.sender] = 0;
348     }
349 }