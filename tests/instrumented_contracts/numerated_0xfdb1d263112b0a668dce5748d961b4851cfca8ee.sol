1 pragma solidity 0.4.18;
2 
3 contract Owned {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9     *  Constructor
10     *
11     *  Sets contract owner to address of constructor caller
12     */
13     function Owned() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     /**
23     *  Change Owner
24     *
25     *  Changes ownership of this contract. Only owner can call this method.
26     *
27     * @param newOwner - new owner's address
28     */
29     function changeOwner(address newOwner) onlyOwner public {
30         require(newOwner != address(0));
31         require(newOwner != owner);
32         OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 }
36 
37 contract FHFTokenInterface {
38     /* Public parameters of the token */
39     string public standard = 'Token 0.1';
40     string public name = 'Forever Has Fallen';
41     string public symbol = 'FC';
42     uint8 public decimals = 18;
43 
44     function approveCrowdsale(address _crowdsaleAddress) external;
45     function balanceOf(address _address) public constant returns (uint256 balance);
46     function vestedBalanceOf(address _address) public constant returns (uint256 balance);
47     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
48     function transfer(address _to, uint256 _value) public returns (bool success);
49     function approve(address _spender, uint256 _value) public returns (bool success);
50     function approve(address _spender, uint256 _currentValue, uint256 _value) public returns (bool success);
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
52 }
53 
54 contract CrowdsaleParameters {
55     ///////////////////////////////////////////////////////////////////////////
56     // Configuration Independent Parameters
57     ///////////////////////////////////////////////////////////////////////////
58 
59     struct AddressTokenAllocation {
60         address addr;
61         uint256 amount;
62     }
63 
64     uint256 public maximumICOCap = 350e6;
65 
66     // ICO period timestamps:
67     // 1525777200 = May 8, 2018. 11am GMT
68     // 1529406000 = June 19, 2018. 11am GMT
69     uint256 public generalSaleStartDate = 1525777200;
70     uint256 public generalSaleEndDate = 1529406000;
71 
72     // Vesting
73     // 1592564400 = June 19, 2020. 11am GMT
74     uint32 internal vestingTeam = 1592564400;
75     // 1529406000 = Bounty to ico end date - June 19, 2018. 11am GMT
76     uint32 internal vestingBounty = 1529406000;
77 
78     ///////////////////////////////////////////////////////////////////////////
79     // Production Config
80     ///////////////////////////////////////////////////////////////////////////
81 
82 
83     ///////////////////////////////////////////////////////////////////////////
84     // QA Config
85     ///////////////////////////////////////////////////////////////////////////
86 
87     AddressTokenAllocation internal generalSaleWallet = AddressTokenAllocation(0x265Fb686cdd2f9a853c519592078cC4d1718C15a, 350e6);
88     AddressTokenAllocation internal communityReserve =  AddressTokenAllocation(0x76d472C73681E3DF8a7fB3ca79E5f8915f9C5bA5, 450e6);
89     AddressTokenAllocation internal team =              AddressTokenAllocation(0x05d46150ceDF59ED60a86d5623baf522E0EB46a2, 170e6);
90     AddressTokenAllocation internal advisors =          AddressTokenAllocation(0x3d5fa25a3C0EB68690075eD810A10170e441413e, 48e5);
91     AddressTokenAllocation internal bounty =            AddressTokenAllocation(0xAc2099D2705434f75adA370420A8Dd397Bf7CCA1, 176e5);
92     AddressTokenAllocation internal administrative =    AddressTokenAllocation(0x438aB07D5EC30Dd9B0F370e0FE0455F93C95002e, 76e5);
93 
94     address internal playersReserve = 0x8A40B0Cf87DaF12C689ADB5C74a1B2f23B3a33e1;
95 }
96 
97 contract FHFToken is Owned, CrowdsaleParameters, FHFTokenInterface {
98     /* Arrays of all balances, vesting, approvals, and approval uses */
99     mapping (address => uint256) private balances;              // Total token balances
100     mapping (address => uint256) private balancesEndIcoFreeze;  // Balances frozen for ICO end by address
101     mapping (address => uint256) private balances2yearFreeze;  // Balances frozen for 2 years after ICO end by address
102     mapping (address => mapping (address => uint256)) private allowed;
103     mapping (address => mapping (address => bool)) private allowanceUsed;
104 
105 
106     /* This generates a public event on the blockchain that will notify clients */
107     event Transfer(address indexed from, address indexed to, uint256 tokens);
108     event VestingTransfer(address indexed from, address indexed to, uint256 value, uint256 vestingTime);
109     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
110     event Issuance(uint256 _amount); // triggered when the total supply is increased
111     event Destruction(uint256 _amount); // triggered when the total supply is decreased
112     event NewFHFToken(address _token);
113 
114     /* Miscellaneous */
115     uint256 public totalSupply = 0; // 1 000 000 000 when minted
116 
117     /**
118     *  Constructor
119     *
120     *  Initializes contract with initial supply tokens to the creator of the contract
121     */
122     function FHFToken() public {
123         owner = msg.sender;
124 
125         mintToken(generalSaleWallet);
126         mintToken(communityReserve);
127         mintToken(team);
128         mintToken(advisors);
129         mintToken(bounty);
130         mintToken(administrative);
131 
132         NewFHFToken(address(this));
133     }
134 
135     modifier onlyPayloadSize(uint size) {
136         assert(msg.data.length >= size + 4);
137         _;
138     }
139 
140     /**
141     *  1. Associate crowdsale contract address with this Token
142     *  2. Allocate general sale amount
143     *
144     * @param _crowdsaleAddress - crowdsale contract address
145     */
146     function approveCrowdsale(address _crowdsaleAddress) external onlyOwner {
147         uint uintDecimals = decimals;
148         uint exponent = 10**uintDecimals;
149         uint amount = generalSaleWallet.amount * exponent;
150 
151         allowed[generalSaleWallet.addr][_crowdsaleAddress] = amount;
152         Approval(generalSaleWallet.addr, _crowdsaleAddress, amount);
153     }
154 
155     /**
156     *  Get token balance of an address
157     *
158     * @param _address - address to query
159     * @return Token balance of _address
160     */
161     function balanceOf(address _address) public constant returns (uint256 balance) {
162         return balances[_address];
163     }
164 
165     /**
166     *  Get vested token balance of an address
167     *
168     * @param _address - address to query
169     * @return balance that has vested
170     */
171     function vestedBalanceOf(address _address) public constant returns (uint256 balance) {
172         if (now < vestingBounty) {
173             return balances[_address] - balances2yearFreeze[_address] - balancesEndIcoFreeze[_address];
174         }
175         if (now < vestingTeam) {
176             return balances[_address] - balances2yearFreeze[_address];
177         } else {
178             return balances[_address];
179         }
180     }
181 
182     /**
183     *  Get token amount allocated for a transaction from _owner to _spender addresses
184     *
185     * @param _owner - owner address, i.e. address to transfer from
186     * @param _spender - spender address, i.e. address to transfer to
187     * @return Remaining amount allowed to be transferred
188     */
189     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
190         return allowed[_owner][_spender];
191     }
192 
193     /**
194     *  Create token and credit it to target address
195     *  Created tokens need to vest
196     *
197     */
198     function mintToken(AddressTokenAllocation tokenAllocation) internal {
199         uint uintDecimals = decimals;
200         uint exponent = 10**uintDecimals;
201         uint mintedAmount = tokenAllocation.amount * exponent;
202 
203         // Mint happens right here: Balance becomes non-zero from zero
204         balances[tokenAllocation.addr] += mintedAmount;
205         totalSupply += mintedAmount;
206 
207         // Emit Issue and Transfer events
208         Issuance(mintedAmount);
209         Transfer(address(this), tokenAllocation.addr, mintedAmount);
210     }
211 
212     /**
213     *  Allow another contract to spend some tokens on your behalf
214     *
215     * @param _spender - address to allocate tokens for
216     * @param _value - number of tokens to allocate
217     * @return True in case of success, otherwise false
218     */
219     function approve(address _spender, uint256 _value) public onlyPayloadSize(2*32) returns (bool success) {
220         require(_value == 0 || allowanceUsed[msg.sender][_spender] == false);
221 
222         allowed[msg.sender][_spender] = _value;
223         allowanceUsed[msg.sender][_spender] = false;
224         Approval(msg.sender, _spender, _value);
225 
226         return true;
227     }
228 
229     /**
230     *  Allow another contract to spend some tokens on your behalf
231     *
232     * @param _spender - address to allocate tokens for
233     * @param _currentValue - current number of tokens approved for allocation
234     * @param _value - number of tokens to allocate
235     * @return True in case of success, otherwise false
236     */
237     function approve(address _spender, uint256 _currentValue, uint256 _value) public onlyPayloadSize(3*32) returns (bool success) {
238         require(allowed[msg.sender][_spender] == _currentValue);
239         allowed[msg.sender][_spender] = _value;
240         Approval(msg.sender, _spender, _value);
241         return true;
242     }
243 
244     /**
245     *  Send coins from sender's address to address specified in parameters
246     *
247     * @param _to - address to send to
248     * @param _value - amount to send in Wei
249     */
250     function transfer(address _to, uint256 _value) public onlyPayloadSize(2*32) returns (bool success) {
251         // Check if the sender has enough
252         require(vestedBalanceOf(msg.sender) >= _value);
253 
254         // Subtract from the sender
255         // _value is never greater than balance of input validation above
256         balances[msg.sender] -= _value;
257 
258         // Overflow is never possible due to input validation above
259         balances[_to] += _value;
260 
261         // If tokens issued from this address need to vest (i.e. this address is a team pool), freeze them here
262         if ((msg.sender == bounty.addr) && (now < vestingBounty)) {
263             balancesEndIcoFreeze[_to] += _value;
264         }
265         if ((msg.sender == team.addr) && (now < vestingTeam)) {
266             balances2yearFreeze[_to] += _value;
267         }
268 
269         Transfer(msg.sender, _to, _value);
270         return true;
271     }
272 
273     /**
274     *  A contract attempts to get the coins. Tokens should be previously allocated
275     *
276     * @param _to - address to transfer tokens to
277     * @param _from - address to transfer tokens from
278     * @param _value - number of tokens to transfer
279     * @return True in case of success, otherwise false
280     */
281     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3*32) returns (bool success) {
282         // Check if the sender has enough
283         require(vestedBalanceOf(_from) >= _value);
284 
285         // Check allowed
286         require(_value <= allowed[_from][msg.sender]);
287 
288         // Subtract from the sender
289         // _value is never greater than balance because of input validation above
290         balances[_from] -= _value;
291         // Add the same to the recipient
292         // Overflow is not possible because of input validation above
293         balances[_to] += _value;
294 
295         // Deduct allocation
296         // _value is never greater than allowed amount because of input validation above
297         allowed[_from][msg.sender] -= _value;
298 
299         // If tokens issued from this address need to vest (i.e. this address is a team pool), freeze them here
300         if ((_from == bounty.addr) && (now < vestingBounty)) {
301             balancesEndIcoFreeze[_to] += _value;
302         }
303         if ((_from == team.addr) && (now < vestingTeam)) {
304             balances2yearFreeze[_to] += _value;
305         }
306 
307         Transfer(_from, _to, _value);
308         allowanceUsed[_from][msg.sender] = true;
309 
310         return true;
311     }
312 
313     /**
314     *  Default method
315     *
316     *  This unnamed function is called whenever someone tries to send ether to
317     *  it. Just revert transaction because there is nothing that Token can do
318     *  with incoming ether.
319     *
320     *  Missing payable modifier prevents accidental sending of ether
321     */
322     function() public {
323     }
324 }