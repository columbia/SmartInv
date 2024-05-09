1 pragma solidity ^0.4.18;
2  
3 /**
4  * Copyright 2018, Flowchain.co
5  *
6  * The FlowchainCoin (FLC) smart contract of private sale Round A
7  */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16         uint256 c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal constant returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal constant returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 interface Token {
41     function mintToken(address to, uint amount) external returns (bool success);  
42     function setupMintableAddress(address _mintable) public returns (bool success);
43 }
44 
45 contract MintableSale {
46     // @notice Create a new mintable sale
47     /// @param rate The exchange rate
48     /// @param fundingGoalInEthers The funding goal in ethers
49     /// @param durationInMinutes The duration of the sale in minutes
50     /// @return 
51     function createMintableSale(uint256 rate, uint fundingGoalInEthers, uint durationInMinutes) external returns (bool success);
52 }
53 
54 contract EarlyTokenSale is MintableSale {
55     using SafeMath for uint256;
56     uint256 public fundingGoal;
57     uint256 public tokensPerEther;
58     uint public deadline;
59     address public multiSigWallet;
60     uint256 public amountRaised;
61     Token public tokenReward;
62     mapping(address => uint256) public balanceOf;
63     bool fundingGoalReached = false;
64     bool crowdsaleClosed = false;
65     address public creator;
66     address public addressOfTokenUsedAsReward;
67     bool public isFunding = false;
68 
69     /* accredited investors */
70     mapping (address => uint256) public accredited;
71 
72     event FundTransfer(address backer, uint amount);
73 
74     /* Constrctor function */
75     function EarlyTokenSale(
76         address _addressOfTokenUsedAsReward
77     ) payable {
78         creator = msg.sender;
79         multiSigWallet = 0x9581973c54fce63d0f5c4c706020028af20ff723;
80         // Token Contract
81         addressOfTokenUsedAsReward = _addressOfTokenUsedAsReward;
82         tokenReward = Token(addressOfTokenUsedAsReward);
83         // Setup accredited investors
84         setupAccreditedAddress(0xec7210E3db72651Ca21DA35309A20561a6F374dd, 1000);
85     }
86 
87     // @dev Start a new mintable sale.
88     // @param rate The exchange rate in ether, for example 1 ETH = 6400 FLC
89     // @param fundingGoalInEthers
90     // @param durationInMinutes
91     function createMintableSale(uint256 rate, uint fundingGoalInEthers, uint durationInMinutes) external returns (bool success) {
92         require(msg.sender == creator);
93         require(isFunding == false);
94         require(rate <= 6400 && rate >= 1);                   // rate must be between 1 and 6400
95         require(durationInMinutes >= 60 minutes);
96         deadline = now + durationInMinutes * 1 minutes;
97         fundingGoal = amountRaised + fundingGoalInEthers * 1 ether;
98         tokensPerEther = rate;
99         isFunding = true;
100         return true;    
101     }
102 
103     modifier afterDeadline() { if (now > deadline) _; }
104     modifier beforeDeadline() { if (now <= deadline) _; }
105 
106     /// @param _accredited The address of the accredited investor
107     /// @param _amountInEthers The amount of remaining ethers allowed to invested
108     /// @return Amount of remaining tokens allowed to spent
109     function setupAccreditedAddress(address _accredited, uint _amountInEthers) public returns (bool success) {
110         require(msg.sender == creator);    
111         accredited[_accredited] = _amountInEthers * 1 ether;
112         return true;
113     }
114 
115     /// @dev This function returns the amount of remaining ethers allowed to invested
116     /// @return The amount
117     function getAmountAccredited(address _accredited) constant returns (uint256) {
118         return accredited[_accredited];
119     }
120 
121     function closeSale() beforeDeadline {
122         isFunding = false;
123     }
124 
125     // change creator address
126     function changeCreator(address _creator) external {
127         require(msg.sender == creator);
128         creator = _creator;
129     }
130 
131     /// @dev This function returns the current exchange rate during the sale
132     /// @return The address of token creator
133     function getRate() beforeDeadline constant returns (uint) {
134         return tokensPerEther;
135     }
136 
137     /// @dev This function returns the amount raised in wei
138     /// @return The address of token creator
139     function getAmountRaised() constant returns (uint) {
140         return amountRaised;
141     }
142 
143     function () payable {
144         require(isFunding == true && amountRaised < fundingGoal);
145         require(msg.value >= 1 ether);
146         uint256 amount = msg.value;
147         require(accredited[msg.sender] - amount >= 0);       
148         uint256 value = amount.mul(tokensPerEther);
149         multiSigWallet.transfer(amount);      
150         balanceOf[msg.sender] += amount;
151         accredited[msg.sender] -= amount;
152         amountRaised += amount;
153         FundTransfer(msg.sender, amount);
154         tokenReward.mintToken(msg.sender, value);        
155     }
156 }