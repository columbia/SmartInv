1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 // Inheritance
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
7 
8 import "../interfaces/Owned.sol";
9 import "../interfaces/ISwapReceiver.sol";
10 
11 
12 /// @title   Umbrella Rewards contract
13 /// @author  umb.network
14 /// @notice  This contract serves Swap functionality for rewards tokens
15 /// @dev     It allows to swap itself for other token (main UMB token).
16 ///          Swap can start 1y from deployment or can be triggered earlier by owner.
17 ///          There is a daily limit for swapping so we can't swap all at once.
18 ///          When swap is executing, this contract do not care about target token,
19 ///          so target token should be responsible for all the check before he mint tokens for swap.
20 abstract contract SwappableToken is Owned, ERC20 {
21     using SafeMath for uint256;
22 
23     uint256 public totalAmountToBeSwapped;
24     uint256 public swappedSoFar;
25     uint256 public swapStartsOn;
26     uint256 public swapDuration;
27 
28     // ========== CONSTRUCTOR ========== //
29 
30     constructor(uint _totalAmountToBeSwapped, uint _swapDuration) {
31         require(_totalAmountToBeSwapped != 0, "_totalAmountToBeSwapped is empty");
32         require(_swapDuration != 0, "swapDuration is empty");
33 
34         totalAmountToBeSwapped = _totalAmountToBeSwapped;
35         swapStartsOn = block.timestamp + 365 days;
36         swapDuration = _swapDuration;
37     }
38 
39     // ========== MODIFIERS ========== //
40 
41     // ========== VIEWS ========== //
42 
43     function isSwapStarted() public view returns (bool) {
44         return block.timestamp >= swapStartsOn;
45     }
46 
47     function canSwapTokens(address _address) public view returns (bool) {
48         return balanceOf(_address) <= totalUnlockedAmountOfToken().sub(swappedSoFar);
49     }
50 
51     function totalUnlockedAmountOfToken() public view returns (uint256) {
52         if (block.timestamp < swapStartsOn)
53             return 0;
54         if (block.timestamp >= swapStartsOn.add(swapDuration)) {
55             return totalSupply().add(swappedSoFar);
56         } else {
57             return totalSupply().add(swappedSoFar).mul(block.timestamp.sub(swapStartsOn)).div(swapDuration);
58         }
59     }
60 
61     // ========== MUTATIVE FUNCTIONS ========== //
62 
63     function swapFor(ISwapReceiver _umb) external {
64         require(block.timestamp >= swapStartsOn, "swapping period has not started yet");
65 
66         uint amountToSwap = balanceOf(_msgSender());
67 
68         require(amountToSwap != 0, "you dont have tokens to swap");
69         require(amountToSwap <= totalUnlockedAmountOfToken().sub(swappedSoFar), "your swap is over the limit");
70 
71         swappedSoFar = swappedSoFar.add(amountToSwap);
72 
73         _burn(_msgSender(), amountToSwap);
74         _umb.swapMint(_msgSender(), amountToSwap);
75 
76         emit LogSwap(_msgSender(), amountToSwap);
77     }
78 
79     // ========== PRIVATE / INTERNAL ========== //
80 
81     // ========== RESTRICTED FUNCTIONS ========== //
82 
83     function startEarlySwap() external onlyOwner {
84         require(block.timestamp < swapStartsOn, "swap is already allowed");
85 
86         swapStartsOn = block.timestamp;
87         emit LogStartEarlySwapNow(block.timestamp);
88     }
89 
90     // ========== EVENTS ========== //
91 
92     event LogStartEarlySwapNow(uint time);
93     event LogSwap(address indexed swappedTo, uint amount);
94 }
