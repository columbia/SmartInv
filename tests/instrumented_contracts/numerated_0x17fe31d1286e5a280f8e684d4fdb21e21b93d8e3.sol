1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract CryptoLeaders {
51   //ETHEREUM SOLIDITY VERSION 4.19
52   //CRYPTOCOLLECTED LTD
53   
54   //INITIALIZATION VALUES
55   address ceoAddress = 0xc10A6AedE9564efcDC5E842772313f0669D79497;
56   struct Leaders {
57     address currentLeaderOwner;
58     uint256 currentValue;
59    
60   }
61 
62   Leaders[32] data;
63   
64   //No-Arg Constructor initializes basic low-end values.
65   function CryptoLeaders() public {
66     for (uint i = 0; i < 32; i++) {
67      
68       data[i].currentValue = 15000000000000000;
69       data[i].currentLeaderOwner = msg.sender;
70     }
71   }
72 
73   // Function to pay the previous owner.
74   //     Neccesary for contract integrity
75   function payPreviousOwner(address previousLeaderOwner, uint256 currentValue) private {
76     previousLeaderOwner.transfer(currentValue);
77   }
78   //Sister function to payPreviousOwner():
79   //   Addresses wallet-to-wallet payment totality
80   function transactionFee(address, uint256 currentValue) private {
81     ceoAddress.transfer(currentValue);
82   }
83   // Function that handles logic for setting prices and assigning collectibles to addresses.
84   // Doubles instance value  on purchase.
85   // Verify  correct amount of ethereum has been received
86   function purchaseLeader(uint uniqueLeaderID) public payable returns (uint, uint) {
87     require(uniqueLeaderID >= 0 && uniqueLeaderID <= 31);
88     // Set initial price to .02 (ETH)
89     if ( data[uniqueLeaderID].currentValue == 15000000000000000 ) {
90       data[uniqueLeaderID].currentValue = 30000000000000000;
91     } else {
92       // Double price
93       data[uniqueLeaderID].currentValue = (data[uniqueLeaderID].currentValue / 10) * 12;
94     }
95     
96     require(msg.value >= data[uniqueLeaderID].currentValue * uint256(1));
97     // Call payPreviousOwner() after purchase.
98     payPreviousOwner(data[uniqueLeaderID].currentLeaderOwner,  (data[uniqueLeaderID].currentValue / 100) * (88)); 
99     transactionFee(ceoAddress, (data[uniqueLeaderID].currentValue / 100) * (12));
100     // Assign owner.
101     data[uniqueLeaderID].currentLeaderOwner = msg.sender;
102     // Return values for web3js display.
103     return (uniqueLeaderID, data[uniqueLeaderID].currentValue);
104 
105   }
106   // Gets the current list of heroes, their owners, and prices. 
107   function getCurrentLeaderOwners() external view returns (address[], uint256[]) {
108     address[] memory currentLeaderOwners = new address[](32);
109     uint256[] memory currentValues =  new uint256[](32);
110     for (uint i=0; i<32; i++) {
111       currentLeaderOwners[i] = (data[i].currentLeaderOwner);
112       currentValues[i] = (data[i].currentValue);
113     }
114     return (currentLeaderOwners,currentValues);
115   }
116   
117 }