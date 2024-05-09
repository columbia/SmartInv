1 pragma solidity ^0.4.11;
2 
3 library SafeMath
4 {
5     uint256 constant public MAX_UINT256 =
6     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
7 
8     function GET_MAX_UINT256() pure internal returns(uint256){
9         return MAX_UINT256;
10     }
11 
12     function mul(uint a, uint b) internal returns(uint){
13         uint c = a * b;
14         assertSafe(a == 0 || c / a == b);
15         return c;
16     }
17 
18     function div(uint a, uint b) pure internal returns(uint){
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint a, uint b) internal returns(uint){
26         assertSafe(b <= a);
27         return a - b;
28     }
29 
30     function add(uint a, uint b) internal returns(uint){
31         uint c = a + b;
32         assertSafe(c >= a);
33         return c;
34     }
35 
36     function max64(uint64 a, uint64 b) internal view returns(uint64){
37         return a >= b ? a : b;
38     }
39 
40     function min64(uint64 a, uint64 b) internal view returns(uint64){
41         return a < b ? a : b;
42     }
43 
44     function max256(uint256 a, uint256 b) internal view returns(uint256){
45         return a >= b ? a : b;
46     }
47 
48     function min256(uint256 a, uint256 b) internal view returns(uint256){
49         return a < b ? a : b;
50     }
51 
52     function assertSafe(bool assertion) internal {
53         if (!assertion) {
54             revert();
55         }
56     }
57 }
58 
59 contract Auctioneer {
60     function createAuctionContract() payable public returns(address) {
61         AuctionContract auctionContract = (new AuctionContract).value(msg.value)(3000, this);//TODO CHANGE 30 -->> 3000
62 
63         return auctionContract;
64     }
65 }
66 
67 contract AuctionContract {
68     using SafeMath for uint;
69 
70     event BetPlacedEvent(address bidderAddress, uint amount);
71     event RefundEvent(address bidderAddress, uint amount);
72     event CreateAuctionContractEvent(address bidderAddress, uint amount);
73 
74     uint public auctionSlideSize = 30;
75     uint public auctionCloseBlock;
76     uint public closeAuctionAfterNBlocks;
77     uint public bettingStep;
78     mapping (address => uint) public bettingMap;
79     address public firstBidder;
80     address public secondBidder;
81     address public winner;
82     uint public biggestBet;
83     uint public prize;
84     address public firstBetContract;
85     address public secondBetContract;
86     uint public minimalPrize = 10000000000000000;//0.01 ETH
87     uint public minimaBetStep = 10000000000000000;//0.01 ETH
88     address public auctioneerAddress;
89     bool public isActive;
90 
91     constructor (uint _closeAuctionAfterNBlocks, address _auctioneerAddress) payable public{
92         assert(msg.value >= minimalPrize);
93         prize = msg.value;
94         auctioneerAddress = _auctioneerAddress;
95         closeAuctionAfterNBlocks = _closeAuctionAfterNBlocks;
96         auctionCloseBlock = block.number.add(_closeAuctionAfterNBlocks);
97         bettingStep = 0;
98         biggestBet = 0;
99         isActive = true;
100 
101         emit CreateAuctionContractEvent(this, prize);
102     }
103 
104     function() public payable {
105         assert(auctionCloseBlock >= block.number);
106         uint value = bettingMap[msg.sender];
107         value = value.add(msg.value);
108         assert(msg.value >= minimaBetStep);
109         assert(biggestBet < value);
110 
111         bettingMap[msg.sender] = value;
112         biggestBet = value;
113 
114         if (msg.sender != firstBidder) {
115             secondBidder = firstBidder;
116         }
117         
118         firstBidder = msg.sender;
119 
120         bettingStep = bettingStep.add(1);
121         auctionCloseBlock = auctionCloseBlock.add(auctionSlideSize);
122         winner = msg.sender;
123 
124         emit BetPlacedEvent(msg.sender, msg.value);
125     }
126 
127     function askForRefund() public {
128         assert(firstBidder != msg.sender);
129         assert(secondBidder != msg.sender);
130         uint value = bettingMap[msg.sender];
131         assert(value != 0);
132 
133         msg.sender.transfer(value);
134         bettingMap[msg.sender] = 0;
135 
136         emit RefundEvent(msg.sender, value);
137     }
138 
139     function closeAuction() public {
140         assert(isActive);
141         assert(auctionCloseBlock < block.number);
142         assert(msg.sender == winner);
143         msg.sender.transfer(prize);
144         Auctioneer auctioneer = Auctioneer(auctioneerAddress);
145 
146         if(firstBidder != address(0)) {
147             uint firstValue = bettingMap[firstBidder];
148             if (firstValue >= minimalPrize) {
149                 address firstContract = auctioneer.createAuctionContract.value(firstValue)();
150                 firstBetContract = firstContract;
151             }
152         }
153 
154         if(secondBidder != address(0)) {
155             uint secondValue = bettingMap[secondBidder];
156             if (secondValue >= minimalPrize) {
157                 address secondContract = auctioneer.createAuctionContract.value(secondValue)();
158                 secondBetContract = secondContract;
159             }
160         }
161         
162         isActive = false;
163     }
164 }