1 pragma solidity ^0.4.25;
2 
3 
4 /**
5 * @title ThorMutual
6 * @author Leo
7 * @dev Thor Mutual for TRX, WAVES, ADA, ERC20 and so on
8 */
9 
10 
11 contract Utils {
12 
13     uint constant DAILY_PERIOD = 1;
14     uint constant WEEKLY_PERIOD = 7;
15 
16     int constant PRICE_DECIMALS = 10 ** 8;
17 
18     int constant INT_MAX = 2 ** 255 - 1;
19 
20     uint constant UINT_MAX = 2 ** 256 - 1;
21 
22 }
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /**
35      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36      * account.
37      */
38     constructor () internal {
39         _owner = msg.sender;
40         emit OwnershipTransferred(address(0), _owner);
41     }
42 
43     /**
44      * @return the address of the owner.
45      */
46     function owner() public view returns (address) {
47         return _owner;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(isOwner());
55         _;
56     }
57 
58     /**
59      * @return true if `msg.sender` is the owner of the contract.
60      */
61     function isOwner() public view returns (bool) {
62         return msg.sender == _owner;
63     }
64 
65     // /**
66     //  * @dev Allows the current owner to relinquish control of the contract.
67     //  * @notice Renouncing to ownership will leave the contract without an owner.
68     //  * It will not be possible to call the functions with the `onlyOwner`
69     //  * modifier anymore.
70     //  */
71     // function renounceOwnership() public onlyOwner {
72     //     emit OwnershipTransferred(_owner, address(0));
73     //     _owner = address(0);
74     // }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers control of the contract to a newOwner.
86      * @param newOwner The address to transfer ownership to.
87      */
88     function _transferOwnership(address newOwner) internal {
89         require(newOwner != address(0));
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94 
95 
96 interface ThorMutualInterface {
97     function getCurrentPeriod() external view returns(uint);
98     function settle() external;
99 }
100 
101 
102 /**
103  * @title ThorMutualToken
104  * @dev Every ThorMutualToken contract is related with a specific token such as BTC/ETH/EOS/ERC20
105  * functions, participants send ETH to this contract to take part in the Thor Mutual activity.
106  */
107 contract ThorMutualToken is Ownable, Utils {
108     string public thorMutualToken;
109 
110     // total deposit for a specific period
111     mapping(uint => uint) amountOfDailyPeriod;
112 
113     // total deposit for a specific period
114     mapping(uint => uint) amountOfWeeklyPeriod;
115 
116     // participant's total deposit fund
117     mapping(address => uint) participantAmount;
118 
119     // participants
120     address[] participants;
121 
122     // deposit info
123     struct DepositInfo {
124         uint blockTimeStamp;
125         uint period;
126         string token;
127         uint amount;
128     }
129 
130     // participant's total deposit history
131     //mapping(address => DepositInfo[]) participantsHistory;
132     mapping(address => uint[]) participantsHistoryTime;
133     mapping(address => uint[]) participantsHistoryPeriod;
134     mapping(address => uint[]) participantsHistoryAmount;
135 
136     // participant's total deposit fund for a specific period
137     mapping(uint => mapping(address => uint)) participantAmountOfDailyPeriod;
138 
139     // participant's total deposit fund for a weekly period
140     mapping(uint => mapping(address => uint)) participantAmountOfWeeklyPeriod;
141 
142     // participants for the daily period
143     mapping(uint => address[]) participantsDaily;
144 
145     // participants for the weekly period
146     mapping(uint => address[]) participantsWeekly;
147 
148     ThorMutualInterface public thorMutualContract;
149 
150     constructor(string _thorMutualToken, ThorMutualInterface _thorMutual) public {
151         thorMutualToken = _thorMutualToken;
152         thorMutualContract = _thorMutual;
153     }
154 
155     event ThorDepositToken(address sender, uint256 amount);
156     function() external payable {
157         require(msg.value >= 0.001 ether);
158         
159         require(address(thorMutualContract) != address(0));
160         address(thorMutualContract).transfer(msg.value);
161 
162         //uint currentPeriod;
163         uint actualPeriod = 0;
164         uint actualPeriodWeek = 0;
165 
166         actualPeriod = thorMutualContract.getCurrentPeriod();
167 
168         actualPeriodWeek = actualPeriod / WEEKLY_PERIOD;
169 
170         if (participantAmount[msg.sender] == 0) {
171             participants.push(msg.sender);
172         }
173 
174         if (participantAmountOfDailyPeriod[actualPeriod][msg.sender] == 0) {
175             participantsDaily[actualPeriod].push(msg.sender);
176         }
177 
178         if (participantAmountOfWeeklyPeriod[actualPeriodWeek][msg.sender] == 0) {
179             participantsWeekly[actualPeriodWeek].push(msg.sender);
180         }
181 
182         participantAmountOfDailyPeriod[actualPeriod][msg.sender] += msg.value;
183 
184         participantAmount[msg.sender] += msg.value;
185         
186         participantAmountOfWeeklyPeriod[actualPeriodWeek][msg.sender] += msg.value;
187 
188         amountOfDailyPeriod[actualPeriod] += msg.value;
189 
190         amountOfWeeklyPeriod[actualPeriodWeek] += msg.value;
191 
192         // DepositInfo memory depositInfo = DepositInfo(block.timestamp, actualPeriod, thorMutualToken, msg.value);
193 
194         // participantsHistory[msg.sender].push(depositInfo);
195 
196         participantsHistoryTime[msg.sender].push(block.timestamp);
197         participantsHistoryPeriod[msg.sender].push(actualPeriod);
198         participantsHistoryAmount[msg.sender].push(msg.value);
199 
200         emit ThorDepositToken(msg.sender, msg.value);
201     }
202 
203     function setThorMutualContract(ThorMutualInterface _thorMutualContract) public onlyOwner{
204         require(address(_thorMutualContract) != address(0));
205         thorMutualContract = _thorMutualContract;
206     }
207 
208     function getThorMutualContract() public view returns(address) {
209         return thorMutualContract;
210     }
211 
212     function setThorMutualToken(string _thorMutualToken) public onlyOwner {
213         thorMutualToken = _thorMutualToken;
214     }
215 
216     function getDepositDailyAmountofPeriod(uint period) external view returns(uint) {
217         require(period >= 0);
218 
219         return amountOfDailyPeriod[period];
220     }
221 
222     function getDepositWeeklyAmountofPeriod(uint period) external view returns(uint) {
223         require(period >= 0);
224         uint periodWeekly = period / WEEKLY_PERIOD;
225         return amountOfWeeklyPeriod[periodWeekly];
226     }
227 
228     function getParticipantsDaily(uint period) external view returns(address[], uint) {
229         require(period >= 0);
230 
231         return (participantsDaily[period], participantsDaily[period].length);
232     }
233 
234     function getParticipantsWeekly(uint period) external view returns(address[], uint) {
235         require(period >= 0);
236 
237         uint periodWeekly = period / WEEKLY_PERIOD;
238         return (participantsWeekly[periodWeekly], participantsWeekly[period].length);
239     }
240 
241     function getParticipantAmountDailyPeriod(uint period, address participant) external view returns(uint) {
242         require(period >= 0);
243 
244         return participantAmountOfDailyPeriod[period][participant];
245     }
246 
247     function getParticipantAmountWeeklyPeriod(uint period, address participant) external view returns(uint) {
248         require(period >= 0);
249 
250         uint periodWeekly = period / WEEKLY_PERIOD;
251         return participantAmountOfWeeklyPeriod[periodWeekly][participant];
252     }
253 
254     //function getParticipantHistory(address participant) public view returns(DepositInfo[]) {
255     function getParticipantHistory(address participant) public view returns(uint[], uint[], uint[]) {
256 
257         return (participantsHistoryTime[participant], participantsHistoryPeriod[participant], participantsHistoryAmount[participant]);
258         //return participantsHistory[participant];
259     }
260 
261     function getSelfBalance() public view returns(uint) {
262         return address(this).balance;
263     }
264 
265     function withdraw(address receiver, uint amount) public onlyOwner {
266         require(receiver != address(0));
267 
268         receiver.transfer(amount);
269     }
270 
271 }