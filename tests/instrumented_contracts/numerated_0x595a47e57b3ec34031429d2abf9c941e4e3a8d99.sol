1 //                                               __                __                                                            
2 //                                              |  \              |  \                                                           
3 //   _______  __   __   __   ______    ______  _| $$_     ______  | $$   __   ______   _______       ______    ______    ______  
4 //  /       \|  \ |  \ |  \ |      \  /      \|   $$ \   /      \ | $$  /  \ /      \ |       \     |      \  /      \  /      \ 
5 // |  $$$$$$$| $$ | $$ | $$  \$$$$$$\|  $$$$$$\\$$$$$$  |  $$$$$$\| $$_/  $$|  $$$$$$\| $$$$$$$\     \$$$$$$\|  $$$$$$\|  $$$$$$\
6 //  \$$    \ | $$ | $$ | $$ /      $$| $$  | $$ | $$ __ | $$  | $$| $$   $$ | $$    $$| $$  | $$    /      $$| $$  | $$| $$  | $$
7 //  _\$$$$$$\| $$_/ $$_/ $$|  $$$$$$$| $$__/ $$ | $$|  \| $$__/ $$| $$$$$$\ | $$$$$$$$| $$  | $$ __|  $$$$$$$| $$__/ $$| $$__/ $$
8 // |       $$ \$$   $$   $$ \$$    $$| $$    $$  \$$  $$ \$$    $$| $$  \$$\ \$$     \| $$  | $$|  \\$$    $$| $$    $$| $$    $$
9 //  \$$$$$$$   \$$$$$\$$$$   \$$$$$$$| $$$$$$$    \$$$$   \$$$$$$  \$$   \$$  \$$$$$$$ \$$   \$$ \$$ \$$$$$$$| $$$$$$$ | $$$$$$$ 
10 //                                   | $$                                                                    | $$      | $$      
11 //                                   | $$                                                                    | $$      | $$      
12 //                                    \$$                                                                     \$$       \$$      
13 // https://swaptoken.app
14 
15 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
16 
17 pragma solidity ^0.5.2;
18 
19 /**
20  * @title SafeMath
21  * @dev Unsigned math operations with safety checks that revert on error
22  */
23 library SafeMath {
24     /**
25      * @dev Multiplies two unsigned integers, reverts on overflow.
26      */
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b);
37 
38         return c;
39     }
40 
41     /**
42      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
43      */
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         // Solidity only automatically asserts when dividing by 0
46         require(b > 0);
47         uint256 c = a / b;
48         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 
50         return c;
51     }
52 
53     /**
54      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
55      */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b <= a);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     /**
64      * @dev Adds two unsigned integers, reverts on overflow.
65      */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a);
69 
70         return c;
71     }
72 
73     /**
74      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
75      * reverts when dividing by zero.
76      */
77     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b != 0);
79         return a % b;
80     }
81 }
82 
83 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
84 
85 pragma solidity ^0.5.2;
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://eips.ethereum.org/EIPS/eip-20
90  */
91 interface IERC20 {
92     function transfer(address to, uint256 value) external returns (bool);
93 
94     function approve(address spender, uint256 value) external returns (bool);
95 
96     function transferFrom(address from, address to, uint256 value) external returns (bool);
97 
98     function totalSupply() external view returns (uint256);
99 
100     function balanceOf(address who) external view returns (uint256);
101 
102     function allowance(address owner, address spender) external view returns (uint256);
103 
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 // File: contracts/HashedTimelock.sol
110 
111 pragma solidity 0.5.3;
112 
113 
114 
115 /**
116  * @title Hashed Timelock Contracts (HTLCs) on Ethereum ETH.
117  *
118  * This contract provides a way to create and keep HTLCs for ETH.
119  *
120  * See HashedTimelockERC20.sol for a contract that provides the same functions 
121  * for ERC20 tokens.
122  *
123  * Protocol:
124  *
125  *  1) newContract(receiver, hashlock, timelock) - a sender calls this to create
126  *      a new HTLC and gets back a 32 byte contract id
127  *  2) withdraw(contractId, preimage) - once the receiver knows the preimage of
128  *      the hashlock hash they can claim the ETH with this function
129  *  3) refund() - after timelock has expired and if the receiver did not 
130  *      withdraw funds the sender / creater of the HTLC can get their ETH 
131  *      back with this function.
132  */
133 contract HashedTimelock {
134 
135     using SafeMath for uint256;
136 
137     event LogHTLCNew(
138         bytes32 indexed contractId,
139         address indexed sender,
140         address indexed receiver,
141         uint amount,
142         uint timelock
143     );
144     event LogHTLCWithdraw(bytes32 indexed contractId, bytes32 preimage);
145     event LogHTLCRefund(bytes32 indexed contractId);
146 
147     struct LockContract {
148         address payable sender;
149         address payable receiver;
150         uint amount;
151         uint timelock; // UNIX timestamp seconds - locked UNTIL this time
152         bool withdrawn;
153         bool refunded;
154         bytes32 preimage;
155     }
156 
157     modifier fundsSent() {
158         require(msg.value > 0, "msg.value must be > 0");
159         _;
160     }
161     modifier futureTimelock(uint _time) {
162         // only requirement is the timelock time is after the last blocktime (now).
163         // probably want something a bit further in the future then this.
164         // but this is still a useful sanity check:
165         require(_time > now + 1 hours, "timelock time must be in the future");
166         _;
167     }
168     modifier contractExists(bytes32 _contractId) {
169         require(haveContract(_contractId), "contractId does not exist");
170         _;
171     }
172     modifier hashlockMatches(bytes32 _contractId, bytes32 _x) {
173         require(
174             _contractId == keccak256(abi.encodePacked(_x)),
175             "hashlock hash does not match"
176         );
177         _;
178     }
179     modifier withdrawable(bytes32 _contractId) {
180         require(contracts[_contractId].withdrawn == false, "withdrawable: already withdrawn");
181         require(contracts[_contractId].refunded == false, "withdrawable: already refunded");
182         _;
183     }
184     modifier refundable(bytes32 _contractId) {
185         require(contracts[_contractId].sender == msg.sender, "refundable: not sender");
186         require(contracts[_contractId].refunded == false, "refundable: already refunded");
187         require(contracts[_contractId].withdrawn == false, "refundable: already withdrawn");
188         require(contracts[_contractId].timelock <= now, "refundable: timelock not yet passed");
189         _;
190     }
191 
192     modifier onlyOwner() {
193         require(msg.sender == owner, "you are not an owner");
194         _;
195     }
196 
197     mapping (bytes32 => LockContract) contracts;
198     uint256 public feePercent; // 5 == 0.05 %
199     uint oneHundredPercent = 10000; // 100 %
200     address payable public owner;
201     uint feeToWithdraw;
202 
203     constructor(address payable _owner, uint256 _feePercent) public {
204         feePercent = _feePercent;
205         owner = _owner;
206     }
207 
208     function setFeePercent(uint256 _feePercent) external onlyOwner {
209         require(_feePercent < oneHundredPercent.div(2), "should be less than 50%");
210         feePercent = _feePercent;
211     }
212     /**
213      * @dev Sender sets up a new hash time lock contract depositing the ETH and 
214      * providing the reciever lock terms.
215      *
216      * @param _receiver Receiver of the ETH.
217      * @param _hashlock A sha-2 sha256 hash hashlock.
218      * @param _timelock UNIX epoch seconds time that the lock expires at. 
219      *                  Refunds can be made after this time.
220      */
221     function newContract(address payable _receiver, bytes32 _hashlock, uint _timelock)
222         external
223         payable
224         fundsSent
225         futureTimelock(_timelock)
226     {
227         uint256 swapValue = msg.value.mul(oneHundredPercent).div(oneHundredPercent.add(feePercent));
228         uint feeValue = msg.value.sub(swapValue);
229         feeToWithdraw = feeValue.add(feeToWithdraw);
230 
231         // Reject if a contract already exists with the same parameters. The
232         // sender must change one of these parameters to create a new distinct 
233         // contract.
234         if (haveContract(_hashlock)) {
235             revert("contract exist");
236         }
237 
238         contracts[_hashlock] = LockContract(
239             msg.sender,
240             _receiver,
241             swapValue,
242             _timelock,
243             false,
244             false,
245             0x0
246         );
247 
248         emit LogHTLCNew(
249             _hashlock,
250             msg.sender,
251             _receiver,
252             swapValue,
253             _timelock
254         );
255     }
256 
257     /**
258      * @dev Called by the receiver once they know the preimage of the hashlock.
259      * This will transfer the locked funds to their address.
260      *
261      * @param _contractId Id of the HTLC.
262      * @param _preimage sha256(_preimage) should equal the contract hashlock.
263      * @return bool true on success
264      */
265     function withdraw(bytes32 _contractId, bytes32 _preimage)
266         external
267         contractExists(_contractId)
268         hashlockMatches(_contractId, _preimage)
269         withdrawable(_contractId)
270         returns (bool)
271     {
272         LockContract storage c = contracts[_contractId];
273         c.preimage = _preimage;
274         c.withdrawn = true;
275         c.receiver.transfer(c.amount);
276         emit LogHTLCWithdraw(_contractId, _preimage);
277         return true;
278     }
279 
280     /**
281      * @dev Called by the sender if there was no withdraw AND the time lock has
282      * expired. This will refund the contract amount.
283      *
284      * @param _contractId Id of HTLC to refund from.
285      * @return bool true on success
286      */
287     function refund(bytes32 _contractId)
288         external
289         contractExists(_contractId)
290         refundable(_contractId)
291         returns (bool)
292     {
293         LockContract storage c = contracts[_contractId];
294         c.refunded = true;
295         c.sender.transfer(c.amount);
296         emit LogHTLCRefund(_contractId);
297         return true;
298     }
299 
300     function claimTokens(address _token) external onlyOwner {
301         if (_token == address(0)) {
302             owner.transfer(feeToWithdraw);
303             return;
304         }
305         IERC20 erc20token = IERC20(_token);
306         uint256 balance = erc20token.balanceOf(address(this));
307         erc20token.transfer(owner, balance);
308     }
309 
310     /**
311      * @dev Get contract details.
312      * @param _contractId HTLC contract id
313      * @return All parameters in struct LockContract for _contractId HTLC
314      */
315     function getContract(bytes32 _contractId)
316         public
317         view
318         returns (
319             address sender,
320             address receiver,
321             uint amount,
322             uint timelock,
323             bool withdrawn,
324             bool refunded,
325             bytes32 preimage
326         )
327     {
328         if (haveContract(_contractId) == false)
329             return (address(0), address(0), 0, 0, false, false, 0);
330         LockContract storage c = contracts[_contractId];
331         return (c.sender, c.receiver, c.amount, c.timelock,
332             c.withdrawn, c.refunded, c.preimage);
333     }
334 
335     /**
336      * @dev Is there a contract with id _contractId.
337      * @param _contractId Id into contracts mapping.
338      */
339     function haveContract(bytes32 _contractId)
340         public
341         view
342         returns (bool exists)
343     {
344         exists = (contracts[_contractId].sender != address(0));
345     }
346 
347 }