1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 
22 /**
23  * @title ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/20
25  */
26 contract ERC20 is ERC20Basic {
27     function allowance(address owner, address spender) public view returns (uint256);
28     function transferFrom(address from, address to, uint256 value) public returns (bool);
29     function approve(address spender, uint256 value) public returns (bool);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 
34 
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         assert(c / a == b);
51         return c;
52     }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // assert(b > 0); // Solidity automatically throws when dividing by 0
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61         return c;
62     }
63 
64   /**
65   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         assert(c >= a);
78         return c;
79     }
80 }
81 
82 
83 /**
84  * @title Crowdsale
85  * @dev Crowdsale is a base contract for managing a token crowdsale,
86  * allowing investors to purchase tokens with ether. This contract implements
87  * such functionality in its most fundamental form and can be extended to provide additional
88  * functionality and/or custom behavior.
89  * The external interface represents the basic interface for purchasing tokens, and conform
90  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
91  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
92  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
93  * behavior.
94  */
95 contract Crowdsale {
96     using SafeMath for uint256;
97 
98     // The token being sold
99     ERC20 public token;
100 
101     // Address where funds are collected
102     address public fundWallet;
103     
104     // the admin of the crowdsale
105     address public admin;
106 
107     // Exchange rate:  1 eth = 10,000 TAUR
108     uint256 public rate = 10000;
109 
110     // Amount of wei raised
111     uint256 public amountRaised;
112 
113     // Crowdsale Status
114     bool public crowdsaleOpen;
115 
116     // Crowdsale Cap
117     uint256 public cap;
118 
119   /**
120    * Event for token purchase logging
121    * @param purchaser who paid for the tokens
122    * @param value weis paid for purchase
123    * @param amount amount of tokens purchased
124    */
125     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
126 
127   /**
128    * @param _token - Address of the token being sold
129    * @param _fundWallet - THe wallet where ether will be collected
130    */
131     function Crowdsale(ERC20 _token, address _fundWallet) public {
132         require(_token != address(0));
133         require(_fundWallet != address(0));
134 
135         fundWallet = _fundWallet;
136         admin = msg.sender;
137         token = _token;
138         crowdsaleOpen = true;
139         cap = 20000 * 1 ether;
140     }
141 
142   // -----------------------------------------
143   // Crowdsale external interface
144   // -----------------------------------------
145 
146   /**
147    * @dev fallback function ***DO NOT OVERRIDE***
148    */
149     function () external payable {
150         buyTokens();
151     }
152 
153   /**
154    * @dev low level token purchase ***DO NOT OVERRIDE***
155    */
156     function buyTokens() public payable {
157 
158         // do necessary checks
159         require(crowdsaleOpen);
160         require(msg.sender != address(0));
161         require(msg.value != 0);
162         require(amountRaised.add(msg.value) <= cap);
163         
164         // calculate token amount to be created
165         uint256 tokens = (msg.value).mul(rate);
166 
167         // update state
168         amountRaised = amountRaised.add(msg.value);
169 
170         // transfer tokens to buyer
171         token.transfer(msg.sender, tokens);
172 
173         // transfer eth to fund wallet
174         fundWallet.transfer(msg.value);
175 
176         emit TokenPurchase (msg.sender, msg.value, tokens);
177     }
178 
179     function lockRemainingTokens() onlyAdmin public {
180         token.transfer(admin, token.balanceOf(address(this)));
181     }
182 
183     function setRate(uint256 _newRate) onlyAdmin public {
184         rate = _newRate;    
185     }
186     
187     function setFundWallet(address _fundWallet) onlyAdmin public {
188         require(_fundWallet != address(0));
189         fundWallet = _fundWallet; 
190     }
191 
192     function setCrowdsaleOpen(bool _crowdsaleOpen) onlyAdmin public {
193         crowdsaleOpen = _crowdsaleOpen;
194     }
195 
196     function getEtherRaised() view public returns (uint256){
197         return amountRaised / 1 ether;
198     }
199 
200     function capReached() public view returns (bool) {
201         return amountRaised >= cap;
202     }
203 
204     modifier onlyAdmin {
205         require(msg.sender == admin);
206         _;
207     }  
208 
209 }