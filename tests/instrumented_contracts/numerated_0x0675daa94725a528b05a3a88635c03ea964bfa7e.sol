1 pragma solidity 0.4.18;
2 
3 
4 contract CrowdsaleParameters {
5     // Vesting time stamps:
6     // 1534672800 = August 19, 2018. 180 days from February 20, 2018. 10:00:00 GMT
7     // 1526896800 = May 21, 2018. 90 days from February 20, 2018. 10:00:00 GMT
8     uint32 internal vestingTime90Days = 1526896800;
9     uint32 internal vestingTime180Days = 1534672800;
10 
11     uint256 internal constant presaleStartDate = 1513072800; // Dec-12-2017 10:00:00 GMT
12     uint256 internal constant presaleEndDate = 1515751200; // Jan-12-2018 10:00:00 GMT
13     uint256 internal constant generalSaleStartDate = 1516442400; // Jan-20-2018 00:00:00 GMT
14     uint256 internal constant generalSaleEndDate = 1519120800; // Feb-20-2018 00:00:00 GMT
15 
16     struct AddressTokenAllocation {
17         address addr;
18         uint256 amount;
19         uint256 vestingTS;
20     }
21 
22     AddressTokenAllocation internal presaleWallet       = AddressTokenAllocation(0x43C5FB6b419E6dF1a021B9Ad205A18369c19F57F, 100e6, 0);
23     AddressTokenAllocation internal generalSaleWallet   = AddressTokenAllocation(0x0635c57CD62dA489f05c3dC755bAF1B148FeEdb0, 550e6, 0);
24     AddressTokenAllocation internal wallet1             = AddressTokenAllocation(0xae46bae68D0a884812bD20A241b6707F313Cb03a,  20e6, vestingTime180Days);
25     AddressTokenAllocation internal wallet2             = AddressTokenAllocation(0xfe472389F3311e5ea19B4Cd2c9945b6D64732F13,  20e6, vestingTime180Days);
26     AddressTokenAllocation internal wallet3             = AddressTokenAllocation(0xE37dfF409AF16B7358Fae98D2223459b17be0B0B,  20e6, vestingTime180Days);
27     AddressTokenAllocation internal wallet4             = AddressTokenAllocation(0x39482f4cd374D0deDD68b93eB7F3fc29ae7105db,  10e6, vestingTime180Days);
28     AddressTokenAllocation internal wallet5             = AddressTokenAllocation(0x03736d5B560fE0784b0F5c2D0eA76A7F15E5b99e,   5e6, vestingTime180Days);
29     AddressTokenAllocation internal wallet6             = AddressTokenAllocation(0xD21726226c32570Ab88E12A9ac0fb2ed20BE88B9,   5e6, vestingTime180Days);
30     AddressTokenAllocation internal foundersWallet      = AddressTokenAllocation(0xC66Cbb7Ba88F120E86920C0f85A97B2c68784755,  30e6, vestingTime90Days);
31     AddressTokenAllocation internal wallet7             = AddressTokenAllocation(0x24ce108d1975f79B57c6790B9d4D91fC20DEaf2d,   6e6, 0);
32     AddressTokenAllocation internal wallet8genesis      = AddressTokenAllocation(0x0125c6Be773bd90C0747012f051b15692Cd6Df31,   5e6, 0);
33     AddressTokenAllocation internal wallet9             = AddressTokenAllocation(0xFCF0589B6fa8A3f262C4B0350215f6f0ed2F630D,   5e6, 0);
34     AddressTokenAllocation internal wallet10            = AddressTokenAllocation(0x0D016B233e305f889BC5E8A0fd6A5f99B07F8ece,   4e6, 0);
35     AddressTokenAllocation internal wallet11bounty      = AddressTokenAllocation(0x68433cFb33A7Fdbfa74Ea5ECad0Bc8b1D97d82E9,  19e6, 0);
36     AddressTokenAllocation internal wallet12            = AddressTokenAllocation(0xd620A688adA6c7833F0edF48a45F3e39480149A6,   4e6, 0);
37     AddressTokenAllocation internal wallet13rsv         = AddressTokenAllocation(0x8C393F520f75ec0F3e14d87d67E95adE4E8b16B1, 100e6, 0);
38     AddressTokenAllocation internal wallet14partners    = AddressTokenAllocation(0x6F842b971F0076C4eEA83b051523d76F098Ffa52,  96e6, 0);
39     AddressTokenAllocation internal wallet15lottery     = AddressTokenAllocation(0xcaA48d91D49f5363B2974bb4B2DBB36F0852cf83,   1e6, 0);
40 
41     uint256 public minimumICOCap = 3333;
42 }
43 
44 contract Owned {
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50     *  Constructor
51     *
52     *  Sets contract owner to address of constructor caller
53     */
54     function Owned() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     /**
64     *  Change Owner
65     *
66     *  Changes ownership of this contract. Only owner can call this method.
67     *
68     * @param newOwner - new owner's address
69     */
70     function changeOwner(address newOwner) onlyOwner public {
71         require(newOwner != address(0));
72         require(newOwner != owner);
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 }
77 
78 contract TKLNToken is Owned, CrowdsaleParameters {
79     /* Public variables of the token */
80     string public standard = 'Token 0.1';
81     string public name = 'Taklimakan';
82     string public symbol = 'TKLN';
83     uint8 public decimals = 18;
84 
85     /* Arrays of all balances, vesting, approvals, and approval uses */
86     mapping (address => uint256) private balances;              // Total token balances
87     mapping (address => uint256) private balances90dayFreeze;   // Balances frozen for 90 days after ICO end
88     mapping (address => uint256) private balances180dayFreeze;  // Balances frozen for 180 days after ICO end
89     mapping (address => uint) private vestingTimesForPools;
90     mapping (address => mapping (address => uint256)) private allowed;
91     mapping (address => mapping (address => bool)) private allowanceUsed;
92 
93     /* This generates a public event on the blockchain that will notify clients */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     event Transfer(address indexed spender, address indexed from, address indexed to, uint256 value);
96     event VestingTransfer(address indexed from, address indexed to, uint256 value, uint256 vestingTime);
97     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98     event Issuance(uint256 _amount); // triggered when the total supply is increased
99     event Destruction(uint256 _amount); // triggered when the total supply is decreased
100     event NewTKLNToken(address _token);
101 
102     /* Miscellaneous */
103     uint256 public totalSupply = 0;
104     bool public transfersEnabled = true;
105 
106     /**
107     *  Constructor
108     *
109     *  Initializes contract with initial supply tokens to the creator of the contract
110     */
111     function TKLNToken() public {
112         owner = msg.sender;
113 
114         mintToken(presaleWallet);
115         mintToken(generalSaleWallet);
116         mintToken(wallet1);
117         mintToken(wallet2);
118         mintToken(wallet3);
119         mintToken(wallet4);
120         mintToken(wallet5);
121         mintToken(wallet6);
122         mintToken(foundersWallet);
123         mintToken(wallet7);
124         mintToken(wallet8genesis);
125         mintToken(wallet9);
126         mintToken(wallet10);
127         mintToken(wallet11bounty);
128         mintToken(wallet12);
129         mintToken(wallet13rsv);
130         mintToken(wallet14partners);
131         mintToken(wallet15lottery);
132 
133         NewTKLNToken(address(this));
134     }
135 
136     modifier transfersAllowed {
137         require(transfersEnabled);
138         _;
139     }
140 
141     modifier onlyPayloadSize(uint size) {
142         assert(msg.data.length >= size + 4);
143         _;
144     }
145 
146     /**
147     *  1. Associate crowdsale contract address with this Token
148     *  2. Allocate general sale amount
149     *
150     * @param _crowdsaleAddress - crowdsale contract address
151     */
152     function approveCrowdsale(address _crowdsaleAddress) external onlyOwner {
153         approveAllocation(generalSaleWallet, _crowdsaleAddress);
154     }
155 
156     /**
157     *  1. Associate pre-sale contract address with this Token
158     *  2. Allocate presale amount
159     *
160     * @param _presaleAddress - pre-sale contract address
161     */
162     function approvePresale(address _presaleAddress) external onlyOwner {
163         approveAllocation(presaleWallet, _presaleAddress);
164     }
165 
166     function approveAllocation(AddressTokenAllocation tokenAllocation, address _crowdsaleAddress) internal {
167         uint uintDecimals = decimals;
168         uint exponent = 10**uintDecimals;
169         uint amount = tokenAllocation.amount * exponent;
170 
171         allowed[tokenAllocation.addr][_crowdsaleAddress] = amount;
172         Approval(tokenAllocation.addr, _crowdsaleAddress, amount);
173     }
174 
175     /**
176     *  Get token balance of an address
177     *
178     * @param _address - address to query
179     * @return Token balance of _address
180     */
181     function balanceOf(address _address) public constant returns (uint256 balance) {
182         return balances[_address];
183     }
184 
185     /**
186     *  Get vested token balance of an address
187     *
188     * @param _address - address to query
189     * @return balance that has vested
190     */
191     function vestedBalanceOf(address _address) public constant returns (uint256 balance) {
192         return balances[_address] - balances90dayFreeze[_address] - balances180dayFreeze[_address];
193     }
194 
195     /**
196     *  Get token amount allocated for a transaction from _owner to _spender addresses
197     *
198     * @param _owner - owner address, i.e. address to transfer from
199     * @param _spender - spender address, i.e. address to transfer to
200     * @return Remaining amount allowed to be transferred
201     */
202     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
203         return allowed[_owner][_spender];
204     }
205 
206     /**
207     *  Send coins from sender's address to address specified in parameters
208     *
209     * @param _to - address to send to
210     * @param _value - amount to send in Wei
211     */
212     function transfer(address _to, uint256 _value) public transfersAllowed onlyPayloadSize(2*32) returns (bool success) {
213         updateVesting(msg.sender);
214 
215         require(vestedBalanceOf(msg.sender) >= _value);
216 
217         // Subtract from the sender
218         // _value is never greater than balance of input validation above
219         balances[msg.sender] -= _value;
220 
221         // If tokens issued from this address need to vest (i.e. this address is a pool), freeze them here
222         if (vestingTimesForPools[msg.sender] > 0) {
223             addToVesting(msg.sender, _to, vestingTimesForPools[msg.sender], _value);
224         }
225 
226         // Overflow is never possible due to input validation above
227         balances[_to] += _value;
228 
229         Transfer(msg.sender, _to, _value);
230         return true;
231     }
232 
233     /**
234     *  Create token and credit it to target address
235     *  Created tokens need to vest
236     *
237     */
238     function mintToken(AddressTokenAllocation tokenAllocation) internal {
239         // Add vesting time for this pool
240         vestingTimesForPools[tokenAllocation.addr] = tokenAllocation.vestingTS;
241 
242         uint uintDecimals = decimals;
243         uint exponent = 10**uintDecimals;
244         uint mintedAmount = tokenAllocation.amount * exponent;
245 
246         // Mint happens right here: Balance becomes non-zero from zero
247         balances[tokenAllocation.addr] += mintedAmount;
248         totalSupply += mintedAmount;
249 
250         // Emit Issue and Transfer events
251         Issuance(mintedAmount);
252         Transfer(address(this), tokenAllocation.addr, mintedAmount);
253     }
254 
255     /**
256     *  Allow another contract to spend some tokens on your behalf
257     *
258     * @param _spender - address to allocate tokens for
259     * @param _value - number of tokens to allocate
260     * @return True in case of success, otherwise false
261     */
262     function approve(address _spender, uint256 _value) public onlyPayloadSize(2*32) returns (bool success) {
263         require(_value == 0 || allowanceUsed[msg.sender][_spender] == false);
264 
265         allowed[msg.sender][_spender] = _value;
266         allowanceUsed[msg.sender][_spender] = false;
267         Approval(msg.sender, _spender, _value);
268 
269         return true;
270     }
271 
272     /**
273     *  Allow another contract to spend some tokens on your behalf
274     *
275     * @param _spender - address to allocate tokens for
276     * @param _currentValue - current number of tokens approved for allocation
277     * @param _value - number of tokens to allocate
278     * @return True in case of success, otherwise false
279     */
280     function approve(address _spender, uint256 _currentValue, uint256 _value) public onlyPayloadSize(3*32) returns (bool success) {
281         require(allowed[msg.sender][_spender] == _currentValue);
282         allowed[msg.sender][_spender] = _value;
283         Approval(msg.sender, _spender, _value);
284         return true;
285     }
286 
287     /**
288     *  A contract attempts to get the coins. Tokens should be previously allocated
289     *
290     * @param _to - address to transfer tokens to
291     * @param _from - address to transfer tokens from
292     * @param _value - number of tokens to transfer
293     * @return True in case of success, otherwise false
294     */
295     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed onlyPayloadSize(3*32) returns (bool success) {
296         updateVesting(_from);
297 
298         // Check if the sender has enough
299         require(vestedBalanceOf(_from) >= _value);
300 
301         // Check allowed
302         require(_value <= allowed[_from][msg.sender]);
303 
304         // Subtract from the sender
305         // _value is never greater than balance because of input validation above
306         balances[_from] -= _value;
307         // Add the same to the recipient
308         // Overflow is not possible because of input validation above
309         balances[_to] += _value;
310 
311         // Deduct allocation
312         // _value is never greater than allowed amount because of input validation above
313         allowed[_from][msg.sender] -= _value;
314 
315         // If tokens issued from this address need to vest (i.e. this address is a pool), freeze them here
316         if (vestingTimesForPools[_from] > 0) {
317             addToVesting(_from, _to, vestingTimesForPools[_from], _value);
318         }
319 
320         Transfer(msg.sender, _from, _to, _value);
321         allowanceUsed[_from][msg.sender] = true;
322 
323         return true;
324     }
325 
326     /**
327     *  Default method
328     *
329     *  This unnamed function is called whenever someone tries to send ether to
330     *  it. Just revert transaction because there is nothing that Token can do
331     *  with incoming ether.
332     *
333     *  Missing payable modifier prevents accidental sending of ether
334     */
335     function() public {
336     }
337 
338     /**
339     *  Enable or disable transfers
340     *
341     * @param _enable - True = enable, False = disable
342     */
343     function toggleTransfers(bool _enable) external onlyOwner {
344         transfersEnabled = _enable;
345     }
346 
347     /**
348     *  Destroy unsold preICO tokens
349     *
350     */
351     function closePresale() external onlyOwner {
352         // Destroyed amount is never greater than total supply,
353         // so no underflow possible here
354         uint destroyedAmount = balances[presaleWallet.addr];
355         totalSupply -= destroyedAmount;
356         balances[presaleWallet.addr] = 0;
357         Destruction(destroyedAmount);
358         Transfer(presaleWallet.addr, 0x0, destroyedAmount);
359     }
360 
361     /**
362     *  Destroy unsold general sale tokens
363     *
364     */
365     function closeGeneralSale() external onlyOwner {
366         // Destroyed amount is never greater than total supply,
367         // so no underflow possible here
368         uint destroyedAmount = balances[generalSaleWallet.addr];
369         totalSupply -= destroyedAmount;
370         balances[generalSaleWallet.addr] = 0;
371         Destruction(destroyedAmount);
372         Transfer(generalSaleWallet.addr, 0x0, destroyedAmount);
373     }
374 
375     function addToVesting(address _from, address _target, uint256 _vestingTime, uint256 _amount) internal {
376         if (CrowdsaleParameters.vestingTime90Days == _vestingTime) {
377             balances90dayFreeze[_target] += _amount;
378             VestingTransfer(_from, _target, _amount, _vestingTime);
379         } else if (CrowdsaleParameters.vestingTime180Days == _vestingTime) {
380             balances180dayFreeze[_target] += _amount;
381             VestingTransfer(_from, _target, _amount, _vestingTime);
382         }
383     }
384 
385     function updateVesting(address sender) internal {
386         if (CrowdsaleParameters.vestingTime90Days < now) {
387             balances90dayFreeze[sender] = 0;
388         }
389         if (CrowdsaleParameters.vestingTime180Days < now) {
390             balances180dayFreeze[sender] = 0;
391         }
392     }
393 }