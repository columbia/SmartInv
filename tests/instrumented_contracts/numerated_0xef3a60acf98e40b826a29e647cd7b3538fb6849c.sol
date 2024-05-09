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
79     string public standard = 'Token 0.1';
80     string public name = 'Taklimakan';
81     string public symbol = 'TKLN';
82     uint8 public decimals = 18;
83     uint256 public totalSupply = 0;
84     bool public transfersEnabled = true;
85 
86     function approveCrowdsale(address _crowdsaleAddress) external;
87     function approvePresale(address _presaleAddress) external;
88     function balanceOf(address _address) public constant returns (uint256 balance);
89     function vestedBalanceOf(address _address) public constant returns (uint256 balance);
90     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
91     function transfer(address _to, uint256 _value) public returns (bool success);
92     function approve(address _spender, uint256 _value) public returns (bool success);
93     function approve(address _spender, uint256 _currentValue, uint256 _value) public returns (bool success);
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
95     function toggleTransfers(bool _enable) external;
96     function closePresale() external;
97     function closeGeneralSale() external;
98 }
99 
100 contract TaklimakanCrowdsale is Owned, CrowdsaleParameters {
101     /* ICO and Pre-ICO Parameters */
102     address internal saleWalletAddress;
103     uint private tokenMultiplier = 10;
104     uint public saleStartTimestamp;
105     uint public saleStopTimestamp;
106     uint public saleGoal;
107     uint8 public stageBonus;
108     bool public goalReached = false;
109 
110     /* Token and records */
111     TKLNToken private token;
112     uint public totalCollected = 0;
113     mapping (address => uint256) private investmentRecords;
114 
115     /* Events */
116     event TokenSale(address indexed tokenReceiver, uint indexed etherAmount, uint indexed tokenAmount, uint tokensPerEther);
117     event FundTransfer(address indexed from, address indexed to, uint indexed amount);
118     event Refund(address indexed backer, uint amount);
119 
120     /**
121     * Constructor
122     *
123     * @param _tokenAddress - address of token (deployed before this contract)
124     */
125     function TaklimakanCrowdsale(address _tokenAddress) public {
126         token = TKLNToken(_tokenAddress);
127         tokenMultiplier = tokenMultiplier ** token.decimals();
128         saleWalletAddress = CrowdsaleParameters.generalSaleWallet.addr;
129 
130         saleStartTimestamp = CrowdsaleParameters.generalSaleStartDate;
131         saleStopTimestamp = CrowdsaleParameters.generalSaleEndDate;
132 
133         // Initialize sale goal
134         saleGoal = CrowdsaleParameters.generalSaleWallet.amount;
135         stageBonus = 1;
136     }
137 
138     /**
139     * Is sale active
140     *
141     * @return active - True, if sale is active
142     */
143     function isICOActive() public constant returns (bool active) {
144         active = ((saleStartTimestamp <= now) && (now < saleStopTimestamp) && (!goalReached));
145         return active;
146     }
147 
148     /**
149     *  Process received payment
150     *
151     *  Determine the integer number of tokens that was purchased considering current
152     *  stage, tier bonus, and remaining amount of tokens in the sale wallet.
153     *  Transfer purchased tokens to bakerAddress and return unused portion of
154     *  ether (change)
155     *
156     * @param bakerAddress - address that ether was sent from
157     * @param amount - amount of Wei received
158     */
159     function processPayment(address bakerAddress, uint amount) internal {
160         require(isICOActive());
161 
162         // Before Metropolis update require will not refund gas, but
163         // for some reason require statement around msg.value always throws
164         assert(msg.value > 0 finney);
165 
166         // Tell everyone about the transfer
167         FundTransfer(bakerAddress, address(this), amount);
168 
169         // Calculate tokens per ETH for this tier
170         uint tokensPerEth = 16500;
171 
172         if (amount < 3 ether)
173             tokensPerEth = 15000;
174         else if (amount < 7 ether)
175             tokensPerEth = 15150;
176         else if (amount < 15 ether)
177             tokensPerEth = 15300;
178         else if (amount < 30 ether)
179             tokensPerEth = 15450;
180         else if (amount < 75 ether)
181             tokensPerEth = 15600;
182         else if (amount < 150 ether)
183             tokensPerEth = 15750;
184         else if (amount < 250 ether)
185             tokensPerEth = 15900;
186         else if (amount < 500 ether)
187             tokensPerEth = 16050;
188         else if (amount < 750 ether)
189             tokensPerEth = 16200;
190         else if (amount < 1000 ether)
191             tokensPerEth = 16350;
192 
193         tokensPerEth = tokensPerEth * stageBonus;
194 
195         // Calculate token amount that is purchased,
196         // truncate to integer
197         uint tokenAmount = amount * tokensPerEth / 1e18;
198 
199         // Check that stage wallet has enough tokens. If not, sell the rest and
200         // return change.
201         uint remainingTokenBalance = token.balanceOf(saleWalletAddress) / tokenMultiplier;
202         if (remainingTokenBalance < tokenAmount) {
203             tokenAmount = remainingTokenBalance;
204             goalReached = true;
205         }
206 
207         // Calculate Wei amount that was received in this transaction
208         // adjusted to rounding and remaining token amount
209         uint acceptedAmount = tokenAmount * 1e18 / tokensPerEth;
210 
211         // Transfer tokens to baker and return ETH change
212         token.transferFrom(saleWalletAddress, bakerAddress, tokenAmount * tokenMultiplier);
213         TokenSale(bakerAddress, amount, tokenAmount, tokensPerEth);
214 
215         // Return change
216         uint change = amount - acceptedAmount;
217         if (change > 0) {
218             if (bakerAddress.send(change)) {
219                 FundTransfer(address(this), bakerAddress, change);
220             }
221             else revert();
222         }
223 
224         // Update crowdsale performance
225         investmentRecords[bakerAddress] += acceptedAmount;
226         totalCollected += acceptedAmount;
227     }
228 
229     /**
230     *  Transfer ETH amount from contract to owner's address.
231     *  Can only be used if ICO is closed
232     *
233     * @param amount - ETH amount to transfer in Wei
234     */
235     function safeWithdrawal(uint amount) external onlyOwner {
236         require(this.balance >= amount);
237         require(!isICOActive());
238 
239         if (owner.send(amount)) {
240             FundTransfer(address(this), msg.sender, amount);
241         }
242     }
243 
244     /**
245     *  Default method
246     *
247     *  Processes all ETH that it receives and credits TKLN tokens to sender
248     *  according to current stage bonus
249     */
250     function () external payable {
251         processPayment(msg.sender, msg.value);
252     }
253 
254     /**
255     *  Kill method
256     *
257     *  Destructs this contract
258     */
259     function kill() external onlyOwner {
260         require(!isICOActive());
261         selfdestruct(owner);
262     }
263 
264     /**
265     *  Refund
266     *
267     *  Sends a refund to the sender who calls this method.
268     */
269     function refund() external {
270         require((now > saleStopTimestamp) && (totalCollected < CrowdsaleParameters.minimumICOCap * 1e18));
271         require(investmentRecords[msg.sender] > 0);
272 
273         var amountToReturn = investmentRecords[msg.sender];
274 
275         require(this.balance >= amountToReturn);
276 
277         investmentRecords[msg.sender] = 0;
278         msg.sender.transfer(amountToReturn);
279         Refund(msg.sender, amountToReturn);
280     }
281 }
282 
283 contract TaklimakanPreICO is TaklimakanCrowdsale {
284     /**
285     * Constructor
286     *
287     * @param _tokenAddress - address of token (deployed before this contract)
288     */
289     function TaklimakanPreICO(address _tokenAddress) TaklimakanCrowdsale(_tokenAddress) public {
290         saleWalletAddress = CrowdsaleParameters.presaleWallet.addr;
291 
292         saleStartTimestamp = CrowdsaleParameters.presaleStartDate;
293         saleStopTimestamp = CrowdsaleParameters.presaleEndDate;
294 
295         // Initialize sale goal
296         saleGoal = CrowdsaleParameters.presaleWallet.amount;
297         stageBonus = 2;
298     }
299 
300     /**
301     *  Allow anytime withdrawals
302     *
303     * @param amount - ETH amount to transfer in Wei
304     */
305     function safeWithdrawal(uint amount) external onlyOwner {
306         require(this.balance >= amount);
307 
308         if (owner.send(amount)) {
309             FundTransfer(address(this), msg.sender, amount);
310         }
311     }
312 
313     /**
314     *  Refund
315     *
316     *  Pre ICO refunds are not provided
317     */
318     function refund() external {
319         revert();
320     }
321 }