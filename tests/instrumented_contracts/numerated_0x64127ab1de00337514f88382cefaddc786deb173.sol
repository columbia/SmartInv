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
11     mapping(address => uint) public gladiatorToPowerBonus;
12     mapping(address => bool)  public trustedContracts;
13     address public kingGladiator;
14     address[] public queue;
15 
16     uint founders = 0;
17 
18     event fightEvent(address indexed g1,address indexed g2,uint random,uint fightPower,uint g1Power);
19     modifier OnlyOwnerAndContracts() {
20         require(msg.sender == m_Owner ||  trustedContracts[msg.sender]);
21         _;
22     }
23     function ChangeAddressTrust(address contract_address,bool trust_flag) public OnlyOwnerAndContracts() {
24         require(msg.sender != contract_address);
25         trustedContracts[contract_address] = trust_flag;
26     }
27     
28     function Gladiethers() public{
29         m_Owner = msg.sender;
30     }
31     
32     function setPartner(address contract_partner) public OnlyOwnerAndContracts(){
33         partner = contract_partner;
34     }
35 
36     function joinArena() public payable returns (bool){
37 
38         require( msg.value >= 10 finney );
39 
40         if(founders < 50 && gladiatorToPowerBonus[msg.sender] == 0){
41             gladiatorToPowerBonus[msg.sender] = 5; // 5% increase in the power of your gladiator for eveeer
42             founders++;
43         }else if(founders < 100 && gladiatorToPowerBonus[msg.sender] == 0){
44             gladiatorToPowerBonus[msg.sender] = 2; // 2% increase in the power
45             founders++;
46         }else if(founders < 200 && gladiatorToPowerBonus[msg.sender] == 0){
47             gladiatorToPowerBonus[msg.sender] = 1; // 1% increase in the power
48             founders++;
49         }
50 
51         if(queue.length > gladiatorToQueuePosition[msg.sender]){
52 
53             if(queue[gladiatorToQueuePosition[msg.sender]] == msg.sender){
54                 gladiatorToPower[msg.sender] += msg.value;
55                 return false;
56             }
57             
58         }
59         
60         enter(msg.sender);
61         return true;  
62 
63     }
64 
65     function enter(address gladiator) private{
66         gladiatorToCooldown[gladiator] = now + 1 days;
67         queue.push(gladiator);
68         gladiatorToQueuePosition[gladiator] = queue.length - 1;
69         gladiatorToPower[gladiator] += msg.value;
70     }
71 
72 
73     function remove(address gladiator) private returns(bool){
74         
75         if(queue.length > gladiatorToQueuePosition[gladiator]){
76 
77             if(queue[gladiatorToQueuePosition[gladiator]] == gladiator){ // is on the line ?
78             
79                 queue[gladiatorToQueuePosition[gladiator]] = queue[queue.length - 1];
80                 gladiatorToQueuePosition[queue[queue.length - 1]] = gladiatorToQueuePosition[gladiator];
81                 gladiatorToCooldown[gladiator] =  9999999999999; // indicative number to know when it is in battle
82                 delete queue[queue.length - 1];
83                 queue.length = queue.length - (1);
84                 return true;
85                 
86             }
87            
88         }
89         return false;
90         
91         
92     }
93 
94     function removeOrc(address _gladiator) public OnlyOwnerAndContracts(){
95          remove(_gladiator);
96     }
97 
98     function setCooldown(address gladiator, uint cooldown) internal{
99         gladiatorToCooldown[gladiator] = cooldown;
100     }
101 
102     function getGladiatorPower(address gladiator) public view returns (uint){
103         return gladiatorToPower[gladiator];
104     }
105     
106     function getQueueLenght() public view returns (uint){
107         return queue.length;
108     }
109 
110     function fight(address gladiator1,string _result) public OnlyOwnerAndContracts(){
111 
112         uint indexgladiator2 = uint(sha3(_result)) % queue.length; // this is an efficient way to get the uint out in the [0, maxRange] range
113         uint randomNumber = uint(sha3(_result)) % 1000;
114         address gladiator2 = queue[indexgladiator2];
115         
116         require(gladiatorToPower[gladiator1] >= 10 finney && gladiator1 != gladiator2);
117 
118         
119         uint g1chance = getChancePowerWithBonus(gladiator1);
120         uint g2chance = getChancePowerWithBonus(gladiator2);
121         uint fightPower = SafeMath.add(g1chance,g2chance);
122 
123         g1chance = (g1chance*1000)/fightPower;
124 
125         if(g1chance <= 958){
126             g1chance = SafeMath.add(g1chance,40);
127         }else{
128             g1chance = 998;
129         }
130 
131         fightEvent( gladiator1, gladiator2,randomNumber,fightPower,getChancePowerWithBonus(gladiator1));
132         uint devFee;
133 
134         if(randomNumber <= g1chance ){ // Wins the Attacker
135             devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator2],4),100);
136 
137             gladiatorToPower[gladiator1] =  SafeMath.add( gladiatorToPower[gladiator1], SafeMath.sub(gladiatorToPower[gladiator2],devFee) );
138             queue[gladiatorToQueuePosition[gladiator2]] = gladiator1;
139             gladiatorToQueuePosition[gladiator1] = gladiatorToQueuePosition[gladiator2];
140             gladiatorToPower[gladiator2] = 0;
141             gladiatorToCooldown[gladiator1] = now + 1 days; // reset atacker cooldown
142 
143             if(gladiatorToPower[gladiator1] > gladiatorToPower[kingGladiator] ){ // check if is the biggest guy in the arena
144                 kingGladiator = gladiator1;
145             }
146 
147         }else{
148             //Defender Wins
149             devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator1],4),100);
150 
151             gladiatorToPower[gladiator2] = SafeMath.add( gladiatorToPower[gladiator2],SafeMath.sub(gladiatorToPower[gladiator1],devFee) );
152             gladiatorToPower[gladiator1] = 0;
153 
154             if(gladiatorToPower[gladiator2] > gladiatorToPower[kingGladiator] ){
155                 kingGladiator = gladiator2;
156             }
157 
158         }
159 
160         
161         gladiatorToPower[kingGladiator] = SafeMath.add( gladiatorToPower[kingGladiator],SafeMath.div(devFee,4) ); // gives 1%      (4% dead gladiator / 4 )
162         gladiatorToPower[m_Owner] = SafeMath.add( gladiatorToPower[m_Owner] , SafeMath.sub(devFee,SafeMath.div(devFee,4)) ); // 4total - 1king  = 3%
163 
164     }
165 
166     function getChancePowerWithBonus(address gladiator) public view returns(uint power){
167         return SafeMath.add(gladiatorToPower[gladiator],SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator],gladiatorToPowerBonus[gladiator]),100));
168     }
169 
170 
171     function withdraw(uint amount) public  returns (bool success){
172         address withdrawalAccount;
173         uint withdrawalAmount;
174 
175         // owner and partner can withdraw
176         if (msg.sender == m_Owner || msg.sender == partner ) {
177             withdrawalAccount = m_Owner;
178             withdrawalAmount = gladiatorToPower[m_Owner];
179             uint partnerFee = SafeMath.div(SafeMath.mul(gladiatorToPower[withdrawalAccount],15),100);
180 
181             // set funds to 0
182             gladiatorToPower[withdrawalAccount] = 0;
183 
184             if (!m_Owner.send(SafeMath.sub(withdrawalAmount,partnerFee))) revert(); // send to owner
185             if (!partner.send(partnerFee)) revert(); // send to partner
186 
187             return true;
188         }else{
189 
190             withdrawalAccount = msg.sender;
191             withdrawalAmount = amount;
192 
193             // cooldown has been reached and the ammout i possible
194             if(gladiatorToCooldown[msg.sender] < now && gladiatorToPower[withdrawalAccount] >= withdrawalAmount){
195 
196                 gladiatorToPower[withdrawalAccount] = SafeMath.sub(gladiatorToPower[withdrawalAccount],withdrawalAmount);
197 
198                 // gladiator have to be removed from areana if the power is less then 0.01 eth
199                 if(gladiatorToPower[withdrawalAccount] < 10 finney){
200                     remove(msg.sender);
201                 }
202 
203             }else{
204                 return false;
205             }
206 
207         }
208 
209         if (withdrawalAmount == 0) revert();
210 
211         // send the funds
212         if (!msg.sender.send(withdrawalAmount)) revert();
213 
214 
215         return true;
216     }
217 
218 
219 }
220 
221 library SafeMath {
222 
223     /**
224     * @dev Multiplies two numbers, throws on overflow.
225     */
226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227         if (a == 0) {
228             return 0;
229         }
230         uint256 c = a * b;
231         assert(c / a == b);
232         return c;
233     }
234 
235     /**
236     * @dev Integer division of two numbers, truncating the quotient.
237     */
238     function div(uint256 a, uint256 b) internal pure returns (uint256) {
239         // assert(b > 0); // Solidity automatically throws when dividing by 0
240         uint256 c = a / b;
241         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242         return c;
243     }
244 
245     /**
246     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
247     */
248     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
249         assert(b <= a);
250         return a - b;
251     }
252 
253     /**
254     * @dev Adds two numbers, throws on overflow.
255     */
256     function add(uint256 a, uint256 b) internal pure returns (uint256) {
257         uint256 c = a + b;
258         assert(c >= a);
259         return c;
260     }
261 }