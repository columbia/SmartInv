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
158         airDropAmount = _airDropAmount;
159     }
160 
161     /**
162      * @dev Standard ERC223 function that will handle incoming token transfers.
163      *
164      * @param _from  Token sender address.
165      * @param _value Amount of tokens.
166      * @param _data  Transaction metadata.
167      */
168     function tokenFallback(address _from, uint _value, bytes _data) {}
169 
170     /**
171     * @dev Confirm that airDrop is available.
172     * @return A bool to confirm that airDrop is available.
173     */
174     function isValidAirDropForAll() public view returns (bool) {
175         bool validNotStop = !stop;
176         bool validAmount = getRemainingToken() >= airDropAmount;
177         bool validPeriod = now >= startTime && now <= endTime;
178         return validNotStop && validAmount && validPeriod;
179     }
180 
181     /**
182     * @dev Confirm that airDrop is available for msg.sender.
183     * @return A bool to confirm that airDrop is available for msg.sender.
184     */
185     function isValidAirDropForIndividual() public view returns (bool) {
186         bool validNotStop = !stop;
187         bool validAmount = getRemainingToken() >= airDropAmount;
188         bool validPeriod = now >= startTime && now <= endTime;
189         bool validReceiveAirDropForIndividual = !invalidAirDrop[msg.sender];
190         return validNotStop && validAmount && validPeriod && validReceiveAirDropForIndividual;
191     }
192 
193     /**
194     * @dev Do the airDrop to msg.sender
195     */
196     function receiveAirDrop() public {
197         require(isValidAirDropForIndividual());
198 
199         // set invalidAirDrop of msg.sender to true
200         invalidAirDrop[msg.sender] = true;
201 
202         // set msg.sender to the array of the airDropReceiver
203         arrayAirDropReceivers.push(msg.sender);
204 
205         // execute transferFrom
206         erc20.transfer(msg.sender, airDropAmount);
207 
208         emit LogAirDrop(msg.sender, airDropAmount);
209     }
210 
211     /**
212     * @dev Change the state of stop flag
213     */
214     function toggle() public onlyOwner {
215         stop = !stop;
216 
217         if (stop) {
218             emit LogStop();
219         } else {
220             emit LogStart();
221         }
222     }
223 
224     /**
225     * @dev Withdraw the amount of token that is remaining in this contract.
226     * @param _address The address of EOA that can receive token from this contract.
227     */
228     function withdraw(address _address) public onlyOwner {
229         require(stop || now > endTime);
230         require(_address != address(0));
231         uint tokenBalanceOfContract = getRemainingToken();
232         erc20.transfer(_address, tokenBalanceOfContract);
233         emit LogWithdrawal(_address, tokenBalanceOfContract);
234     }
235 
236     /**
237     * @dev Get the total number of addresses which received airDrop.
238     * @return Uint256 the total number of addresses which received airDrop.
239     */
240     function getTotalNumberOfAddressesReceivedAirDrop() public view returns (uint256) {
241         return arrayAirDropReceivers.length;
242     }
243 
244     /**
245     * @dev Get the remaining amount of token user can receive.
246     * @return Uint256 the amount of token that user can reveive.
247     */
248     function getRemainingToken() public view returns (uint256) {
249         return erc20.balanceOf(this);
250     }
251 
252     /**
253     * @dev Return the total amount of token user received.
254     * @return Uint256 total amount of token user received.
255     */
256     function getTotalAirDroppedAmount() public view returns (uint256) {
257         return airDropAmount.mul(arrayAirDropReceivers.length);
258     }
259 }