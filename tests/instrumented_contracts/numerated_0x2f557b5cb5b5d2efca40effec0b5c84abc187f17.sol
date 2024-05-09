1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63     * account.
64     */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70     * @dev Throws if called by any account other than the owner.
71     */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78     * @dev Allows the current owner to transfer control of the contract to a newOwner.
79     * @param newOwner The address to transfer ownership to.
80     */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20BasicInterface {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     uint8 public decimals;
102 }
103 
104 
105 /**
106  * @title AirDropContract
107  * Simply do the airdrop.
108  */
109 contract AirDrop is Ownable {
110     using SafeMath for uint256;
111 
112     // the amount that owner wants to send each time
113     uint public airDropAmount;
114 
115     // the mapping to judge whether each address has already received airDropped
116     mapping ( address => bool ) public invalidAirDrop;
117 
118     // the array of addresses which received airDrop
119     address[] public arrayAirDropReceivers;
120 
121     // flag to stop airdrop
122     bool public stop = false;
123 
124     ERC20BasicInterface public erc20;
125 
126     uint256 public startTime;
127     uint256 public endTime;
128 
129     // event
130     event LogAirDrop(address indexed receiver, uint amount);
131     event LogStop();
132     event LogStart();
133     event LogWithdrawal(address indexed receiver, uint amount);
134 
135     /**
136     * @dev Constructor to set _airDropAmount and _tokenAddresss.
137     * @param _airDropAmount The amount of token that is sent for doing airDrop.
138     * @param _tokenAddress The address of token.
139     */
140     constructor(uint256 _startTime, uint256 _endTime, uint _airDropAmount, address _tokenAddress) public {
141         require(_startTime >= now &&
142             _endTime >= _startTime &&
143             _airDropAmount > 0 &&
144             _tokenAddress != address(0)
145         );
146         startTime = _startTime;
147         endTime = _endTime;
148         erc20 = ERC20BasicInterface(_tokenAddress);
149         uint tokenDecimals = erc20.decimals();
150         airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);
151     }
152 
153     /**
154     * @dev Confirm that airDrop is available.
155     * @return A bool to confirm that airDrop is available.
156     */
157     function isValidAirDropForAll() public view returns (bool) {
158         bool validNotStop = !stop;
159         bool validAmount = getRemainingToken() >= airDropAmount;
160         bool validPeriod = now >= startTime && now <= endTime;
161         return validNotStop && validAmount && validPeriod;
162     }
163 
164     /**
165     * @dev Confirm that airDrop is available for msg.sender.
166     * @return A bool to confirm that airDrop is available for msg.sender.
167     */
168     function isValidAirDropForIndividual() public view returns (bool) {
169         bool validNotStop = !stop;
170         bool validAmount = getRemainingToken() >= airDropAmount;
171         bool validPeriod = now >= startTime && now <= endTime;
172         bool validReceiveAirDropForIndividual = !invalidAirDrop[msg.sender];
173         return validNotStop && validAmount && validPeriod && validReceiveAirDropForIndividual;
174     }
175 
176     /**
177     * @dev Do the airDrop to msg.sender
178     */
179     function receiveAirDrop() public {
180         require(isValidAirDropForIndividual());
181 
182         // set invalidAirDrop of msg.sender to true
183         invalidAirDrop[msg.sender] = true;
184 
185         // set msg.sender to the array of the airDropReceiver
186         arrayAirDropReceivers.push(msg.sender);
187 
188         // execute transferFrom
189         require(erc20.transfer(msg.sender, airDropAmount));
190 
191         emit LogAirDrop(msg.sender, airDropAmount);
192     }
193 
194     /**
195     * @dev Change the state of stop flag
196     */
197     function toggle() public onlyOwner {
198         stop = !stop;
199 
200         if (stop) {
201             emit LogStop();
202         } else {
203             emit LogStart();
204         }
205     }
206 
207     /**
208     * @dev Withdraw the amount of token that is remaining in this contract.
209     * @param _address The address of EOA that can receive token from this contract.
210     */
211     function withdraw(address _address) public onlyOwner {
212         require(stop || now > endTime);
213         require(_address != address(0));
214         uint tokenBalanceOfContract = getRemainingToken();
215         require(erc20.transfer(_address, tokenBalanceOfContract));
216         emit LogWithdrawal(_address, tokenBalanceOfContract);
217     }
218 
219     /**
220     * @dev Get the total number of addresses which received airDrop.
221     * @return Uint256 the total number of addresses which received airDrop.
222     */
223     function getTotalNumberOfAddressesReceivedAirDrop() public view returns (uint256) {
224         return arrayAirDropReceivers.length;
225     }
226 
227     /**
228     * @dev Get the remaining amount of token user can receive.
229     * @return Uint256 the amount of token that user can reveive.
230     */
231     function getRemainingToken() public view returns (uint256) {
232         return erc20.balanceOf(this);
233     }
234 
235     /**
236     * @dev Return the total amount of token user received.
237     * @return Uint256 total amount of token user received.
238     */
239     function getTotalAirDroppedAmount() public view returns (uint256) {
240         return airDropAmount.mul(arrayAirDropReceivers.length);
241     }
242 }