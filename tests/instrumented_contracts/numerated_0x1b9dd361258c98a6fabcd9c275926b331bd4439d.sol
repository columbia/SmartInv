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
108     uint public tokensSold;
109     uint public maxToken;
110     token public tokenReward;
111     mapping(address => uint256) public balanceOf;
112     bool fundingGoalReached = false;
113     bool crowdsaleClosed = false;
114 
115 
116     event FundWithdrawal(address addr, uint value);
117     event ReceivedETH(address addr, uint value);
118 	event ReceivedBTC(address addr, uint value);
119 	event ReceivedGBP(address addr, uint value);
120     
121 	modifier ICOactive{ 
122 	    require(!crowdsaleClosed); 
123 	    _; 
124 	}
125 	
126 	modifier ICOinactive{ 
127 	    require(crowdsaleClosed); 
128 	    _; 
129 	}
130 	
131 	modifier onlyBy(address a){
132 	    require(msg.sender == a);
133 		_;
134 	}
135 	
136     /**
137      * Constrctor function
138      *
139      * Setup the owner
140      */
141     function ICO() public{
142         maxToken = 40*(10 ** 6) * (10 ** 6);
143         stopped = false;
144         tokensSold = 0;
145         ifSuccessfulSendFundsTo = 0xDB9e5d21B0c4f06b55fb85ff96acfF75d94D60F7;
146         BTCproxy = 0x50651260Ba2B8A3264F1AE074E7a6E7Da101567a;
147         GBPproxy = 0x1ABb9E204Eb8E546eFA06Cbb8c039A91227cb211;
148         fundingGoal = 100 ether;
149         tokenReward = token(0xc4796a5bfc6fa56ea42b5e7c7889abcf724c44fd);
150     }
151 
152     /**
153      * Fallback function
154      *
155      * The function without name is the default function that is called whenever anyone sends funds to a contract
156      */
157     function () public payable stopInEmergency ICOactive{
158         require(msg.value >= 0.01 ether);
159         uint amount = amountToSend(msg.value);
160         if (amount==0){
161             revert();
162         }else{
163             balanceOf[msg.sender] += msg.value;
164             amountRaised += msg.value;
165             tokenReward.transfer(msg.sender,amount);
166             tokensSold = add(tokensSold,amount);
167             ReceivedETH(msg.sender,msg.value);
168         }
169     }
170     
171     function ReceiveBTC(address addr, uint value) public stopInEmergency ICOactive onlyBy(BTCproxy){
172         require(value >= 0.01 ether);
173         uint amount = amountToSend(value);
174         if (amount==0){
175             revert();
176         }else{
177             amountRaised += value;
178             tokenReward.transfer(addr,amount);
179             tokensSold = add(tokensSold,amount);
180             ReceivedBTC(addr,value);
181         }
182     }
183     
184     function ReceiveGBP(address addr, uint value) public stopInEmergency ICOactive onlyBy(GBPproxy){
185         require(value >= 0.01 ether);
186         uint amount = amountToSend(value);
187         if (amount==0){
188             revert();
189         }else{
190             balanceOf[addr] += value;
191             amountRaised += value;
192             tokenReward.transfer(addr,amount);
193             tokensSold = add(tokensSold,amount);
194             ReceivedGBP(addr,value);
195         }
196     }
197     
198     function amountToSend(uint amount) internal returns(uint){
199         uint toSend = 0;
200         if (tokensSold <= 5 * (10 ** 6) * (10 ** 6)){
201             toSend = mul(amount,1000*(10 ** 6))/(1 ether);
202         }else if (5 * (10 ** 6) * (10 ** 6)< tokensSold &&  tokensSold <= 10 * (10 ** 6) * (10 ** 6)){
203             toSend = mul(amount,850*(10 ** 6))/(1 ether);
204         }else if (10 * (10 ** 6) * (10 ** 6)< tokensSold &&  tokensSold <= 20 * (10 ** 6) * (10 ** 6)){
205             toSend = mul(amount,700*(10 ** 6))/(1 ether);
206         }else if (20 * (10 ** 6) * (10 ** 6)< tokensSold &&  tokensSold <= 30 * (10 ** 6) * (10 ** 6)){
207             toSend = mul(amount,600*(10 ** 6))/(1 ether);
208         }else if (30 * (10 ** 6) * (10 ** 6)< tokensSold &&  tokensSold <= 40 * (10 ** 6) * (10 ** 6)){
209             toSend = mul(amount,550*(10 ** 6))/(1 ether);
210         }
211         if (amount >= 10 ether){
212                 toSend = add(toSend,toSend/50); // volume bonus
213         }
214         if (add(toSend,tokensSold) > maxToken){
215             return 0;
216         }else{
217             return toSend;
218         }
219     }
220     function finalize() public onlyBy(owner) {
221         if (amountRaised>=fundingGoal){
222 		    if (!ifSuccessfulSendFundsTo.send(amountRaised)){
223 		        revert();
224 		    }else{
225             fundingGoalReached = true;
226 		    }
227 		}else{
228 		    fundingGoalReached = false;
229 		}
230 		uint HYDEmitted = add(tokensSold,10 * (10 ** 6) * (10 ** 6));
231 		if (HYDEmitted < 50 * (10 ** 6) * (10 ** 6)){													// burn the rest of RLC
232 			  tokenReward.burn(50 * (10 ** 6) * (10 ** 6) - HYDEmitted);
233 		}
234 		tokenReward.unlock();
235 		crowdsaleClosed = true;
236 	}
237 
238     
239     function safeWithdrawal() public ICOinactive{
240         if (!fundingGoalReached) {
241             uint amount = balanceOf[msg.sender];
242             balanceOf[msg.sender] = 0;
243             if (amount > 0) {
244                 if (msg.sender.send(amount)) {
245                     FundWithdrawal(msg.sender, amount);
246                 } else {
247                     balanceOf[msg.sender] = amount;
248                 }
249             }
250         }
251     }
252 }