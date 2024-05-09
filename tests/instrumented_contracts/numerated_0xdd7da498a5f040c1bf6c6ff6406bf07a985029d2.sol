1 pragma solidity 0.5.14;
2 
3 
4 contract Ballast{
5 
6     struct UserStruct {
7         bool isExist;
8         uint id;
9         uint referrerID;
10         uint totalEarning;
11         address[] referral;
12         mapping(uint => uint) levelExpired;
13     }
14     
15     struct AutoPoolStruct{
16         bool isExist;
17         bool poolStatus;
18         uint seqID;
19         uint poolReferrerID;
20         uint totalEarning;
21         address[] poolReferral;
22     }
23     
24     address payable public admin;
25     uint public entryFee = 0.08 ether;
26     uint public adminFee = 0.02 ether;
27     uint public Auto_Pool_Limit = 3;
28     
29     mapping(address => UserStruct) public users;
30     mapping(address => mapping(uint => mapping(uint =>AutoPoolStruct))) public usersPool;
31     mapping(uint => uint) public Auto_Pool_SeqID;
32     mapping(uint => uint) public Auto_Pool;
33     mapping(uint => uint) public Auto_Pool_Upline;
34     mapping(uint => uint) public Auto_Pool_System;
35     mapping(uint => mapping (uint => address)) public userPoolList;
36     mapping(uint => address) public userList;
37     mapping(address => mapping (uint => bool)) public userPoolStatus;
38     mapping(address => mapping(uint => uint[])) public userPoolSeqID;
39     
40     uint public currUserID = 0;
41     bool public lockStatus;
42 
43     event UserEntryEvent(
44         address indexed _user,
45         address indexed _referrer,
46         uint _time
47     );
48     event AutoPoolEvent(
49         uint indexed _referrerID,
50         address indexed _user,
51         uint indexed _poolID,
52         uint _time
53     );
54     event AutoPoolUplineEvent(
55        uint indexed _referrerID,
56        uint indexed _poolID,
57        address indexed _user,
58        address[10] _uplines
59     );
60     
61     constructor() public {
62         admin = msg.sender;
63 
64         Auto_Pool_SeqID[1] = 0;
65         Auto_Pool_SeqID[2] = 0;
66         Auto_Pool_SeqID[3] = 0;
67         
68         Auto_Pool[1] = 0.25 ether;
69         Auto_Pool[2] = 0.50 ether;
70         Auto_Pool[3] = 1 ether;
71         
72         Auto_Pool_Upline[1] = 0.02 ether;
73         Auto_Pool_Upline[2] = 0.04 ether;
74         Auto_Pool_Upline[3] = 0.08 ether;
75         
76         Auto_Pool_System[1] = 0.05 ether;
77         Auto_Pool_System[2] = 0.10 ether;
78         Auto_Pool_System[3] = 0.20 ether;
79         
80         UserStruct memory userStruct;
81         currUserID++;
82         Auto_Pool_SeqID[1]++;
83         Auto_Pool_SeqID[2]++;
84         Auto_Pool_SeqID[3]++;
85 
86         userStruct = UserStruct({
87             isExist: true,
88             id: currUserID,
89             referrerID: 0,
90             totalEarning:0,
91             referral: new address[](0)
92         });
93         users[admin] = userStruct;    
94         userList[currUserID] = admin;
95         
96         AutoPoolStruct memory autoPoolStruct;
97         autoPoolStruct = AutoPoolStruct({
98             isExist: true,
99             poolStatus: true,
100             seqID: Auto_Pool_SeqID[1],
101             totalEarning:0,
102             poolReferrerID: 0,
103             poolReferral: new address[](0)
104         });
105         usersPool[admin][1][1] = autoPoolStruct;
106         usersPool[admin][2][1] = autoPoolStruct;
107         usersPool[admin][3][1] = autoPoolStruct;
108         userPoolList[1][Auto_Pool_SeqID[1]] = admin;
109         userPoolList[2][Auto_Pool_SeqID[2]] = admin;
110         userPoolList[3][Auto_Pool_SeqID[3]] = admin;
111         userPoolSeqID[admin][1].push(Auto_Pool_SeqID[1]);
112         userPoolSeqID[admin][2].push(Auto_Pool_SeqID[2]);
113         userPoolSeqID[admin][3].push(Auto_Pool_SeqID[3]);
114     }
115     
116     function() external {
117         revert("No contract call");
118     }
119     
120     function userEntry(
121         uint _referrerID
122     ) 
123         payable
124         public 
125     {
126         
127         require(
128             lockStatus == false, 
129             "Contract Locked"
130         );
131         require(
132             !users[msg.sender].isExist,
133             'User exist'
134         );
135         require(
136             _referrerID > 0 && _referrerID <= currUserID,
137             'Incorrect referrer Id'
138         );
139         require(
140             msg.value == entryFee,
141             "insufficient value"
142         );
143         
144         UserStruct memory userStruct;
145         currUserID++;
146 
147         userStruct = UserStruct({
148             isExist: true,
149             id: currUserID,
150             totalEarning:0,
151             referrerID: _referrerID,
152             referral: new address[](0)
153         });
154 
155         users[msg.sender] = userStruct;
156         userList[currUserID] = msg.sender;
157 
158         users[userList[_referrerID]].referral.push(msg.sender);
159         uint referrerAmount = entryFee-adminFee;
160         address(uint160(userList[_referrerID])).transfer(referrerAmount); 
161         admin.transfer(adminFee);
162         users[userList[_referrerID]].totalEarning += referrerAmount;
163         users[admin].totalEarning += adminFee;   
164         emit UserEntryEvent(
165             msg.sender,
166             userList[_referrerID],
167             now
168         );
169     }
170     
171     function AutoPool(
172         uint _poolID,
173         uint _poolRefSeqID
174     ) 
175         payable
176         public 
177     {   
178         require(lockStatus == false, "Contract Locked");
179         require(users[msg.sender].isExist,'User not exist');
180         require(!userPoolStatus[msg.sender][_poolID],'User exist in pool');
181         // require(usersPool[userList[_poolRefSeqID]][_poolID].poolStatus,'pool referrer is not exist');
182         require(_poolID <= 3 && _poolID > 0,"_poolID must be greather than zero and less than 4");
183         require(
184             _poolRefSeqID > 0 && _poolRefSeqID <= Auto_Pool_SeqID[_poolID],
185             'Incorrect pool referrer Id'
186         );
187         require(
188             usersPool[userPoolList[_poolID][_poolRefSeqID]][_poolID][_poolRefSeqID].poolReferral.length < Auto_Pool_Limit,
189             "reached poolReferral limit"
190         );
191         require(msg.value == Auto_Pool[_poolID],"Incorrect value");
192         
193         Auto_Pool_SeqID[_poolID]++;
194         
195         AutoPoolStruct memory autoPoolStruct;
196         autoPoolStruct = AutoPoolStruct({
197             isExist: true,
198             poolStatus: false,
199             seqID: Auto_Pool_SeqID[_poolID],
200             totalEarning:0,
201             poolReferrerID: _poolRefSeqID,
202             poolReferral: new address[](0)
203         });
204         
205         usersPool[msg.sender][_poolID][Auto_Pool_SeqID[_poolID]] = autoPoolStruct;
206         
207         userPoolList[_poolID][Auto_Pool_SeqID[_poolID]] = msg.sender;
208         userPoolSeqID[msg.sender][_poolID].push(Auto_Pool_SeqID[_poolID]);
209         userPoolStatus[msg.sender][_poolID] = true;
210         
211         usersPool[userPoolList[_poolID][_poolRefSeqID]][_poolID][_poolRefSeqID].poolReferral.push(msg.sender);
212         
213         if(usersPool[userPoolList[_poolID][_poolRefSeqID]][_poolID][_poolRefSeqID].poolReferral.length == 1){
214             address(uint160(userPoolList[_poolID][_poolRefSeqID])).transfer(Auto_Pool[_poolID]); 
215             usersPool[userPoolList[_poolID][_poolRefSeqID]][_poolID][_poolRefSeqID].totalEarning += Auto_Pool[_poolID];
216         }
217         else if(usersPool[userPoolList[_poolID][_poolRefSeqID]][_poolID][_poolRefSeqID].poolReferral.length == 2){
218             autoPoolUplines(msg.sender, _poolID,Auto_Pool_SeqID[_poolID]);
219         }
220         else{
221             address(uint160(userPoolList[_poolID][_poolRefSeqID])).transfer(Auto_Pool[_poolID]);
222             usersPool[userPoolList[_poolID][_poolRefSeqID]][_poolID][_poolRefSeqID].totalEarning += Auto_Pool[_poolID];
223             
224             Auto_Pool_SeqID[_poolID]++;
225         
226             AutoPoolStruct memory autoPoolStructReinvest;
227             autoPoolStructReinvest = AutoPoolStruct({
228                 isExist: true,
229                 poolStatus: false,
230                 seqID: Auto_Pool_SeqID[_poolID],
231                 totalEarning:0,
232                 poolReferrerID: usersPool[userPoolList[_poolID][_poolRefSeqID]][_poolID][_poolRefSeqID].poolReferrerID,
233                 poolReferral: new address[](0)
234             });
235             
236             usersPool[userPoolList[_poolID][_poolRefSeqID]][_poolID][Auto_Pool_SeqID[_poolID]] = autoPoolStructReinvest;
237             userPoolSeqID[userPoolList[_poolID][_poolRefSeqID]][_poolID].push(Auto_Pool_SeqID[_poolID]);
238             userPoolList[_poolID][Auto_Pool_SeqID[_poolID]] = userPoolList[_poolID][_poolRefSeqID];
239         }
240         
241         emit AutoPoolEvent(_poolRefSeqID,msg.sender, _poolID, now);    
242     }
243     
244     
245     function autoPoolUplines(
246         address _user,
247         uint _poolID,
248         uint _userPoolID
249         )
250         internal
251     {
252         address[10] memory  uplineUsers;
253         uint[10] memory uplineUsersID;
254         uplineUsers[0] =  userPoolList[_poolID][usersPool[_user][_poolID][_userPoolID].poolReferrerID];
255         uplineUsersID[0] = usersPool[_user][_poolID][_userPoolID].poolReferrerID;
256         uplineUsers[1] =  userPoolList[_poolID][usersPool[uplineUsers[0]][_poolID][uplineUsersID[0]].poolReferrerID];
257         uplineUsersID[1] = usersPool[uplineUsers[0]][_poolID][uplineUsersID[0]].poolReferrerID;
258         uplineUsers[2] =  userPoolList[_poolID][usersPool[uplineUsers[1]][_poolID][uplineUsersID[1]].poolReferrerID];
259         uplineUsersID[2] = usersPool[uplineUsers[1]][_poolID][uplineUsersID[1]].poolReferrerID;
260         uplineUsers[3] =  userPoolList[_poolID][usersPool[uplineUsers[2]][_poolID][uplineUsersID[2]].poolReferrerID];
261         uplineUsersID[3] = usersPool[uplineUsers[2]][_poolID][uplineUsersID[2]].poolReferrerID;
262         uplineUsers[4] =  userPoolList[_poolID][usersPool[uplineUsers[3]][_poolID][uplineUsersID[3]].poolReferrerID];
263         uplineUsersID[4] = usersPool[uplineUsers[3]][_poolID][uplineUsersID[3]].poolReferrerID;
264         uplineUsers[5] =  userPoolList[_poolID][usersPool[uplineUsers[4]][_poolID][uplineUsersID[4]].poolReferrerID];
265         uplineUsersID[5] = usersPool[uplineUsers[4]][_poolID][uplineUsersID[4]].poolReferrerID;
266         uplineUsers[6] =  userPoolList[_poolID][usersPool[uplineUsers[5]][_poolID][uplineUsersID[5]].poolReferrerID];
267         uplineUsersID[6] = usersPool[uplineUsers[5]][_poolID][uplineUsersID[5]].poolReferrerID;
268         uplineUsers[7] =  userPoolList[_poolID][usersPool[uplineUsers[6]][_poolID][uplineUsersID[6]].poolReferrerID];
269         uplineUsersID[7] = usersPool[uplineUsers[6]][_poolID][uplineUsersID[6]].poolReferrerID;
270         uplineUsers[8] =  userPoolList[_poolID][usersPool[uplineUsers[7]][_poolID][uplineUsersID[7]].poolReferrerID];
271         uplineUsersID[8] = usersPool[uplineUsers[7]][_poolID][uplineUsersID[7]].poolReferrerID;
272         uplineUsers[9] =  userPoolList[_poolID][usersPool[uplineUsers[8]][_poolID][uplineUsersID[8]].poolReferrerID];
273         uplineUsersID[9] = usersPool[uplineUsers[8]][_poolID][uplineUsersID[8]].poolReferrerID;
274         
275         for(uint i=0;i<10;i++){
276             if(uplineUsers[i] == address(0)){
277                 uplineUsers[i] = userPoolList[_poolID][1];
278                 uplineUsersID[i] = 1;
279             }
280         }
281         uint uplineAmount = Auto_Pool_Upline[_poolID];
282         
283         address(uint160(uplineUsers[0])).transfer(uplineAmount);
284         address(uint160(uplineUsers[1])).transfer(uplineAmount);
285         address(uint160(uplineUsers[2])).transfer(uplineAmount);
286         address(uint160(uplineUsers[3])).transfer(uplineAmount);
287         address(uint160(uplineUsers[4])).transfer(uplineAmount);
288         address(uint160(uplineUsers[5])).transfer(uplineAmount);
289         address(uint160(uplineUsers[6])).transfer(uplineAmount);
290         address(uint160(uplineUsers[7])).transfer(uplineAmount);
291         address(uint160(uplineUsers[8])).transfer(uplineAmount);
292         address(uint160(uplineUsers[9])).transfer(uplineAmount);
293         admin.transfer(Auto_Pool_System[_poolID]);
294         
295         usersPool[uplineUsers[0]][_poolID][uplineUsersID[0]].totalEarning += uplineAmount;
296         usersPool[uplineUsers[1]][_poolID][uplineUsersID[1]].totalEarning += uplineAmount;
297         usersPool[uplineUsers[2]][_poolID][uplineUsersID[2]].totalEarning += uplineAmount;
298         usersPool[uplineUsers[3]][_poolID][uplineUsersID[3]].totalEarning += uplineAmount;
299         usersPool[uplineUsers[4]][_poolID][uplineUsersID[4]].totalEarning += uplineAmount;
300         usersPool[uplineUsers[5]][_poolID][uplineUsersID[5]].totalEarning += uplineAmount;
301         usersPool[uplineUsers[6]][_poolID][uplineUsersID[6]].totalEarning += uplineAmount;
302         usersPool[uplineUsers[7]][_poolID][uplineUsersID[7]].totalEarning += uplineAmount;
303         usersPool[uplineUsers[8]][_poolID][uplineUsersID[8]].totalEarning += uplineAmount;
304         usersPool[uplineUsers[9]][_poolID][uplineUsersID[9]].totalEarning += uplineAmount;
305         usersPool[admin][_poolID][1].totalEarning += Auto_Pool_System[_poolID];
306         emit AutoPoolUplineEvent(usersPool[_user][_poolID][_userPoolID].poolReferrerID,_poolID,msg.sender, uplineUsers);
307        
308     }
309     
310     function viewUserReferral(address _user) public view returns(address[] memory) {
311         return users[_user].referral;
312     }
313     
314     function viewUserPoolReferral(address _user,uint _poolID,uint _userPoolID) public view returns(address[] memory) {
315         return usersPool[_user][_poolID][_userPoolID].poolReferral;
316     }
317     
318     function viewUserPoolSeqID(address _user,uint _poolID)public view returns(uint[] memory) {
319         return userPoolSeqID[_user][_poolID];
320     }
321     
322     function contractLock(bool _lockStatus) public returns (bool) {
323         require(msg.sender == admin, "Invalid User");
324 
325         lockStatus = _lockStatus;
326         return true;
327     }
328     
329     function failSafe(address payable _toUser, uint _amount) public returns (bool) {
330         require(msg.sender == admin, "only Owner Wallet");
331         require(_toUser != address(0), "Invalid Address");
332         require(address(this).balance >= _amount, "Insufficient balance");
333 
334         (_toUser).transfer(_amount);
335         return true;
336     }
337     
338 }