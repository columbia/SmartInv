1 pragma solidity ^0.4.13;
2 /*
3     Copyright 2017, Griff Green
4 
5     This program is free software: you can redistribute it and/or modify
6     it under the terms of the GNU General Public License as published by
7     the Free Software Foundation, either version 3 of the License, or
8     (at your option) any later version.
9 
10     This program is distributed in the hope that it will be useful,
11     but WITHOUT ANY WARRANTY; without even the implied warranty of
12     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13     GNU General Public License for more details.
14 
15     You should have received a copy of the GNU General Public License
16     along with this program.  If not, see <http://www.gnu.org/licenses/>.
17  */
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal constant returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal constant returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   uint256 public totalSupply;
57   function balanceOf(address who) public constant returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of BasicToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public constant returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 /// @dev `Escapable` is a base level contract for and contract that wants to
98 ///  add an escape hatch for a contract that holds ETH or ERC20 tokens. This
99 ///  contract creates an `escapeHatch()` function to send its `baseTokens` to
100 ///  `escapeHatchDestination` when called by the `escapeHatchCaller` in the case that
101 ///  something unexpected happens
102 contract Escapable {
103     BasicToken public baseToken;
104 
105     address public escapeHatchCaller;
106     address public escapeHatchDestination;
107 
108     /// @notice The Constructor assigns the `escapeHatchDestination`, the
109     ///  `escapeHatchCaller`, and the `baseToken`
110     /// @param _baseToken The address of the token that is used as a store value
111     ///  for this contract, 0x0 in case of ether. The token must have the ERC20
112     ///  standard `balanceOf()` and `transfer()` functions
113     /// @param _escapeHatchDestination The address of a safe location (usu a
114     ///  Multisig) to send the `baseToken` held in this contract
115     /// @param _escapeHatchCaller The address of a trusted account or contract to
116     ///  call `escapeHatch()` to send the `baseToken` in this contract to the
117     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
118     /// cannot move funds out of `escapeHatchDestination`
119     function Escapable(
120         address _baseToken,
121         address _escapeHatchCaller,
122         address _escapeHatchDestination) {
123         baseToken = BasicToken(_baseToken);
124         escapeHatchCaller = _escapeHatchCaller;
125         escapeHatchDestination = _escapeHatchDestination;
126     }
127 
128     /// @dev The addresses preassigned the `escapeHatchCaller` role
129     ///  is the only addresses that can call a function with this modifier
130     modifier onlyEscapeHatchCaller {
131         require (msg.sender == escapeHatchCaller);
132         _;
133     }
134 
135     /// @notice The `escapeHatch()` should only be called as a last resort if a
136     /// security issue is uncovered or something unexpected happened
137     function escapeHatch() onlyEscapeHatchCaller {
138         uint total = getBalance();
139         // Send the total balance of this contract to the `escapeHatchDestination`
140         transfer(escapeHatchDestination, total);
141         EscapeHatchCalled(total);
142     }
143     /// @notice Changes the address assigned to call `escapeHatch()`
144     /// @param _newEscapeHatchCaller The address of a trusted account or contract to
145     ///  call `escapeHatch()` to send the ether in this contract to the
146     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot
147     ///  move funds out of `escapeHatchDestination`
148     function changeEscapeHatchCaller(address _newEscapeHatchCaller
149         ) onlyEscapeHatchCaller 
150     {
151         escapeHatchCaller = _newEscapeHatchCaller;
152         EscapeHatchCallerChanged(escapeHatchCaller);
153     }
154     /// @notice Returns the balance of the `baseToken` stored in this contract
155     function getBalance() constant returns(uint) {
156         if (address(baseToken) != 0) {
157             return baseToken.balanceOf(this);
158         } else {
159             return this.balance;
160         }
161     }
162     /// @notice Sends an `_amount` of `baseToken` to `_to` from this contract,
163     /// and it can only be called by the contract itself
164     /// @param _to The address of the recipient
165     /// @param _amount The amount of `baseToken to be sent
166     function transfer(address _to, uint _amount) internal {
167         if (address(baseToken) != 0) {
168             require (baseToken.transfer(_to, _amount));
169         } else {
170             require ( _to.send(_amount));
171         }
172     }
173 
174 
175 //////
176 // Receive Ether
177 //////
178 
179     /// @notice Called anytime ether is sent to the contract && creates an event
180     /// to more easily track the incoming transactions
181     function receiveEther() payable {
182         // Do not accept ether if baseToken is not ETH
183         require (address(baseToken) == 0);
184         EtherReceived(msg.sender, msg.value);
185     }
186 
187 //////////
188 // Safety Methods
189 //////////
190 
191     /// @notice This method can be used by the controller to extract mistakenly
192     ///  sent tokens to this contract.
193     /// @param _token The address of the token contract that you want to recover
194     ///  set to 0 in case you want to extract ether.
195     function claimTokens(address _token) public onlyEscapeHatchCaller {
196         if (_token == 0x0) {
197             escapeHatchDestination.transfer(this.balance);
198             return;
199         }
200 
201         BasicToken token = BasicToken(_token);
202         uint256 balance = token.balanceOf(this);
203         token.transfer(escapeHatchDestination, balance);
204         ClaimedTokens(_token, escapeHatchDestination, balance);
205     }
206 
207     /// @notice The fall back function is called whenever ether is sent to this
208     ///  contract
209     function () payable {
210         receiveEther();
211     }
212 
213     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
214     event EscapeHatchCalled(uint amount);
215     event EscapeHatchCallerChanged(address indexed newEscapeHatchCaller);
216     event EtherReceived(address indexed from, uint amount);
217 }
218 
219 /// @title Mexico Matcher
220 /// @author Vojtech Simetka, Jordi Baylina, Dani Philia, Arthur Lunn, Griff Green
221 /// @notice This contract is used to match donations inspired by the generosity
222 ///  of Bitso:  
223 ///  The escapeHatch allows removal of any other tokens deposited by accident.
224 
225 
226 /// @dev The main contract which forwards funds sent to contract.
227 contract MexicoMatcher is Escapable {
228     address public beneficiary; // expected to be a Giveth campaign
229 
230     /// @notice The Constructor assigns the `beneficiary`, the
231     ///  `escapeHatchDestination` and the `escapeHatchCaller` as well as deploys
232     ///  the contract to the blockchain (obviously)
233     /// @param _beneficiary The address that will receive donations
234     /// @param _escapeHatchDestination The address of a safe location (usually a
235     ///  Multisig) to send the ether deposited to be matched in this contract if
236     ///  there is an issue
237     /// @param _escapeHatchCaller The address of a trusted account or contract
238     ///  to call `escapeHatch()` to send the ether in this contract to the 
239     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
240     ///  cannot move funds out of `escapeHatchDestination`
241     function MexicoMatcher(
242             address _beneficiary, // address that receives ether
243             address _escapeHatchCaller,
244             address _escapeHatchDestination
245         )
246         // Set the escape hatch to accept ether (0x0)
247         Escapable(0x0, _escapeHatchCaller, _escapeHatchDestination)
248     {
249         beneficiary = _beneficiary;
250     }
251     
252     /// @notice Simple function to deposit more ETH to match future donations
253     function depositETH() payable {
254         DonationDeposited4Matching(msg.sender, msg.value);
255     }
256     /// @notice Donate ETH to the `beneficiary`, and if there is enough in the 
257     ///  contract double it. The `msg.sender` is rewarded with Campaign tokens;
258     ///  This contract may have a high gasLimit requirement
259     function () payable {
260         uint256 amount;
261         
262         // If there is enough ETH in the contract to double it, DOUBLE IT!
263         if (this.balance >= msg.value*2){
264             amount = msg.value*2; // do it two it!
265         
266             // Send ETH to the beneficiary; must be an account, not a contract
267             require (beneficiary.send(amount));
268             DonationMatched(msg.sender, amount);
269         } else {
270             amount = this.balance;
271             require (beneficiary.send(amount));
272             DonationSentButNotMatched(msg.sender, amount);
273         }
274     }
275     event DonationDeposited4Matching(address indexed sender, uint amount);
276     event DonationMatched(address indexed sender, uint amount);
277     event DonationSentButNotMatched(address indexed sender, uint amount);
278 }