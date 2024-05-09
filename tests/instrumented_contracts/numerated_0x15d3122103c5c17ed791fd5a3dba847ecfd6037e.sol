1 pragma solidity ^0.4.18;
2 
3 // File: contracts/Ownable.sol
4 
5 contract Ownable {
6   address public owner;
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     require(msg.sender == owner);
16     _;
17   }
18 
19   function transferOwnership(address newOwner) public onlyOwner {
20     require(newOwner != address(0));
21     OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23   }
24 
25 }
26 
27 // File: contracts/SingleMessage.sol
28 
29 contract SingleMessage is Ownable {
30   string public message;
31   uint256 public priceInWei;
32   uint256 public maxLength;
33 
34   event MessageSet(string message, uint256 priceInWei, uint256 newPriceInWei, address payer);
35 
36   function SingleMessage(string initialMessage, uint256 initialPriceInWei, uint256 maxLengthArg) public {
37     message = initialMessage;
38     priceInWei = initialPriceInWei;
39     maxLength = maxLengthArg;
40   }
41 
42   function set(string newMessage) external payable {
43     require(msg.value >= priceInWei);
44     require(bytes(newMessage).length <= maxLength);
45 
46     uint256 newPrice = priceInWei * 2;
47     MessageSet(newMessage, priceInWei, newPrice, msg.sender);
48     priceInWei = newPrice;
49     message = newMessage;
50   }
51 
52   function withdraw(address destination, uint256 amountInWei) external onlyOwner {
53     require(this.balance >= amountInWei);
54     require(destination != address(0));
55     destination.transfer(amountInWei);
56   }
57 }