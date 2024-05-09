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
19 /// @title Owned
20 /// @author Adrià Massanet <adria@codecontext.io>
21 /// @notice The Owned contract has an owner address, and provides basic 
22 ///  authorization control functions, this simplifies & the implementation of
23 ///  user permissions; this contract has three work flows for a change in
24 ///  ownership, the first requires the new owner to validate that they have the
25 ///  ability to accept ownership, the second allows the ownership to be
26 ///  directly transfered without requiring acceptance, and the third allows for
27 ///  the ownership to be removed to allow for decentralization 
28 contract Owned {
29 
30     address public owner;
31     address public newOwnerCandidate;
32 
33     event OwnershipRequested(address indexed by, address indexed to);
34     event OwnershipTransferred(address indexed from, address indexed to);
35     event OwnershipRemoved();
36 
37     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
38     function Owned() {
39         owner = msg.sender;
40     }
41 
42     /// @dev `owner` is the only address that can call a function with this
43     /// modifier
44     modifier onlyOwner() {
45         require (msg.sender == owner);
46         _;
47     }
48     
49     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
50     ///  be called first by the current `owner` then `acceptOwnership()` must be
51     ///  called by the `newOwnerCandidate`
52     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
53     ///  new owner
54     /// @param _newOwnerCandidate The address being proposed as the new owner
55     function proposeOwnership(address _newOwnerCandidate) onlyOwner {
56         newOwnerCandidate = _newOwnerCandidate;
57         OwnershipRequested(msg.sender, newOwnerCandidate);
58     }
59 
60     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
61     ///  transfer of ownership
62     function acceptOwnership() {
63         require(msg.sender == newOwnerCandidate);
64 
65         address oldOwner = owner;
66         owner = newOwnerCandidate;
67         newOwnerCandidate = 0x0;
68 
69         OwnershipTransferred(oldOwner, owner);
70     }
71 
72     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
73     ///  be called and it will immediately assign ownership to the `newOwner`
74     /// @notice `owner` can step down and assign some other address to this role
75     /// @param _newOwner The address of the new owner
76     function changeOwnership(address _newOwner) onlyOwner {
77         require(_newOwner != 0x0);
78 
79         address oldOwner = owner;
80         owner = _newOwner;
81         newOwnerCandidate = 0x0;
82 
83         OwnershipTransferred(oldOwner, owner);
84     }
85 
86     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
87     ///  be called and it will immediately assign ownership to the 0x0 address;
88     ///  it requires a 0xdece be input as a parameter to prevent accidental use
89     /// @notice Decentralizes the contract, this operation cannot be undone 
90     /// @param _dac `0xdac` has to be entered for this function to work
91     function removeOwnership(uint _dac) onlyOwner {
92         require(_dac == 0xdac);
93         owner = 0x0;
94         newOwnerCandidate = 0x0;
95         OwnershipRemoved();     
96     }
97 } 
98 
99 
100 /// @dev `Escapable` is a base level contract built off of the `Owned`
101 ///  contract; it creates an escape hatch function that can be called in an
102 ///  emergency that will allow designated addresses to send any ether or tokens
103 ///  held in the contract to an `escapeHatchDestination` as long as they were
104 ///  not blacklisted
105 contract Escapable is Owned {
106     address public escapeHatchCaller;
107     address public escapeHatchDestination;
108     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
109 
110     /// @notice The Constructor assigns the `escapeHatchDestination` and the
111     ///  `escapeHatchCaller`
112     /// @param _escapeHatchCaller The address of a trusted account or contract
113     ///  to call `escapeHatch()` to send the ether in this contract to the
114     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
115     ///  cannot move funds out of `escapeHatchDestination`
116     /// @param _escapeHatchDestination The address of a safe location (usu a
117     ///  Multisig) to send the ether held in this contract; if a neutral address
118     ///  is required, the WHG Multisig is an option:
119     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
120     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) {
121         escapeHatchCaller = _escapeHatchCaller;
122         escapeHatchDestination = _escapeHatchDestination;
123     }
124 
125     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
126     ///  are the only addresses that can call a function with this modifier
127     modifier onlyEscapeHatchCallerOrOwner {
128         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
129         _;
130     }
131 
132     /// @notice Creates the blacklist of tokens that are not able to be taken
133     ///  out of the contract; can only be done at the deployment, and the logic
134     ///  to add to the blacklist will be in the constructor of a child contract
135     /// @param _token the token contract address that is to be blacklisted 
136     function blacklistEscapeToken(address _token) internal {
137         escapeBlacklist[_token] = true;
138         EscapeHatchBlackistedToken(_token);
139     }
140 
141     /// @notice Checks to see if `_token` is in the blacklist of tokens
142     /// @param _token the token address being queried
143     /// @return False if `_token` is in the blacklist and can't be taken out of
144     ///  the contract via the `escapeHatch()`
145     function isTokenEscapable(address _token) constant public returns (bool) {
146         return !escapeBlacklist[_token];
147     }
148 
149     /// @notice The `escapeHatch()` should only be called as a last resort if a
150     /// security issue is uncovered or something unexpected happened
151     /// @param _token to transfer, use 0x0 for ether
152     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
153         require(escapeBlacklist[_token]==false);
154 
155         uint256 balance;
156 
157         /// @dev Logic for ether
158         if (_token == 0x0) {
159             balance = this.balance;
160             escapeHatchDestination.transfer(balance);
161             EscapeHatchCalled(_token, balance);
162             return;
163         }
164         /// @dev Logic for tokens
165         ERC20 token = ERC20(_token);
166         balance = token.balanceOf(this);
167         token.transfer(escapeHatchDestination, balance);
168         EscapeHatchCalled(_token, balance);
169     }
170 
171     /// @notice Changes the address assigned to call `escapeHatch()`
172     /// @param _newEscapeHatchCaller The address of a trusted account or
173     ///  contract to call `escapeHatch()` to send the value in this contract to
174     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
175     ///  cannot move funds out of `escapeHatchDestination`
176     function changeHatchEscapeCaller(address _newEscapeHatchCaller) onlyEscapeHatchCallerOrOwner {
177         escapeHatchCaller = _newEscapeHatchCaller;
178     }
179 
180     event EscapeHatchBlackistedToken(address token);
181     event EscapeHatchCalled(address token, uint amount);
182 }
183 
184 /// @dev This is an empty contract declaring `proxyPayment()` to comply with
185 ///  Giveth Campaigns so that tokens will be generated when donations are sent
186 contract Campaign {
187 
188     /// @notice `proxyPayment()` allows the caller to send ether to the Campaign
189     /// and have the tokens created in an address of their choosing
190     /// @param _owner The address that will hold the newly created tokens
191     function proxyPayment(address _owner) payable returns(bool);
192 }
193 
194 /// @title Fund Forwarder
195 /// @author Vojtech Simetka, Jordi Baylina, Dani Philia, Arthur Lunn
196 /// @notice This contract is used to forward funds to a Giveth Campaign 
197 ///  with an escapeHatch. The ether is sent directly to designated Campaign and
198 ///  the `escapeHatch()` allows removal of any tokens deposited by accident
199 contract FundForwarder is Escapable {
200     Campaign public beneficiary; // expected to be a Giveth campaign
201 
202     /// @notice The Constructor assigns the `beneficiary`, the
203     ///  `escapeHatchDestination` and the `escapeHatchCaller` as well as deploys
204     ///  the contract to the blockchain (obviously)
205     /// @param _beneficiary The address of the CAMPAIGN CONTROLLER for the
206     ///  Campaign that is to receive donations
207     /// @param _escapeHatchDestination The address of a safe location (usually a
208     ///  Multisig) to send the ether held in this contract
209     /// @param _escapeHatchCaller The address of a trusted account or contract
210     ///  to call `escapeHatch()` to send the ether in this contract to the 
211     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
212     ///  cannot move funds out of `escapeHatchDestination` in a less centralized
213     ///  and more trustless set up
214     function FundForwarder(
215         Campaign _beneficiary, // address that receives ether
216         address _escapeHatchCaller,
217         address _escapeHatchDestination
218         )Escapable(_escapeHatchCaller, _escapeHatchDestination)
219     {
220         beneficiary = _beneficiary;
221     }
222 
223     /// @dev The "fallback function" forwards ether to `beneficiary` and the 
224     ///  `msg.sender` is rewarded with Campaign tokens; this contract may have a
225     ///  high gasLimit requirement dependent on beneficiary
226     function () payable {
227         // Send the ETH to the beneficiary so that they receive Campaign tokens
228         require (beneficiary.proxyPayment.value(msg.value)(msg.sender));
229         FundsSent(msg.sender, msg.value);
230     }
231     event FundsSent(address indexed sender, uint amount);
232 }
233 
234 /**
235  * @title ERC20
236  * @dev A standard interface for tokens.
237  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
238  */
239 contract ERC20 {
240   
241     /// @dev Returns the total token supply
242     function totalSupply() public constant returns (uint256 supply);
243 
244     /// @dev Returns the account balance of the account with address _owner
245     function balanceOf(address _owner) public constant returns (uint256 balance);
246 
247     /// @dev Transfers _value number of tokens to address _to
248     function transfer(address _to, uint256 _value) public returns (bool success);
249 
250     /// @dev Transfers _value number of tokens from address _from to address _to
251     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
252 
253     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
254     function approve(address _spender, uint256 _value) public returns (bool success);
255 
256     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
257     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
258 
259     event Transfer(address indexed _from, address indexed _to, uint256 _value);
260     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
261 
262 }