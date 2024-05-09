1 pragma solidity 0.4.18;
2 
3 contract FHFTokenInterface {
4     /* Public parameters of the token */
5     string public standard = 'Token 0.1';
6     string public name = 'Forever Has Fallen';
7     string public symbol = 'FC';
8     uint8 public decimals = 18;
9 
10     function approveCrowdsale(address _crowdsaleAddress) external;
11     function balanceOf(address _address) public constant returns (uint256 balance);
12     function vestedBalanceOf(address _address) public constant returns (uint256 balance);
13     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14     function transfer(address _to, uint256 _value) public returns (bool success);
15     function approve(address _spender, uint256 _value) public returns (bool success);
16     function approve(address _spender, uint256 _currentValue, uint256 _value) public returns (bool success);
17     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
18 }
19 
20 contract CrowdsaleParameters {
21     ///////////////////////////////////////////////////////////////////////////
22     // Configuration Independent Parameters
23     ///////////////////////////////////////////////////////////////////////////
24 
25     struct AddressTokenAllocation {
26         address addr;
27         uint256 amount;
28     }
29 
30     uint256 public maximumICOCap = 350e6;
31 
32     // ICO period timestamps:
33     // 1525777200 = May 8, 2018. 11am GMT
34     // 1529406000 = June 19, 2018. 11am GMT
35     uint256 public generalSaleStartDate = 1525777200;
36     uint256 public generalSaleEndDate = 1529406000;
37 
38     // Vesting
39     // 1592564400 = June 19, 2020. 11am GMT
40     uint32 internal vestingTeam = 1592564400;
41     // 1529406000 = Bounty to ico end date - June 19, 2018. 11am GMT
42     uint32 internal vestingBounty = 1529406000;
43 
44     ///////////////////////////////////////////////////////////////////////////
45     // Production Config
46     ///////////////////////////////////////////////////////////////////////////
47 
48 
49     ///////////////////////////////////////////////////////////////////////////
50     // QA Config
51     ///////////////////////////////////////////////////////////////////////////
52 
53     AddressTokenAllocation internal generalSaleWallet = AddressTokenAllocation(0x265Fb686cdd2f9a853c519592078cC4d1718C15a, 350e6);
54     AddressTokenAllocation internal communityReserve =  AddressTokenAllocation(0x76d472C73681E3DF8a7fB3ca79E5f8915f9C5bA5, 450e6);
55     AddressTokenAllocation internal team =              AddressTokenAllocation(0x05d46150ceDF59ED60a86d5623baf522E0EB46a2, 170e6);
56     AddressTokenAllocation internal advisors =          AddressTokenAllocation(0x3d5fa25a3C0EB68690075eD810A10170e441413e, 48e5);
57     AddressTokenAllocation internal bounty =            AddressTokenAllocation(0xAc2099D2705434f75adA370420A8Dd397Bf7CCA1, 176e5);
58     AddressTokenAllocation internal administrative =    AddressTokenAllocation(0x438aB07D5EC30Dd9B0F370e0FE0455F93C95002e, 76e5);
59 
60     address internal playersReserve = 0x8A40B0Cf87DaF12C689ADB5C74a1B2f23B3a33e1;
61 }
62 
63 
64 contract Owned {
65     address public owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70     *  Constructor
71     *
72     *  Sets contract owner to address of constructor caller
73     */
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner() {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     /**
84     *  Change Owner
85     *
86     *  Changes ownership of this contract. Only owner can call this method.
87     *
88     * @param newOwner - new owner's address
89     */
90     function changeOwner(address newOwner) onlyOwner public {
91         require(newOwner != address(0));
92         require(newOwner != owner);
93         OwnershipTransferred(owner, newOwner);
94         owner = newOwner;
95     }
96 }
97 
98 contract FHFTokenCrowdsale is Owned, CrowdsaleParameters {
99     /* Token and records */
100     FHFTokenInterface private token;
101     address private saleWalletAddress;
102     uint private tokenMultiplier = 10;
103     uint public totalCollected = 0;
104     uint public saleGoal;
105     bool public goalReached = false;
106 
107     /* Events */
108     event TokenSale(address indexed tokenReceiver, uint indexed etherAmount, uint indexed tokenAmount, uint tokensPerEther);
109     event FundTransfer(address indexed from, address indexed to, uint indexed amount);
110 
111     /**
112     * Constructor
113     *
114     * @param _tokenAddress - address of token (deployed before this contract)
115     */
116     function FHFTokenCrowdsale(address _tokenAddress) public {
117         token = FHFTokenInterface(_tokenAddress);
118         tokenMultiplier = tokenMultiplier ** token.decimals();
119         saleWalletAddress = CrowdsaleParameters.generalSaleWallet.addr;
120 
121         // Initialize sale goal
122         saleGoal = CrowdsaleParameters.generalSaleWallet.amount;
123     }
124 
125     /**
126     * Is sale active
127     *
128     * @return active - True, if sale is active
129     */
130     function isICOActive() public constant returns (bool active) {
131         active = ((generalSaleStartDate <= now) && (now < generalSaleEndDate) && (!goalReached));
132         return active;
133     }
134 
135     /**
136     *  Process received payment
137     *
138     *  Determine the integer number of tokens that was purchased considering current
139     *  stage, tier bonus, and remaining amount of tokens in the sale wallet.
140     *  Transfer purchased tokens to backerAddress and return unused portion of
141     *  ether (change)
142     *
143     * @param backerAddress - address that ether was sent from
144     * @param amount - amount of Wei received
145     */
146     function processPayment(address backerAddress, uint amount) internal {
147         require(isICOActive());
148 
149         // Before Metropolis update require will not refund gas, but
150         // for some reason require statement around msg.value always throws
151         assert(msg.value > 0 finney);
152 
153         // Tell everyone about the transfer
154         FundTransfer(backerAddress, address(this), amount);
155 
156         // Calculate tokens per ETH for this tier
157         uint tokensPerEth = 10000;
158 
159         // Calculate token amount that is purchased,
160         uint tokenAmount = amount * tokensPerEth;
161 
162         // Check that stage wallet has enough tokens. If not, sell the rest and
163         // return change.
164         uint remainingTokenBalance = token.balanceOf(saleWalletAddress);
165         if (remainingTokenBalance <= tokenAmount) {
166             tokenAmount = remainingTokenBalance;
167             goalReached = true;
168         }
169 
170         // Calculate Wei amount that was received in this transaction
171         // adjusted to rounding and remaining token amount
172         uint acceptedAmount = tokenAmount / tokensPerEth;
173 
174         // Update crowdsale performance
175         totalCollected += acceptedAmount;
176 
177         // Transfer tokens to baker and return ETH change
178         token.transferFrom(saleWalletAddress, backerAddress, tokenAmount);
179 
180         TokenSale(backerAddress, amount, tokenAmount, tokensPerEth);
181 
182         // Return change (in Wei)
183         uint change = amount - acceptedAmount;
184         if (change > 0) {
185             if (backerAddress.send(change)) {
186                 FundTransfer(address(this), backerAddress, change);
187             }
188             else revert();
189         }
190     }
191 
192     /**
193     *  Transfer ETH amount from contract to owner's address.
194     *  Can only be used if ICO is closed
195     *
196     * @param amount - ETH amount to transfer in Wei
197     */
198     function safeWithdrawal(uint amount) external onlyOwner {
199         require(this.balance >= amount);
200         require(!isICOActive());
201 
202         if (owner.send(amount)) {
203             FundTransfer(address(this), msg.sender, amount);
204         }
205     }
206 
207     /**
208     *  Default method
209     *
210     *  Processes all ETH that it receives and credits FHF tokens to sender
211     *  according to current stage bonus
212     */
213     function () external payable {
214         processPayment(msg.sender, msg.value);
215     }
216 
217     /**
218     * Close main sale and move unsold tokens to playersReserve wallet
219     */
220     function closeMainSaleICO() external onlyOwner {
221         require(!isICOActive());
222         require(generalSaleStartDate < now);
223 
224         var amountToMove = token.balanceOf(generalSaleWallet.addr);
225         token.transferFrom(generalSaleWallet.addr, playersReserve, amountToMove);
226         generalSaleEndDate = now;
227     }
228 
229     /**
230     *  Kill method
231     *
232     *  Double-checks that unsold general sale tokens were moved off general sale wallet and
233     *  destructs this contract
234     */
235     function kill() external onlyOwner {
236         require(!isICOActive());
237         if (now < generalSaleStartDate) {
238             selfdestruct(owner);
239         } else if (token.balanceOf(generalSaleWallet.addr) == 0) {
240             FundTransfer(address(this), msg.sender, this.balance);
241             selfdestruct(owner);
242         } else {
243             revert();
244         }
245     }
246 }