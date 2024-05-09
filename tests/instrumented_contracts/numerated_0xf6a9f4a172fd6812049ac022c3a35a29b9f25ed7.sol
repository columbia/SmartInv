1 pragma solidity ^0.4.20;
2 
3 /**
4 * Standard SafeMath Library: zeppelin-solidity/contracts/math/SafeMath.sol
5 */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 /**
36  * Buy GPX automatically when Ethers are received
37  */
38 contract Buyable {
39 
40     function buy() payable public returns (uint256);
41 
42 }
43 
44 
45 
46 /**
47  * Exchange all my ParcelX token to mainchain GPX
48  */
49 contract Convertible {
50 
51     function convertMainchainGPX(string destinationAccount, string extra) external returns (bool);
52   
53     // ParcelX deamon program is monitoring this event. 
54     // Once it triggered, ParcelX will transfer corresponding GPX to destination account
55     event Converted(address indexed who, string destinationAccount, uint256 amount, string extra);
56 }
57 
58 /**
59  * Starndard ERC20 interface: https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 {
62 
63     function totalSupply() public view returns (uint256);
64     function balanceOf(address who) public view returns (uint256);
65     function transfer(address to, uint256 value) public returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     function allowance(address owner, address spender) public view returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 /**
75  * FEATURE 2): MultiOwnable implementation
76  */
77 contract MultiOwnable {
78 
79     address[8] m_owners;
80     uint m_numOwners;
81     uint m_multiRequires;
82 
83     mapping (bytes32 => uint) internal m_pendings;
84 
85     // constructor is given number of sigs required to do protected "multiOwner" transactions
86     // as well as the selection of addresses capable of confirming them.
87     function MultiOwnable (address[] _otherOwners, uint _multiRequires) internal {
88         require(0 < _multiRequires && _multiRequires <= _otherOwners.length + 1);
89         m_numOwners = _otherOwners.length + 1;
90         require(m_numOwners <= 8);   // 不支持大于8人
91         m_owners[0] = msg.sender;
92         for (uint i = 0; i < _otherOwners.length; ++i) {
93             m_owners[1 + i] = _otherOwners[i];
94         }
95         m_multiRequires = _multiRequires;
96     }
97 
98     // Any one of the owners, will approve the action
99     modifier anyOwner {
100         if (isOwner(msg.sender)) {
101             _;
102         }
103     }
104 
105     // Requiring num > m_multiRequires owners, to approve the action
106     modifier mostOwner(bytes32 operation) {
107         if (checkAndConfirm(msg.sender, operation)) {
108             _;
109         }
110     }
111 
112     function isOwner(address currentOwner) internal view returns (bool) {
113         for (uint i = 0; i < m_numOwners; ++i) {
114             if (m_owners[i] == currentOwner) {
115                 return true;
116             }
117         }
118         return false;
119     }
120 
121     function checkAndConfirm(address currentOwner, bytes32 operation) internal returns (bool) {
122         uint ownerIndex = m_numOwners;
123         uint i;
124         for (i = 0; i < m_numOwners; ++i) {
125             if (m_owners[i] == currentOwner) {
126                 ownerIndex = i;
127             }
128         }
129         if (ownerIndex == m_numOwners) {
130             return false;  // Not Owner
131         }
132         
133         uint newBitFinger = (m_pendings[operation] | (2 ** ownerIndex));
134 
135         uint confirmTotal = 0;
136         for (i = 0; i < m_numOwners; ++i) {
137             if ((newBitFinger & (2 ** i)) > 0) {
138                 confirmTotal ++;
139             }
140         }
141         if (confirmTotal >= m_multiRequires) {
142             delete m_pendings[operation];
143             return true;
144         }
145         else {
146             m_pendings[operation] = newBitFinger;
147             return false;
148         }
149     }
150 }
151 
152 /**
153  * FEATURE 3): Pausable implementation
154  */
155 contract Pausable is MultiOwnable {
156     event Pause();
157     event Unpause();
158 
159     bool paused = false;
160 
161     // Modifier to make a function callable only when the contract is not paused.
162     modifier whenNotPaused() {
163         require(!paused);
164         _;
165     }
166 
167     // Modifier to make a function callable only when the contract is paused.
168     modifier whenPaused() {
169         require(paused);
170         _;
171     }
172 
173     // called by the owner to pause, triggers stopped state
174     function pause() mostOwner(keccak256(msg.data)) whenNotPaused public {
175         paused = true;
176         Pause();
177     }
178 
179     // called by the owner to unpause, returns to normal state
180     function unpause() mostOwner(keccak256(msg.data)) whenPaused public {
181         paused = false;
182         Unpause();
183     }
184 
185     function isPause() view public returns(bool) {
186         return paused;
187     }
188 }
189 
190 /**
191  * The main body of final smart contract 
192  */
193 contract ParcelXToken is ERC20, MultiOwnable, Pausable, Buyable, Convertible {
194 
195     using SafeMath for uint256;
196   
197     string public constant name = "TestGPX-name";
198     string public constant symbol = "TestGPX-symbol";
199     uint8 public constant decimals = 18;
200     uint256 public constant TOTAL_SUPPLY = uint256(1000000000) * (uint256(10) ** decimals);  // 10,0000,0000
201 
202     address internal tokenPool;      // Use a token pool holding all GPX. Avoid using sender address.
203     mapping(address => uint256) internal balances;
204     mapping (address => mapping (address => uint256)) internal allowed;
205 
206     function ParcelXToken(address[] _otherOwners, uint _multiRequires) 
207         MultiOwnable(_otherOwners, _multiRequires) public {
208         tokenPool = this;
209         balances[tokenPool] = TOTAL_SUPPLY;
210     }
211 
212     /**
213      * FEATURE 1): ERC20 implementation
214      */
215     function totalSupply() public view returns (uint256) {
216         return TOTAL_SUPPLY;       
217     }
218 
219     function transfer(address _to, uint256 _value) public returns (bool) {
220         require(_to != address(0));
221         require(_value <= balances[msg.sender]);
222 
223         // SafeMath.sub will throw if there is not enough balance.
224         balances[msg.sender] = balances[msg.sender].sub(_value);
225         balances[_to] = balances[_to].add(_value);
226         Transfer(msg.sender, _to, _value);
227         return true;
228   }
229 
230     function balanceOf(address _owner) public view returns (uint256) {
231         return balances[_owner];
232     }
233 
234     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
235         require(_to != address(0));
236         require(_value <= balances[_from]);
237         require(_value <= allowed[_from][msg.sender]);
238 
239         balances[_from] = balances[_from].sub(_value);
240         balances[_to] = balances[_to].add(_value);
241         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242         Transfer(_from, _to, _value);
243         return true;
244     }
245 
246     function approve(address _spender, uint256 _value) public returns (bool) {
247         allowed[msg.sender][_spender] = _value;
248         Approval(msg.sender, _spender, _value);
249         return true;
250     }
251 
252     function allowance(address _owner, address _spender) public view returns (uint256) {
253         return allowed[_owner][_spender];
254     }
255 
256     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259         return true;
260     }
261 
262     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
263         uint oldValue = allowed[msg.sender][_spender];
264         if (_subtractedValue > oldValue) {
265             allowed[msg.sender][_spender] = 0;
266         } else {
267             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268         }
269         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270         return true;
271     }
272 
273     /**
274      * FEATURE 4): Buyable implements
275      * 0.000268 eth per GPX, so the rate is 1.0 / 0.000268 = 3731.3432835820895
276      */
277     uint256 internal buyRate = uint256(3731); 
278     
279     event Deposit(address indexed who, uint256 value);
280     event Withdraw(address indexed who, uint256 value, address indexed lastApprover);
281         
282 
283     function getBuyRate() external view returns (uint256) {
284         return buyRate;
285     }
286 
287     function setBuyRate(uint256 newBuyRate) mostOwner(keccak256(msg.data)) external {
288         buyRate = newBuyRate;
289     }
290 
291     // minimum of 0.001 ether for purchase in the public, pre-ico, and private sale
292     function buy() payable whenNotPaused public returns (uint256) {
293         require(msg.value >= 0.001 ether);
294         uint256 tokens = msg.value.mul(buyRate);  // calculates the amount
295         require(balances[tokenPool] >= tokens);               // checks if it has enough to sell
296         balances[tokenPool] = balances[tokenPool].sub(tokens);                        // subtracts amount from seller's balance
297         balances[msg.sender] = balances[msg.sender].add(tokens);                  // adds the amount to buyer's balance
298         Transfer(tokenPool, msg.sender, tokens);               // execute an event reflecting the change
299         return tokens;                                    // ends function and returns
300     }
301 
302     // gets called when no other function matches
303     function () public payable {
304         if (msg.value > 0) {
305             buy();
306             Deposit(msg.sender, msg.value);
307         }
308     }
309 
310     function execute(address _to, uint256 _value, bytes _data) mostOwner(keccak256(msg.data)) external returns (bool){
311         require(_to != address(0));
312         Withdraw(_to, _value, msg.sender);
313         return _to.call.value(_value)(_data);
314     }
315 
316     /**
317      * FEATURE 5): Convertible implements
318      */
319     function convertMainchainGPX(string destinationAccount, string extra) external returns (bool) {
320         require(bytes(destinationAccount).length > 10 && bytes(destinationAccount).length < 128);
321         require(balances[msg.sender] > 0);
322         uint256 amount = balances[msg.sender];
323         balances[msg.sender] = 0;
324         balances[tokenPool] = balances[tokenPool].add(amount);   // recycle ParcelX to tokenPool's init account
325         Converted(msg.sender, destinationAccount, amount, extra);
326         return true;
327     }
328 
329 }