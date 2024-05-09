1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // BLU ICO contract
5 //
6 // BLU mainnet token address : 0x362a95215564d895f27021a7d7314629db2e1649
7 // RATE = 4000 => 1 ETH = 4000 BLU
8 // ----------------------------------------------------------------------------
9 
10 
11 // ----------------------------------------------------------------------------
12 // Safe math
13 // ----------------------------------------------------------------------------
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function sub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function mul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function div(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // Ownership contract
36 // _newOwner is address of new owner
37 // ----------------------------------------------------------------------------
38 contract Owned {
39     
40     address public owner;
41 
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     function Owned() public {
45         owner = 0x0567cB7c5A688401Aab87093058754E096C4d37E;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     // transfer Ownership to other address
54     function transferOwnership(address _newOwner) public onlyOwner {
55         require(_newOwner != address(0x0));
56         emit OwnershipTransferred(owner,_newOwner);
57         owner = _newOwner;
58     }
59     
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // BlupassToken interface
65 // ----------------------------------------------------------------------------
66 contract BlupassToken {
67     
68     function balanceOf(address _owner) public constant returns (uint256 balance);
69     function transfer(address _to, uint256 _value) public returns (bool success);
70     
71 }
72 
73 
74 // ----------------------------------------------------------------------------
75 // Blupass ICO smart contract
76 // ----------------------------------------------------------------------------
77 contract BlupassICO is Owned {
78 
79     using SafeMath for uint256;
80     
81     // public Variables
82     uint256 public totalRaised; //eth in wei
83     uint256 public totalDistributed; //tokens distributed
84     uint256 public RATE; // RATE of the BLU
85     BlupassToken public BLU; // BLU token address
86     bool public isStopped = false; // ICO start/stop
87     
88     mapping(address => bool) whitelist; // whitelisting for KYC verified users
89 
90     // events for log
91     event LogWhiteListed(address _addr);
92     event LogBlackListed(address _addr);
93     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
94     event LogBeneficiaryPaid(address _beneficiaryAddress);
95     event LogFundingSuccessful(uint _totalRaised);
96     event LogFunderInitialized(address _creator);
97     event LogContributorsPayout(address _addr, uint _amount);
98     
99     // To determine whether the ICO is running or stopped
100     modifier onlyWhenRunning {
101         require(!isStopped);
102         _;
103     }
104     
105     // To determine whether the user is whitelisted 
106     modifier onlyifWhiteListed {
107         require(whitelist[msg.sender]);
108         _;
109     }
110     
111     // ----------------------------------------------------------------------------
112     // BlupassICO constructor
113     // _addressOfToken is the token totalDistributed
114     // ----------------------------------------------------------------------------
115     function BlupassICO (BlupassToken _addressOfToken) public {
116         require(_addressOfToken != address(0)); // should have valid address
117         RATE = 4000;
118         BLU = BlupassToken(_addressOfToken);
119         emit LogFunderInitialized(owner);
120     }
121     
122     
123     // ----------------------------------------------------------------------------
124     // Function to handle eth transfers
125     // It invokes when someone sends ETH to this contract address.
126     // Requires enough gas for the execution otherwise it'll throw out of gas error.
127     // tokens are transferred to user
128     // ETH are transferred to current owner
129     // minimum 1 ETH investment
130     // ----------------------------------------------------------------------------
131     function() public payable {
132         contribute();
133     }
134 
135 
136     // ----------------------------------------------------------------------------
137     // Acceptes ETH and send equivalent BLU with bonus if any.
138     // NOTE: Add user to whitelist by invoking addToWhiteList() function.
139     // Only whitelisted users can buy tokens.
140     // For Non-whitelisted/Blacklisted users transaction will be reverted. 
141     // ----------------------------------------------------------------------------
142     function contribute() onlyWhenRunning onlyifWhiteListed public payable {
143         
144         require(msg.value >= 1 ether); // min 1 ETH investment
145         
146         uint256 tokenBought; // Variable to store amount of tokens bought
147         uint256 bonus; // Variable to store bonus if any
148 
149         totalRaised = totalRaised.add(msg.value); // Save the total eth totalRaised (in wei)
150         tokenBought = msg.value.mul(RATE); // Token calculation according to RATE
151         
152         // Bonus for  5+ ETH investment
153         
154         // 20 % bonus for 5 to 9 ETH investment
155         if (msg.value >= 5 ether && msg.value <= 9 ether) {
156             bonus = (tokenBought.mul(20)).div(100); // 20 % bonus
157             tokenBought = tokenBought.add(bonus);
158         } 
159         
160         // 40 % bonus for 10+ ETH investment
161         if (msg.value >= 10 ether) {
162             bonus = (tokenBought.mul(40)).div(100); // 40 % bonus
163             tokenBought = tokenBought.add(bonus);
164         }
165 
166         // this smart contract should have enough tokens to distribute
167         require(BLU.balanceOf(this) >= tokenBought);
168         
169         totalDistributed = totalDistributed.add(tokenBought); //Save to total tokens distributed
170         BLU.transfer(msg.sender,tokenBought); //Send Tokens to user
171         owner.transfer(msg.value); // Send ETH to owner
172         
173         //LOGS
174         emit LogContributorsPayout(msg.sender,tokenBought); // Log investor paid event
175         emit LogBeneficiaryPaid(owner); // Log owner paid event
176         emit LogFundingReceived(msg.sender, msg.value, totalRaised); // Log funding event
177     }
178 
179 
180     // ----------------------------------------------------------------------------
181     // function to whitelist user if KYC verified
182     // returns true if whitelisting is successful else returns false
183     // ----------------------------------------------------------------------------
184     function addToWhiteList(address _userAddress) onlyOwner public returns(bool) {
185         require(_userAddress != address(0)); // user address must be valid
186         // if not already in the whitelist
187         if (!whitelist[_userAddress]) {
188             whitelist[_userAddress] = true;
189             emit LogWhiteListed(_userAddress); // Log whitelist event
190             return true;
191         } else {
192             return false;
193         }
194     }
195     
196     
197     // ----------------------------------------------------------------------------
198     // function to remove user from whitelist
199     // ----------------------------------------------------------------------------
200     function removeFromWhiteList(address _userAddress) onlyOwner public returns(bool) {
201         require(_userAddress != address(0)); // user address must be valid
202         // if in the whitelist
203         if(whitelist[_userAddress]) {
204            whitelist[_userAddress] = false; 
205            emit LogBlackListed(_userAddress); // Log blacklist event
206            return true;
207         } else {
208             return false;
209         }
210         
211     }
212     
213     
214     // ----------------------------------------------------------------------------
215     // function to check if user is whitelisted
216     // ----------------------------------------------------------------------------
217     function checkIfWhiteListed(address _userAddress) view public returns(bool) {
218         return whitelist[_userAddress];
219     }
220     
221     
222     // ----------------------------------------------------------------------------
223     // function to stop the ICO
224     // ----------------------------------------------------------------------------
225     function stopICO() onlyOwner public {
226         isStopped = true;
227     }
228     
229     
230     // ----------------------------------------------------------------------------
231     // function to resume the ICO
232     // ----------------------------------------------------------------------------
233     function resumeICO() onlyOwner public {
234         isStopped = false;
235     }
236 
237 
238     // ----------------------------------------------------------------------------
239     // Function to claim any token stuck on contract
240     // ----------------------------------------------------------------------------
241     function claimTokens() onlyOwner public {
242         uint256 remainder = BLU.balanceOf(this); //Check remainder tokens
243         BLU.transfer(owner,remainder); //Transfer tokens to owner
244     }
245     
246 }