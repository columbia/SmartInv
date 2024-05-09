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
127     // the array of addresses which received airDrop
128     address[] public arrayAirDropReceivers;
129 
130     // flag to stop airdrop
131     bool public stop = false;
132 
133     ERC223Interface public erc20;
134 
135     uint256 public startTime;
136     uint256 public endTime;
137 
138     // event
139     event LogAirDrop(address indexed receiver, uint amount);
140     event LogStop();
141     event LogStart();
142     event LogWithdrawal(address indexed receiver, uint amount);
143     event LogInfoUpdate(uint256 startTime, uint256 endTime, uint256 airDropAmount);
144 
145     /**
146     * @dev Constructor to set _airDropAmount and _tokenAddresss.
147     * @param _airDropAmount The amount of token that is sent for doing airDrop.
148     * @param _tokenAddress The address of token.
149     */
150     constructor(uint256 _startTime, uint256 _endTime, uint _airDropAmount, address _tokenAddress) public {
151         require(_startTime >= now &&
152             _endTime >= _startTime &&
153             _airDropAmount > 0 &&
154             _tokenAddress != address(0)
155         );
156         startTime = _startTime;
157         endTime = _endTime;
158         erc20 = ERC223Interface(_tokenAddress);
159         uint tokenDecimals = erc20.decimals();
160         airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);
161     }
162 
163     /**
164      * @dev Standard ERC223 function that will handle incoming token transfers.
165      *
166      * @param _from  Token sender address.
167      * @param _value Amount of tokens.
168      * @param _data  Transaction metadata.
169      */
170     function tokenFallback(address _from, uint _value, bytes _data) {}
171 
172     /**
173     * @dev Confirm that airDrop is available.
174     * @return A bool to confirm that airDrop is available.
175     */
176     function isValidAirDropForAll() public view returns (bool) {
177         bool validNotStop = !stop;
178         bool validAmount = getRemainingToken() >= airDropAmount;
179         bool validPeriod = now >= startTime && now <= endTime;
180         return validNotStop && validAmount && validPeriod;
181     }
182 
183     /**
184     * @dev Confirm that airDrop is available for msg.sender.
185     * @return A bool to confirm that airDrop is available for msg.sender.
186     */
187     function isValidAirDropForIndividual() public view returns (bool) {
188         bool validNotStop = !stop;
189         bool validAmount = getRemainingToken() >= airDropAmount;
190         bool validPeriod = now >= startTime && now <= endTime;
191         bool validReceiveAirDropForIndividual = !invalidAirDrop[msg.sender];
192         return validNotStop && validAmount && validPeriod && validReceiveAirDropForIndividual;
193     }
194 
195     /**
196     * @dev Do the airDrop to msg.sender
197     */
198     function receiveAirDrop() public {
199         require(isValidAirDropForIndividual());
200 
201         // set invalidAirDrop of msg.sender to true
202         invalidAirDrop[msg.sender] = true;
203 
204         // set msg.sender to the array of the airDropReceiver
205         arrayAirDropReceivers.push(msg.sender);
206 
207         // execute transfer
208         erc20.transfer(msg.sender, airDropAmount);
209 
210         emit LogAirDrop(msg.sender, airDropAmount);
211     }
212 
213     /**
214     * @dev Change the state of stop flag
215     */
216     function toggle() public onlyOwner {
217         stop = !stop;
218 
219         if (stop) {
220             emit LogStop();
221         } else {
222             emit LogStart();
223         }
224     }
225 
226     /**
227     * @dev Withdraw the amount of token that is remaining in this contract.
228     * @param _address The address of EOA that can receive token from this contract.
229     */
230     function withdraw(address _address) public onlyOwner {
231         require(stop || now > endTime);
232         require(_address != address(0));
233         uint tokenBalanceOfContract = getRemainingToken();
234         erc20.transfer(_address, tokenBalanceOfContract);
235         emit LogWithdrawal(_address, tokenBalanceOfContract);
236     }
237 
238     /**
239     * @dev Update the information regarding to period and amount.
240     * @param _startTime The start time this airdrop starts.
241     * @param _endTime The end time this sirdrop ends.
242     * @param _airDropAmount The airDrop Amount that user can get via airdrop.
243     */
244     function updateInfo(uint256 _startTime, uint256 _endTime, uint256 _airDropAmount) public onlyOwner {
245         require(stop || now > endTime);
246         require(
247             _startTime >= now &&
248             _endTime >= _startTime &&
249             _airDropAmount > 0
250         );
251 
252         startTime = _startTime;
253         endTime = _endTime;
254         uint tokenDecimals = erc20.decimals();
255         airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);
256 
257         emit LogInfoUpdate(startTime, endTime, airDropAmount);
258     }
259 
260     /**
261     * @dev Get the total number of addresses which received airDrop.
262     * @return Uint256 the total number of addresses which received airDrop.
263     */
264     function getTotalNumberOfAddressesReceivedAirDrop() public view returns (uint256) {
265         return arrayAirDropReceivers.length;
266     }
267 
268     /**
269     * @dev Get the remaining amount of token user can receive.
270     * @return Uint256 the amount of token that user can reveive.
271     */
272     function getRemainingToken() public view returns (uint256) {
273         return erc20.balanceOf(this);
274     }
275 
276     /**
277     * @dev Return the total amount of token user received.
278     * @return Uint256 total amount of token user received.
279     */
280     function getTotalAirDroppedAmount() public view returns (uint256) {
281         return airDropAmount.mul(arrayAirDropReceivers.length);
282     }
283 }