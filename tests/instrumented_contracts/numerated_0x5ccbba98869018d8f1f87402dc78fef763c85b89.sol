1 pragma solidity ^0.4.9;
2 
3 contract SaleOfChametz {
4     struct Deal {
5         address seller;
6     }
7     
8     Deal[] public deals;
9     uint   public nextDealIndex;
10     
11     mapping(address=>uint) public sellerNumOpenDeals;
12     mapping(address=>uint) public buyerNumDeals;
13     
14     
15     event Sell( address indexed seller, uint timestamp );
16     event Buy( address indexed buyer, address indexed seller, uint timestamp );
17     event ReturnChametz( address indexed buyer, uint payment, uint timestamp );
18     event CancelSell( address indexed seller, uint payment, uint timestamp );
19     
20     
21     uint constant public passoverStartTime = 1491840000;
22     uint constant public passoverEndTime = 1492401600;                                        
23     
24     uint constant public downPayment = 30 finney;
25     uint constant public buyerBonus = 30 finney;
26     
27     function SaleOfChametz() {}
28     
29     function numChametzForSale() constant returns(uint) {
30         return deals.length - nextDealIndex;
31     }
32     
33     function sell() payable {
34         if( now >= passoverStartTime ) throw; // too late to sell
35         if( msg.value != buyerBonus ) throw;
36         
37         Deal memory deal;
38         deal.seller = msg.sender;
39         
40         sellerNumOpenDeals[ msg.sender ]++;
41         
42         deals.push(deal);
43         
44         Sell( msg.sender, now );
45     }
46     
47     function buy() payable {
48         if( now >= passoverStartTime ) throw; // too late to buy
49         if( msg.value != downPayment ) throw;
50         if( deals.length <= nextDealIndex ) throw; // no deals
51         
52         Deal memory deal = deals[nextDealIndex];
53         if( sellerNumOpenDeals[ deal.seller ] > 0 ) {
54             sellerNumOpenDeals[ deal.seller ]--;
55         }
56         
57         buyerNumDeals[msg.sender]++;
58         nextDealIndex++;
59         
60         Buy( msg.sender, deal.seller, now );
61     }
62     
63     function returnChametz() {
64         if( now <= passoverEndTime ) throw; // too early to return
65         if( buyerNumDeals[msg.sender] == 0 ) throw; // never bought chametz
66         uint payment = buyerNumDeals[msg.sender] * (downPayment + buyerBonus);
67         buyerNumDeals[msg.sender] = 0;
68         if( ! msg.sender.send( payment ) ) throw;
69         
70         ReturnChametz( msg.sender, payment, now );
71     }
72     
73     function cancelSell() {
74        if( now <= passoverStartTime ) throw; // too early to cancel
75      
76         if( sellerNumOpenDeals[ msg.sender ] == 0 ) throw; // no deals to cancel
77         uint payment = sellerNumOpenDeals[ msg.sender ] * buyerBonus;
78         sellerNumOpenDeals[ msg.sender ] = 0;
79         if( ! msg.sender.send( payment ) ) throw;
80         
81         CancelSell( msg.sender, payment, now );
82     }
83     
84 }