1 pragma solidity ^0.4.24;
2 
3 interface IERC20Token {
4     function balanceOf(address owner) external returns (uint256);
5     function transfer(address to, uint256 amount) external returns (bool);
6     function decimals() external returns (uint256);
7 }
8 
9 contract TokenSale {
10     IERC20Token public tokenContract;  // the token being sold
11     uint256 public price;              // the price, in wei, per token
12     address owner;
13 
14     uint256 public tokensSold;
15 
16     event Sold(address buyer, uint256 amount);
17 
18     constructor() public {
19         owner = msg.sender;
20         tokenContract = IERC20Token(0x25a803EC5d9a14D41F1Af5274d3f2C77eec80CE9);
21         price = 800 finney;
22     }
23 
24     // Guards against integer overflows
25     function safeMultiply(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         } else {
29             uint256 c = a * b;
30             assert(c / a == b);
31             return c;
32         }
33     }
34 
35     function buyTokens(uint256 numberOfTokens) public payable {
36         require(msg.value == safeMultiply(numberOfTokens, price));
37 
38         uint256 scaledAmount = safeMultiply(numberOfTokens,
39             uint256(10) ** tokenContract.decimals());
40 
41         require(tokenContract.balanceOf(this) >= scaledAmount);
42 
43         emit Sold(msg.sender, numberOfTokens);
44         tokensSold += numberOfTokens;
45 
46         require(tokenContract.transfer(msg.sender, scaledAmount));
47     }
48 
49     function retractTokens(uint256 numberOfTokens) public {
50         require(msg.sender == owner);
51         tokenContract.transfer(owner, numberOfTokens);
52     }
53 
54     function withdraw() public {
55         require(msg.sender == owner);
56         msg.sender.transfer(address(this).balance);
57     }
58 }