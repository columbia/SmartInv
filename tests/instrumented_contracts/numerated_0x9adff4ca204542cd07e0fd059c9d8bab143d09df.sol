1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract ToyCo{
6     //uint256 STORES_PER_CENTER_PER_SECOND=1;
7     uint256 public STORES_TO_UPGRADE_1CENTER=86400;
8     uint256 PSN=10000;
9     uint256 PSNH=5000;
10     bool public initialized=false;
11     address public ceoAddress;
12     mapping (address => uint256) public upgradingCenter;
13     mapping (address => uint256) public claimedStores;
14     mapping (address => uint256) public lastUpgrade;
15     mapping (address => address) public referrals;
16     uint256 public marketStores;
17     function ToyCo() public{
18         ceoAddress=msg.sender;
19     }
20     function upgradeStores(address ref) public{
21         require(initialized);
22         if(referrals[msg.sender]==0 && ref!=msg.sender){
23             referrals[msg.sender]=ref;
24         }
25         uint256 storesUsed=getMyStores();
26         uint256 newCenter=SafeMath.div(storesUsed,STORES_TO_UPGRADE_1CENTER);
27         upgradingCenter[msg.sender]=SafeMath.add(upgradingCenter[msg.sender],newCenter);
28         claimedStores[msg.sender]=0;
29         lastUpgrade[msg.sender]=now;
30 
31         //send referral stores
32         claimedStores[referrals[msg.sender]]=SafeMath.add(claimedStores[referrals[msg.sender]],SafeMath.div(storesUsed,10));
33 
34         //boost market to nerf center hoarding
35         marketStores=SafeMath.add(marketStores,SafeMath.div(storesUsed,10));
36     }
37     function sellStores() public{
38         require(initialized);
39         uint256 hasStores=getMyStores();
40         uint256 storeValue=calculateStoreSell(hasStores);
41         uint256 fee=devFee(storeValue);
42         claimedStores[msg.sender]=0;
43         lastUpgrade[msg.sender]=now;
44         marketStores=SafeMath.add(marketStores,hasStores);
45         ceoAddress.transfer(fee);
46         msg.sender.transfer(SafeMath.sub(storeValue,fee));
47         upgradingCenter[msg.sender]=0;
48     }
49     function buyStores() public payable{
50         require(initialized);
51         uint256 storesBought=calculateStoreBuy(msg.value,SafeMath.sub(this.balance,msg.value));
52         storesBought=SafeMath.sub(storesBought,devFee(storesBought));
53         ceoAddress.transfer(devFee(msg.value));
54         claimedStores[msg.sender]=SafeMath.add(claimedStores[msg.sender],storesBought);
55     }
56     //magic trade balancing algorithm
57     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
58         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
59         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
60     }
61     function calculateStoreSell(uint256 stores) public view returns(uint256){
62         return calculateTrade(stores,marketStores,this.balance);
63     }
64     function calculateStoreBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
65         return calculateTrade(eth,contractBalance,marketStores);
66     }
67     function calculateStoreBuySimple(uint256 eth) public view returns(uint256){
68         return calculateStoreBuy(eth,this.balance);
69     }
70     function devFee(uint256 amount) public view returns(uint256){
71         return SafeMath.div(SafeMath.mul(amount,4),100);
72     }
73     function seedMarket(uint256 stores) public payable{
74         require(marketStores==0);
75         initialized=true;
76         marketStores=stores;
77     }
78     function getBalance() public view returns(uint256){
79         return this.balance;
80     }
81     function getMyCenter() public view returns(uint256){
82         return upgradingCenter[msg.sender];
83     }
84     function getMyStores() public view returns(uint256){
85         return SafeMath.add(claimedStores[msg.sender],getStoresSinceLastUpgrade(msg.sender));
86     }
87     function getStoresSinceLastUpgrade(address adr) public view returns(uint256){
88         uint256 secondsPassed=min(STORES_TO_UPGRADE_1CENTER,SafeMath.sub(now,lastUpgrade[adr]));
89         return SafeMath.mul(secondsPassed,upgradingCenter[adr]);
90     }
91     function min(uint256 a, uint256 b) private pure returns (uint256) {
92         return a < b ? a : b;
93     }
94 }
95 
96 library SafeMath {
97 
98   /**
99   * @dev Multiplies two numbers, throws on overflow.
100   */
101   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102     if (a == 0) {
103       return 0;
104     }
105     uint256 c = a * b;
106     assert(c / a == b);
107     return c;
108   }
109 
110   /**
111   * @dev Integer division of two numbers, truncating the quotient.
112   */
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114     // assert(b > 0); // Solidity automatically throws when dividing by 0
115     uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117     return c;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   /**
129   * @dev Adds two numbers, throws on overflow.
130   */
131   function add(uint256 a, uint256 b) internal pure returns (uint256) {
132     uint256 c = a + b;
133     assert(c >= a);
134     return c;
135   }
136 }