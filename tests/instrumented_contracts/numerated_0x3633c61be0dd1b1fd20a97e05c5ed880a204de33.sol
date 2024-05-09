1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6   /**
7    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8    * account.
9    */
10   constructor() public {
11     owner = msg.sender;
12   }
13 
14 
15   /**
16    * @dev Throws if called by any account other than the owner.
17    */
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23 
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) onlyOwner public {
29     require(newOwner != address(0));
30     //emit OwnershipTransferred(owner, newOwner);
31     owner = newOwner;
32   }
33   
34     /**
35     * @dev prevents contracts from interacting with others
36     */
37     modifier isHuman() {
38         address _addr = msg.sender;
39         uint256 _codeLength;
40     
41         assembly {_codeLength := extcodesize(_addr)}
42         require(_codeLength == 0, "sorry humans only");
43         _;
44     }
45 
46 
47 }
48 
49 contract PyramidEvents{
50 
51     event buyEvt(
52         address indexed addr,
53         uint refCode,
54         uint amount
55         );
56     
57     event rewardEvt(
58         address indexed addr,
59         uint refCode,
60         uint rewardAmount
61         );
62 }
63 
64 /*
65 
66 Discord: https://discord.gg/9gBhKDc
67  ____    __    __                     ______                               
68 /\  _`\ /\ \__/\ \                   /\__  _\                              
69 \ \ \L\_\ \ ,_\ \ \___      __   _ __\/_/\ \/    __     __      ___ ___    
70  \ \  _\L\ \ \/\ \  _ `\  /'__`\/\`'__\ \ \ \  /'__`\ /'__`\  /' __` __`\  
71   \ \ \L\ \ \ \_\ \ \ \ \/\  __/\ \ \/   \ \ \/\  __//\ \L\.\_/\ \/\ \/\ \ 
72    \ \____/\ \__\\ \_\ \_\ \____\\ \_\    \ \_\ \____\ \__/.\_\ \_\ \_\ \_\
73     \/___/  \/__/ \/_/\/_/\/____/ \/_/     \/_/\/____/\/__/\/_/\/_/\/_/\/_/
74                                                                            
75                                                                            
76 */
77 
78 contract EtherTeam is Ownable,PyramidEvents{
79     using SafeMath for uint;
80 
81     address private wallet1;
82     address private wallet2;
83 
84     uint public startAtBlockNumber;
85     uint public curBubbleNumber= 1000;
86     bool public gameOpened=false;
87     uint public totalPlayers=0;
88     
89     mapping(address=>uint) playerRefCode;    //address=> refCode;
90     mapping(uint=>address) playerRefxAddr;    //refCode=>address;
91     
92     mapping(uint=>uint) parentRefCode;    //player refCode=> parent refCode;
93 
94     /* refCode=>bubbles numOfBubbles */
95     mapping(uint=>uint) numOfBubblesL1;
96     mapping(uint=>uint) numOfBubblesL2;
97     mapping(uint=>uint) numOfBubblesL3;
98     
99     
100     mapping(address=>uint) playerRewards;
101     mapping(uint=>uint) referees;
102     
103     uint gameRound=1;
104     mapping(uint=>address) roundxAddr;
105     mapping(uint=>uint) roundxRefCode;
106     
107 
108     constructor(address _addr1,address _addr2)public {
109         wallet1=_addr1;
110         wallet2=_addr2;
111         
112         startAtBlockNumber = block.number+633;
113     }
114     
115     function buyandearn(uint refCode) isHuman payable public returns(uint){
116         require(block.number>=startAtBlockNumber,"Not Start");
117         require(playerRefxAddr[refCode]!= 0x0 || (refCode==0 && totalPlayers==0));
118         require(msg.value >= 0.1 ether,"Minima amoun:0.1 ether");
119         
120         bool _firstJoin=false;
121         uint selfRefCode;
122         
123         /* Joining the game */
124         if(playerRefCode[msg.sender]==0){
125             selfRefCode=curBubbleNumber+1;
126             playerRefCode[msg.sender]=selfRefCode;
127             
128             parentRefCode[selfRefCode]=refCode;
129             
130             numOfBubblesL1[selfRefCode]=6;
131             numOfBubblesL2[selfRefCode]=6*6;
132             numOfBubblesL3[selfRefCode]=6*6*6;
133             _firstJoin=true;
134         }else{
135             //Referral Stays the same
136             selfRefCode=playerRefCode[msg.sender];
137             refCode=parentRefCode[selfRefCode];
138             
139             numOfBubblesL1[playerRefCode[msg.sender]]+=6;
140             numOfBubblesL2[playerRefCode[msg.sender]]+=36;
141             numOfBubblesL3[playerRefCode[msg.sender]]+=216;    
142         }
143         
144         
145         uint up1RefCode=0;
146         uint up2RefCode=0;
147         uint up3RefCode=0;
148         
149         if(totalPlayers>0 && numOfBubblesL1[refCode]>0 ){
150             //if not first player
151             up1RefCode=refCode;
152             numOfBubblesL1[up1RefCode]-=1;
153             
154             if(_firstJoin) referees[up1RefCode]+=1;
155         }
156         
157         if(parentRefCode[up1RefCode]!=0 && numOfBubblesL2[refCode]>0){
158             //up 2 layer
159             up2RefCode=parentRefCode[up1RefCode];
160             numOfBubblesL2[up2RefCode]-=1;
161             
162             if(_firstJoin) referees[up2RefCode]+=1;
163         }
164         
165         if(parentRefCode[up2RefCode]!=0 && numOfBubblesL3[refCode]>0){
166             //up 2 layer
167             up3RefCode=parentRefCode[up2RefCode];
168             numOfBubblesL3[up3RefCode]-=1;
169             
170             if(_firstJoin) referees[up3RefCode]+=1;
171         }
172 
173         playerRefxAddr[playerRefCode[msg.sender]]=msg.sender;
174         
175         roundxAddr[gameRound]=msg.sender;
176         roundxRefCode[gameRound]=selfRefCode;
177         
178         curBubbleNumber=selfRefCode;
179         gameRound+=1;
180         
181          if(_firstJoin) totalPlayers+=1;
182         
183         emit buyEvt(msg.sender,selfRefCode,msg.value);
184         
185         /* =========================================
186        distribute
187        =========================================*/
188         distribute(up1RefCode,up2RefCode,up3RefCode);
189         
190     }
191     
192 /*
193 
194 
195 Discord: https://discord.gg/9gBhKDc
196  ____    __    __                     ______                               
197 /\  _`\ /\ \__/\ \                   /\__  _\                              
198 \ \ \L\_\ \ ,_\ \ \___      __   _ __\/_/\ \/    __     __      ___ ___    
199  \ \  _\L\ \ \/\ \  _ `\  /'__`\/\`'__\ \ \ \  /'__`\ /'__`\  /' __` __`\  
200   \ \ \L\ \ \ \_\ \ \ \ \/\  __/\ \ \/   \ \ \/\  __//\ \L\.\_/\ \/\ \/\ \ 
201    \ \____/\ \__\\ \_\ \_\ \____\\ \_\    \ \_\ \____\ \__/.\_\ \_\ \_\ \_\
202     \/___/  \/__/ \/_/\/_/\/____/ \/_/     \/_/\/____/\/__/\/_/\/_/\/_/\/_/
203                                                                            
204      
205 */
206     
207     function distribute(uint up1RefCode,uint up2RefCode,uint up3RefCode) internal{
208         
209         uint v1;
210         uint v2;
211         uint v3;
212         uint w1;
213         uint w2;
214         
215         v1 = msg.value.mul(40 ether).div(100 ether);
216         v2 = msg.value.mul(30 ether).div(100 ether);
217         v3 = msg.value.mul(20 ether).div(100 ether);
218         w1 = msg.value.mul(7 ether).div(100 ether);
219         w2 = msg.value.mul(3 ether).div(100 ether);
220         
221         if(up1RefCode!=0){
222             playerRefxAddr[up1RefCode].transfer(v1);
223             playerRewards[playerRefxAddr[up1RefCode]]=playerRewards[playerRefxAddr[up1RefCode]].add(v1);
224             
225             emit rewardEvt(playerRefxAddr[up1RefCode],up1RefCode,v1);
226         }
227         if(up2RefCode!=0){
228             playerRefxAddr[up2RefCode].transfer(v2);
229             playerRewards[playerRefxAddr[up2RefCode]]=playerRewards[playerRefxAddr[up2RefCode]].add(v2);
230             
231             emit rewardEvt(playerRefxAddr[up2RefCode],up2RefCode,v2);
232         }
233         if(up3RefCode!=0){
234             playerRefxAddr[up3RefCode].transfer(v3);
235             playerRewards[playerRefxAddr[up3RefCode]]=playerRewards[playerRefxAddr[up3RefCode]].add(v3);
236             
237             emit rewardEvt(playerRefxAddr[up3RefCode],up3RefCode,v3);
238         }
239 
240         wallet1.transfer(w1);
241         wallet2.transfer(w2);
242     }
243     
244     function witrhdraw(uint _val) public onlyOwner{
245         owner.transfer(_val);
246     }
247     
248     function myData() public view returns(uint,uint,uint,uint){
249         /*return rewards,referees,refCode,totalPlayers  */
250         
251         uint refCode=playerRefCode[msg.sender];
252         return (playerRewards[msg.sender],referees[refCode],refCode,totalPlayers);
253     }
254 
255     function availableRef() public view returns(uint,uint,uint){
256         return (numOfBubblesL1[playerRefCode[msg.sender]],numOfBubblesL2[playerRefCode[msg.sender]],numOfBubblesL3[playerRefCode[msg.sender]]);
257     }
258 }
259 
260 
261 
262 /*
263 =====================================================
264 Library
265 =====================================================
266 */
267 
268 
269 library SafeMath {
270   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271     uint256 c = a * b;
272     assert(a == 0 || c / a == b);
273     return c;
274   }
275 
276   function div(uint256 a, uint256 b) internal pure returns (uint256) {
277     // assert(b > 0); // Solidity automatically throws when dividing by 0
278     uint256 c = a / b;
279     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
280     return c;
281   }
282 
283   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284     assert(b <= a);
285     return a - b;
286   }
287 
288   function add(uint256 a, uint256 b) internal pure returns (uint256) {
289     uint256 c = a + b;
290     assert(c >= a);
291     return c;
292   }
293 }