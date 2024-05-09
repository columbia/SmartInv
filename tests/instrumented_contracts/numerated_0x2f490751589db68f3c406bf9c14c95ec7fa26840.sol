1 pragma solidity ^0.4.11;
2 
3 contract ERC20Token {
4   function balanceOf(address _who) constant returns (uint balance);
5   function transferFrom(address _from, address _to, uint _value);
6   function transfer(address _to, uint _value);
7 }
8 
9 contract UnicornRanch {
10   enum VisitType { Spa, Afternoon, Day, Overnight, Week, Extended }
11   enum VisitState { InProgress, Completed, Repossessed }
12   function getBooking(address _who, uint _index) constant returns (uint _unicornCount, VisitType _type, uint _startBlock, uint _expiresBlock, VisitState _state, uint _completedBlock, uint _completedCount);
13 }
14 
15 /**
16  * Math operations with safety checks
17  */
18 library SafeMath {
19   function mul(uint a, uint b) internal returns (uint) {
20     uint c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint a, uint b) internal returns (uint) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint a, uint b) internal returns (uint) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint a, uint b) internal returns (uint) {
38     uint c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 
43   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
44     return a >= b ? a : b;
45   }
46 
47   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a < b ? a : b;
49   }
50 
51   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
52     return a >= b ? a : b;
53   }
54 
55   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a < b ? a : b;
57   }
58 }
59 
60 contract UnicornRefunds {
61   using SafeMath for uint;
62 
63   address public cardboardUnicornTokenAddress;
64   address public unicornRanchAddress;
65   address public owner = msg.sender;
66   uint public pricePerUnicorn = 1 finney;
67   uint public rewardUnicornAmount = 100;
68   mapping(address => uint) allowedAmounts;
69   mapping(address => bool) rewardClaimed;
70 
71   event RewardClaimed(address indexed _who, uint _bookingIndex);
72   event UnicornsSold(address indexed _who, uint _unicornCount, uint _unicornCost, uint _paymentTotal);
73   event DonationReceived(address indexed _who, uint _amount, uint _allowanceEarned);
74 
75   modifier onlyOwner {
76     require(msg.sender == owner);
77     _;
78   }
79   
80   function getAllowedAmount(address _who) constant returns (uint _amount) {
81     return allowedAmounts[_who];
82   }
83 
84   function claimReward(uint _bookingIndex) {
85     UnicornRanch ranch = UnicornRanch(unicornRanchAddress);
86     var (unicornCount, visitType, , , state, , completedCount) = ranch.getBooking(msg.sender, _bookingIndex);
87     require(state == UnicornRanch.VisitState.Completed); // Must be a visit that's completed (not in progress or repossessed)
88     require(visitType != UnicornRanch.VisitType.Spa); // Must be longer than a Spa visit
89     require(completedCount > unicornCount); // Must have triggered the "birth" conditions so the user went home with more than what they send in
90     require(rewardClaimed[msg.sender] == false); // Must not have already claimed the reward
91       
92     rewardClaimed[msg.sender] = true;
93     allowedAmounts[msg.sender] = allowedAmounts[msg.sender].add(rewardUnicornAmount);
94       
95     RewardClaimed(msg.sender, _bookingIndex);
96   }
97   
98   /**
99    * Sell back a number of unicorn tokens, in exchange for ether.
100    */
101   function sell(uint _unicornCount) {
102     require(_unicornCount > 0);
103     allowedAmounts[msg.sender] = allowedAmounts[msg.sender].sub(_unicornCount);
104     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
105     cardboardUnicorns.transferFrom(msg.sender, owner, _unicornCount); // Transfer the actual asset
106     uint total = pricePerUnicorn.mul(_unicornCount);
107     msg.sender.transfer(total);
108     
109     UnicornsSold(msg.sender, _unicornCount, pricePerUnicorn, total);
110   }
111   
112   function() payable {
113     uint count = (msg.value).div(pricePerUnicorn);
114     allowedAmounts[msg.sender] = allowedAmounts[msg.sender].add(count);
115     
116     DonationReceived(msg.sender, msg.value, count);
117   }
118   
119   /**
120    * Change ownership
121    */
122   function changeOwner(address _newOwner) onlyOwner {
123     owner = _newOwner;
124   }
125 
126   /**
127    * Change the outside contracts used by this contract
128    */
129   function changeCardboardUnicornTokenAddress(address _newTokenAddress) onlyOwner {
130     cardboardUnicornTokenAddress = _newTokenAddress;
131   }
132   function changeUnicornRanchAddress(address _newAddress) onlyOwner {
133     unicornRanchAddress = _newAddress;
134   }
135   
136   /**
137    * Update unicorn price
138    */
139   function changePricePerUnicorn(uint _newPrice) onlyOwner {
140     pricePerUnicorn = _newPrice;
141   }
142   
143   /**
144    * Update reward amount
145    */
146   function changeRewardAmount(uint _newAmount) onlyOwner {
147     rewardUnicornAmount = _newAmount;
148   }
149   
150   function setAllowance(address _who, uint _amount) onlyOwner {
151     allowedAmounts[_who] = _amount;
152   }
153   
154   function withdraw() onlyOwner {
155     owner.transfer(this.balance); // Send all ether in this contract to this contract's owner
156   }
157   function withdrawForeignTokens(address _tokenContract) onlyOwner {
158     ERC20Token token = ERC20Token(_tokenContract);
159     token.transfer(owner, token.balanceOf(address(this))); // Send all owned tokens to this contract's owner
160   }
161   
162 }