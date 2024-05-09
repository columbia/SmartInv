1 pragma solidity ^0.4.20;
2 
3 contract NotFomo3D {
4 
5     //owner of contract
6     address public owner;
7     
8     //last bidder and winner
9     address public latestBidder;
10     address public latestWinner;
11     
12     //time left of auction
13     uint public endTime;
14     uint public addTime;
15     
16     //event for auctions bid
17     event Bid(address bidder, uint ending, uint adding, uint balance);
18 
19     //constructor
20     function NotFomo3D() public {
21         owner           = msg.sender;
22         latestBidder    = msg.sender;
23         latestWinner    = msg.sender;
24         addTime         = (2 hours);
25         endTime         = 0;
26     }
27 
28     //bid on auction
29     function bid() payable public{
30         
31         //bid must be precisely 0.005 ETH
32         require(msg.value == 5000000000000000);
33 
34         //place first bid
35         if(endTime == 0){
36             endTime = (now + addTime);
37         }
38         
39         //place a bid
40         if(endTime != 0 && endTime > now){
41             addTime -= (10 seconds);
42             endTime = (now + addTime);
43             latestBidder = msg.sender;
44             Bid(latestBidder, endTime, addTime, this.balance);
45         }
46         
47         //winner found, restart auction
48         if(addTime == 0 || endTime <= now){
49             latestWinner = latestBidder;
50             
51             //restart auction
52             addTime = (2 hours);
53             endTime = (now + addTime);
54             latestBidder = msg.sender;
55             Bid(latestBidder, endTime, addTime, ((this.balance/20)*17)+5000000000000000);
56             
57             //transfer winnings
58             owner.transfer((this.balance/20)*1);
59             latestWinner.transfer(((this.balance-5000000000000000)/10)*8);
60         }
61     }
62     
63     //allow for eth to be fed to the contract
64     function() public payable {}
65 }