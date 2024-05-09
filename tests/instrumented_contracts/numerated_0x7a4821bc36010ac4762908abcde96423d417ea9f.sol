1 pragma solidity ^0.5.0;
2 
3 
4 // Safe math
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22     
23      //not a SafeMath function
24     function max(uint a, uint b) private pure returns (uint) {
25         return a > b ? a : b;
26     }
27     
28 }
29 
30 
31 // ERC Token Standard #20 Interface
32 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
33 contract ERC20Interface {
34     function totalSupply() public view returns (uint);
35     function balanceOf(address tokenOwner) public view returns (uint balance);
36     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 
46 // Owned contract
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 
74 
75 /// @title  A test contract to store and exchange Dai, Ether, and test INCH tokens. 
76 /// @author Decentralized
77 /// @notice Use the 4 withdrawel and deposit functions in your this contract to short and long ETH. ETH/Dai price is
78 ///         pegged at 300 to 1. INCH burn rate is 1% per deposit
79 ///         Because there is no UI for this contract, KEEP IN MIND THAT ALL VALUES ARE IN MINIMUM DENOMINATIONS
80 ///         IN OTHER WORDS ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AND INPUT AS 10^-18 * THE BASE UNIT OF CURRENCY
81 ///         Other warnings: This is a test contract. Do not risk any significant value. You are not guaranteed a 
82 ///         refund, even if it's my fault. Do not send any tokens or assets directly to the contract. 
83 ///         DO NOT SEND ANY TOKENS OR ASSETS DIRECTLY TO THE CONTRACT. Use only the withdrawel and deposit functions
84 /// @dev    Addresses and 'deployership' must be initialized before use. INCH must be deposited in contract
85 ///         Ownership will be set to 0x0 after initialization
86 contract VaultPOC is Owned {
87     using SafeMath for uint;
88 
89     uint public constant initialSupply = 1000000000000000000000;
90 
91     uint public constant etherPeg = 300;
92     uint8 public constant burnRate = 1;
93     
94     mapping(address => uint) balances;
95     mapping(address => mapping(address => uint)) allowed;
96 
97     ERC20Interface inchWormContract;
98     ERC20Interface daiContract;
99     address deployer; //retains ability to transfer mistaken ERC20s after ownership is revoked
100     
101     //____________________________________________________________________________________
102     // Inititialization functions
103     
104     /// @notice Sets the address for the INCH and Dai tokens, as well as the deployer
105     function initialize(address _inchwormAddress, address _daiAddress) external onlyOwner {
106         inchWormContract = ERC20Interface(_inchwormAddress);
107         daiContract = ERC20Interface(_daiAddress);
108         deployer = owner;
109     }
110 
111     //____________________________________________________________________________________
112     
113     
114     
115     
116     //____________________________________________________________________________________
117     // Deposit and withdrawel functions
118 
119 
120     /* @notice Make a deposit by including payment in function call
121                Wei deposited will be rewarded with INCH tokens. Exchange rate changes over time
122                Call will fail with insufficient Wei balance from sender or INCH balance in vault
123                ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AND INPUT AS 10^-18 * THE BASE UNIT OF CURRENCY
124        @dev    Function will fail if totalSupply < 0.01 * initialSupply.To be fixed 
125                Exchange rate is 1 Wei : 300 * totalSupply/initialSupply *10**-18
126     */
127     function depositWeiForInch() external payable {
128         uint _percentOfInchRemaining = inchWormContract.totalSupply().mul(100).div(initialSupply);
129         uint _tokensToWithdraw = msg.value.mul(etherPeg);
130         _tokensToWithdraw = _tokensToWithdraw.mul(_percentOfInchRemaining).div(100);
131         inchWormContract.transfer(msg.sender, _tokensToWithdraw);
132     }
133     
134      /* @param  Dai to deposit in contract, denomination 1*10**-18 Dai
135         @notice Dai deposited will be rewarded with INCH tokens. Exchange rate changes over time
136                 Call will fail with insufficient Dai balance from sender or INCH balance in vault
137                 ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AND INPUT AS 10^-18 * THE BASE UNIT OF CURRENCY
138         @dev    Exchange rate is 1*10**-18 Dai : totalSupply/initialSupply
139     */
140     function depositDaiForInch(uint _daiToDeposit) external {
141         uint _percentOfInchRemaining = inchWormContract.totalSupply().mul(100).div(initialSupply);
142         uint _tokensToWithdraw = _daiToDeposit.mul(_percentOfInchRemaining).div(100);
143         
144         inchWormContract.transfer(msg.sender, _tokensToWithdraw);
145         daiContract.transferFrom(msg.sender, address(this), _daiToDeposit);
146     }
147     
148     /* @param  Wei to withdraw from contract
149        @notice INCH must be deposited in exchange for the withdrawel. Exchange rate changes over time
150                Call will fail with insufficient INCH balance from sender or insufficient Wei balance in the vault
151                1% of INCH deposited is burned
152                ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AND INPUT AS 10^-18 * THE BASE UNIT OF CURRENCY
153        @dev    Exchange rate is 1 Wei : 300 * totalSupply/initialSupply *10**-18
154     */
155     function withdrawWei(uint _weiToWithdraw) external {
156         uint _inchToDeposit = _weiToWithdraw.mul(etherPeg).mul((initialSupply.div(inchWormContract.totalSupply())));
157         inchWormContract.transferFrom(msg.sender, address(this), _inchToDeposit); 
158         uint _inchToBurn = _inchToDeposit.mul(burnRate).div(100);
159         inchWormContract.transfer(address(0), _inchToBurn);
160         msg.sender.transfer(1 wei * _weiToWithdraw);
161     }
162     
163     /* @param  Dai to withdraw from contract, denomination 1*10**-18 Dai
164        @notice INCH must be deposited in exchange for the withdrawel. Exchange rate changes over time
165                Call will fail with insufficient INCH balance from sender or insufficient Dai balance in the vault
166                1% of INCH deposited is burned
167                ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AND INPUT AS 10^-18 * THE BASE UNIT OF CURRENCY
168        @dev    Exchange rate is 1*10**-18 Dai : totalSupply/initialSupply
169     */
170     function withdrawDai(uint _daiToWithdraw) external {
171         uint _inchToDeposit = _daiToWithdraw.mul(initialSupply.div(inchWormContract.totalSupply()));
172         inchWormContract.transferFrom(msg.sender, address(this), _inchToDeposit); 
173         uint _inchToBurn = _inchToDeposit.mul(burnRate).div(100);
174         inchWormContract.transfer(address(0), _inchToBurn);
175         daiContract.transfer(msg.sender, _daiToWithdraw); 
176     }
177     
178     //____________________________________________________________________________________
179     
180     
181     
182     
183     //____________________________________________________________________________________
184     // view functions
185     
186     /// @notice Returns the number of INCH recieved per Dai, 
187     ///         ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AS 10^-18 * THE BASE UNIT OF CURRENCY
188     function getInchDaiRate() public view returns(uint) {
189         return initialSupply.div(inchWormContract.totalSupply());
190     }
191     
192     /// @notice Returns the number of INCH recieved per Eth
193     ///         ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AS 10^-18 * THE BASE UNIT OF CURRENCY
194     function getInchEthRate() public view returns(uint) {
195         etherPeg.mul((initialSupply.div(inchWormContract.totalSupply())));
196     }
197     
198     /// @notice Returns the Wei balance of the vault contract
199     ///         ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AS 10^-18 * THE BASE UNIT OF CURRENCY
200     function getEthBalance() public view returns(uint) {
201         return address(this).balance;
202     }
203     
204     /// @notice Returns the INCH balance of the vault contract
205     ///         ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AS 10^-18 * THE BASE UNIT OF CURRENCY
206     function getInchBalance() public view returns(uint) {
207         return inchWormContract.balanceOf(address(this));
208     }
209     
210     /// @notice Returns the Dai balance of the vault contract
211     ///         ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AS 10^-18 * THE BASE UNIT OF CURRENCY
212     function getDaiBalance() public view returns(uint) {
213         return daiContract.balanceOf(address(this));
214     }
215     
216     /// @notice Returns the percent of INCH that has not been burned (sent to 0X0)
217     /// @dev    Implicitly floors the result
218     ///         INCH sent to burn addresses other than 0x0 are not currently included in calculation
219     function getPercentOfInchRemaining() external view returns(uint) {
220        return inchWormContract.totalSupply().mul(100).div(initialSupply);
221     }
222     
223     //____________________________________________________________________________________
224 
225 
226 
227     //____________________________________________________________________________________
228     // emergency and fallback functions
229     
230     /// @notice original deployer can transfer out tokens other than Dai and INCH
231     function transferAccidentalERC20Tokens(address tokenAddress, uint tokens) external returns (bool success) {
232         require(msg.sender == deployer);
233         require(tokenAddress != address(inchWormContract));
234         require(tokenAddress != address(daiContract));
235         
236         return ERC20Interface(tokenAddress).transfer(owner, tokens);
237     }
238     
239     // fallback function
240     function () external payable {
241         revert();
242     }
243     
244     //____________________________________________________________________________________
245     
246 }