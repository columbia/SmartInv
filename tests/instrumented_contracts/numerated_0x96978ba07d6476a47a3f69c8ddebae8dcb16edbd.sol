1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract PotPotato{
6     address public ceoAddress;
7     address public hotPotatoHolder;
8     address public lastHotPotatoHolder;
9     uint256 public lastBidTime;
10     uint256 public contestStartTime;
11     uint256 public lastPot;
12 
13     Potato[] public potatoes;
14     
15     uint256 public BASE_TIME_TO_COOK=30 minutes;//60 seconds;
16     uint256 public TIME_MULTIPLIER=5 minutes;//5 seconds;//time per index of potato
17     uint256 public TIME_TO_COOK=BASE_TIME_TO_COOK; //this changes
18     uint256 public NUM_POTATOES=12;
19     uint256 public START_PRICE=0.001 ether;
20     uint256 public CONTEST_INTERVAL=1 weeks;//4 minutes;//1 week
21     
22     /*** DATATYPES ***/
23     struct Potato {
24         address owner;
25         uint256 price;
26     }
27     
28     /*** CONSTRUCTOR ***/
29     function PotPotato() public{
30         ceoAddress=msg.sender;
31         hotPotatoHolder=0;
32         contestStartTime=1520799754;//sunday march 11
33         for(uint i = 0; i<NUM_POTATOES; i++){
34             Potato memory newpotato=Potato({owner:address(this),price: START_PRICE});
35             potatoes.push(newpotato);
36         }
37     }
38     
39     /*** PUBLIC FUNCTIONS ***/
40     function buyPotato(uint256 index) public payable{
41         require(block.timestamp>contestStartTime);
42         if(_endContestIfNeeded()){ 
43 
44         }
45         else{
46             Potato storage potato=potatoes[index];
47             require(msg.value >= potato.price);
48             //allow calling transfer() on these addresses without risking re-entrancy attacks
49             require(msg.sender != potato.owner);
50             require(msg.sender != ceoAddress);
51             uint256 sellingPrice=potato.price;
52             uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
53             uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 76), 100));
54             uint256 devFee= uint256(SafeMath.div(SafeMath.mul(sellingPrice, 4), 100));
55             //20 percent remaining in the contract goes to the pot
56             //if the owner is the contract, this is the first purchase, and payment should go to the pot
57             if(potato.owner!=address(this)){
58                 potato.owner.transfer(payment);
59             }
60             ceoAddress.transfer(devFee);
61             potato.price= SafeMath.div(SafeMath.mul(sellingPrice, 150), 76);
62             potato.owner=msg.sender;//transfer ownership
63             hotPotatoHolder=msg.sender;//becomes holder with potential to win the pot
64             lastBidTime=block.timestamp;
65             TIME_TO_COOK=SafeMath.add(BASE_TIME_TO_COOK,SafeMath.mul(index,TIME_MULTIPLIER)); //pots have times to cook varying from 30-85 minutes
66             msg.sender.transfer(purchaseExcess);//returns excess eth
67         }
68     }
69     
70     function getBalance() public view returns(uint256 value){
71         return this.balance;
72     }
73     function timePassed() public view returns(uint256 time){
74         if(lastBidTime==0){
75             return 0;
76         }
77         return SafeMath.sub(block.timestamp,lastBidTime);
78     }
79     function timeLeftToContestStart() public view returns(uint256 time){
80         if(block.timestamp>contestStartTime){
81             return 0;
82         }
83         return SafeMath.sub(contestStartTime,block.timestamp);
84     }
85     function timeLeftToCook() public view returns(uint256 time){
86         return SafeMath.sub(TIME_TO_COOK,timePassed());
87     }
88     function contestOver() public view returns(bool){
89         return timePassed()>=TIME_TO_COOK;
90     }
91     
92     /*** PRIVATE FUNCTIONS ***/
93     function _endContestIfNeeded() private returns(bool){
94         if(timePassed()>=TIME_TO_COOK){
95             //contest over, refund anything paid
96             msg.sender.transfer(msg.value);
97             lastPot=this.balance;
98             lastHotPotatoHolder=hotPotatoHolder;
99             hotPotatoHolder.transfer(this.balance);
100             hotPotatoHolder=0;
101             lastBidTime=0;
102             _resetPotatoes();
103             _setNewStartTime();
104             return true;
105         }
106         return false;
107     }
108     function _resetPotatoes() private{
109         for(uint i = 0; i<NUM_POTATOES; i++){
110             Potato memory newpotato=Potato({owner:address(this),price: START_PRICE});
111             potatoes[i]=newpotato;
112         }
113     }
114     function _setNewStartTime() private{
115         uint256 start=contestStartTime;
116         while(start<block.timestamp){
117             start=SafeMath.add(start,CONTEST_INTERVAL);
118         }
119         contestStartTime=start;
120     }
121 }
122 library SafeMath {
123 
124   /**
125   * @dev Multiplies two numbers, throws on overflow.
126   */
127   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128     if (a == 0) {
129       return 0;
130     }
131     uint256 c = a * b;
132     assert(c / a == b);
133     return c;
134   }
135 
136   /**
137   * @dev Integer division of two numbers, truncating the quotient.
138   */
139   function div(uint256 a, uint256 b) internal pure returns (uint256) {
140     // assert(b > 0); // Solidity automatically throws when dividing by 0
141     uint256 c = a / b;
142     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143     return c;
144   }
145 
146   /**
147   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
148   */
149   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150     assert(b <= a);
151     return a - b;
152   }
153 
154   /**
155   * @dev Adds two numbers, throws on overflow.
156   */
157   function add(uint256 a, uint256 b) internal pure returns (uint256) {
158     uint256 c = a + b;
159     assert(c >= a);
160     return c;
161   }
162 }