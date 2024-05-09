1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * VNET Token Airdrop
6  * 
7  * Just call this contract (send 0 ETH here),
8  * and you will receive 100-200 VNET Tokens immediately.
9  * 
10  * https://vision.network
11  */
12 
13 
14 /**
15  * @title ERC20Basic
16  * @dev Simpler version of ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/179
18  */
19 contract ERC20Basic {
20     function totalSupply() public view returns (uint256);
21     function balanceOf(address _who) public view returns (uint256);
22     function transfer(address _to, uint256 _value) public returns (bool);
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24 }
25 
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33     address public owner;
34 
35 
36     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
37 
38 
39     /**
40      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41      * account.
42      */
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param _newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address _newOwner) public onlyOwner {
60         require(_newOwner != address(0));
61         emit OwnershipTransferred(owner, _newOwner);
62         owner = _newOwner;
63     }
64 
65     /**
66      * @dev Rescue compatible ERC20Basic Token
67      *
68      * @param _token ERC20Basic The address of the token contract
69      */
70     function rescueTokens(ERC20Basic _token) external onlyOwner {
71         uint256 balance = _token.balanceOf(this);
72         assert(_token.transfer(owner, balance));
73     }
74 
75     /**
76      * @dev Withdraw Ether
77      */
78     function withdrawEther() external onlyOwner {
79         owner.transfer(address(this).balance);
80     }
81 }
82 
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89 
90     /**
91      * @dev Multiplies two numbers, throws on overflow.
92      */
93     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
94         if (a == 0) {
95             return 0;
96         }
97         c = a * b;
98         assert(c / a == b);
99         return c;
100     }
101 
102     /**
103      * @dev Integer division of two numbers, truncating the quotient.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // assert(b > 0); // Solidity automatically throws when dividing by 0
107         // uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109         return a / b;
110     }
111 
112     /**
113      * @dev Adds two numbers, throws on overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
116         c = a + b;
117         assert(c >= a);
118         return c;
119     }
120 
121     /**
122      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         assert(b <= a);
126         return a - b;
127     }
128 }
129 
130 
131 /**
132  * @title VNET Token Airdrop
133  */
134 contract VNETAirdrop is Ownable {
135     using SafeMath for uint256;
136 
137     // VNET Token Contract Address
138     ERC20Basic public vnetToken;
139 
140     // Description
141     string public description;
142     
143     // Nonce for random
144     uint256 randNonce = 0;
145 
146     // Airdropped
147     mapping(address => bool) public airdopped;
148 
149 
150     /**
151      * @dev Constructor
152      */
153     constructor(ERC20Basic _vnetToken, string _description) public {
154         vnetToken = _vnetToken;
155         description = _description;
156     }
157 
158     /**
159      * @dev receive ETH and send tokens
160      */
161     function () public payable {
162         require(airdopped[msg.sender] != true);
163         uint256 balance = vnetToken.balanceOf(address(this));
164         require(balance > 0);
165 
166         uint256 vnetAmount = 100;
167         vnetAmount = vnetAmount.add(uint256(keccak256(abi.encode(now, msg.sender, randNonce))) % 100).mul(10 ** 6);
168         
169         if (vnetAmount <= balance) {
170             assert(vnetToken.transfer(msg.sender, vnetAmount));
171         } else {
172             assert(vnetToken.transfer(msg.sender, balance));
173         }
174 
175         randNonce = randNonce.add(1);
176         airdopped[msg.sender] = true;
177     }
178 
179     /**
180      * @dev Set Description
181      * 
182      * @param _description string
183      */
184     function setDescription(string _description) external onlyOwner {
185         description = _description;
186     }
187 }