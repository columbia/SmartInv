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
73 
74   modifier onlyOwner {
75     require(msg.sender == owner);
76     _;
77   }
78   
79   function claimReward(uint _bookingIndex) {
80     UnicornRanch ranch = UnicornRanch(unicornRanchAddress);
81     var (unicornCount, visitType, , , state, , completedCount) = ranch.getBooking(msg.sender, _bookingIndex);
82     require(state == UnicornRanch.VisitState.Completed); // Must be a visit that's completed (not in progress or repossessed)
83     require(visitType != UnicornRanch.VisitType.Spa); // Must be longer than a Spa visit
84     require(completedCount > unicornCount); // Must have triggered the "birth" conditions so the user went home with more than what they send in
85     require(rewardClaimed[msg.sender] == false); // Must not have already claimed the reward
86       
87     rewardClaimed[msg.sender] = true;
88     allowedAmounts[msg.sender] = allowedAmounts[msg.sender].add(rewardUnicornAmount);
89       
90     RewardClaimed(msg.sender, _bookingIndex);
91   }
92   
93   /**
94    * Sell back a number of unicorn tokens, in exchange for ether.
95    */
96   function sell(uint _unicornCount) {
97     require(_unicornCount > 0);
98     allowedAmounts[msg.sender] = allowedAmounts[msg.sender].sub(_unicornCount);
99     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
100     cardboardUnicorns.transferFrom(msg.sender, owner, _unicornCount); // Transfer the actual asset
101     uint total = pricePerUnicorn.mul(_unicornCount);
102     msg.sender.transfer(total);
103     UnicornsSold(msg.sender, _unicornCount, pricePerUnicorn, total);
104   }
105   
106   function() payable {
107     // Thanks for the donation!
108   }
109   
110   /**
111    * Change ownership
112    */
113   function changeOwner(address _newOwner) onlyOwner {
114     owner = _newOwner;
115   }
116 
117   /**
118    * Change the outside contracts used by this contract
119    */
120   function changeCardboardUnicornTokenAddress(address _newTokenAddress) onlyOwner {
121     cardboardUnicornTokenAddress = _newTokenAddress;
122   }
123   function changeUnicornRanchAddress(address _newAddress) onlyOwner {
124     unicornRanchAddress = _newAddress;
125   }
126   
127   /**
128    * Update unicorn price
129    */
130   function changePricePerUnicorn(uint _newPrice) onlyOwner {
131     pricePerUnicorn = _newPrice;
132   }
133   
134   /**
135    * Update reward amount
136    */
137   function changeRewardAmount(uint _newAmount) onlyOwner {
138     rewardUnicornAmount = _newAmount;
139   }
140   
141   function setAllowance(address _who, uint _amount) onlyOwner {
142     allowedAmounts[_who] = _amount;
143   }
144   
145   function withdraw() onlyOwner {
146     owner.transfer(this.balance); // Send all ether in this contract to this contract's owner
147   }
148   function withdrawForeignTokens(address _tokenContract) onlyOwner {
149     ERC20Token token = ERC20Token(_tokenContract);
150     token.transfer(owner, token.balanceOf(address(this))); // Send all owned tokens to this contract's owner
151   }
152   
153 }