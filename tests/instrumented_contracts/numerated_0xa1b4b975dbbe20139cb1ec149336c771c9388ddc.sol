1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that revert on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, reverts on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (a == 0) {
91       return 0;
92     }
93 
94     uint256 c = a * b;
95     require(c / a == b);
96 
97     return c;
98   }
99 
100   /**
101   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
102   */
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     require(b > 0); // Solidity only automatically asserts when dividing by 0
105     uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108     return c;
109   }
110 
111   /**
112   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     require(b <= a);
116     uint256 c = a - b;
117 
118     return c;
119   }
120 
121   /**
122   * @dev Adds two numbers, reverts on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     require(c >= a);
127 
128     return c;
129   }
130 
131   /**
132   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
133   * reverts when dividing by zero.
134   */
135   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136     require(b != 0);
137     return a % b;
138   }
139 }
140 
141 /**
142  * @title Scouting module for tokenstars.com
143  * @dev scouting logic
144  */
145 contract Scouting is Ownable {
146     using SafeMath for uint32;
147     
148     struct TalentData {
149         uint8 eventName; // only 4,5,6,9,10,12
150         string data;
151     }
152     struct TalentInfo {
153         uint32 scoutId;
154         uint8 numData;
155         mapping (uint8 => TalentData) data;
156     }
157     mapping (uint32 => TalentInfo) talents;
158     mapping (uint8 => string) eventNames;
159     
160     event playerSubmitted(
161         uint32 indexed _talentId, 
162         uint32 indexed _scoutId, 
163         string _data
164     );
165     
166     event playerAssessed(
167         uint32 indexed _talentId, 
168         uint32 indexed _scoutId, 
169         string _data
170     );
171     
172     event playerRejected(
173         uint32 indexed _talentId, 
174         uint32 indexed _scoutId, 
175         string _data
176     );
177     
178     event playerVotepro(
179         uint32 indexed _talentId, 
180         uint32 indexed _scoutId, 
181         string _data
182     );
183     
184     event playerVotecontra(
185         uint32 indexed _talentId, 
186         uint32 indexed _scoutId, 
187         string _data
188     );
189     
190     
191     event playerSupportContracted(
192         uint32 indexed _talentId, 
193         uint32 indexed _scoutId, 
194         string _data
195     );
196     
197     constructor() public{
198         eventNames[4] = "player_submitted";
199         eventNames[5] = "player_assessed";
200         eventNames[6] = "player_rejected";
201         eventNames[9] = "player_votepro";
202         eventNames[10] = "player_votecontra";
203         eventNames[12] = "player_support_contracted";
204     }
205     
206     /**
207      * @dev Function add talent by owner contract
208      * @param talentId in tokenstars platform
209      * @param data information talent
210      */
211     function addTalent(uint32 talentId, uint32 scoutId, uint8 eventName, string data) public onlyOwner{
212         if(eventName == 4 || eventName == 5 || eventName == 6 || eventName == 9 || eventName == 10 || eventName == 12){
213             if(talents[talentId].scoutId == 0){
214                 talents[talentId] = TalentInfo(scoutId, 0);
215                 fillData(talentId, eventName, data);
216             }
217             else{
218                 fillData(talentId, eventName, data);
219             }    
220         }
221     }
222     
223     function fillData(uint32 talentId, uint8 eventName, string data) private onlyOwner{
224         TalentInfo storage ti = talents[talentId];
225         ti.data[ti.numData++] =  TalentData(eventName, data);
226         
227         // player_submitted
228         if(eventName == 4){
229             emit playerSubmitted(talentId, ti.scoutId, data);
230         }
231         else{
232            // player_assessed
233             if(eventName == 5){   
234                 emit playerAssessed(talentId, ti.scoutId, data);
235            }
236            else{
237               // player_rejected
238               if(eventName == 6){
239                 emit playerRejected(talentId, ti.scoutId, data);
240                }
241                else{
242                    // player_votepro
243                    if(eventName == 9){
244                     emit playerVotepro(talentId, ti.scoutId, data);
245                    }
246                    else{
247                       // player_votecontra
248                         if(eventName == 10){  
249                         emit playerVotecontra(talentId, ti.scoutId, data);
250                        }
251                        else{
252                           // player_support_contracted
253                           if(eventName == 12){  
254                             emit playerSupportContracted(talentId, ti.scoutId, data);
255                            }  
256                        } 
257                    } 
258                }  
259            } 
260         }
261     }
262    
263     
264     /**
265      * @dev Function view talent
266      * @param _talentId in tokenstars platform
267      * @return data
268      */
269     function viewTalent(uint32 _talentId) public constant returns (uint talentId, uint scoutId, uint8 countRecords, string eventName, string data) {
270         return (
271             _talentId, 
272             talents[_talentId].scoutId, 
273             talents[_talentId].numData, 
274             eventNames[talents[_talentId].data[talents[_talentId].numData-1].eventName], 
275             talents[_talentId].data[talents[_talentId].numData-1].data
276             );
277     }
278     
279     function viewTalentNum(uint32 talentId, uint8 numData) public constant returns (uint _talentId, uint scoutId, string eventName, string data) {
280         return (
281             talentId, 
282             talents[talentId].scoutId, 
283             eventNames[talents[talentId].data[numData].eventName], 
284             talents[talentId].data[numData].data
285             );
286     }
287 }