1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * VNET Token Private Placement Contract
6  * 
7  * Send ETH here, and you will receive the VNET Tokens immediately.
8  * The minimum ivnestment limit is 300 ETH, and the accumulated maximum limit is 1000 ETH.
9  * 
10  * RATE: 1 ETH = 200,000 VNET
11  * 
12  * https://vision.network
13  */
14 
15 
16 /**
17  * @title ERC20Basic
18  * @dev Simpler version of ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/179
20  */
21 contract ERC20Basic {
22     function totalSupply() public view returns (uint256);
23     function balanceOf(address _who) public view returns (uint256);
24     function transfer(address _to, uint256 _value) public returns (bool);
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 }
27 
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35     address public owner;
36 
37 
38     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
39 
40 
41     /**
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param _newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address _newOwner) public onlyOwner {
62         require(_newOwner != address(0));
63         emit OwnershipTransferred(owner, _newOwner);
64         owner = _newOwner;
65     }
66 
67     /**
68      * @dev Rescue compatible ERC20Basic Token
69      *
70      * @param _token ERC20Basic The address of the token contract
71      */
72     function rescueTokens(ERC20Basic _token) external onlyOwner {
73         uint256 balance = _token.balanceOf(this);
74         assert(_token.transfer(owner, balance));
75     }
76 
77     /**
78      * @dev Withdraw Ether
79      */
80     function withdrawEther() external onlyOwner {
81         owner.transfer(address(this).balance);
82     }
83 }
84 
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 library SafeMath {
91 
92     /**
93      * @dev Multiplies two numbers, throws on overflow.
94      */
95     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
96         if (a == 0) {
97             return 0;
98         }
99         c = a * b;
100         assert(c / a == b);
101         return c;
102     }
103 
104     /**
105      * @dev Integer division of two numbers, truncating the quotient.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         // assert(b > 0); // Solidity automatically throws when dividing by 0
109         // uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111         return a / b;
112     }
113 
114     /**
115      * @dev Adds two numbers, throws on overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118         c = a + b;
119         assert(c >= a);
120         return c;
121     }
122 
123     /**
124      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         assert(b <= a);
128         return a - b;
129     }
130 }
131 
132 
133 /**
134  * @title VNET Token Private Placement
135  */
136 contract VNETPrivatePlacement is Ownable {
137     using SafeMath for uint256;
138 
139     ERC20Basic public vnetToken;
140 
141     uint256 public rate = 200000;
142     string public description;
143     uint256 public etherMinimum = 300;
144     uint256 public etherMaximum = 1000;
145 
146     /**
147      * @dev Constructor
148      */
149     constructor(ERC20Basic _vnetToken, string _description) public {
150         vnetToken = _vnetToken;
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
197     function setDescription(string _description) external onlyOwner returns (bool) {
198         description = _description;
199         return true;
200     }
201 }