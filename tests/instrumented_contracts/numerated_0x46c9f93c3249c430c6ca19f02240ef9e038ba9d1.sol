1 pragma solidity ^0.4.15;
2 /*
3     Copyright 2017, Arthur Lunn
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
19 
20 /**
21  * @title ERC20
22  * @dev A standard interface for tokens.
23  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
24  */
25 contract ERC20 {
26   
27     /// @dev Returns the total token supply.
28     function totalSupply() public constant returns (uint256 supply);
29 
30     /// @dev Returns the account balance of another account with address _owner.
31     function balanceOf(address _owner) public constant returns (uint256 balance);
32 
33     /// @dev Transfers _value amount of tokens to address _to
34     function transfer(address _to, uint256 _value) public returns (bool success);
35 
36     /// @dev Transfers _value amount of tokens from address _from to address _to
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
38 
39     /// @dev Allows _spender to withdraw from your account multiple times, up to the _value amount
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner.
43     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 
48 }
49 
50 /// @title Owned
51 /// @author Adrià Massanet <adria@codecontext.io>
52 /// @notice The Owned contract has an owner address, and provides basic 
53 ///  authorization control functions, this simplifies & the implementation of
54 ///  "user permissions"
55 contract Owned {
56 
57     address public owner;
58     address public newOwnerCandidate;
59 
60     event OwnershipRequested(address indexed by, address indexed to);
61     event OwnershipTransferred(address indexed from, address indexed to);
62     event OwnershipRemoved();
63 
64     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
65     function Owned() {
66         owner = msg.sender;
67     }
68 
69     /// @dev `owner` is the only address that can call a function with this
70     /// modifier
71     modifier onlyOwner() {
72         require (msg.sender == owner);
73         _;
74     }
75 
76     /// @notice `owner` can step down and assign some other address to this role
77     /// @param _newOwner The address of the new owner.
78     function changeOwnership(address _newOwner) onlyOwner {
79         require(_newOwner != 0x0);
80 
81         address oldOwner = owner;
82         owner = _newOwner;
83         newOwnerCandidate = 0x0;
84 
85         OwnershipTransferred(oldOwner, owner);
86     }
87 
88     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
89     ///  new owner
90     /// @param _newOwnerCandidate The address being proposed as the new owner
91     function proposeOwnership(address _newOwnerCandidate) onlyOwner {
92         newOwnerCandidate = _newOwnerCandidate;
93         OwnershipRequested(msg.sender, newOwnerCandidate);
94     }
95 
96     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
97     ///  transfer of ownership
98     function acceptOwnership() {
99         require(msg.sender == newOwnerCandidate);
100 
101         address oldOwner = owner;
102         owner = newOwnerCandidate;
103         newOwnerCandidate = 0x0;
104 
105         OwnershipTransferred(oldOwner, owner);
106     }
107 
108     /// @notice Decentralizes the contract, this operation cannot be undone 
109     /// @param _dece `0xdece` has to be entered for this function to work
110     function removeOwnership(address _dece) onlyOwner {
111         require(_dece == 0xdece);
112         owner = 0x0;
113         newOwnerCandidate = 0x0;
114         OwnershipRemoved();     
115     }
116 
117 } 
118 
119 /// @dev `Escapable` is a base level contract built off of the `Owned`
120 ///  contract that creates an escape hatch function to send its ether to
121 ///  `escapeHatchDestination` when called by the `escapeHatchCaller` in the case that
122 ///  something unexpected happens
123 contract Escapable is Owned {
124     address public escapeHatchCaller;
125     address public escapeHatchDestination;
126     mapping (address=>bool) private escapeBlacklist;
127 
128     /// @notice The Constructor assigns the `escapeHatchDestination` and the
129     ///  `escapeHatchCaller`
130     /// @param _escapeHatchDestination The address of a safe location (usu a
131     ///  Multisig) to send the ether held in this contract
132     /// @param _escapeHatchCaller The address of a trusted account or contract to
133     ///  call `escapeHatch()` to send the ether in this contract to the
134     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot move
135     ///  funds out of `escapeHatchDestination`
136     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) {
137         escapeHatchCaller = _escapeHatchCaller;
138         escapeHatchDestination = _escapeHatchDestination;
139     }
140 
141     modifier onlyEscapeHatchCallerOrOwner {
142         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
143         _;
144     }
145 
146     /// @notice The `blacklistEscapeTokens()` marks a token in a whitelist to be
147     ///   escaped. The proupose is to be done at construction time.
148     /// @param _token the be bloacklisted for escape
149     function blacklistEscapeToken(address _token) internal {
150         escapeBlacklist[_token] = true;
151         EscapeHatchBlackistedToken(_token);
152     }
153 
154     function isTokenEscapable(address _token) constant public returns (bool) {
155         return !escapeBlacklist[_token];
156     }
157 
158     /// @notice The `escapeHatch()` should only be called as a last resort if a
159     /// security issue is uncovered or something unexpected happened
160     /// @param _token to transfer, use 0x0 for ethers
161     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
162         require(escapeBlacklist[_token]==false);
163 
164         uint256 balance;
165 
166         if (_token == 0x0) {
167             balance = this.balance;
168             escapeHatchDestination.transfer(balance);
169             EscapeHatchCalled(_token, balance);
170             return;
171         }
172 
173         ERC20 token = ERC20(_token);
174         balance = token.balanceOf(this);
175         token.transfer(escapeHatchDestination, balance);
176         EscapeHatchCalled(_token, balance);
177     }
178 
179     /// @notice Changes the address assigned to call `escapeHatch()`
180     /// @param _newEscapeHatchCaller The address of a trusted account or contract to
181     ///  call `escapeHatch()` to send the ether in this contract to the
182     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot
183     ///  move funds out of `escapeHatchDestination`
184     function changeEscapeCaller(address _newEscapeHatchCaller) onlyEscapeHatchCallerOrOwner {
185         escapeHatchCaller = _newEscapeHatchCaller;
186     }
187 
188     event EscapeHatchBlackistedToken(address token);
189     event EscapeHatchCalled(address token, uint amount);
190 }
191 
192 
193 /// @dev This is an empty contract to declare `proxyPayment()` to comply with
194 ///  Giveth Campaigns so that tokens will be generated when donations are sent
195 contract Campaign {
196     /// @notice `proxyPayment()` allows the caller to send ether to the Campaign and
197     /// have the tokens created in an address of their choosing
198     /// @param _owner The address that will hold the newly created tokens
199     function proxyPayment(address _owner) payable returns(bool);
200 }
201 
202 
203 /// @title Fund Forwarder
204 /// @authors Vojtech Simetka, Jordi Baylina, Dani Philia, Arthur Lunn (hardly)
205 /// @notice This contract is used to forward funds to a Giveth Campaign 
206 ///  with an escapeHatch.The fund value is sent directly to designated Campaign.
207 ///  The escapeHatch allows removal of any other tokens deposited by accident.
208 /*
209     Copyright 2016, Jordi Baylina
210     Contributor: Adrià Massanet <adria@codecontext.io>
211 
212     This program is free software: you can redistribute it and/or modify
213     it under the terms of the GNU General Public License as published by
214     the Free Software Foundation, either version 3 of the License, or
215     (at your option) any later version.
216 
217     This program is distributed in the hope that it will be useful,
218     but WITHOUT ANY WARRANTY; without even the implied warranty of
219     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
220     GNU General Public License for more details.
221 
222     You should have received a copy of the GNU General Public License
223     along with this program.  If not, see <http://www.gnu.org/licenses/>.
224 */
225 
226 /// @dev The main contract which forwards funds sent to contract.
227 contract FundForwarder is Escapable {
228     Campaign public beneficiary; // expected to be a Giveth campaign
229 
230     /// @notice The Constructor assigns the `beneficiary`, the
231     ///  `escapeHatchDestination` and the `escapeHatchCaller` as well as deploys
232     ///  the contract to the blockchain (obviously)
233     /// @param _beneficiary The address of the CAMPAIGN CONTROLLER for the Campaign
234     ///  that is to receive donations
235     /// @param _escapeHatchDestination The address of a safe location (usually a
236     ///  Multisig) to send the ether held in this contract
237     /// @param _escapeHatchCaller The address of a trusted account or contract
238     ///  to call `escapeHatch()` to send the ether in this contract to the 
239     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
240     ///  cannot move funds out of `escapeHatchDestination`
241     function FundForwarder(
242             Campaign _beneficiary, // address that receives ether
243             address _escapeHatchCaller,
244             address _escapeHatchDestination
245         )
246         // Set the escape hatch to accept ether (0x0)
247         Escapable(_escapeHatchCaller, _escapeHatchDestination)
248     {
249         beneficiary = _beneficiary;
250     }
251 
252     /// @notice Directly forward Eth to `beneficiary`. The `msg.sender` is rewarded with Campaign tokens.
253     ///  This contract may have a high gasLimit requirement dependent on beneficiary.
254     function () payable {
255         uint amount;
256         amount = msg.value;
257         // Send the ETH to the beneficiary so that they receive Campaign tokens
258         require (beneficiary.proxyPayment.value(amount)
259         (msg.sender)
260         );
261         FundsSent(msg.sender, amount);
262     }
263     event FundsSent(address indexed sender, uint amount);
264 }