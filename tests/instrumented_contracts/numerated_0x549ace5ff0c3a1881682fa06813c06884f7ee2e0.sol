1 pragma solidity ^0.4.18;
2  
3 /**
4  * Copyright 2018, Flowchain.co
5  *
6  * The FlowchainCoin (FLC) smart contract of private sale Round A
7  */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that revert on error
12  */
13 library SafeMath {
14     int256 constant private INT256_MIN = -2**255;
15 
16     /**
17     * @dev Multiplies two unsigned integers, reverts on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21         // benefit is lost if 'b' is also tested.
22         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29 
30         return c;
31     }
32 
33     /**
34     * @dev Multiplies two signed integers, reverts on overflow.
35     */
36     function mul(int256 a, int256 b) internal pure returns (int256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
45 
46         int256 c = a * b;
47         require(c / a == b);
48 
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // Solidity only automatically asserts when dividing by 0
57         require(b > 0);
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     /**
65     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
66     */
67     function div(int256 a, int256 b) internal pure returns (int256) {
68         require(b != 0); // Solidity only automatically asserts when dividing by 0
69         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
70 
71         int256 c = a / b;
72 
73         return c;
74     }
75 
76     /**
77     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
78     */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87     * @dev Subtracts two signed integers, reverts on overflow.
88     */
89     function sub(int256 a, int256 b) internal pure returns (int256) {
90         int256 c = a - b;
91         require((b >= 0 && c <= a) || (b < 0 && c > a));
92 
93         return c;
94     }
95 
96     /**
97     * @dev Adds two unsigned integers, reverts on overflow.
98     */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a);
102 
103         return c;
104     }
105 
106     /**
107     * @dev Adds two signed integers, reverts on overflow.
108     */
109     function add(int256 a, int256 b) internal pure returns (int256) {
110         int256 c = a + b;
111         require((b >= 0 && c >= a) || (b < 0 && c < a));
112 
113         return c;
114     }
115 
116     /**
117     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
118     * reverts when dividing by zero.
119     */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }
125 
126 interface Token {
127     function mintToken(address to, uint amount) external returns (bool success);  
128     function setupMintableAddress(address _mintable) public returns (bool success);
129 }
130 
131 contract MintableSale {
132     // @notice Create a new mintable sale
133     /// @param rate The exchange rate
134     /// @param fundingGoalInEthers The funding goal in ethers
135     /// @param durationInMinutes The duration of the sale in minutes
136     /// @return 
137     function createMintableSale(uint256 rate, uint256 fundingGoalInEthers, uint durationInMinutes) external returns (bool success);
138 }
139 
140 contract EarlyTokenSale is MintableSale {
141     using SafeMath for uint256;
142     uint256 public fundingGoal;
143     uint256 public tokensPerEther;
144     uint public deadline;
145     address public multiSigWallet;
146     uint256 public amountRaised;
147     Token public tokenReward;
148     mapping(address => uint256) public balanceOf;
149     bool fundingGoalReached = false;
150     bool crowdsaleClosed = false;
151     address public creator;
152     address public addressOfTokenUsedAsReward;
153     bool public isFunding = false;
154 
155     /* accredited investors */
156     mapping (address => uint256) public accredited;
157 
158     event FundTransfer(address backer, uint amount);
159 
160     /* Constrctor function */
161     function EarlyTokenSale(
162         address _addressOfTokenUsedAsReward
163     ) payable {
164         creator = msg.sender;
165         multiSigWallet = 0x9581973c54fce63d0f5c4c706020028af20ff723;
166         // Token Contract
167         addressOfTokenUsedAsReward = _addressOfTokenUsedAsReward;
168         tokenReward = Token(addressOfTokenUsedAsReward);
169         // Setup accredited investors
170         setupAccreditedAddress(0xec7210E3db72651Ca21DA35309A20561a6F374dd, 1000);
171     }
172 
173     // @dev Start a new mintable sale.
174     // @param rate The exchange rate in ether, for example 1 ETH = 6400 FLC
175     // @param fundingGoalInEthers
176     // @param durationInMinutes
177     function createMintableSale(uint256 rate, uint256 fundingGoalInEthers, uint durationInMinutes) external returns (bool success) {
178         require(msg.sender == creator);
179         require(isFunding == false);
180         require(rate <= 6400 && rate >= 1);                   // rate must be between 1 and 6400
181         require(fundingGoalInEthers >= 1000);        
182         require(durationInMinutes >= 60 minutes);
183 
184         deadline = now + durationInMinutes * 1 minutes;
185         fundingGoal = amountRaised + fundingGoalInEthers * 1 ether;
186         tokensPerEther = rate;
187         isFunding = true;
188         return true;    
189     }
190 
191     modifier afterDeadline() { if (now > deadline) _; }
192     modifier beforeDeadline() { if (now <= deadline) _; }
193 
194     /// @param _accredited The address of the accredited investor
195     /// @param _amountInEthers The amount of remaining ethers allowed to invested
196     /// @return Amount of remaining tokens allowed to spent
197     function setupAccreditedAddress(address _accredited, uint _amountInEthers) public returns (bool success) {
198         require(msg.sender == creator);    
199         accredited[_accredited] = _amountInEthers * 1 ether;
200         return true;
201     }
202 
203     /// @dev This function returns the amount of remaining ethers allowed to invested
204     /// @return The amount
205     function getAmountAccredited(address _accredited) view returns (uint256) {
206         uint256 amount = accredited[_accredited];
207         return amount;
208     }
209 
210     function closeSale() beforeDeadline {
211         require(msg.sender == creator);    
212         isFunding = false;
213     }
214 
215     // change creator address
216     function changeCreator(address _creator) external {
217         require(msg.sender == creator);
218         creator = _creator;
219     }
220 
221     /// @dev This function returns the current exchange rate during the sale
222     /// @return The address of token creator
223     function getRate() beforeDeadline view returns (uint) {
224         return tokensPerEther;
225     }
226 
227     /// @dev This function returns the amount raised in wei
228     /// @return The address of token creator
229     function getAmountRaised() view returns (uint) {
230         return amountRaised;
231     }
232 
233     function () payable {
234         // check if we can offer the private sale
235         require(isFunding == true && amountRaised < fundingGoal);
236 
237         // the minimum deposit is 1 ETH
238         uint256 amount = msg.value;        
239         require(amount >= 1 ether);
240 
241         require(accredited[msg.sender] - amount >= 0); 
242 
243         multiSigWallet.transfer(amount);      
244         balanceOf[msg.sender] += amount;
245         accredited[msg.sender] -= amount;
246         amountRaised += amount;
247         FundTransfer(msg.sender, amount);
248 
249         uint256 value = amount.mul(tokensPerEther);        
250         tokenReward.mintToken(msg.sender, value);        
251     }
252 }