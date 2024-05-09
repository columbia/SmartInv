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
18 pragma solidity ^0.4.11;
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
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
54     function balanceOf(address _owner) constant returns (uint256 balance);
55 
56     /// @notice send `_value` token to `_to` from `msg.sender`
57     /// @param _to The address of the recipient
58     /// @param _value The amount of token to be transferred
59     /// @return Whether the transfer was successful or not
60     function transfer(address _to, uint256 _value) returns (bool success);
61 
62     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
63     /// @param _from The address of the sender
64     /// @param _to The address of the recipient
65     /// @param _value The amount of token to be transferred
66     /// @return Whether the transfer was successful or not
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
68 
69     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
70     /// @param _spender The address of the account able to transfer the tokens
71     /// @param _value The amount of tokens to be approved for transfer
72     /// @return Whether the approval was successful or not
73     function approve(address _spender, uint256 _value) returns (bool success);
74 
75     /// @param _owner The address of the account owning tokens
76     /// @param _spender The address of the account able to transfer the tokens
77     /// @return Amount of remaining tokens allowed to spent
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82 }
83 
84 
85 /// @title LRC Foundation Icebox Program
86 /// @author Daniel Wang - <daniel@loopring.org>.
87 /// For more information, please visit https://loopring.org.
88 
89 /// Loopring Foundation's LRC (20% of total supply) will be locked during the first two years，
90 /// two years later, 1/24 of all locked LRC fund can be unlocked every month.
91 
92 contract LRCFoundationIceboxContract {
93     using SafeMath for uint;
94     
95     uint public constant FREEZE_PERIOD = 720 days; // = 2 years
96 
97     address public lrcTokenAddress  = 0x0;
98     address public owner            = 0x0;
99 
100     uint public lrcInitialBalance   = 0;
101     uint public lrcWithdrawn         = 0;
102     uint public lrcUnlockPerMonth   = 0;
103     uint public startTime           = 0;
104 
105     /* 
106      * EVENTS
107      */
108 
109     /// Emitted when program starts.
110     event Started(uint _time);
111 
112     /// Emitted for each sucuessful deposit.
113     uint public withdrawId = 0;
114     event Withdrawal(uint _withdrawId, uint _lrcAmount);
115 
116     /// @dev Initialize the contract
117     /// @param _lrcTokenAddress LRC ERC20 token address
118     /// @param _owner Owner's address
119     function LRCFoundationIceboxContract(address _lrcTokenAddress, address _owner) {
120         require(_lrcTokenAddress != address(0));
121         require(_owner != address(0));
122 
123         lrcTokenAddress = _lrcTokenAddress;
124         owner = _owner;
125     }
126 
127     /*
128      * PUBLIC FUNCTIONS
129      */
130 
131     /// @dev start the program.
132     function start() public {
133         require(msg.sender == owner);
134         require(startTime == 0);
135 
136         lrcInitialBalance = Token(lrcTokenAddress).balanceOf(address(this));
137         require(lrcInitialBalance > 0);
138 
139         lrcUnlockPerMonth = lrcInitialBalance.div(24); // 24 month
140         startTime = now;
141 
142         Started(startTime);
143     }
144 
145 
146     function () payable {
147         require(msg.sender == owner);
148         require(msg.value == 0);
149         require(startTime > 0);
150         require(now > startTime + FREEZE_PERIOD);
151 
152         var token = Token(lrcTokenAddress);
153         uint balance = token.balanceOf(address(this));
154         require(balance > 0);
155 
156         uint lrcAmount = calculateLRCUnlockAmount(now, balance);
157         if (lrcAmount > 0) {
158             lrcWithdrawn += lrcAmount;
159 
160             Withdrawal(withdrawId++, lrcAmount);
161             require(token.transfer(owner, lrcAmount));
162         }
163     }
164 
165 
166     /*
167      * INTERNAL FUNCTIONS
168      */
169 
170     function calculateLRCUnlockAmount(uint _now, uint _balance) internal returns (uint lrcAmount) {
171         uint unlockable = (_now - startTime - FREEZE_PERIOD)
172             .div(30 days)
173             .mul(lrcUnlockPerMonth) - lrcWithdrawn;
174 
175         require(unlockable > 0);
176 
177         if (unlockable > _balance) return _balance;
178         else return unlockable;
179     }
180 
181 }