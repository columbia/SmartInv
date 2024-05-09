1 pragma solidity ^0.4.11;
2 
3 contract dapEscrow{
4     
5     struct Bid{
6         bytes32 name;
7         address oracle;
8         address seller;
9         address buyer;
10         uint price;
11         uint timeout;
12         dealStatus status;
13         uint fee;
14         bool isLimited;
15     }
16     
17     enum dealStatus{ unPaid, Pending, Closed, Rejected, Refund }
18     
19     mapping (address => Bid[]) public bids;
20     mapping (address => uint) public pendingWithdrawals;
21     
22     event amountRecieved(
23         address seller,
24         uint bidId
25     );
26     
27     event bidClosed(
28         address seller,
29         uint bidId
30         );
31         
32     event bidCreated(
33         address seller,
34         bytes32 name,
35         uint bidId
36         );
37         
38     event refundDone(
39         address seller,
40         uint bidId
41         );
42         
43     event withdrawDone(
44         address person,
45         uint amount
46         );
47     
48     event bidRejected(
49         address seller,
50         uint bidId
51         );
52         
53     function getBidIndex(address seller, bytes32 name) public constant returns (uint){
54         for (uint8 i=0;i<bids[seller].length;i++){
55             if (bids[seller][i].name == name){
56                 return i;
57             }
58         }
59     }
60     
61     function getBidsNum (address seller) public constant returns (uint bidsNum) {
62         return bids[seller].length;
63     }
64     
65     function sendAmount (address seller, uint bidId) external payable{
66         Bid storage a = bids[seller][bidId];
67         require(msg.value == a.price && a.status == dealStatus.unPaid);
68         if (a.isLimited == true){
69             require(a.timeout > block.number);
70         }
71         a.status = dealStatus.Pending;
72         amountRecieved(seller, bidId);
73     }
74     
75     function createBid (bytes32 name, address seller, address oracle, address buyer, uint price, uint timeout, uint fee) external{
76         require(name.length != 0 && price !=0);
77         bool limited = true;
78         if (timeout == 0){
79             limited = false;
80         }
81         bids[seller].push(Bid({
82             name: name, 
83             oracle: oracle, 
84             seller: seller, 
85             buyer: buyer,
86             price: price,
87             timeout: block.number+timeout,
88             status: dealStatus.unPaid,
89             fee: fee,
90             isLimited: limited
91         }));
92         uint bidId = bids[seller].length-1;
93         bidCreated(seller, name, bidId);
94     }
95     
96     function closeBid(address seller, uint bidId) external returns (bool){
97         Bid storage bid = bids[seller][bidId];
98         if (bid.isLimited == true){
99             require(bid.timeout > block.number);
100         }
101         require(msg.sender == bid.oracle && bid.status == dealStatus.Pending);
102         bid.status = dealStatus.Closed;
103         pendingWithdrawals[bid.seller]+=bid.price-bid.fee;
104         pendingWithdrawals[bid.oracle]+=bid.fee;
105         withdraw(bid.seller);
106         withdraw(bid.oracle);
107         bidClosed(seller, bidId);
108         return true;
109     }
110     
111     function refund(address seller, uint bidId) external returns (bool){
112         require(bids[seller][bidId].buyer == msg.sender && bids[seller][bidId].isLimited == true && bids[seller][bidId].timeout < block.number && bids[seller][bidId].status == dealStatus.Pending);
113         Bid storage a = bids[seller][bidId];
114         a.status = dealStatus.Refund;
115         pendingWithdrawals[a.buyer] = a.price;
116         withdraw(a.buyer);
117         refundDone(seller,bidId);
118         return true;
119     }
120     function rejectBid(address seller, uint bidId) external returns (bool){
121         if (bids[seller][bidId].isLimited == true){
122             require(bids[seller][bidId].timeout > block.number);
123         }
124         require(msg.sender == bids[seller][bidId].oracle && bids[seller][bidId].status == dealStatus.Pending);
125         Bid storage bid = bids[seller][bidId];
126         bid.status = dealStatus.Rejected;
127         pendingWithdrawals[bid.oracle] = bid.fee;
128         pendingWithdrawals[bid.buyer] = bid.price-bid.fee;
129         withdraw(bid.buyer);
130         withdraw(bid.oracle);
131         bidRejected(seller, bidId);
132         return true;
133     }
134     
135     function withdraw(address person) private{
136         uint amount = pendingWithdrawals[person];
137         pendingWithdrawals[person] = 0;
138         person.transfer(amount);
139         withdrawDone(person, amount);
140     }
141     
142 }