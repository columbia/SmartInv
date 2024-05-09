1 pragma solidity 0.5.5;
2 
3 contract IERC20 {
4     function transfer(address to, uint256 value) public returns (bool) {}
5 }
6 
7 contract Auction {
8 
9   uint256 public REWARD_PER_WIN = 625000000;
10   uint256 public CREATOR_REWARD = 6250000;
11   address public CREATOR_ADDRESS;
12   address public GTT_ADDRESS;
13 
14   address public currWinner;   // winner
15   uint256 public currHighest;  // highest bet
16   uint256 public lastHighest;  // last highest bet
17   uint256 public lastAuctionStart;
18 
19   constructor() public {
20     CREATOR_ADDRESS = msg.sender;
21     lastAuctionStart = block.number;
22     currWinner = address(this);
23   }
24 
25   // can only be called once
26   function setTokenAddress(address _gttAddress) public {
27     if (GTT_ADDRESS == address(0)) {
28       GTT_ADDRESS = _gttAddress;
29     }
30   }
31 
32   function play() public payable {
33     uint256 currentBlock = block.number;
34 
35     // pay out last block's winnings
36     if (lastAuctionStart < currentBlock - 50) {
37       payOut();
38 
39       // reset state for new auction
40       lastAuctionStart = currentBlock;
41       currWinner = address(this);
42       lastHighest = currHighest;
43       currHighest = 0;
44     }
45 
46     // log winning tx
47     if (msg.sender.balance > currHighest) {
48       currHighest = msg.sender.balance;
49       currWinner = msg.sender;
50     }
51   }
52 
53   function payOut() internal {
54     IERC20(GTT_ADDRESS).transfer(currWinner, REWARD_PER_WIN);
55     IERC20(GTT_ADDRESS).transfer(CREATOR_ADDRESS, CREATOR_REWARD);
56   }
57 }