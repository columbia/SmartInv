1 pragma solidity 0.4.24;
2  
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a / b;
25     }
26 
27     /**
28      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36      * @dev Adds two numbers, throws on overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 /**
46  * @title Token
47  * @dev Implemented token interface
48  */
49 contract Token {
50     function transferSoldToken(address _contractAddr, address _to, uint256 _value) public returns(bool);
51     function balanceOf(address who) public view returns (uint256);
52     function totalSupply() public view returns (uint256);
53 }
54 contract WhiteList {
55 	function register(address _address) public;
56 	function unregister(address _address) public;
57 	function isRegistered(address _address) public view returns(bool);	
58 }
59 /**
60  * @title BtradeIcoSale
61  * @dev Smart contract for ico sale
62  */
63 contract PriIcoSale2 {
64     using SafeMath for uint256;  // use SafeMath
65     
66     address public owner;              // BtradeIcoSale creator
67     address public beneficiary;        // After ico end, send to address
68     uint public fundingEthGoal;        // Goal funding ethereum amount
69     uint public raisedEthAmt;          // Funded ethereum amout
70     uint public totalSoldTokenCount;   // Sold total token count
71     uint public pricePerEther;         // Percentage of token per ethereum
72     
73     Token public tokenReward;          // ERC20 based token address
74 	WhiteList public whiteListMge;     // Whitelist manage contract address
75 	
76     bool enableWhiteList = false;      // check whitelist flag
77     bool public icoProceeding = false; // Whether ico is in progress
78     
79     mapping(address => uint256) public funderEthAmt;
80     
81     event ResistWhiteList(address funder, bool isRegist); // white list resist event
82     event UnregisteWhiteList(address funder, bool isRegist); // white list remove event
83     event FundTransfer(address backer, uint amount, bool isContribution); // Investment Event
84     event StartICO(address owner, bool isStart);
85 	event CloseICO(address recipient, uint totalAmountRaised); // ico close event
86     event ReturnExcessAmount(address funder, uint amount);
87     
88     /**
89      * Constructor function
90      * Setup the owner
91      */
92     function PriIcoSale2(address _sendAddress, uint _goalEthers, uint _dividendRate, address _tokenAddress, address _whiteListAddress) public {
93         require(_sendAddress != address(0));
94         require(_tokenAddress != address(0));
95         require(_whiteListAddress != address(0));
96         
97         owner = msg.sender; // set owner
98         beneficiary = _sendAddress; // set beneficiary 
99         fundingEthGoal = _goalEthers * 1 ether; // set goal ethereu
100         pricePerEther = _dividendRate; // set price per ether
101         
102         tokenReward = Token(_tokenAddress); // set token address
103         whiteListMge = WhiteList(_whiteListAddress); // set whitelist address
104         
105     }
106     /**
107      * Start ICO crowdsale.
108      */
109     function startIco() public {
110         require(msg.sender == owner);
111         require(!icoProceeding);
112         icoProceeding = true;
113 		emit StartICO(msg.sender, true);
114     }
115     /**
116      * Close ICO crowdsale.
117      */
118     function endIco() public {
119         require(msg.sender == owner);
120         require(icoProceeding);
121         icoProceeding = false;
122         emit CloseICO(beneficiary, raisedEthAmt);
123     }
124     /**
125      * Check whiteList.
126      */
127     function setEnableWhiteList(bool _flag) public {
128         require(msg.sender == owner);
129         require(enableWhiteList != _flag);
130         enableWhiteList = _flag;
131     }
132     /**
133      * Resist White list for to fund
134      * @param _funderAddress the address of the funder
135      */
136     function resistWhiteList(address _funderAddress) public {
137         require(msg.sender == owner);
138         require(_funderAddress != address(0));		
139 		require(!whiteListMge.isRegistered(_funderAddress));
140 		
141 		whiteListMge.register(_funderAddress);
142         emit ResistWhiteList(_funderAddress, true);
143     }
144     function removeWhiteList(address _funderAddress) public {
145         require(msg.sender == owner);
146         require(_funderAddress != address(0));
147         require(whiteListMge.isRegistered(_funderAddress));
148         
149         whiteListMge.unregister(_funderAddress);
150         emit UnregisteWhiteList(_funderAddress, false);
151     }
152     /**
153      * Fallback function
154      * The function without name is the default function that is called whenever anyone sends funds to a contract
155      */
156     function () public payable {
157         require(icoProceeding);
158         require(raisedEthAmt < fundingEthGoal);
159         require(msg.value >= 0.1 ether); // Minimum deposit amount
160         if (enableWhiteList) {
161             require(whiteListMge.isRegistered(msg.sender));
162         }
163         
164         uint amount = msg.value; // Deposit amount
165         uint remainToGoal = fundingEthGoal - raisedEthAmt;
166         uint returnAmt = 0; // Amount to return when the goal is exceeded
167         if (remainToGoal < amount) {
168             returnAmt = msg.value.sub(remainToGoal);
169             amount = remainToGoal;
170         }
171         
172         // Token quantity calculation and token transfer, if excess amount is exceeded, it is sent to investor
173         uint tokenCount = amount.mul(pricePerEther);
174         if (tokenReward.transferSoldToken(address(this), msg.sender, tokenCount)) {
175             raisedEthAmt = raisedEthAmt.add(amount);
176             totalSoldTokenCount = totalSoldTokenCount.add(tokenCount);
177             funderEthAmt[msg.sender] = funderEthAmt[msg.sender].add(amount);
178             emit FundTransfer(msg.sender, amount, true);
179             
180             // The amount above the target amount is returned.
181             if (returnAmt > 0) {
182                 msg.sender.transfer(returnAmt);
183                 icoProceeding = false; // ICO close
184                 emit ReturnExcessAmount(msg.sender, returnAmt);
185             }
186         }
187     }
188     /**
189      * Check if goal was reached
190      *
191      * Checks if the goal or time limit has been reached and ends the campaign
192      */
193     function checkGoalReached() public {
194         require(msg.sender == owner);
195         if (raisedEthAmt >= fundingEthGoal){
196             safeWithdrawal();
197         }
198         icoProceeding = false;
199     }
200     /**
201      * Withdraw the funds
202      */
203     function safeWithdrawal() public {
204         require(msg.sender == owner);
205         beneficiary.transfer(address(this).balance);
206         emit FundTransfer(beneficiary, address(this).balance, false);
207     }
208 }