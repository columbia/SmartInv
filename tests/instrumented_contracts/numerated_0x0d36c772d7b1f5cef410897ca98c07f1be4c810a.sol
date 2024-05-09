1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7     /**
8      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9      * account.
10      */
11     function Ownable() {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     address newOwner;
21     function transferOwnership(address _newOwner) onlyOwner {
22         if (_newOwner != address(0)) {
23             newOwner = _newOwner;
24         }
25     }
26     function acceptOwnership() {
27         if (msg.sender == newOwner) {
28             owner = newOwner;
29         }
30     }
31 }
32 
33 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
34 
35 contract ERC20 is Ownable {
36     /* Public variables of the token */
37     string public standard;
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public initialSupply;
42     bool public locked;
43     uint256 public creationBlock;
44     mapping (address => uint256) public balances;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     /* This generates a public event on the blockchain that will notify clients */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     modifier onlyPayloadSize(uint numwords) {
51         assert(msg.data.length == numwords * 32 + 4);
52         _;
53     }
54 
55     /* Initializes contract with initial supply tokens to the creator of the contract */
56     function ERC20(
57     uint256 _initialSupply,
58     string tokenName,
59     uint8 decimalUnits,
60     string tokenSymbol,
61     bool transferAllSupplyToOwner,
62     bool _locked
63     ) {
64         standard = 'ERC20 0.1';
65 
66         initialSupply = _initialSupply;
67 
68         if (transferAllSupplyToOwner) {
69             setBalance(msg.sender, initialSupply);
70         }
71         else {
72             setBalance(this, initialSupply);
73         }
74 
75         name = tokenName;
76         // Set the name for display purposes
77         symbol = tokenSymbol;
78         // Set the symbol for display purposes
79         decimals = decimalUnits;
80         // Amount of decimals for display purposes
81         locked = _locked;
82         creationBlock = block.number;
83     }
84 
85     /* internal balances */
86 
87     function setBalance(address holder, uint256 amount) internal {
88         balances[holder] = amount;
89     }
90 
91     function transferInternal(address _from, address _to, uint256 value) internal returns (bool success) {
92         if (value == 0) {
93             return true;
94         }
95 
96         if (balances[_from] < value) {
97             return false;
98         }
99 
100         if (balances[_to] + value <= balances[_to]) {
101             return false;
102         }
103 
104         setBalance(_from, balances[_from] - value);
105         setBalance(_to, balances[_to] + value);
106 
107         Transfer(_from, _to, value);
108 
109         return true;
110     }
111 
112     /* public methods */
113     function totalSupply() public returns (uint256) {
114         return initialSupply;
115     }
116 
117     function balanceOf(address _address) public returns (uint256) {
118         return balances[_address];
119     }
120 
121     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
122         require(locked == false);
123 
124         bool status = transferInternal(msg.sender, _to, _value);
125 
126         require(status == true);
127 
128         return true;
129     }
130 
131     function approve(address _spender, uint256 _value) public returns (bool success) {
132         if(locked) {
133             return false;
134         }
135 
136         allowance[msg.sender][_spender] = _value;
137 
138         return true;
139     }
140 
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
142         if (locked) {
143             return false;
144         }
145 
146         tokenRecipient spender = tokenRecipient(_spender);
147 
148         if (approve(_spender, _value)) {
149             spender.receiveApproval(msg.sender, _value, this, _extraData);
150             return true;
151         }
152     }
153 
154     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
155         if (locked) {
156             return false;
157         }
158 
159         if (allowance[_from][msg.sender] < _value) {
160             return false;
161         }
162 
163         bool _success = transferInternal(_from, _to, _value);
164 
165         if (_success) {
166             allowance[_from][msg.sender] -= _value;
167         }
168 
169         return _success;
170     }
171 
172 }
173 
174 contract MintingERC20 is ERC20 {
175 
176     mapping (address => bool) public minters;
177 
178     uint256 public maxSupply;
179 
180     function MintingERC20(
181     uint256 _initialSupply,
182     uint256 _maxSupply,
183     string _tokenName,
184     uint8 _decimals,
185     string _symbol,
186     bool _transferAllSupplyToOwner,
187     bool _locked
188     )
189     ERC20(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
190 
191     {
192         standard = "MintingERC20 0.1";
193         minters[msg.sender] = true;
194         maxSupply = _maxSupply;
195     }
196 
197 
198     function addMinter(address _newMinter) onlyOwner {
199         minters[_newMinter] = true;
200     }
201 
202 
203     function removeMinter(address _minter) onlyOwner {
204         minters[_minter] = false;
205     }
206 
207 
208     function mint(address _addr, uint256 _amount) onlyMinters returns (uint256) {
209         if (locked == true) {
210             return uint256(0);
211         }
212 
213         if (_amount == uint256(0)) {
214             return uint256(0);
215         }
216         if (initialSupply + _amount <= initialSupply){
217             return uint256(0);
218         }
219         if (initialSupply + _amount > maxSupply) {
220             return uint256(0);
221         }
222 
223         initialSupply += _amount;
224         balances[_addr] += _amount;
225         Transfer(this, _addr, _amount);
226         return _amount;
227     }
228 
229 
230     modifier onlyMinters () {
231         require(true == minters[msg.sender]);
232         _;
233     }
234 }
235 
236 contract Lamden is MintingERC20 {
237 
238 
239     uint8 public decimals = 18;
240 
241     string public tokenName = "Lamden Tau";
242 
243     string public tokenSymbol = "TAU";
244 
245     uint256 public  maxSupply = 500 * 10 ** 6 * uint(10) ** decimals; // 500,000,000
246 
247     // We block token transfers till ICO end.
248     bool public transferFrozen = true;
249 
250     function Lamden(
251     uint256 initialSupply,
252     bool _locked
253     ) MintingERC20(initialSupply, maxSupply, tokenName, decimals, tokenSymbol, false, _locked) {
254         standard = 'Lamden 0.1';
255     }
256 
257     function setLocked(bool _locked) onlyOwner {
258         locked = _locked;
259     }
260 
261     // Allow token transfer.
262     function freezing(bool _transferFrozen) onlyOwner {
263         transferFrozen = _transferFrozen;
264     }
265 
266     // ERC20 functions
267     // =========================
268 
269     function transfer(address _to, uint _value) returns (bool) {
270         require(!transferFrozen);
271         return super.transfer(_to, _value);
272 
273     }
274 
275     // should  not have approve/transferFrom
276     function approve(address, uint) returns (bool success)  {
277         require(false);
278         return false;
279         //        super.approve(_spender, _value);
280     }
281 
282     function approveAndCall(address, uint256, bytes) returns (bool success) {
283         require(false);
284         return false;
285     }
286 
287     function transferFrom(address, address, uint)  returns (bool success) {
288         require(false);
289         return false;
290         //        super.transferFrom(_from, _to, _value);
291     }
292 }
293 
294 contract LamdenTokenAllocation is Ownable {
295 
296     Lamden public tau;
297 
298     uint256 public constant LAMDEN_DECIMALS = 10 ** 18;
299 
300     uint256 allocatedTokens = 0;
301 
302     Allocation[] allocations;
303 
304     struct Allocation {
305     address _address;
306     uint256 amount;
307     }
308 
309 
310     function LamdenTokenAllocation(
311     address _tau,
312     address[] addresses
313     ){
314         require(uint8(addresses.length) == uint8(14));
315         allocations.push(Allocation(addresses[0], 20000000 * LAMDEN_DECIMALS)); //Stu
316         allocations.push(Allocation(addresses[1], 12500000 * LAMDEN_DECIMALS)); //Nick
317         allocations.push(Allocation(addresses[2], 8750000 * LAMDEN_DECIMALS)); //James
318         allocations.push(Allocation(addresses[3], 8750000 * LAMDEN_DECIMALS)); //Mario
319         allocations.push(Allocation(addresses[4], 250000 * LAMDEN_DECIMALS));     // Advisor
320         allocations.push(Allocation(addresses[5], 250000 * LAMDEN_DECIMALS));  // Advisor
321         allocations.push(Allocation(addresses[6], 250000 * LAMDEN_DECIMALS));  // Advisor
322         allocations.push(Allocation(addresses[7], 250000 * LAMDEN_DECIMALS));  // Advisor
323         allocations.push(Allocation(addresses[8], 250000 * LAMDEN_DECIMALS));  // Advisor
324         allocations.push(Allocation(addresses[9], 250000 * LAMDEN_DECIMALS));  // Advisor
325         allocations.push(Allocation(addresses[10], 250000 * LAMDEN_DECIMALS));  // Advisor
326         allocations.push(Allocation(addresses[11], 250000 * LAMDEN_DECIMALS));  // Advisor
327         allocations.push(Allocation(addresses[12], 48000000 * LAMDEN_DECIMALS));  // enterpriseCaseStudies
328         allocations.push(Allocation(addresses[13], 50000000  * LAMDEN_DECIMALS));  // AKA INNOVATION FUND
329         tau = Lamden(_tau);
330     }
331 
332     function allocateTokens(){
333         require(uint8(allocations.length) == uint8(14));
334         require(address(tau) != 0x0);
335         require(allocatedTokens == 0);
336         for (uint8 i = 0; i < allocations.length; i++) {
337             Allocation storage allocation = allocations[i];
338             uint256 mintedAmount = tau.mint(allocation._address, allocation.amount);
339             require(mintedAmount == allocation.amount);
340             allocatedTokens += allocation.amount;
341         }
342     }
343 
344     function setTau(address _tau) onlyOwner {
345         tau = Lamden(_tau);
346     }
347 }