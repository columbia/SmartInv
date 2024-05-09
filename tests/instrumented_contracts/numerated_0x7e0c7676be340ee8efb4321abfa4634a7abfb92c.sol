1 pragma solidity ^0.4.15;
2 
3 /* TODO: change this to an interface definition as soon as truffle accepts it. See https://github.com/trufflesuite/truffle/issues/560 */
4 contract ITransferable {
5     function transfer(address _to, uint256 _value) public returns (bool success);
6 }
7 
8 /**
9 @title PLAY Token
10 
11 ERC20 Token with additional mint functionality.
12 A "controller" (initialized to the contract creator) has exclusive permission to mint.
13 The controller address can be changed until locked.
14 
15 Implementation based on https://github.com/ConsenSys/Tokens
16 */
17 contract PlayToken {
18     uint256 public totalSupply = 0;
19     string public name = "PLAY";
20     uint8 public decimals = 18;
21     string public symbol = "PLY";
22     string public version = '1';
23 
24     address public controller;
25     bool public controllerLocked = false;
26 
27     mapping (address => uint256) balances;
28     mapping (address => mapping (address => uint256)) allowed;
29 
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33     modifier onlyController() {
34         require(msg.sender == controller);
35         _;
36     }
37 
38     /** @dev constructor */
39     function PlayToken(address _controller) {
40         controller = _controller;
41     }
42 
43     /** Sets a new controller address if the current controller isn't locked */
44     function setController(address _newController) onlyController {
45         require(! controllerLocked);
46         controller = _newController;
47     }
48 
49     /** Locks the current controller address forever */
50     function lockController() onlyController {
51         controllerLocked = true;
52     }
53 
54     /**
55     Creates new tokens for the given receiver.
56     Can be called only by the contract creator.
57     */
58     function mint(address _receiver, uint256 _value) onlyController {
59         balances[_receiver] += _value;
60         totalSupply += _value;
61         // (probably) recommended by the standard, see https://github.com/ethereum/EIPs/pull/610/files#diff-c846f31381e26d8beeeae24afcdf4e3eR99
62         Transfer(0, _receiver, _value);
63     }
64 
65     function transfer(address _to, uint256 _value) returns (bool success) {
66         /* Additional Restriction: don't accept token payments to the contract itself and to address 0 in order to avoid most
67          token losses by mistake - as is discussed in https://github.com/ethereum/EIPs/issues/223 */
68         require((_to != 0) && (_to != address(this)));
69 
70         require(balances[msg.sender] >= _value);
71         balances[msg.sender] -= _value;
72         balances[_to] += _value;
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
79         balances[_to] += _value;
80         balances[_from] -= _value;
81         allowed[_from][msg.sender] -= _value;
82         Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function balanceOf(address _owner) constant returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90     function approve(address _spender, uint256 _value) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97         return allowed[_owner][_spender];
98     }
99 
100     /* Approves and then calls the receiving contract */
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104 
105         /* call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
106         receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
107         it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead. */
108         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
109         return true;
110     }
111 
112     /**
113     Withdraws tokens held by the contract to a given account.
114     Motivation: see https://github.com/ethereum/EIPs/issues/223#issuecomment-317987571
115     */
116     function withdrawTokens(ITransferable _token, address _to, uint256 _amount) onlyController {
117         _token.transfer(_to, _amount);
118     }
119 }
120 
121 /** @title P4P Donation Pool
122 
123 Contract which receives donations for privacy projects.
124 Donators will be rewarded with PLAY tokens.
125 
126 The donation process is 2-phased.
127 Donations of the first round will be weighted twice as much compared to later donations.
128 
129 The received Ether funds will not be accessible during the donation period.
130 Donated Eth can be retrieved only after the donation rounds are over and the set unlock timestamp is reached.
131 In order to never own the funds, the contract owner can set and lock the receiver address beforehand.
132 The receiver address can be an external account or a distribution contract.
133 
134 Note that there's no way for the owner to withdraw tokens assigned to donators which aren't withdrawn.
135 In case destroy() is invoked, they will effectively be burned.
136 */
137 contract P4PPool {
138     address public owner;
139     PlayToken public playToken;
140 
141     uint8 public currentState = 0;
142     // valid states (not using enum in order to be able to simply increment in startNextPhase()):
143     uint8 public constant STATE_NOT_STARTED = 0;
144     uint8 public constant STATE_DONATION_ROUND_1 = 1;
145     uint8 public constant STATE_PLAYING = 2;
146     uint8 public constant STATE_DONATION_ROUND_2 = 3;
147     uint8 public constant STATE_PAYOUT = 4;
148 
149     uint256 public tokenPerEth; // calculated after finishing donation rounds
150 
151     mapping(address => uint256) round1Donations;
152     mapping(address => uint256) round2Donations;
153 
154     // glitch: forgot to rename those from "phase" to "round" too
155     uint256 public totalPhase1Donations = 0;
156     uint256 public totalPhase2Donations = 0;
157 
158     // 1509494400 = 2017 Nov 01, 00:00 (UTC)
159     uint32 public donationUnlockTs = uint32(now); //1509494400;
160 
161     // share of the pooled tokens the owner (developers) gets in percent
162     uint8 public constant ownerTokenSharePct = 20;
163 
164     address public donationReceiver;
165     bool public donationReceiverLocked = false;
166 
167     event StateChanged(uint8 newState);
168     event DonatedEthPayout(address receiver, uint256 amount);
169 
170     modifier onlyOwner() {
171         require(msg.sender == owner);
172         _;
173     }
174 
175     modifier onlyDuringDonationRounds() {
176         require(currentState == STATE_DONATION_ROUND_1 || currentState == STATE_DONATION_ROUND_2);
177         _;
178     }
179 
180     modifier onlyIfPayoutUnlocked() {
181         require(currentState == STATE_PAYOUT);
182         require(uint32(now) >= donationUnlockTs);
183         _;
184     }
185 
186     /** @dev constructor */
187     function P4PPool(address _tokenAddr) {
188         owner = msg.sender;
189         playToken = PlayToken(_tokenAddr);
190     }
191 
192     /** So called "fallback function" which handles incoming Ether payments
193     Remembers which address payed how much, doubling round 1 contributions.
194     */
195     function () payable onlyDuringDonationRounds {
196         donateForImpl(msg.sender);
197     }
198 
199     /** Receives Eth on behalf of somebody else
200     Can be used for proxy payments.
201     */
202     function donateFor(address _donor) payable onlyDuringDonationRounds {
203         donateForImpl(_donor);
204     }
205 
206     function startNextPhase() onlyOwner {
207         require(currentState <= STATE_PAYOUT);
208         currentState++;
209         if(currentState == STATE_PAYOUT) {
210             // donation ended. Calculate and persist the distribution key:
211             tokenPerEth = calcTokenPerEth();
212         }
213         StateChanged(currentState);
214     }
215 
216     function setDonationUnlockTs(uint32 _newTs) onlyOwner {
217         require(_newTs > donationUnlockTs);
218         donationUnlockTs = _newTs;
219     }
220 
221     function setDonationReceiver(address _receiver) onlyOwner {
222         require(! donationReceiverLocked);
223         donationReceiver = _receiver;
224     }
225 
226     function lockDonationReceiver() onlyOwner {
227         require(donationReceiver != 0);
228         donationReceiverLocked = true;
229     }
230 
231     // this could be left available to everybody instead of owner only
232     function payoutDonations() onlyOwner onlyIfPayoutUnlocked {
233         require(donationReceiver != 0);
234         var amount = this.balance;
235         require(donationReceiver.send(amount));
236         DonatedEthPayout(donationReceiver, amount);
237     }
238 
239     /** Emergency fallback for retrieving funds
240     In case something goes horribly wrong, this allows to retrieve Eth from the contract.
241     Becomes available at March 1 2018.
242     If called, all tokens still owned by the contract (not withdrawn by anybody) are burned.
243     */
244     function destroy() onlyOwner {
245         require(currentState == STATE_PAYOUT);
246         require(now > 1519862400);
247         selfdestruct(owner);
248     }
249 
250     /** Allows donators to withdraw the share of tokens they are entitled to */
251     function withdrawTokenShare() {
252         require(tokenPerEth > 0); // this implies that donation rounds have closed
253         require(playToken.transfer(msg.sender, calcTokenShareOf(msg.sender)));
254         round1Donations[msg.sender] = 0;
255         round2Donations[msg.sender] = 0;
256     }
257 
258     // ######### INTERNAL FUNCTIONS ##########
259 
260     function calcTokenShareOf(address _addr) constant internal returns(uint256) {
261         if(_addr == owner) {
262             // TODO: this could probably be simplified. But does the job without requiring additional storage
263             var virtualEthBalance = (((totalPhase1Donations*2 + totalPhase2Donations) * 100) / (100 - ownerTokenSharePct) + 1);
264             return ((tokenPerEth * virtualEthBalance) * ownerTokenSharePct) / (100 * 1E18);
265         } else {
266             return (tokenPerEth * (round1Donations[_addr]*2 + round2Donations[_addr])) / 1E18;
267         }
268     }
269 
270     // Will throw if no donations were received.
271     function calcTokenPerEth() constant internal returns(uint256) {
272         var tokenBalance = playToken.balanceOf(this);
273         // the final + 1 makes sure we're not running out of tokens due to rounding artifacts.
274         // that would otherwise be (theoretically, if all tokens are withdrawn) possible,
275         // because this number acts as divisor for the return value.
276         var virtualEthBalance = (((totalPhase1Donations*2 + totalPhase2Donations) * 100) / (100 - ownerTokenSharePct) + 1);
277         // use 18 decimals precision. No danger of overflow with 256 bits.
278         return tokenBalance * 1E18 / (virtualEthBalance);
279     }
280 
281     function donateForImpl(address _donor) internal onlyDuringDonationRounds {
282         if(currentState == STATE_DONATION_ROUND_1) {
283             round1Donations[_donor] += msg.value;
284             totalPhase1Donations += msg.value;
285         } else if(currentState == STATE_DONATION_ROUND_2) {
286             round2Donations[_donor] += msg.value;
287             totalPhase2Donations += msg.value;
288         }
289     }
290 }