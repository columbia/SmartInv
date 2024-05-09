1 pragma solidity ^0.4.11;
2 
3 contract boleno {
4     string public constant name = "Boleno";                 // Token name
5     string public constant symbol = "BLN";                  // Boleno token symbol
6     uint8 public constant decimals = 18;                    // Number of decimals
7     uint256 public totalSupply = 10**25;                    // The initial supply (10 million) in base unit
8     address public supplier;                                // Boleno supplier address
9     uint public blnpereth = 50;                             // Price of 1 Ether in Bolenos by the supplier
10     uint public bounty = 15;                                // Percentage of bounty program. Initiates with 15%
11     bool public sale = false;                               // Is there an ongoing sale?
12     bool public referral = false;                           // Is the referral program enabled?
13 
14     // Events
15     event Transfer(address indexed _from, address indexed _to, uint _value);
16     event Approval(address indexed _owner, address indexed _spender, uint _value);
17 
18     mapping (address => uint256) public balances;           // Balances
19     mapping(address => mapping (address => uint256)) allowed;// Record of allowances
20 
21     // Initialization
22     function boleno() {
23       supplier = msg.sender;                                // Supplier is contract creator
24       balances[supplier] = totalSupply;                     // The initial supply goes to supplier
25     }
26 
27     // For functions that require only supplier usage
28     modifier onlySupplier {
29       if (msg.sender != supplier) throw;
30       _;
31     }
32 
33     // Token transfer
34     function transfer(address _to, uint256 _value) returns (bool success) {
35       if (now < 1502755200 && msg.sender != supplier) throw;// Cannot trade until Tuesday, August 15, 2017 12:00:00 AM (End of ICO)
36       if (balances[msg.sender] < _value) throw;            // Does the spender have enough Bolenos to send?
37       if (balances[_to] + _value < balances[_to]) throw;   // Overflow?
38       balances[msg.sender] -= _value;                      // Subtract the Bolenos from the sender's balance
39       balances[_to] += _value;                             // Add the Bolenos to the recipient's balance
40       Transfer(msg.sender, _to, _value);                   // Send Bolenos transfer event
41       return true;                                         // Return true to client
42     }
43 
44     // Token transfer on your behalf (i.e. by contracts)
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
46       if (now < 1502755200 && _from != supplier) throw;     // Cannot trade until Tuesday, August 15, 2017 12:00:00 AM (End of ICO)
47       if (balances[_from] < _value) throw;                  // Does the spender have enough Bolenos to send?
48       if(allowed[_from][msg.sender] < _value) throw;        // Is the sender allowed to spend as much money on behalf of the spender?
49       if (balances[_to] + _value < balances[_to]) throw;    // Overflow?
50       balances[_from] -= _value;                            // Subtract the Bolenos from the sender's balance
51       allowed[_from][msg.sender] -= _value;                 // Update allowances record
52       balances[_to] += _value;                              // Add the Bolenos to the recipient's balance
53       Transfer(_from, _to, _value);                         // Send Bolenos transfer event
54       return true;                                          // Return true to client
55      }
56 
57      // Allows someone (i.e a contract) to spend on your behalf multiple times up to a certain value.
58      // If this function is called again, it overwrites the current allowance with _value.
59      // Approve 0 to cancel previous approval
60      function approve(address _spender, uint256 _value) returns (bool success) {
61        allowed[msg.sender][_spender] = _value;             // Update allowances record
62        Approval(msg.sender, _spender, _value);             // Send approval event
63        return true;                                        // Return true to client
64      }
65 
66      // Check how much someone approved you to spend on their behalf
67      function allowance(address _owner, address _spender) returns (uint256 bolenos) {
68        return allowed[_owner][_spender];                   // Check the allowances record
69      }
70 
71     // What is the Boleno balance of a particular person?
72     function balanceOf(address _owner) returns (uint256 bolenos){
73       return balances[_owner];
74     }
75 
76     /*
77      Crowdsale related functions
78     */
79 
80     // Referral bounty system
81     function referral(address referrer) payable {
82       if(sale != true) throw;                               // Is there an ongoing sale?
83       if(referral != true) throw;                           // Is referral bounty allowed by supplier?
84       if(balances[referrer] < 100**18) throw;               // Make sure referrer already has at least 100 Bolenos
85       uint256 bolenos = msg.value * blnpereth;              // Determine amount of equivalent Bolenos to the Ethers received
86       /*
87         First give Bolenos to the purchaser
88       */
89       uint256 purchaserBounty = (bolenos / 100) * (100 + bounty);// Add bounty to the purchased amount
90       if(balances[supplier] < purchaserBounty) throw;       // Does the supplier have enough BLN tokens to sell?
91       if (balances[msg.sender] + purchaserBounty < balances[msg.sender]) throw; // Overflow?
92       balances[supplier] -= purchaserBounty;                // Subtract the Bolenos from the supplier's balance
93       balances[msg.sender] += purchaserBounty;              // Add the Bolenos to the buyer's balance
94       Transfer(supplier, msg.sender, purchaserBounty);      // Send Bolenos transfer event
95       /*
96         Then give Bolenos to the referrer
97       */
98       uint256 referrerBounty = (bolenos / 100) * bounty;    // Only the bounty percentage is added to the referrer
99       if(balances[supplier] < referrerBounty) throw;        // Does the supplier have enough BLN tokens to sell?
100       if (balances[referrer] + referrerBounty < balances[referrer]) throw; // Overflow?
101       balances[supplier] -= referrerBounty;                 // Subtract the Bolenos from the supplier's balance
102       balances[referrer] += referrerBounty;                 // Add the Bolenos to the buyer's balance
103       Transfer(supplier, referrer, referrerBounty);         // Send Bolenos transfer event
104     }
105 
106     // Set the number of BLNs sold per ETH (only by the supplier).
107     function setbounty(uint256 newBounty) onlySupplier {
108       bounty = newBounty;
109     }
110 
111     // Set the number of BLNs sold per ETH (only by the supplier).
112     function setblnpereth(uint256 newRate) onlySupplier {
113       blnpereth = newRate;
114     }
115 
116     // Trigger Sale (only by the supplier)
117     function triggerSale(bool newSale) onlySupplier {
118       sale = newSale;
119     }
120 
121     // Transfer both supplier status and all held Boleno tokens supply to a different address (only supplier)
122     function transferSupply(address newSupplier) onlySupplier {
123       if (balances[newSupplier] + balances[supplier] < balances[newSupplier]) throw;// Overflow?
124       uint256 supplyValue = balances[supplier];             // Determine current value of the supply
125       balances[newSupplier] += supplyValue;                 // Add supply to new supplier
126       balances[supplier] -= supplyValue;                    // Substract supply from old supplier
127       Transfer(supplier, newSupplier, supplyValue);         // Send Bolenos transfer event
128       supplier = newSupplier;                               // Transfer supplier status
129     }
130 
131     // Claim sale Ethers. Can be executed by anyone.
132     function claimSale(){
133       address dao = 0x400Be625f1308a56C19C38b1A21A50FCE8c62617;// Hardcoded address of the Bolenum private DAO
134       dao.transfer(this.balance);                           // Send all collected Ethers to the address
135     }
136 
137     // Fallback function. Used for buying Bolenos from supplier by simply sending Ethers to contract
138     function () payable {
139       if(sale != true) throw;                               // Is there an ongoing sale?
140       uint256 bolenos = msg.value * blnpereth;              // Determine amount of equivalent Bolenos to the Ethers received
141       if(balances[supplier] < bolenos) throw;               // Does the supplier have enough BLN tokens to sell?
142       if (balances[msg.sender] + bolenos < balances[msg.sender]) throw; // Overflow?
143       balances[supplier] -= bolenos;                        // Subtract the Bolenos the supplier's balance
144       balances[msg.sender] += bolenos;                      // Add the Bolenos to the buyer's balance
145       Transfer(supplier, msg.sender, bolenos);              // Send Bolenos transfer event
146     }
147 }