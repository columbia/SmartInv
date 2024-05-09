1 pragma solidity ^0.4.11;
2 
3 contract AuctionItem {
4     
5     string public auctionName;
6     address public owner; 
7     bool auctionEnded = false;
8     
9     event NewHighestBid(
10         address newHighBidder,
11         uint newHighBid,
12         string squak
13     );
14     
15     uint public currentHighestBid = 0;
16     address public highBidder; 
17     string public squak;
18 
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23     modifier higherBid {
24         require(msg.value > currentHighestBid);
25         _;
26     }
27     
28     modifier auctionNotOver {
29         require(auctionEnded == false);
30         _;
31     }
32     
33     function AuctionItem(string name, uint startingBid) {
34         auctionName = name; 
35         owner = msg.sender;
36         currentHighestBid = startingBid;
37     }
38     
39     //allow people using MetaMask/Cipher et. al. to specifically set a taunting message ;)
40     function bid(string _squak) payable higherBid auctionNotOver {
41         highBidder.transfer(currentHighestBid);
42         currentHighestBid = msg.value;
43         highBidder = msg.sender;
44         squak = _squak;
45         NewHighestBid(msg.sender, msg.value, _squak);
46 
47         }
48     //allow people with basic wallets to send a bid (QR scan etc.), but no squaking for them 
49     function() payable higherBid auctionNotOver{
50         highBidder.transfer(currentHighestBid);
51         currentHighestBid = msg.value;
52         highBidder = msg.sender;
53         NewHighestBid(msg.sender, msg.value, '');
54         
55     }
56     //The owner should be able to end the auction
57     function endAuction() onlyOwner{
58         selfdestruct(owner);
59         auctionEnded = true;
60     }
61 
62     
63 }