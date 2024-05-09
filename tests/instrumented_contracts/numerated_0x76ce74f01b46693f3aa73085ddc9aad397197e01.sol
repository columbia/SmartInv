1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract Crowdsale {
8 
9     uint256 public price;
10     token public tokenReward;
11     address owner;
12     uint256 public amount;
13 
14      modifier onlyCreator() {
15         require(msg.sender == owner); // If it is incorrect here, it reverts.
16         _;                              // Otherwise, it continues.
17     } 
18     
19     constructor(address addressOfTokenUsedAsReward) public {
20         owner = msg.sender;
21         price = 0.00028 ether;
22         tokenReward = token(addressOfTokenUsedAsReward);
23     }
24     
25     function updateOwner(address newOwner) public onlyCreator{
26         owner = newOwner;
27     }
28 
29     function () payable public {
30 
31         amount = msg.value;
32         uint256 tobesent = amount/price;
33         tokenReward.transfer(msg.sender, tobesent*10e17);
34 
35     }
36 
37     function safeWithdrawal() public onlyCreator {
38             uint amount = address(this).balance;
39                 owner.send(amount);
40     }
41 }