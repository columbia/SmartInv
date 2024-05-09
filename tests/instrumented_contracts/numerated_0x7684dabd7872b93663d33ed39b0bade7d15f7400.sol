1 pragma solidity ^0.4.21;
2 
3 interface IERC20Token {
4     function balanceOf(address owner) public returns (uint256);
5     function transfer(address to, uint256 amount) public returns (bool);
6     function decimals() public returns (uint256);
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
18     function TokenSale(IERC20Token _tokenContract, uint256 _price) public {
19         owner = msg.sender;
20         tokenContract = _tokenContract;
21         price = _price;
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
49     function endSale() public {
50         require(msg.sender == owner);
51 
52         // Send unsold tokens to the owner.
53         require(tokenContract.transfer(owner, tokenContract.balanceOf(this)));
54 
55         msg.sender.transfer(address(this).balance);
56     }
57 }