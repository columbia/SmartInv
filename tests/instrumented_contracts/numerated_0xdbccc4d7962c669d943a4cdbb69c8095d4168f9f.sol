1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 pragma solidity ^0.5.2;
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor () internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     /**
93      * @return the address of the owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(isOwner());
104         _;
105     }
106 
107     /**
108      * @return true if `msg.sender` is the owner of the contract.
109      */
110     function isOwner() public view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     /**
115      * @dev Allows the current owner to relinquish control of the contract.
116      * @notice Renouncing to ownership will leave the contract without an owner.
117      * It will not be possible to call the functions with the `onlyOwner`
118      * modifier anymore.
119      */
120     function renounceOwnership() public onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 
125     /**
126      * @dev Allows the current owner to transfer control of the contract to a newOwner.
127      * @param newOwner The address to transfer ownership to.
128      */
129     function transferOwnership(address newOwner) public onlyOwner {
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers control of the contract to a newOwner.
135      * @param newOwner The address to transfer ownership to.
136      */
137     function _transferOwnership(address newOwner) internal {
138         require(newOwner != address(0));
139         emit OwnershipTransferred(_owner, newOwner);
140         _owner = newOwner;
141     }
142 }
143 
144 // File: contracts/brothers.sol
145 
146 pragma solidity ^0.5.0;
147 
148 
149 
150 
151 //import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
152 //import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";
153 
154 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/lifecycle/Pausable.sol";
155 
156 
157 contract brothers is Ownable { //
158     using SafeMath for uint256;
159 
160     event EthIssued(uint256 value);
161 
162     event AddressAdded(address newbrother);
163     event AddressRemoved(address oldbrother);
164 
165 
166     address payable[] bizbrothers;
167     address payable[] devbrothers;
168     address payable[] tradebrothers;
169     address payable[] socialbrothers;
170     uint256 public pool;
171     uint256 public serviceshare;
172 
173     
174     uint256 public total_distributed;
175 
176     address payable service_costs = 0x5315845c377DC739Db349c24760955bf3aA88e2a;
177 
178     constructor() public Ownable() {
179         
180         emit EthIssued(0);
181         
182         bizbrothers.push(0x7A6C7Da79Ac78C9f473D8723E1e62030414B6909);
183         bizbrothers.push(0x5736AF088b326DaFCbF8fCBe005241245E853a0F);
184         bizbrothers.push(0x1f6bca1657e2B08A31A562B14c6A5c7e49661eb2);
185         
186         devbrothers.push(0x73D0e9F8dACa563A50fd70498Be9390088594E72);
187 
188         tradebrothers.push(0xC02bc79F386685CE4bAEc9243982BAf9163A06E7);
189         tradebrothers.push(0x27b8e7fffC5d3DC967c96b2cA0E7EC028268A2b6);
190         tradebrothers.push(0x4C1f6069D12d7110985b48f963084C3ccf48aB06);
191 
192         socialbrothers.push(0xe91717B09Cd9D0e8f548EC5cE2921da9C2367356);
193     }
194 
195     function () external payable {
196         
197     }
198 
199     function distributepool() external payable {
200         //if msg.value
201         
202         pool = address(this).balance;
203         if(msg.value > 0){
204             pool = pool + msg.value;
205         }
206         serviceshare = pool / 100 * 10;
207         service_costs.transfer(serviceshare);
208         pool = pool - serviceshare;
209 
210         uint256 bizshare = pool / 8 * 3;
211         for(uint256 i = 0; i < bizbrothers.length; i++){
212             bizbrothers[i].transfer(bizshare / bizbrothers.length);
213         }
214 
215         uint256 devshare = pool / 8 * 1;
216         for(uint256 i = 0; i < devbrothers.length; i++){
217             devbrothers[i].transfer(devshare / devbrothers.length);
218         }
219 
220         uint256 tradeshare = pool / 8 * 3;
221         for(uint256 i = 0; i < tradebrothers.length; i++){
222             tradebrothers[i].transfer(tradeshare / tradebrothers.length);
223         }
224 
225         uint256 socialshare = pool / 8 * 1;
226         for(uint256 i = 0; i < socialbrothers.length; i++){
227             socialbrothers[i].transfer(socialshare / socialbrothers.length);
228         }
229 
230     }
231  
232     function addbizbrother(address payable newbrother) external onlyOwner(){
233         bizbrothers.push(newbrother);
234         emit AddressAdded(newbrother);
235     }
236 
237     function adddevbrother(address payable newbrother) external onlyOwner(){
238         devbrothers.push(newbrother);
239         emit AddressAdded(newbrother);
240     }
241 
242     function addtradebrother(address payable newbrother) external onlyOwner(){
243         tradebrothers.push(newbrother);
244         emit AddressAdded(newbrother);
245     }
246 
247     function addsocialbrother(address payable newbrother) external onlyOwner(){
248         socialbrothers.push(newbrother);
249         emit AddressAdded(newbrother);
250     }
251 
252     function removebrother(address payable oldbrother) external onlyOwner(){
253         for(uint256 i = 0; i < bizbrothers.length; i++){
254             if(bizbrothers[i] == oldbrother){
255                 for (uint j = i; j < bizbrothers.length-1; j++){
256                     bizbrothers[j] = bizbrothers[j+1];
257                 }
258                 bizbrothers.length--;
259             }
260 
261         }
262         for(uint256 i = 0; i < devbrothers.length; i++){
263             if(devbrothers[i] == oldbrother){
264                 for (uint j = i; j < devbrothers.length-1; j++){
265                     devbrothers[j] = devbrothers[j+1];
266                 }
267                 devbrothers.length--;
268             }
269 
270         }
271         for(uint256 i = 0; i < tradebrothers.length; i++){
272             if(tradebrothers[i] == oldbrother){
273                 for (uint j = i; j < tradebrothers.length-1; j++){
274                     tradebrothers[j] = tradebrothers[j+1];
275                 }
276                 tradebrothers.length--;
277             }
278 
279         }
280         for(uint256 i = 0; i < socialbrothers.length; i++){
281             if(socialbrothers[i] == oldbrother){
282                 for (uint j = i; j < socialbrothers.length-1; j++){
283                     socialbrothers[j] = socialbrothers[j+1];
284                 }
285                 socialbrothers.length--;
286             }
287 
288         }
289 
290     }
291 
292 
293 }