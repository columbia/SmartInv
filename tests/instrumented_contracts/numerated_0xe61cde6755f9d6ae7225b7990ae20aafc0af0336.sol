1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) constant returns (uint256);
4   function transfer(address to, uint256 value) returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 contract ERC20 is ERC20Basic {
13   function allowance(address owner, address spender) constant returns (uint256);
14   function transferFrom(address from, address to, uint256 value) returns (bool);
15   function approve(address spender, uint256 value) returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal constant returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 
49 }
50 
51 /**
52  * @title Contract for object that have an owner
53  */
54 contract Owned {
55     /**
56      * Contract owner address
57      */
58     address public owner;
59 
60     /**
61      * @dev Delegate contract to another person
62      * @param _owner New owner address
63      */
64     function setOwner(address _owner) onlyOwner
65     { owner = _owner; }
66 
67     /**
68      * @dev Owner check modifier
69      */
70     modifier onlyOwner { if (msg.sender != owner) throw; _; }
71 }
72 
73 contract TRMCrowdsale is Owned {
74     using SafeMath for uint;
75 
76     event Print(string _message, address _msgSender);
77 
78     uint public ETHUSD = 100000; //in cent
79     address manager = 0xf5c723B7Cc90eaA3bEec7B05D6bbeBCd9AFAA69a;
80     address ETHUSDdemon;
81     address public multisig = 0xc2CDcE18deEcC1d5274D882aEd0FB082B813FFE8;
82     address public addressOfERC20Token = 0x8BeF0141e8D078793456C4b74f7E60640f618594;
83     ERC20 public token;
84 
85     uint public startICO = now;
86     uint public endICO = 1519776000; // Wed, 28 Feb 2018 00:00:00 GMT
87     uint public endPostICO = 1522454400; //  Sat, 31 Mar 2018 00:00:00 GMT
88 
89     uint public tokenIcoUsdCentPrice = 550;
90     uint public tokenPostIcoUsdCentPrice = 650;
91 
92     uint public bonusWeiAmount = 29900000000000000000; //29.9 ETH
93     uint public smallBonusPercent = 27;
94     uint public bigBonusPercent = 37;
95 
96 
97     function TRMCrowdsale(){
98         owner = msg.sender;
99         token = ERC20(addressOfERC20Token);
100         ETHUSDdemon = msg.sender;
101 
102     }
103 
104     function tokenBalance() constant returns (uint256) {
105         return token.balanceOf(address(this));
106     }
107 
108  
109     function setAddressOfERC20Token(address _addressOfERC20Token) onlyOwner {
110         addressOfERC20Token = _addressOfERC20Token;
111         token = ERC20(addressOfERC20Token);
112 
113     }
114 
115     function transferToken(address _to, uint _value) returns (bool) {
116         require(msg.sender == manager);
117         return token.transfer(_to, _value);
118     }
119 
120     function() payable {
121         doPurchase();
122     }
123 
124     function doPurchase() payable {
125         require(now >= startICO && now < endPostICO);
126 
127         require(msg.value > 0);
128 
129         uint sum = msg.value;
130 
131         uint tokensAmount;
132 
133         if(now < endICO){
134             tokensAmount = sum.mul(ETHUSD).div(tokenIcoUsdCentPrice).div(10000000000);
135         } else {
136             tokensAmount = sum.mul(ETHUSD).div(tokenPostIcoUsdCentPrice).div(10000000000);
137         }
138 
139 
140         //Bonus
141         if(sum < bonusWeiAmount){
142            tokensAmount = tokensAmount.mul(100+smallBonusPercent).div(100);
143         } else{
144            tokensAmount = tokensAmount.mul(100+bigBonusPercent).div(100);
145         }
146 
147         if(tokenBalance() > tokensAmount){
148             require(token.transfer(msg.sender, tokensAmount));
149             multisig.transfer(msg.value);
150         } else {
151             manager.transfer(msg.value);
152             Print("Tokens will be released manually", msg.sender);
153         }
154 
155 
156     }
157 
158     function setETHUSD( uint256 _newPrice ) {
159         require((msg.sender == ETHUSDdemon)||(msg.sender == manager));
160         ETHUSD = _newPrice;
161     }
162 
163     function setBonus( uint256 _bonusWeiAmount, uint256 _smallBonusPercent, uint256 _bigBonusPercent ) {
164         require(msg.sender == manager);
165 
166         bonusWeiAmount = _bonusWeiAmount;
167         smallBonusPercent = _smallBonusPercent;
168         bigBonusPercent = _bigBonusPercent;
169     }
170     
171     function setETHUSDdemon(address _ETHUSDdemon) 
172     { 
173         require(msg.sender == manager);
174         ETHUSDdemon = _ETHUSDdemon; 
175         
176     }
177 
178 }