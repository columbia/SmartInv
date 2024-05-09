1 pragma solidity ^0.4.20;
2 
3 contract Gladiethers
4 {
5     address public m_Owner;
6     address public partner;
7 
8     mapping (address => uint) public gladiatorToPower; // gladiator power
9     mapping (address => uint) public gladiatorToCooldown;
10     mapping(address => uint) public gladiatorToQueuePosition;
11     mapping(address => bool)  public trustedContracts;
12     uint public m_OwnerFees = 0;
13     uint public initGameAt = 1529532000;
14     address public kingGladiator;
15     address public kingGladiatorFounder;
16     address public oraclizeContract;
17     address[] public queue;
18     
19     bool started = false;
20 
21     event fightEvent(address indexed g1,address indexed g2,uint random,uint fightPower,uint g1Power);
22     modifier OnlyOwnerAndContracts() {
23         require(msg.sender == m_Owner ||  trustedContracts[msg.sender]);
24         _;
25     }
26     
27     function ChangeAddressTrust(address contract_address,bool trust_flag) public OnlyOwnerAndContracts() {
28         require(msg.sender != contract_address);
29         trustedContracts[contract_address] = trust_flag;
30     }
31     
32     function Gladiethers() public{
33         m_Owner = msg.sender;
34     }
35     
36     function setPartner(address contract_partner) public OnlyOwnerAndContracts(){
37         partner = contract_partner;
38     }
39     
40     function setOraclize(address contract_oraclize) public OnlyOwnerAndContracts(){
41         require(!started);
42         oraclizeContract = contract_oraclize;
43         started = true;
44     }
45 
46     function joinArena() public payable returns (bool){
47 
48         require( msg.value >= 10 finney && getGladiatorCooldown(msg.sender) != 9999999999999);
49 
50         if(queue.length > gladiatorToQueuePosition[msg.sender]){
51 
52             if(queue[gladiatorToQueuePosition[msg.sender]] == msg.sender){
53                 gladiatorToPower[msg.sender] += msg.value;
54                 checkKingFounder(msg.sender);
55                 return false;
56             }
57         }
58         
59         enter(msg.sender);
60         return true;  
61 
62     }
63 
64     function enter(address gladiator) private{
65         gladiatorToCooldown[gladiator] = now + 1 days;
66         queue.push(gladiator);
67         gladiatorToQueuePosition[gladiator] = queue.length - 1;
68         gladiatorToPower[gladiator] += msg.value;
69         checkKingFounder(gladiator);
70     }
71     
72     function checkKingFounder(address gladiator) internal{
73         if(gladiatorToPower[gladiator] > gladiatorToPower[kingGladiatorFounder] && now < initGameAt){
74             kingGladiatorFounder = gladiator;
75         }
76     }
77 
78 
79     function remove(address gladiator) private returns(bool){
80         
81         if(queue.length > gladiatorToQueuePosition[gladiator]){
82 
83             if(queue[gladiatorToQueuePosition[gladiator]] == gladiator){ // is on the line ?
84             
85                 queue[gladiatorToQueuePosition[gladiator]] = queue[queue.length - 1];
86                 gladiatorToQueuePosition[queue[queue.length - 1]] = gladiatorToQueuePosition[gladiator];
87                 gladiatorToCooldown[gladiator] =  9999999999999; // indicative number to know when it is in battle
88                 delete queue[queue.length - 1];
89                 queue.length = queue.length - (1);
90                 return true;
91                 
92             }
93            
94         }
95         return false;
96         
97         
98     }
99 
100     function removeOrc(address _gladiator) public {
101         require(msg.sender == oraclizeContract);
102         remove(_gladiator);
103     }
104 
105     function setCooldown(address gladiator, uint cooldown) internal{
106         gladiatorToCooldown[gladiator] = cooldown;
107     }
108 
109     function getGladiatorPower(address gladiator) public view returns (uint){
110         return gladiatorToPower[gladiator];
111     }
112     
113     function getQueueLenght() public view returns (uint){
114         return queue.length;
115     }
116     
117     function getGladiatorCooldown(address gladiator) public view returns (uint){
118         return gladiatorToCooldown[gladiator];
119     }
120     
121 
122     function fight(address gladiator1,string _result) public {
123 
124         require(msg.sender == oraclizeContract);
125         
126         // in a unlikely case of 3 guys in queue two of them scheduleFight and the last one withdraws and left the first fighter that enconters the queue empty becomes the kingGladiator
127         if(queue.length == 0){  
128             gladiatorToCooldown[gladiator1] = now + 1 days;
129             queue.push(gladiator1);
130             gladiatorToQueuePosition[gladiator1] = queue.length - 1;
131             kingGladiator = gladiator1;
132         }else{
133         
134             uint indexgladiator2 = uint(sha3(_result)) % queue.length; // this is an efficient way to get the uint out in the [0, maxRange] range
135             uint randomNumber = uint(sha3(_result)) % 1000;
136             address gladiator2 = queue[indexgladiator2];
137             
138             require(gladiatorToPower[gladiator1] >= 10 finney && gladiator1 != gladiator2);
139     
140             
141             uint g1chance = gladiatorToPower[gladiator1];
142             uint g2chance =  gladiatorToPower[gladiator2];
143             uint fightPower = SafeMath.add(g1chance,g2chance);
144     
145             g1chance = (g1chance*1000)/fightPower;
146     
147             if(g1chance <= 958){
148                 g1chance = SafeMath.add(g1chance,40);
149             }else{
150                 g1chance = 998;
151             }
152     
153             fightEvent( gladiator1, gladiator2,randomNumber,fightPower,gladiatorToPower[gladiator1]);
154             uint devFee;
155     
156             if(randomNumber <= g1chance ){ // Wins the Attacker
157                 devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator2],5),100);
158     
159                 gladiatorToPower[gladiator1] =  SafeMath.add( gladiatorToPower[gladiator1], SafeMath.sub(gladiatorToPower[gladiator2],devFee) );
160                 queue[gladiatorToQueuePosition[gladiator2]] = gladiator1;
161                 gladiatorToQueuePosition[gladiator1] = gladiatorToQueuePosition[gladiator2];
162                 gladiatorToPower[gladiator2] = 0;
163                 gladiatorToCooldown[gladiator1] = now + 1 days; // reset atacker cooldown
164     
165                 if(gladiatorToPower[gladiator1] > gladiatorToPower[kingGladiator] ){ // check if is the biggest guy in the arena
166                     kingGladiator = gladiator1;
167                 }
168     
169             }else{
170                 //Defender Wins
171                 devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator1],5),100);
172     
173                 gladiatorToPower[gladiator2] = SafeMath.add( gladiatorToPower[gladiator2],SafeMath.sub(gladiatorToPower[gladiator1],devFee) );
174                 gladiatorToPower[gladiator1] = 0;
175                 gladiatorToCooldown[gladiator1] = 0;
176                 
177                 if(gladiatorToPower[gladiator2] > gladiatorToPower[kingGladiator] ){
178                     kingGladiator = gladiator2;
179                 }
180 
181         }
182 
183         
184         kingGladiator.transfer(SafeMath.div(devFee,5)); // gives 1%      (5% dead gladiator / 5 )
185         m_OwnerFees = SafeMath.add( m_OwnerFees , SafeMath.sub(devFee,SafeMath.div(devFee,5)) ); // 5total - 1king  = 4%
186         }
187         
188         
189 
190     }
191 
192 
193     function withdraw(uint amount) public  returns (bool success){
194         address withdrawalAccount;
195         uint withdrawalAmount;
196 
197         // owner and partner can withdraw
198         if (msg.sender == m_Owner || msg.sender == partner ) {
199             withdrawalAccount = m_Owner;
200             withdrawalAmount = m_OwnerFees;
201             uint kingGladiatorFounderProffits = SafeMath.div(withdrawalAmount,4);
202             uint partnerFee =  SafeMath.div(SafeMath.mul(SafeMath.sub(withdrawalAmount,kingGladiatorFounderProffits),15),100);
203 
204             // set funds to 0
205             m_OwnerFees = 0;
206 
207             if (!m_Owner.send(SafeMath.sub(SafeMath.sub(withdrawalAmount,partnerFee),kingGladiatorFounderProffits))) revert(); // send to owner
208             if (!partner.send(partnerFee)) revert(); // send to partner
209             if (!kingGladiatorFounder.send(kingGladiatorFounderProffits)) revert(); // send to kingGladiatorFounder
210 
211             return true;
212         }else{
213 
214             withdrawalAccount = msg.sender;
215             withdrawalAmount = amount;
216 
217             // cooldown has been reached and the ammout i possible
218             if(gladiatorToCooldown[msg.sender] < now && gladiatorToPower[withdrawalAccount] >= withdrawalAmount){
219 
220                 gladiatorToPower[withdrawalAccount] = SafeMath.sub(gladiatorToPower[withdrawalAccount],withdrawalAmount);
221 
222                 // gladiator have to be removed from areana if the power is less then 0.01 eth
223                 if(gladiatorToPower[withdrawalAccount] < 10 finney){
224                     remove(msg.sender);
225                 }
226 
227             }else{
228                 return false;
229             }
230 
231         }
232 
233         if (withdrawalAmount == 0) revert();
234 
235         // send the funds
236         if (!msg.sender.send(withdrawalAmount)) revert();
237 
238 
239         return true;
240     }
241 
242 
243 }
244 
245 library SafeMath {
246 
247     /**
248     * @dev Multiplies two numbers, throws on overflow.
249     */
250     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251         if (a == 0) {
252             return 0;
253         }
254         uint256 c = a * b;
255         assert(c / a == b);
256         return c;
257     }
258 
259     /**
260     * @dev Integer division of two numbers, truncating the quotient.
261     */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         // assert(b > 0); // Solidity automatically throws when dividing by 0
264         uint256 c = a / b;
265         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
266         return c;
267     }
268 
269     /**
270     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
271     */
272     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273         assert(b <= a);
274         return a - b;
275     }
276 
277     /**
278     * @dev Adds two numbers, throws on overflow.
279     */
280     function add(uint256 a, uint256 b) internal pure returns (uint256) {
281         uint256 c = a + b;
282         assert(c >= a);
283         return c;
284     }
285 }