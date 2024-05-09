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
58   uint256 public softCap = 30000 ether;
59   uint256 public maxContributionPerAddress = 1500 ether;
60   uint256 public startTime;
61   uint256 public endTime;
62   uint256 public weiRaised;
63   uint256 public sale_period = 75 days;
64   uint256 public minInvestment = 0.01 ether;
65   bool public sale_state = false;
66   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
67   modifier nonZeroAddress(address _to) {
68     require(_to != 0x0);
69     _;
70   }
71   modifier nonZeroEth() {
72 	require(msg.value > 0);
73     _;
74   }
75   function Crowdsale(address _token_call, address _token_callg) public nonZeroAddress(_token_call) nonZeroAddress(_token_callg) {
76     token_call = Token(_token_call);
77     token_callg = Token(_token_callg);
78     fiat_contract = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
79   }
80   function calculateRate(uint256 _amount) public view returns(uint256) {
81         uint256 tokenPrice = fiat_contract.USD(0);
82         if(startTime.add(15 days) >= block.timestamp) {
83             tokenPrice = tokenPrice.mul(200).div(10 ** 8);
84         } else if(startTime.add(45 days) >= block.timestamp) {
85             tokenPrice = tokenPrice.mul(300).div(10 ** 8);
86         } else if(startTime.add(52 days) >= block.timestamp) {
87             tokenPrice = tokenPrice.mul(330).div(10 ** 8);
88         } else if(startTime.add(59 days) >= block.timestamp) {
89             tokenPrice = tokenPrice.mul(360).div(10 ** 8);
90         } else if(startTime.add(66 days) >= block.timestamp) {
91             tokenPrice = tokenPrice.mul(400).div(10 ** 8);
92         } else {
93             tokenPrice = tokenPrice.mul(150).div(10 ** 8);
94         }
95         return _amount.div(tokenPrice).mul(10 ** 10);
96   }
97   function () external payable {
98     buyTokens(msg.sender);
99   }
100   function buyTokens(address beneficiary) public payable nonZeroAddress(beneficiary) {
101     require(validPurchase());
102 	uint256 weiAmount = msg.value;
103     uint256 tokenPrice = fiat_contract.USD(0);
104     if(startTime.add(15 days) >= block.timestamp) {
105         tokenPrice = tokenPrice.mul(200).div(10 ** 8);
106     } else if(startTime.add(45 days) >= block.timestamp) {
107         tokenPrice = tokenPrice.mul(300).div(10 ** 8);
108     } else if(startTime.add(52 days) >= block.timestamp) {
109         tokenPrice = tokenPrice.mul(330).div(10 ** 8);
110     } else if(startTime.add(59 days) >= block.timestamp) {
111         tokenPrice = tokenPrice.mul(360).div(10 ** 8);
112     } else if(startTime.add(66 days) >= block.timestamp) {
113         tokenPrice = tokenPrice.mul(400).div(10 ** 8);
114     } else {
115         tokenPrice = tokenPrice.mul(150).div(10 ** 8);
116     }
117     uint256 call_units = weiAmount.div(tokenPrice).mul(10 ** 10);
118     uint256 callg_units = call_units.mul(200);
119     forwardFunds();
120     weiRaised = weiRaised.add(weiAmount);
121     emit TokenPurchase(msg.sender, beneficiary, weiAmount, call_units);
122     require(token_call.transfer(beneficiary, call_units));
123     require(token_callg.transfer(beneficiary, callg_units));
124   }
125   function forwardFunds() internal;
126   function hasEnded() public view returns (bool) {
127     require(sale_state);
128     return block.timestamp > endTime;
129   }
130   function validPurchase() internal view returns (bool);
131 }
132 contract FinalizableCrowdsale is Crowdsale, Ownable {
133   using SafeMath for uint256;
134   event Finalized();  
135   function FinalizableCrowdsale(address _token_call, address _token_callg) Crowdsale(_token_call, _token_callg) public {
136       
137   }
138   function finalize() onlyOwner public {
139     require(hasEnded());
140     finalization();
141     emit Finalized();
142     sale_state = false;
143   }
144   function finalization() internal ;
145 }
146 contract CapitalTechCrowdsale is FinalizableCrowdsale {
147   using SafeMath for uint256;
148   RefundVault public vault; 
149   event BurnedUnsold();
150   function CapitalTechCrowdsale( address _wallet, address _token_call, address _token_callg) FinalizableCrowdsale( _token_call, _token_callg) public nonZeroAddress(_wallet) {
151     vault = new RefundVault(_wallet);
152   }
153   function powerUpContract() public onlyOwner{
154     require(!sale_state);
155 	startTime = block.timestamp;
156     endTime = block.timestamp.add(sale_period);    
157     sale_state = true;
158   }
159   function transferTokens(address _to, uint256 amount) public onlyOwner nonZeroAddress(_to) {
160     require(hasEnded());
161     token_call.transfer(_to, amount);
162     token_callg.transfer(_to, amount.mul(200));  
163   }  
164   function forwardFunds() internal {
165     vault.deposit.value(msg.value)(msg.sender);
166   }
167   function claimRefund() public {
168     require(!sale_state);
169     require(!goalReached());
170     vault.refund(msg.sender);
171   }
172   function withdrawFunds() public onlyOwner{
173     require(!sale_state);
174     require(goalReached());
175     vault.withdrawToWallet();
176   }
177   function finalization() internal {
178     if (goalReached()) {
179       burnUnsold();
180       vault.close();
181     } else {
182       vault.enableRefunds();
183     }
184   }
185   function burnUnsold() internal {
186     require(!sale_state);
187     require(!goalReached());
188     token_call.transfer(address(0), token_call.balanceOf(this));
189     token_callg.transfer(address(0), token_callg.balanceOf(this));
190     emit BurnedUnsold();
191   }
192   function validPurchase() internal view returns (bool) {
193     require(!hasEnded());
194     require(msg.value >= minInvestment);
195 	require(vault.deposited(msg.sender).add(msg.value) <= maxContributionPerAddress); 
196     return true;
197   }
198   function goalReached() public view returns (bool) {
199     return token_call.balanceOf(this) <= 5250000000000000000000000;
200   }
201 }
202 contract RefundVault is Ownable {
203   using SafeMath for uint256;
204   enum State { Active, Refunding, Closed }
205   mapping (address => uint256) public deposited;
206   address public wallet;
207   State public state;
208   event Closed();
209   event RefundsEnabled();
210   event Refunded(address indexed beneficiary, uint256 weiAmount);
211   function RefundVault(address _wallet) public {
212     require(_wallet != address(0));
213     wallet = _wallet;
214     state = State.Active;
215   }
216   function deposit(address investor) onlyOwner public payable {
217     require(state == State.Active);
218     deposited[investor] = deposited[investor].add(msg.value);
219   }
220   function close() onlyOwner public {
221     require(state == State.Active);
222     state = State.Closed;
223     emit Closed();
224   }
225   function withdrawToWallet() onlyOwner public{
226     require(state == State.Closed);
227     wallet.transfer(address(this).balance);
228   }
229   function enableRefunds() onlyOwner public {
230     require(state == State.Active);
231     state = State.Refunding;
232     emit RefundsEnabled();
233   }
234   function refund(address investor) public {
235     require(state == State.Refunding);
236     uint256 depositedValue = deposited[investor];
237     deposited[investor] = 0;
238     emit Refunded(investor, depositedValue);
239     investor.transfer(depositedValue);
240   }
241 }