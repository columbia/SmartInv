1 pragma solidity ^0.4.18; 
2 
3 // similar as other games, with two changes:
4 // A. half of your kebabs expiry date is over when you sell them so they are thrown away
5 // B. the "free" 150 initial cost 0.001 eth (in line with the mining fee)
6 
7 // bots should have a harder time
8 
9 contract EtherKebab{
10     uint256 public KEBABER_TO_MAKE_1KEBAB=86400;//for final version should be seconds in a day
11     uint256 public STARTING_KEBAB=150;
12     uint256 PSN=10000;
13     uint256 PSNH=5000;
14     bool public initialized=false;
15     address public ceoAddress = 0xdf4703369ecE603a01e049e34e438ff74Cd96D66;
16     uint public ceoEtherBalance;
17     mapping (address => uint256) public workingKebaber;
18     mapping (address => uint256) public claimedKebabs;
19     mapping (address => uint256) public lastKebab;
20     mapping (address => address) public referrals;
21     uint256 public marketKebabs;
22    
23     function makeKebabs(address ref) public
24     {
25         require(initialized);
26         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender)
27         {
28             referrals[msg.sender]=ref;
29         }
30         uint256 kebabUsed=getMyKebabs();
31         uint256 newKebaber=SafeMath.div(kebabUsed,KEBABER_TO_MAKE_1KEBAB);
32         workingKebaber[msg.sender]=SafeMath.add(workingKebaber[msg.sender],newKebaber);
33         claimedKebabs[msg.sender]=0;
34         lastKebab[msg.sender]=now;
35         
36         //send referral kebab
37         claimedKebabs[referrals[msg.sender]]=SafeMath.add(claimedKebabs[referrals[msg.sender]],SafeMath.div(kebabUsed,5));
38         
39         //boost market to nerf shrimp hoarding
40         marketKebabs=SafeMath.add(marketKebabs,SafeMath.div(kebabUsed,10));
41     }
42 
43     function sellKebabs() public{
44         require(initialized);
45         uint256 hasKebabs=getMyKebabs();
46         uint256 kebabValue=calculateKebabSell(hasKebabs);
47         uint256 fee=calculatePercentage(kebabValue,10);
48         // kill one half of the owner's snails on egg sale
49         workingKebaber[msg.sender] = SafeMath.div(workingKebaber[msg.sender],2);
50         claimedKebabs[msg.sender]=0;
51         lastKebab[msg.sender]=now;
52         marketKebabs=SafeMath.add(marketKebabs,hasKebabs);
53         ceoEtherBalance+=fee;
54         msg.sender.transfer(SafeMath.sub(kebabValue,fee));
55     }
56 
57     function buyKebabs() public payable
58     {
59         require(initialized);
60         uint256 kebabBought=calculateKebabBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
61         kebabBought=SafeMath.sub(kebabBought,calculatePercentage(kebabBought,10));
62         ceoEtherBalance+=calculatePercentage(msg.value, 10);
63         claimedKebabs[msg.sender]=SafeMath.add(claimedKebabs[msg.sender],kebabBought);
64     }
65 
66     //magic trade balancing algorithm
67     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256)
68     {
69         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
70         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
71     }
72 
73     function calculateKebabSell(uint256 kebab) public view returns(uint256)
74     {
75         return calculateTrade(kebab,marketKebabs,address(this).balance);
76     }
77 
78     function calculateKebabBuy(uint256 eth,uint256 contractBalance) public view returns(uint256)
79     {
80         return calculateTrade(eth,contractBalance,marketKebabs);
81     }
82 
83     function calculateKebabBuySimple(uint256 eth) public view returns(uint256)
84     {
85         return calculateKebabBuy(eth, address(this).balance);
86     }
87 
88     function calculatePercentage(uint256 amount, uint percentage) public pure returns(uint256){
89         return SafeMath.div(SafeMath.mul(amount,percentage),100);
90     }
91 
92     function seedMarket(uint256 kebab) public payable
93     {
94         require(marketKebabs==0);
95         initialized=true;
96         marketKebabs=kebab;
97     }
98 
99     function getFreeKebaber() public payable
100     {
101         require(initialized);
102         require(msg.value==0.001 ether); //similar to mining fee, prevents bots
103         ceoEtherBalance+=msg.value; //ceo gets this entrance fee
104         require(workingKebaber[msg.sender]==0);
105         lastKebab[msg.sender]=now;
106         workingKebaber[msg.sender]=STARTING_KEBAB;
107     }
108 
109     function getBalance() public view returns(uint256)
110     {
111         return address(this).balance;
112     }
113 
114     function getMyKebabers() public view returns(uint256)
115     {
116         return workingKebaber[msg.sender];
117     }
118 
119     function withDrawMoney() public { //to prevent fee to get fee
120         require(msg.sender == ceoAddress);
121         uint256 myBalance = ceoEtherBalance;
122         ceoEtherBalance = ceoEtherBalance - myBalance;
123         ceoAddress.transfer(myBalance);
124     }
125 
126     function getMyKebabs() public view returns(uint256)
127     {
128         return SafeMath.add(claimedKebabs[msg.sender],getKebabsSincelastKebab(msg.sender));
129     }
130 
131     function getKebabsSincelastKebab(address adr) public view returns(uint256)
132     {
133         uint256 secondsPassed=min(KEBABER_TO_MAKE_1KEBAB,SafeMath.sub(now,lastKebab[adr]));
134         return SafeMath.mul(secondsPassed,workingKebaber[adr]);
135     }
136 
137     function min(uint256 a, uint256 b) private pure returns (uint256) 
138     {
139         return a < b ? a : b;
140     }
141 }
142 
143 library SafeMath {
144 
145   /**
146   * @dev Multiplies two numbers, throws on overflow.
147   */
148   function mul(uint256 a, uint256 b) internal pure returns (uint256) 
149   {
150     if (a == 0) 
151     {
152       return 0;
153     }
154     uint256 c = a * b;
155     assert(c / a == b);
156     return c;
157   }
158 
159   /**
160   * @dev Integer division of two numbers, truncating the quotient.
161   */
162   function div(uint256 a, uint256 b) internal pure returns (uint256) {
163     // assert(b > 0); // Solidity automatically throws when dividing by 0
164     uint256 c = a / b;
165     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166     return c;
167   }
168 
169   /**
170   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
171   */
172   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173     assert(b <= a);
174     return a - b;
175   }
176 
177   /**
178   * @dev Adds two numbers, throws on overflow.
179   */
180   function add(uint256 a, uint256 b) internal pure returns (uint256) {
181     uint256 c = a + b;
182     assert(c >= a);
183     return c;
184   }
185 }