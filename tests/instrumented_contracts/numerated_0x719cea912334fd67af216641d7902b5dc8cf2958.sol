1 pragma solidity ^0.4.24;
2 
3 contract owned{
4     address public owner;
5     constructor () public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner{
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnerShip(address newOwer) public onlyOwner{
15         owner = newOwer;
16     }
17 
18 }
19 
20 interface token{
21     function transfer(address _to,uint amount) external;
22 }
23 
24 contract DSSCrowdsale is owned{
25 
26     uint public fundingGoal;
27     uint public deadline;
28     uint public price;
29     token public tokenReward;
30     address public beneficiary;
31 
32     event FundTransfer(address backer,uint amount);
33 
34     constructor (
35         uint fundingGoalInEther,
36         uint durationInMinutes,
37         uint etherCostOfEachToken,
38         address addressOfToken)public{
39 
40         fundingGoal = fundingGoalInEther *1 ether;
41         deadline = now + durationInMinutes * 1 minutes;
42 
43         price = etherCostOfEachToken  * 1 wei ;
44         tokenReward = token(addressOfToken);
45         beneficiary = msg.sender;
46         }
47     function setPrice(uint newPrice) public onlyOwner{
48       price = newPrice * 1 wei;
49 
50     }
51     function () public payable {
52         require(now < deadline);
53         uint amount = msg.value;
54 
55         uint tokenAmount = amount * price ;
56 
57         tokenReward.transfer(msg.sender,tokenAmount);
58 
59         beneficiary.transfer(amount);
60 
61         emit FundTransfer(msg.sender,amount);
62     }
63 }