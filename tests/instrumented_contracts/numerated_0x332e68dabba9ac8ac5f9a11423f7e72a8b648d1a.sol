1 pragma solidity ^0.4.25;
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
31     function totalSupply() public view returns (uint256);
32     function balanceOf(address who) public view returns (uint256);
33     function transfer(address to, uint256 value) public;
34     function transferFrom(address from, address to, uint256 value) public;
35     function approve(address spender, uint256 value) external;
36     function allowance(address owner, address spender) public view returns (uint256);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 
41 }
42 
43 contract DTDToken is IERC20 {
44 
45     using SafeMath for uint256;
46 
47     // Token properties
48     string public name = "Dontoshi Token";
49     string public symbol = "DTD";
50     uint public decimals = 18;
51 
52     uint public _totalSupply = 100000000e18;
53     uint public _tokenLeft = 100000000e18;
54     uint public _round1Limit = 2300000e18;
55     uint public _round2Limit = 5300000e18;
56     uint public _round3Limit = 9800000e18;
57     uint public _developmentReserve = 20200000e18;
58     uint public _endDate = 1544918399;
59     uint public _minInvest = 0.5 ether;
60     uint public _maxInvest = 100 ether;
61 
62     // Invested ether
63     mapping (address => uint256) _investedEth;
64     // Balances for each account
65     mapping (address => uint256) balances;
66 
67     // Owner of account approves the transfer of an amount to another account
68     mapping (address => mapping(address => uint256)) allowed;
69 
70     // Owner of Token
71     address public owner;
72 
73     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
74 
75     // modifier to allow only owner has full control on the function
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     // Constructor
82     // @notice DTDToken Contract
83     // @return the transaction address
84     constructor() public payable {
85         owner = 0x9FD6977e609AA945C6b6e40537dCF0A791775279;
86 
87         balances[owner] = _totalSupply; 
88     }
89 
90     // Payable method
91     // @notice Anyone can buy the tokens on tokensale by paying ether
92     function () external payable {
93         tokensale(msg.sender);
94     }
95 
96     // @notice tokensale
97     // @param recipient The address of the recipient
98     // @return the transaction address and send the event as Transfer
99     function tokensale(address recipient) public payable {
100         require(recipient != 0x0);
101         
102         uint256 weiAmount = msg.value;
103         uint tokens = weiAmount.mul(getPrice());
104         
105         _investedEth[msg.sender] = _investedEth[msg.sender].add(weiAmount);
106         
107         require( weiAmount >= _minInvest );
108         require(_investedEth[msg.sender] <= _maxInvest);
109         require(_tokenLeft >= tokens + _developmentReserve);
110 
111         balances[owner] = balances[owner].sub(tokens);
112         balances[recipient] = balances[recipient].add(tokens);
113 
114         _tokenLeft = _tokenLeft.sub(tokens);
115 
116         owner.transfer(msg.value);
117         TokenPurchase(msg.sender, recipient, weiAmount, tokens);
118     }
119 
120     // @return total tokens supplied
121     function totalSupply() public view returns (uint256) {
122         return _totalSupply;
123     }
124 
125     // What is the balance of a particular account?
126     // @param who The address of the particular account
127     // @return the balanace the particular account
128     function balanceOf(address who) public view returns (uint256) {
129         return balances[who];
130     }
131 
132     // Token distribution to founder, develoment team, partners, charity, and bounty
133     function sendDTDToken(address to, uint256 value) public onlyOwner {
134         require (
135             to != 0x0 && value > 0 && _tokenLeft >= value
136         );
137 
138         balances[owner] = balances[owner].sub(value);
139         balances[to] = balances[to].add(value);
140         _tokenLeft = _tokenLeft.sub(value);
141         Transfer(owner, to, value);
142     }
143 
144     function sendDTDTokenToMultiAddr(address[] memory listAddresses, uint256[] memory amount) public onlyOwner {
145         require(listAddresses.length == amount.length); 
146          for (uint256 i = 0; i < listAddresses.length; i++) {
147                 require(listAddresses[i] != 0x0); 
148                 balances[listAddresses[i]] = balances[listAddresses[i]].add(amount[i]);
149                 balances[owner] = balances[owner].sub(amount[i]);
150                 Transfer(owner, listAddresses[i], amount[i]);
151                 _tokenLeft = _tokenLeft.sub(amount[i]);
152          }
153     }
154 
155     function destroyDTDToken(address to, uint256 value) public onlyOwner {
156         require (
157                 to != 0x0 && value > 0 && _totalSupply >= value
158             );
159         balances[to] = balances[to].sub(value);
160     }
161 
162     // @notice send value token to to from msg.sender
163     // @param to The address of the recipient
164     // @param value The amount of token to be transferred
165     // @return the transaction address and send the event as Transfer
166     function transfer(address to, uint256 value) public {
167         require (
168             balances[msg.sender] >= value && value > 0
169         );
170         balances[msg.sender] = balances[msg.sender].sub(value);
171         balances[to] = balances[to].add(value);
172         Transfer(msg.sender, to, value);
173     }
174 
175     // @notice send value token to to from from
176     // @param from The address of the sender
177     // @param to The address of the recipient
178     // @param value The amount of token to be transferred
179     // @return the transaction address and send the event as Transfer
180     function transferFrom(address from, address to, uint256 value) public {
181         require (
182             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
183         );
184         balances[from] = balances[from].sub(value);
185         balances[to] = balances[to].add(value);
186         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
187         Transfer(from, to, value);
188     }
189 
190     // Allow spender to withdraw from your account, multiple times, up to the value amount.
191     // If this function is called again it overwrites the current allowance with value.
192     // @param spender The address of the sender
193     // @param value The amount to be approved
194     // @return the transaction address and send the event as Approval
195     function approve(address spender, uint256 value) external {
196         require (
197             balances[msg.sender] >= value && value > 0
198         );
199         allowed[msg.sender][spender] = value;
200         Approval(msg.sender, spender, value);
201     }
202 
203     // Check the allowed value for the spender to withdraw from owner
204     // @param owner The address of the owner
205     // @param spender The address of the spender
206     // @return the amount which spender is still allowed to withdraw from owner
207     function allowance(address _owner, address spender) public view returns (uint256) {
208         return allowed[_owner][spender];
209     }
210 
211     // Get current price of a Token
212     // @return the price or token value for a ether
213     function getPrice() public constant returns (uint result) {
214         if ( _totalSupply - _tokenLeft < _round1Limit )
215             return 650;
216         else if ( _totalSupply - _tokenLeft < _round2Limit )
217             return 500;
218         else if ( _totalSupply - _tokenLeft < _round3Limit )
219             return 400;
220         else
221             return 0;
222     }
223 
224     function getTokenDetail() public view returns (string memory, string memory, uint256) {
225      return (name, symbol, _totalSupply);
226     }
227 }