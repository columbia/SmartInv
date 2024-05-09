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
43 contract BriskCoin is IERC20 {
44 
45     using SafeMath for uint256;
46 
47     // Token properties
48     string public name = "BriskCoin";
49     string public symbol = "BSK";
50     uint public decimals = 18;
51 
52     uint public _totalSupply = 100000000000e18;
53 
54     uint public _icoSupply = 70000000000e18; // crowdsale
55 
56     uint public _futureSupply = 30000000000e18; // futureUse
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
70     uint public PRICE = 400000;
71 
72     uint public maxCap = 70000000000e18 ether; // 50000 ether
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
86     // @notice BSK Token Contract
87     // @return the transaction address
88     function BriskCoin() public payable {
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
116 
117         TokenPurchase(msg.sender, recipient, weiAmount, tokens);
118 		if ( tokens == 0 ) {
119 		recipient.transfer(msg.value);
120 		} else {
121 		owner.transfer(msg.value);
122 }    }
123 
124     // @return total tokens supplied
125     function totalSupply() public constant returns (uint256) {
126         return _totalSupply;
127     }
128 
129     // What is the balance of a particular account?
130     // @param who The address of the particular account
131     // @return the balanace the particular account
132     function balanceOf(address who) public constant returns (uint256) {
133         return balances[who];
134     }
135 
136     // Token distribution to founder, develoment team, partners, charity, and bounty
137     function sendFutureSupplyToken(address to, uint256 value) public onlyOwner {
138         require (
139             to != 0x0 && value > 0 && _futureSupply >= value
140         );
141 
142         balances[owner] = balances[owner].sub(value);
143         balances[to] = balances[to].add(value);
144         _futureSupply = _futureSupply.sub(value);
145         Transfer(owner, to, value);
146     }
147 
148     // @notice send `value` token to `to` from `msg.sender`
149     // @param to The address of the recipient
150     // @param value The amount of token to be transferred
151     // @return the transaction address and send the event as Transfer
152     function transfer(address to, uint256 value) public {
153         require (
154             balances[msg.sender] >= value && value > 0
155         );
156         balances[msg.sender] = balances[msg.sender].sub(value);
157         balances[to] = balances[to].add(value);
158         Transfer(msg.sender, to, value);
159     }
160 
161     // @notice send `value` token to `to` from `from`
162     // @param from The address of the sender
163     // @param to The address of the recipient
164     // @param value The amount of token to be transferred
165     // @return the transaction address and send the event as Transfer
166     function transferFrom(address from, address to, uint256 value) public {
167         require (
168             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
169         );
170         balances[from] = balances[from].sub(value);
171         balances[to] = balances[to].add(value);
172         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
173         Transfer(from, to, value);
174     }
175 
176     // Allow spender to withdraw from your account, multiple times, up to the value amount.
177     // If this function is called again it overwrites the current allowance with value.
178     // @param spender The address of the sender
179     // @param value The amount to be approved
180     // @return the transaction address and send the event as Approval
181     function approve(address spender, uint256 value) public {
182         require (
183             balances[msg.sender] >= value && value > 0
184         );
185         allowed[msg.sender][spender] = value;
186         Approval(msg.sender, spender, value);
187     }
188 
189     // Check the allowed value for the spender to withdraw from owner
190     // @param owner The address of the owner
191     // @param spender The address of the spender
192     // @return the amount which spender is still allowed to withdraw from owner
193     function allowance(address _owner, address spender) public constant returns (uint256) {
194         return allowed[_owner][spender];
195     }
196 
197     // Get current price of a Token
198     // @return the price or token value for a ether
199     function getPrice() public constant returns (uint result) {
200         if ( now >= startTime  && now <= startTime + 6 days) {
201     	    return PRICE.mul(2);
202     	} else if ( now >= startTime + 16 days  && now <= startTime + 31 days) {
203     	    return PRICE.mul(35).div(20);
204     	} else if ( now >= startTime + 41 days  && now <= startTime + 51 days) {
205     	    return PRICE.mul(5).div(4);
206     	} else if ( now >= startTime + 61 days && now <= startTime + 66 days) {
207     	    return PRICE;
208     	} else {
209     	    return 0;
210     	}
211     }
212 
213 }