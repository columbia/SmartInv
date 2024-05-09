1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * VNET Token Private Placement Contract
6  * 
7  * Send ETH here, and you will receive the VNET Tokens immediately.
8  * 
9  * https://vision.network
10  */
11 
12 
13 /**
14  * @title ERC20Basic
15  * @dev Simpler version of ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/179
17  */
18 contract ERC20Basic {
19     function totalSupply() public view returns (uint256);
20     function balanceOf(address _who) public view returns (uint256);
21     function transfer(address _to, uint256 _value) public returns (bool);
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 }
24 
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32     address public owner;
33 
34 
35     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
36 
37 
38     /**
39      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40      * account.
41      */
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     /**
55      * @dev Allows the current owner to transfer control of the contract to a newOwner.
56      * @param _newOwner The address to transfer ownership to.
57      */
58     function transferOwnership(address _newOwner) public onlyOwner {
59         require(_newOwner != address(0));
60         emit OwnershipTransferred(owner, _newOwner);
61         owner = _newOwner;
62     }
63 
64     /**
65      * @dev Rescue compatible ERC20Basic Token
66      *
67      * @param _token ERC20Basic The address of the token contract
68      */
69     function rescueTokens(ERC20Basic _token) external onlyOwner {
70         uint256 balance = _token.balanceOf(this);
71         assert(_token.transfer(owner, balance));
72     }
73 
74     /**
75      * @dev Withdraw Ether
76      */
77     function withdrawEther() external onlyOwner {
78         owner.transfer(address(this).balance);
79     }
80 }
81 
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89     /**
90      * @dev Multiplies two numbers, throws on overflow.
91      */
92     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
93         if (a == 0) {
94             return 0;
95         }
96         c = a * b;
97         assert(c / a == b);
98         return c;
99     }
100 
101     /**
102      * @dev Integer division of two numbers, truncating the quotient.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         // assert(b > 0); // Solidity automatically throws when dividing by 0
106         // uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108         return a / b;
109     }
110 
111     /**
112      * @dev Adds two numbers, throws on overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
115         c = a + b;
116         assert(c >= a);
117         return c;
118     }
119 
120     /**
121      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         assert(b <= a);
125         return a - b;
126     }
127 }
128 
129 
130 /**
131  * @title VNET Token Private Placement
132  */
133 contract VNETPrivatePlacement is Ownable {
134     using SafeMath for uint256;
135 
136     ERC20Basic public vnetToken;
137 
138     string public description;
139     uint256 public rate;
140     uint256 public etherMinimum;
141     uint256 public etherMaximum;
142 
143     /**
144      * @dev Constructor
145      */
146     constructor(ERC20Basic _vnetToken, string _description, uint256 _rate, uint256 _min, uint256 _max) public {
147         vnetToken = _vnetToken;
148         rate = _rate;
149         etherMinimum = _min;
150         etherMaximum = _max;
151         description = _description;
152     }
153 
154     /**
155      * @dev receive ETH and send tokens
156      */
157     function () public payable {
158         // Make sure balance > 0
159         uint256 balance = vnetToken.balanceOf(address(this));
160         require(balance > 0);
161         
162         // Minimum & Maximum Limit
163         uint256 weiAmount = msg.value;
164         require(weiAmount >= etherMinimum.mul(10 ** 18));
165         require(weiAmount <= etherMaximum.mul(10 ** 18));
166 
167         // VNET Token Amount to be send back
168         uint256 tokenAmount = weiAmount.mul(rate).div(10 ** 12);
169 
170         // Send VNET
171         if (balance >= tokenAmount) {
172             assert(vnetToken.transfer(msg.sender, tokenAmount));
173             owner.transfer(address(this).balance);
174         } else {
175             uint256 expend = balance.div(rate);
176             assert(vnetToken.transfer(msg.sender, balance));
177             msg.sender.transfer(weiAmount - expend.mul(10 ** 12));
178             owner.transfer(address(this).balance);
179         }
180     }
181 
182     /**
183      * @dev Send VNET Token
184      *
185      * @param _to address
186      * @param _amount uint256
187      */ 
188     function sendVNET(address _to, uint256 _amount) external onlyOwner {
189         assert(vnetToken.transfer(_to, _amount));
190     }
191 
192     /**
193      * @dev Set Description
194      * 
195      * @param _description string
196      */
197     function setDescription(string _description) external onlyOwner {
198         description = _description;
199     }
200     
201     /**
202      * @dev Set Rate
203      * 
204      * @param _rate uint256
205      */
206     function setRate(uint256 _rate, uint256 _min, uint256 _max) external onlyOwner {
207         rate = _rate;
208         etherMinimum = _min;
209         etherMaximum = _max;
210     }
211 }