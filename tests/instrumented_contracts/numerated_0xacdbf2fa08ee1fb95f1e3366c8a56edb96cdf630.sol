1 pragma solidity ^0.4.21;
2 
3 
4 // If your investment is less than 300 ETHs. Send ETH here, this contract will
5 // transfer VNETs to you automatically. And I just make a small profit.
6 //
7 // And you can get more details via etherscan.io - "Read Contract"
8 
9 
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16     function totalSupply() public view returns (uint256);
17     function balanceOf(address _who) public view returns (uint256);
18     function transfer(address _to, uint256 _value) public returns (bool);
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20 }
21 
22 
23 /**
24  * @title Ownable
25  * @dev The Ownable contract has an owner address, and provides basic authorization control
26  * functions, this simplifies the implementation of "user permissions".
27  */
28 contract Ownable {
29     address public owner;
30 
31 
32     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
33 
34 
35     /**
36      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37      * account.
38      */
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param _newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address _newOwner) public onlyOwner {
56         require(_newOwner != address(0));
57         emit OwnershipTransferred(owner, _newOwner);
58         owner = _newOwner;
59     }
60 
61     /**
62      * @dev Rescue compatible ERC20Basic Token
63      *
64      * @param _token ERC20Basic The address of the token contract
65      */
66     function rescueTokens(ERC20Basic _token) external onlyOwner {
67         uint256 balance = _token.balanceOf(this);
68         assert(_token.transfer(owner, balance));
69     }
70 
71     /**
72      * @dev Withdraw Ether
73      */
74     function withdrawEther() external onlyOwner {
75         owner.transfer(address(this).balance);
76     }
77 }
78 
79 
80 /**
81  * @title SafeMath
82  * @dev Math operations with safety checks that throw on error
83  */
84 library SafeMath {
85 
86     /**
87      * @dev Multiplies two numbers, throws on overflow.
88      */
89     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
90         if (a == 0) {
91             return 0;
92         }
93         c = a * b;
94         assert(c / a == b);
95         return c;
96     }
97 
98     /**
99      * @dev Integer division of two numbers, truncating the quotient.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         // assert(b > 0); // Solidity automatically throws when dividing by 0
103         // uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105         return a / b;
106     }
107 
108     /**
109      * @dev Adds two numbers, throws on overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
112         c = a + b;
113         assert(c >= a);
114         return c;
115     }
116 
117     /**
118      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         assert(b <= a);
122         return a - b;
123     }
124 }
125 
126 
127 /**
128  * @title Sell Tokens
129  */
130 contract SellTokens is Ownable {
131     using SafeMath for uint256;
132 
133     ERC20Basic public token;
134 
135     uint256 decimalDiff;
136     uint256 public rate;
137     string public description;
138     string public telegram;
139 
140 
141     /**
142      * @dev Constructor
143      */
144     constructor(ERC20Basic _token, uint256 _tokenDecimals, uint256 _rate, string _description, string _telegram) public {
145         uint256 etherDecimals = 18;
146 
147         token = _token;
148         decimalDiff = etherDecimals.sub(_tokenDecimals);
149         rate = _rate;
150         description = _description;
151         telegram = _telegram;
152     }
153 
154     /**
155      * @dev receive ETH and send tokens
156      */
157     function () public payable {
158         uint256 weiAmount = msg.value;
159         uint256 tokenAmount = weiAmount.mul(rate).div(10 ** decimalDiff);
160         
161         require(tokenAmount > 0);
162         
163         assert(token.transfer(msg.sender, tokenAmount));
164         owner.transfer(address(this).balance);
165     }
166 
167     /**
168      * @dev Set Rate
169      * 
170      * @param _rate uint256
171      */
172     function setRate(uint256 _rate) external onlyOwner returns (bool) {
173         rate = _rate;
174         return true;
175     }
176 
177     /**
178      * @dev Set Description
179      * 
180      * @param _description string
181      */
182     function setDescription(string _description) external onlyOwner returns (bool) {
183         description = _description;
184         return true;
185     }
186 
187     /**
188      * @dev Set Telegram
189      * 
190      * @param _telegram string
191      */
192     function setTelegram(string _telegram) external onlyOwner returns (bool) {
193         telegram = _telegram;
194         return true;
195     }
196 }