1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract Claimable is Ownable {
67   address pendingOwner;
68 
69   /**
70    * @dev Modifier throws if called by any account other than the pendingOwner.
71    */
72   modifier onlyPendingOwner() {
73     require(msg.sender == pendingOwner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to set the pendingOwner address.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) onlyOwner public {
82     pendingOwner = newOwner;
83   }
84 
85   /**
86    * @dev Allows the pendingOwner address to finalize the transfer.
87    */
88   function claimOwnership() onlyPendingOwner public {
89     OwnershipTransferred(owner, pendingOwner);
90     owner = pendingOwner;
91     pendingOwner = 0x0;
92   }
93 }
94 
95 contract ERC20Basic {
96   uint256 public totalSupply;
97   function balanceOf(address who) public constant returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 contract DopamemePresale is Claimable {
103     using SafeMath for uint256;
104     uint256 public maxCap = 14000000000000000000;  // 1400 ETH
105     uint256 public minCap = 3000000000000000000;  // 300 ETH
106     uint256 public minimum_investment = 15000000000000000; // 0.015 ETH
107     uint256 public totalInvestedInWei;
108     uint8 public exchangeRate = 230;  // ICO rate 200 + 15% Presale Bonus
109     uint256 public DMT_TotalSuply = 100000000;
110     uint256 public startBlock = 4597180;  // 21Nov2017_23_gmt
111     uint256 public endBlock;
112     uint256 public end_Dec_21_2017 = 1513897200;
113     bool public isInitialized = false;
114     bool public paused = false;
115 
116     uint256 public tokensGenerated;
117     uint256 public investorsLength;
118     
119     address vault;
120     mapping(address => uint256) public investorBalances;
121     mapping(address => uint256) public investorToken;
122     mapping(address => bool) whitelist;
123     
124     modifier notPaused() {
125         require(!paused);
126         _;
127     }
128 
129     function hasStarted() public constant returns(bool) {
130         return block.number >= startBlock;
131     }
132 
133     function hasEnded() public constant returns (bool) {
134         return (getTime() > end_Dec_21_2017 || maxCapReached());
135     }
136 
137     function showVault() onlyOwner constant returns(address) {
138         return vault;
139     }
140 
141     function showOwner() onlyOwner constant returns(address) {
142         return owner;
143     }
144 
145     /// @return Total to invest in weis.
146     function toFound() public constant returns(uint256) {
147         return maxCap >= totalInvestedInWei ? maxCap - totalInvestedInWei : 0;
148     }
149     
150     /// @return Total to invest in weis.
151     function tokensleft() public constant returns(uint256) {
152         return DMT_TotalSuply > tokensGenerated ? DMT_TotalSuply - tokensGenerated : 0;
153     }
154 
155     function maxCapReached() public constant returns(bool) {
156         return totalInvestedInWei >= maxCap;
157     }
158 
159     function minCapReached() public constant returns(bool) {
160         return totalInvestedInWei >= minCap;
161     }
162 
163     function () public payable {
164         buy();
165     }
166 
167     /// @notice Pauses the contribution if there is any issue
168     function pauseContribution(bool _paused) onlyOwner {
169         paused = _paused;
170     }
171     
172     function initialize(address _vault) public onlyOwner {
173         require(!isInitialized);
174         require(_vault != 0x0);
175         isInitialized = true;
176         vault = _vault;
177         Initialized(block.number, getTime());
178     }
179 
180     function buy() public payable notPaused {
181         require(isInitialized);
182         require(hasStarted());
183         require(!hasEnded());
184         require(isValidPurchase(msg.value));
185         whitelistInvestor(msg.sender);
186         address investor = msg.sender;
187         investorBalances[investor] += msg.value;
188         uint256 tokens = msg.value.mul(exchangeRate).div(1e18);
189         investorToken[investor] += tokens;
190         tokensGenerated += tokens;
191         totalInvestedInWei += msg.value;
192         forwardFunds(msg.value);
193         NewSale(investor, tokens);
194         if(hasEnded()){
195             endBlock = block.number;
196             Finalized(endBlock, getTime());
197         }
198     }
199     function forwardFunds(uint256 _amount) internal {
200         vault.transfer(_amount);
201     }
202 
203     function getTime() internal view returns(uint256) {
204         return now;
205     }
206     
207     function isValidPurchase(uint256 _amount) internal view returns(bool) {
208         bool nonZero = _amount > 0;
209         bool hasMinimumAmount = investorBalances[msg.sender].add(_amount) >= minimum_investment;
210         bool withinCap = totalInvestedInWei.add(_amount) <= maxCap;
211         return hasMinimumAmount && withinCap && nonZero;
212     }
213     function whitelistInvestor(address _newInvestor) internal {
214         if(!whitelist[_newInvestor]) {
215             whitelist[_newInvestor] = true;
216             investorsLength++;
217         }
218     }
219     function whitelistInvestors(address[] _investors) external onlyOwner {
220         require(_investors.length <= 250);
221         for(uint8 i=0; i<_investors.length;i++) {
222             address newInvestor = _investors[i];
223             if(!whitelist[newInvestor]) {
224                 whitelist[newInvestor] = true;
225                 investorsLength++;
226             }
227         }
228     }
229     function blacklistInvestor(address _investor) public onlyOwner {
230         if(whitelist[_investor]) {
231             delete whitelist[_investor];
232             if(investorsLength != 0) {
233                 investorsLength--;
234             }
235         }
236     }
237 
238     event NewSale(address indexed investor, uint256 _tokens);
239     event Initialized(uint256 _block, uint _now);
240     event Finalized(uint256 _block, uint _now);
241 }