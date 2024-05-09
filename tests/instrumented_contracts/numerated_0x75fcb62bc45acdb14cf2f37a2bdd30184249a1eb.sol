1 /*
2 Capital Technologies & Research - Capital (CALL) & CapitalGAS (CALLG) - Crowdsale Smart Contract
3 https://www.mycapitalco.in
4 */
5 pragma solidity ^0.4.18;
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 contract Ownable {
31     address public owner;
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33     function Ownable() public {
34         owner = msg.sender;
35     }
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 interface Token {
47     function transfer(address _to, uint256 _amount) external returns (bool success);
48     function balanceOf(address _owner) external returns (uint256 balance);
49 }
50 contract FiatContract {
51     function USD(uint _id) public constant returns (uint256);
52 }
53 contract Crowdsale {
54   using SafeMath for uint256;
55   Token public token_call;
56   Token public token_callg;
57   FiatContract public fiat_contract;
58   uint256 public maxContributionPerAddress;
59   uint256 public startTime;
60   uint256 public endTime;
61   uint256 public weiRaised;
62   uint256 public sale_period;
63   uint256 public minInvestment;
64   uint256 public softCap;
65   bool public sale_state = false;
66   string public stage;
67   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
68   modifier nonZeroAddress(address _to) {
69     require(_to != 0x0);
70     _;
71   }
72   modifier nonZeroEth() {
73 	require(msg.value > 0);
74     _;
75   }
76   function Crowdsale(address _token_call, address _token_callg) public nonZeroAddress(_token_call) nonZeroAddress(_token_callg) {
77     token_call = Token(_token_call);
78     token_callg = Token(_token_callg);
79     fiat_contract = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
80   }
81   function calculateRate(uint256 _amount) public view returns(uint256) {
82         uint256 tokenPrice = fiat_contract.USD(0);
83         if(startTime.add(15 days) >= block.timestamp) {
84             tokenPrice = tokenPrice.mul(200).div(10 ** 8);
85         } else if(startTime.add(45 days) >= block.timestamp) {
86             tokenPrice = tokenPrice.mul(300).div(10 ** 8);
87         } else if(startTime.add(52 days) >= block.timestamp) {
88             tokenPrice = tokenPrice.mul(330).div(10 ** 8);
89         } else if(startTime.add(59 days) >= block.timestamp) {
90             tokenPrice = tokenPrice.mul(360).div(10 ** 8);
91         } else if(startTime.add(66 days) >= block.timestamp) {
92             tokenPrice = tokenPrice.mul(400).div(10 ** 8);
93         } else {
94             tokenPrice = tokenPrice.mul(150).div(10 ** 8);
95         }
96         return _amount.div(tokenPrice).mul(10 ** 10);
97   }
98   function () external payable {
99     buyTokens(msg.sender);
100   }
101   function compareStages (string a, string b) internal pure returns (bool){
102     return keccak256(a) == keccak256(b);
103   }
104   function buyTokens(address beneficiary) public payable nonZeroAddress(beneficiary) {
105     require(validPurchase());
106 	uint256 weiAmount = msg.value;
107     uint256 tokenPrice = fiat_contract.USD(0);
108     if(startTime.add(15 days) >= block.timestamp) {
109         tokenPrice = tokenPrice.mul(200).div(10 ** 8);
110 		if(!compareStages(stage, "pre")){
111 			stage = "pre";
112 		}
113     } else if(startTime.add(45 days) >= block.timestamp) {
114         tokenPrice = tokenPrice.mul(300).div(10 ** 8);		
115 		if(!compareStages(stage, "main_first")){
116 			stage = "main_first";
117 		}
118     } else if(startTime.add(52 days) >= block.timestamp) {
119         tokenPrice = tokenPrice.mul(330).div(10 ** 8);		
120 		if(!compareStages(stage, "main_second")){
121 			stage = "main_second";
122 		}
123     } else if(startTime.add(59 days) >= block.timestamp) {
124         tokenPrice = tokenPrice.mul(360).div(10 ** 8);
125 		if(!compareStages(stage, "main_third")){
126 			stage = "main_third";
127 		}
128     } else if(startTime.add(66 days) >= block.timestamp) {
129         tokenPrice = tokenPrice.mul(400).div(10 ** 8);
130 		if(!compareStages(stage, "main_fourth")){
131 			stage = "main_fourth";
132 		}
133     } else {
134         tokenPrice = tokenPrice.mul(150).div(10 ** 8);
135 		if(!compareStages(stage, "private")){
136 			stage = "private";
137 		}
138     }
139     uint256 call_units = weiAmount.div(tokenPrice).mul(10 ** 10);
140     uint256 callg_units = call_units.mul(200);
141     forwardFunds();
142     weiRaised = weiRaised.add(weiAmount);
143     emit TokenPurchase(msg.sender, beneficiary, weiAmount, call_units);
144     require(token_call.transfer(beneficiary, call_units));
145     require(token_callg.transfer(beneficiary, callg_units));
146   }
147   function forwardFunds() internal;
148   function hasEnded() public view returns (bool) {
149     require(sale_state);
150     return block.timestamp > endTime;
151   }
152   function validPurchase() internal view returns (bool);
153 }
154 contract FinalizableCrowdsale is Crowdsale, Ownable {
155   using SafeMath for uint256;
156   event Finalized();  
157   function FinalizableCrowdsale(address _token_call, address _token_callg) Crowdsale(_token_call, _token_callg) public {
158       
159   }
160   function finalize() onlyOwner public {
161     require(hasEnded());
162     finalization();
163     emit Finalized();
164 	stage = "ended";
165     sale_state = false;
166   }
167   function finalization() internal ;
168 }
169 contract CapitalTechCrowdsale is FinalizableCrowdsale {
170   using SafeMath for uint256;
171   RefundVault public vault; 
172   event BurnedUnsold();
173   function CapitalTechCrowdsale( address _wallet, address _token_call, address _token_callg) FinalizableCrowdsale( _token_call, _token_callg) public nonZeroAddress(_wallet) {
174     vault = new RefundVault(_wallet);
175   }
176   function powerUpContract() public onlyOwner{
177     require(!sale_state);
178 	startTime = block.timestamp;
179 	sale_period = 75 days;
180     endTime = block.timestamp.add(sale_period);    
181     sale_state = true;
182 	stage = "private";
183 	softCap = 2231250000000000000000000;
184 	maxContributionPerAddress = 1500 ether;	
185 	minInvestment = 0.01 ether;
186   }
187   function transferTokens(address _to, uint256 amount) public onlyOwner nonZeroAddress(_to) {
188     require(hasEnded());
189     token_call.transfer(_to, amount);
190     token_callg.transfer(_to, amount.mul(200));  
191   }  
192   function forwardFunds() internal {
193     vault.deposit.value(msg.value)(msg.sender);
194   }
195   function claimRefund() public {
196     require(!sale_state);
197     require(!goalReached());
198     vault.refund(msg.sender);
199   }
200   function withdrawFunds() public onlyOwner{
201     require(!sale_state);
202     require(goalReached());
203     vault.withdrawToWallet();
204   }
205   function finalization() internal {
206     if (goalReached()) {
207       burnUnsold();
208       vault.close();
209     } else {
210       vault.enableRefunds();
211     }
212   }
213   function burnUnsold() internal {
214     require(!sale_state);
215     require(!goalReached());
216     token_call.transfer(address(0), token_call.balanceOf(this));
217     token_callg.transfer(address(0), token_callg.balanceOf(this));
218     emit BurnedUnsold();
219   }
220   function validPurchase() internal view returns (bool) {
221     require(!hasEnded());
222     require(msg.value >= minInvestment);
223 	require(vault.deposited(msg.sender).add(msg.value) <= maxContributionPerAddress); 
224     return true;
225   }
226   function goalReached() public view returns (bool) {
227     return token_call.balanceOf(this) <= softCap;
228   }
229 }
230 contract RefundVault is Ownable {
231   using SafeMath for uint256;
232   enum State { Active, Refunding, Closed }
233   mapping (address => uint256) public deposited;
234   address public wallet;
235   State public state;
236   event Closed();
237   event RefundsEnabled();
238   event Refunded(address indexed beneficiary, uint256 weiAmount);
239   function RefundVault(address _wallet) public {
240     require(_wallet != address(0));
241     wallet = _wallet;
242     state = State.Active;
243   }
244   function deposit(address investor) onlyOwner public payable {
245     require(state == State.Active);
246     deposited[investor] = deposited[investor].add(msg.value);
247   }
248   function close() onlyOwner public {
249     require(state == State.Active);
250     state = State.Closed;
251     emit Closed();
252   }
253   function withdrawToWallet() onlyOwner public{
254     require(state == State.Closed);
255     wallet.transfer(address(this).balance);
256   }
257   function enableRefunds() onlyOwner public {
258     require(state == State.Active);
259     state = State.Refunding;
260     emit RefundsEnabled();
261   }
262   function refund(address investor) public {
263     require(state == State.Refunding);
264     uint256 depositedValue = deposited[investor];
265     deposited[investor] = 0;
266     emit Refunded(investor, depositedValue);
267     investor.transfer(depositedValue);
268   }
269 }