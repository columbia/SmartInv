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
19 /// @title DNNTradeGame contract
20 /// @author Dondrey Taylor - <dondrey@dnn.media>
21 contract DNNTradeGame {
22 
23   // DNN Token
24   DNNToken public dnnToken;
25 
26   // Owner
27   address owner = 0x3Cf26a9FE33C219dB87c2e50572e50803eFb2981;
28 
29 	// Event that gets triggered each time a user
30 	// sends a redemption transaction to this smart contract
31   event Winner(address indexed to, uint256 dnnBalance, uint256 dnnWon);
32   event Trader(address indexed to, uint256 dnnBalance);
33 
34   // Owner
35   modifier onlyOwner() {
36       require (msg.sender == owner);
37       _;
38   }
39 
40   // Decide DNN Winner
41   function pickWinner(address winnerAddress, uint256 dnnToReward, DNNToken.DNNSupplyAllocations allocationType)
42     public
43     onlyOwner
44   {
45       uint256 winnerDNNBalance = dnnToken.balanceOf(msg.sender);
46 
47       if (!dnnToken.issueTokens(winnerAddress, dnnToReward, allocationType)) {
48           revert();
49       }
50       else {
51           emit Winner(winnerAddress, winnerDNNBalance, dnnToReward);
52       }
53   }
54 
55   // Constructor
56   constructor() public
57   {
58       dnnToken = DNNToken(0x9D9832d1beb29CC949d75D61415FD00279f84Dc2);
59   }
60 
61 	// Handles incoming transactions
62 	function () public payable {
63 
64       // Sender address
65       address dnnHolder = msg.sender;
66 
67       // Sender balance
68       uint256 dnnHolderBalance = dnnToken.balanceOf(msg.sender);
69 
70       // Event to reference for picking a winner
71       emit Trader(dnnHolder, dnnHolderBalance);
72 
73       if (msg.value > 0) {
74           owner.transfer(msg.value);
75       }
76 	}
77 }