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
50 contract EtherHeroes {
51   //ETHEREUM SOLIDITY VERSION 4.19
52   //CRYPTOCOLLECTED LTD
53   
54   //INITIALIZATION VALUES
55   address ceoAddress = 0xC0c8Dc6C1485060a72FCb629560371fE09666500;
56   struct Hero {
57     address currentHeroOwner;
58     uint256 currentValue;
59    
60   }
61   Hero[16] data;
62   
63   //No-Arg Constructor initializes basic low-end values.
64   function EtherHeroes() public {
65     for (uint i = 0; i < 16; i++) {
66      
67       data[i].currentValue = 10000000000000000;
68       data[i].currentHeroOwner = msg.sender;
69     }
70   }
71 
72   // Function to pay the previous owner.
73   //     Neccesary for contract integrity
74   function payPreviousOwner(address previousHeroOwner, uint256 currentValue) private {
75     previousHeroOwner.transfer(currentValue);
76   }
77   //Sister function to payPreviousOwner():
78   //   Addresses wallet-to-wallet payment totality
79   function transactionFee(address, uint256 currentValue) private {
80     ceoAddress.transfer(currentValue);
81   }
82   // Function that handles logic for setting prices and assigning heroes to addresses.
83   // Doubles instance value  on purchase.
84   // Verify  correct amount of ethereum has been received
85   function purchaseHeroForEth(uint uniqueHeroID) public payable returns (uint, uint) {
86     require(uniqueHeroID >= 0 && uniqueHeroID <= 15);
87     // Set initial price to .02 (ETH)
88     if ( data[uniqueHeroID].currentValue == 10000000000000000 ) {
89       data[uniqueHeroID].currentValue = 20000000000000000;
90     } else {
91       // Double price
92       data[uniqueHeroID].currentValue = data[uniqueHeroID].currentValue * 2;
93     }
94     
95     require(msg.value >= data[uniqueHeroID].currentValue * uint256(1));
96     // Call payPreviousOwner() after purchase.
97     payPreviousOwner(data[uniqueHeroID].currentHeroOwner,  (data[uniqueHeroID].currentValue / 10) * (9)); 
98     transactionFee(ceoAddress, (data[uniqueHeroID].currentValue / 10) * (1));
99     // Assign owner.
100     data[uniqueHeroID].currentHeroOwner = msg.sender;
101     // Return values for web3js display.
102     return (uniqueHeroID, data[uniqueHeroID].currentValue);
103 
104   }
105   // Gets the current list of heroes, their owners, and prices. 
106   function getCurrentHeroOwners() external view returns (address[], uint256[]) {
107     address[] memory currentHeroOwners = new address[](16);
108     uint256[] memory currentValues =  new uint256[](16);
109     for (uint i=0; i<16; i++) {
110       currentHeroOwners[i] = (data[i].currentHeroOwner);
111       currentValues[i] = (data[i].currentValue);
112     }
113     return (currentHeroOwners,currentValues);
114   }
115   
116 }