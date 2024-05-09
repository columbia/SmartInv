1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract BountyHunter {
51 
52   function() public payable { }
53 
54   string public constant NAME = "BountyHunter";
55   string public constant SYMBOL = "BountyHunter";
56   address ceoAddress = 0xc10A6AedE9564efcDC5E842772313f0669D79497;
57   address hunter;
58   address hunted;
59 
60   struct ContractData {
61     address user;
62     uint256 hunterPrice;
63     uint256 last_transaction;
64    
65   }
66 
67   ContractData[8] data;
68   
69 
70   
71   function BountyHunter() public {
72     for (uint i = 0; i < 8; i++) {
73      
74       data[i].hunterPrice = 5000000000000000;
75       data[i].user = msg.sender;
76       data[i].last_transaction = block.timestamp;
77     }
78   }
79 
80 
81   function payoutOnPurchase(address previousHunterOwner, uint256 hunterPrice) private {
82     previousHunterOwner.transfer(hunterPrice);
83   }
84   function transactionFee(address, uint256 hunterPrice) private {
85     ceoAddress.transfer(hunterPrice);
86   }
87   function createBounty(uint256 hunterPrice) private {
88     this.transfer(hunterPrice);
89   }
90 
91 
92   
93   function hireBountyHunter(uint bountyHunterID) public payable returns (uint, uint) {
94     require(bountyHunterID >= 0 && bountyHunterID <= 8);
95     
96     if ( data[bountyHunterID].hunterPrice == 5000000000000000 ) {
97       data[bountyHunterID].hunterPrice = 10000000000000000;
98     }
99     else { 
100       data[bountyHunterID].hunterPrice = data[bountyHunterID].hunterPrice * 2;
101     }
102     
103     require(msg.value >= data[bountyHunterID].hunterPrice * uint256(1));
104 
105     createBounty((data[bountyHunterID].hunterPrice / 10) * (3));
106     
107     payoutOnPurchase(data[bountyHunterID].user,  (data[bountyHunterID].hunterPrice / 10) * (6));
108     
109     transactionFee(ceoAddress, (data[bountyHunterID].hunterPrice / 10) * (1));
110 
111     
112     data[bountyHunterID].user = msg.sender;
113     
114     playerKiller();
115     
116     return (bountyHunterID, data[bountyHunterID].hunterPrice);
117 
118   }
119 
120 
121   function getUsers() public view returns (address[], uint256[]) {
122     address[] memory users = new address[](8);
123     uint256[] memory hunterPrices =  new uint256[](8);
124     for (uint i=0; i<8; i++) {
125       if (data[i].user != ceoAddress){
126         users[i] = (data[i].user);
127       }
128       else{
129         users[i] = address(0);
130       }
131       
132       hunterPrices[i] = (data[i].hunterPrice);
133     }
134     return (users,hunterPrices);
135   }
136 
137   function rand(uint max) public returns (uint256){
138         
139     uint256 lastBlockNumber = block.number - 1;
140     uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
141 
142     uint256 FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;
143     return uint256(uint256( (hashVal) / FACTOR) + 1) % max;
144   }
145   
146   
147   function playerKiller() private {
148     uint256 killshot = rand(31);
149 
150     if( (killshot < 8) &&  (msg.sender != data[killshot].user) ){
151       hunter = msg.sender;
152       if( ceoAddress != data[killshot].user){
153         hunted = data[killshot].user;
154       }
155       else{
156         hunted = address(0);
157       }
158       
159       data[killshot].hunterPrice  = 5000000000000000;
160       data[killshot].user  = 5000000000000000;
161 
162       msg.sender.transfer((this.balance / 10) * (9));
163       ceoAddress.transfer((this.balance / 10) * (1));
164 
165     }
166     
167   }
168 
169   function killFeed() public view returns(address, address){
170     return(hunter, hunted);
171   }
172   
173 }