1 pragma solidity 0.4.19;
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
63     event AcceptConfirm(bytes32 operation, address indexed who, uint confirmTotal);
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
121         AcceptConfirm(operation, currentUser, confirmTotal);
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
217     string public constant name = "ParcelX";
218     string public constant symbol = "GPX-shadow";
219     uint8 public constant decimals = 18;
220     uint256 public constant TOTAL_SUPPLY = uint256(10000) * (uint256(10) ** decimals);
221 
222     address internal tokenPool = address(0);      // Use a token pool holding all GPX. Avoid using sender address.
223     mapping(address => uint256) internal balances;
224     mapping (address => mapping (address => uint256)) internal allowed;
225 
226     function ParcelXGPX(address[] _multiOwners, uint _multiRequires) 
227         MultiOwnable(_multiOwners, _multiRequires) public {
228         require(tokenPool == address(0));
229         tokenPool = this;
230         require(tokenPool != address(0));
231         balances[tokenPool] = TOTAL_SUPPLY;
232     }
233 
234     /**
235      * FEATURE 1): ERC20 implementation
236      */
237     function totalSupply() public view returns (uint256) {
238         return TOTAL_SUPPLY;       
239     }
240 
241     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
242         require(_to != address(0));
243         require(_value <= balances[msg.sender]);
244 
245         // SafeMath.sub will throw if there is not enough balance.
246         balances[msg.sender] = balances[msg.sender].sub(_value);
247         balances[_to] = balances[_to].add(_value);
248         Transfer(msg.sender, _to, _value);
249         return true;
250   }
251 
252     function balanceOf(address _owner) public view returns (uint256) {
253         return balances[_owner];
254     }
255 
256     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
257         require(_to != address(0));
258         require(_value <= balances[_from]);
259         require(_value <= allowed[_from][msg.sender]);
260 
261         balances[_from] = balances[_from].sub(_value);
262         balances[_to] = balances[_to].add(_value);
263         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
264         Transfer(_from, _to, _value);
265         return true;
266     }
267 
268     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
269         allowed[msg.sender][_spender] = _value;
270         Approval(msg.sender, _spender, _value);
271         return true;
272     }
273 
274     function allowance(address _owner, address _spender) public view returns (uint256) {
275         return allowed[_owner][_spender];
276     }
277 
278     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
279         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
280         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281         return true;
282     }
283 
284     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
285         uint oldValue = allowed[msg.sender][_spender];
286         if (_subtractedValue > oldValue) {
287             allowed[msg.sender][_spender] = 0;
288         } else {
289             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290         }
291         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292         return true;
293     }
294 
295     /**
296      * FEATURE 4): Buyable implements
297      * 0.000268 eth per GPX, so the rate is 1.0 / 0.000268 = 3731.3432835820895
298      */
299     uint256 internal buyRate = uint256(3731); 
300     
301     event Deposit(address indexed who, uint256 value);
302     event Withdraw(address indexed who, uint256 value, address indexed lastApprover, string extra);
303         
304 
305     function getBuyRate() external view returns (uint256) {
306         return buyRate;
307     }
308 
309     function setBuyRate(uint256 newBuyRate) mostOwner(keccak256(msg.data)) external {
310         buyRate = newBuyRate;
311     }
312 
313     /**
314      * FEATURE 4): Buyable
315      * minimum of 0.001 ether for purchase in the public, pre-ico, and private sale
316      */
317     function buy() payable whenNotPaused public returns (uint256) {
318         Deposit(msg.sender, msg.value);
319         require(msg.value >= 0.001 ether);
320 
321         // Token compute & transfer
322         uint256 tokens = msg.value.mul(buyRate);
323         require(balances[tokenPool] >= tokens);
324         balances[tokenPool] = balances[tokenPool].sub(tokens);
325         balances[msg.sender] = balances[msg.sender].add(tokens);
326         Transfer(tokenPool, msg.sender, tokens);
327         
328         return tokens;
329     }
330 
331     // gets called when no other function matches
332     function () payable public {
333         if (msg.value > 0) {
334             buy();
335         }
336     }
337 
338     /**
339      * FEATURE 6): Budget control
340      * Malloc GPX for airdrops, marketing-events, bonus, etc 
341      */
342     function mallocBudget(address _admin, uint256 _value) mostOwner(keccak256(msg.data)) external returns (bool) {
343         require(_admin != address(0));
344         require(_value <= balances[tokenPool]);
345 
346         balances[tokenPool] = balances[tokenPool].sub(_value);
347         balances[_admin] = balances[_admin].add(_value);
348         Transfer(tokenPool, _admin, _value);
349         return true;
350     }
351     
352     function execute(address _to, uint256 _value, string _extra) mostOwner(keccak256(msg.data)) external returns (bool){
353         require(_to != address(0));
354         _to.transfer(_value);   // Prevent using call() or send()
355         Withdraw(_to, _value, msg.sender, _extra);
356         return true;
357     }
358 
359     /**
360      * FEATURE 5): 'Convertible' implements
361      * Below actions would be performed after token being converted into mainchain:
362      * - Unsold tokens are discarded.
363      * - Tokens sold with bonus will be locked for a period (see Whitepaper).
364      * - Token distribution for team will be locked for a period (see Whitepaper).
365      */
366     function convertMainchainGPX(string destinationAccount, string extra) external returns (bool) {
367         require(bytes(destinationAccount).length > 10 && bytes(destinationAccount).length < 1024);
368         require(balances[msg.sender] > 0);
369         uint256 amount = balances[msg.sender];
370         balances[msg.sender] = 0;
371         balances[tokenPool] = balances[tokenPool].add(amount);   // return GPX to tokenPool - the init account
372         Converted(msg.sender, destinationAccount, amount, extra);
373         return true;
374     }
375 
376 }