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
43 contract IBTCToken is IERC20 {
44 
45     using SafeMath for uint256;
46 
47     // Token properties
48     string public name = "IBTC";
49     string public symbol = "IBTC";
50     uint public decimals = 18;
51 
52     uint public _totalSupply = 21000000e18;
53     uint public _tokenLeft = 21000000e18;
54 
55     // Balances for each account
56     mapping (address => uint256) balances;
57 
58     // Owner of account approves the transfer of an amount to another account
59     mapping (address => mapping(address => uint256)) allowed;
60 
61     // Owner of Token
62     address public owner;
63 
64     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
65 
66     // modifier to allow only owner has full control on the function
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     // Constructor
73     // @notice IBTCToken Contract
74     // @return the transaction address
75     function IBTCToken() public payable {
76         owner = "0x9FD6977e609AA945C6b6e40537dCF0A791775279";
77 
78         balances[owner] = _totalSupply; 
79     }
80 
81     // Payable method
82     // @notice Anyone can buy the tokens on tokensale by paying ether
83     function () public payable {
84         tokensale(msg.sender);
85     }
86 
87     // @notice tokensale
88     // @param recipient The address of the recipient
89     // @return the transaction address and send the event as Transfer
90     function tokensale(address recipient) public payable {
91         require(recipient != 0x0);
92 
93         //uint tokens = weiAmount.mul(getPrice());
94 
95         //require(_tokenLeft >= tokens);
96 
97         //balances[owner] = balances[owner].sub(tokens);
98         //balances[recipient] = balances[recipient].add(tokens);
99 
100         //_tokenLeft = _tokenLeft.sub(tokens);
101 
102         //TokenPurchase(msg.sender, recipient, weiAmount, tokens);
103     }
104 
105     // @return total tokens supplied
106     function totalSupply() public constant returns (uint256) {
107         return _totalSupply;
108     }
109 
110     // What is the balance of a particular account?
111     // @param who The address of the particular account
112     // @return the balanace the particular account
113     function balanceOf(address who) public constant returns (uint256) {
114         return balances[who];
115     }
116 
117     // Token distribution to founder, develoment team, partners, charity, and bounty
118     function sendIBTCToken(address to, uint256 value) public onlyOwner {
119         require (
120             to != 0x0 && value > 0 && _tokenLeft >= value
121         );
122 
123         balances[owner] = balances[owner].sub(value);
124         balances[to] = balances[to].add(value);
125         _tokenLeft = _tokenLeft.sub(value);
126         Transfer(owner, to, value);
127     }
128 
129     function sendIBTCTokenToMultiAddr(address[] listAddresses, uint256[] amount) onlyOwner {
130         require(listAddresses.length == amount.length); 
131          for (uint256 i = 0; i < listAddresses.length; i++) {
132                 require(listAddresses[i] != 0x0); 
133                 balances[listAddresses[i]] = balances[listAddresses[i]].add(amount[i]);
134                 balances[owner] = balances[owner].sub(amount[i]);
135                 Transfer(owner, listAddresses[i], amount[i]);
136                 _tokenLeft = _tokenLeft.sub(amount[i]);
137          }
138     }
139 
140     function destroyIBTCToken(address to, uint256 value) public onlyOwner {
141         require (
142                 to != 0x0 && value > 0 && _totalSupply >= value
143             );
144         balances[to] = balances[to].sub(value);
145     }
146 
147     // @notice send `value` token to `to` from `msg.sender`
148     // @param to The address of the recipient
149     // @param value The amount of token to be transferred
150     // @return the transaction address and send the event as Transfer
151     function transfer(address to, uint256 value) public {
152         require (
153             balances[msg.sender] >= value && value > 0
154         );
155         balances[msg.sender] = balances[msg.sender].sub(value);
156         balances[to] = balances[to].add(value);
157         Transfer(msg.sender, to, value);
158     }
159 
160     // @notice send `value` token to `to` from `from`
161     // @param from The address of the sender
162     // @param to The address of the recipient
163     // @param value The amount of token to be transferred
164     // @return the transaction address and send the event as Transfer
165     function transferFrom(address from, address to, uint256 value) public {
166         require (
167             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
168         );
169         balances[from] = balances[from].sub(value);
170         balances[to] = balances[to].add(value);
171         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
172         Transfer(from, to, value);
173     }
174 
175     // Allow spender to withdraw from your account, multiple times, up to the value amount.
176     // If this function is called again it overwrites the current allowance with value.
177     // @param spender The address of the sender
178     // @param value The amount to be approved
179     // @return the transaction address and send the event as Approval
180     function approve(address spender, uint256 value) public {
181         require (
182             balances[msg.sender] >= value && value > 0
183         );
184         allowed[msg.sender][spender] = value;
185         Approval(msg.sender, spender, value);
186     }
187 
188     // Check the allowed value for the spender to withdraw from owner
189     // @param owner The address of the owner
190     // @param spender The address of the spender
191     // @return the amount which spender is still allowed to withdraw from owner
192     function allowance(address _owner, address spender) public constant returns (uint256) {
193         return allowed[_owner][spender];
194     }
195 
196     // Get current price of a Token
197     // @return the price or token value for a ether
198 //    function getPrice() public constant returns (uint result) {
199 //        return PRICE;
200 //    }
201 
202     function getTokenDetail() public constant returns (string, string, uint256) {
203 	return (name, symbol, _totalSupply);
204     }
205 }