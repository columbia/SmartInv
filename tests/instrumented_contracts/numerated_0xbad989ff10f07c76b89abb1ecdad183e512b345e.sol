1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 contract BBDToken {
73     function totalSupply() constant returns (uint256);
74     function balanceOf(address _owner) constant returns (uint256 balance);
75     function transfer(address _to, uint256 _value) returns (bool);
76 
77     function creationRateOnTime() constant returns (uint256);
78     function creationMinCap() constant returns (uint256);
79     function transferToExchange(address _from, uint256 _value) returns (bool);
80     function buy(address _beneficiary) payable;
81 }
82 
83 /**
84     Exchange for BlockChain Board Of Derivatives Token.
85  */
86 contract BBDExchange is Ownable {
87     using SafeMath for uint256;
88 
89     uint256 public constant startTime = 1506844800; //Sunday, 1 October 2017 08:00:00 GMT
90     uint256 public constant endTime = 1509523200;  // Wednesday, 1 November 2017 08:00:00 GMT
91 
92     BBDToken private bbdToken;
93 
94     // Events
95     event LogSell(address indexed _seller, uint256 _value, uint256 _amount);
96     event LogBuy(address indexed _purchaser, uint256 _value, uint256 _amount);
97 
98     // Check if min cap was archived.
99     modifier onlyWhenICOReachedCreationMinCap() {
100         require(bbdToken.totalSupply() >= bbdToken.creationMinCap());
101         _;
102     }
103 
104     function() payable {}
105 
106     function Exchange(address bbdTokenAddress) {
107         bbdToken = BBDToken(bbdTokenAddress);
108     }
109 
110     // Current exchange rate for BBD
111     function exchangeRate() constant returns (uint256){
112         return bbdToken.creationRateOnTime().mul(100).div(93); // 93% of price on current contract sale
113     }
114 
115     // Number of BBD tokens on exchange
116     function exchangeBBDBalance() constant returns (uint256){
117         return bbdToken.balanceOf(this);
118     }
119 
120     // Max number of BBD tokens on exchange to sell
121     function maxSell() constant returns (uint256 valueBbd) {
122         valueBbd = this.balance.mul(exchangeRate());
123     }
124 
125     // Max value of wei for buy on exchange
126     function maxBuy() constant returns (uint256 valueInEthWei) {
127         valueInEthWei = exchangeBBDBalance().div(exchangeRate());
128     }
129 
130     // Check if sell is possible
131     function checkSell(uint256 _valueBbd) constant returns (bool isPossible, uint256 valueInEthWei) {
132         valueInEthWei = _valueBbd.div(exchangeRate());
133         isPossible = this.balance >= valueInEthWei ? true : false;
134     }
135 
136     // Check if buy is possible
137     function checkBuy(uint256 _valueInEthWei) constant returns (bool isPossible, uint256 valueBbd) {
138         valueBbd = _valueInEthWei.mul(exchangeRate());
139         isPossible = exchangeBBDBalance() >= valueBbd ? true : false;
140     }
141 
142     // Sell BBD
143     function sell(uint256 _valueBbd) onlyWhenICOReachedCreationMinCap external {
144         require(_valueBbd > 0);
145         require(now >= startTime);
146         require(now <= endTime);
147         require(_valueBbd <= bbdToken.balanceOf(msg.sender));
148 
149         uint256 checkedEth = _valueBbd.div(exchangeRate());
150         require(checkedEth <= this.balance);
151 
152         //Transfer BBD to exchange and ETH to user 
153         require(bbdToken.transferToExchange(msg.sender, _valueBbd));
154         msg.sender.transfer(checkedEth);
155 
156         LogSell(msg.sender, checkedEth, _valueBbd);
157     }
158 
159     // Buy BBD
160     function buy() onlyWhenICOReachedCreationMinCap payable external {
161         require(msg.value != 0);
162         require(now >= startTime);
163         require(now <= endTime);
164 
165         uint256 checkedBBDTokens = msg.value.mul(exchangeRate());
166         require(checkedBBDTokens <= exchangeBBDBalance());
167 
168         //Transfer BBD to user. 
169         require(bbdToken.transfer(msg.sender, checkedBBDTokens));
170 
171         LogBuy(msg.sender, msg.value, checkedBBDTokens);
172     }
173 
174     // Close Exchange
175     function close() onlyOwner {
176         require(now >= endTime);
177 
178         //Transfer BBD and ETH to owner
179         require(bbdToken.transfer(owner, exchangeBBDBalance()));
180         owner.transfer(this.balance);
181     }
182 }