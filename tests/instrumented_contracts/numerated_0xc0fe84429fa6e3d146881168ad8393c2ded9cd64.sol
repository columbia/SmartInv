1 pragma solidity ^0.4.15;
2 
3 contract ForniteCoinSelling {
4     
5     Token public coin;
6     address public coinOwner;
7     address public owner;
8     
9     uint256 public pricePerCoin;
10     
11     constructor(address coinAddressToUse, address coinOwnerToUse, address ownerToUse, uint256 pricePerCoinToUse) public {
12         coin = Token(coinAddressToUse);
13         coinOwner = coinOwnerToUse;
14         owner = ownerToUse;
15         pricePerCoin = pricePerCoinToUse;
16     }
17     
18     function newCoinOwner(address newCoinOwnerToUse) public {
19         if(msg.sender == owner) {
20             coinOwner = newCoinOwnerToUse;
21         } else {
22             revert();
23         }
24     }
25     
26     function newOwner(address newOwnerToUse) public {
27         if(msg.sender == owner) {
28             owner = newOwnerToUse;
29         } else {
30             revert();
31         }
32     }
33     
34     function newPrice(uint256 newPricePerCoinToUse) public {
35         if(msg.sender == owner) {
36             pricePerCoin = newPricePerCoinToUse;
37         } else {
38             revert();
39         }
40     }
41     
42     function payOut() public {
43         if(msg.sender == owner) {
44             owner.transfer(address(this).balance);
45         } else {
46             revert();
47         }
48     }
49     
50     function() public payable {
51         uint256 numberOfCoin = msg.value/pricePerCoin;
52         if(numberOfCoin>=0) revert();
53         if(coin.balanceOf(coinOwner) < numberOfCoin) revert();
54         if(!coin.transferFrom(coinOwner, msg.sender, numberOfCoin)) revert();
55     }
56 }
57 
58 contract Token {
59     mapping (address => uint256) public balanceOf;
60     function transferFrom(
61          address _from,
62          address _to,
63          uint256 _amount
64      ) public payable returns(bool success) {
65         _from = _from;
66         _to = _to;
67         _amount = _amount;
68         return true;
69     }
70 }