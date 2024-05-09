1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b <= a);
14     return a - b;
15   }
16   function add(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a + b;
18     assert(c >= a);
19     return c;
20   }
21 }
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public admin;
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() public {
34     admin = msg.sender;
35   }
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == admin);
41     _;
42   }
43 }
44 /**
45  * @title Crowdsale
46  * @dev Crowdsale is a base contract for managing a token crowdsale.
47  * Crowdsales have a start and end timestamps, where investors can make
48  * token purchases and the crowdsale will assign them tokens based
49  * on a token per ETH rate. Funds collected are forwarded to a wallet
50  * as they arrive.
51  */
52  contract Crowdsale {
53   using SafeMath for uint256;
54   // start and end timestamps where investments are allowed (both inclusive)
55   uint256 public startTime;
56   uint256 public endTime;
57   // address where funds are collected
58   address public wallet;
59   // how many token units a buyer gets per wei
60   uint256 public rate;
61   // amount of raised money in wei
62   uint256 public weiRaised;
63   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
64     require(_startTime >= now);
65     require(_endTime >= _startTime);
66     require(_rate > 0);
67     require(_wallet != 0x0);
68     startTime = _startTime;
69     endTime = _endTime;
70     rate = _rate;
71     wallet = 0x00b95a5d838f02b12b75be562abf7ee0100410922b;
72   }
73   // @return true if the transaction can buy tokens
74   function validPurchase() internal constant returns (bool) {
75     bool withinPeriod = now >= startTime && now <= endTime;
76     bool nonZeroPurchase = msg.value != 0;
77     return withinPeriod && nonZeroPurchase;
78   }
79   // @return true if the transaction can mint tokens
80   function validMintPurchase(uint256 _value) internal constant returns (bool) {
81     bool withinPeriod = now >= startTime && now <= endTime;
82     bool nonZeroPurchase = _value != 0;
83     return withinPeriod && nonZeroPurchase;
84   }
85   // @return true if crowdsale event has ended
86   function hasEnded() public constant returns (bool) {
87     return now > endTime;
88   }
89 }
90 /**
91  * @title CappedCrowdsale
92  * @dev Extension of Crowdsale with a max amount of funds raised
93  */
94  contract CappedCrowdsale is Crowdsale {
95   using SafeMath for uint256;
96   uint256 public cap;
97   function CappedCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap) public
98   Crowdsale(_startTime, _endTime, _rate, _wallet)
99   {
100     require(_cap > 0);
101     cap = _cap;
102   }
103   // overriding Crowdsale#validPurchase to add extra cap logic
104   // @return true if investors can buy at the moment
105   function validPurchase() internal constant returns (bool) {
106     bool withinCap = weiRaised.add(msg.value) <= cap;
107     return super.validPurchase() && withinCap;
108   }
109   // overriding Crowdsale#validPurchase to add extra cap logic
110   // @return true if investors can mint at the moment
111   function validMintPurchase(uint256 _value) internal constant returns (bool) {
112     bool withinCap = weiRaised.add(_value) <= cap;
113     return super.validMintPurchase(_value) && withinCap;
114   }
115   // overriding Crowdsale#hasEnded to add cap logic
116   // @return true if crowdsale event has ended
117   function hasEnded() public constant returns (bool) {
118     bool capReached = weiRaised >= cap;
119     return super.hasEnded() || capReached;
120   }
121 }
122 contract HeartBoutToken {
123    function mint(address _to, uint256 _amount, string _account) public returns (bool);
124 }
125 contract HeartBoutPreICO is CappedCrowdsale, Ownable {
126     using SafeMath for uint256;
127     
128     // The token address
129     address public token;
130     uint256 public minCount;
131     function HeartBoutPreICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap, uint256 _minCount) public
132     CappedCrowdsale(_startTime, _endTime, _rate, _wallet, _cap)
133     {
134         token = 0x00f5b36df8732fb5a045bd90ab40082ab37897b841;
135         minCount = _minCount;
136     }
137     // fallback function can be used to buy tokens
138     function () payable public {}
139     // low level token purchase function
140     function buyTokens(string _account) public payable {
141         require(!stringEqual(_account, ""));
142         require(validPurchase());
143         require(msg.value >= minCount);
144         uint256 weiAmount = msg.value;
145         // calculate token amount to be created
146         uint256 tokens = weiAmount.mul(rate);
147         // Mint only message sender address
148         HeartBoutToken token_contract = HeartBoutToken(token);
149         token_contract.mint(msg.sender, tokens, _account);
150         // update state
151         weiRaised = weiRaised.add(weiAmount);
152         forwardFunds();
153     }
154     // mintTokens function
155     function mintTokens(address _to, uint256 _amount, string _account) onlyOwner public {
156         require(!stringEqual(_account, ""));
157         require(validMintPurchase(_amount));
158         require(_amount >= minCount);
159         uint256 weiAmount = _amount;
160         // calculate token amount to be created
161         uint256 tokens = weiAmount.mul(rate);
162         // Mint only message sender address
163         HeartBoutToken token_contract = HeartBoutToken(token);
164         token_contract.mint(_to, tokens, _account);
165         // update state
166         weiRaised = weiRaised.add(weiAmount);
167     }
168     // send ether to the fund collection wallet
169     // override to create custom fund forwarding mechanisms
170     function forwardFunds() internal {
171         wallet.transfer(msg.value);
172     }
173     function stringEqual(string _a, string _b) internal pure returns (bool) {
174         return keccak256(_a) == keccak256(_b);
175     }
176     // change wallet
177     function changeWallet(address _wallet) onlyOwner public {
178         wallet = _wallet;
179     }
180     // Remove contract
181     function removeContract() onlyOwner public {
182         selfdestruct(wallet);
183     }
184 }