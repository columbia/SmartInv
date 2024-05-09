1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
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
33     function transfer(address to, uint256 value) public;
34     function transferFrom(address from, address to, uint256 value) public;
35     function approve(address spender, uint256 value) public;
36     function allowance(address owner, address spender) public constant returns (uint256);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 
41 }
42 
43 contract BTCPToken is IERC20 {
44 
45     using SafeMath for uint256;
46 
47     // Token properties
48     string public name = "BitcoinPeso";
49     string public symbol = "BTCP";
50     uint public decimals = 18;
51 
52     uint public _totalSupply = 21000000e18;
53     uint public _leftSupply = 21000000e18;
54 
55     // Balances for each account
56     mapping (address => uint256) balances;
57 
58     // Owner of account approves the transfer of an amount to another account
59     mapping (address => mapping(address => uint256)) allowed;
60 
61     uint256 public startTime;
62 
63     // Owner of Token
64     address public owner;
65 
66     // how many token units a buyer gets per wei
67     uint public PRICE = 1000;
68 
69     // amount of raised money in wei
70 
71     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
72 
73     // modifier to allow only owner has full control on the function
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     // Constructor
80     // @notice BTCPToken Contract
81     // @return the transaction address
82     function BTCPToken() public payable {
83         startTime = now;
84         owner = msg.sender;
85 
86         balances[owner] = _totalSupply; 
87     }
88 
89     // Payable method
90     // @notice Anyone can buy the tokens on tokensale by paying ether
91     function () public payable {
92         tokensale(msg.sender);
93     }
94 
95     // @notice tokensale
96     // @param recipient The address of the recipient
97     // @return the transaction address and send the event as Transfer
98     function tokensale(address recipient) public payable {
99         require(recipient != 0x0);
100 
101         uint256 weiAmount = msg.value;
102         uint tokens = weiAmount.mul(getPrice());
103 
104         require(_leftSupply >= tokens);
105 
106         balances[owner] = balances[owner].sub(tokens);
107         balances[recipient] = balances[recipient].add(tokens);
108 
109         _leftSupply = _leftSupply.sub(tokens);
110 
111         TokenPurchase(msg.sender, recipient, weiAmount, tokens);
112     }
113 
114     // @return total tokens supplied
115     function totalSupply() public constant returns (uint256) {
116         return _totalSupply;
117     }
118 
119     // What is the balance of a particular account?
120     // @param who The address of the particular account
121     // @return the balanace the particular account
122     function balanceOf(address who) public constant returns (uint256) {
123         return balances[who];
124     }
125 
126     // Token distribution to founder, develoment team, partners, charity, and bounty
127     function sendBTCPToken(address to, uint256 value) public onlyOwner {
128         require (
129             to != 0x0 && value > 0 && _leftSupply >= value
130         );
131 
132         balances[owner] = balances[owner].sub(value);
133         balances[to] = balances[to].add(value);
134         _leftSupply = _leftSupply.sub(value);
135         Transfer(owner, to, value);
136     }
137 
138     function sendBTCPTokenToMultiAddr(address[] listAddresses, uint256[] amount) onlyOwner {
139         require(listAddresses.length == amount.length); 
140          for (uint256 i = 0; i < listAddresses.length; i++) {
141                 require(listAddresses[i] != 0x0); 
142                 balances[listAddresses[i]] = balances[listAddresses[i]].add(amount[i]);
143                 balances[owner] = balances[owner].sub(amount[i]);
144                 Transfer(owner, listAddresses[i], amount[i]);
145                 _leftSupply = _leftSupply.sub(amount[i]);
146          }
147     }
148 
149     function destroyBTCPToken(address to, uint256 value) public onlyOwner {
150         require (
151                 to != 0x0 && value > 0 && _totalSupply >= value
152             );
153         balances[to] = balances[to].sub(value);
154     }
155 
156     // @notice send `value` token to `to` from `msg.sender`
157     // @param to The address of the recipient
158     // @param value The amount of token to be transferred
159     // @return the transaction address and send the event as Transfer
160     function transfer(address to, uint256 value) public {
161         require (
162             balances[msg.sender] >= value && value > 0
163         );
164         balances[msg.sender] = balances[msg.sender].sub(value);
165         balances[to] = balances[to].add(value);
166         Transfer(msg.sender, to, value);
167     }
168 
169     // @notice send `value` token to `to` from `from`
170     // @param from The address of the sender
171     // @param to The address of the recipient
172     // @param value The amount of token to be transferred
173     // @return the transaction address and send the event as Transfer
174     function transferFrom(address from, address to, uint256 value) public {
175         require (
176             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
177         );
178         balances[from] = balances[from].sub(value);
179         balances[to] = balances[to].add(value);
180         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
181         Transfer(from, to, value);
182     }
183 
184     // Allow spender to withdraw from your account, multiple times, up to the value amount.
185     // If this function is called again it overwrites the current allowance with value.
186     // @param spender The address of the sender
187     // @param value The amount to be approved
188     // @return the transaction address and send the event as Approval
189     function approve(address spender, uint256 value) public {
190         require (
191             balances[msg.sender] >= value && value > 0
192         );
193         allowed[msg.sender][spender] = value;
194         Approval(msg.sender, spender, value);
195     }
196 
197     // Check the allowed value for the spender to withdraw from owner
198     // @param owner The address of the owner
199     // @param spender The address of the spender
200     // @return the amount which spender is still allowed to withdraw from owner
201     function allowance(address _owner, address spender) public constant returns (uint256) {
202         return allowed[_owner][spender];
203     }
204 
205     // Get current price of a Token
206     // @return the price or token value for a ether
207     function getPrice() public constant returns (uint result) {
208         return PRICE;
209     }
210 
211     function getTokenDetail() public constant returns (string, string, uint256) {
212 	return (name, symbol, _totalSupply);
213     }
214 }