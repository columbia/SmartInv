1 pragma solidity ^0.4.18;
2 
3 contract Token {
4   function transfer(address to, uint256 value) public returns (bool success);
5   function transferFrom(address from, address to, uint256 value) public returns (bool success);
6   function balanceOf(address _owner) public constant returns (uint256 balance);
7 }
8 
9 /*************************************************************************\
10  *  Autobid: Automatic Bidirectional Distribution contract
11  *
12  *  Allows users to exchange ETH for tokens (and vice versa) at a 
13  *  predefined rate until an expiration timestamp is reached or the
14  *  contract token supply is fully depleted
15  *
16  *  Note: users must go through the approve() -> redeemTokens() process
17  *  in order to successfully convert their token balances back to ETH
18  *  (i.e. autobid contract will not recognize direct token transfers)
19  *
20 \*************************************************************************/
21 contract Autobid {
22   /*************\
23    *  Storage  *
24   \*************/
25   address public admin;         // account with access to contract balance after expiration
26   address public token;         // the token address
27   uint public exchangeRate;     // number of tokens per ETH
28   uint public expirationTime;   // epoch timestamp at which the contract expires
29   bool public active;           // whether contract is still active (false after expiration)
30 
31   /************\
32    *  Events  *
33   \************/
34   event TokenClaim(address tokenContract, address claimant, uint ethDeposited, uint tokensGranted);
35   event Redemption(address redeemer, uint tokensDeposited, uint redemptionAmount);
36 
37   /**************\
38    *  Modifiers
39   \**************/
40   modifier autobidActive() {
41     // Check active variable
42     require(active);
43 
44     // Also check current timestamp (edge condition sanity check)
45     require(now < expirationTime);
46     _;
47   }
48 
49   modifier autobidExpired() {
50     require(!active);
51     _;
52   }
53 
54   modifier onlyAdmin() {
55     require(msg.sender == admin);
56     _;
57   }
58 
59   /*********************\
60    *  Public functions
61    *********************************************************************************\
62    *  @dev Constructor
63    *  @param _admin Account with access to contract balance after expiration
64    *  @param _token Token recognized by autobid contract
65    *  @param _exchangeRate Number of tokens granted per ETH sent
66    *  @param _expirationTime Epoch time at which contract expires
67    *
68   \*********************************************************************************/
69   function Autobid(address _admin, address _token, uint _exchangeRate, uint _expirationTime) public {
70     admin = _admin;
71     token = _token;
72     exchangeRate = _exchangeRate;
73     expirationTime = _expirationTime;
74     active = true;
75   }
76 
77   /********************************************\
78    *  @dev Deposit function
79    *  Anyone can pay while contract is active
80   \********************************************/
81   function () public payable autobidActive {
82     // Calculate number of tokens owed to sender
83     uint tokenQuantity = msg.value * exchangeRate;
84 
85     // Ensure that sender receives their tokens
86     require(Token(token).transfer(msg.sender, tokenQuantity));
87 
88     // Check if contract has now expired (i.e. is empty)
89     expirationCheck();
90 
91     // Fire TokenClaim event
92     TokenClaim(token, msg.sender, msg.value, tokenQuantity);
93   }
94 
95   /******************************************************\
96    *  @dev Redeem function (exchange tokens back to ETH)
97    *  @param amount Number of tokens exchanged
98    *  Anyone can redeem while contract is active
99   \******************************************************/
100   function redeemTokens(uint amount) public autobidActive {
101     // NOTE: redeemTokens will only work once the sender has approved 
102     // the RedemptionContract address for the deposit amount 
103     require(Token(token).transferFrom(msg.sender, this, amount));
104 
105     uint redemptionValue = amount / exchangeRate; 
106 
107     msg.sender.transfer(redemptionValue);
108 
109     // Fire Redemption event
110     Redemption(msg.sender, amount, redemptionValue);
111   }
112 
113   /**************************************************************\
114    *  @dev Expires contract if any expiration criteria is met
115    *  (declared as public function to allow direct manual call)
116   \**************************************************************/
117   function expirationCheck() public {
118     // If expirationTime has been passed, contract expires
119     if (now > expirationTime) {
120       active = false;
121     }
122 
123     // If the contract's token supply is depleted, it expires
124     uint remainingTokenSupply = Token(token).balanceOf(this);
125     if (remainingTokenSupply < exchangeRate) {
126       active = false;
127     }
128   }
129 
130   /*****************************************************\
131    *  @dev Withdraw function (ETH)
132    *  @param amount Quantity of ETH (in wei) withdrawn
133    *  Admin can only withdraw after contract expires
134   \*****************************************************/
135   function adminWithdraw(uint amount) public autobidExpired onlyAdmin {
136     // Send ETH
137     msg.sender.transfer(amount);
138 
139     // Fire Redemption event
140     Redemption(msg.sender, 0, amount);
141   }
142 
143   /********************************************************\
144    *  @dev Withdraw function (tokens)
145    *  @param amount Quantity of tokens withdrawn
146    *  Admin can only access tokens after contract expires
147   \********************************************************/
148   function adminWithdrawTokens(uint amount) public autobidExpired onlyAdmin {
149     // Send tokens
150     require(Token(token).transfer(msg.sender, amount));
151 
152     // Fire TokenClaim event
153     TokenClaim(token, msg.sender, 0, amount);
154   }
155 
156   /********************************************************\
157    *  @dev Withdraw function (for miscellaneous tokens)
158    *  @param tokenContract Address of the token contract
159    *  @param amount Quantity of tokens withdrawn
160    *  Admin can only access tokens after contract expires
161   \********************************************************/
162   function adminWithdrawMiscTokens(address tokenContract, uint amount) public autobidExpired onlyAdmin {
163     // Send tokens
164     require(Token(tokenContract).transfer(msg.sender, amount));
165 
166     // Fire TokenClaim event
167     TokenClaim(tokenContract, msg.sender, 0, amount);
168   }
169 }