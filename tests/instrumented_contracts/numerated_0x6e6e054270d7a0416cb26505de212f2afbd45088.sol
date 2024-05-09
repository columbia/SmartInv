1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract token {
31   function balanceOf(address _owner) public constant returns (uint256 balance);
32   function transfer(address _to, uint256 _value) public returns (bool success);
33 }
34 
35 contract Ownable {
36   address public owner;
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   constructor() public{
43     owner = msg.sender;
44   }
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner public {
57     require(newOwner != address(0));
58     emit OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 }
62 
63 /**
64  * @title Crowdsale
65  * @dev Crowdsale is a base contract for managing a token crowdsale.
66  * Crowdsales have a start and end timestamps, where investors can make
67  * token purchases and the crowdsale will assign them tokens based
68  * on a token per ETH rate. Funds collected are forwarded to a wallet
69  * as they arrive.
70  */
71 contract Crowdsale is Ownable {
72   using SafeMath for uint256;
73 
74   // The token being sold
75   token myToken;
76   
77   // address where funds are collected
78   address public wallet;
79   
80   // rate => tokens per ether
81   uint256 public rate = 750000 ; 
82 
83   // amount of raised money in wei
84   uint256 public weiRaised;
85 
86   /**
87    * event for token purchase logging
88    * @param beneficiary who got the tokens
89    * @param value weis paid for purchase
90    * @param amount amount of tokens purchased
91    */
92   event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
93 
94 
95   constructor(address tokenContractAddress, address _walletAddress) public{
96     wallet = _walletAddress;
97     myToken = token(tokenContractAddress);
98   }
99 
100   // fallback function can be used to buy tokens
101   function () payable public{
102     buyTokens(msg.sender);
103   }
104 
105   // low level token purchase function
106   function buyTokens(address beneficiary) public payable {
107     require(beneficiary != 0x0);
108     require(msg.value >= 10000000000000000);// min contribution 0.01ETH
109     require(msg.value <= 1000000000000000000);// max contribution 1ETH
110 
111     uint256 weiAmount = msg.value;
112 
113     // calculate token amount to be created
114     uint256 tokens = weiAmount.mul(rate);
115 
116     // update state
117     weiRaised = weiRaised.add(weiAmount);
118 
119     myToken.transfer(beneficiary, tokens);
120 
121     emit TokenPurchase(beneficiary, weiAmount, tokens);
122 
123     forwardFunds();
124   }
125 
126   // to change rate
127   function updateRate(uint256 new_rate) onlyOwner public{
128     rate = new_rate;
129   }
130 
131 
132   // send ether to the fund collection wallet
133   // override to create custom fund forwarding mechanisms
134   function forwardFunds() onlyOwner internal {
135     wallet.transfer(msg.value);
136   }
137 
138   function transferBackTo(uint256 tokens, address beneficiary) onlyOwner public returns (bool){
139     myToken.transfer(beneficiary, tokens);
140     return true;
141   }
142 
143 }