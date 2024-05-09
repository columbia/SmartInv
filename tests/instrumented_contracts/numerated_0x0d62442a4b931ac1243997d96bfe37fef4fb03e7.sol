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
28   address public owner;
29   address public oldOwner;
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44   modifier onlyOldOwner() {
45     require(msg.sender == oldOwner || msg.sender == owner);
46     _;
47   }
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     oldOwner = owner;
55     owner = newOwner;
56   }
57   function backToOldOwner() onlyOldOwner public {
58     require(oldOwner != address(0));
59     owner = oldOwner;
60   }
61 }
62 /**
63  * @title Crowdsale
64  * @dev Crowdsale is a base contract for managing a token crowdsale.
65  * Crowdsales have a start and end timestamps, where investors can make
66  * token purchases and the crowdsale will assign them tokens based
67  * on a token per ETH rate. Funds collected are forwarded to a wallet
68  * as they arrive.
69  */
70  contract Crowdsale {
71   using SafeMath for uint256;
72   // start and end timestamps where investments are allowed (both inclusive)
73   uint256 public startTime;
74   uint256 public endTime;
75   // address where funds are collected
76   address public wallet;
77   // how many token units a buyer gets per wei
78   uint256 public rate;
79   // amount of raised money in wei
80   uint256 public weiRaised;
81   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
82     require(_startTime >= now);
83     require(_endTime >= _startTime);
84     require(_rate > 0);
85     require(_wallet != 0x0);
86     startTime = _startTime;
87     endTime = _endTime;
88     rate = _rate;
89     wallet = 0x00B95A5D838F02b12B75BE562aBF7Ee0100410922b;
90   }
91   // @return true if the transaction can buy tokens
92   function validPurchase() internal constant returns (bool) {
93     bool withinPeriod = now >= startTime && now <= endTime;
94     bool nonZeroPurchase = msg.value != 0;
95     return withinPeriod && nonZeroPurchase;
96   }
97   // @return true if crowdsale event has ended
98   function hasEnded() public constant returns (bool) {
99     return now > endTime;
100   }
101 }
102 /**
103  * @title CappedCrowdsale
104  * @dev Extension of Crowdsale with a max amount of funds raised
105  */
106  contract CappedCrowdsale is Crowdsale {
107   using SafeMath for uint256;
108   uint256 public cap;
109   function CappedCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap) public
110   Crowdsale(_startTime, _endTime, _rate, _wallet)
111   {
112     require(_cap > 0);
113     cap = _cap;
114   }
115   // overriding Crowdsale#validPurchase to add extra cap logic
116   // @return true if investors can buy at the moment
117   function validPurchase() internal constant returns (bool) {
118     bool withinCap = weiRaised.add(msg.value) <= cap;
119     return super.validPurchase() && withinCap;
120   }
121   // overriding Crowdsale#hasEnded to add cap logic
122   // @return true if crowdsale event has ended
123   function hasEnded() public constant returns (bool) {
124     bool capReached = weiRaised >= cap;
125     return super.hasEnded() || capReached;
126   }
127 }
128 contract HeartBoutPreICO is CappedCrowdsale, Ownable {
129     using SafeMath for uint256;
130     
131     // The token address
132     address public token;
133     uint256 public minCount;
134     // Bind User Account and Address Wallet
135     mapping(string => address) bindAccountsAddress;
136     mapping(address => string) bindAddressAccounts;
137     string[] accounts;
138     event GetBindTokensAccountEvent(address _address, string _account);
139     function HeartBoutPreICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap, uint256 _minCount) public
140     CappedCrowdsale(_startTime, _endTime, _rate, _wallet, _cap)
141     {
142         token = 0x00305cB299cc82a8A74f8da00AFA6453741d9a15Ed;
143         minCount = _minCount;
144     }
145     // fallback function can be used to buy tokens
146     function () payable public {
147     }
148     // low level token purchase function
149     function buyTokens(string _account) public payable {
150         require(!stringEqual(_account, ""));
151         require(validPurchase());
152         require(msg.value >= minCount);
153         // throw if address was bind with another account
154         if(!stringEqual(bindAddressAccounts[msg.sender], "")) {
155             require(stringEqual(bindAddressAccounts[msg.sender], _account));
156         }
157         uint256 weiAmount = msg.value;
158         // calculate token amount to be created
159         uint256 tokens = weiAmount.mul(rate);
160         // Mint only message sender address
161         require(token.call(bytes4(keccak256("mint(address,uint256)")), msg.sender, tokens));
162         bindAccountsAddress[_account] = msg.sender;
163         bindAddressAccounts[msg.sender] = _account;
164         accounts.push(_account);
165         // update state
166         weiRaised = weiRaised.add(weiAmount);
167         forwardFunds();
168     }
169     function getEachBindAddressAccount() onlyOwner public {
170         // get transfered account and addresses
171         for (uint i = 0; i < accounts.length; i++) {
172             GetBindTokensAccountEvent(bindAccountsAddress[accounts[i]], accounts[i]);
173         }
174     }
175     function getBindAccountAddress(string _account) public constant returns (address) {
176         return bindAccountsAddress[_account];
177     }
178     function getBindAddressAccount(address _accountAddress) public constant returns (string) {
179         return bindAddressAccounts[_accountAddress];
180     }
181     // send ether to the fund collection wallet
182     // override to create custom fund forwarding mechanisms
183     function forwardFunds() internal {
184         wallet.transfer(msg.value);
185     }
186     function stringEqual(string _a, string _b) internal pure returns (bool) {
187         return keccak256(_a) == keccak256(_b);
188     }
189     // change wallet
190     function changeWallet(address _wallet) onlyOwner public {
191         wallet = _wallet;
192     }
193     // Remove contract
194     function removeContract() onlyOwner public {
195         selfdestruct(wallet);
196     }
197 }