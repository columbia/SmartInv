1 pragma solidity ^0.4.18; 
2 
3 
4 contract CEO_Trader{
5     address public ceoAddress;
6     address public dev1 = 0x3b6B7E115EF186Aa4151651468e34f0E92084852;
7     address public hotPotatoHolder;
8     address public lastHotPotatoHolder;
9     uint256 public lastBidTime;
10     uint256 public contestStartTime;
11     uint256 public lastPot;
12     mapping (address => uint256) public cantBidUntil;
13     Potato[] public potatoes;
14     
15     uint256 public TIME_TO_COOK=6 hours; 
16     uint256 public NUM_POTATOES=9;
17     uint256 public START_PRICE=0.005 ether;
18     uint256 public CONTEST_INTERVAL=12 hours;
19     
20     /*** DATATYPES ***/
21     struct Potato {
22         address owner;
23         uint256 price;
24     }
25     
26      /// Access modifier for contract owner only functionality
27      modifier onlyContractOwner() {
28          require(msg.sender == ceoAddress);
29         _;
30      }
31     
32     /*** CONSTRUCTOR ***/
33     function CEO_Trader() public{
34         ceoAddress=msg.sender;
35         hotPotatoHolder=0;
36         contestStartTime=1520799754;//sunday march 11
37         for(uint i = 0; i<NUM_POTATOES; i++){
38             Potato memory newpotato=Potato({owner:address(this),price: START_PRICE});
39             potatoes.push(newpotato);
40         }
41     }
42     
43     /*** PUBLIC FUNCTIONS ***/
44     function buyPotato(uint256 index) public payable{
45         require(block.timestamp>contestStartTime);
46         if(_endContestIfNeeded()){ 
47 
48         }
49         else{
50             Potato storage potato=potatoes[index];
51             require(msg.value >= potato.price);
52             //allow calling transfer() on these addresses without risking re-entrancy attacks
53             require(msg.sender != potato.owner);
54             require(msg.sender != ceoAddress);
55             uint256 sellingPrice=potato.price;
56             uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
57             uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 80), 100));
58             //20 percent remaining in the contract goes to the pot
59             //if the owner is the contract, this is the first purchase, and payment should go to the pot
60             if(potato.owner!=address(this)){
61                 potato.owner.transfer(payment);
62             }
63             potato.price= SafeMath.div(SafeMath.mul(sellingPrice, 140), 80);
64             potato.owner=msg.sender;//transfer ownership
65             hotPotatoHolder=msg.sender;//becomes holder with potential to win the pot
66             lastBidTime=block.timestamp;
67             msg.sender.transfer(purchaseExcess);//returns excess eth
68         }
69     }
70     
71     function getBalance() public view returns(uint256 value){
72         return this.balance;
73     }
74     function timePassed() public view returns(uint256 time){
75         if(lastBidTime==0){
76             return 0;
77         }
78         return SafeMath.sub(block.timestamp,lastBidTime);
79     }
80     function timeLeftToContestStart() public view returns(uint256 time){
81         if(block.timestamp>contestStartTime){
82             return 0;
83         }
84         return SafeMath.sub(contestStartTime,block.timestamp);
85     }
86     function timeLeftToCook() public view returns(uint256 time){
87         return SafeMath.sub(TIME_TO_COOK,timePassed());
88     }
89     function contestOver() public view returns(bool){
90         return _endContestIfNeeded();
91     }
92     function payout() public onlyContractOwner {
93     ceoAddress.transfer(this.balance);
94     }
95     
96     /*** PRIVATE FUNCTIONS ***/
97     function _endContestIfNeeded() private returns(bool){
98         if(timePassed()>=TIME_TO_COOK){
99             //contest over, refund anything paid
100             uint256 devFee = uint256(SafeMath.div(SafeMath.mul(this.balance, 10), 100));
101             ceoAddress.transfer(devFee); //To pump winning stock
102             dev1.transfer(devFee); //To pump winning stock
103             uint256 faucetFee = uint256(SafeMath.div(SafeMath.mul(this.balance, 1), 100));
104             msg.sender.transfer(faucetFee); 
105             msg.sender.transfer(msg.value); 
106             lastPot=this.balance;
107             lastHotPotatoHolder=hotPotatoHolder;
108             uint256 potRevard = uint256(SafeMath.div(SafeMath.mul(this.balance, 90), 100));
109             hotPotatoHolder.transfer(potRevard);
110             hotPotatoHolder=0;
111             lastBidTime=0;
112             _resetPotatoes();
113             _setNewStartTime();
114             return true;
115         }
116         return false;
117     }
118     function _resetPotatoes() private{
119         for(uint i = 0; i<NUM_POTATOES; i++){
120             Potato memory newpotato=Potato({owner:address(this),price: START_PRICE});
121             potatoes[i]=newpotato;
122         }
123     }
124     function _setNewStartTime() private{
125         uint256 start=contestStartTime;
126         while(start<block.timestamp){
127             start=SafeMath.add(start,CONTEST_INTERVAL);
128         }
129         contestStartTime=start;
130     }
131 
132 }
133 library SafeMath {
134 
135   /**
136   * @dev Multiplies two numbers, throws on overflow.
137   */
138   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139     if (a == 0) {
140       return 0;
141     }
142     uint256 c = a * b;
143     assert(c / a == b);
144     return c;
145   }
146 
147   /**
148   * @dev Integer division of two numbers, truncating the quotient.
149   */
150   function div(uint256 a, uint256 b) internal pure returns (uint256) {
151     // assert(b > 0); // Solidity automatically throws when dividing by 0
152     uint256 c = a / b;
153     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154     return c;
155   }
156 
157   /**
158   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
159   */
160   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161     assert(b <= a);
162     return a - b;
163   }
164 
165   /**
166   * @dev Adds two numbers, throws on overflow.
167   */
168   function add(uint256 a, uint256 b) internal pure returns (uint256) {
169     uint256 c = a + b;
170     assert(c >= a);
171     return c;
172   }
173 }