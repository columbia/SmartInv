1 pragma solidity 0.4.24;
2  
3 /**
4  * Copyright 2018, The Flowchain Foundation Limited
5  *
6  * The FlowchainCoin (FLC) Token Sale Contract
7  * 
8  *  - Private Sale A
9  *  - Monthly Vest
10  */
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that revert on error
15  */
16 library SafeMath {
17     int256 constant private INT256_MIN = -2**255;
18 
19     /**
20     * @dev Multiplies two unsigned integers, reverts on overflow.
21     */
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
24         // benefit is lost if 'b' is also tested.
25         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b);
32 
33         return c;
34     }
35 
36     /**
37     * @dev Multiplies two signed integers, reverts on overflow.
38     */
39     function mul(int256 a, int256 b) internal pure returns (int256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
48 
49         int256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     /**
56     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
57     */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
69     */
70     function div(int256 a, int256 b) internal pure returns (int256) {
71         require(b != 0); // Solidity only automatically asserts when dividing by 0
72         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
73 
74         int256 c = a / b;
75 
76         return c;
77     }
78 
79     /**
80     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
81     */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b <= a);
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89     /**
90     * @dev Subtracts two signed integers, reverts on overflow.
91     */
92     function sub(int256 a, int256 b) internal pure returns (int256) {
93         int256 c = a - b;
94         require((b >= 0 && c <= a) || (b < 0 && c > a));
95 
96         return c;
97     }
98 
99     /**
100     * @dev Adds two unsigned integers, reverts on overflow.
101     */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a);
105 
106         return c;
107     }
108 
109     /**
110     * @dev Adds two signed integers, reverts on overflow.
111     */
112     function add(int256 a, int256 b) internal pure returns (int256) {
113         int256 c = a + b;
114         require((b >= 0 && c >= a) || (b < 0 && c < a));
115 
116         return c;
117     }
118 
119     /**
120     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
121     * reverts when dividing by zero.
122     */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b != 0);
125         return a % b;
126     }
127 }
128 
129 interface Token {
130     /// @dev Mint an amount of tokens and transfer to the backer
131     /// @param to The address of the backer who will receive the tokens
132     /// @param amount The amount of rewarded tokens
133     /// @return The result of token transfer
134     function mintToken(address to, uint amount) external returns (bool success);  
135 
136     /// @param _owner The address from which the balance will be retrieved
137     /// @return The balance
138     function balanceOf(address _owner) public view returns (uint256 balance);
139 
140     /// @notice send `_value` token to `_to` from `msg.sender`
141     /// @param _to The address of the recipient
142     /// @param _value The amount of token to be transferred
143     /// @return Whether the transfer was successful or not
144     function transfer(address _to, uint256 _value) public returns (bool success);    
145 }
146 
147 contract MintableSale {
148     // @notice Create a new mintable sale
149     /// @param vestingAddress The vesting app    
150     /// @param rate The exchange rate
151     /// @param fundingGoalInEthers The funding goal in ethers
152     /// @param durationInMinutes The duration of the sale in minutes
153     /// @return 
154     function createMintableSale(address vestingAddress, uint256 rate, uint256 fundingGoalInEthers, uint durationInMinutes) public returns (bool success);
155 }
156 
157 contract VestingTokenSale is MintableSale {
158     using SafeMath for uint256;
159     uint256 public fundingGoal;
160     uint256 public tokensPerEther;
161     uint public deadline;
162     address public multiSigWallet;
163     uint256 public amountRaised;
164     Token public tokenReward;
165     mapping(address => uint256) public balanceOf;
166     bool fundingGoalReached = false;
167     bool crowdsaleClosed = false;
168     address public creator;
169     address public addressOfTokenUsedAsReward;
170     bool public isFunding = false;
171 
172     /* accredited investors */
173     mapping (address => uint256) public accredited;
174 
175     event FundTransfer(address backer, uint amount);
176 
177     address public addressOfVestingApp;
178     uint256 constant public   VESTING_DURATION    =  31536000; // 1 Year in second
179     uint256 constant public   CLIFF_DURATION      =   2592000; // 1 months (30 days) in second
180 
181     /* Constrctor function */
182     function VestingTokenSale(
183         address _addressOfTokenUsedAsReward
184     ) payable {
185         creator = msg.sender;
186         multiSigWallet = 0x9581973c54fce63d0f5c4c706020028af20ff723;
187 
188         // Token Contract
189         addressOfTokenUsedAsReward = _addressOfTokenUsedAsReward;
190         tokenReward = Token(addressOfTokenUsedAsReward);
191 
192         // Setup accredited investors
193         setupAccreditedAddress(0xec7210E3db72651Ca21DA35309A20561a6F374dd, 1000);
194     }
195 
196     // @dev Start a new mintable sale.
197     // @param vestingAddress The vesting app
198     // @param rate The exchange rate in ether, for example 1 ETH = 6400 FLC
199     // @param fundingGoalInEthers
200     // @param durationInMinutes
201     function createMintableSale(address vestingAddrss, uint256 rate, uint256 fundingGoalInEthers, uint durationInMinutes) public returns (bool success) {
202         require(msg.sender == creator);
203         require(isFunding == false);
204         require(rate <= 6400 && rate >= 1);                   // rate must be between 1 and 6400
205         require(fundingGoalInEthers >= 1);        
206         require(durationInMinutes >= 60 minutes);
207 
208         addressOfVestingApp = vestingAddrss;
209 
210         deadline = now + durationInMinutes * 1 minutes;
211         fundingGoal = amountRaised + fundingGoalInEthers * 1 ether;
212         tokensPerEther = rate;
213         isFunding = true;
214         return true;    
215     }
216 
217     modifier afterDeadline() { if (now > deadline) _; }
218     modifier beforeDeadline() { if (now <= deadline) _; }
219 
220     /// @param _accredited The address of the accredited investor
221     /// @param _amountInEthers The amount of remaining ethers allowed to invested
222     /// @return Amount of remaining tokens allowed to spent
223     function setupAccreditedAddress(address _accredited, uint _amountInEthers) public returns (bool success) {
224         require(msg.sender == creator);    
225         accredited[_accredited] = _amountInEthers * 1 ether;
226         return true;
227     }
228 
229     /// @dev This function returns the amount of remaining ethers allowed to invested
230     /// @return The amount
231     function getAmountAccredited(address _accredited) view returns (uint256) {
232         uint256 amount = accredited[_accredited];
233         return amount;
234     }
235 
236     function closeSale() beforeDeadline {
237         require(msg.sender == creator);    
238         isFunding = false;
239     }
240 
241     // change creator address
242     function changeCreator(address _creator) external {
243         require(msg.sender == creator);
244         creator = _creator;
245     }
246 
247     /// @dev This function returns the current exchange rate during the sale
248     /// @return The address of token creator
249     function getRate() beforeDeadline view returns (uint) {
250         return tokensPerEther;
251     }
252 
253     /// @dev This function returns the amount raised in wei
254     /// @return The address of token creator
255     function getAmountRaised() view returns (uint) {
256         return amountRaised;
257     }
258 
259     function () payable {
260         // check if we can offer the private sale
261         require(isFunding == true && amountRaised < fundingGoal);
262 
263         // the minimum deposit is 1 ETH
264         uint256 amount = msg.value;        
265         require(amount >= 1 ether);
266 
267         require(accredited[msg.sender] - amount >= 0); 
268 
269         multiSigWallet.transfer(amount);      
270         balanceOf[msg.sender] += amount;
271         accredited[msg.sender] -= amount;
272         amountRaised += amount;
273         FundTransfer(msg.sender, amount);
274 
275         // total releasable tokens
276         uint256 value = amount.mul(tokensPerEther);
277 
278         // Mint tokens and keep it in the contract
279         tokenReward.mintToken(addressOfVestingApp, value);
280     }   
281 }