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
118 contract AirDrop is Ownable {
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
143 
144     /**
145     * @dev Constructor to set _airDropAmount and _tokenAddresss.
146     * @param _airDropAmount The amount of token that is sent for doing airDrop.
147     * @param _tokenAddress The address of token.
148     */
149     constructor(uint256 _startTime, uint256 _endTime, uint _airDropAmount, address _tokenAddress) public {
150         require(_startTime >= now &&
151             _endTime >= _startTime &&
152             _airDropAmount > 0 &&
153             _tokenAddress != address(0)
154         );
155         startTime = _startTime;
156         endTime = _endTime;
157         erc20 = ERC223Interface(_tokenAddress);
158         uint tokenDecimals = erc20.decimals();
159         airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);
160     }
161 
162     /**
163      * @dev Standard ERC223 function that will handle incoming token transfers.
164      *
165      * @param _from  Token sender address.
166      * @param _value Amount of tokens.
167      * @param _data  Transaction metadata.
168      */
169     function tokenFallback(address _from, uint _value, bytes _data) {}
170 
171     /**
172     * @dev Confirm that airDrop is available.
173     * @return A bool to confirm that airDrop is available.
174     */
175     function isValidAirDropForAll() public view returns (bool) {
176         bool validNotStop = !stop;
177         bool validAmount = getRemainingToken() >= airDropAmount;
178         bool validPeriod = now >= startTime && now <= endTime;
179         return validNotStop && validAmount && validPeriod;
180     }
181 
182     /**
183     * @dev Confirm that airDrop is available for msg.sender.
184     * @return A bool to confirm that airDrop is available for msg.sender.
185     */
186     function isValidAirDropForIndividual() public view returns (bool) {
187         bool validNotStop = !stop;
188         bool validAmount = getRemainingToken() >= airDropAmount;
189         bool validPeriod = now >= startTime && now <= endTime;
190         bool validReceiveAirDropForIndividual = !invalidAirDrop[msg.sender];
191         return validNotStop && validAmount && validPeriod && validReceiveAirDropForIndividual;
192     }
193 
194     /**
195     * @dev Do the airDrop to msg.sender
196     */
197     function receiveAirDrop() public {
198         require(isValidAirDropForIndividual());
199 
200         // set invalidAirDrop of msg.sender to true
201         invalidAirDrop[msg.sender] = true;
202 
203         // set msg.sender to the array of the airDropReceiver
204         arrayAirDropReceivers.push(msg.sender);
205 
206         // execute transferFrom
207         erc20.transfer(msg.sender, airDropAmount);
208 
209         emit LogAirDrop(msg.sender, airDropAmount);
210     }
211 
212     /**
213     * @dev Change the state of stop flag
214     */
215     function toggle() public onlyOwner {
216         stop = !stop;
217 
218         if (stop) {
219             emit LogStop();
220         } else {
221             emit LogStart();
222         }
223     }
224 
225     /**
226     * @dev Withdraw the amount of token that is remaining in this contract.
227     * @param _address The address of EOA that can receive token from this contract.
228     */
229     function withdraw(address _address) public onlyOwner {
230         require(stop || now > endTime);
231         require(_address != address(0));
232         uint tokenBalanceOfContract = getRemainingToken();
233         erc20.transfer(_address, tokenBalanceOfContract);
234         emit LogWithdrawal(_address, tokenBalanceOfContract);
235     }
236 
237     /**
238     * @dev Get the total number of addresses which received airDrop.
239     * @return Uint256 the total number of addresses which received airDrop.
240     */
241     function getTotalNumberOfAddressesReceivedAirDrop() public view returns (uint256) {
242         return arrayAirDropReceivers.length;
243     }
244 
245     /**
246     * @dev Get the remaining amount of token user can receive.
247     * @return Uint256 the amount of token that user can reveive.
248     */
249     function getRemainingToken() public view returns (uint256) {
250         return erc20.balanceOf(this);
251     }
252 
253     /**
254     * @dev Return the total amount of token user received.
255     * @return Uint256 total amount of token user received.
256     */
257     function getTotalAirDroppedAmount() public view returns (uint256) {
258         return airDropAmount.mul(arrayAirDropReceivers.length);
259     }
260 }