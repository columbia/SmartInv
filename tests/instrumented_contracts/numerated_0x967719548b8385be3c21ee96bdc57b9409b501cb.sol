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
11     function balanceOf(address _who) public view returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool);
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14 }
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23     address public owner;
24 
25 
26     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
27 
28 
29     /**
30      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31      * account.
32      */
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     /**
46      * @dev Allows the current owner to transfer control of the contract to a newOwner.
47      * @param _newOwner The address to transfer ownership to.
48      */
49     function transferOwnership(address _newOwner) public onlyOwner {
50         require(_newOwner != address(0));
51         emit OwnershipTransferred(owner, _newOwner);
52         owner = _newOwner;
53     }
54 
55     /**
56      * @dev Rescue compatible ERC20Basic Token
57      *
58      * @param _token ERC20Basic The address of the token contract
59      */
60     function rescueTokens(ERC20Basic _token) external onlyOwner {
61         uint256 balance = _token.balanceOf(this);
62         assert(_token.transfer(owner, balance));
63     }
64 
65     /**
66      * @dev Withdraw Ether
67      */
68     function withdrawEther() external onlyOwner {
69         owner.transfer(address(this).balance);
70     }
71 }
72 
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79 
80     /**
81      * @dev Multiplies two numbers, throws on overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
84         if (a == 0) {
85             return 0;
86         }
87         c = a * b;
88         assert(c / a == b);
89         return c;
90     }
91 
92     /**
93      * @dev Integer division of two numbers, truncating the quotient.
94      */
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         // assert(b > 0); // Solidity automatically throws when dividing by 0
97         // uint256 c = a / b;
98         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99         return a / b;
100     }
101 
102     /**
103      * @dev Adds two numbers, throws on overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106         c = a + b;
107         assert(c >= a);
108         return c;
109     }
110 
111     /**
112      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         assert(b <= a);
116         return a - b;
117     }
118 }
119 
120 
121 /**
122  * @title Sell ERC20Basic Tokens
123  */
124 contract SellERC20BasicTokens is Ownable {
125     using SafeMath for uint256;
126 
127     // Token
128     ERC20Basic public token;
129     uint256 etherDecimals = 18;
130     uint256 tokenDecimals;
131     uint256 decimalDiff;
132 
133     // Ether Minimum
134     uint256 public etherMinimum;
135 
136     // RATE
137     uint256 public rate;
138     uint256 public depositRate;
139 
140     // Deposit
141     uint256 public deposit;
142     
143     // Wallet
144     address public wallet;
145 
146 
147     /**
148      * @dev Constructor
149      *
150      * @param _token address
151      * @param _tokenDecimals uint256
152      * @param _etherMinimum uint256
153      * @param _rate uint256
154      * @param _depositRate uint256
155      * @param _wallet address
156      */
157     constructor(ERC20Basic _token, uint256 _tokenDecimals, uint256 _etherMinimum, uint256 _rate, uint256 _depositRate, address _wallet) public {
158         token = _token;
159         tokenDecimals = _tokenDecimals;
160         decimalDiff = etherDecimals.sub(_tokenDecimals);
161         etherMinimum = _etherMinimum;
162         rate = _rate;
163         depositRate = _depositRate;
164         wallet = _wallet;
165     }
166 
167     /**
168      * @dev receive ETH and send tokens
169      */
170     function () public payable {
171         // minimum limit
172         uint256 weiAmount = msg.value;
173         require(weiAmount >= etherMinimum.mul(10 ** etherDecimals));
174 
175         // make sure: onsale > 0
176         uint256 balance = token.balanceOf(address(this));
177         uint256 onsale = balance.sub(deposit);
178         require(onsale > 0);
179 
180         // token amount
181         uint256 tokenBought = weiAmount.mul(rate).div(10 ** decimalDiff);
182         uint256 tokenDeposit = weiAmount.mul(depositRate).div(10 ** decimalDiff);
183         uint256 tokenAmount = tokenBought.add(tokenDeposit);
184         require(tokenAmount > 0);
185 
186         // transfer tokens
187         if (tokenAmount <= onsale) {
188             assert(token.transfer(msg.sender, tokenBought));
189         } else {
190             uint256 weiExpense = onsale.div(rate + depositRate);
191             tokenBought = weiExpense.mul(rate);
192             tokenDeposit = onsale.sub(tokenBought);
193 
194             // transfer tokens
195             assert(token.transfer(msg.sender, tokenBought));
196 
197             // refund
198             msg.sender.transfer(weiAmount - weiExpense.mul(10 ** decimalDiff));
199         }
200 
201         // deposit +
202         deposit = deposit.add(tokenDeposit);
203 
204         // onsale -
205         onsale = token.balanceOf(address(this)).sub(deposit);
206 
207         // transfer eth back to owner
208         owner.transfer(address(this).balance);
209     }
210 
211     /**
212      * @dev Send Token
213      * 
214      * @param _receiver address
215      * @param _amount uint256
216      */
217     function sendToken(address _receiver, uint256 _amount) external {
218         require(msg.sender == wallet);
219         require(_amount <= deposit);
220         assert(token.transfer(_receiver, _amount));
221         deposit = deposit.sub(_amount);
222     }
223 
224     /**
225      * @dev Set Rate
226      * 
227      * @param _rate uint256
228      * @param _depositRate uint256
229      */
230     function setRate(uint256 _rate, uint256 _depositRate) external onlyOwner {
231         rate = _rate;
232         depositRate = _depositRate;
233     }
234 
235     /**
236      * @dev Set Wallet
237      * 
238      * @param _wallet address
239      */
240     function setWallet(address _wallet) external onlyOwner {
241         wallet = _wallet;
242     }
243 }