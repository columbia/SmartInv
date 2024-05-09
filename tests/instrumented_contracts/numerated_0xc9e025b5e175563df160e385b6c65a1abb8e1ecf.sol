1 pragma solidity ^0.4.11;
2 
3 contract Base {
4 
5     function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
6     function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }
7 
8     modifier only(address allowed) {
9         if (msg.sender != allowed) throw;
10         _;
11     }
12 
13 
14     ///@return True if `_addr` is a contract
15     function isContract(address _addr) constant internal returns (bool) {
16         if (_addr == 0) return false;
17         uint size;
18         assembly {
19             size := extcodesize(_addr)
20         }
21         return (size > 0);
22     }
23 
24     // *************************************************
25     // *          reentrancy handling                  *
26     // *************************************************
27 
28     //@dev predefined locks (up to uint bit length, i.e. 256 possible)
29     uint constant internal L00 = 2 ** 0;
30     uint constant internal L01 = 2 ** 1;
31     uint constant internal L02 = 2 ** 2;
32     uint constant internal L03 = 2 ** 3;
33     uint constant internal L04 = 2 ** 4;
34     uint constant internal L05 = 2 ** 5;
35 
36     //prevents reentrancy attacs: specific locks
37     uint private bitlocks = 0;
38     modifier noReentrancy(uint m) {
39         var _locks = bitlocks;
40         if (_locks & m > 0) throw;
41         bitlocks |= m;
42         _;
43         bitlocks = _locks;
44     }
45 
46     modifier noAnyReentrancy {
47         var _locks = bitlocks;
48         if (_locks > 0) throw;
49         bitlocks = uint(-1);
50         _;
51         bitlocks = _locks;
52     }
53 
54     ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.
55     ///     developer should make the caller function reentrant-safe if it use a reentrant function.
56     modifier reentrant { _; }
57 
58 }
59 
60 contract Owned is Base {
61 
62     address public owner;
63     address public newOwner;
64 
65     function Owned() {
66         owner = msg.sender;
67     }
68 
69     function transferOwnership(address _newOwner) only(owner) {
70         newOwner = _newOwner;
71     }
72 
73     function acceptOwnership() only(newOwner) {
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 
80 }
81 
82 
83 contract ERC20 is Owned {
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87 
88     function transfer(address _to, uint256 _value) isStartedOnly returns (bool success) {
89         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
90             balances[msg.sender] -= _value;
91             balances[_to] += _value;
92             Transfer(msg.sender, _to, _value);
93             return true;
94         } else { return false; }
95     }
96 
97     function transferFrom(address _from, address _to, uint256 _value) isStartedOnly returns (bool success) {
98         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
99             balances[_to] += _value;
100             balances[_from] -= _value;
101             allowed[_from][msg.sender] -= _value;
102             Transfer(_from, _to, _value);
103             return true;
104         } else { return false; }
105     }
106 
107     function balanceOf(address _owner) constant returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     function approve(address _spender, uint256 _value) isStartedOnly returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118         return allowed[_owner][_spender];
119     }
120 
121     mapping (address => uint256) balances;
122     mapping (address => mapping (address => uint256)) allowed;
123 
124     uint256 public totalSupply;
125     bool    public isStarted = false;
126 
127     modifier onlyHolder(address holder) {
128         if (balanceOf(holder) == 0) throw;
129         _;
130     }
131 
132     modifier isStartedOnly() {
133         if (!isStarted) throw;
134         _;
135     }
136 
137 }
138 
139 
140 contract SubscriptionModule {
141     function attachToken(address addr) public ;
142 }
143 
144 contract SAN is Owned, ERC20 {
145 
146     string public constant name     = "SANtiment TEST token";
147     string public constant symbol   = "SAN.TEST.MAX.1";
148     uint8  public constant decimals = 15;
149 
150     address CROWDSALE_MINTER = 0x6Be4E8a44C9D22F39DB262cF1A54C1172dA3B864;
151     address public SUBSCRIPTION_MODULE = 0x00000000;
152     address public beneficiary;
153 
154     uint public PLATFORM_FEE_PER_10000 = 1; //0.01%
155     uint public totalOnDeposit;
156     uint public totalInCirculation;
157 
158     ///@dev constructor
159     function SAN() {
160         beneficiary = owner = msg.sender;
161     }
162 
163     // ------------------------------------------------------------------------
164     // Don't accept ethers
165     // ------------------------------------------------------------------------
166     function () {
167         throw;
168     }
169 
170     //======== SECTION Configuration: Owner only ========
171     //
172     ///@notice set beneficiary - the account receiving platform fees.
173     function setBeneficiary(address newBeneficiary)
174     external
175     only(owner) {
176         beneficiary = newBeneficiary;
177     }
178 
179 
180     ///@notice attach module managing subscriptions. if subModule==0x0, then disables subscription functionality for this token.
181     /// detached module can usually manage subscriptions, but all operations changing token balances are disabled.
182     function attachSubscriptionModule(SubscriptionModule subModule)
183     noAnyReentrancy
184     external
185     only(owner) {
186         SUBSCRIPTION_MODULE = subModule;
187         if (address(subModule) > 0) subModule.attachToken(this);
188     }
189 
190     ///@notice set platform fee denominated in 1/10000 of SAN token. Thus "1" means 0.01% of SAN token.
191     function setPlatformFeePer10000(uint newFee)
192     external
193     only(owner) {
194         require (newFee <= 10000); //formally maximum fee is 100% (completely insane but technically possible)
195         PLATFORM_FEE_PER_10000 = newFee;
196     }
197 
198 
199     //======== Interface XRateProvider: a trivial exchange rate provider. Rate is 1:1 and SAN symbol as the code
200     //
201     ///@dev used as a default XRateProvider (id==0) by subscription module.
202     ///@notice returns always 1 because exchange rate of the token to itself is always 1.
203     function getRate() returns(uint32 ,uint32) { return (1,1);  }
204     function getCode() public returns(string)  { return symbol; }
205 
206 
207     //==== Interface ERC20ModuleSupport: Subscription, Deposit and Payment Support =====
208     ///
209     ///@dev used by subscription module to operate on token balances.
210     ///@param msg_sender should be an original msg.sender provided to subscription module.
211     function _fulfillPreapprovedPayment(address _from, address _to, uint _value, address msg_sender)
212     public
213     onlyTrusted
214     returns(bool success) {
215         success = _from != msg_sender && allowed[_from][msg_sender] >= _value;
216         if (!success) {
217             Payment(_from, _to, _value, _fee(_value), msg_sender, PaymentStatus.APPROVAL_ERROR, 0);
218         } else {
219             success = _fulfillPayment(_from, _to, _value, 0, msg_sender);
220             if (success) {
221                 allowed[_from][msg_sender] -= _value;
222             }
223         }
224         return success;
225     }
226 
227     ///@dev used by subscription module to operate on token balances.
228     ///@param msg_sender should be an original msg.sender provided to subscription module.
229     function _fulfillPayment(address _from, address _to, uint _value, uint subId, address msg_sender)
230     public
231     onlyTrusted
232     returns (bool success) {
233         var fee = _fee(_value);
234         assert (fee <= _value); //internal sanity check
235         if (balances[_from] >= _value && balances[_to] + _value > balances[_to]) {
236             balances[_from] -= _value;
237             balances[_to] += _value - fee;
238             balances[beneficiary] += fee;
239             Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.OK, subId);
240             return true;
241         } else {
242             Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.BALANCE_ERROR, subId);
243             return false;
244         }
245     }
246 
247     function _fee(uint _value) internal constant returns (uint fee) {
248         return _value * PLATFORM_FEE_PER_10000 / 10000;
249     }
250 
251     ///@notice used by subscription module to re-create token from returning deposit.
252     ///@dev a subscription module is responsible to correct deposit management.
253     function _mintFromDeposit(address owner, uint amount)
254     public
255     onlyTrusted {
256         balances[owner] += amount;
257         totalOnDeposit -= amount;
258         totalInCirculation += amount;
259     }
260 
261     ///@notice used by subscription module to burn token while creating a new deposit.
262     ///@dev a subscription module is responsible to create and maintain the deposit record.
263     function _burnForDeposit(address owner, uint amount)
264     public
265     onlyTrusted
266     returns (bool success) {
267         if (balances[owner] >= amount) {
268             balances[owner] -= amount;
269             totalOnDeposit += amount;
270             totalInCirculation -= amount;
271             return true;
272         } else { return false; }
273     }
274 
275     //========= Crowdsale Only ===============
276     ///@notice mint new token for given account in crowdsale stage
277     ///@dev allowed only if token not started yet and only for registered minter.
278     ///@dev tokens are become in circulation after token start.
279     function mint(uint amount, address account)
280     onlyCrowdsaleMinter
281     isNotStartedOnly
282     {
283         totalSupply += amount;
284         balances[account]+=amount;
285     }
286 
287     ///@notice start normal operation of the token. No minting is possible after this point.
288     function start()
289     isNotStartedOnly
290     only(owner) {
291         totalInCirculation = totalSupply;
292         isStarted = true;
293     }
294 
295     //========= SECTION: Modifier ===============
296 
297     modifier onlyCrowdsaleMinter() {
298         if (msg.sender != CROWDSALE_MINTER) throw;
299         _;
300     }
301 
302     modifier onlyTrusted() {
303         if (msg.sender != SUBSCRIPTION_MODULE) throw;
304         _;
305     }
306 
307     ///@dev token not started means minting is possible, but usual token operations are not.
308     modifier isNotStartedOnly() {
309         if (isStarted) throw;
310         _;
311     }
312 
313     enum PaymentStatus {OK, BALANCE_ERROR, APPROVAL_ERROR}
314     ///@notice event issued on any fee based payment (made of failed).
315     ///@param subId - related subscription Id if any, or zero otherwise.
316     event Payment(address _from, address _to, uint _value, uint _fee, address caller, PaymentStatus status, uint subId);
317 
318 }//contract SAN