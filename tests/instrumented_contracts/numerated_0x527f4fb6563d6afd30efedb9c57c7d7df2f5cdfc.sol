1 /*
2 
3   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9   http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 pragma solidity 0.5.7;
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 }
38 
39 contract Token {
40     /* This is a slight change to the ERC20 base standard.
41     function totalSupply() constant returns (uint256 supply);
42     is replaced with:
43     uint256 public totalSupply;
44     This automatically creates a getter function for the totalSupply.
45     This is moved to the base contract since public getter functions are not
46     currently recognised as an implementation of the matching abstract
47     function by the compiler.
48     */
49     /// total amount of tokens
50     uint256 public totalSupply;
51 
52     /// @param _owner The address from which the balance will be retrieved
53     /// @return The balance
54     function balanceOf(address _owner) view public returns (uint256 balance);
55 
56     /// @notice send `_value` token to `_to` from `msg.sender`
57     /// @param _to The address of the recipient
58     /// @param _value The amount of token to be transferred
59     /// @return Whether the transfer was successful or not
60     function transfer(address _to, uint256 _value) public returns (bool success);
61 
62     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
63     /// @param _from The address of the sender
64     /// @param _to The address of the recipient
65     /// @param _value The amount of token to be transferred
66     /// @return Whether the transfer was successful or not
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
68 
69     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
70     /// @param _spender The address of the account able to transfer the tokens
71     /// @param _value The amount of tokens to be approved for transfer
72     /// @return Whether the approval was successful or not
73     function approve(address _spender, uint256 _value) public returns (bool success);
74 
75     /// @param _owner The address of the account owning tokens
76     /// @param _spender The address of the account able to transfer the tokens
77     /// @return Amount of remaining tokens allowed to spent
78     function allowance(address _owner, address _spender) view public returns (uint256 remaining);
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82 }
83 
84 /// @title Ownable
85 /// @dev The Ownable contract has an owner address, and provides basic
86 ///      authorization control functions, this simplifies the implementation of
87 ///      "user permissions".
88 contract Ownable {
89     address public owner;
90 
91     event OwnershipTransferred(
92         address indexed previousOwner,
93         address indexed newOwner
94     );
95 
96     /// @dev The Ownable constructor sets the original `owner` of the contract
97     ///      to the sender.
98     constructor()
99         public
100     {
101         owner = msg.sender;
102     }
103 
104     /// @dev Throws if called by any account other than the owner.
105     modifier onlyOwner()
106     {
107         require(msg.sender == owner, "NOT_OWNER");
108         _;
109     }
110 
111     /// @dev Allows the current owner to transfer control of the contract to a
112     ///      newOwner.
113     /// @param newOwner The address to transfer ownership to.
114     function transferOwnership(
115         address newOwner
116         )
117         public
118         onlyOwner
119     {
120         require(newOwner != address(0x0), "ZERO_ADDRESS");
121         emit OwnershipTransferred(owner, newOwner);
122         owner = newOwner;
123     }
124 }
125 
126 contract Claimable is Ownable {
127     address public pendingOwner;
128 
129     /// @dev Modifier throws if called by any account other than the pendingOwner.
130     modifier onlyPendingOwner() {
131         require(msg.sender == pendingOwner, "UNAUTHORIZED");
132         _;
133     }
134 
135     /// @dev Allows the current owner to set the pendingOwner address.
136     /// @param newOwner The address to transfer ownership to.
137     function transferOwnership(
138         address newOwner
139         )
140         public
141         onlyOwner
142     {
143         require(newOwner != address(0x0) && newOwner != owner, "INVALID_ADDRESS");
144         pendingOwner = newOwner;
145     }
146 
147     /// @dev Allows the pendingOwner address to finalize the transfer.
148     function claimOwnership()
149         public
150         onlyPendingOwner
151     {
152         emit OwnershipTransferred(owner, pendingOwner);
153         owner = pendingOwner;
154         pendingOwner = address(0x0);
155     }
156 }
157 
158 /// @title LRC Foundation Icebox Program
159 /// @author Daniel Wang - <daniel@loopring.org>.
160 /// For more information, please visit https://loopring.org.
161 
162 /// Loopring Foundation's LRC (20% of total supply) will be locked during the first two years，
163 /// two years later, 1/24 of all locked LRC fund can be unlocked every month.
164 
165 contract NewLRCFoundationIceboxContract is Claimable {
166     using SafeMath for uint;
167 
168     uint public constant FREEZE_PERIOD = 720 days; // = 2 years
169 
170     address public lrcTokenAddress;
171 
172     uint public lrcInitialBalance   = 0;
173     uint public lrcWithdrawn         = 0;
174     uint public lrcUnlockPerMonth   = 0;
175     uint public startTime           = 0;
176 
177     /*
178      * EVENTS
179      */
180 
181     /// Emitted when program starts.
182     event Started(uint _time);
183 
184     /// Emitted for each sucuessful deposit.
185     uint public withdrawId = 0;
186     event Withdrawal(uint _withdrawId, uint _lrcAmount);
187 
188     /// @dev Initialize the contract
189     /// @param _lrcTokenAddress LRC ERC20 token address
190     constructor(address _lrcTokenAddress) public {
191         require(_lrcTokenAddress != address(0));
192         lrcTokenAddress = _lrcTokenAddress;
193     }
194 
195     /*
196      * PUBLIC FUNCTIONS
197      */
198 
199     /// @dev start the program.
200     function start(uint _startTime) public onlyOwner {
201         require(startTime == 0);
202 
203         lrcInitialBalance = Token(lrcTokenAddress).balanceOf(address(this));
204         require(lrcInitialBalance > 0);
205 
206         lrcUnlockPerMonth = lrcInitialBalance.div(24); // 24 month
207         startTime = _startTime;
208 
209         emit Started(startTime);
210     }
211 
212     function withdraw() public onlyOwner {
213         require(now > startTime + FREEZE_PERIOD);
214         Token token = Token(lrcTokenAddress);
215         uint balance = token.balanceOf(address(this));
216         require(balance > 0);
217 
218         uint lrcAmount = calculateLRCUnlockAmount(now, balance);
219         if (lrcAmount > 0) {
220             lrcWithdrawn += lrcAmount;
221 
222             emit Withdrawal(withdrawId++, lrcAmount);
223             require(token.transfer(owner, lrcAmount));
224         }
225     }
226 
227     /*
228      * INTERNAL FUNCTIONS
229      */
230 
231     function calculateLRCUnlockAmount(uint _now, uint _balance) internal view returns (uint lrcAmount) {
232         uint unlockable = (_now - startTime - FREEZE_PERIOD)
233             .div(30 days)
234             .mul(lrcUnlockPerMonth) - lrcWithdrawn;
235 
236         require(unlockable > 0);
237 
238         if (unlockable > _balance) return _balance;
239         else return unlockable;
240     }
241 
242 }