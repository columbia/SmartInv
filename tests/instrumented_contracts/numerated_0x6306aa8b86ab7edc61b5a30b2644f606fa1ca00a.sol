1 pragma solidity 0.4.19;
2 
3 // File: contracts\ERC20.sol
4 
5 /**
6  * Starndard ERC20 interface: https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9 
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     function allowance(address owner, address spender) public view returns (uint256);
17     function transferFrom(address from, address to, uint256 value) public returns (bool);
18     function approve(address spender, uint256 value) public returns (bool);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21     
22     /**	
23     * @dev Fix for the ERC20 short address attack.	
24     * Remove short address attack checks from tokens(https://github.com/OpenZeppelin/openzeppelin-solidity/issues/261)
25     */	
26     modifier onlyPayloadSize(uint256 size) {	
27         require(msg.data.length >= size + 4);
28         _;	
29     }
30     
31 }
32 
33 // File: contracts\MultiOwnable.sol
34 
35 /**
36  * FEATURE 2): MultiOwnable implementation
37  * Transactions approved by _multiRequires of _multiOwners' addresses will be executed. 
38 
39  * All functions needing unit-tests cannot be INTERNAL
40  */
41 contract MultiOwnable {
42 
43     address[8] m_owners;
44     uint m_numOwners;
45     uint m_multiRequires;
46 
47     mapping (bytes32 => uint) internal m_pendings;
48 
49     event AcceptConfirm(bytes32 operation, address indexed who, uint confirmTotal);
50     
51     // constructor is given number of sigs required to do protected "multiOwner" transactions
52     function MultiOwnable (address[] _multiOwners, uint _multiRequires) public {
53         require(0 < _multiRequires && _multiRequires <= _multiOwners.length);
54         m_numOwners = _multiOwners.length;
55         require(m_numOwners <= 8);   // Bigger then 8 co-owners, not support !
56         for (uint i = 0; i < _multiOwners.length; ++i) {
57             m_owners[i] = _multiOwners[i];
58             require(m_owners[i] != address(0));
59         }
60         m_multiRequires = _multiRequires;
61     }
62 
63     // Any one of the owners, will approve the action
64     modifier anyOwner {
65         if (isOwner(msg.sender)) {
66             _;
67         }
68     }
69 
70     // Requiring num > m_multiRequires owners, to approve the action
71     modifier mostOwner(bytes32 operation) {
72         if (checkAndConfirm(msg.sender, operation)) {
73             _;
74         }
75     }
76 
77     function isOwner(address currentUser) public view returns (bool) {
78         for (uint i = 0; i < m_numOwners; ++i) {
79             if (m_owners[i] == currentUser) {
80                 return true;
81             }
82         }
83         return false;
84     }
85 
86     function checkAndConfirm(address currentUser, bytes32 operation) public returns (bool) {
87         uint ownerIndex = m_numOwners;
88         uint i;
89         for (i = 0; i < m_numOwners; ++i) {
90             if (m_owners[i] == currentUser) {
91                 ownerIndex = i;
92             }
93         }
94         if (ownerIndex == m_numOwners) {
95             return false;  // Not Owner
96         }
97         
98         uint newBitFinger = (m_pendings[operation] | (2 ** ownerIndex));
99 
100         uint confirmTotal = 0;
101         for (i = 0; i < m_numOwners; ++i) {
102             if ((newBitFinger & (2 ** i)) > 0) {
103                 confirmTotal ++;
104             }
105         }
106         
107         AcceptConfirm(operation, currentUser, confirmTotal);
108 
109         if (confirmTotal >= m_multiRequires) {
110             delete m_pendings[operation];
111             return true;
112         }
113         else {
114             m_pendings[operation] = newBitFinger;
115             return false;
116         }
117     }
118 }
119 
120 // File: contracts\Pausable.sol
121 
122 /**
123  * FEATURE 3): Pausable implementation
124  */
125 contract Pausable is MultiOwnable {
126     event Pause();
127     event Unpause();
128 
129     bool paused = false;
130 
131     // Modifier to make a function callable only when the contract is not paused.
132     modifier whenNotPaused() {
133         require(!paused);
134         _;
135     }
136 
137     // Modifier to make a function callable only when the contract is paused.
138     modifier whenPaused() {
139         require(paused);
140         _;
141     }
142 
143     // called by the owner to pause, triggers stopped state
144     function pause() mostOwner(keccak256(msg.data)) whenNotPaused public {
145         paused = true;
146         Pause();
147     }
148 
149     // called by the owner to unpause, returns to normal state
150     function unpause() mostOwner(keccak256(msg.data)) whenPaused public {
151         paused = false;
152         Unpause();
153     }
154 
155     function isPause() view public returns(bool) {
156         return paused;
157     }
158 }
159 
160 // File: contracts\SafeMath.sol
161 
162 /**
163 * Standard SafeMath Library: zeppelin-solidity/contracts/math/SafeMath.sol
164 */
165 library SafeMath {
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         if (a == 0) {
168             return 0;
169         }
170         uint256 c = a * b;
171         assert(c / a == b);
172         return c;
173     }
174 
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         // assert(b > 0); // Solidity automatically throws when dividing by 0
177         uint256 c = a / b;
178         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
179         return c;
180     }
181 
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         assert(b <= a);
184         return a - b;
185     }
186 
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         uint256 c = a + b;
189         assert(c >= a);
190         return c;
191     }
192 }
193 
194 // File: contracts\Convertible.sol
195 
196 /**
197  * Exchange all my ParcelX token to mainchain GPX
198  */
199 contract Convertible {
200 
201     function convertMainchainGPX(string destinationAccount, string extra) external returns (bool);
202   
203     // ParcelX deamon program is monitoring this event. 
204     // Once it triggered, ParcelX will transfer corresponding GPX to destination account
205     event Converted(address indexed who, string destinationAccount, uint256 amount, string extra);
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
218     string public constant symbol = "GPX";
219     uint8 public constant decimals = 18;
220 
221     // Main - 50000 ETH * int(1 / 0.000268) = 186550000
222     uint256 public constant TOTAL_SUPPLY = uint256(186550000) * (uint256(10) ** decimals);
223     
224     address internal tokenPool = address(0);      // Use a token pool holding all GPX. Avoid using sender address.
225     mapping(address => uint256) internal balances;
226     mapping (address => mapping (address => uint256)) internal allowed;
227 
228     function ParcelXGPX(address[] _multiOwners, uint _multiRequires) 
229         MultiOwnable(_multiOwners, _multiRequires) public {
230         require(tokenPool == address(0));
231         tokenPool = this;
232         require(tokenPool != address(0));
233         balances[tokenPool] = TOTAL_SUPPLY;
234     }
235 
236     /**
237      * FEATURE 1): ERC20 implementation
238      */
239     function totalSupply() public view returns (uint256) {
240         return TOTAL_SUPPLY;       
241     }
242 
243     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
244         require(_to != address(0));
245         require(_value <= balances[msg.sender]);
246 
247         // SafeMath.sub will throw if there is not enough balance.
248         balances[msg.sender] = balances[msg.sender].sub(_value);
249         balances[_to] = balances[_to].add(_value);
250         Transfer(msg.sender, _to, _value);
251         return true;
252   }
253 
254     function balanceOf(address _owner) public view returns (uint256) {
255         return balances[_owner];
256     }
257 
258     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
259         require(_to != address(0));
260         require(_value <= balances[_from]);
261         require(_value <= allowed[_from][msg.sender]);
262 
263         balances[_from] = balances[_from].sub(_value);
264         balances[_to] = balances[_to].add(_value);
265         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
266         Transfer(_from, _to, _value);
267         return true;
268     }
269 
270     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
271         allowed[msg.sender][_spender] = _value;
272         Approval(msg.sender, _spender, _value);
273         return true;
274     }
275 
276     function allowance(address _owner, address _spender) public view returns (uint256) {
277         return allowed[_owner][_spender];
278     }
279 
280     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
281         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283         return true;
284     }
285 
286     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
287         uint oldValue = allowed[msg.sender][_spender];
288         if (_subtractedValue > oldValue) {
289             allowed[msg.sender][_spender] = 0;
290         } else {
291             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292         }
293         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294         return true;
295     }
296 
297     /**
298      * FEATURE 4): Buyable implements
299      * 0.000268 eth per GPX, so the rate is 1.0 / 0.000268 = 3731.3432835820895
300      */
301     uint256 internal buyRate = uint256(3731); 
302     
303     event Deposit(address indexed who, uint256 value);
304     event Withdraw(address indexed who, uint256 value, address indexed lastApprover, string extra);
305         
306 
307     function getBuyRate() external view returns (uint256) {
308         return buyRate;
309     }
310 
311     function setBuyRate(uint256 newBuyRate) mostOwner(keccak256(msg.data)) external {
312         buyRate = newBuyRate;
313     }
314 
315     /**
316      * FEATURE 4): Buyable
317      * minimum of 0.001 ether for purchase in the public, pre-ico, and private sale
318      */
319     function buy() payable whenNotPaused public returns (uint256) {
320         Deposit(msg.sender, msg.value);
321         require(msg.value >= 0.001 ether);
322 
323         // Token compute & transfer
324         uint256 tokens = msg.value.mul(buyRate);
325         require(balances[tokenPool] >= tokens);
326         balances[tokenPool] = balances[tokenPool].sub(tokens);
327         balances[msg.sender] = balances[msg.sender].add(tokens);
328         Transfer(tokenPool, msg.sender, tokens);
329         
330         return tokens;
331     }
332 
333     // gets called when no other function matches
334     function () payable public {
335         if (msg.value > 0) {
336             buy();
337         }
338     }
339 
340     /**
341      * FEATURE 6): Budget control
342      * Malloc GPX for airdrops, marketing-events, bonus, etc 
343      */
344     function mallocBudget(address _admin, uint256 _value) mostOwner(keccak256(msg.data)) external returns (bool) {
345         require(_admin != address(0));
346         require(_value <= balances[tokenPool]);
347 
348         balances[tokenPool] = balances[tokenPool].sub(_value);
349         balances[_admin] = balances[_admin].add(_value);
350         Transfer(tokenPool, _admin, _value);
351         return true;
352     }
353     
354     function execute(address _to, uint256 _value, string _extra) mostOwner(keccak256(msg.data)) external returns (bool){
355         require(_to != address(0));
356         _to.transfer(_value);   // Prevent using call() or send()
357         Withdraw(_to, _value, msg.sender, _extra);
358         return true;
359     }
360 
361     /**
362      * FEATURE 5): 'Convertible' implements
363      * Below actions would be performed after token being converted into mainchain:
364      * - KYC / AML
365      * - Unsold tokens are discarded.
366      * - Tokens sold with bonus will be locked for a period (see Whitepaper).
367      * - Token distribution for team will be locked for a period (see Whitepaper).
368      */
369     function convertMainchainGPX(string destinationAccount, string extra) external returns (bool) {
370         require(bytes(destinationAccount).length > 10 && bytes(destinationAccount).length < 1024);
371         require(balances[msg.sender] > 0);
372         uint256 amount = balances[msg.sender];
373         balances[msg.sender] = 0;
374         balances[tokenPool] = balances[tokenPool].add(amount);   // return GPX to tokenPool - the init account
375         Converted(msg.sender, destinationAccount, amount, extra);
376         return true;
377     }
378 
379 }