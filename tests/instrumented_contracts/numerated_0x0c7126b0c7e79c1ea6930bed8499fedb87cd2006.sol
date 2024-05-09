1 pragma solidity ^0.4.25;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract CoooinsCoinAd {
50 
51 	using SafeMath for uint256;
52 
53 	string public adMessage;
54 	string public adUrl;
55 	uint256 public purchaseTimestamp;
56 	uint256 public purchaseSeconds;
57 	uint256 public adPriceWeek;
58 	uint256 public adPriceMonth;
59 	address public contractOwner;
60 
61 	event newAd(address indexed buyer, uint256 amount, string adMessage, string adUrl, uint256 purchaseSeconds, uint256 purchaseTimestamp);
62 
63 	modifier onlyContractOwner {
64 		require(msg.sender == contractOwner);
65 		_;
66 	}
67 
68 	constructor() public {
69 		adPriceWeek = 50000000000000000;
70 		adPriceMonth = 150000000000000000;
71 		contractOwner = 0x2E26a4ac59094DA46a0D8d65D90A7F7B51E5E69A;
72 	}
73 
74 	function withdraw() public onlyContractOwner {
75 		contractOwner.transfer(address(this).balance);
76 	}
77 
78 	function setAdPriceWeek(uint256 amount) public onlyContractOwner {
79 		adPriceWeek = amount;
80 	}
81 
82 	function setAdPriceMonth(uint256 amount) public onlyContractOwner {
83 		adPriceMonth = amount;
84 	}
85 
86 	function updateAd(string message, string url) public payable {
87 		// set minimum amount and make sure ad hasnt expired
88 		require(msg.value >= adPriceWeek);
89 		require(block.timestamp > purchaseTimestamp.add(purchaseSeconds));
90 
91 		// set ad time limit in seconds
92 		if (msg.value >= adPriceMonth) {
93 			purchaseSeconds = 2592000; // 1 month
94 		} else {
95 			purchaseSeconds = 604800; // 1 week
96 		}
97 
98 		adMessage = message;
99 		adUrl = url;
100 
101 		purchaseTimestamp = block.timestamp;
102 
103 		emit newAd(msg.sender, msg.value, adMessage, adUrl, purchaseSeconds, purchaseTimestamp);
104 	}
105 
106 	function getPurchaseTimestampEnds() public view returns (uint _getPurchaseTimestampAdEnds) {
107 		return purchaseTimestamp.add(purchaseSeconds);
108 	}
109 
110 	function getBalance() public view returns(uint256){
111 		return address(this).balance;
112 	}
113 
114 }