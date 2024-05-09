1 /**
2  * @title DVIP Contract. DCAsset Membership Token contract.
3  *
4  * @author Ray Pulver, ray@decentralizedcapital.com
5  */
6 contract Relay {
7   function relayReceiveApproval(address _caller, address _spender, uint256 _amount, bytes _extraData) returns (bool success);
8 }
9 
10 contract DVIPBackend {
11   uint8 public decimals;
12   function assert(bool assertion) {
13     if (!assertion) throw;
14   }
15   address public owner;
16   event SetOwner(address indexed previousOwner, address indexed newOwner);
17   modifier onlyOwner {
18     assert(msg.sender == owner);
19     _
20   }
21   function setOwner(address newOwner) onlyOwner {
22     SetOwner(owner, newOwner);
23     owner = newOwner;
24   }
25   bool internal locked;
26   event Locked(address indexed from);
27   event PropertySet(address indexed from);
28   modifier onlyIfUnlocked {
29     assert(!locked);
30     _
31   }
32   modifier setter {
33     _
34     PropertySet(msg.sender);
35   }
36   modifier onlyOwnerUnlocked {
37     assert(!locked && msg.sender == owner);
38     _
39   }
40   function lock() onlyOwner onlyIfUnlocked {
41     locked = true;
42     Locked(msg.sender);
43   }
44   function isLocked() returns (bool status) {
45     return locked;
46   }
47   bytes32 public standard = 'Token 0.1';
48   bytes32 public name;
49   bytes32 public symbol;
50   bool public allowTransactions;
51   uint256 public totalSupply;
52 
53   event Approval(address indexed from, address indexed spender, uint256 amount);
54 
55   mapping (address => uint256) public balanceOf;
56   mapping (address => mapping (address => uint256)) public allowance;
57 
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 
60   function () {
61     throw;
62   }
63 
64   uint256 public expiry;
65   uint8 public feeDecimals;
66   mapping (address => uint256) public validAfter;
67   uint256 public mustHoldFor;
68   address public hotwalletAddress;
69   address public frontendAddress;
70   mapping (address => bool) public frozenAccount;
71   mapping (address => uint256) public exportFee;
72 
73   event FeeSetup(address indexed from, address indexed target, uint256 amount);
74   event Processed(address indexed sender);
75 
76   modifier onlyAsset {
77     if (msg.sender != frontendAddress) throw;
78     _
79   }
80 
81   /**
82    * Constructor.
83    *
84    */
85   function DVIPBackend(address _hotwalletAddress, address _frontendAddress) {
86     owner = msg.sender;
87     hotwalletAddress = _hotwalletAddress;
88     frontendAddress = _frontendAddress;
89     allowTransactions = true;
90     totalSupply = 0;
91     name = "DVIP";
92     symbol = "DVIP";
93     feeDecimals = 6;
94     expiry = 1514764800; //1 jan 2018
95     mustHoldFor = 86400;
96   }
97 
98   function setHotwallet(address _address) onlyOwnerUnlocked {
99     hotwalletAddress = _address;
100     PropertySet(msg.sender);
101   }
102 
103   function setFrontend(address _address) onlyOwnerUnlocked {
104     frontendAddress = _address;
105     PropertySet(msg.sender);
106   } 
107 
108   /**
109    * @notice Transfer `_amount` from `msg.sender.address()` to `_to`.
110    *
111    * @param _to Address that will receive.
112    * @param _amount Amount to be transferred.
113    */
114   function transfer(address caller, address _to, uint256 _amount) onlyAsset returns (bool success) {
115     assert(allowTransactions);
116     assert(balanceOf[caller] >= _amount);
117     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
118     assert(!frozenAccount[caller]);
119     assert(!frozenAccount[_to]);
120     balanceOf[caller] -= _amount;
121     uint256 preBalance = balanceOf[_to];
122     balanceOf[_to] += _amount;
123     if (preBalance <= 1 && balanceOf[_to] >= 1) {
124       validAfter[_to] = now + mustHoldFor;
125     }
126     Transfer(caller, _to, _amount);
127     return true;
128   }
129 
130   /**
131    * @notice Transfer `_amount` from `_from` to `_to`.
132    *
133    * @param _from Origin address
134    * @param _to Address that will receive
135    * @param _amount Amount to be transferred.
136    * @return result of the method call
137    */
138   function transferFrom(address caller, address _from, address _to, uint256 _amount) onlyAsset returns (bool success) {
139     assert(allowTransactions);
140     assert(balanceOf[_from] >= _amount);
141     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
142     assert(_amount <= allowance[_from][caller]);
143     assert(!frozenAccount[caller]);
144     assert(!frozenAccount[_from]);
145     assert(!frozenAccount[_to]);
146     balanceOf[_from] -= _amount;
147     uint256 preBalance = balanceOf[_to];
148     balanceOf[_to] += _amount;
149     allowance[_from][caller] -= _amount;
150     if (balanceOf[_to] >= 1 && preBalance <= 1) {
151       validAfter[_to] = now + mustHoldFor;
152     }
153     Transfer(_from, _to, _amount);
154     return true;
155   }
156 
157   /**
158    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
159    *
160    * @param _spender Address that receives the cheque
161    * @param _amount Amount on the cheque
162    * @param _extraData Consequential contract to be executed by spender in same transcation.
163    * @return result of the method call
164    */
165   function approveAndCall(address caller, address _spender, uint256 _amount, bytes _extraData) onlyAsset returns (bool success) {
166     assert(allowTransactions);
167     allowance[caller][_spender] = _amount;
168     Relay(frontendAddress).relayReceiveApproval(caller, _spender, _amount, _extraData);
169     Approval(caller, _spender, _amount);
170     return true;
171   }
172 
173   /**
174    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
175    *
176    * @param _spender Address that receives the cheque
177    * @param _amount Amount on the cheque
178    * @return result of the method call
179    */
180   function approve(address caller, address _spender, uint256 _amount) onlyAsset returns (bool success) {
181     assert(allowTransactions);
182     allowance[caller][_spender] = _amount;
183     Approval(caller, _spender, _amount);
184     return true;
185   }
186 
187   /* ---------------  multisig admin methods  --------------*/
188 
189 
190 
191   /**
192    * @notice Sets the expiry time in milliseconds since 1970.
193    *
194    * @param ts milliseconds since 1970.
195    *
196    */
197   function setExpiry(uint256 ts) onlyOwner {
198     expiry = ts;
199     Processed(msg.sender);
200   }
201 
202   /**
203    * @notice Mints `mintedAmount` new tokens to the hotwallet `hotWalletAddress`.
204    *
205    * @param mintedAmount Amount of new tokens to be minted.
206    */
207   function mint(uint256 mintedAmount) onlyOwner {
208     balanceOf[hotwalletAddress] += mintedAmount;
209     totalSupply += mintedAmount;
210     Processed(msg.sender);
211   }
212 
213   function freezeAccount(address target, bool frozen) onlyOwner {
214     frozenAccount[target] = frozen;
215     Processed(msg.sender);
216   }
217 
218   function seizeTokens(address target, uint256 amount) onlyOwner {
219     assert(balanceOf[target] >= amount);
220     assert(frozenAccount[target]);
221     balanceOf[target] -= amount;
222     balanceOf[hotwalletAddress] += amount;
223     Transfer(target, hotwalletAddress, amount);
224   }
225 
226   function destroyTokens(uint256 amt) onlyOwner {
227     assert(balanceOf[hotwalletAddress] >= amt);
228     balanceOf[hotwalletAddress] -= amt;
229     Processed(msg.sender);
230   }
231 
232   /**
233    * @notice Sets an export fee of `fee` on address `addr`
234    *
235    * @param addr Address for which the fee is valid
236    * @param addr fee Fee
237    *
238    */
239   function setExportFee(address addr, uint256 fee) onlyOwner {
240     exportFee[addr] = fee;
241     Processed(msg.sender);
242   }
243 
244   function setHoldingPeriod(uint256 ts) onlyOwner {
245     mustHoldFor = ts;
246     Processed(msg.sender);
247   }
248 
249   function setAllowTransactions(bool allow) onlyOwner {
250     allowTransactions = allow;
251     Processed(msg.sender);
252   }
253 
254   /* --------------- fee calculation method ---------------- */
255 
256 
257   /**
258    * @notice 'Returns the fee for a transfer from `from` to `to` on an amount `amount`.
259    *
260    * Fee's consist of a possible
261    *    - import fee on transfers to an address
262    *    - export fee on transfers from an address
263    * DVIP ownership on an address
264    *    - reduces fee on a transfer from this address to an import fee-ed address
265    *    - reduces the fee on a transfer to this address from an export fee-ed address
266    * DVIP discount does not work for addresses that have an import fee or export fee set up against them.
267    *
268    * DVIP discount goes up to 100%
269    *
270    * @param from From address
271    * @param to To address
272    * @param amount Amount for which fee needs to be calculated.
273    *
274    */
275   function feeFor(address from, address to, uint256 amount) constant external returns (uint256 value) {
276     uint256 fee = exportFee[from];
277     if (fee == 0) return 0;
278     if ((exportFee[from] == 0 && balanceOf[from] != 0 && now < expiry && validAfter[from] <= now) || (balanceOf[to] != 0 && now < expiry && validAfter[to] <= now)) return 0;
279     return div10(amount*fee, feeDecimals);
280   }
281   function div10(uint256 a, uint8 b) internal returns (uint256 result) {
282     for (uint8 i = 0; i < b; i++) {
283       a /= 10;
284     }
285     return a;
286   }
287 }