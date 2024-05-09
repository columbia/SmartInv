1 /**
2  * Interface for defining crowdsale pricing.
3  */
4 contract PricingStrategy {
5 
6   /** Interface declaration. */
7   function isPricingStrategy() public constant returns (bool) {
8     return true;
9   }
10 
11   /** Self check if all references are correctly set.
12    *
13    * Checks that pricing strategy matches crowdsale parameters.
14    */
15   function isSane(address crowdsale) public constant returns (bool) {
16     return true;
17   }
18 
19   /**
20    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
21    *
22    *
23    * @param value - What is the value of the transaction send in as wei
24    * @param tokensSold - how much tokens have been sold this far
25    * @param weiRaised - how much money has been raised this far
26    * @param msgSender - who is the investor of this transaction
27    * @param decimals - how many decimal units the token has
28    * @return Amount of tokens the investor receives
29    */
30   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
31 }
32 
33 /*
34  * ERC20 interface
35  * see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 {
38   uint public totalSupply;
39   function balanceOf(address who) constant returns (uint);
40   function allowance(address owner, address spender) constant returns (uint);
41 
42   function transfer(address to, uint value) returns (bool ok);
43   function transferFrom(address from, address to, uint value) returns (bool ok);
44   function approve(address spender, uint value) returns (bool ok);
45   event Transfer(address indexed from, address indexed to, uint value);
46   event Approval(address indexed owner, address indexed spender, uint value);
47 }
48 
49 
50 /**
51  * Math operations with safety checks
52  */
53 contract SafeMath {
54   function safeMul(uint a, uint b) internal returns (uint) {
55     uint c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59 
60   function safeDiv(uint a, uint b) internal returns (uint) {
61     assert(b > 0);
62     uint c = a / b;
63     assert(a == b * c + a % b);
64     return c;
65   }
66 
67   function safeSub(uint a, uint b) internal returns (uint) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function safeAdd(uint a, uint b) internal returns (uint) {
73     uint c = a + b;
74     assert(c>=a && c>=b);
75     return c;
76   }
77 
78   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
79     return a >= b ? a : b;
80   }
81 
82   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
83     return a < b ? a : b;
84   }
85 
86   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
87     return a >= b ? a : b;
88   }
89 
90   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
91     return a < b ? a : b;
92   }
93 
94   function assert(bool assertion) internal {
95     if (!assertion) {
96       throw;
97     }
98   }
99 }
100 
101 
102 
103 /**
104  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
105  *
106  * Based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20, SafeMath {
110 
111   /* Token supply got increased and a new owner received these tokens */
112   event Minted(address receiver, uint amount);
113 
114   /* Actual balances of token holders */
115   mapping(address => uint) balances;
116 
117   /* approve() allowances */
118   mapping (address => mapping (address => uint)) allowed;
119 
120   /* Interface declaration */
121   function isToken() public constant returns (bool weAre) {
122     return true;
123   }
124 
125   function transfer(address _to, uint _value) returns (bool success) {
126     balances[msg.sender] = safeSub(balances[msg.sender], _value);
127     balances[_to] = safeAdd(balances[_to], _value);
128     Transfer(msg.sender, _to, _value);
129     return true;
130   }
131 
132   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
133     uint _allowance = allowed[_from][msg.sender];
134 
135     balances[_to] = safeAdd(balances[_to], _value);
136     balances[_from] = safeSub(balances[_from], _value);
137     allowed[_from][msg.sender] = safeSub(_allowance, _value);
138     Transfer(_from, _to, _value);
139     return true;
140   }
141 
142   function balanceOf(address _owner) constant returns (uint balance) {
143     return balances[_owner];
144   }
145 
146   function approve(address _spender, uint _value) returns (bool success) {
147 
148     // To change the approve amount you first have to reduce the addresses`
149     //  allowance to zero by calling `approve(_spender, 0)` if it is not
150     //  already 0 to mitigate the race condition described here:
151     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
153 
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   function allowance(address _owner, address _spender) constant returns (uint remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163 }
164 
165 //crowdsale.co referral contract for WWAM ICO
166 contract crowdsaleCoReferral is SafeMath {
167     
168     uint256 public weiRaised = 0; //Holding the number of wei invested through this referral contract
169     address public wwamICOcontractAddress = 0x59a048d31d72b98dfb10f91a8905aecda7639f13;
170     address public pricingStrategyAddress = 0xe4b9b539f047f08991a231cc1b01eb0fa1849946;
171     address public tokenAddress = 0xf13f1023cfD796FF7909e770a8DDB12d33CADC08;
172 
173     function() payable {
174         wwamICOcontractAddress.call.gas(300000).value(msg.value)();
175         weiRaised = safeAdd(weiRaised, msg.value);
176         PricingStrategy pricingStrategy = PricingStrategy(pricingStrategyAddress);
177         uint tokenAmount = pricingStrategy.calculatePrice(msg.value, 0, 0, 0, 0);
178         StandardToken token = StandardToken(tokenAddress);
179         token.transfer(msg.sender, tokenAmount);
180     }
181 }