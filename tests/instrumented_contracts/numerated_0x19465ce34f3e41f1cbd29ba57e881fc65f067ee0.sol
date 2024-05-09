1 /*
2 
3 CONTRACT DEPLOYED FOR VALIDATION 2020-05-27
4 
5 HEXRUN.NETWORK
6 
7 WEBSITE URL: https://hexrun.network/
8 
9 */
10 pragma solidity 0.5.11;
11 
12 
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract hexrun {
85     
86     
87     IERC20 public hexTokenInterface;
88     
89     address public hexTokenAddress = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39;
90     address public ownerWallet;
91 
92 
93     struct UserStruct {
94         bool isExist;
95         uint id;
96         uint referrerID;
97         address[] referral;
98         mapping(uint => uint) levelExpired;
99     }
100 
101     uint REFERRER_1_LEVEL_LIMIT = 2;
102     uint PERIOD_LENGTH = 30 days;
103 
104     mapping(uint => uint) public LEVEL_PRICE;
105 
106     mapping (address => UserStruct) public users;
107     mapping (uint => address) public userList;
108     uint public currUserID = 0;
109     uint public totalHex = 0;
110 
111 
112 
113     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
114     event buyLevelEvent(address indexed _user, uint _level, uint _time);
115     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
116     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
117     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
118 
119     constructor() public {
120         hexTokenInterface = IERC20(hexTokenAddress);
121         ownerWallet = 0x418EA32f7EB0795aa83ceBA00D6DDD055e6643A7;
122 
123         LEVEL_PRICE[1] = 2000 * 1e8;
124         LEVEL_PRICE[2] = 4000 * 1e8;
125         LEVEL_PRICE[3] = 8000 * 1e8;
126         LEVEL_PRICE[4] = 16000 * 1e8;
127         LEVEL_PRICE[5] = 32000 * 1e8;
128         LEVEL_PRICE[6] = 64000 * 1e8;
129         LEVEL_PRICE[7] = 128000 * 1e8;
130         LEVEL_PRICE[8] = 256000 * 1e8;
131         LEVEL_PRICE[9] = 512000 * 1e8;
132         LEVEL_PRICE[10] = 1024000 * 1e8; /// (HEX)
133 
134         UserStruct memory userStruct;
135         currUserID++;
136 
137         userStruct = UserStruct({
138             isExist: true,
139             id: currUserID,
140             referrerID: 0,
141             referral: new address[](0)
142         });
143         users[ownerWallet] = userStruct;
144         userList[currUserID] = ownerWallet;
145 
146         for(uint i = 1; i <= 10; i++) {
147             users[ownerWallet].levelExpired[i] = 55555555555;
148         }
149     }
150 
151 
152 
153     function regUser(uint _referrerID, uint _numHex) public {
154 
155         require(!users[msg.sender].isExist, 'User exist');
156         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
157         require(_numHex == LEVEL_PRICE[1], 'Incorrect number of HEX sent');
158         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
159         
160         hexTokenInterface.transferFrom(msg.sender, address(this), _numHex);
161         
162         UserStruct memory userStruct;
163         currUserID++;
164 
165         userStruct = UserStruct({
166             isExist: true,
167             id: currUserID,
168             referrerID: _referrerID,
169             referral: new address[](0)
170         });
171 
172         users[msg.sender] = userStruct;
173         userList[currUserID] = msg.sender;
174 
175         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
176 
177         users[userList[_referrerID]].referral.push(msg.sender);
178 
179         payForLevel(1, msg.sender);
180 
181         emit regLevelEvent(msg.sender, userList[_referrerID], now);
182         
183     }
184 
185 
186 
187     function buyLevel(uint _level, uint _numHex) public {
188         require(users[msg.sender].isExist, 'User not exist'); 
189         require(_level > 0 && _level <= 10, 'Incorrect level');
190 
191         hexTokenInterface.transferFrom(msg.sender, address(this), _numHex);
192 
193         if(_level == 1) {
194             require(_numHex == LEVEL_PRICE[1], 'Incorrect Value');
195             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
196         }
197         else {
198             require(_numHex == LEVEL_PRICE[_level], 'Incorrect Value');
199 
200             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
201 
202             if(users[msg.sender].levelExpired[_level] == 0) users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
203             else users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
204         }
205 
206         payForLevel(_level, msg.sender);
207 
208         emit buyLevelEvent(msg.sender, _level, now);
209     }
210 
211 
212 
213 
214     function payForLevel(uint _level, address _user) internal {
215         address referer;
216         address referer1;
217         address referer2;
218         address referer3;
219         address referer4;
220 
221         if(_level == 1 || _level == 6) {
222             referer = userList[users[_user].referrerID];
223         }
224         else if(_level == 2 || _level == 7) {
225             referer1 = userList[users[_user].referrerID];
226             referer = userList[users[referer1].referrerID];
227         }
228         else if(_level == 3 || _level == 8) {
229             referer1 = userList[users[_user].referrerID]; 
230             referer2 = userList[users[referer1].referrerID];
231             referer = userList[users[referer2].referrerID];
232         }
233         else if(_level == 4 || _level == 9) {
234             referer1 = userList[users[_user].referrerID];
235             referer2 = userList[users[referer1].referrerID];
236             referer3 = userList[users[referer2].referrerID];
237             referer = userList[users[referer3].referrerID];
238         }
239         else if(_level == 5 || _level == 10) {
240             referer1 = userList[users[_user].referrerID];
241             referer2 = userList[users[referer1].referrerID];
242             referer3 = userList[users[referer2].referrerID];
243             referer4 = userList[users[referer3].referrerID];
244             referer = userList[users[referer4].referrerID];
245         }
246 
247         if(!users[referer].isExist) referer = userList[1];
248 
249         bool sent = false;
250         if(users[referer].levelExpired[_level] >= now) {
251 
252             sent = hexTokenInterface.transfer(referer, LEVEL_PRICE[_level]);
253 
254             totalHex += LEVEL_PRICE[_level];
255 
256             if (sent) {
257                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
258             }
259         }
260         if(!sent) {
261             emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
262 
263             payForLevel(_level, referer);
264         }
265     }
266 
267     function findFreeReferrer(address _user) public view returns(address) {
268         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;
269 
270         address[] memory referrals = new address[](126);
271         referrals[0] = users[_user].referral[0];
272         referrals[1] = users[_user].referral[1];
273 
274         address freeReferrer;
275         bool noFreeReferrer = true;
276 
277         for(uint i = 0; i < 126; i++) {
278             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
279                 if(i < 62) {
280                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
281                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
282                 }
283             }
284             else {
285                 noFreeReferrer = false;
286                 freeReferrer = referrals[i];
287                 break;
288             }
289         }
290 
291         
292         if(noFreeReferrer == true){
293             // nothing found - default
294             freeReferrer = userList[1];
295         }
296 
297         return freeReferrer;
298     }
299 
300     
301     function viewLevelStats() public view returns(uint[10]  memory lvlUserCount) {
302         for(uint c=1; c <= currUserID; c++) {    
303             if(userList[c] != address(0)){
304                 for(uint lvl=1; lvl < 11; lvl ++) {
305                     if(users[userList[c]].levelExpired[lvl] > now) {
306                         lvlUserCount[lvl-1] += 1;
307                     }
308                 }
309             }
310         }
311     }
312 
313     function viewUserReferral(address _user) public view returns(address[] memory) {
314         return users[_user].referral;
315     }
316 
317     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
318         return users[_user].levelExpired[_level];
319     }
320     
321 
322     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
323         assembly {
324             addr := mload(add(bys, 20))
325         }
326     }
327 }