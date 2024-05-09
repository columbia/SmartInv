1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Crowdsale
35  * @dev Crowdsale is a base contract for managing a token crowdsale.
36  * Crowdsales have a start and end timestamps, where investors can make
37  * token purchases and the crowdsale will assign them tokens based
38  * on a token per ETH rate. Funds collected are forwarded 
39  to a wallet
40  * as they arrive.
41  */
42 interface token { function transfer(address receiver, uint amount) external; }
43 
44 contract Crowdsale {
45   using SafeMath for uint256;
46 
47   // address where funds are collected
48   address public wallet;
49   // token address
50   address public addressOfTokenUsedAsReward;
51 
52   uint256 public price = 3000;
53 
54   token tokenReward;
55 
56   mapping (address => uint) public contributions;
57   mapping (uint => address) public addresses;
58   mapping (address => uint) public indexes;
59   uint public lastIndex;
60 
61   function addToList(address sender) private {
62     // if the sender is not in the list
63     if (indexes[sender] == 0) {
64       // add the sender to the list
65       lastIndex++;
66       addresses[lastIndex] = sender;
67       indexes[sender] = lastIndex;
68     }
69   }
70 
71   function getList() public view returns (address[], uint[]) {
72     address[] memory _addrs = new address[](lastIndex);
73     uint[] memory _contributions = new uint[](lastIndex);
74 
75     for (uint i = 1; i <= lastIndex; i++) {
76       _addrs[i-1] = addresses[i];
77       _contributions[i-1] = contributions[addresses[i]];
78     }
79     return (_addrs, _contributions);
80   }
81   
82 
83   // amount of raised money in wei
84   uint256 public weiRaised;
85 
86   /**
87    * event for token purchase logging
88    * @param purchaser who paid for the tokens
89    * @param beneficiary who got the tokens
90    * @param value weis paid for purchase
91    * @param amount amount of tokens purchased
92    */
93   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
94 
95 
96   constructor () public {
97     //You will change this to your wallet where you need the ETH 
98     wallet = 0xbACa637033CfC458505b6c694184DeB1d1294a94;
99     //Here will come the checksum address we got
100     addressOfTokenUsedAsReward = 0xb50902BA2F7f71B203e44bf766f4A5cee98F45Ed  ;
101     tokenReward = token(addressOfTokenUsedAsReward);
102   }
103 
104   bool public started = true;
105 
106   function endIco(address[] _winners) public {
107     require(msg.sender == wallet && started == true);
108 
109     uint _100percent = address(this).balance;
110 
111     uint _11percent = _100percent.mul(11).div(100);
112     uint _89percent = _100percent.mul(89).div(100);
113 
114     uint _toEachWinner = _89percent.div(_winners.length);
115 
116     wallet.transfer(_11percent);
117 
118     for (uint i = 0; i < _winners.length; i++) {
119       _winners[i].transfer(_toEachWinner);
120     }
121     started = false;
122   }
123   
124   function setPrice(uint256 _price) public {
125     require(msg.sender == wallet);
126     price = _price;
127   }
128 
129   function changeWallet(address _wallet) public {
130     require(msg.sender == wallet);
131     wallet = _wallet;
132   }
133 
134 
135   // fallback function can be used to buy tokens
136   function () payable public {
137     buyTokens(msg.sender);
138   }
139 
140   // low level token purchase function
141   function buyTokens(address beneficiary) payable public {
142     require(beneficiary != 0x0);
143     require(validPurchase());
144 
145     // size of code at target address
146     uint codeLength;
147 
148     // get the length of code at the sender address
149     assembly {
150       codeLength := extcodesize(beneficiary)
151     }
152 
153     // don't allow contracts to deposit ether
154     require(codeLength == 0);
155 
156     uint256 weiAmount = msg.value;
157 
158 
159     // calculate token amount to be sent
160     uint256 tokens = (weiAmount) * price;//weiamount * price 
161     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;
162     //weiamount * price 
163 
164     // update state
165     weiRaised = weiRaised.add(weiAmount);
166 
167     contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
168     addToList(beneficiary);
169     
170     tokenReward.transfer(beneficiary, tokens);
171     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
172   }
173 
174   // @return true if the transaction can buy tokens
175   function validPurchase() internal constant returns (bool) {
176     bool withinPeriod = started;
177     bool nonZeroPurchase = msg.value != 0;
178     return withinPeriod && nonZeroPurchase;
179   }
180 
181   function withdrawTokens(uint256 _amount) public {
182     require(msg.sender == wallet);
183     tokenReward.transfer(wallet, _amount);
184   }
185 }