1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17  /**
18  * @title Contract that will work with ERC223 tokens.
19  */
20 
21 contract ERC223ReceivingContract {
22 /**
23  * @dev Standard ERC223 function that will handle incoming token transfers.
24  *
25  * @param _from  Token sender address.
26  * @param _value Amount of tokens.
27  * @param _data  Transaction metadata.
28  */
29     function tokenFallback(address _from, uint _value, bytes _data);
30 }
31 
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  */
80 library SafeMath {
81   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82     if (a == 0) {
83       return 0;
84     }
85     uint256 c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return c;
95   }
96 
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 }
108 
109 
110 
111 
112 
113 
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) public view returns (uint256);
122   function transferFrom(address from, address to, uint256 value) public returns (bool);
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 
128 
129 
130 contract Bounty0xEscrow is Ownable, ERC223ReceivingContract {
131 
132     using SafeMath for uint256;
133 
134     address[] supportedTokens;
135 
136     mapping (address => bool) public tokenIsSupported;
137     mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
138 
139     event Deposit(address token, address user, uint amount, uint balance);
140     event Distribution(address token, address host, address hunter, uint256 amount, uint64 timestamp);
141 
142 
143     function Bounty0xEscrow() public {
144         address Bounty0xToken = 0xd2d6158683aeE4Cc838067727209a0aAF4359de3;
145         supportedTokens.push(Bounty0xToken);
146         tokenIsSupported[Bounty0xToken] = true;
147     }
148 
149 
150     function addSupportedToken(address _token) public onlyOwner {
151         require(!tokenIsSupported[_token]);
152 
153         supportedTokens.push(_token);
154         tokenIsSupported[_token] = true;
155     }
156 
157     function removeSupportedToken(address _token) public onlyOwner {
158         require(tokenIsSupported[_token]);
159 
160         for (uint i = 0; i < supportedTokens.length; i++) {
161             if (supportedTokens[i] == _token) {
162                 var indexOfLastToken = supportedTokens.length - 1;
163                 supportedTokens[i] = supportedTokens[indexOfLastToken];
164                 supportedTokens.length--;
165                 tokenIsSupported[_token] = false;
166                 return;
167             }
168         }
169     }
170 
171     function getListOfSupportedTokens() view public returns(address[]) {
172         return supportedTokens;
173     }
174 
175 
176     function tokenFallback(address _from, uint _value, bytes _data) public {
177         var _token = msg.sender;
178         require(tokenIsSupported[_token]);
179 
180         tokens[_token][_from] = SafeMath.add(tokens[_token][_from], _value);
181         Deposit(_token, _from, _value, tokens[_token][_from]);
182     }
183 
184 
185     function depositToken(address _token, uint _amount) public {
186         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
187         require(_token != address(0));
188         require(tokenIsSupported[_token]);
189 
190         require(ERC20(_token).transferFrom(msg.sender, this, _amount));
191         tokens[_token][msg.sender] = SafeMath.add(tokens[_token][msg.sender], _amount);
192 
193         Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
194     }
195 
196 
197     function distributeTokenToAddress(address _token, address _host, address _hunter, uint256 _amount) external onlyOwner {
198         require(_token != address(0));
199         require(_hunter != address(0));
200         require(tokenIsSupported[_token]);
201         require(tokens[_token][_host] >= _amount);
202 
203         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], _amount);
204         require(ERC20(_token).transfer(_hunter, _amount));
205 
206         Distribution(_token, _host, _hunter, _amount, uint64(now));
207     }
208 
209     function distributeTokenToAddressesAndAmounts(address _token, address _host, address[] _hunters, uint256[] _amounts) external onlyOwner {
210         require(_token != address(0));
211         require(_host != address(0));
212         require(_hunters.length == _amounts.length);
213         require(tokenIsSupported[_token]);
214 
215         uint256 totalAmount = 0;
216         for (uint j = 0; j < _amounts.length; j++) {
217             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
218         }
219         require(tokens[_token][_host] >= totalAmount);
220         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], totalAmount);
221 
222         for (uint i = 0; i < _hunters.length; i++) {
223             require(ERC20(_token).transfer(_hunters[i], _amounts[i]));
224 
225             Distribution(_token, _host, _hunters[i], _amounts[i], uint64(now));
226         }
227     }
228 
229     function distributeTokenToAddressesAndAmountsWithoutHost(address _token, address[] _hunters, uint256[] _amounts) external onlyOwner {
230         require(_token != address(0));
231         require(_hunters.length == _amounts.length);
232         require(tokenIsSupported[_token]);
233 
234         uint256 totalAmount = 0;
235         for (uint j = 0; j < _amounts.length; j++) {
236             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
237         }
238         require(ERC20(_token).balanceOf(this) >= totalAmount);
239 
240         for (uint i = 0; i < _hunters.length; i++) {
241             require(ERC20(_token).transfer(_hunters[i], _amounts[i]));
242 
243             Distribution(_token, this, _hunters[i], _amounts[i], uint64(now));
244         }
245     }
246 
247 }