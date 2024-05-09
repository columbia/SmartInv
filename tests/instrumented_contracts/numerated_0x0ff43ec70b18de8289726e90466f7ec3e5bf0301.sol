1 pragma solidity 0.4.18;
2 
3 //! The owned contract.
4 //!
5 //! Copyright 2016 Gavin Wood, Parity Technologies Ltd.
6 //!
7 //! Licensed under the Apache License, Version 2.0 (the "License");
8 //! you may not use this file except in compliance with the License.
9 //! You may obtain a copy of the License at
10 //!
11 //!     http://www.apache.org/licenses/LICENSE-2.0
12 //!
13 //! Unless required by applicable law or agreed to in writing, software
14 //! distributed under the License is distributed on an "AS IS" BASIS,
15 //! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
16 //! See the License for the specific language governing permissions and
17 //! limitations under the License.
18 
19 contract Owned {
20   modifier only_owner { require(msg.sender == owner); _; }
21 
22   event NewOwner(address indexed old, address indexed current);
23 
24   function setOwner(address _new) only_owner public { NewOwner(owner, _new); owner = _new; }
25 
26   address public owner = msg.sender;
27 }
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 
61 /**
62  *  CanYa Coin contract
63  */
64 
65 
66 contract ERC20TokenInterface {
67 
68     /// @return The total amount of tokens
69     function totalSupply() constant returns (uint256 supply);
70 
71     /// @param _owner The address from which the balance will be retrieved
72     /// @return The balance
73     function balanceOf(address _owner) constant public returns (uint256 balance);
74 
75     /// @notice send `_value` token to `_to` from `msg.sender`
76     /// @param _to The address of the recipient
77     /// @param _value The amount of token to be transferred
78     /// @return Whether the transfer was successful or not
79     function transfer(address _to, uint256 _value) public returns (bool success);
80 
81     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
82     /// @param _from The address of the sender
83     /// @param _to The address of the recipient
84     /// @param _value The amount of token to be transferred
85     /// @return Whether the transfer was successful or not
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
87 
88     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
89     /// @param _spender The address of the account able to transfer the tokens
90     /// @param _value The amount of tokens to be approved for transfer
91     /// @return Whether the approval was successful or not
92     function approve(address _spender, uint256 _value) public returns (bool success);
93 
94     /// @param _owner The address of the account owning tokens
95     /// @param _spender The address of the account able to transfer the tokens
96     /// @return Amount of remaining tokens allowed to spent
97     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
98 
99     event Transfer(address indexed from, address indexed to, uint256 value);
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 
102 }
103 
104 
105 contract CanYaCoin is ERC20TokenInterface {
106 
107     string public constant name = "CanYaCoin";
108     string public constant symbol = "CAN";
109     uint256 public constant decimals = 6;
110     uint256 public constant totalTokens = 100000000 * (10 ** decimals);
111 
112     mapping (address => uint256) public balances;
113     mapping (address => mapping (address => uint256)) public allowed;
114 
115     function CanYaCoin() {
116         balances[msg.sender] = totalTokens;
117     }
118 
119     function totalSupply() constant returns (uint256) {
120         return totalTokens;
121     }
122 
123     function transfer(address _to, uint256 _value) public returns (bool) {
124         if (balances[msg.sender] >= _value) {
125             balances[msg.sender] -= _value;
126             balances[_to] += _value;
127             Transfer(msg.sender, _to, _value);
128             return true;
129         }
130         return false;
131     }
132 
133     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
135             balances[_from] -= _value;
136             allowed[_from][msg.sender] -= _value;
137             balances[_to] += _value;
138             Transfer(_from, _to, _value);
139             return true;
140         }
141         return false;
142     }
143 
144     function balanceOf(address _owner) constant public returns (uint256) {
145         return balances[_owner];
146     }
147 
148     function approve(address _spender, uint256 _value) public returns (bool) {
149         allowed[msg.sender][_spender] = _value;
150         Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
155         return allowed[_owner][_spender];
156     }
157 
158 }
159 
160 
161 contract AssetSplit is Owned {
162   using SafeMath for uint256;
163 
164   CanYaCoin public CanYaCoinToken;
165 
166   address public operationalAddress;
167   address public rewardAddress;
168   address public charityAddress;
169   address public constant burnAddress = 0x000000000000000000000000000000000000dEaD;
170 
171   uint256 public constant operationalSplitPercent = 30;
172   uint256 public constant rewardSplitPercent = 30;
173   uint256 public constant charitySplitPercent = 10;
174   uint256 public constant burnSplitPercent = 30;
175 
176   event OperationalSplit(uint256 _split);
177   event RewardSplit(uint256 _split);
178   event CharitySplit(uint256 _split);
179   event BurnSplit(uint256 _split);
180 
181   /// @dev Deploys the asset splitting contract
182   /// @param _tokenAddress Address of the CAN token contract
183   /// @param _operational Address of the operational holdings
184   /// @param _reward Address of the reward holdings
185   /// @param _charity Address of the charity holdings
186   function AssetSplit (
187     address _tokenAddress,
188     address _operational,
189     address _reward,
190     address _charity) public {
191     require(_tokenAddress != 0);
192     require(_operational != 0);
193     require(_reward != 0);
194     require(_charity != 0);
195     CanYaCoinToken = CanYaCoin(_tokenAddress);
196     operationalAddress = _operational;
197     rewardAddress = _reward;
198     charityAddress = _charity;
199   }
200 
201   /// @dev Splits the tokens from the owner address to the defined locations
202   /// @param _amountToSplit Amount of tokens to redistribute from the owner
203   function split (uint256 _amountToSplit) public only_owner {
204     require(_amountToSplit != 0);
205     // check that we are going to have enough tokens to transfer
206     require(CanYaCoinToken.allowance(owner, this) >= _amountToSplit);
207 
208     // now we get the amounts of tokens for each recipient
209     uint256 onePercentOfSplit = _amountToSplit / 100;
210     uint256 operationalSplitAmount = onePercentOfSplit.mul(operationalSplitPercent);
211     uint256 rewardSplitAmount = onePercentOfSplit.mul(rewardSplitPercent);
212     uint256 charitySplitAmount = onePercentOfSplit.mul(charitySplitPercent);
213     uint256 burnSplitAmount = onePercentOfSplit.mul(burnSplitPercent);
214 
215     // double check that we're not going to try to send too many tokens
216     require(
217       operationalSplitAmount
218         .add(rewardSplitAmount)
219         .add(charitySplitAmount)
220         .add(burnSplitAmount)
221       <= _amountToSplit
222     );
223 
224     // we now should be able to make the transfers
225     require(CanYaCoinToken.transferFrom(owner, operationalAddress, operationalSplitAmount));
226     require(CanYaCoinToken.transferFrom(owner, rewardAddress, rewardSplitAmount));
227     require(CanYaCoinToken.transferFrom(owner, charityAddress, charitySplitAmount));
228     require(CanYaCoinToken.transferFrom(owner, burnAddress, burnSplitAmount));
229 
230     OperationalSplit(operationalSplitAmount);
231     RewardSplit(rewardSplitAmount);
232     CharitySplit(charitySplitAmount);
233     BurnSplit(burnSplitAmount);
234   }
235 
236 }