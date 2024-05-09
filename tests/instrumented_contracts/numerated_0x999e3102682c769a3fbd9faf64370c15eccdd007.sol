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
43 contract RLSToken is IERC20 {
44 
45     using SafeMath for uint256;
46 
47     // Token properties
48     string public name = "Reales";
49     string public symbol = "RLS";
50     uint public decimals = 18;
51 
52     uint public _totalSupply = 1000000000e18;
53 
54     uint public _icoSupply = 500000000e18; // crowdsale
55 
56     uint public _futureSupply = 500000000e18; // futureUse
57 
58     // Balances for each account
59     mapping (address => uint256) balances;
60 
61     // Owner of account approves the transfer of an amount to another account
62     mapping (address => mapping(address => uint256)) allowed;
63 
64     uint256 public startTime;
65 
66     // Owner of Token
67     address public owner;
68 
69     // how many token units a buyer gets per wei
70     uint public PRICE = 1000;
71 
72     uint public maxCap = 700000e18 ether; // 50000 ether
73 
74     // amount of raised money in wei
75     uint256 public fundRaised;
76 
77     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
78 
79     // modifier to allow only owner has full control on the function
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     // Constructor
86     // @notice RLSToken Contract
87     // @return the transaction address
88     function RLSToken() public payable {
89         startTime = now;
90         owner = msg.sender;
91 
92         balances[owner] = _totalSupply; 
93     }
94 
95     // Payable method
96     // @notice Anyone can buy the tokens on tokensale by paying ether
97     function () public payable {
98         tokensale(msg.sender);
99     }
100 
101     // @notice tokensale
102     // @param recipient The address of the recipient
103     // @return the transaction address and send the event as Transfer
104     function tokensale(address recipient) public payable {
105         require(recipient != 0x0);
106 
107         uint256 weiAmount = msg.value;
108         uint tokens = weiAmount.mul(getPrice());
109 
110         require(_icoSupply >= tokens);
111 
112         balances[owner] = balances[owner].sub(tokens);
113         balances[recipient] = balances[recipient].add(tokens);
114 
115         _icoSupply = _icoSupply.sub(tokens);
116         owner.transfer(msg.value);
117         TokenPurchase(msg.sender, recipient, weiAmount, tokens);
118     }
119 
120     // @return total tokens supplied
121     function totalSupply() public constant returns (uint256) {
122         return _totalSupply;
123     }
124 
125     // What is the balance of a particular account?
126     // @param who The address of the particular account
127     // @return the balanace the particular account
128     function balanceOf(address who) public constant returns (uint256) {
129         return balances[who];
130     }
131 
132     // Token distribution to founder, develoment team, partners, charity, and bounty
133     function sendFutureSupplyToken(address to, uint256 value) public onlyOwner {
134         require (
135             to != 0x0 && value > 0 && _futureSupply >= value
136         );
137 
138         balances[owner] = balances[owner].sub(value);
139         balances[to] = balances[to].add(value);
140         _futureSupply = _futureSupply.sub(value);
141         Transfer(owner, to, value);
142     }
143 
144     // @notice send `value` token to `to` from `msg.sender`
145     // @param to The address of the recipient
146     // @param value The amount of token to be transferred
147     // @return the transaction address and send the event as Transfer
148     function transfer(address to, uint256 value) public {
149         require (
150             balances[msg.sender] >= value && value > 0
151         );
152         balances[msg.sender] = balances[msg.sender].sub(value);
153         balances[to] = balances[to].add(value);
154         Transfer(msg.sender, to, value);
155     }
156 
157     // @notice send `value` token to `to` from `from`
158     // @param from The address of the sender
159     // @param to The address of the recipient
160     // @param value The amount of token to be transferred
161     // @return the transaction address and send the event as Transfer
162     function transferFrom(address from, address to, uint256 value) public {
163         require (
164             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
165         );
166         balances[from] = balances[from].sub(value);
167         balances[to] = balances[to].add(value);
168         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
169         Transfer(from, to, value);
170     }
171 
172     // Allow spender to withdraw from your account, multiple times, up to the value amount.
173     // If this function is called again it overwrites the current allowance with value.
174     // @param spender The address of the sender
175     // @param value The amount to be approved
176     // @return the transaction address and send the event as Approval
177     function approve(address spender, uint256 value) public {
178         require (
179             balances[msg.sender] >= value && value > 0
180         );
181         allowed[msg.sender][spender] = value;
182         Approval(msg.sender, spender, value);
183     }
184 
185     // Check the allowed value for the spender to withdraw from owner
186     // @param owner The address of the owner
187     // @param spender The address of the spender
188     // @return the amount which spender is still allowed to withdraw from owner
189     function allowance(address _owner, address spender) public constant returns (uint256) {
190         return allowed[_owner][spender];
191     }
192 
193     // Get current price of a Token
194     // @return the price or token value for a ether
195     function getPrice() public constant returns (uint result) {
196          if ( now >= startTime  && now <= startTime + 7 days) {
197           return PRICE.mul(20).div(13);
198       } else if ( now >= startTime + 8 days  && now <= startTime + 14 days) {
199           return PRICE.mul(4).div(3);
200       } else if ( now >= startTime + 15 days  && now <= startTime + 21 days) {
201           return PRICE.mul(20).div(17);
202       } else if ( now >= startTime + 22 days  && now <= startTime + 28 days) {
203           return PRICE.mul(10).div(9);
204       } else if ( now >= startTime + 29 days && now <= startTime + 30 days) {
205           return PRICE.mul(20).div(19);
206       } else if ( now >= startTime + 31 days) {
207           return PRICE;
208       } else {
209           return 0;
210       }
211     }
212 
213 }