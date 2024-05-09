1 pragma solidity 0.5.3;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79      * account.
80      */
81     constructor () internal {
82         _owner = msg.sender;
83         emit OwnershipTransferred(address(0), _owner);
84     }
85 
86     /**
87      * @return the address of the owner.
88      */
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(isOwner());
98         _;
99     }
100 
101     /**
102      * @return true if `msg.sender` is the owner of the contract.
103      */
104     function isOwner() public view returns (bool) {
105         return msg.sender == _owner;
106     }
107 
108     /**
109      * @dev Allows the current owner to relinquish control of the contract.
110      * @notice Renouncing to ownership will leave the contract without an owner.
111      * It will not be possible to call the functions with the `onlyOwner`
112      * modifier anymore.
113      */
114     function renounceOwnership() public onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119     /**
120      * @dev Allows the current owner to transfer control of the contract to a newOwner.
121      * @param newOwner The address to transfer ownership to.
122      */
123     function transferOwnership(address newOwner) public onlyOwner {
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers control of the contract to a newOwner.
129      * @param newOwner The address to transfer ownership to.
130      */
131     function _transferOwnership(address newOwner) internal {
132         require(newOwner != address(0));
133         emit OwnershipTransferred(_owner, newOwner);
134         _owner = newOwner;
135     }
136 }
137 
138 /**
139  * @title PaymentDistributor
140  * @dev distributes all the received funds between project wallets and team members. 
141  */
142 contract PaymentDistributor is Ownable {
143     using SafeMath for uint256;
144 
145     event PaymentReleased(address to, uint256 amount);
146     event PaymentReceived(address from, uint256 amount);
147 
148     // timestamp when fund backup release is enabled
149     uint256 private _backupReleaseTime;
150 
151     uint256 private _totalReleased;
152     mapping(address => uint256) private _released;
153 
154     uint256 private constant step1Fund = uint256(5000) * 10 ** 18;
155 
156     address payable private _beneficiary0;
157     address payable private _beneficiary1;
158     address payable private _beneficiary2;
159     address payable private _beneficiary3;
160     address payable private _beneficiary4;
161     address payable private _beneficiaryBackup;
162 
163     /**
164      * @dev Constructor
165      */
166     constructor (address payable beneficiary0, address payable beneficiary1, address payable beneficiary2, address payable beneficiary3, address payable beneficiary4, address payable beneficiaryBackup, uint256 backupReleaseTime) public {
167         _beneficiary0 = beneficiary0;
168         _beneficiary1 = beneficiary1;
169         _beneficiary2 = beneficiary2;
170         _beneficiary3 = beneficiary3;
171         _beneficiary4 = beneficiary4;
172         _beneficiaryBackup = beneficiaryBackup;
173         _backupReleaseTime = backupReleaseTime;
174     }
175 
176     /**
177      * @dev payable fallback
178      */
179     function () external payable {
180         emit PaymentReceived(msg.sender, msg.value);
181     }
182 
183     /**
184      * @return the total amount already released.
185      */
186     function totalReleased() public view returns (uint256) {
187         return _totalReleased;
188     }
189 
190     /**
191      * @return the amount already released to an account.
192      */
193     function released(address account) public view returns (uint256) {
194         return _released[account];
195     }
196 
197     /**
198      * @return the beneficiary0 of the Payments.
199      */
200     function beneficiary0() public view returns (address) {
201         return _beneficiary0;
202     }
203 
204     /**
205      * @return the beneficiary1 of the Payments.
206      */
207     function beneficiary1() public view returns (address) {
208         return _beneficiary1;
209     }
210 
211     /**
212      * @return the beneficiary2 of the Payments.
213      */
214     function beneficiary2() public view returns (address) {
215         return _beneficiary2;
216     }
217 
218     /**
219      * @return the beneficiary3 of the Payments.
220      */
221     function beneficiary3() public view returns (address) {
222         return _beneficiary3;
223     }
224 
225     /**
226      * @return the beneficiary4 of the Payments.
227      */
228     function beneficiary4() public view returns (address) {
229         return _beneficiary4;
230     }
231 
232     /**
233      * @return the beneficiaryBackup of Payments.
234      */
235     function beneficiaryBackup() public view returns (address) {
236         return _beneficiaryBackup;
237     }
238 
239     /**
240      * @return the time when Payments are released to the beneficiaryBackup wallet.
241      */
242     function backupReleaseTime() public view returns (uint256) {
243         return _backupReleaseTime;
244     }
245 
246     /**
247      * @dev send to one of the beneficiarys' addresses.
248      * @param account Whose the fund will be send to.
249      * @param amount Value in wei to be sent
250      */
251     function sendToAccount(address payable account, uint256 amount) internal {
252         require(amount > 0, 'The amount must be greater than zero.');
253 
254         _released[account] = _released[account].add(amount);
255         _totalReleased = _totalReleased.add(amount);
256 
257         account.transfer(amount);
258         emit PaymentReleased(account, amount);
259     }
260 
261     /**
262      * @dev distributes the amount between team's wallets 
263      * which are created for different purposes.
264      * @param amount Value in wei to send to the wallets.
265      */
266     function release(uint256 amount) onlyOwner public{
267         require(address(this).balance >= amount, 'Balance must be greater than or equal to the amount.');
268         uint256 _value = amount;
269         if (_released[_beneficiary0] < step1Fund) {
270             if (_released[_beneficiary0].add(_value) > step1Fund){
271                 uint256 _remainValue = step1Fund.sub(_released[_beneficiary0]);
272                 _value = _value.sub(_remainValue);
273                 sendToAccount(_beneficiary0, _remainValue);
274             }
275             else {
276                 sendToAccount(_beneficiary0, _value);
277                 _value = 0;
278             }
279         }
280 
281         if (_value > 0) {
282             uint256 _value1 = _value.mul(10).div(100);          //10%
283             uint256 _value2 = _value.mul(7020).div(10000);      //70.2%
284             uint256 _value3 = _value.mul(1080).div(10000);      //10.8%
285             uint256 _value4 = _value.mul(9).div(100);           //9%
286             sendToAccount(_beneficiary1, _value1);
287             sendToAccount(_beneficiary2, _value2);
288             sendToAccount(_beneficiary3, _value3);
289             sendToAccount(_beneficiary4, _value4);
290         }
291     }    
292 
293     /**
294      * @dev transfer the amount to the beneficiaryBackup wallet
295      * which are created for different purposes.
296      * @param amount Value in wei to send to the backup wallet.
297      */
298     function releaseBackup(uint256 amount) onlyOwner public{
299         require(address(this).balance >= amount, 'Balance must be greater than or equal to the amount.');
300         require(block.timestamp >= backupReleaseTime(), 'The transfer is possible only 2 months after the ICO.');
301         sendToAccount(_beneficiaryBackup, amount);
302     }
303 }