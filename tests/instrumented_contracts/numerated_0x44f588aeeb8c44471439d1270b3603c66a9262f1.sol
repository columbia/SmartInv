1 pragma solidity ^0.4.15;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     // function totalSupply() public constant returns (uint supply);
7     // `totalSupply` is defined below because the automatically generated
8     // getter function does not match the abstract function above
9     uint public totalSupply;
10 
11     /// @param _owner The address from which the balance will be retrieved
12     /// @return The balance
13     function balanceOf(address _owner) public constant returns (uint);
14 
15     /// @notice send `_value` token to `_to` from `msg.sender`
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transfer(address _to, uint _value) public returns (bool success);
20 
21     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
22     /// @param _from The address of the sender
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
27 
28     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @param _value The amount of wei to be approved for transfer
31     /// @return Whether the approval was successful or not
32     function approve(address _spender, uint _value) public returns (bool success);
33 
34     /// @param _owner The address of the account owning tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @return Amount of remaining tokens allowed to spent
37     function allowance(address _owner, address _spender) public constant returns (uint remaining);
38 
39     event Transfer(address indexed _from, address indexed _to, uint _value);
40     event Approval(address indexed _owner, address indexed _spender, uint _value);
41 
42 }
43 
44 contract StandardToken is Token {
45 
46     function transfer(address _to, uint _value) public returns (bool success) {
47         if (balances[msg.sender] >= _value &&          // Account has sufficient balance
48             balances[_to] + _value >= balances[_to]) { // Overflow check
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { throw; }
54     }
55 
56     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
57         if (balances[_from] >= _value &&                // Account has sufficient balance
58             allowed[_from][msg.sender] >= _value &&     // Amount has been approved
59             balances[_to] + _value >= balances[_to]) {  // Overflow check
60             balances[_from] -= _value;
61             allowed[_from][msg.sender] -= _value;
62             balances[_to] += _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { throw; }
66     }
67 
68     function balanceOf(address _owner) public constant returns (uint balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint _value) public returns (bool success) {
73         // To change the approve amount you first have to reduce the addresses`
74         //  allowance to zero by calling `approve(_spender, 0)` if it is not
75         //  already 0 to mitigate the race condition described here:
76         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
78 
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
85       return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint) balances;
89     mapping (address => mapping (address => uint)) allowed;
90 }
91 
92 // Based on TokenFactory(https://github.com/ConsenSys/Token-Factory)
93 
94 contract SnipCoin is StandardToken {
95 
96     string public constant name = "SnipCoin";         // Token name
97     string public symbol = "SNIP";                    // Token identifier
98     uint8 public constant decimals = 18;              // Decimal points for token
99     uint public totalEthReceivedInWei;                // The total amount of Ether received during the sale in WEI
100     uint public totalUsdReceived;                     // The total amount of Ether received during the sale in USD terms
101     uint public totalUsdValueOfAllTokens;             // The total USD value of 100% of tokens
102     string public version = "1.0";                    // Code version
103     address public saleWalletAddress;                 // The wallet address where the Ether from the sale will be stored
104 
105     mapping (address => bool) public uncappedBuyerList;      // The list of buyers allowed to participate in the sale without a cap
106     mapping (address => uint) public cappedBuyerList;        // The list of buyers allowed to participate in the sale, with their updated payment sum
107 
108     uint public snipCoinToEtherExchangeRate = 76250; // This is the ratio of SnipCoin to Ether, could be updated by the owner, change before the sale
109     bool public isSaleOpen = false;                   // This opens and closes upon external command
110     bool public transferable = false;                 // Tokens are transferable
111 
112     uint public ethToUsdExchangeRate = 282;           // Number of USD in one Eth
113 
114     address public contractOwner;                     // Address of the contract owner
115     // Address of an additional account to manage the sale without risk to the tokens or eth. Change before the sale
116     address public accountWithUpdatePermissions = 0x6933784a82F5daDEbB600Bed8670667837aD196f;
117 
118     uint public constant PERCENTAGE_OF_TOKENS_SOLD_IN_SALE = 28;     // Percentage of all the tokens being sold in the current sale
119     uint public constant DECIMALS_MULTIPLIER = 10**uint(decimals);   // Multiplier for the decimals
120     uint public constant SALE_CAP_IN_USD = 8000000;                  // The total sale cap in USD
121     uint public constant MINIMUM_PURCHASE_IN_USD = 50;               // It is impossible to purchase tokens for more than $50 in the sale.
122     uint public constant USD_PURCHASE_AMOUNT_REQUIRING_ID = 4500;    // Above this purchase amount an ID is required.
123 
124     modifier onlyPermissioned() {
125         require((msg.sender == contractOwner) || (msg.sender == accountWithUpdatePermissions));
126         _;
127     }
128 
129     modifier verifySaleNotOver() {
130         require(isSaleOpen);
131         require(totalUsdReceived < SALE_CAP_IN_USD); // Make sure that sale isn't over
132         _;
133     }
134 
135     modifier verifyBuyerCanMakePurchase() {
136         uint currentPurchaseValueInUSD = uint(msg.value / getWeiToUsdExchangeRate()); // The USD worth of tokens sold
137         uint totalPurchaseIncludingCurrentPayment = currentPurchaseValueInUSD +  cappedBuyerList[msg.sender]; // The USD worth of all tokens this buyer bought
138 
139         require(currentPurchaseValueInUSD > MINIMUM_PURCHASE_IN_USD); // Minimum transfer is of $50
140 
141         uint EFFECTIVE_MAX_CAP = SALE_CAP_IN_USD + 1000;  // This allows for the end of the sale by passing $8M and reaching the cap
142         require(EFFECTIVE_MAX_CAP - totalUsdReceived > currentPurchaseValueInUSD); // Make sure that there is enough usd left to buy.
143 
144         if (!uncappedBuyerList[msg.sender]) // If buyer is on uncapped white list then no worries, else need to make sure that they're okay
145         {
146             require(cappedBuyerList[msg.sender] > 0); // Check that the sender has been initialized.
147             require(totalPurchaseIncludingCurrentPayment < USD_PURCHASE_AMOUNT_REQUIRING_ID); // Check that they're not buying too much
148         }
149         _;
150     }
151 
152     function SnipCoin() public {
153         initializeSaleWalletAddress();
154         initializeEthReceived();
155         initializeUsdReceived();
156 
157         contractOwner = msg.sender;                      // The creator of the contract is its owner
158         totalSupply = 10000000000 * DECIMALS_MULTIPLIER; // In total, 10 billion tokens
159         balances[contractOwner] = totalSupply;           // Initially give owner all of the tokens 
160         Transfer(0x0, contractOwner, totalSupply);
161     }
162 
163     function initializeSaleWalletAddress() internal {
164         saleWalletAddress = 0xb4Ad56E564aAb5409fe8e34637c33A6d3F2a0038; // Change before the sale
165     }
166 
167     function initializeEthReceived() internal {
168         totalEthReceivedInWei = 14018 * 1 ether; // Ether received before public sale. Verify this figure before the sale starts.
169     }
170 
171     function initializeUsdReceived() internal {
172         totalUsdReceived = 3953076; // USD received before public sale. Verify this figure before the sale starts.
173         totalUsdValueOfAllTokens = totalUsdReceived * 100 / PERCENTAGE_OF_TOKENS_SOLD_IN_SALE; // sold tokens are 28% of all tokens
174     }
175 
176     function getWeiToUsdExchangeRate() public constant returns(uint) {
177         return 1 ether / ethToUsdExchangeRate; // Returns how much Wei one USD is worth
178     }
179 
180     function updateEthToUsdExchangeRate(uint newEthToUsdExchangeRate) public onlyPermissioned {
181         ethToUsdExchangeRate = newEthToUsdExchangeRate; // Change exchange rate to new value, influences the counter of when the sale is over.
182     }
183 
184     function updateSnipCoinToEtherExchangeRate(uint newSnipCoinToEtherExchangeRate) public onlyPermissioned {
185         snipCoinToEtherExchangeRate = newSnipCoinToEtherExchangeRate; // Change the exchange rate to new value, influences tokens received per purchase
186     }
187 
188     function openOrCloseSale(bool saleCondition) public onlyPermissioned {
189         require(!transferable);
190         isSaleOpen = saleCondition; // Decide if the sale should be open or closed (default: closed)
191     }
192 
193     function allowTransfers() public onlyPermissioned {
194         require(!isSaleOpen);
195         transferable = true;
196     }
197 
198     function addAddressToCappedAddresses(address addr) public onlyPermissioned {
199         cappedBuyerList[addr] = 1; // Allow a certain address to purchase SnipCoin up to the cap (<4500)
200     }
201 
202     function addMultipleAddressesToCappedAddresses(address[] addrList) public onlyPermissioned {
203         for (uint i = 0; i < addrList.length; i++) {
204             addAddressToCappedAddresses(addrList[i]); // Allow a certain address to purchase SnipCoin up to the cap (<4500)
205         }
206     }
207 
208     function addAddressToUncappedAddresses(address addr) public onlyPermissioned {
209         uncappedBuyerList[addr] = true; // Allow a certain address to purchase SnipCoin above the cap (>=$4500)
210     }
211 
212     function addMultipleAddressesToUncappedAddresses(address[] addrList) public onlyPermissioned {
213         for (uint i = 0; i < addrList.length; i++) {
214             addAddressToUncappedAddresses(addrList[i]); // Allow a certain address to purchase SnipCoin up to the cap (<4500)
215         }
216     }
217 
218     function transfer(address _to, uint _value) public returns (bool success) {
219         require(transferable);
220         return super.transfer(_to, _value);
221     }
222 
223     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
224         require(transferable);
225         return super.transferFrom(_from, _to, _value);
226     }
227 
228     function () public payable verifySaleNotOver verifyBuyerCanMakePurchase {
229         uint tokens = snipCoinToEtherExchangeRate * msg.value;
230         balances[contractOwner] -= tokens;
231         balances[msg.sender] += tokens;
232         Transfer(contractOwner, msg.sender, tokens);
233 
234         totalEthReceivedInWei = totalEthReceivedInWei + msg.value; // total eth received counter
235         uint usdReceivedInCurrentTransaction = uint(msg.value / getWeiToUsdExchangeRate());
236         totalUsdReceived = totalUsdReceived + usdReceivedInCurrentTransaction; // total usd received counter
237         totalUsdValueOfAllTokens = totalUsdReceived * 100 / PERCENTAGE_OF_TOKENS_SOLD_IN_SALE; // sold tokens are 28% of all tokens
238 
239         if (cappedBuyerList[msg.sender] > 0)
240         {
241             cappedBuyerList[msg.sender] = cappedBuyerList[msg.sender] + usdReceivedInCurrentTransaction;
242         }
243 
244         saleWalletAddress.transfer(msg.value); // Transfer ether to safe sale address
245     }
246 }