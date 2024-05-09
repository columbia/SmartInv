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
66 8 888888888o  `8.`8888.      ,8' 8 888888888o.    8 8888          ,8.       ,8.           8 8888 8 888888888o.                       
67 8 8888    `88. `8.`8888.    ,8'  8 8888    `88.   8 8888         ,888.     ,888.          8 8888 8 8888    `^888.                    
68 8 8888     `88  `8.`8888.  ,8'   8 8888     `88   8 8888        .`8888.   .`8888.         8 8888 8 8888        `88.                  
69 8 8888     ,88   `8.`8888.,8'    8 8888     ,88   8 8888       ,8.`8888. ,8.`8888.        8 8888 8 8888         `88                  
70 8 8888.   ,88'    `8.`88888'     8 8888.   ,88'   8 8888      ,8'8.`8888,8^8.`8888.       8 8888 8 8888          88                  
71 8 888888888P'      `8. 8888      8 888888888P'    8 8888     ,8' `8.`8888' `8.`8888.      8 8888 8 8888          88                  
72 8 8888              `8 8888      8 8888`8b        8 8888    ,8'   `8.`88'   `8.`8888.     8 8888 8 8888         ,88                  
73 8 8888               8 8888      8 8888 `8b.      8 8888   ,8'     `8.`'     `8.`8888.    8 8888 8 8888        ,88'                  
74 8 8888               8 8888      8 8888   `8b.    8 8888  ,8'       `8        `8.`8888.   8 8888 8 8888    ,o88P'                    
75 8 8888               8 8888      8 8888     `88.  8 8888 ,8'         `         `8.`8888.  8 8888 8 888888888P'         
76 
77 By EtherG 2018.8.21
78 */
79 
80 contract Pyramid is Ownable,PyramidEvents{
81     using SafeMath for uint;
82 
83     address private wallet1;
84     address private wallet2;
85 
86     uint public startAtBlockNumber;
87     uint public curBubbleNumber= 1000;
88     bool public gameOpened=false;
89     uint public totalPlayers=0;
90     
91     mapping(address=>uint) playerRefCode;    //address=> refCode;
92     mapping(uint=>address) playerRefxAddr;    //refCode=>address;
93     
94     mapping(uint=>uint) parentRefCode;    //player refCode=> parent refCode;
95 
96     /* refCode=>bubbles numOfBubbles */
97     mapping(uint=>uint) numOfBubblesL1;
98     mapping(uint=>uint) numOfBubblesL2;
99     mapping(uint=>uint) numOfBubblesL3;
100     
101     
102     mapping(address=>uint) playerRewards;
103     mapping(uint=>uint) referees;
104     
105     uint gameRound=1;
106     mapping(uint=>address) roundxAddr;
107     mapping(uint=>uint) roundxRefCode;
108     
109 
110     constructor(address _addr1,address _addr2)public {
111         wallet1=_addr1;
112         wallet2=_addr2;
113         
114         startAtBlockNumber = block.number+633;
115     }
116     
117     function buyandearn(uint refCode) isHuman payable public returns(uint){
118         require(block.number>=startAtBlockNumber,"Not Start");
119         require(playerRefxAddr[refCode]!= 0x0 || (refCode==0 && totalPlayers==0));
120         require(msg.value >= 0.1 ether,"Minima amoun:0.1 ether");
121         
122         bool _firstJoin=false;
123         uint selfRefCode;
124         
125         /* 首次加入 */
126         if(playerRefCode[msg.sender]==0){
127             selfRefCode=curBubbleNumber+1;
128             playerRefCode[msg.sender]=selfRefCode;
129             
130             parentRefCode[selfRefCode]=refCode;
131             
132             numOfBubblesL1[selfRefCode]=6;
133             numOfBubblesL2[selfRefCode]=6*6;
134             numOfBubblesL3[selfRefCode]=6*6*6;
135             _firstJoin=true;
136         }else{
137             //不能异动推荐人
138             selfRefCode=playerRefCode[msg.sender];
139             refCode=parentRefCode[selfRefCode];
140             
141             numOfBubblesL1[playerRefCode[msg.sender]]+=6;
142             numOfBubblesL2[playerRefCode[msg.sender]]+=36;
143             numOfBubblesL3[playerRefCode[msg.sender]]+=216;    
144         }
145         
146         /* 计算可以用推荐数*/
147         
148         uint up1RefCode=0;
149         uint up2RefCode=0;
150         uint up3RefCode=0;
151         
152         if(totalPlayers>0 && numOfBubblesL1[refCode]>0 ){
153             //if not first player
154             up1RefCode=refCode;
155             numOfBubblesL1[up1RefCode]-=1;
156             
157             if(_firstJoin) referees[up1RefCode]+=1;
158         }
159         
160         if(parentRefCode[up1RefCode]!=0 && numOfBubblesL2[refCode]>0){
161             //up 2 layer
162             up2RefCode=parentRefCode[up1RefCode];
163             numOfBubblesL2[up2RefCode]-=1;
164             
165             if(_firstJoin) referees[up2RefCode]+=1;
166         }
167         
168         if(parentRefCode[up2RefCode]!=0 && numOfBubblesL3[refCode]>0){
169             //up 2 layer
170             up3RefCode=parentRefCode[up2RefCode];
171             numOfBubblesL3[up3RefCode]-=1;
172             
173             if(_firstJoin) referees[up3RefCode]+=1;
174         }
175 
176         playerRefxAddr[playerRefCode[msg.sender]]=msg.sender;
177         
178         roundxAddr[gameRound]=msg.sender;
179         roundxRefCode[gameRound]=selfRefCode;
180         
181         curBubbleNumber=selfRefCode;
182         gameRound+=1;
183         
184          if(_firstJoin) totalPlayers+=1;
185         
186         emit buyEvt(msg.sender,selfRefCode,msg.value);
187         
188         /* =========================================
189        distribute
190        =========================================*/
191         distribute(up1RefCode,up2RefCode,up3RefCode);
192         
193     }
194     
195 /*
196 
197     8 8888      88 8 8888   8888888 8888888888  8 8888          ,8.       ,8.                   .8.    8888888 8888888888 8 8888888888   
198 8 8888      88 8 8888         8 8888        8 8888         ,888.     ,888.                 .888.         8 8888       8 8888         
199 8 8888      88 8 8888         8 8888        8 8888        .`8888.   .`8888.               :88888.        8 8888       8 8888         
200 8 8888      88 8 8888         8 8888        8 8888       ,8.`8888. ,8.`8888.             . `88888.       8 8888       8 8888         
201 8 8888      88 8 8888         8 8888        8 8888      ,8'8.`8888,8^8.`8888.           .8. `88888.      8 8888       8 888888888888 
202 8 8888      88 8 8888         8 8888        8 8888     ,8' `8.`8888' `8.`8888.         .8`8. `88888.     8 8888       8 8888         
203 8 8888      88 8 8888         8 8888        8 8888    ,8'   `8.`88'   `8.`8888.       .8' `8. `88888.    8 8888       8 8888         
204 ` 8888     ,8P 8 8888         8 8888        8 8888   ,8'     `8.`'     `8.`8888.     .8'   `8. `88888.   8 8888       8 8888         
205   8888   ,d8P  8 8888         8 8888        8 8888  ,8'       `8        `8.`8888.   .888888888. `88888.  8 8888       8 8888         
206    `Y88888P'   8 888888888888 8 8888        8 8888 ,8'         `         `8.`8888. .8'       `8. `88888. 8 8888       8 888888888888
207 
208 */
209     
210     function distribute(uint up1RefCode,uint up2RefCode,uint up3RefCode) internal{
211         
212         uint v1;
213         uint v2;
214         uint v3;
215         uint w1;
216         uint w2;
217         
218         v1 = msg.value.mul(40 ether).div(100 ether);
219         v2 = msg.value.mul(30 ether).div(100 ether);
220         v3 = msg.value.mul(20 ether).div(100 ether);
221         w1 = msg.value.mul(7 ether).div(100 ether);
222         w2 = msg.value.mul(3 ether).div(100 ether);
223         
224         if(up1RefCode!=0){
225             playerRefxAddr[up1RefCode].transfer(v1);
226             playerRewards[playerRefxAddr[up1RefCode]]=playerRewards[playerRefxAddr[up1RefCode]].add(v1);
227             
228             emit rewardEvt(playerRefxAddr[up1RefCode],up1RefCode,v1);
229         }
230         if(up2RefCode!=0){
231             playerRefxAddr[up2RefCode].transfer(v2);
232             playerRewards[playerRefxAddr[up2RefCode]]=playerRewards[playerRefxAddr[up2RefCode]].add(v2);
233             
234             emit rewardEvt(playerRefxAddr[up2RefCode],up2RefCode,v2);
235         }
236         if(up3RefCode!=0){
237             playerRefxAddr[up3RefCode].transfer(v3);
238             playerRewards[playerRefxAddr[up3RefCode]]=playerRewards[playerRefxAddr[up3RefCode]].add(v3);
239             
240             emit rewardEvt(playerRefxAddr[up3RefCode],up3RefCode,v3);
241         }
242 
243         wallet1.transfer(w1);
244         wallet2.transfer(w2);
245     }
246     
247     function witrhdraw(uint _val) public onlyOwner{
248         owner.transfer(_val);
249     }
250     
251     function myData() public view returns(uint,uint,uint,uint){
252         /*return rewards,referees,refCode,totalPlayers  */
253         
254         uint refCode=playerRefCode[msg.sender];
255         return (playerRewards[msg.sender],referees[refCode],refCode,totalPlayers);
256     }
257 
258     function availableRef() public view returns(uint,uint,uint){
259         return (numOfBubblesL1[playerRefCode[msg.sender]],numOfBubblesL2[playerRefCode[msg.sender]],numOfBubblesL3[playerRefCode[msg.sender]]);
260     }
261 }
262 
263 
264 
265 /*
266 =====================================================
267 Library
268 =====================================================
269 */
270 
271 
272 library SafeMath {
273   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274     uint256 c = a * b;
275     assert(a == 0 || c / a == b);
276     return c;
277   }
278 
279   function div(uint256 a, uint256 b) internal pure returns (uint256) {
280     // assert(b > 0); // Solidity automatically throws when dividing by 0
281     uint256 c = a / b;
282     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283     return c;
284   }
285 
286   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287     assert(b <= a);
288     return a - b;
289   }
290 
291   function add(uint256 a, uint256 b) internal pure returns (uint256) {
292     uint256 c = a + b;
293     assert(c >= a);
294     return c;
295   }
296 }