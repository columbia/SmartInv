1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract IERC20 {
4     function totalSupply() constant public returns (uint256);
5     function balanceOf(address _owner) constant public returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) constant public returns (uint256 remianing);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 /*
16 CREATED BY ANDRAS SZEKELY, SaiTech (c) 2019
17 
18 */ 
19 
20 contract Ownable {
21     address public owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26     /**
27     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28     * account.
29     */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     /**
35     * @dev Throws if called by any account other than the owner.
36     */
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     /**
43     * @dev Allows the current owner to transfer control of the contract to a newOwner.
44     * @param newOwner The address to transfer ownership to.
45     */
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 }
52 
53 library SafeMath {
54     
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59 	uint256 c = a * b;
60         assert(a == 0 || c / a == b);
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         assert(b <= a);
73         return a - b;
74     }
75 
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         assert(c >= a);
79         return c;
80     }
81 
82     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
83         return a >= b ? a : b;
84     }
85 
86     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
87         return a < b ? a : b;
88     }
89 
90     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a >= b ? a : b;
92     }
93 
94     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a < b ? a : b;
96     }
97 }
98 
99 contract LYCCoin is IERC20, Ownable {
100 
101     using SafeMath for uint256;
102 
103     uint public _totalSupply = 0;
104     uint public constant INITIAL_SUPPLY = 175000000000000000000000000;
105     uint public MAXUM_SUPPLY =            175000000000000000000000000;
106     uint256 public _currentSupply = 0;
107 
108     string public constant symbol = "LYC";
109     string public constant name = "LYCCoin";
110     uint8 public constant decimals = 18;
111 
112     uint256 public RATE;
113 
114     bool public mintingFinished = false;
115 
116     mapping(address => uint256) balances;
117     mapping(address => mapping(address => uint256)) allowed;
118 	mapping (address => uint256) public freezeOf;
119     mapping(address => bool) whitelisted;
120     mapping(address => bool) blockListed;
121 
122 
123     event Transfer(address indexed _from, address indexed _to, uint256 _value);
124     event Burn(address indexed from, uint256 value);
125     event Freeze(address indexed from, uint256 value);
126     event Unfreeze(address indexed from, uint256 value);
127     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
128     event Mint(address indexed to, uint256 amount);
129     event MintFinished();
130     event LogUserAdded(address user);
131     event LogUserRemoved(address user);
132 
133 
134 
135 
136     constructor() public {
137         setRate(1);
138         _totalSupply = INITIAL_SUPPLY;
139         balances[msg.sender] = INITIAL_SUPPLY;
140         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
141 
142         owner = msg.sender;
143     }
144 
145     function () public payable {
146         revert();
147     }
148 
149     function createTokens() payable public {
150         require(msg.value > 0);
151         require(whitelisted[msg.sender]);
152 
153         uint256 tokens = msg.value.mul(RATE);
154         balances[msg.sender] = balances[msg.sender].add(tokens);
155         _totalSupply = _totalSupply.add(tokens);
156 
157         owner.transfer(msg.value);
158     }
159 
160     function totalSupply() constant public returns (uint256) {
161         return _totalSupply;
162     }
163 
164     function balanceOf(address _owner) constant public returns (uint256 balance) {
165         return balances[_owner];
166     }
167 
168     function transfer(address _to, uint256 _value) public returns (bool success) {
169         // Prevent transfer to 0x0 address. Use burn() instead
170         require(_to != 0x0);
171 
172         require(
173             balances[msg.sender] >= _value
174             && _value > 0
175             && !blockListed[_to]
176             && !blockListed[msg.sender]
177         );
178 
179         // Save this for an assertion in the future
180         uint previousBalances = balances[msg.sender] + balances[_to];
181         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);                     // Subtract from the sender
182         balances[_to] = SafeMath.add(balances[_to], _value);                            // Add the same to the recipient
183 
184         emit Transfer(msg.sender, _to, _value);
185 
186         // Asserts are used to use static analysis to find bugs in your code. They should never fail
187         assert(balances[msg.sender] + balances[_to] == previousBalances);
188 
189         return true;
190     }
191 
192     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
193         require(
194             balances[msg.sender] >= _value
195             && balances[_from] >= _value
196             && _value > 0
197             && whitelisted[msg.sender]
198             && !blockListed[_to]
199             && !blockListed[msg.sender]
200         );
201         balances[_from] = SafeMath.sub(balances[_from], _value);                           // Subtract from the sender
202         balances[_to] = SafeMath.add(balances[_to], _value);                             // Add the same to the recipient
203         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
204         emit Transfer(_from, _to, _value);
205         return true;
206     }
207 
208     function approve(address _spender, uint256 _value) public returns (bool success) {
209         allowed[msg.sender][_spender] = _value;
210         whitelisted[_spender] = true;
211         emit Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     function allowance(address _owner, address _spender) constant public returns (uint256 remianing) {
216         return allowed[_owner][_spender];
217     }
218 
219     function getRate() public constant returns (uint256) {
220         return RATE;
221     }
222 
223     function setRate(uint256 _rate) public returns (bool success) {
224         RATE = _rate;
225         return true;
226     }
227 
228     modifier canMint() {
229         require(!mintingFinished);
230         _;
231     }
232 
233     modifier hasMintPermission() {
234         require(msg.sender == owner);
235         _;
236     }
237 
238     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
239         uint256 tokens = _amount.mul(RATE);
240         require(
241             _currentSupply.add(tokens) < MAXUM_SUPPLY
242             && whitelisted[msg.sender]
243             && !blockListed[_to]
244         );
245 
246         if (_currentSupply >= INITIAL_SUPPLY) {
247             _totalSupply = _totalSupply.add(tokens);
248         }
249 
250         _currentSupply = _currentSupply.add(tokens);
251         balances[_to] = balances[_to].add(tokens);
252         emit Mint(_to, tokens);
253         emit Transfer(address(0), _to, tokens);
254         return true;
255     }
256 
257     function finishMinting() onlyOwner canMint public returns (bool) {
258         mintingFinished = true;
259         emit MintFinished();
260         return true;
261     }
262 
263     // Add a user to the whitelist
264     function addUser(address user) onlyOwner public {
265         whitelisted[user] = true;
266         emit LogUserAdded(user);
267     }
268 
269     // Remove an user from the whitelist
270     function removeUser(address user) onlyOwner public {
271         whitelisted[user] = false;
272         emit LogUserRemoved(user);
273     }
274 
275     function getCurrentOwnerBallence() constant public returns (uint256) {
276         return balances[msg.sender];
277     }
278 
279     function addBlockList(address wallet) onlyOwner public {
280         blockListed[wallet] = true;
281     }
282 
283     function removeBlockList(address wallet) onlyOwner public {
284         blockListed[wallet] = false;
285     }
286 
287  
288     /**
289      * Destroy tokens
290      *
291      * Remove `_value` tokens from the system irreversibly
292      *
293      * @param _value the amount of money to burn
294      */
295     function burn(uint256 _value) public returns (bool success) {
296         require(balances[msg.sender] >= _value);   // Check if the sender has enough
297         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);           // Subtract from the sender
298         _totalSupply = SafeMath.sub(_totalSupply,_value);                                // Updates totalSupply
299         emit Burn(msg.sender, _value);
300         return true;
301     }
302 
303     /**
304      * Destroy tokens from other account
305      *
306      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
307      *
308      * @param _from the address of the sender
309      * @param _value the amount of money to burn
310      */
311     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
312         require(balances[_from] >= _value);                // Check if the targeted balance is enough
313         require(_value <= allowed[_from][msg.sender]);    // Check allowance
314         balances[_from] -= _value;                         // Subtract from the targeted balance
315         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
316         _totalSupply -= _value;                              // Update totalSupply
317         emit Burn(_from, _value);
318         return true;
319     }
320 
321 
322 	function freeze(uint256 _value) onlyOwner public returns (bool success) {
323         if (balances[msg.sender] < _value) revert();            // Check if the sender has enough
324 		if (_value <= 0) revert(); 
325         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);                      // Subtract from the sender
326         freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);                        // Updates totalSupply
327         emit Freeze(msg.sender, _value);
328         return true;
329     }
330 	
331 	function unfreeze(uint256 _value) onlyOwner public returns (bool success) {
332         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
333 		if (_value <= 0) revert(); 
334         freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);                      // Subtract from the sender
335 		balances[msg.sender] = SafeMath.add(balances[msg.sender], _value);
336         emit Unfreeze(msg.sender, _value);
337         return true;
338     }
339 
340 }