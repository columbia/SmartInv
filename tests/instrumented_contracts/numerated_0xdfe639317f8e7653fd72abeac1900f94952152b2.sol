1 pragma solidity ^0.4.11;
2 
3 contract DGDb_Auction{
4     
5     Badge public badge_obj;
6     
7     address public beneficiary;
8     uint public expiry_date;
9     
10     address public highest_bidder;
11     uint public highest_bid;
12     mapping(address => uint) pending_returns;
13     
14     
15     function DGDb_Auction(address beneficiary_address, address badge_address, uint duration_in_days){
16         beneficiary = beneficiary_address;
17         badge_obj = Badge(badge_address);
18         expiry_date = now + duration_in_days * 1 days;
19     }
20     
21     // This function is called every time someone sends ether to this contract
22     function() payable {
23         require(now < (expiry_date));
24         require(msg.value > highest_bid);
25         
26         uint num_badges = badge_obj.balanceOf(this);
27         require(num_badges > 0);
28         
29         if (highest_bidder != 0) {
30             pending_returns[highest_bidder] += highest_bid;
31         }
32         
33         highest_bidder = msg.sender;
34         highest_bid = msg.value;
35     }
36     
37     // Bidders that have been outbid can call this to retrieve their ETH
38     function withdraw_ether() returns (bool) {
39         uint amount = pending_returns[msg.sender];
40         if (amount > 0) {
41             pending_returns[msg.sender] = 0;
42             if (!msg.sender.send(amount)) {
43                 pending_returns[msg.sender] = amount;
44                 return false;
45             }
46         }
47         return true;
48     }
49     
50     // For winner (or creator if no bids) to retrieve badge
51     function withdraw_badge() {
52         require(now >= (expiry_date));
53         
54         uint num_badges = badge_obj.balanceOf(this);
55         
56         if (highest_bid > 0){
57             badge_obj.transfer(highest_bidder, num_badges);
58         } else {
59             badge_obj.transfer(beneficiary, num_badges);
60         }
61     }
62     
63     // For auction creator to retrieve ETH 1 day after auction ends
64     function end_auction() {
65         require(msg.sender == beneficiary);
66         require(now > (expiry_date + 1 days));
67         selfdestruct(beneficiary);
68     }
69 }
70 
71 contract Badge{
72 function Badge();
73 function approve(address _spender,uint256 _value)returns(bool success);
74 function setOwner(address _owner)returns(bool success);
75 function totalSupply()constant returns(uint256 );
76 function transferFrom(address _from,address _to,uint256 _value)returns(bool success);
77 function subtractSafely(uint256 a,uint256 b)returns(uint256 );
78 function mint(address _owner,uint256 _amount)returns(bool success);
79 function safeToAdd(uint256 a,uint256 b)returns(bool );
80 function balanceOf(address _owner)constant returns(uint256 balance);
81 function owner()constant returns(address );
82 function transfer(address _to,uint256 _value)returns(bool success);
83 function addSafely(uint256 a,uint256 b)returns(uint256 result);
84 function locked()constant returns(bool );
85 function allowance(address _owner,address _spender)constant returns(uint256 remaining);
86 function safeToSubtract(uint256 a,uint256 b)returns(bool );
87 }