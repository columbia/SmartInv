1 pragma solidity ^0.4.18;
2 
3 /**
4  * IAME PRIVATE SALE CONTRACT
5  *
6  * Version 0.1
7  *
8  * Author IAME Limited
9  *
10  * MIT LICENSE Copyright 2018 IAME Limited
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
29 /**
30  *
31  * Important information about the IAME Token Private Sale
32  *
33  * For details about the IAME Token Private Sale, and in particular to find out
34  * about risks and limitations, please visit:
35  *
36  * https://www.iame.io
37  * 
38  **/
39  
40 /**
41  * Private Sale Contract Guide:
42  * 
43  * Start Date: 18 April 2018.
44  * Contributions to this contract made before Start Date will be returned to sender.
45  * Closing Date: 20 May 2018 at 2018.
46  * Contributions to this contract made after End Date will be returned to sender.
47  * Minimum Contribution for this Private Sale is 1 Ether.
48  * Contributions of less than 1 Ether will be returned to sender.
49  * Contributors will receive IAM Tokens at the rate of 20,000 IAM per Ether.
50  * IAM Tokens will not be transferred to any other address than the contributing address.
51  * IAM Tokens will be distributed to contributing address no later than 3 weeks after ICO Start.
52  *
53  **/
54 
55 
56 contract Owned {
57   address public owner;
58 
59   function Owned() internal{
60     owner = msg.sender;
61   }
62 
63   modifier onlyOwner() {
64     if (msg.sender != owner) {
65       revert();
66     }
67     _;
68   }
69 }
70 
71 /// ----------------------------------------------------------------------------------------
72 /// @title IAME Private Sale Contract
73 /// @author IAME Ltd
74 /// @dev Changes to this contract will invalidate any security audits done before.
75 /// ----------------------------------------------------------------------------------------
76 contract IAMEPrivateSale is Owned {
77   // -------------------------------------------------------------------------------------
78   // TODO Before deployment of contract to Mainnet
79   // 1. Confirm MINIMUM_PARTICIPATION_AMOUNT below
80   // 2. Adjust PRIVATESALE_START_DATE and confirm the Private Sale period
81   // 3. Test the deployment to a dev blockchain or Testnet
82   // 4. A stable version of Solidity has been used. Check for any major bugs in the
83   //    Solidity release announcements after this version.
84   // -------------------------------------------------------------------------------------
85 
86   // Keep track of the total funding amount
87   uint256 public totalFunding;
88 
89   // Minimum amount per transaction for public participants
90   uint256 public constant MINIMUM_PARTICIPATION_AMOUNT = 1 ether;
91 
92   // Private Sale period
93   uint256 public PRIVATESALE_START_DATE;
94   uint256 public PRIVATESALE_END_DATE;
95 
96   /// @notice This is the constructor to set the dates
97   function IAMEPrivateSale() public{
98     PRIVATESALE_START_DATE = now + 5 days; // 'now' is the block timestamp
99     PRIVATESALE_END_DATE = now + 40 days;
100   }
101 
102   /// @notice Keep track of all participants contributions, including both the
103   ///         preallocation and public phases
104   /// @dev Name complies with ERC20 token standard, etherscan for example will recognize
105   ///      this and show the balances of the address
106   mapping (address => uint256) public balanceOf;
107 
108   /// @notice Log an event for each funding contributed during the public phase
109   event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);
110 
111 
112   /// @notice A participant sends a contribution to the contract's address
113   ///         between the PRIVATESALE_STATE_DATE and the PRIVATESALE_END_DATE
114   /// @notice Only contributions bigger than the MINIMUM_PARTICIPATION_AMOUNT
115   ///         are accepted. Otherwise the transaction
116   ///         is rejected and contributed amount is returned to the participant's
117   ///         account
118   /// @notice A participant's contribution will be rejected if the Private Sale
119   ///         has been funded to the maximum amount
120   function () public payable {
121     // A participant cannot send funds before the Private Sale Start Date
122     if (now < PRIVATESALE_START_DATE) revert();
123     // A participant cannot send funds after the Private Sale End Date
124     if (now > PRIVATESALE_END_DATE) revert();
125     // A participant cannot send less than the minimum amount
126     if (msg.value < MINIMUM_PARTICIPATION_AMOUNT) revert();
127     // Register the participant's contribution
128     addBalance(msg.sender, msg.value);
129   }
130 
131   /// @notice The owner can withdraw ethers already during Private Sale,
132   function ownerWithdraw(uint256 value) external onlyOwner {
133     if (!owner.send(value)) revert();
134   }
135 
136   /// @dev Keep track of participants contributions and the total funding amount
137   function addBalance(address participant, uint256 value) private {
138     // Participant's balance is increased by the sent amount
139     balanceOf[participant] = safeIncrement(balanceOf[participant], value);
140     // Keep track of the total funding amount
141     totalFunding = safeIncrement(totalFunding, value);
142     // Log an event of the participant's contribution
143     LogParticipation(participant, value, now);
144   }
145 
146   /// @dev Add a number to a base value. Detect overflows by checking the result is larger
147   ///      than the original base value.
148   function safeIncrement(uint256 base, uint256 increment) private pure returns (uint256) {
149     uint256 result = base + increment;
150     if (result < base) revert();
151     return result;
152   }
153 
154 }