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
36 }
37 
38 // File: contracts\MultiOwnable.sol
39 
40 /**
41  * FEATURE 2): MultiOwnable implementation
42  * Transactions approved by _multiRequires of _multiOwners' addresses will be executed. 
43 
44  * All functions needing unit-tests cannot be INTERNAL
45  */
46 contract MultiOwnable {
47 
48     address[8] m_owners;
49     uint m_numOwners;
50     uint m_multiRequires;
51 
52     mapping (bytes32 => uint) internal m_pendings;
53 
54     event AcceptConfirm(address indexed who, uint confirmTotal);
55     
56     // constructor is given number of sigs required to do protected "multiOwner" transactions
57     function MultiOwnable (address[] _multiOwners, uint _multiRequires) public {
58         require(0 < _multiRequires && _multiRequires <= _multiOwners.length);
59         m_numOwners = _multiOwners.length;
60         require(m_numOwners <= 8);   // Bigger then 8 co-owners, not support !
61         for (uint i = 0; i < _multiOwners.length; ++i) {
62             m_owners[i] = _multiOwners[i];
63             require(m_owners[i] != address(0));
64         }
65         m_multiRequires = _multiRequires;
66     }
67 
68     // Any one of the owners, will approve the action
69     modifier anyOwner {
70         if (isOwner(msg.sender)) {
71             _;
72         }
73     }
74 
75     // Requiring num > m_multiRequires owners, to approve the action
76     modifier mostOwner(bytes32 operation) {
77         if (checkAndConfirm(msg.sender, operation)) {
78             _;
79         }
80     }
81 
82     function isOwner(address currentUser) public view returns (bool) {
83         for (uint i = 0; i < m_numOwners; ++i) {
84             if (m_owners[i] == currentUser) {
85                 return true;
86             }
87         }
88         return false;
89     }
90 
91     function checkAndConfirm(address currentUser, bytes32 operation) public returns (bool) {
92         uint ownerIndex = m_numOwners;
93         uint i;
94         for (i = 0; i < m_numOwners; ++i) {
95             if (m_owners[i] == currentUser) {
96                 ownerIndex = i;
97             }
98         }
99         if (ownerIndex == m_numOwners) {
100             return false;  // Not Owner
101         }
102         
103         uint newBitFinger = (m_pendings[operation] | (2 ** ownerIndex));
104 
105         uint confirmTotal = 0;
106         for (i = 0; i < m_numOwners; ++i) {
107             if ((newBitFinger & (2 ** i)) > 0) {
108                 confirmTotal ++;
109             }
110         }
111         
112         AcceptConfirm(currentUser, confirmTotal);
113 
114         if (confirmTotal >= m_multiRequires) {
115             delete m_pendings[operation];
116             return true;
117         }
118         else {
119             m_pendings[operation] = newBitFinger;
120             return false;
121         }
122     }
123 }
124 
125 // File: contracts\Pausable.sol
126 
127 /**
128  * FEATURE 3): Pausable implementation
129  */
130 contract Pausable is MultiOwnable {
131     event Pause();
132     event Unpause();
133 
134     bool paused = false;
135 
136     // Modifier to make a function callable only when the contract is not paused.
137     modifier whenNotPaused() {
138         require(!paused);
139         _;
140     }
141 
142     // Modifier to make a function callable only when the contract is paused.
143     modifier whenPaused() {
144         require(paused);
145         _;
146     }
147 
148     // called by the owner to pause, triggers stopped state
149     function pause() mostOwner(keccak256(msg.data)) whenNotPaused public {
150         paused = true;
151         Pause();
152     }
153 
154     // called by the owner to unpause, returns to normal state
155     function unpause() mostOwner(keccak256(msg.data)) whenPaused public {
156         paused = false;
157         Unpause();
158     }
159 
160     function isPause() view public returns(bool) {
161         return paused;
162     }
163 }
164 
165 // File: contracts\SafeMath.sol
166 
167 /**
168 * Standard SafeMath Library: zeppelin-solidity/contracts/math/SafeMath.sol
169 */
170 library SafeMath {
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         if (a == 0) {
173             return 0;
174         }
175         uint256 c = a * b;
176         assert(c / a == b);
177         return c;
178     }
179 
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         // assert(b > 0); // Solidity automatically throws when dividing by 0
182         uint256 c = a / b;
183         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184         return c;
185     }
186 
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         assert(b <= a);
189         return a - b;
190     }
191 
192     function add(uint256 a, uint256 b) internal pure returns (uint256) {
193         uint256 c = a + b;
194         assert(c >= a);
195         return c;
196     }
197 }
198 
199 // File: contracts\ParcelXGPX.sol
200 
201 /**
202  * The main body of final smart contract 
203  */
204 contract ParcelXToken is ERC20, MultiOwnable, Pausable, Convertible {
205 
206     using SafeMath for uint256;
207   
208     string public constant name = "TestGPXv2";
209     string public constant symbol = "TestGPXv2";
210     uint8 public constant decimals = 18;
211     uint256 public constant TOTAL_SUPPLY = uint256(1000000000) * (uint256(10) ** decimals);  // 10,0000,0000
212 
213     address internal tokenPool;      // Use a token pool holding all GPX. Avoid using sender address.
214     mapping(address => uint256) internal balances;
215     mapping (address => mapping (address => uint256)) internal allowed;
216 
217     function ParcelXToken(address[] _multiOwners, uint _multiRequires) 
218         MultiOwnable(_multiOwners, _multiRequires) public {
219         tokenPool = this;
220         require(tokenPool != address(0));
221         balances[tokenPool] = TOTAL_SUPPLY;
222     }
223 
224     /**
225      * FEATURE 1): ERC20 implementation
226      */
227     function totalSupply() public view returns (uint256) {
228         return TOTAL_SUPPLY;       
229     }
230 
231     function transfer(address _to, uint256 _value) public returns (bool) {
232         require(_to != address(0));
233         require(_value <= balances[msg.sender]);
234 
235         // SafeMath.sub will throw if there is not enough balance.
236         balances[msg.sender] = balances[msg.sender].sub(_value);
237         balances[_to] = balances[_to].add(_value);
238         Transfer(msg.sender, _to, _value);
239         return true;
240   }
241 
242     function balanceOf(address _owner) public view returns (uint256) {
243         return balances[_owner];
244     }
245 
246     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
247         require(_to != address(0));
248         require(_value <= balances[_from]);
249         require(_value <= allowed[_from][msg.sender]);
250 
251         balances[_from] = balances[_from].sub(_value);
252         balances[_to] = balances[_to].add(_value);
253         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
254         Transfer(_from, _to, _value);
255         return true;
256     }
257 
258     function approve(address _spender, uint256 _value) public returns (bool) {
259         allowed[msg.sender][_spender] = _value;
260         Approval(msg.sender, _spender, _value);
261         return true;
262     }
263 
264     function allowance(address _owner, address _spender) public view returns (uint256) {
265         return allowed[_owner][_spender];
266     }
267 
268     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
269         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
270         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271         return true;
272     }
273 
274     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
275         uint oldValue = allowed[msg.sender][_spender];
276         if (_subtractedValue > oldValue) {
277             allowed[msg.sender][_spender] = 0;
278         } else {
279             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
280         }
281         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282         return true;
283     }
284 
285     /**
286      * FEATURE 4): Buyable implements
287      * 0.000268 eth per GPX, so the rate is 1.0 / 0.000268 = 3731.3432835820895
288      */
289     uint256 internal buyRate = uint256(3731); 
290     
291     event Deposit(address indexed who, uint256 value);
292     event Withdraw(address indexed who, uint256 value, address indexed lastApprover, string extra);
293         
294 
295     function getBuyRate() external view returns (uint256) {
296         return buyRate;
297     }
298 
299     function setBuyRate(uint256 newBuyRate) mostOwner(keccak256(msg.data)) external {
300         buyRate = newBuyRate;
301     }
302 
303     /**
304      * FEATURE 4): Buyable
305      * minimum of 0.001 ether for purchase in the public, pre-ico, and private sale
306      */
307     function buy() payable whenNotPaused public returns (uint256) {
308         Deposit(msg.sender, msg.value);
309         require(msg.value >= 0.001 ether);
310 
311         // Token compute & transfer
312         uint256 tokens = msg.value.mul(buyRate);
313         require(balances[tokenPool] >= tokens);
314         balances[tokenPool] = balances[tokenPool].sub(tokens);
315         balances[msg.sender] = balances[msg.sender].add(tokens);
316         Transfer(tokenPool, msg.sender, tokens);
317         
318         return tokens;
319     }
320 
321     // gets called when no other function matches
322     function () payable public {
323         if (msg.value > 0) {
324             buy();
325         }
326     }
327 
328     function execute(address _to, uint256 _value, string _extra) mostOwner(keccak256(msg.data)) external returns (bool){
329         require(_to != address(0));
330         Withdraw(_to, _value, msg.sender, _extra);
331         _to.transfer(_value);
332         return true;
333     }
334 
335     /**
336      * FEATURE 5): Convertible implements
337      */
338     function convertMainchainGPX(string destinationAccount, string extra) external returns (bool) {
339         require(bytes(destinationAccount).length > 10 && bytes(destinationAccount).length < 128);
340         require(balances[msg.sender] > 0);
341         uint256 amount = balances[msg.sender];
342         balances[msg.sender] = 0;
343         balances[tokenPool] = balances[tokenPool].add(amount);   // recycle ParcelX to tokenPool's init account
344         Converted(msg.sender, destinationAccount, amount, extra);
345         return true;
346     }
347 
348 }