1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) onlyOwner public {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a * b;
52         assert(a == 0 || c / a == b);
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         assert(b <= a);
65         return a - b;
66     }
67 
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         assert(c >= a);
71         return c;
72     }
73 }
74 
75 
76 contract TempusToken {
77 
78     function mint(address receiver, uint256 amount) public returns (bool success);
79 
80 }
81 
82 contract TempusPreIco is Ownable {
83     using SafeMath for uint256;
84 
85     // start and end timestamps where investments are allowed (both inclusive)
86     uint public startTime = 1512118800; //1 December 2017 09:00:00 GMT
87     uint public endTime = 1517562000; //2 February 2018 09:00:00 GMT
88 
89     //token price
90     uint public price = 0.005 ether / 1000;
91 
92     //max tokens could be sold during preico
93     uint public hardCap = 860000000;
94     uint public tokensSold = 0;
95 
96     bool public paused = false;
97 
98     address withdrawAddress1;
99     address withdrawAddress2;
100 
101     TempusToken token;
102 
103     mapping(address => bool) public sellers;
104 
105     modifier onlySellers() {
106         require(sellers[msg.sender]);
107         _;
108     }
109 
110     function TempusPreIco (address tokenAddress, address _withdrawAddress1,
111     address _withdrawAddress2) public {
112         token = TempusToken(tokenAddress);
113         withdrawAddress1 = _withdrawAddress1;
114         withdrawAddress2 = _withdrawAddress2;
115     }
116 
117     /**
118     * @dev Function that indicates whether pre ico is active or not
119     */
120     function isActive() public view returns (bool active) {
121         bool withinPeriod = now >= startTime && now <= endTime;
122         bool capIsNotMet = tokensSold < hardCap;
123         return capIsNotMet && withinPeriod && !paused;
124     }
125 
126     function() external payable {
127         buyFor(msg.sender);
128     }
129 
130     /**
131     * @dev Low-level purchase function. Purchases tokens for specified address
132     * @param beneficiary Address that will get tokens
133     */
134     function buyFor(address beneficiary) public payable {
135         require(msg.value != 0);
136         uint amount = msg.value;
137         uint tokenAmount = amount.div(price);
138         makePurchase(beneficiary, tokenAmount);
139     }
140 
141     /**
142     * @dev Function that is called by our robot to allow users
143     * to buy tonkens for various cryptos.
144     * @param beneficiary An address that will get tokens
145     * @param amount Amount of tokens that address will get
146     */
147     function externalPurchase(address beneficiary, uint amount) external onlySellers {
148         makePurchase(beneficiary, amount);
149     }
150 
151     function makePurchase(address beneficiary, uint amount) private {
152         require(beneficiary != 0x0);
153         require(isActive());
154         uint minimumTokens = 20000;
155         if(tokensSold < hardCap.sub(minimumTokens)) {
156             require(amount >= minimumTokens);
157         }
158         require(amount.add(tokensSold) <= hardCap);
159         tokensSold = tokensSold.add(amount);
160         token.mint(beneficiary, amount);
161     }
162 
163     function setPaused(bool isPaused) external onlyOwner {
164         paused = isPaused;
165     }
166 
167     /**
168     * @dev Sets address of seller robot
169     * @param seller Address of seller robot to set
170     * @param isSeller Parameter whether set as seller or not
171     */
172     function setAsSeller(address seller, bool isSeller) external onlyOwner {
173         sellers[seller] = isSeller;
174     }
175 
176     /**
177     * @dev Set start time of Pre ICO
178     * @param _startTime Start of Pre ICO (unix time)
179     */
180     function setStartTime(uint _startTime) external onlyOwner {
181         startTime = _startTime;
182     }
183 
184     /**
185     * @dev Sets end time of Pre ICO
186     * @param _endTime End time of Pre ICO (unit time)
187     */
188     function setEndTime(uint _endTime) external onlyOwner {
189         endTime = _endTime;
190     }
191 
192     /**
193     * @dev Function to get ether from contract
194     * @param amount Amount in wei to withdraw
195     */
196     function withdrawEther(uint amount) external onlyOwner {
197         withdrawAddress1.transfer(amount / 2);
198         withdrawAddress2.transfer(amount / 2);
199     }
200 
201 }