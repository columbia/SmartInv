1 pragma solidity 0.4.15;
2 
3 contract Owned {
4     address public owner;
5 
6     function Owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         if (msg.sender != owner) {
12             throw;
13         }
14         _;
15     }
16 }
17 
18 contract IungoPresale is Owned {
19     // Total funding amount
20     uint256 public totalFunding;
21 
22     // Minimum and maximum amounts per transaction for participants
23     uint256 public constant MIN_AMOUNT = 500 finney;
24     uint256 public constant MAX_AMOUNT = 50 ether;
25 
26     // Minimum and maximum goals of the presale
27     uint256 public constant PRESALE_MINIMUM_FUNDING = 120 ether;
28     uint256 public constant PRESALE_MAXIMUM_FUNDING = 1100 ether;
29 
30     // Public presale period
31     // Starts Saturday, October 28, 2017 12:00:00 AM GMT
32     // Ends Sunday, November 19, 2017 12:00:00 AM GTM
33     uint256 public constant PRESALE_START_DATE = 1509148800;
34     uint256 public constant PRESALE_END_DATE = 1511049600;
35 
36     // Owner can clawback after a date in the future, so no ethers remain
37     // trapped in the contract. This will only be relevant if the
38     // minimum funding level is not reached
39     // Jan 01 2018 @ 12:00pm (UTC) 2018-01-01T12:00:00+00:00 in ISO 8601
40     uint256 public constant OWNER_CLAWBACK_DATE = 1514808000;
41 
42     /// @notice Keep track of all participants contributions, including both the
43     ///         preallocation and public phases
44     /// @dev Name complies with ERC20 token standard, etherscan for example will recognize
45     ///      this and show the balances of the address
46     mapping (address => uint256) public balanceOf;
47 
48     /// @notice Log an event for each funding contributed during the public phase
49     /// @notice Events are not logged when the constructor is being executed during
50     ///         deployment, so the preallocations will not be logged
51     event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);
52 
53     /// @notice A participant sends a contribution to the contract's address
54     ///         between the PRESALE_STATE_DATE and the PRESALE_END_DATE
55     /// @notice Only contributions between the MIN_AMOUNT and
56     ///         MAX_AMOUNT are accepted. Otherwise the transaction
57     ///         is rejected and contributed amount is returned to the participant's
58     ///         account
59     /// @notice A participant's contribution will be rejected if the presale
60     ///         has been funded to the maximum amount
61     function () payable {
62         // A participant cannot send funds before the presale start date
63         if (now < PRESALE_START_DATE) throw;
64         // A participant cannot send funds after the presale end date
65         if (now > PRESALE_END_DATE) throw;
66         // A participant cannot send less than the minimum amount
67         if (msg.value < MIN_AMOUNT) throw;
68         // A participant cannot send more than the maximum amount
69         if (msg.value > MAX_AMOUNT) throw;
70         // A participant cannot send funds if the presale has been reached the maximum
71         // funding amount
72         if (safeIncrement(totalFunding, msg.value) > PRESALE_MAXIMUM_FUNDING) throw;
73         // Register the participant's contribution
74         addBalance(msg.sender, msg.value);
75     }
76 
77     /// @notice The owner can withdraw ethers already during presale,
78     ///         only if the minimum funding level has been reached
79     function ownerWithdraw(uint256 value) external onlyOwner {
80         // The owner cannot withdraw if the presale did not reach the minimum funding amount
81         if (totalFunding < PRESALE_MINIMUM_FUNDING) throw;
82         // Withdraw the amount requested
83         if (!owner.send(value)) throw;
84     }
85 
86     /// @notice The participant will need to withdraw their funds from this contract if
87     ///         the presale has not achieved the minimum funding level
88     function participantWithdrawIfMinimumFundingNotReached(uint256 value) external {
89         // Participant cannot withdraw before the presale ends
90         if (now <= PRESALE_END_DATE) throw;
91         // Participant cannot withdraw if the minimum funding amount has been reached
92         if (totalFunding >= PRESALE_MINIMUM_FUNDING) throw;
93         // Participant can only withdraw an amount up to their contributed balance
94         if (balanceOf[msg.sender] < value) throw;
95         // Participant's balance is reduced by the claimed amount.
96         balanceOf[msg.sender] = safeDecrement(balanceOf[msg.sender], value);
97         // Send ethers back to the participant's account
98         if (!msg.sender.send(value)) throw;
99     }
100 
101     /// @notice The owner can clawback any ethers after a date in the future, so no
102     ///         ethers remain trapped in this contract. This will only be relevant
103     ///         if the minimum funding level is not reached
104     function ownerClawback() external onlyOwner {
105         // The owner cannot withdraw before the clawback date
106         if (now < OWNER_CLAWBACK_DATE) throw;
107         // Send remaining funds back to the owner
108         if (!owner.send(this.balance)) throw;
109     }
110 
111     /// @dev Keep track of participants contributions and the total funding amount
112     function addBalance(address participant, uint256 value) private {
113         // Participant's balance is increased by the sent amount
114         balanceOf[participant] = safeIncrement(balanceOf[participant], value);
115         // Keep track of the total funding amount
116         totalFunding = safeIncrement(totalFunding, value);
117         // Log an event of the participant's contribution
118         LogParticipation(participant, value, now);
119     }
120 
121     /// @dev Add a number to a base value. Detect overflows by checking the result is larger
122     ///      than the original base value.
123     function safeIncrement(uint256 base, uint256 increment) private constant returns (uint256) {
124         uint256 result = base + increment;
125         if (result < base) throw;
126         return result;
127     }
128 
129     /// @dev Subtract a number from a base value. Detect underflows by checking that the result
130     ///      is smaller than the original base value
131     function safeDecrement(uint256 base, uint256 increment) private constant returns (uint256) {
132         uint256 result = base - increment;
133         if (result > base) throw;
134         return result;
135     }
136 }