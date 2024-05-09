1 pragma solidity 0.5.5;
2 
3 contract IERC20 {
4     function transfer(address to, uint256 value) public returns (bool) {}
5 }
6 
7 contract NoTx {
8 
9   // initialize
10   uint256 public REWARD_PER_WIN = 125000000;
11   uint256 public CREATOR_REWARD = 1250000;
12   address public CREATOR_ADDRESS;
13   address public GTT_ADDRESS;
14 
15   // game state params
16   uint256 public lastPayout;
17   address public currWinner;
18 
19   mapping (uint256 => bool) public didBlockHaveTx;  // blockNumber, didBlockHaveTx
20 
21   constructor() public {
22     CREATOR_ADDRESS = msg.sender;
23     currWinner = address(this);
24   }
25 
26   // can only be called once
27   function setTokenAddress(address _gttAddress) public {
28     if (GTT_ADDRESS == address(0)) {
29       GTT_ADDRESS = _gttAddress;
30     }
31   }
32 
33   function play() public {
34     uint256 currentBlock = block.number;
35     uint256 lastBlock = currentBlock - 1;
36 
37     // pay out last winner
38     if (!didBlockHaveTx[lastBlock]) {
39       payOut(currWinner);
40 
41       lastPayout = currentBlock;
42     }
43 
44     // do nothing if a block has already been transacted in
45     if (didBlockHaveTx[currentBlock] == false) {
46       didBlockHaveTx[currentBlock] = true;
47       currWinner = msg.sender;
48     }
49   }
50 
51   function payOut(address winner) internal {
52     IERC20(GTT_ADDRESS).transfer(winner, REWARD_PER_WIN);
53     IERC20(GTT_ADDRESS).transfer(CREATOR_ADDRESS, CREATOR_REWARD);
54   }
55 }