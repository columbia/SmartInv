1 pragma solidity ^0.4.19;
2 
3 /**
4  *  MXL PRE SALE CONTRACTS
5  * 
6  *  Adapted from SIKOBA PRE SALE CONTRACTS
7  *
8 **/
9 
10 /**
11  * SIKOBA PRE SALE CONTRACTS
12  *
13  * Version 0.1
14  *
15  * Author Roland Kofler, Alex Kampa, Bok 'BokkyPooBah' Khoo
16  *
17  * MIT LICENSE Copyright 2017 Sikoba Ltd
18  *
19  * Permission is hereby granted, free of charge, to any person obtaining a copy
20  * of this software and associated documentation files (the "Software"), to deal
21  * in the Software without restriction, including without limitation the rights
22  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
23  * copies of the Software, and to permit persons to whom the Software is
24  * furnished to do so, subject to the following conditions:
25  * The above copyright notice and this permission notice shall be included in
26  * all copies or substantial portions of the Software.
27  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33  * SOFTWARE.
34  **/
35 
36 /**
37  *
38  * Important information about the MXL Token pre sale
39  *
40  * For details about the MXL token pre sale, and in particular to find out
41  * about risks and limitations, please visit:
42  *
43  * https://marketxl.io/en/pre-sale/
44  *
45  **/
46 
47 
48 contract Owned {
49     address public owner;
50 
51     function Owned() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner() {
56         if (msg.sender != owner) {
57             revert();
58         }
59         _;
60     }
61 }
62 
63 /// ----------------------------------------------------------------------------------------
64 /// @title MXL PRE SALE CONTRACT
65 /// @author Carlos Afonso
66 /// @dev Changes to this contract will invalidate any security audits done before.
67 /// It is MANDATORY to protocol audits in the "Security reviews done" section
68 ///  # Security checklists to use in each review:
69 ///  - Consensys checklist https://github.com/ConsenSys/smart-contract-best-practices
70 ///  - Roland Kofler's checklist https://github.com/rolandkofler/ether-security
71 ///  - Read all of the code and use creative and lateral thinking to discover bugs
72 ///  # Security reviews done:
73 ///  Date         Auditors       Short summary of the review executed
74 ///  Mar 03 2017 - Roland Kofler  - NO SECURITY REVIEW DONE
75 ///  Mar 07 2017 - Roland Kofler, - Informal Security Review; added overflow protections;
76 ///                Alex Kampa       fixed wrong inequality operators; added maximum amount
77 ///                                 per transactions
78 ///  Mar 07 2017 - Alex Kampa     - Some code clean up; removed restriction of
79 ///                                 MINIMUM_PARTICIPATION_AMOUNT for preallocations
80 ///  Mar 08 2017 - Bok Khoo       - Complete security review and modifications
81 ///  Mar 09 2017 - Roland Kofler  - Check the diffs between MAR 8 and MAR 7 versions
82 ///  Mar 12 2017 - Bok Khoo       - Renamed TOTAL_PREALLOCATION_IN_WEI
83 ///                                 to TOTAL_PREALLOCATION.
84 ///                                 Removed isPreAllocation from addBalance(...)
85 ///  Mar 13 2017 - Bok Khoo       - Made dates in comments consistent
86 ///  Apr 05 2017 - Roland Kofler  - removed the necessity of pre sale end before withdrawing
87 ///                                 thus price drops during pre sale can be mitigated
88 ///  Apr 24 2017 - Alex Kampa     - edited constants and added pre allocation amounts
89 ///
90 ///  Dec 22 2017 - Carlos Afonso  - edited constants removed pre allocation amounts
91 ///                                 
92 /// ----------------------------------------------------------------------------------------
93 contract MXLPresale is Owned {
94     // -------------------------------------------------------------------------------------
95     // TODO Before deployment of contract to Mainnet
96     // 1. Confirm MINIMUM_PARTICIPATION_AMOUNT and MAXIMUM_PARTICIPATION_AMOUNT below
97     // 2. Adjust PRESALE_MINIMUM_FUNDING and PRESALE_MAXIMUM_FUNDING to desired EUR
98     //    equivalents
99     // 3. Adjust PRESALE_START_DATE and confirm the presale period
100     // 4. Test the deployment to a dev blockchain or Testnet to confirm the constructor
101     //    will not run out of gas as this will vary with the number of preallocation
102     //    account entries
103     // 5. A stable version of Solidity has been used. Check for any major bugs in the
104     //    Solidity release announcements after this version.    
105     // -------------------------------------------------------------------------------------
106 
107     // Keep track of the total funding amount
108     uint256 public totalFunding;
109 
110     // Minimum and maximum amounts per transaction for public participants
111     uint256 public constant MINIMUM_PARTICIPATION_AMOUNT = 0.009 ether; 
112     uint256 public constant MAXIMUM_PARTICIPATION_AMOUNT = 90 ether;
113 
114     // Minimum and maximum goals of the pre sale
115 	// Based on Budget of 300k€ to 450k€ at 614€ per ETH on 2018-12-28
116     uint256 public constant PRESALE_MINIMUM_FUNDING = 486 ether;
117     uint256 public constant PRESALE_MAXIMUM_FUNDING = 720 ether;
118 	
119 
120     // Total preallocation in wei
121     //uint256 public constant TOTAL_PREALLOCATION = 999.999 ether; // no preallocation
122 
123     // Public pre sale periods  
124 	// Starts 2018-01-03T00:00:00+00:00 in ISO 8601
125     uint256 public constant PRESALE_START_DATE = 1514937600;
126 	
127 	// Ends 2018-03-27T18:00:00+00:00 in ISO 8601
128     uint256 public constant PRESALE_END_DATE = 1522173600;
129 	
130 	// Limit 30% Bonus 2018-02-18T00:00:00+00:00 in ISO 8601
131 	//uint256 public constant PRESALE_30BONUS_END = 1518912000;  // for reference only
132 	// Limit 15% Bonus 2018-03-09T00:00:00+00:00 in ISO 8601
133 	//uint256 public constant PRESALE_15BONUS_END = 1520553000;  // for reference only
134 	
135 
136     // Owner can clawback after a date in the future, so no ethers remain
137     // trapped in the contract. This will only be relevant if the
138     // minimum funding level is not reached
139     // 2018-04-27T00:00:00+00:00 in ISO 8601
140     uint256 public constant OWNER_CLAWBACK_DATE = 1524787200; 
141 
142     /// @notice Keep track of all participants contributions, including both the
143     ///         preallocation and public phases
144     /// @dev Name complies with ERC20 token standard, etherscan for example will recognize
145     ///      this and show the balances of the address
146     mapping (address => uint256) public balanceOf;
147 
148     /// @notice Log an event for each funding contributed during the public phase
149     /// @notice Events are not logged when the constructor is being executed during
150     ///         deployment, so the preallocations will not be logged
151     event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);
152 
153     function MXLPresale () public payable {
154 		// no preallocated 
155         //assertEquals(TOTAL_PREALLOCATION, msg.value);
156         // Pre-allocations
157         //addBalance(0xe902741cD4666E4023b7E3AB46D3DE2985c996f1, 0.647 ether);
158         //addBalance(0x98aB52E249646cA2b013aF8F2E411bB90C1c9b4d, 66.98333494 ether);
159         //addBalance(0x96050f871811344Dd44C2F5b7bc9741Dff296f5e, 10 ether);
160         //assertEquals(TOTAL_PREALLOCATION, totalFunding);
161     }
162 
163     /// @notice A participant sends a contribution to the contract's address
164     ///         between the PRESALE_STATE_DATE and the PRESALE_END_DATE
165     /// @notice Only contributions between the MINIMUM_PARTICIPATION_AMOUNT and
166     ///         MAXIMUM_PARTICIPATION_AMOUNT are accepted. Otherwise the transaction
167     ///         is rejected and contributed amount is returned to the participant's
168     ///         account
169     /// @notice A participant's contribution will be rejected if the pre sale
170     ///         has been funded to the maximum amount
171     function () public payable {
172         // A participant cannot send funds before the pre sale start date
173         if (now < PRESALE_START_DATE) revert();
174         // A participant cannot send funds after the pre sale end date
175         if (now > PRESALE_END_DATE) revert();
176         // A participant cannot send less than the minimum amount
177         if (msg.value < MINIMUM_PARTICIPATION_AMOUNT) revert();
178         // A participant cannot send more than the maximum amount
179         if (msg.value > MAXIMUM_PARTICIPATION_AMOUNT) revert();
180         // A participant cannot send funds if the pres ale has been reached the maximum
181         // funding amount
182         if (safeIncrement(totalFunding, msg.value) > PRESALE_MAXIMUM_FUNDING) revert();
183         // Register the participant's contribution
184         addBalance(msg.sender, msg.value);
185     }
186 
187     /// @notice The owner can withdraw ethers already during pre sale,
188     ///         only if the minimum funding level has been reached
189     function ownerWithdraw(uint256 _value) external onlyOwner {
190         // The owner cannot withdraw if the pre sale did not reach the minimum funding amount
191         if (totalFunding < PRESALE_MINIMUM_FUNDING) revert();
192         // Withdraw the amount requested
193         if (!owner.send(_value)) revert();
194     }
195 
196     /// @notice The participant will need to withdraw their funds from this contract if
197     ///         the pre sale has not achieved the minimum funding level
198     function participantWithdrawIfMinimumFundingNotReached(uint256 _value) external {
199         // Participant cannot withdraw before the pre sale ends
200         if (now <= PRESALE_END_DATE) revert();
201         // Participant cannot withdraw if the minimum funding amount has been reached
202         if (totalFunding >= PRESALE_MINIMUM_FUNDING) revert();
203         // Participant can only withdraw an amount up to their contributed balance
204         if (balanceOf[msg.sender] < _value) revert();
205         // Participant's balance is reduced by the claimed amount.
206         balanceOf[msg.sender] = safeDecrement(balanceOf[msg.sender], _value);
207         // Send ethers back to the participant's account
208         if (!msg.sender.send(_value)) revert();
209     }
210 
211     /// @notice The owner can clawback any ethers after a date in the future, so no
212     ///         ethers remain trapped in this contract. This will only be relevant
213     ///         if the minimum funding level is not reached
214     function ownerClawback() external onlyOwner {
215         // The owner cannot withdraw before the clawback date
216         if (now < OWNER_CLAWBACK_DATE) revert();
217         // Send remaining funds back to the owner
218         if (!owner.send(this.balance)) revert();
219     }
220 
221     /// @dev Keep track of participants contributions and the total funding amount
222     function addBalance(address participant, uint256 value) private {
223         // Participant's balance is increased by the sent amount
224         balanceOf[participant] = safeIncrement(balanceOf[participant], value);
225         // Keep track of the total funding amount
226         totalFunding = safeIncrement(totalFunding, value);
227         // Log an event of the participant's contribution
228         LogParticipation(participant, value, now);
229     }
230 
231     /// @dev Throw an exception if the amounts are not equal
232     function assertEquals(uint256 expectedValue, uint256 actualValue) private pure {
233         if (expectedValue != actualValue) revert();
234     }
235 
236     /// @dev Add a number to a base value. Detect overflows by checking the result is larger
237     ///      than the original base value.
238     function safeIncrement(uint256 base, uint256 increment) private pure returns (uint256) {
239         uint256 result = base + increment;
240         if (result < base) revert();
241         return result;
242     }
243 
244     /// @dev Subtract a number from a base value. Detect underflows by checking that the result
245     ///      is smaller than the original base value
246     function safeDecrement(uint256 base, uint256 increment) private pure returns (uint256) {
247         uint256 result = base - increment;
248         if (result > base) revert();
249         return result;
250     }
251 }