1 pragma solidity ^0.4.25;
2 
3 contract test {
4 
5     struct BidInfo {
6         address user;
7         uint256 amount;
8         bool processed;
9     }
10 
11     struct Tranche {
12         uint256 tokens;
13         uint256 total;
14         mapping(address => uint256) user_total;
15         mapping(address => uint256) user_tokens;
16 
17         uint256 start;
18         uint256 end;
19         BidInfo[] bids;
20 
21         uint256 price;
22         bool configured;
23         bool settled;
24     }
25 
26     mapping (uint256 => Tranche) public trancheInfo;
27     address public owner;
28 
29     //event LogBid(address who,uint256 amount);
30     //event LogSettleTranche(uint256 price);
31     //event LogPayout(uint256 trancheId, uint256 bidId, address user,uint256 amount, uint256 tokenspaid);
32 
33     event LogROWTranchePublished(
34         uint256 trancheId,
35         uint256 trancheStartTime,
36         uint256 trancheEndTime,
37         uint256 tokensInTranche,
38         uint256 reservePrice
39     );  
40 
41     address public auth;
42     
43     function configureAuth(address _addr) external {
44         auth=_addr;
45     }
46 
47     function ConfigureTranche(
48         uint256 _tranche,
49         uint256 _tranche_start_time,
50         uint256 _tranche_end_time,
51         uint256 _tokens_in_tranche,
52         uint256 _reserve_price
53     )
54         external
55     {
56         require(msg.sender==auth);
57         Tranche storage t = trancheInfo[_tranche];
58         require(t.configured == false);
59         t.configured = true;
60         
61         require(now<_tranche_start_time);
62         t.start=_tranche_start_time;
63         require(_tranche_end_time>_tranche_start_time);
64         t.end=_tranche_end_time;
65         t.tokens = _tokens_in_tranche*(10**18);
66         emit LogROWTranchePublished(_tranche,_tranche_start_time,_tranche_end_time,_tokens_in_tranche,_reserve_price); 
67     }
68 
69     function Bid(uint256 tranche_id, address user, uint256 amount) external {
70         Tranche storage t = trancheInfo[tranche_id];
71         require(t.configured);
72         require((now>t.start) && (now<t.end));
73         require(amount>0);
74         t.total+=amount;
75         t.user_total[user]+=amount;
76         BidInfo memory b = BidInfo(user,amount,false);
77         t.bids.push(b);
78         //emit LogBid(user,amount);
79     }
80 
81     function SettleTranche(uint256 tranche_id) external {
82         
83         Tranche storage t = trancheInfo[tranche_id];
84         require(t.configured);
85         require(now > t.end);
86         require(!t.settled);
87         t.settled=true;
88         t.price = t.tokens/t.total;
89         //emit LogSettleTranche(t.price);
90     }
91 
92     function settleBid(uint256 tranche_id, uint256 bid_id) external {
93         Tranche storage t = trancheInfo[tranche_id];
94         require(t.settled);
95         BidInfo storage b = t.bids[bid_id];
96         require(b.processed==false);
97         
98         b.processed=true;
99         t.user_tokens[b.user] += (b.amount*t.price);
100         t.tokens -= (b.amount*t.price);
101 
102         //emit LogPayout(tranche_id,bid_id,b.user,b.amount,b.amount*t.price);
103     }
104 
105     function getBidInfo(uint256 tranche_id, uint256 bid_id) external view returns (address,uint256,bool) {
106         return (trancheInfo[tranche_id].bids[bid_id].user,trancheInfo[tranche_id].bids[bid_id].amount,trancheInfo[tranche_id].bids[bid_id].processed);
107     }
108 
109     function getNumberBids(uint256 tranche_id) external view returns (uint256) {
110         return trancheInfo[tranche_id].bids.length;
111     }
112     
113     function getUserInfo(uint256 tranche_id) external view returns (uint256,uint256) {
114         return (trancheInfo[tranche_id].user_tokens[msg.sender],trancheInfo[tranche_id].user_total[msg.sender]);
115     }
116 
117 }