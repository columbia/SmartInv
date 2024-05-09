1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract IERC20 {
30 
31     function totalSupply() public constant returns (uint256);
32     function balanceOf(address who) public constant returns (uint256);
33     function transfer(address to, uint256 value) public returns (bool success);
34     function transferFrom(address from, address to, uint256 value) public returns (bool success);
35     function approve(address spender, uint256 value) public returns (bool success);
36     function allowance(address owner, address spender) public constant returns (uint256);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 
41 }
42 
43 contract QPSEToken is IERC20 {
44 
45     using SafeMath for uint256;
46 
47     // Token properties
48     string public name = "Qompass";
49     string public symbol = "QPSE";
50     uint public decimals = 18;
51 
52     uint private constant STAGE_PRE_ICO = 1;
53     uint private constant STAGE_MAIN_ICO = 2;
54 
55     uint public ico_stage = 0;
56     uint public _totalSupply = 33000000e18;
57 
58     uint public _icoSupply = 20000000e18; // crowdsale 70%
59     uint public _presaleSupply = 8000000e18;
60     uint public _mainsaleSupply = 12000000e18;
61     uint public _futureSupply = 13000000e18;
62                                     
63 //    uint256 public pre_startTime = 1522904400;  //2018/04/08 00:00:00 UTC + 8
64     uint256 public pre_endTime = 1523854800;    //2018/04/16 00:00:00 UTC + 8
65 	
66     uint256 public ico_startTime = 1523854800;  //2018/04/16 00:00:00 UTC + 8
67 //    uint256 public ico_endTime = 1533074400;    //2018/08/01 00:00:00 UTC + 8
68 
69     address eth_addr = 0xE3a08428160C8B7872EcaB35578D3304239a5748;
70     address token_addr = 0xDB882cFbA6A483b7e0FdedCF2aa50fA311DD392e;
71 
72 //    address eth_addr = 0x5A745e3A30CB59980BB86442B6B19c317585cd8e;
73 //    address token_addr = 0x6f5A6AAfD56AF48673F0DDd32621dC140F16212a;
74 
75     // Balances for each account
76     mapping (address => uint256) balances;
77 
78     // Owner of account approves the transfer of an amount to another account
79     mapping (address => mapping(address => uint256)) allowed;
80 
81     // Owner of Token
82     address public owner;
83 
84     // how many token units a buyer gets per wei
85     uint public PRICE = 800;
86     uint public pre_PRICE = 960;  //800 + 20% as bonus
87     uint public ico_PRICE = 840;  //800 + 5% as bonus
88 
89     // amount of raised money in wei
90     uint256 public fundRaised;
91 
92     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
93 
94     // modifier to allow only owner has full control on the function
95     modifier onlyOwner {
96         require(msg.sender == owner);
97         _;
98     }
99 
100     // Constructor
101     // @notice QPSEToken Contract
102     // @return the transaction address
103     function QPSEToken() public payable {
104         owner = msg.sender;
105 	    fundRaised = 0;
106         balances[token_addr] = _totalSupply; 
107     }
108 
109     // Payable method
110     // @notice Anyone can buy the tokens on tokensale by paying ether
111     function () public payable {
112         tokensale(msg.sender);
113     }
114 
115     // @notice tokensale
116     // @param recipient The address of the recipient
117     // @return the transaction address and send the event as Transfer
118     function tokensale(address recipient) public payable {
119         require(recipient != 0x0);
120 //        require(now >= pre_startTime);
121 
122         if (now < pre_endTime) {
123             ico_stage = STAGE_PRE_ICO;
124         } else {
125             ico_stage = STAGE_MAIN_ICO;
126         }
127 
128         if ( fundRaised >= _presaleSupply ) {
129             ico_stage = STAGE_MAIN_ICO;
130         }
131 	
132         uint256 weiAmount = msg.value;
133         uint tokens = weiAmount.mul(getPrice());
134 
135         require(_icoSupply >= tokens);
136 
137         balances[token_addr] = balances[token_addr].sub(tokens);
138         balances[recipient] = balances[recipient].add(tokens);
139 
140         _icoSupply = _icoSupply.sub(tokens);
141         fundRaised = fundRaised.add(tokens);
142 
143         TokenPurchase(msg.sender, recipient, weiAmount, tokens);
144         if ( tokens == 0 ) {
145             recipient.transfer(msg.value);
146         } else {
147             eth_addr.transfer(msg.value);    
148         }
149     }
150 
151     // @return total tokens supplied
152     function totalSupply() public constant returns (uint256) {
153         return _totalSupply;
154     }
155 
156     // What is the balance of a particular account?
157     // @param who The address of the particular account
158     // @return the balanace the particular account
159     function balanceOf(address who) public constant returns (uint256) {
160         return balances[who];
161     }
162 
163     // Token distribution
164     function sendTokenToMultiAddr(address[] _toAddresses, uint256[] _amounts) public {
165 	/* Ensures _toAddresses array is less than or equal to 255 */
166         require(_toAddresses.length <= 255);
167         /* Ensures _toAddress and _amounts have the same number of entries. */
168         require(_toAddresses.length == _amounts.length);
169 
170         for (uint8 i = 0; i < _toAddresses.length; i++) {
171             transfer(_toAddresses[i], _amounts[i]);
172         }
173     }
174 
175     // @notice send `value` token to `to` from `msg.sender`
176     // @param to The address of the recipient
177     // @param value The amount of token to be transferred
178     // @return the transaction address and send the event as Transfer
179     function transfer(address to, uint256 value) public returns (bool success) {
180         require (
181             balances[msg.sender] >= value && value > 0
182         );
183         balances[msg.sender] = balances[msg.sender].sub(value);
184         balances[to] = balances[to].add(value);
185         Transfer(msg.sender, to, value);
186         return true;
187     }
188 
189     // @notice send `value` token to `to` from `from`
190     // @param from The address of the sender
191     // @param to The address of the recipient
192     // @param value The amount of token to be transferred
193     // @return the transaction address and send the event as Transfer
194     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
195         require (
196             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
197         );
198         balances[from] = balances[from].sub(value);
199         balances[to] = balances[to].add(value);
200         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
201         Transfer(from, to, value);
202         return true;
203     }
204 
205     // Allow spender to withdraw from your account, multiple times, up to the value amount.
206     // If this function is called again it overwrites the current allowance with value.
207     // @param spender The address of the sender
208     // @param value The amount to be approved
209     // @return the transaction address and send the event as Approval
210     function approve(address _spender, uint256 _value) public returns (bool success) {
211         require (
212             balances[msg.sender] >= _value && _value > 0
213         );
214         allowed[msg.sender][_spender] = _value;
215         Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     // Check the allowed value for the spender to withdraw from owner
220     // @param owner The address of the owner
221     // @param spender The address of the spender
222     // @return the amount which spender is still allowed to withdraw from owner
223     function allowance(address _owner, address spender) public view returns (uint256) {
224         return allowed[_owner][spender];
225     }
226 
227     // Get current price of a Token
228     // @return the price or token value for a ether
229     function getPrice() public view returns (uint result) {
230         if ( ico_stage == STAGE_PRE_ICO ) {
231     	    return pre_PRICE;
232     	} if ( ico_stage == STAGE_MAIN_ICO ) {
233     	    return ico_PRICE;
234     	}
235     }
236 }