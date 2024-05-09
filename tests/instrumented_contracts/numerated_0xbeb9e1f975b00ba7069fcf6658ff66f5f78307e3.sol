1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 contract ShrimpFarmer{
4     function buyEggs() public payable;
5 }
6 contract AdPotato{
7     address ceoAddress;
8     ShrimpFarmer fundsTarget;
9     Advertisement[] ads;
10     uint256 NUM_ADS=10;
11     uint256 BASE_PRICE=0.005 ether;
12     uint256 PERCENT_TAXED=30;
13     /***EVENTS***/
14     event BoughtAd(address sender, uint256 amount);
15     /*** ACCESS MODIFIERS ***/
16     modifier onlyCLevel() {
17     require(
18       msg.sender == ceoAddress
19     );
20     _;
21     }
22     /***CONSTRUCTOR***/
23     function AdPotato() public{
24         ceoAddress=msg.sender;
25         initialize(0x39dD0AC05016B2D4f82fdb3b70d011239abffA8B);
26     }
27     /*** DATATYPES ***/
28     struct Advertisement{
29         string text;
30         string url;
31         address owner;
32         uint256 startingLevel;
33         uint256 startingTime;
34         uint256 halfLife;
35     }
36     /*** PUBLIC FUNCTIONS ***/
37     function initialize(address fund) public onlyCLevel{
38         fundsTarget=ShrimpFarmer(fund);
39         for(uint i=0;i<NUM_ADS;i++){
40             ads.push(Advertisement({text:"Your Text Here",url:"",owner:ceoAddress,startingLevel:0,startingTime:now,halfLife:12 hours}));
41         }
42     }
43     function buyAd(uint256 index,string text,string url) public payable{
44         require(ads.length>index);
45         require(msg.sender==tx.origin);
46         Advertisement storage toBuy=ads[index];
47         uint256 currentLevel=getCurrentLevel(toBuy.startingLevel,toBuy.startingTime,toBuy.halfLife);
48         uint256 currentPrice=getCurrentPrice(currentLevel);
49         require(msg.value>=currentPrice);
50         uint256 purchaseExcess = SafeMath.sub(msg.value, currentPrice);
51         toBuy.text=text;
52         toBuy.url=url;
53         toBuy.startingLevel=currentLevel+1;
54         toBuy.startingTime=now;
55         fundsTarget.buyEggs.value(SafeMath.div(SafeMath.mul(currentPrice,PERCENT_TAXED),100))();//send to recipient of ad revenue
56         toBuy.owner.transfer(SafeMath.div(SafeMath.mul(currentPrice,100-PERCENT_TAXED),100));//send most of purchase price to previous owner
57         toBuy.owner=msg.sender;//change owner
58         msg.sender.transfer(purchaseExcess);
59         emit BoughtAd(msg.sender,purchaseExcess);
60     }
61     function getAdText(uint256 index)public view returns(string){
62         return ads[index].text;
63     }
64     function getAdUrl(uint256 index)public view returns(string){
65         return ads[index].url;
66     }
67     function getAdOwner(uint256 index) public view returns(address){
68         return ads[index].owner;
69     }
70     function getAdPrice(uint256 index) public view returns(uint256){
71         Advertisement ad=ads[index];
72         return getCurrentPrice(getCurrentLevel(ad.startingLevel,ad.startingTime,ad.halfLife));
73     }
74     function getCurrentPrice(uint256 currentLevel) public view returns(uint256){
75         return BASE_PRICE*2**currentLevel; //** is exponent, price doubles every level
76     }
77     function getCurrentLevel(uint256 startingLevel,uint256 startingTime,uint256 halfLife)public view returns(uint256){
78         uint256 timePassed=SafeMath.sub(now,startingTime);
79         uint256 levelsPassed=SafeMath.div(timePassed,halfLife);
80         if(startingLevel<levelsPassed){
81             return 0;
82         }
83         return SafeMath.sub(startingLevel,levelsPassed);
84     }
85     /*** PRIVATE FUNCTIONS ***/
86 }
87 
88 library SafeMath {
89 
90   /**
91   * @dev Multiplies two numbers, throws on overflow.
92   */
93   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94     if (a == 0) {
95       return 0;
96     }
97     uint256 c = a * b;
98     assert(c / a == b);
99     return c;
100   }
101 
102   /**
103   * @dev Integer division of two numbers, truncating the quotient.
104   */
105   function div(uint256 a, uint256 b) internal pure returns (uint256) {
106     // assert(b > 0); // Solidity automatically throws when dividing by 0
107     uint256 c = a / b;
108     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109     return c;
110   }
111 
112   /**
113   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
114   */
115   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116     assert(b <= a);
117     return a - b;
118   }
119 
120   /**
121   * @dev Adds two numbers, throws on overflow.
122   */
123   function add(uint256 a, uint256 b) internal pure returns (uint256) {
124     uint256 c = a + b;
125     assert(c >= a);
126     return c;
127   }
128 }