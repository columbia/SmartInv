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
11     address owner;
12     uint256 public tokensSold;
13 
14     event Sold(address buyer, uint256 amount);
15 
16     constructor(IERC20Token _tokenContract) public {
17         owner = msg.sender;
18         tokenContract = _tokenContract;
19     }
20 
21     // Guards against integer overflows
22     function safeMultiply(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         } else {
26             uint256 c = a * b;
27             assert(c / a == b);
28             return c;
29         }
30     }
31 
32     function () public payable {
33 
34         uint256 scaledAmount = safeMultiply(msg.value, 125000);
35 
36         require(tokenContract.balanceOf(this) >= scaledAmount);
37 
38 
39         tokenContract.transfer(msg.sender, scaledAmount);
40     }
41 
42 
43     function endSale() public {
44         require(msg.sender == owner);
45 
46         // Send unsold tokens to the owner.
47         require(tokenContract.transfer(owner, tokenContract.balanceOf(this)));
48 
49         msg.sender.transfer(address(this).balance);
50     }
51 }