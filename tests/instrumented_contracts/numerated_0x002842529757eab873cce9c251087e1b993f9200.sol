1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract StupidToken {
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
36 }
37 
38 
39 contract StupidCrowdsale {
40 
41     using SafeMath for uint256;
42 
43     StupidToken public token;
44 
45     //Tokens per 1 eth
46     uint256 constant public rate = 10000;
47     
48     uint256 constant public goal = 20000000 * (10 ** 18);
49     uint256 public startTime;
50     uint256 public endTime;
51     uint256 public weiRaised;
52     uint256 public tokensSold;
53 
54     bool public crowdsaleActive = true;
55 
56     address public wallet;
57     address public tokenOwner;
58 
59     mapping(address => uint256) balances;
60 
61     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
62 
63     /**
64     * @param _startTime Unix timestamp
65     * @param _endTime Unix timestamp
66     * @param _wallet Ethereum address to which the invested funds are forwarded
67     * @param _token Address of the token that will be rewarded for the investors
68     * @param _tokenOwner Address of the token owner who can execute restricted functions
69     */
70     function StupidCrowdsale(uint256 _startTime, uint256 _endTime, address _wallet, address _token, address _tokenOwner) public {
71         require(_startTime < _endTime);
72         require(_wallet != address(0));
73         require(_token != address(0));
74         require(_tokenOwner != address(0));
75 
76         startTime = _startTime;
77         endTime = _endTime;
78 
79         wallet = _wallet;
80         tokenOwner = _tokenOwner;
81         token = StupidToken(_token);
82     }
83 
84     // fallback function can be used to buy tokens
85     function () external payable {
86         buyTokens(msg.sender);
87     }
88 
89     // low level token purchase function
90     function buyTokens(address investor) public payable {
91         require(investor != address(0));
92         require(now >= startTime && now <= endTime);
93         require(crowdsaleActive);
94         require(msg.value != 0);
95 
96         uint256 weiAmount = msg.value;
97 
98         // calculate token amount to be created
99         uint256 tokens = weiAmount.mul(rate);
100 
101         require(tokensSold.add(tokens) <= goal);
102 
103         // update state
104         weiRaised = weiRaised.add(weiAmount);
105         tokensSold = tokensSold.add(tokens);
106         balances[investor] = balances[investor].add(weiAmount);
107 
108         assert(token.transferFrom(tokenOwner, investor, tokens));
109         TokenPurchase(msg.sender, investor, weiAmount, tokens);
110 
111         wallet.transfer(msg.value);
112     }
113 
114     function setCrowdsaleActive(bool _crowdsaleActive) public {
115         require(msg.sender == tokenOwner);
116         crowdsaleActive = _crowdsaleActive;
117     }
118 
119     /**
120         * @dev Gets the balance of the specified address.
121         * @param _owner The address to query the the balance of.
122         * @return An uint256 representing the amount owned by the passed address.
123         */
124     function balanceOf(address _owner) external constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 }