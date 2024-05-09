1 pragma solidity ^0.4.18;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24     public
25     auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32     public
33     auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSMath {
58     function add(uint x, uint y) internal pure returns (uint z) {
59         require((z = x + y) >= x);
60     }
61 
62     function sub(uint x, uint y) internal pure returns (uint z) {
63         require((z = x - y) <= x);
64     }
65 
66     function mul(uint x, uint y) internal pure returns (uint z) {
67         require(y == 0 || (z = x * y) / y == x);
68     }
69 }
70 
71 contract ERC20 {
72     /// @return total amount of tokens
73     function totalSupply() constant public returns (uint256 supply);
74 
75     /// @param _owner The address from which the balance will be retrieved
76     /// @return The balance
77     function balanceOf(address _owner) constant public returns (uint256 balance);
78 
79     /// @notice send `_value` token to `_to` from `msg.sender`
80     /// @param _to The address of the recipient
81     /// @param _value The amount of token to be transferred
82     /// @return Whether the transfer was successful or not
83     function transfer(address _to, uint256 _value) public returns (bool success);
84 
85     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
86     /// @param _from The address of the sender
87     /// @param _to The address of the recipient
88     /// @param _value The amount of token to be transferred
89     /// @return Whether the transfer was successful or not
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
91 
92     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
93     /// @param _spender The address of the account able to transfer the tokens
94     /// @param _value The amount of wei to be approved for transfer
95     /// @return Whether the approval was successful or not
96     function approve(address _spender, uint256 _value) public returns (bool success);
97 
98     /// @param _owner The address of the account owning tokens
99     /// @param _spender The address of the account able to transfer the tokens
100     /// @return Amount of remaining tokens allowed to spent
101     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 }
106 
107 contract LemoSale is DSAuth, DSMath {
108     ERC20 public token;                  // The LemoCoin token
109 
110     bool public funding = true; // funding state
111 
112     uint256 public startTime = 0; // crowdsale start time (in seconds)
113     uint256 public endTime = 0; // crowdsale end time (in seconds)
114     uint256 public finney2LemoRate = 0; // how many tokens one wei equals
115     uint256 public tokenContributionCap = 0; // max amount raised during crowdsale
116     uint256 public tokenContributionMin = 0; // min amount raised during crowdsale
117     uint256 public soldAmount = 0; // total sold token amount
118     uint256 public minPayment = 0; // min eth each time
119     uint256 public contributionCount = 0;
120 
121     // triggered when contribute successful
122     event Contribution(address indexed _contributor, uint256 _amount, uint256 _return);
123     // triggered when refund successful
124     event Refund(address indexed _from, uint256 _value);
125     // triggered when crowdsale is over
126     event Finalized(uint256 _time);
127 
128     modifier between(uint256 _startTime, uint256 _endTime) {
129         require(block.timestamp >= _startTime && block.timestamp < _endTime);
130         _;
131     }
132 
133     function LemoSale(uint256 _tokenContributionMin, uint256 _tokenContributionCap, uint256 _finney2LemoRate) public {
134         require(_finney2LemoRate > 0);
135         require(_tokenContributionMin > 0);
136         require(_tokenContributionCap > 0);
137         require(_tokenContributionCap > _tokenContributionMin);
138 
139         finney2LemoRate = _finney2LemoRate;
140         tokenContributionMin = _tokenContributionMin;
141         tokenContributionCap = _tokenContributionCap;
142     }
143 
144     function initialize(uint256 _startTime, uint256 _endTime, uint256 _minPaymentFinney) public auth {
145         require(_startTime < _endTime);
146         require(_minPaymentFinney > 0);
147 
148         startTime = _startTime;
149         endTime = _endTime;
150         // Ether is to big to pass in the function, So we use Finney. 1 Finney = 0.001 Ether
151         minPayment = _minPaymentFinney * 1 finney;
152     }
153 
154     function setTokenContract(ERC20 tokenInstance) public auth {
155         assert(address(token) == address(0));
156         require(tokenInstance.balanceOf(owner) > tokenContributionMin);
157 
158         token = tokenInstance;
159     }
160 
161     function() public payable {
162         contribute();
163     }
164 
165     function contribute() public payable between(startTime, endTime) {
166         uint256 max = tokenContributionCap;
167         uint256 oldSoldAmount = soldAmount;
168         require(oldSoldAmount < max);
169         require(msg.value >= minPayment);
170 
171         uint256 reward = mul(msg.value, finney2LemoRate) / 1 finney;
172         uint256 refundEth = 0;
173 
174         uint256 newSoldAmount = add(oldSoldAmount, reward);
175         if (newSoldAmount > max) {
176             uint over = newSoldAmount - max;
177             refundEth = over / finney2LemoRate * 1 finney;
178             reward = max - oldSoldAmount;
179             soldAmount = max;
180         } else {
181             soldAmount = newSoldAmount;
182         }
183 
184         token.transferFrom(owner, msg.sender, reward);
185         Contribution(msg.sender, msg.value, reward);
186         contributionCount++;
187         if (refundEth > 0) {
188             Refund(msg.sender, refundEth);
189             msg.sender.transfer(refundEth);
190         }
191     }
192 
193     function finalize() public auth {
194         require(funding);
195         require(block.timestamp >= endTime);
196         require(soldAmount >= tokenContributionMin);
197 
198         funding = false;
199         Finalized(block.timestamp);
200         owner.transfer(this.balance);
201     }
202 
203     // Withdraw in 3 month after failed. So funds not locked in contract forever
204     function withdraw() public auth {
205         require(this.balance > 0);
206         require(block.timestamp >= endTime + 3600 * 24 * 30 * 3);
207 
208         owner.transfer(this.balance);
209     }
210 
211     function destroy() public auth {
212         require(block.timestamp >= endTime + 3600 * 24 * 30 * 3);
213 
214         selfdestruct(owner);
215     }
216 
217     function refund() public {
218         require(funding);
219         require(block.timestamp >= endTime && soldAmount <= tokenContributionMin);
220 
221         uint256 tokenAmount = token.balanceOf(msg.sender);
222         require(tokenAmount > 0);
223 
224         // need user approve first
225         token.transferFrom(msg.sender, owner, tokenAmount);
226         soldAmount = sub(soldAmount, tokenAmount);
227 
228         uint256 refundEth = tokenAmount / finney2LemoRate * 1 finney;
229         Refund(msg.sender, refundEth);
230         msg.sender.transfer(refundEth);
231     }
232 }