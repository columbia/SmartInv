1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5     function unlock() public;
6     function burn(uint256 _value) public returns (bool);
7 }
8 
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 contract Pausable is Ownable {
47   bool public stopped;
48 
49   modifier stopInEmergency {
50     require(!stopped);
51     _;
52   }
53   
54   modifier onlyInEmergency {
55     require(stopped);
56     _;
57   }
58 
59   // called by the owner on emergency, triggers stopped state
60   function emergencyStop() external onlyOwner {
61     stopped = true;
62   }
63 
64   // called by the owner on end of emergency, returns to normal state
65   function release() external onlyOwner onlyInEmergency {
66     stopped = false;
67   }
68 
69 }
70 
71 contract SafeMath {
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92 
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 
101 
102 contract ICO is SafeMath, Pausable{
103     address public ifSuccessfulSendFundsTo;
104     address public BTCproxy;
105     address public GBPproxy;
106     uint public fundingGoal;
107     uint public amountRaised;
108     uint public deadline;
109     uint public preIcoEnds;
110     uint public tokensSold;
111     uint public maxToken;
112     token public tokenReward;
113     mapping(address => uint256) public balanceOf;
114     bool fundingGoalReached = false;
115     bool crowdsaleClosed = false;
116 
117 
118     event FundWithdrawal(address addr, uint value);
119     event ReceivedETH(address addr, uint value);
120 	event ReceivedBTC(address addr, uint value);
121 	event ReceivedGBP(address addr, uint value);
122     
123     modifier beforeDeadline{ 
124         require(now < deadline); 
125         _;
126     }
127 	modifier afterDeadline{ 
128 	    require(now >= deadline); 
129 	    _; 
130 	}
131 	modifier ICOactive{ 
132 	    require(!crowdsaleClosed); 
133 	    _; 
134 	}
135 	
136 	modifier ICOinactive{ 
137 	    require(crowdsaleClosed); 
138 	    _; 
139 	}
140 	
141 	modifier onlyBy(address a){
142 	    require(msg.sender == a);
143 		_;
144 	}
145 	
146     /**
147      * Constrctor function
148      *
149      * Setup the owner
150      */
151     function ICO() public{
152         maxToken = 40*(10 ** 6) * (10 ** 6);
153         stopped = false;
154         tokensSold = 0;
155         ifSuccessfulSendFundsTo = 0xDB9e5d21B0c4f06b55fb85ff96acfF75d94D60F7;
156         BTCproxy = 0x50651260Ba2B8A3264F1AE074E7a6E7Da101567a;
157         GBPproxy = 0x1ABb9E204Eb8E546eFA06Cbb8c039A91227cb211;
158         fundingGoal = 100 ether;
159         deadline = now + 35 days;
160         preIcoEnds = now + 7 days;
161         tokenReward = token(0x2749b5bfd51f9d9dd12927f53c112ebb5e94c247);
162     }
163 
164     /**
165      * Fallback function
166      *
167      * The function without name is the default function that is called whenever anyone sends funds to a contract
168      */
169     function () public payable stopInEmergency beforeDeadline ICOactive{
170         require(msg.value >= MinimumInvestment());
171         uint amount = amountToSend(msg.value);
172         if (amount==0){
173             revert();
174         }else{
175             balanceOf[msg.sender] += msg.value;
176             amountRaised += msg.value;
177             tokenReward.transfer(msg.sender,amount);
178             tokensSold = add(tokensSold,amount);
179             ReceivedETH(msg.sender,msg.value);
180         }
181     }
182     
183     function ReceiveBTC(address addr, uint value) public stopInEmergency beforeDeadline ICOactive onlyBy(BTCproxy){
184         require(value >= MinimumInvestment());
185         uint amount = amountToSend(value);
186         if (amount==0){
187             revert();
188         }else{
189             amountRaised += value;
190             tokenReward.transfer(addr,amount);
191             tokensSold = add(tokensSold,amount);
192             ReceivedBTC(addr,value);
193         }
194     }
195     
196     function ReceiveGBP(address addr, uint value) public stopInEmergency beforeDeadline ICOactive onlyBy(GBPproxy){
197         require(value >= MinimumInvestment());
198         uint amount = amountToSend(value);
199         if (amount==0){
200             revert();
201         }else{
202             balanceOf[addr] += value;
203             amountRaised += value;
204             tokenReward.transfer(addr,amount);
205             tokensSold = add(tokensSold,amount);
206             ReceivedGBP(addr,value);
207         }
208     }
209     
210     function MinimumInvestment() internal returns(uint){
211         if (now <= preIcoEnds){
212             return 0.1 ether;
213         }else{
214             return 0.01 ether;
215         }
216     }
217     
218     function amountToSend(uint amount) internal returns(uint){
219         uint toSend = 0;
220         if (tokensSold <= 5 * (10 ** 6) * (10 ** 6)){
221             toSend = mul(amount,1000*(10 ** 6))/(1 ether);
222         }else if (5 * (10 ** 6) * (10 ** 6)< tokensSold &&  tokensSold <= 10 * (10 ** 6) * (10 ** 6)){
223             toSend = mul(amount,850*(10 ** 6))/(1 ether);
224         }else if (10 * (10 ** 6) * (10 ** 6)< tokensSold &&  tokensSold <= 20 * (10 ** 6) * (10 ** 6)){
225             toSend = mul(amount,700*(10 ** 6))/(1 ether);
226         }else if (20 * (10 ** 6) * (10 ** 6)< tokensSold &&  tokensSold <= 30 * (10 ** 6) * (10 ** 6)){
227             toSend = mul(amount,600*(10 ** 6))/(1 ether);
228         }else if (30 * (10 ** 6) * (10 ** 6)< tokensSold &&  tokensSold <= 40 * (10 ** 6) * (10 ** 6)){
229             toSend = mul(amount,550*(10 ** 6))/(1 ether);
230         }
231         if (amount >= 10 ether){
232                 toSend = add(toSend,toSend/50); // volume bonus
233         }
234         if (add(toSend,tokensSold) > maxToken){
235             return 0;
236         }else{
237             return toSend;
238         }
239     }
240     function finalize() public onlyBy(owner) {
241         if (amountRaised>=fundingGoal){
242 		    if (!ifSuccessfulSendFundsTo.send(amountRaised)){
243 		        revert();
244 		    }else{
245             fundingGoalReached = true;
246 		    }
247 		}else{
248 		    fundingGoalReached = false;
249 		}
250 		uint HYDEmitted = add(tokensSold,10 * (10 ** 6) * (10 ** 6));
251 		if (HYDEmitted < 50 * (10 ** 6) * (10 ** 6)){													// burn the rest of RLC
252 			  tokenReward.burn(50 * (10 ** 6) * (10 ** 6) - HYDEmitted);
253 		}
254 		tokenReward.unlock();
255 		crowdsaleClosed = true;
256 	}
257 
258     
259     function safeWithdrawal() public afterDeadline ICOinactive{
260         if (!fundingGoalReached) {
261             uint amount = balanceOf[msg.sender];
262             balanceOf[msg.sender] = 0;
263             if (amount > 0) {
264                 if (msg.sender.send(amount)) {
265                     FundWithdrawal(msg.sender, amount);
266                 } else {
267                     balanceOf[msg.sender] = amount;
268                 }
269             }
270         }
271     }
272 }