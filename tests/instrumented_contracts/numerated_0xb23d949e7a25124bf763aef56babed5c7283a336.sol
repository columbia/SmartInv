1 pragma solidity ^0.4.11;
2 
3 contract BigFish {
4   uint private auctionEndTime = now;
5   address private highestBidder;
6   uint private highestBid = 0;
7 
8   address private previousHighestBidder;
9   uint previousPoolValue = 0;
10 
11   bool noActiveGame = true;
12 
13   mapping(address => uint) users;
14 
15   address owner;
16 
17   uint constant ownerPercentage = 20;
18   uint constant winnerPercentage = 100 - ownerPercentage;
19 
20   modifier onlyOwner(){
21     require(msg.sender == owner);
22     _;
23   }
24 
25   constructor()
26     public
27   {
28     owner = msg.sender;
29   }
30 
31   function auctionStart(uint _hours)
32     public
33     payable
34     onlyOwner
35   {
36     require(hasEnded());
37     require(noActiveGame);
38     auctionEndTime = now + (_hours * 1 hours);
39     noActiveGame = false;
40   }
41 
42   function auctionEnd()
43     public
44     onlyOwner
45   {
46     require(hasEnded());
47     require(!noActiveGame);
48 
49     previousPoolValue = getPoolValue();
50 
51     if (highestBid == 0) {
52       owner.transfer(getPoolValue());
53     } else {
54       previousHighestBidder = highestBidder;
55       highestBid = 0;
56       highestBidder.transfer(getPoolValue() * winnerPercentage / 100);
57       owner.transfer(getPoolValue());
58     }
59 
60     noActiveGame = true;
61   }
62 
63   function bid()
64     public
65     payable
66   {
67     require(msg.value > highestBid);
68     require(!hasEnded());
69     highestBidder = msg.sender;
70     highestBid = msg.value;
71   }
72 
73   function hasEnded()
74     public
75     view
76     returns (bool)
77   {
78     return now >= auctionEndTime;
79   }
80 
81   function getOwner()
82     public
83     view
84     returns (address)
85   {
86     return owner;
87   }
88 
89   function getHighestBid()
90     public
91     view
92     returns (uint)
93   {
94     return highestBid;
95   }
96 
97   function getBidder()
98     public
99     view
100     returns (address)
101   {
102     return highestBidder;
103   }
104 
105   function getPoolValue()
106     public
107     view
108     returns (uint)
109   {
110     return address(this).balance;
111   }
112 
113   function getPreviousBidder()
114     public
115     view
116     returns (address)
117   {
118     return previousHighestBidder;
119   }
120 
121   function getPreviousPoolValue()
122     public
123     view
124     returns (uint)
125   {
126     return previousPoolValue;
127   }
128 }