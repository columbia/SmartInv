1 pragma solidity ^0.4.20;
2 
3 contract Owned {
4     address public owner;
5 
6     function Owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 
21 interface AquaPriceOracle {
22   function getAudCentWeiPrice() external constant returns (uint);
23   function getAquaTokenAudCentsPrice() external constant returns (uint);
24   event NewPrice(uint _audCentWeiPrice, uint _aquaTokenAudCentsPrice);
25 }
26 
27 ///@title Aqua Price Oracle Smart contract. It is used to set Aqua token price for during crowdsale and also for token redemptions
28 contract SimpleAquaPriceOracle is Owned, AquaPriceOracle  {
29   uint internal audCentWeiPrice;
30   uint internal aquaTokenAudCentsPrice;
31  
32   ///Event is triggered when price is updated
33   ///@param _audCentWeiPrice Price of A$0.01 in Wei
34   ///@param _aquaTokenAudCentsPrice Price of 1 Aqua Token expressed in (Australian dollar) cents
35   event NewPrice(uint _audCentWeiPrice, uint _aquaTokenAudCentsPrice);
36  
37   ///Function returns price of A$0.01 in Wei
38   ///@return Price of A$0.01 in Wei
39   function getAudCentWeiPrice() external constant returns (uint) {
40       return audCentWeiPrice;
41   }
42   
43   ///Function returns price of 1 Aqua Token expressed in (Australian dollar) cents
44   ///@return Price of 1 Aqua Token expressed in (Australian dollar) cents
45   function getAquaTokenAudCentsPrice() external constant returns (uint) {
46       return aquaTokenAudCentsPrice;
47   }
48  
49   ///Constructor initializes Aqua Price Oracle smart contract
50   ///@param _audCentWeiPrice Price of A$0.01 in Wei
51   ///@param _aquaTokenAudCentsPrice Price of 1 Aqua Token expressed in (Australian dollar) cents
52   function SimpleAquaPriceOracle(uint _audCentWeiPrice, uint _aquaTokenAudCentsPrice) public {
53       updatePrice(_audCentWeiPrice, _aquaTokenAudCentsPrice);
54   }
55   
56   ///Function updates prices
57   ///@param _audCentWeiPrice Price of 1 Aqua Token expressed in (Australian dollar) cents
58   ///@param _aquaTokenAudCentsPrice Price of 1 Aqua Token expressed in (Australian dollar) cents
59   function updatePrice(uint _audCentWeiPrice, uint _aquaTokenAudCentsPrice) onlyOwner public {
60     audCentWeiPrice = _audCentWeiPrice;
61     aquaTokenAudCentsPrice = _aquaTokenAudCentsPrice;
62     NewPrice(audCentWeiPrice, aquaTokenAudCentsPrice);
63   }
64 }