1 pragma solidity ^0.4.13;
2 
3 contract Crowdsale {
4     using SafeMath for uint256;
5 
6     address constant public TOKEN_OWNER = 0x57Cdd07287f668eC4D58f3E362b4FCC2bC54F5b8; //Token Owner
7     address constant public WALLET = 0x1513F644590d866e25490687AB1b3Ad262d5b6dF; //Investment storage;
8     uint256 constant public MINSALESCAP = 200 ether;
9     uint256 constant public MAXSALESCAP = 126000 ether;
10     uint256 constant public STARTDATE = 1533686401; //Friday, Wednesday, August 8, 2018 2:00:01 AM
11     uint256 constant public ENDDATE = 1543536060; // November 30, 2018 12:01:00 AM
12     uint256 constant public FXRATE = 50000;
13     uint256 constant public MINCONTRIBUTION = 5000000000000 wei; //0,005 eth
14 
15     //set on deployment
16     address public TOKEN;
17     address public owner;
18     uint256 public weiRaised;
19 
20     enum State { Running, Expired, Funded }
21     State public state;
22 
23     struct ContributorStruct {
24         bool whitelisted;
25         uint256 contributions;
26     }
27     mapping(address => ContributorStruct) public whitelist;
28 
29     modifier isContributor() {require(whitelist[msg.sender].contributions > 0x00); _;}
30     modifier isOwner() {require(msg.sender == owner); _;}
31     modifier inState(State _state) {require(state == _state); _;}
32     modifier inPaymentLimits(uint256 _payment) {require(_payment >= MINCONTRIBUTION); _;}
33     modifier inWhitelist(address _contributor) {require(whitelist[_contributor].whitelisted == true); _;}
34 
35     event WhitelistingLog(address indexed _contributor);
36     event RefundLog(address indexed _contributor, uint256 _amount);
37     event PurchaseLog(address indexed _contributor, address indexed _beneficiary, uint256 _amount);
38 
39     constructor (address _token) public {
40         require(_token != address(0x00));
41 
42         owner = msg.sender;
43         TOKEN = _token;
44     }
45 
46     function () public payable {
47         _updateStateIfExpired();
48     }
49 
50     //available only to whitelisted addresses after startBlock
51     function buyTokens(address _beneficiary)
52         public
53         inState(State.Running)
54         inPaymentLimits(msg.value)
55         inWhitelist(_beneficiary)
56         payable
57         returns (bool success)
58     {
59         require(_beneficiary != address(0x00));
60 
61         assert(block.timestamp >= STARTDATE); //check if sale has started
62 
63         uint256 tokenAmount = _calculateTokenAmount(msg.value);
64         YOUToken token = YOUToken(TOKEN);
65 
66         weiRaised = weiRaised.add(msg.value);
67         whitelist[_beneficiary].contributions = whitelist[_beneficiary].contributions.add(msg.value);
68         if (!token.mint.gas(700000)(_beneficiary, tokenAmount)) {
69             return false;
70         }
71 
72         if (weiRaised >= MAXSALESCAP
73             || weiRaised >= MINSALESCAP && block.timestamp >= ENDDATE) {
74             state = State.Funded;
75         } else {
76             _updateStateIfExpired();
77         }
78 
79         emit PurchaseLog(msg.sender, _beneficiary, msg.value);
80         return true;
81     }
82 
83     //available to contributers after deadline and only if unfunded
84     //if contributer used a different address as _beneficiary, only this address can claim refund
85     function refund(address _contributor)
86         public
87         isContributor
88         inState(State.Expired)
89         returns (bool success)
90     {
91         require(_contributor != address(0x00));
92 
93         uint256 amount = whitelist[_contributor].contributions;
94         whitelist[_contributor].contributions = 0x00;
95 
96         _contributor.transfer(amount);
97 
98         emit RefundLog(_contributor, amount);
99         return true;
100     }
101 
102     //as owner, whitelist individual address
103     function whitelistAddr(address _contributor)
104         public
105         isOwner
106         returns(bool)
107     {
108         require(_contributor != address(0x00));
109 
110         // whitelist[_contributor] = true;
111         whitelist[_contributor].whitelisted = true;
112 
113         emit WhitelistingLog(_contributor);
114         return true;
115     }
116 
117     //in cases where funds are not payed in ETH to this contract,
118     //as owner, whitelist and give tokens to address.
119     function whitelistAddrAndBuyTokens(address _contributor, uint256 _weiAmount)
120         public
121         isOwner
122         returns(bool)
123     {
124         require(_contributor != address(0x00));
125 
126         uint256 tokenAmount = _calculateTokenAmount(_weiAmount);
127         YOUToken token = YOUToken(TOKEN);
128 
129         whitelist[_contributor].whitelisted = true;
130         weiRaised = weiRaised.add(_weiAmount);
131         if (!token.mint.gas(700000)(_contributor, tokenAmount)) {
132             return false;
133         }
134 
135         emit WhitelistingLog(_contributor);
136         return true;
137     }
138 
139     //withdraw Funds only if funded, as owner
140     function withdraw() public isOwner inState(State.Funded) {
141         WALLET.transfer(address(this).balance);
142     }
143 
144     function delistAddress(address _contributor)
145         public
146         isOwner
147         inState(State.Running)
148         returns (bool)
149     {
150         require(_contributor != address(0x00));
151         require(whitelist[_contributor].whitelisted);
152 
153         whitelist[_contributor].whitelisted = false;
154 
155         return true;
156     }
157 
158     function emergencyStop()
159         public
160         isOwner
161         inState(State.Running)
162     {
163         //prevent more contributions and allow refunds
164         state = State.Expired;
165     }
166 
167     function transferOwnership()
168         public
169         isOwner
170         inState(State.Running)
171     {
172         //after deployment is complete run once
173         owner = TOKEN_OWNER;
174     }
175 
176     function _updateStateIfExpired() internal {
177         if ((block.timestamp >= ENDDATE && state == State.Running)
178             || (block.timestamp >= ENDDATE && weiRaised < MINSALESCAP)) {
179             state = State.Expired;
180         }
181     }
182 
183     function _calculateTokenAmount(uint256 _weiAmount)
184         internal
185         view
186         returns (uint256 tokenAmount)
187     {
188         uint256 discount;
189         if (block.timestamp <= 1535241660) {
190             if (_weiAmount >= 1700 ether) {
191                 discount = 30;
192             } else if (_weiAmount > 0.2 ether) {
193                 discount = 25;
194             }
195         } else if (block.timestamp <= 1537747260) {
196             discount = 15;
197         } else if (block.timestamp <= 1540339260) {
198             discount = 10;
199         } else if (block.timestamp <= 1543536060) {
200             discount = 5;
201         }
202 
203         _weiAmount = _weiAmount.mul(discount).div(100).add(_weiAmount);
204 
205         return _weiAmount.mul(FXRATE);
206     }
207 }
208 
209 library SafeMath {
210   function mul(uint a, uint b) internal pure returns (uint) {
211     uint c = a * b;
212     assert(a == 0 || c / a == b);
213     return c;
214   }
215 
216   function div(uint a, uint b) internal pure returns (uint) {
217     // assert(b > 0); // Solidity automatically throws when dividing by 0
218     uint c = a / b;
219     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220     return c;
221   }
222 
223   function sub(uint a, uint b) internal pure returns (uint) {
224     assert(b <= a);
225     return a - b;
226   }
227 
228   function add(uint a, uint b) internal pure returns (uint) {
229     uint c = a + b;
230     assert(c >= a);
231     return c;
232   }
233 
234 }
235 
236 contract YOUToken {
237     function mint(address _to, uint256 _amount) public returns (bool);
238     function transferOwnership(address _newOwner) public;
239 }