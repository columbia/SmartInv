1 pragma solidity ^0.4.18;
2 
3 contract FullERC20 {
4   event Transfer(address indexed from, address indexed to, uint256 value);
5   event Approval(address indexed owner, address indexed spender, uint256 value);
6   
7   uint256 public totalSupply;
8   uint8 public decimals;
9 
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15 }
16 
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 
81 }
82 
83 contract Crowdsale is Ownable {
84     using SafeMath for uint256;
85 
86 
87     // start and end timestamps where investments are allowed (both inclusive)
88     uint256 public startTime;
89     uint256 public endTime;
90 
91     // address where funds are collected
92     address public wallet;
93     FullERC20 public token;
94 
95     // token amount per 1 ETH
96     // eg. 40000000000 = 2500000 tokens.
97     uint256 public rate; 
98 
99     // amount of raised money in wei
100     uint256 public weiRaised;
101     uint256 public tokensPurchased;
102 
103     /**
104     * event for token purchase logging
105     * @param purchaser who paid for the tokens
106     * @param value weis paid for purchase
107     * @param amount amount of tokens purchased
108     */
109     event TokenPurchased(address indexed purchaser, uint256 value, uint256 amount);
110 
111     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) public {
112         require(_startTime >= now);
113         require(_endTime >= _startTime);
114         require(_rate > 0);
115         require(_wallet != address(0));
116         require(_token != address(0));
117 
118         startTime = _startTime;
119         endTime = _endTime;
120         rate = _rate;
121         wallet = _wallet;
122         token = FullERC20(_token);
123     }
124 
125     // fallback function can be used to buy tokens
126     function () public payable {
127         purchase();
128     }
129 
130     function purchase() public payable {
131         require(msg.sender != address(0));
132         require(validPurchase());
133 
134         uint256 weiAmount = msg.value;
135 
136         // calculate token amount to be created
137         uint256 tokens = weiAmount.div(rate);
138         require(tokens > 0);
139         require(token.balanceOf(this) > tokens);
140 
141         // update state
142         weiRaised = weiRaised.add(weiAmount);
143         tokensPurchased = tokensPurchased.add(tokens);
144 
145         TokenPurchased(msg.sender, weiAmount, tokens);
146         assert(token.transfer(msg.sender, tokens));
147         wallet.transfer(msg.value);
148     }
149 
150     // @return true if the transaction can buy tokens
151     function validPurchase() internal view returns (bool) {
152         bool withinPeriod = now >= startTime && now <= endTime;
153         bool nonZeroPurchase = msg.value != 0;
154         return withinPeriod && nonZeroPurchase;
155     }
156 
157     // @return true if crowdsale event has ended
158     function hasEnded() public view returns (bool) {
159         return now > endTime;
160     }
161 
162     // @dev updates the rate
163     function updateRate(uint256 newRate) public onlyOwner {
164         rate = newRate;
165     }
166 
167     function updateTimes(uint256 _startTime, uint256 _endTime) public onlyOwner {
168         startTime = _startTime;
169         endTime = _endTime;
170     }
171 
172     // @dev returns the number of tokens available in the sale.
173     function tokensAvailable() public view returns (bool) {
174         return token.balanceOf(this) > 0;
175     }
176 
177     // @dev Ends the token sale and transfers balance of tokens
178     // and eth to owner. 
179     function endSale() public onlyOwner {
180         wallet.transfer(this.balance);
181         assert(token.transfer(wallet, token.balanceOf(this)));
182         endTime = now;
183     }
184 }