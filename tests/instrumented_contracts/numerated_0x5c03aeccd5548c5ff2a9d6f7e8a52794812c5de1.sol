1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     require(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     //   require(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     //   require(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     require(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     require(c >= a);
30     return c;
31   }
32 }
33 
34 contract ControllerInterface {
35 
36   function totalSupply() constant returns (uint256);
37   function balanceOf(address _owner) constant returns (uint256);
38   function allowance(address _owner, address _spender) constant returns (uint256);
39 
40   function approve(address owner, address spender, uint256 value) public returns (bool);
41   function transfer(address owner, address to, uint value, bytes data) public returns (bool);
42   function transferFrom(address owner, address from, address to, uint256 amount, bytes data) public returns (bool);
43   function mint(address _to, uint256 _amount)  public returns (bool);
44 }
45 
46 /**
47  * @title CrowdsaleBase
48  * @dev CrowdsaleBase is a base contract for managing a token crowdsale.
49  * All crowdsale contracts must inherit this contract.
50  */
51 
52 contract CrowdsaleBase {
53   using SafeMath for uint256;
54 
55   address public controller;
56   uint256 public startTime;
57   address public wallet;
58   uint256 public weiRaised;
59   uint256 public endTime;
60 
61   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
62 
63   modifier onlyController() {
64     require(msg.sender == controller);
65     _;
66   }
67 
68   function CrowdsaleBase(uint256 _startTime, address _wallet, address _controller) public {
69     require(_wallet != address(0));
70 
71     controller = _controller;
72     startTime = _startTime;
73     wallet = _wallet;
74   }
75 
76   // @return true if crowdsale event has ended
77   function hasEnded() public constant returns (bool) {
78     return now > endTime;
79   }
80 
81   // send ether to the fund collection wallet
82   function forwardFunds() internal {
83     require(wallet.call.gas(2000).value(msg.value)());
84   }
85 
86   // @return true if the transaction can buy tokens
87   function validPurchase() internal constant returns (bool) {
88     bool withinPeriod = now >= startTime && now <= endTime;
89     bool nonZeroPurchase = msg.value != 0;
90     return withinPeriod && nonZeroPurchase;
91   }
92 
93   // internal token purchase function
94   function _buyTokens(address beneficiary, uint256 rate) internal returns (uint256 tokens) {
95     require(beneficiary != address(0));
96     require(validPurchase());
97 
98     uint256 weiAmount = msg.value;
99 
100     // calculate token amount to be created
101     tokens = weiAmount.mul(rate);
102 
103     // update state
104     weiRaised = weiRaised.add(weiAmount);
105 
106     ControllerInterface(controller).mint(beneficiary, tokens);
107     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
108 
109     forwardFunds();
110   }
111 
112 }
113 
114 /**
115  * @title Crowdsale
116  * @dev Crowdsale is a  contract for managing a token crowdsale.
117  * Crowdsales have a start and end timestamps, where investors can make
118  * token purchases and the crowdsale will assign them tokens based
119  * on a token per ETH rate. Funds collected are forwarded to a wallet
120  * as they arrive.
121  */
122 contract Crowdsale is CrowdsaleBase {
123 
124   uint256 public rate;
125 
126   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _controller) public
127     CrowdsaleBase(_startTime, _wallet, _controller)
128   {
129     require(_endTime >= _startTime);
130     require(_rate > 0);
131 
132     endTime = _endTime;
133     rate = _rate;
134   }
135 
136 }
137 
138 /**
139  * @title TokenCappedCrowdsale
140  * @dev Extension of Crowdsale with a max amount of tokens to be bought
141  */
142 contract TokenCappedCrowdsale is Crowdsale {
143 
144   uint256 public tokenCap;
145   uint256 public totalSupply;
146 
147   function TokenCappedCrowdsale(uint256 _tokenCap) public {
148       require(_tokenCap > 0);
149       tokenCap = _tokenCap;
150   }
151 
152   function setSupply(uint256 newSupply) internal constant returns (bool) {
153     totalSupply = newSupply;
154     return tokenCap >= totalSupply;
155   }
156 
157 }
158 
159 contract SGPayPresale is TokenCappedCrowdsale {
160 
161 
162   function SGPayPresale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address controller, uint256 _cap)
163     Crowdsale(_startTime, _endTime, _rate, _wallet, controller)
164     TokenCappedCrowdsale(_cap)
165   {
166 
167   }
168 
169   function buyTokens(address beneficiary) public payable {
170     uint256 tokens = _buyTokens(beneficiary, rate);
171     if(!setSupply(totalSupply.add(tokens))) revert();
172   }
173 
174   function changeRate(uint256 _newValue) public onlyController {
175     rate = _newValue;
176   }
177 
178   // fallback function can be used to buy tokens
179   function () external payable {
180     buyTokens(msg.sender);
181   }
182 }