1 pragma solidity ^0.4.8;
2 
3 /**
4  * SIKOBA PRESALE CONTRACTS
5  *
6  * Version 0.1
7  *
8  * Author Roland Kofler, Alex Kampa, Bok 'BokkyPooBah' Khoo
9  *
10  * MIT LICENSE Copyright 2017 Sikoba Ltd
11  *
12  * Permission is hereby granted, free of charge, to any person obtaining a copy
13  * of this software and associated documentation files (the "Software"), to deal
14  * in the Software without restriction, including without limitation the rights
15  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16  * copies of the Software, and to permit persons to whom the Software is
17  * furnished to do so, subject to the following conditions:
18  * The above copyright notice and this permission notice shall be included in
19  * all copies or substantial portions of the Software.
20  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
23  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
24  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
26  * SOFTWARE.
27  **/
28 
29 
30 /**
31  *
32  * Important information about the Sikoba token presale
33  *
34  * For details about the Sikoba token presale, and in particular to find out
35  * about risks and limitations, please visit:
36  *
37  * http://www.sikoba.com/www/presale/index.html
38  *
39  **/
40 
41 
42 contract Owned {
43     address public owner;
44 
45     function Owned() {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner() {
50         if (msg.sender != owner) {
51             throw;
52         }
53         _;
54     }
55 }
56 
57 /// ----------------------------------------------------------------------------------------
58 /// @title Sikoba Presale Contract
59 /// @author Roland Kofler, Alex Kampa, Bok 'Bokky Poo Bah' Khoo
60 /// @dev Changes to this contract will invalidate any security audits done before.
61 /// It is MANDATORY to protocol audits in the "Security reviews done" section
62 ///  # Security checklists to use in each review:
63 ///  - Consensys checklist https://github.com/ConsenSys/smart-contract-best-practices
64 ///  - Roland Kofler's checklist https://github.com/rolandkofler/ether-security
65 ///  - Read all of the code and use creative and lateral thinking to discover bugs
66 ///  # Security reviews done:
67 ///  Date         Auditors       Short summary of the review executed
68 ///  Mar 03 2017 - Roland Kofler  - NO SECURITY REVIEW DONE
69 ///  Mar 07 2017 - Roland Kofler, - Informal Security Review; added overflow protections;
70 ///                Alex Kampa       fixed wrong inequality operators; added maximum amount
71 ///                                 per transactions
72 ///  Mar 07 2017 - Alex Kampa     - Some code clean up; removed restriction of
73 ///                                 MINIMUM_PARTICIPATION_AMOUNT for preallocations
74 ///  Mar 08 2017 - Bok Khoo       - Complete security review and modifications
75 ///  Mar 09 2017 - Roland Kofler  - Check the diffs between MAR 8 and MAR 7 versions
76 ///  Mar 12 2017 - Bok Khoo       - Renamed TOTAL_PREALLOCATION_IN_WEI
77 ///                                 to TOTAL_PREALLOCATION.
78 ///                                 Removed isPreAllocation from addBalance(...)
79 ///  Mar 13 2017 - Bok Khoo       - Made dates in comments consistent
80 ///  Apr 05 2017 - Roland Kofler  - removed the necessity of presale end before withdrawing
81 ///                                 thus price drops during presale can be mitigated
82 ///  Apr 24 2017 - Alex Kampa     - edited constants and added pre-allocation amounts
83 ///                                 
84 /// ----------------------------------------------------------------------------------------
85 contract SikobaPresale is Owned {
86     // -------------------------------------------------------------------------------------
87     // TODO Before deployment of contract to Mainnet
88     // 1. Confirm MINIMUM_PARTICIPATION_AMOUNT and MAXIMUM_PARTICIPATION_AMOUNT below
89     // 2. Adjust PRESALE_MINIMUM_FUNDING and PRESALE_MAXIMUM_FUNDING to desired EUR
90     //    equivalents
91     // 3. Adjust PRESALE_START_DATE and confirm the presale period
92     // 4. Update TOTAL_PREALLOCATION to the total preallocations received
93     // 5. Add each preallocation address and funding amount from the Sikoba bookmaker
94     //    to the constructor function
95     // 6. Test the deployment to a dev blockchain or Testnet to confirm the constructor
96     //    will not run out of gas as this will vary with the number of preallocation
97     //    account entries
98     // 7. A stable version of Solidity has been used. Check for any major bugs in the
99     //    Solidity release announcements after this version.
100     // 8. Remember to send the preallocated funds when deploying the contract!
101     // -------------------------------------------------------------------------------------
102 
103     // Keep track of the total funding amount
104     uint256 public totalFunding;
105 
106     // Minimum and maximum amounts per transaction for public participants
107     uint256 public constant MINIMUM_PARTICIPATION_AMOUNT =   1 ether;
108     uint256 public constant MAXIMUM_PARTICIPATION_AMOUNT = 250 ether;
109 
110     // Minimum and maximum goals of the presale
111     uint256 public constant PRESALE_MINIMUM_FUNDING = 4000 ether;
112     uint256 public constant PRESALE_MAXIMUM_FUNDING = 8000 ether;
113 
114     // Total preallocation in wei
115     uint256 public constant TOTAL_PREALLOCATION = 496.46472668 ether;
116 
117     // Public presale period
118     // Starts Apr 25 2017 @ 12:00pm (UTC) 2017-04-05T12:00:00+00:00 in ISO 8601
119     // Ends May 15 2017 @ 12:00pm (UTC) 2017-05-15T12:00:00+00:00 in ISO 8601
120     uint256 public constant PRESALE_START_DATE = 1493121600;
121     uint256 public constant PRESALE_END_DATE = 1494849600;
122 
123     // Owner can clawback after a date in the future, so no ethers remain
124     // trapped in the contract. This will only be relevant if the
125     // minimum funding level is not reached
126     // Jan 01 2018 @ 12:00pm (UTC) 2018-01-01T12:00:00+00:00 in ISO 8601
127     uint256 public constant OWNER_CLAWBACK_DATE = 1514808000;
128 
129     /// @notice Keep track of all participants contributions, including both the
130     ///         preallocation and public phases
131     /// @dev Name complies with ERC20 token standard, etherscan for example will recognize
132     ///      this and show the balances of the address
133     mapping (address => uint256) public balanceOf;
134 
135     /// @notice Log an event for each funding contributed during the public phase
136     /// @notice Events are not logged when the constructor is being executed during
137     ///         deployment, so the preallocations will not be logged
138     event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);
139 
140     function SikobaPresale () payable {
141         assertEquals(TOTAL_PREALLOCATION, msg.value);
142         // Pre-allocations
143         addBalance(0xe902741cD4666E4023b7E3AB46D3DE2985c996f1, 0.647 ether);
144         addBalance(0x98aB52E249646cA2b013aF8F2E411bB90C1c9b4d, 66.98333494 ether);
145         addBalance(0x7C6003EDEB99886E8D65b5a3AF81Cd82962266f6, 1.0508692 ether);
146         addBalance(0x7C6003EDEB99886E8D65b5a3AF81Cd82962266f6, 1.9491308 ether);
147         addBalance(0x99a4f90e16C043197dA52d5d8c9B36A106c27042, 13 ether);
148         addBalance(0x452F7faa5423e8D38435FFC5cFBA6Da806F159a5, 0.412 ether);
149         addBalance(0x7FEA1962E35D62059768C749bedd96cAB930D378, 127.8142 ether);
150         addBalance(0x0bFEc3578B7174997EFBf145b8d5f5b5b66F273f, 10 ether);
151         addBalance(0xB4f14EDd0e846727cAe9A4B866854ed1bfE95781, 110 ether);
152         addBalance(0xB6500cebED3334DCd9A5484D27a1986703BDcB1A, 0.9748227 ether);
153         addBalance(0x8FBCE39aB5f2664506d6C3e3CD39f8A419784f62, 75.1 ether);
154         addBalance(0x665A816F54020a5A255b366b7763D5dfE6f87940, 9 ether);
155         addBalance(0x665A816F54020a5A255b366b7763D5dfE6f87940, 12 ether);
156         addBalance(0x9cB37d0Ae943C8B4256e71F98B2dD0935e89344f, 10 ether);
157         addBalance(0x00F87D9949B8E96f7c70F9Dd5a6951258729c5C3, 22.24507475 ether);
158         addBalance(0xFf2694cd9Ca6a72C7864749072Fab8DB6090a1Ca, 10 ether);
159         addBalance(0xCb5A0bC5EfC931C336fa844C920E070E6fc4e6ee, 0.27371429 ether);
160         addBalance(0xd956d333BF4C89Cb4e3A3d833610817D8D4bedA3, 1 ether);
161         addBalance(0xBA43Bbd58E0F389B5652a507c8F9d30891750C00, 2 ether);
162         addBalance(0x1203c41aE7469B837B340870CE4F2205b035E69F, 5 ether);
163         addBalance(0x8efdB5Ee103c2295dAb1410B4e3d1eD7A91584d4, 1 ether);
164         addBalance(0xed1B8bbAE30a58Dc1Ce57bCD7DcA51eB75e1fde9, 6.01458 ether);
165         addBalance(0x96050f871811344Dd44C2F5b7bc9741Dff296f5e, 10 ether);
166         assertEquals(TOTAL_PREALLOCATION, totalFunding);
167     }
168 
169     /// @notice A participant sends a contribution to the contract's address
170     ///         between the PRESALE_STATE_DATE and the PRESALE_END_DATE
171     /// @notice Only contributions between the MINIMUM_PARTICIPATION_AMOUNT and
172     ///         MAXIMUM_PARTICIPATION_AMOUNT are accepted. Otherwise the transaction
173     ///         is rejected and contributed amount is returned to the participant's
174     ///         account
175     /// @notice A participant's contribution will be rejected if the presale
176     ///         has been funded to the maximum amount
177     function () payable {
178         // A participant cannot send funds before the presale start date
179         if (now < PRESALE_START_DATE) throw;
180         // A participant cannot send funds after the presale end date
181         if (now > PRESALE_END_DATE) throw;
182         // A participant cannot send less than the minimum amount
183         if (msg.value < MINIMUM_PARTICIPATION_AMOUNT) throw;
184         // A participant cannot send more than the maximum amount
185         if (msg.value > MAXIMUM_PARTICIPATION_AMOUNT) throw;
186         // A participant cannot send funds if the presale has been reached the maximum
187         // funding amount
188         if (safeIncrement(totalFunding, msg.value) > PRESALE_MAXIMUM_FUNDING) throw;
189         // Register the participant's contribution
190         addBalance(msg.sender, msg.value);
191     }
192 
193     /// @notice The owner can withdraw ethers already during presale,
194     ///         only if the minimum funding level has been reached
195     function ownerWithdraw(uint256 value) external onlyOwner {
196         // The owner cannot withdraw if the presale did not reach the minimum funding amount
197         if (totalFunding < PRESALE_MINIMUM_FUNDING) throw;
198         // Withdraw the amount requested
199         if (!owner.send(value)) throw;
200     }
201 
202     /// @notice The participant will need to withdraw their funds from this contract if
203     ///         the presale has not achieved the minimum funding level
204     function participantWithdrawIfMinimumFundingNotReached(uint256 value) external {
205         // Participant cannot withdraw before the presale ends
206         if (now <= PRESALE_END_DATE) throw;
207         // Participant cannot withdraw if the minimum funding amount has been reached
208         if (totalFunding >= PRESALE_MINIMUM_FUNDING) throw;
209         // Participant can only withdraw an amount up to their contributed balance
210         if (balanceOf[msg.sender] < value) throw;
211         // Participant's balance is reduced by the claimed amount.
212         balanceOf[msg.sender] = safeDecrement(balanceOf[msg.sender], value);
213         // Send ethers back to the participant's account
214         if (!msg.sender.send(value)) throw;
215     }
216 
217     /// @notice The owner can clawback any ethers after a date in the future, so no
218     ///         ethers remain trapped in this contract. This will only be relevant
219     ///         if the minimum funding level is not reached
220     function ownerClawback() external onlyOwner {
221         // The owner cannot withdraw before the clawback date
222         if (now < OWNER_CLAWBACK_DATE) throw;
223         // Send remaining funds back to the owner
224         if (!owner.send(this.balance)) throw;
225     }
226 
227     /// @dev Keep track of participants contributions and the total funding amount
228     function addBalance(address participant, uint256 value) private {
229         // Participant's balance is increased by the sent amount
230         balanceOf[participant] = safeIncrement(balanceOf[participant], value);
231         // Keep track of the total funding amount
232         totalFunding = safeIncrement(totalFunding, value);
233         // Log an event of the participant's contribution
234         LogParticipation(participant, value, now);
235     }
236 
237     /// @dev Throw an exception if the amounts are not equal
238     function assertEquals(uint256 expectedValue, uint256 actualValue) private constant {
239         if (expectedValue != actualValue) throw;
240     }
241 
242     /// @dev Add a number to a base value. Detect overflows by checking the result is larger
243     ///      than the original base value.
244     function safeIncrement(uint256 base, uint256 increment) private constant returns (uint256) {
245         uint256 result = base + increment;
246         if (result < base) throw;
247         return result;
248     }
249 
250     /// @dev Subtract a number from a base value. Detect underflows by checking that the result
251     ///      is smaller than the original base value
252     function safeDecrement(uint256 base, uint256 increment) private constant returns (uint256) {
253         uint256 result = base - increment;
254         if (result > base) throw;
255         return result;
256     }
257 }