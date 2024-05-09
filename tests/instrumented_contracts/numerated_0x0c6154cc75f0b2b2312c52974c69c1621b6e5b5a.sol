1 pragma solidity ^0.4.19;
2 
3 // File: contracts\Convertible.sol
4 
5 /**
6  * Exchange all my ParcelX token to mainchain GPX
7  */
8 contract Convertible {
9 
10     function convertMainchainGPX(string destinationAccount, string extra) external returns (bool);
11   
12     // ParcelX deamon program is monitoring this event. 
13     // Once it triggered, ParcelX will transfer corresponding GPX to destination account
14     event Converted(address indexed who, string destinationAccount, uint256 amount, string extra);
15 }
16 
17 // File: contracts\ERC20.sol
18 
19 /**
20  * Starndard ERC20 interface: https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 {
23 
24     function totalSupply() public view returns (uint256);
25     function balanceOf(address who) public view returns (uint256);
26     function transfer(address to, uint256 value) public returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     function allowance(address owner, address spender) public view returns (uint256);
31     function transferFrom(address from, address to, uint256 value) public returns (bool);
32     function approve(address spender, uint256 value) public returns (bool);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35     
36     /**	
37     * @dev Fix for the ERC20 short address attack.	
38     * Remove short address attack checks from tokens(https://github.com/OpenZeppelin/openzeppelin-solidity/issues/261)
39     */	
40     modifier onlyPayloadSize(uint256 size) {	
41         require(msg.data.length >= size + 4);
42         _;	
43     }
44     
45 }
46 
47 // File: contracts\MultiOwnable.sol
48 
49 /**
50  * FEATURE 2): MultiOwnable implementation
51  * Transactions approved by _multiRequires of _multiOwners' addresses will be executed. 
52 
53  * All functions needing unit-tests cannot be INTERNAL
54  */
55 contract MultiOwnable {
56 
57     address[8] m_owners;
58     uint m_numOwners;
59     uint m_multiRequires;
60 
61     mapping (bytes32 => uint) internal m_pendings;
62 
63     event AcceptConfirm(address indexed who, uint confirmTotal);
64     
65     // constructor is given number of sigs required to do protected "multiOwner" transactions
66     function MultiOwnable (address[] _multiOwners, uint _multiRequires) public {
67         require(0 < _multiRequires && _multiRequires <= _multiOwners.length);
68         m_numOwners = _multiOwners.length;
69         require(m_numOwners <= 8);   // Bigger then 8 co-owners, not support !
70         for (uint i = 0; i < _multiOwners.length; ++i) {
71             m_owners[i] = _multiOwners[i];
72             require(m_owners[i] != address(0));
73         }
74         m_multiRequires = _multiRequires;
75     }
76 
77     // Any one of the owners, will approve the action
78     modifier anyOwner {
79         if (isOwner(msg.sender)) {
80             _;
81         }
82     }
83 
84     // Requiring num > m_multiRequires owners, to approve the action
85     modifier mostOwner(bytes32 operation) {
86         if (checkAndConfirm(msg.sender, operation)) {
87             _;
88         }
89     }
90 
91     function isOwner(address currentUser) public view returns (bool) {
92         for (uint i = 0; i < m_numOwners; ++i) {
93             if (m_owners[i] == currentUser) {
94                 return true;
95             }
96         }
97         return false;
98     }
99 
100     function checkAndConfirm(address currentUser, bytes32 operation) public returns (bool) {
101         uint ownerIndex = m_numOwners;
102         uint i;
103         for (i = 0; i < m_numOwners; ++i) {
104             if (m_owners[i] == currentUser) {
105                 ownerIndex = i;
106             }
107         }
108         if (ownerIndex == m_numOwners) {
109             return false;  // Not Owner
110         }
111         
112         uint newBitFinger = (m_pendings[operation] | (2 ** ownerIndex));
113 
114         uint confirmTotal = 0;
115         for (i = 0; i < m_numOwners; ++i) {
116             if ((newBitFinger & (2 ** i)) > 0) {
117                 confirmTotal ++;
118             }
119         }
120         
121         AcceptConfirm(currentUser, confirmTotal);
122 
123         if (confirmTotal >= m_multiRequires) {
124             delete m_pendings[operation];
125             return true;
126         }
127         else {
128             m_pendings[operation] = newBitFinger;
129             return false;
130         }
131     }
132 }
133 
134 // File: contracts\Pausable.sol
135 
136 /**
137  * FEATURE 3): Pausable implementation
138  */
139 contract Pausable is MultiOwnable {
140     event Pause();
141     event Unpause();
142 
143     bool paused = false;
144 
145     // Modifier to make a function callable only when the contract is not paused.
146     modifier whenNotPaused() {
147         require(!paused);
148         _;
149     }
150 
151     // Modifier to make a function callable only when the contract is paused.
152     modifier whenPaused() {
153         require(paused);
154         _;
155     }
156 
157     // called by the owner to pause, triggers stopped state
158     function pause() mostOwner(keccak256(msg.data)) whenNotPaused public {
159         paused = true;
160         Pause();
161     }
162 
163     // called by the owner to unpause, returns to normal state
164     function unpause() mostOwner(keccak256(msg.data)) whenPaused public {
165         paused = false;
166         Unpause();
167     }
168 
169     function isPause() view public returns(bool) {
170         return paused;
171     }
172 }
173 
174 // File: contracts\SafeMath.sol
175 
176 /**
177 * Standard SafeMath Library: zeppelin-solidity/contracts/math/SafeMath.sol
178 */
179 library SafeMath {
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         if (a == 0) {
182             return 0;
183         }
184         uint256 c = a * b;
185         assert(c / a == b);
186         return c;
187     }
188 
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         // assert(b > 0); // Solidity automatically throws when dividing by 0
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193         return c;
194     }
195 
196     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197         assert(b <= a);
198         return a - b;
199     }
200 
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         assert(c >= a);
204         return c;
205     }
206 }
207 
208 // File: contracts\ParcelXGPX.sol
209 
210 /**
211  * The main body of final smart contract 
212  */
213 contract ParcelXGPX is ERC20, MultiOwnable, Pausable, Convertible {
214 
215     using SafeMath for uint256;
216   
217     string public constant name = "ParcelX Token";
218     string public constant symbol = "GPX";
219     uint8 public constant decimals = 18;
220     uint256 public constant TOTAL_SUPPLY = uint256(1000000000) * (uint256(10) ** decimals);  // 10,0000,0000
221 
222     address internal tokenPool;      // Use a token pool holding all GPX. Avoid using sender address.
223     mapping(address => uint256) internal balances;
224     mapping (address => mapping (address => uint256)) internal allowed;
225 
226     function ParcelXGPX(address[] _multiOwners, uint _multiRequires) 
227         MultiOwnable(_multiOwners, _multiRequires) public {
228         tokenPool = this;
229         require(tokenPool != address(0));
230         balances[tokenPool] = TOTAL_SUPPLY;
231     }
232 
233     /**
234      * FEATURE 1): ERC20 implementation
235      */
236     function totalSupply() public view returns (uint256) {
237         return TOTAL_SUPPLY;       
238     }
239 
240     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
241         require(_to != address(0));
242         require(_value <= balances[msg.sender]);
243 
244         // SafeMath.sub will throw if there is not enough balance.
245         balances[msg.sender] = balances[msg.sender].sub(_value);
246         balances[_to] = balances[_to].add(_value);
247         Transfer(msg.sender, _to, _value);
248         return true;
249   }
250 
251     function balanceOf(address _owner) public view returns (uint256) {
252         return balances[_owner];
253     }
254 
255     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
256         require(_to != address(0));
257         require(_value <= balances[_from]);
258         require(_value <= allowed[_from][msg.sender]);
259 
260         balances[_from] = balances[_from].sub(_value);
261         balances[_to] = balances[_to].add(_value);
262         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
263         Transfer(_from, _to, _value);
264         return true;
265     }
266 
267     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
268         allowed[msg.sender][_spender] = _value;
269         Approval(msg.sender, _spender, _value);
270         return true;
271     }
272 
273     function allowance(address _owner, address _spender) public view returns (uint256) {
274         return allowed[_owner][_spender];
275     }
276 
277     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
278         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
279         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280         return true;
281     }
282 
283     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284         uint oldValue = allowed[msg.sender][_spender];
285         if (_subtractedValue > oldValue) {
286             allowed[msg.sender][_spender] = 0;
287         } else {
288             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289         }
290         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291         return true;
292     }
293 
294     /**
295      * FEATURE 4): Buyable implements
296      * 0.000268 eth per GPX, so the rate is 1.0 / 0.000268 = 3731.3432835820895
297      */
298     uint256 internal buyRate = uint256(3731); 
299     
300     event Deposit(address indexed who, uint256 value);
301     event Withdraw(address indexed who, uint256 value, address indexed lastApprover, string extra);
302         
303 
304     function getBuyRate() external view returns (uint256) {
305         return buyRate;
306     }
307 
308     function setBuyRate(uint256 newBuyRate) mostOwner(keccak256(msg.data)) external {
309         buyRate = newBuyRate;
310     }
311 
312     /**
313      * FEATURE 4): Buyable
314      * minimum of 0.001 ether for purchase in the public, pre-ico, and private sale
315      */
316     function buy() payable whenNotPaused public returns (uint256) {
317         Deposit(msg.sender, msg.value);
318         require(msg.value >= 0.001 ether);
319 
320         // Token compute & transfer
321         uint256 tokens = msg.value.mul(buyRate);
322         require(balances[tokenPool] >= tokens);
323         balances[tokenPool] = balances[tokenPool].sub(tokens);
324         balances[msg.sender] = balances[msg.sender].add(tokens);
325         Transfer(tokenPool, msg.sender, tokens);
326         
327         return tokens;
328     }
329 
330     // gets called when no other function matches
331     function () payable public {
332         if (msg.value > 0) {
333             buy();
334         }
335     }
336 
337     /**
338      * FEATURE 6): Budget control
339      * Malloc GPX for airdrops, marketing-events, etc 
340      */
341     function mallocBudget(address _admin, uint256 _value) mostOwner(keccak256(msg.data)) external returns (bool) {
342         require(_admin != address(0));
343         require(_value <= balances[tokenPool]);
344 
345         balances[tokenPool] = balances[tokenPool].sub(_value);
346         balances[_admin] = balances[_admin].add(_value);
347         Transfer(tokenPool, _admin, _value);
348         return true;
349     }
350     
351     function execute(address _to, uint256 _value, string _extra) mostOwner(keccak256(msg.data)) external returns (bool){
352         require(_to != address(0));
353         Withdraw(_to, _value, msg.sender, _extra);
354         _to.transfer(_value);   // Prevent using call() or send()
355         return true;
356     }
357 
358     /**
359      * FEATURE 5): Convertible implements
360      */
361     function convertMainchainGPX(string destinationAccount, string extra) external returns (bool) {
362         require(bytes(destinationAccount).length > 10 && bytes(destinationAccount).length < 128);
363         require(balances[msg.sender] > 0);
364         uint256 amount = balances[msg.sender];
365         balances[msg.sender] = 0;
366         balances[tokenPool] = balances[tokenPool].add(amount);   // recycle ParcelX to tokenPool's init account
367         Converted(msg.sender, destinationAccount, amount, extra);
368         return true;
369     }
370 
371 }