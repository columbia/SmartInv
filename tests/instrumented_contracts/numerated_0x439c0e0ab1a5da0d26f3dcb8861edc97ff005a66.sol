1 pragma solidity ^0.4.23;
2 
3 contract ERC223Interface {
4     uint public totalSupply;
5     uint8 public decimals;
6     function balanceOf(address who) constant returns (uint);
7     function transfer(address to, uint value);
8     function transfer(address to, uint value, bytes data);
9     event Transfer(address indexed from, address indexed to, uint value, bytes data);
10 }
11 
12 contract ERC223ReceivingContract {
13     
14     /**
15      * @dev Standard ERC223 function that will handle incoming token transfers.
16      *
17      * @param _from  Token sender address.
18      * @param _value Amount of tokens.
19      * @param _data  Transaction metadata.
20      */
21     function tokenFallback(address _from, uint _value, bytes _data);
22 }
23 
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 
63 }
64 
65 
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, throws on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     if (a == 0) {
78       return 0;
79     }
80     c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     // uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return a / b;
93   }
94 
95   /**
96   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
107     c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 
114 /**
115  * @title AirDropContract
116  * Simply do the airdrop.
117  */
118 contract AirDropForERC223 is Ownable {
119     using SafeMath for uint256;
120 
121     // the amount that owner wants to send each time
122     uint public airDropAmount;
123 
124     // the mapping to judge whether each address has already received airDropped
125     mapping ( address => bool ) public invalidAirDrop;
126 
127     // the mapping of testAccount
128     mapping ( address => bool ) public isTestAccount;
129 
130     // the array of addresses which received airDrop
131     address[] public arrayAirDropReceivers;
132 
133     // flag to stop airdrop
134     bool public stop = false;
135 
136     ERC223Interface public token;
137 
138     uint256 public startTime;
139     uint256 public endTime;
140 
141     // event
142     event LogAirDrop(address indexed receiver, uint amount);
143     event LogStop();
144     event LogStart();
145     event LogWithdrawal(address indexed receiver, uint amount);
146     event LogInfoUpdate(uint256 startTime, uint256 endTime, uint256 airDropAmount);
147 
148     /**
149      * @dev Constructor to set _airDropAmount and _tokenAddresss.
150      * @param _airDropAmount The amount of token that is sent for doing airDrop.
151      * @param _tokenAddress The address of token.
152      */
153     constructor(uint256 _startTime, uint256 _endTime, uint _airDropAmount, address _tokenAddress, address[] _testAccounts) public {
154         require(
155             _startTime >= now &&
156             _endTime >= _startTime &&
157             _airDropAmount > 0 &&
158             _tokenAddress != address(0)
159         );
160         startTime = _startTime;
161         endTime = _endTime;
162         token = ERC223Interface(_tokenAddress);
163         uint tokenDecimals = token.decimals();
164         airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);
165 
166         for (uint i = 0; i < _testAccounts.length; i++ ) {
167             isTestAccount[_testAccounts[i]] = true;
168         }
169     }
170 
171     /**
172      * @dev Standard ERC223 function that will handle incoming token transfers.
173      *
174      * @param _from  Token sender address.
175      * @param _value Amount of tokens.
176      * @param _data  Transaction metadata.
177      */
178     function tokenFallback(address _from, uint _value, bytes _data) {}
179 
180     /**
181      * @dev Confirm that airDrop is available.
182      * @return A bool to confirm that airDrop is available.
183      */
184     function isValidAirDropForAll() public view returns (bool) {
185         bool validNotStop = !stop;
186         bool validAmount = getRemainingToken() >= airDropAmount;
187         bool validPeriod = now >= startTime && now <= endTime;
188         return validNotStop && validAmount && validPeriod;
189     }
190 
191     /**
192      * @dev Confirm that airDrop is available for msg.sender.
193      * @return A bool to confirm that airDrop is available for msg.sender.
194      */
195     function isValidAirDropForIndividual() public view returns (bool) {
196         bool validNotStop = !stop;
197         bool validAmount = getRemainingToken() >= airDropAmount;
198         bool validPeriod = now >= startTime && now <= endTime;
199         bool validReceiveAirDropForIndividual = !invalidAirDrop[msg.sender];
200         return validNotStop && validAmount && validPeriod && validReceiveAirDropForIndividual;
201     }
202 
203     /**
204      * @dev Do the airDrop to msg.sender
205      */
206     function receiveAirDrop() public {
207         if (isTestAccount[msg.sender]) {
208             // execute transfer
209             token.transfer(msg.sender, airDropAmount);
210         } else {
211             require(isValidAirDropForIndividual());
212 
213             // set invalidAirDrop of msg.sender to true
214             invalidAirDrop[msg.sender] = true;
215 
216             // set msg.sender to the array of the airDropReceiver
217             arrayAirDropReceivers.push(msg.sender);
218 
219             // execute transfer
220             token.transfer(msg.sender, airDropAmount);
221 
222             emit LogAirDrop(msg.sender, airDropAmount);
223         }
224     }
225 
226     /**
227      * @dev Change the state of stop flag
228      */
229     function toggle() public onlyOwner {
230         stop = !stop;
231 
232         if (stop) {
233             emit LogStop();
234         } else {
235             emit LogStart();
236         }
237     }
238 
239     /**
240      * @dev Withdraw the amount of token that is remaining in this contract.
241      * @param _address The address of EOA that can receive token from this contract.
242      */
243     function withdraw(address _address) public onlyOwner {
244         require(
245             stop ||
246             now > endTime
247         );
248         require(_address != address(0));
249         uint tokenBalanceOfContract = getRemainingToken();
250         token.transfer(_address, tokenBalanceOfContract);
251         emit LogWithdrawal(_address, tokenBalanceOfContract);
252     }
253 
254     /**
255      * @dev Update the information regarding to period and amount.
256      * @param _startTime The start time this airdrop starts.
257      * @param _endTime The end time this sirdrop ends.
258      * @param _airDropAmount The airDrop Amount that user can get via airdrop.
259      */
260     function updateInfo(uint256 _startTime, uint256 _endTime, uint256 _airDropAmount) public onlyOwner {
261         require(
262             stop ||
263             now > endTime
264         );
265         require(
266             _startTime >= now &&
267             _endTime >= _startTime &&
268             _airDropAmount > 0
269         );
270 
271         startTime = _startTime;
272         endTime = _endTime;
273         uint tokenDecimals = token.decimals();
274         airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);
275 
276         emit LogInfoUpdate(startTime, endTime, airDropAmount);
277     }
278 
279     /**
280      * @dev Get the total number of addresses which received airDrop.
281      * @return Uint256 the total number of addresses which received airDrop.
282      */
283     function getTotalNumberOfAddressesReceivedAirDrop() public view returns (uint256) {
284         return arrayAirDropReceivers.length;
285     }
286 
287     /**
288      * @dev Get the remaining amount of token user can receive.
289      * @return Uint256 the amount of token that user can reveive.
290      */
291     function getRemainingToken() public view returns (uint256) {
292         return token.balanceOf(this);
293     }
294 
295     /**
296      * @dev Return the total amount of token user received.
297      * @return Uint256 total amount of token user received.
298      */
299     function getTotalAirDroppedAmount() public view returns (uint256) {
300         return airDropAmount.mul(arrayAirDropReceivers.length);
301     }
302 }