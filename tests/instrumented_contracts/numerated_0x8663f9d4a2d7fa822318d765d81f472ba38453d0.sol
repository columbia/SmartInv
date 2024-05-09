1 pragma solidity ^0.4.15;
2 
3 /// @title DNNToken contract - Main DNN contract
4 /// @author Dondrey Taylor - <dondrey@dnn.media>
5 contract DNNToken {
6     enum DNNSupplyAllocations {
7         EarlyBackerSupplyAllocation,
8         PRETDESupplyAllocation,
9         TDESupplyAllocation,
10         BountySupplyAllocation,
11         WriterAccountSupplyAllocation,
12         AdvisorySupplyAllocation,
13         PlatformSupplyAllocation
14     }
15     function balanceOf(address who) constant public returns (uint256);
16     function issueTokens(address, uint256, DNNSupplyAllocations) public pure returns (bool) {}
17 }
18 
19 /// @title DNNHODLGame contrac
20 /// @author Dondrey Taylor - <dondrey@dnn.media>
21 contract DNNHODLGame {
22 
23   // DNN Token
24   DNNToken public dnnToken;
25 
26   // Owner
27   address owner = 0x3Cf26a9FE33C219dB87c2e50572e50803eFb2981;
28 
29   // Stores largest HODLER information
30   uint256 public largestHODLERBalance = 0;
31   address public largestHODLERAddress = 0x0;
32 
33   // Stores last largest HODLER information
34   uint256 public lastLargestHODLERBalance = 0;
35   address public lastLargestHODLER = 0x0;
36 
37 	// Event that gets triggered each time a user
38 	// sends a redemption transaction to this smart contract
39   event WINNER(address indexed to, uint256 dnnBalance, uint256 dnnWon);
40 	event HODLER(address indexed to, uint256 dnnBalance);
41 	event NEWLARGESTHODLER(address indexed from, uint256 dnnBalance);
42 
43   // Owner
44   modifier onlyOwner() {
45       require (msg.sender == owner);
46       _;
47   }
48 
49   // Decide DNN Winner
50   function decideWinner(uint256 dnnToReward, DNNToken.DNNSupplyAllocations allocationType)
51     public
52     onlyOwner
53   {
54       if (!dnnToken.issueTokens(largestHODLERAddress, dnnToReward, allocationType)) {
55           revert();
56       }
57       else {
58           emit WINNER(largestHODLERAddress, largestHODLERBalance, dnnToReward);
59           lastLargestHODLER = largestHODLERAddress;
60           lastLargestHODLERBalance = largestHODLERBalance;
61           largestHODLERAddress = 0x0;
62           largestHODLERBalance = 0;
63       }
64   }
65 
66   // Constructor
67   constructor() public
68   {
69       dnnToken = DNNToken(0x9D9832d1beb29CC949d75D61415FD00279f84Dc2);
70   }
71 
72 	// Handles incoming transactions
73 	function () public payable {
74 
75       // Sender address
76       address dnnHODLER = msg.sender;
77 
78       // Sender balance
79       uint256 dnnHODLERBalance = dnnToken.balanceOf(msg.sender);
80 
81       // Check if the senders balance is the largest
82       if (largestHODLERBalance <= dnnHODLERBalance) {
83           if ( (lastLargestHODLER != dnnHODLER) ||
84               (lastLargestHODLER == dnnHODLER && lastLargestHODLERBalance < dnnHODLERBalance)
85           ) {
86               largestHODLERBalance = dnnHODLERBalance;
87               largestHODLERAddress = dnnHODLER;
88               emit NEWLARGESTHODLER(msg.sender, dnnHODLERBalance);
89           }
90       }
91 
92       emit HODLER(msg.sender, dnnHODLERBalance);
93 
94       if (msg.value > 0) {
95           owner.transfer(msg.value);
96       }
97 	}
98 }