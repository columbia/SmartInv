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
14 pragma solidity ^0.5.2;
15 
16 /**
17  * @title SafeMath
18  * @dev Unsigned math operations with safety checks that revert on error
19  */
20 library SafeMath {
21     /**
22      * @dev Multiplies two unsigned integers, reverts on overflow.
23      */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b);
34 
35         return c;
36     }
37 
38     /**
39      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
40      */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0);
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 
50     /**
51      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         require(b <= a);
55         uint256 c = a - b;
56 
57         return c;
58     }
59 
60     /**
61      * @dev Adds two unsigned integers, reverts on overflow.
62      */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a);
66 
67         return c;
68     }
69 
70     /**
71      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
72      * reverts when dividing by zero.
73      */
74     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b != 0);
76         return a % b;
77     }
78 }
79 
80 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
81 
82 pragma solidity ^0.5.2;
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://eips.ethereum.org/EIPS/eip-20
87  */
88 interface IERC20 {
89     function transfer(address to, uint256 value) external returns (bool);
90 
91     function approve(address spender, uint256 value) external returns (bool);
92 
93     function transferFrom(address from, address to, uint256 value) external returns (bool);
94 
95     function totalSupply() external view returns (uint256);
96 
97     function balanceOf(address who) external view returns (uint256);
98 
99     function allowance(address owner, address spender) external view returns (uint256);
100 
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: contracts/HashedTimelock.sol
107 
108 pragma solidity 0.5.3;
109 
110 
111 
112 /**
113  * @title Hashed Timelock Contracts (HTLCs) on Ethereum ETH.
114  *
115  * This contract provides a way to create and keep HTLCs for ETH.
116  *
117  *
118  * Protocol:
119  *
120  *  1) newContract(receiver, hashlock, timelock) - a sender calls this to create
121  *      a new HTLC and gets back a 32 byte contract id
122  *  2) withdraw(contractId, preimage) - once the receiver knows the preimage of
123  *      the hashlock hash they can claim the ETH with this function
124  *  3) refund() - after timelock has expired and if the receiver did not 
125  *      withdraw funds the sender / creater of the HTLC can get their ETH 
126  *      back with this function.
127  */
128 contract HashedTimelock {
129 
130     using SafeMath for uint256;
131 
132     event LogHTLCNew(
133         bytes32 indexed contractId,
134         address indexed sender,
135         address indexed receiver,
136         uint amount,
137         uint timelock
138     );
139     event LogHTLCWithdraw(bytes32 indexed contractId, bytes32 preimage);
140     event LogHTLCRefund(bytes32 indexed contractId);
141 
142     struct LockContract {
143         address payable sender;
144         address payable receiver;
145         uint amount;
146         uint timelock; // UNIX timestamp seconds - locked UNTIL this time
147         bool withdrawn;
148         bool refunded;
149         bytes32 preimage;
150     }
151 
152     modifier fundsSent() {
153         require(msg.value > 0, "msg.value must be > 0");
154         _;
155     }
156     modifier futureTimelock(uint _time) {
157         // only requirement is the timelock time is after the last blocktime (now).
158         // probably want something a bit further in the future then this.
159         // but this is still a useful sanity check:
160         require(_time > now + 1 hours, "timelock time must be in the future");
161         _;
162     }
163     modifier contractExists(bytes32 _contractId) {
164         require(haveContract(_contractId), "contractId does not exist");
165         _;
166     }
167     modifier hashlockMatches(bytes32 _contractId, bytes32 _x) {
168         require(
169             _contractId == keccak256(abi.encodePacked(_x)),
170             "hashlock hash does not match"
171         );
172         _;
173     }
174     modifier withdrawable(bytes32 _contractId) {
175         require(contracts[_contractId].receiver == msg.sender, "withdrawable: not receiver");
176         require(contracts[_contractId].withdrawn == false, "withdrawable: already withdrawn");
177         _;
178     }
179     modifier refundable(bytes32 _contractId) {
180         require(contracts[_contractId].sender == msg.sender, "refundable: not sender");
181         require(contracts[_contractId].refunded == false, "refundable: already refunded");
182         require(contracts[_contractId].withdrawn == false, "refundable: already withdrawn");
183         require(contracts[_contractId].timelock <= now, "refundable: timelock not yet passed");
184         _;
185     }
186 
187     modifier onlyOwner() {
188         require(msg.sender == owner, "you are not an owner");
189         _;
190     }
191 
192     mapping (bytes32 => LockContract) contracts;
193     uint256 public feePercent; // 5 == 0.05 %
194     uint oneHundredPercent = 10000; // 100 %
195     address payable public owner;
196     uint feeToWithdraw;
197 
198     constructor(address payable _owner, uint256 _feePercent) public {
199         feePercent = _feePercent;
200         owner = _owner;
201     }
202 
203     function setFeePercent(uint256 _feePercent) external onlyOwner {
204         require(_feePercent < oneHundredPercent.div(2), "should be less than 50%");
205         feePercent = _feePercent;
206     }
207     /**
208      * @dev Sender sets up a new hash time lock contract depositing the ETH and 
209      * providing the reciever lock terms.
210      *
211      * @param _receiver Receiver of the ETH.
212      * @param _hashlock A keccak256 hash hashlock.
213      * @param _timelock UNIX epoch seconds time that the lock expires at. 
214      *                  Refunds can be made after this time.
215      */
216     function newContract(address payable _receiver, bytes32 _hashlock, uint _timelock)
217         external
218         payable
219         fundsSent
220         futureTimelock(_timelock)
221     {
222         uint256 swapValue = msg.value.mul(oneHundredPercent).div(oneHundredPercent.add(feePercent));
223         uint feeValue = msg.value.sub(swapValue);
224         feeToWithdraw = feeValue.add(feeToWithdraw);
225 
226         // Reject if a contract already exists with the same parameters. The
227         // sender must change one of these parameters to create a new distinct 
228         // contract.
229         if (haveContract(_hashlock)) {
230             revert("contract exist");
231         }
232 
233         contracts[_hashlock] = LockContract(
234             msg.sender,
235             _receiver,
236             swapValue,
237             _timelock,
238             false,
239             false,
240             0x0
241         );
242 
243         emit LogHTLCNew(
244             _hashlock,
245             msg.sender,
246             _receiver,
247             swapValue,
248             _timelock
249         );
250     }
251 
252     /**
253      * @dev Called by the receiver once they know the preimage of the hashlock.
254      * This will transfer the locked funds to their address.
255      *
256      * @param _contractId Id of the HTLC.
257      * @param _preimage keccak256(_preimage) should equal the contract hashlock.
258      * @return bool true on success
259      */
260     function withdraw(bytes32 _contractId, bytes32 _preimage)
261         external
262         contractExists(_contractId)
263         hashlockMatches(_contractId, _preimage)
264         withdrawable(_contractId)
265         returns (bool)
266     {
267         LockContract storage c = contracts[_contractId];
268         c.preimage = _preimage;
269         c.withdrawn = true;
270         c.receiver.transfer(c.amount);
271         emit LogHTLCWithdraw(_contractId, _preimage);
272         return true;
273     }
274 
275     /**
276      * @dev Called by the sender if there was no withdraw AND the time lock has
277      * expired. This will refund the contract amount.
278      *
279      * @param _contractId Id of HTLC to refund from.
280      * @return bool true on success
281      */
282     function refund(bytes32 _contractId)
283         external
284         contractExists(_contractId)
285         refundable(_contractId)
286         returns (bool)
287     {
288         LockContract storage c = contracts[_contractId];
289         c.refunded = true;
290         c.sender.transfer(c.amount);
291         emit LogHTLCRefund(_contractId);
292         return true;
293     }
294 
295     function claimTokens(address _token) external onlyOwner {
296         if (_token == address(0)) {
297             owner.transfer(feeToWithdraw);
298             return;
299         }
300         IERC20 erc20token = IERC20(_token);
301         uint256 balance = erc20token.balanceOf(address(this));
302         erc20token.transfer(owner, balance);
303     }
304 
305     /**
306      * @dev Get contract details.
307      * @param _contractId HTLC contract id
308      * @return All parameters in struct LockContract for _contractId HTLC
309      */
310     function getContract(bytes32 _contractId)
311         public
312         view
313         returns (
314             address sender,
315             address receiver,
316             uint amount,
317             uint timelock,
318             bool withdrawn,
319             bool refunded,
320             bytes32 preimage
321         )
322     {
323         if (haveContract(_contractId) == false)
324             return (address(0), address(0), 0, 0, false, false, 0);
325         LockContract storage c = contracts[_contractId];
326         return (c.sender, c.receiver, c.amount, c.timelock,
327             c.withdrawn, c.refunded, c.preimage);
328     }
329 
330     /**
331      * @dev Is there a contract with id _contractId.
332      * @param _contractId Id into contracts mapping.
333      */
334     function haveContract(bytes32 _contractId)
335         public
336         view
337         returns (bool exists)
338     {
339         exists = (contracts[_contractId].sender != address(0));
340     }
341 
342 }