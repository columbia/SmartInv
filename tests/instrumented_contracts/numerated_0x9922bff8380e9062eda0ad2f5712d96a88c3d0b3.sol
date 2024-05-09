1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4     address public owner;
5 
6     function Owned() { owner = msg.sender; }
7 
8     modifier onlyOwner() {
9         require(msg.sender == owner);
10         _;
11     }
12 }
13 
14 contract Bounty0xPresale is Owned {
15     // -------------------------------------------------------------------------------------
16     // TODO Before deployment of contract to Mainnet
17     // 1. Confirm MINIMUM_PARTICIPATION_AMOUNT and MAXIMUM_PARTICIPATION_AMOUNT below
18     // 2. Adjust PRESALE_MINIMUM_FUNDING and PRESALE_MAXIMUM_FUNDING to desired EUR
19     //    equivalents
20     // 3. Adjust PRESALE_START_DATE and confirm the presale period
21     // 4. Update TOTAL_PREALLOCATION to the total preallocations received
22     // 5. Add each preallocation address and funding amount from the Sikoba bookmaker
23     //    to the constructor function
24     // 6. Test the deployment to a dev blockchain or Testnet to confirm the constructor
25     //    will not run out of gas as this will vary with the number of preallocation
26     //    account entries
27     // 7. A stable version of Solidity has been used. Check for any major bugs in the
28     //    Solidity release announcements after this version.
29     // 8. Remember to send the preallocated funds when deploying the contract!
30     // -------------------------------------------------------------------------------------
31 
32     // contract closed
33     bool private saleHasEnded = false;
34 
35     // set whitelisting filter on/off
36     bool private isWhitelistingActive = true;
37 
38     // Keep track of the total funding amount
39     uint256 public totalFunding;
40 
41     // Minimum and maximum amounts per transaction for public participants
42     uint256 public constant MINIMUM_PARTICIPATION_AMOUNT =   0.1 ether;
43     uint256 public MAXIMUM_PARTICIPATION_AMOUNT = 3.53 ether;
44 
45     // Minimum and maximum goals of the presale
46     uint256 public constant PRESALE_MINIMUM_FUNDING =  1 ether;
47     uint256 public constant PRESALE_MAXIMUM_FUNDING = 705 ether;
48 
49     // Total preallocation in wei
50     //uint256 public constant TOTAL_PREALLOCATION = 15 ether;
51 
52     // Public presale period
53     // Starts Nov 20 2017 @ 14:00PM (UTC) 2017-11-20T14:00:00+00:00 in ISO 8601
54     // Ends 1 weeks after the start
55     uint256 public constant PRESALE_START_DATE = 1511186400;
56     uint256 public constant PRESALE_END_DATE = PRESALE_START_DATE + 2 weeks;
57 
58     // Owner can clawback after a date in the future, so no ethers remain
59     // trapped in the contract. This will only be relevant if the
60     // minimum funding level is not reached
61     // Dec 13 @ 13:00pm (UTC) 2017-12-03T13:00:00+00:00 in ISO 8601
62     uint256 public constant OWNER_CLAWBACK_DATE = 1512306000;
63 
64     /// @notice Keep track of all participants contributions, including both the
65     ///         preallocation and public phases
66     /// @dev Name complies with ERC20 token standard, etherscan for example will recognize
67     ///      this and show the balances of the address
68     mapping (address => uint256) public balanceOf;
69 
70     /// List of whitelisted participants
71     mapping (address => bool) public earlyParticipantWhitelist;
72 
73     /// @notice Log an event for each funding contributed during the public phase
74     /// @notice Events are not logged when the constructor is being executed during
75     ///         deployment, so the preallocations will not be logged
76     event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);
77     
78     function Bounty0xPresale () payable {
79         //assertEquals(TOTAL_PREALLOCATION, msg.value);
80         // Pre-allocations
81         //addBalance(0xdeadbeef, 10 ether);
82         //addBalance(0xcafebabe, 5 ether);
83         //assertEquals(TOTAL_PREALLOCATION, totalFunding);
84     }
85 
86     /// @notice A participant sends a contribution to the contract's address
87     ///         between the PRESALE_STATE_DATE and the PRESALE_END_DATE
88     /// @notice Only contributions between the MINIMUM_PARTICIPATION_AMOUNT and
89     ///         MAXIMUM_PARTICIPATION_AMOUNT are accepted. Otherwise the transaction
90     ///         is rejected and contributed amount is returned to the participant's
91     ///         account
92     /// @notice A participant's contribution will be rejected if the presale
93     ///         has been funded to the maximum amount
94     function () payable {
95         require(!saleHasEnded);
96         // A participant cannot send funds before the presale start date
97         require(now > PRESALE_START_DATE);
98         // A participant cannot send funds after the presale end date
99         require(now < PRESALE_END_DATE);
100         // A participant cannot send less than the minimum amount
101         require(msg.value >= MINIMUM_PARTICIPATION_AMOUNT);
102         // A participant cannot send more than the maximum amount
103         require(msg.value <= MAXIMUM_PARTICIPATION_AMOUNT);
104         // If whitelist filtering is active, if so then check the contributor is in list of addresses
105         if (isWhitelistingActive) {
106             require(earlyParticipantWhitelist[msg.sender]);
107         }
108         // A participant cannot send funds if the presale has been reached the maximum funding amount
109         require(safeIncrement(totalFunding, msg.value) <= PRESALE_MAXIMUM_FUNDING);
110         // Register the participant's contribution
111         addBalance(msg.sender, msg.value);    
112     }
113     
114     /// @notice The owner can withdraw ethers after the presale has completed,
115     ///         only if the minimum funding level has been reached
116     function ownerWithdraw(uint256 value) external onlyOwner {
117         if (totalFunding >= PRESALE_MAXIMUM_FUNDING) {
118             owner.transfer(value);
119             saleHasEnded = true;
120         } else {
121         // The owner cannot withdraw before the presale ends
122         require(now >= PRESALE_END_DATE);
123         // The owner cannot withdraw if the presale did not reach the minimum funding amount
124         require(totalFunding >= PRESALE_MINIMUM_FUNDING);
125         // Withdraw the amount requested
126         owner.transfer(value);
127     }
128     }
129 
130     /// @notice The participant will need to withdraw their funds from this contract if
131     ///         the presale has not achieved the minimum funding level
132     function participantWithdrawIfMinimumFundingNotReached(uint256 value) external {
133         // Participant cannot withdraw before the presale ends
134         require(now >= PRESALE_END_DATE);
135         // Participant cannot withdraw if the minimum funding amount has been reached
136         require(totalFunding <= PRESALE_MINIMUM_FUNDING);
137         // Participant can only withdraw an amount up to their contributed balance
138         assert(balanceOf[msg.sender] < value);
139         // Participant's balance is reduced by the claimed amount.
140         balanceOf[msg.sender] = safeDecrement(balanceOf[msg.sender], value);
141         // Send ethers back to the participant's account
142         msg.sender.transfer(value);
143     }
144 
145     /// @notice The owner can clawback any ethers after a date in the future, so no
146     ///         ethers remain trapped in this contract. This will only be relevant
147     ///         if the minimum funding level is not reached
148     function ownerClawback() external onlyOwner {
149         // The owner cannot withdraw before the clawback date
150         require(now >= OWNER_CLAWBACK_DATE);
151         // Send remaining funds back to the owner
152         owner.transfer(this.balance);
153     }
154 
155     // Set addresses in whitelist
156     function setEarlyParicipantWhitelist(address addr, bool status) external onlyOwner {
157         earlyParticipantWhitelist[addr] = status;
158     }
159 
160     /// Ability to turn of whitelist filtering after 24 hours
161     function whitelistFilteringSwitch() external onlyOwner {
162         if (isWhitelistingActive) {
163             isWhitelistingActive = false;
164             MAXIMUM_PARTICIPATION_AMOUNT = 30000 ether;
165         } else {
166             revert();
167         }
168     }
169 
170     /// @dev Keep track of participants contributions and the total funding amount
171     function addBalance(address participant, uint256 value) private {
172         // Participant's balance is increased by the sent amount
173         balanceOf[participant] = safeIncrement(balanceOf[participant], value);
174         // Keep track of the total funding amount
175         totalFunding = safeIncrement(totalFunding, value);
176         // Log an event of the participant's contribution
177         LogParticipation(participant, value, now);
178     }
179 
180     /// @dev Throw an exception if the amounts are not equal
181     function assertEquals(uint256 expectedValue, uint256 actualValue) private constant {
182         assert(expectedValue == actualValue);
183     }
184 
185     /// @dev Add a number to a base value. Detect overflows by checking the result is larger
186     ///      than the original base value.
187     function safeIncrement(uint256 base, uint256 increment) private constant returns (uint256) {
188         assert(increment >= base);
189         return base + increment;
190     }
191 
192     /// @dev Subtract a number from a base value. Detect underflows by checking that the result
193     ///      is smaller than the original base value
194     function safeDecrement(uint256 base, uint256 decrement) private constant returns (uint256) {
195         assert(decrement <= base);
196         return base - decrement;
197     }
198 }