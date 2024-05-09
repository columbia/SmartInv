1 pragma solidity ^0.4.24;
2 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
3 
4 
5 
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b; //200
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract Ownable {
49   address public owner;
50   address public coowner;
51   uint256 public globalLimit = 3000000;
52   address public token = 0xeaf61FC150CD5c3BeA75744e830D916E60EA5A9F;
53 
54   // How many tokens each user got distributed
55   mapping(address => uint256) public distributedBalances;
56   
57   // Individual limit for special cases
58   mapping(address => uint256) public personalLimit;
59   
60   constructor() public {
61     owner = msg.sender;
62     coowner = msg.sender;
63   }
64 
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70   modifier onlyTeam() {
71     require(msg.sender == coowner || msg.sender == owner);
72     _;
73   }
74 
75   function transferOwnership(address _newOwner) onlyOwner public {
76     coowner = _newOwner;
77   }
78 
79   function changeToken(address _newToken) onlyOwner public {
80     token = _newToken;
81   }
82 
83 
84   function changeGlobalLimit(uint _newGlobalLimit) onlyTeam public {
85     globalLimit = _newGlobalLimit;
86   }
87 
88   function setPersonalLimit(address wallet, uint256 _newPersonalLimit) onlyTeam public {
89     personalLimit[wallet] = _newPersonalLimit;
90   }
91 
92 }
93 
94 contract ERC20Basic {
95   uint public totalSupply;
96   function balanceOf(address who) public returns (uint);
97   function transfer(address to, uint value) public;
98   event Transfer(address indexed from, address indexed to, uint value);
99 }
100 
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public returns (uint);
103   function transferFrom(address from, address to, uint value) public;
104   function approve(address spender, uint value) public;
105   event Approval(address indexed owner, address indexed spender, uint value);
106 }
107 
108 contract Airdropper2 is Ownable {
109     using SafeMath for uint256;
110     function multisend(address[] wallets, uint256[] values) external onlyTeam returns (uint256) {
111         
112         uint256 limit = globalLimit;
113         uint256 tokensToIssue = 0;
114         address wallet = address(0);
115         
116         for (uint i = 0; i < wallets.length; i++) {
117 
118             tokensToIssue = values[i];
119             wallet = wallets[i];
120 
121            if(tokensToIssue > 0 && wallet != address(0)) { 
122                
123                 if(personalLimit[wallet] > globalLimit) {
124                     limit = personalLimit[wallet];
125                 }
126 
127                 if(distributedBalances[wallet].add(tokensToIssue) > limit) {
128                     tokensToIssue = limit.sub(distributedBalances[wallet]);
129                 }
130 
131                 if(limit > distributedBalances[wallet]) {
132                     distributedBalances[wallet] = distributedBalances[wallet].add(tokensToIssue);
133                     ERC20(token).transfer(wallet, tokensToIssue);
134                 }
135            }
136         }
137     }
138     
139     function simplesend(address[] wallets) external onlyTeam returns (uint256) {
140         
141         uint256 tokensToIssue = globalLimit;
142         address wallet = address(0);
143         
144         for (uint i = 0; i < wallets.length; i++) {
145             
146             wallet = wallets[i];
147            if(wallet != address(0)) {
148                
149                 if(distributedBalances[wallet] == 0) {
150                     distributedBalances[wallet] = distributedBalances[wallet].add(tokensToIssue);
151                     ERC20(token).transfer(wallet, tokensToIssue);
152                 }
153            }
154         }
155     }
156 
157 
158     function evacuateTokens(ERC20 _tokenInstance, uint256 _tokens) external onlyOwner returns (bool success) {
159         _tokenInstance.transfer(owner, _tokens);
160         return true;
161     }
162 
163     function _evacuateEther() onlyOwner external {
164         owner.transfer(address(this).balance);
165     }
166 }