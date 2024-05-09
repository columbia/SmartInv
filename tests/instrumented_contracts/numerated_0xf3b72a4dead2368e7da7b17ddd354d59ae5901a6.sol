1 pragma solidity 0.5.5;
2 
3 contract IERC20 {
4     function transfer(address to, uint256 value) public returns (bool) {}
5 }
6 
7 contract GasPrice {
8 
9   // initialize
10   uint256 public REWARD_PER_WIN = 12500000;
11   uint256 public CREATOR_REWARD = 125000;
12   address public CREATOR_ADDRESS;
13   address public GTT_ADDRESS;
14   uint256 public ONE_HUNDRED_GWEI = 100000000000;
15 
16   // game state params
17   uint256 public currLowest;
18   uint256 public lastPayoutBlock;
19   address public currWinner;
20 
21   constructor() public {
22     CREATOR_ADDRESS = msg.sender;
23     lastPayoutBlock = block.number;
24     currWinner = address(this);
25   }
26 
27   // can only be called once
28   function setTokenAddress(address _gttAddress) public {
29     if (GTT_ADDRESS == address(0)) {
30       GTT_ADDRESS = _gttAddress;
31     }
32   }
33 
34   function play() public {
35     uint256 currentBlock = block.number;
36 
37     // pay out last winner
38     if (lastPayoutBlock < currentBlock) {
39       payOut(currWinner);
40 
41       // reinitialize
42       lastPayoutBlock = currentBlock;
43       currLowest = ONE_HUNDRED_GWEI;
44     }
45 
46     // set current winner
47     if (tx.gasprice <= currLowest) {
48       currLowest = tx.gasprice;
49       currWinner = msg.sender;
50     }
51   }
52 
53   function payOut(address winner) internal {
54     IERC20(GTT_ADDRESS).transfer(winner, REWARD_PER_WIN);
55     IERC20(GTT_ADDRESS).transfer(CREATOR_ADDRESS, CREATOR_REWARD);
56   }
57 }