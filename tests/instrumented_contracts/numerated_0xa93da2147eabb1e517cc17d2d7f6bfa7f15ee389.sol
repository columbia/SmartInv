1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
5 }
6 
7 contract braggerContract {
8 
9 /*********************************/
10 /*********** MAPPINGS ************/
11 /*********************************/
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     mapping (address => bool) private isUser;
18     mapping (address => bool) private hasPicture;
19     mapping (address => string) private userWalletToUserName;
20     mapping (string => address) private userNameToUserWallet;
21     mapping (string => string) private userNameToPicture;
22     mapping (address => string) private userWalletToPicture;
23     mapping (address => uint256) private fineLevel;
24 
25 /*********************************/
26 /************* EVENTS ************/
27 /*********************************/
28 
29     // This generates a public event on the blockchain that will notify clients
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     // This notifies clients about the amount burnt
33     event Burn(address indexed from, uint256 value);
34 
35 /*********************************/
36 /******** FREE VARIABLES *********/
37 /*********************************/
38 
39     address public ownerAddress = 0x000;
40     address private bragAddress = 0x04fd8fcff717754dE3BA18dAC22A5Fda7D69658E;
41 
42     string private initialQuote = "Teach your people with your wisdom.";
43     /******SET PICTURE*/
44     string private initialPicture = "https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male2-512.png";
45 
46     uint256 basicFine = 25000000000000000;
47 
48     uint256 totalBraggedValue = 0;
49 
50     uint256 winningpot = 0;
51 
52     uint256 totalbrags = 0;
53 
54     bool payoutReady;
55     bool payoutRequested;
56     uint256 payoutBlock;
57 
58 /*********************************/
59 /*********** DATA TYPES **********/
60 /*********************************/
61 
62     struct Bragger{
63         address braggerAddress;
64         uint256 braggedAmount;
65         string braggerQuote;
66     }
67 
68     Bragger[] private braggers;
69 
70     struct User{
71         address userAddress;
72         string userName;
73     }
74 
75     User[] private users;
76 
77 /*********************************/
78 /*********** MODIFIER ************/
79 /*********************************/
80 
81     /// @dev Access modifier for CEO-only functionality
82     modifier onlyCreator() {
83         require(msg.sender == ownerAddress);
84         _;
85     }
86 
87 
88 /*********************************/
89 /********** CONSTRUCTOR **********/
90 /*********************************/
91 
92     constructor() public {
93         payoutRequested = false;
94         payoutReady = false;
95         ownerAddress = msg.sender;
96     }
97 
98 /*********************************/
99 /******* PAYOUT FUNCTIONS ********/
100 /*********************************/
101 
102     function requestPayout() public {
103         //require(isUser[msg.sender]);
104         if(!getPayoutRequestedState()) {
105             payoutRequested = true;
106             payoutBlock = SafeMath.add(block.number, 17280);
107         }
108     }
109 
110     function delayPayout() public payable {
111         require(getPayoutRequestedState());
112         //require(isUser[msg.sender]);
113         require(msg.value>=2500000000000000);
114         payoutBlock = SafeMath.add(payoutBlock, 240);
115         bragAddress.transfer(msg.value);
116     }
117 
118     function triggerPayout() public {
119         //require(isUser[msg.sender]);
120         require(checkPayoutReadyState());
121         address _winner = braggers[braggers.length-1].braggerAddress;
122         _winner.transfer(getWinnerPot());
123         payoutBlock = 0;
124         payoutRequested = false;
125     }
126 
127      function checkPayoutReadyState() public returns(bool){
128         if(block.number >= payoutBlock && payoutBlock != 0){
129             payoutReady = true;
130             return true;
131         }
132 
133         if(block.number < payoutBlock){
134             payoutReady = false;
135             return false;
136         }
137     }
138 
139 /*********************************/
140 /************ GETTERS ************/
141 /*********************************/
142 
143     function getPayoutRequestedState() public view returns(bool){
144         return payoutRequested;
145     }
146 
147     function getPayoutReadyState() public view returns(bool){
148          if(block.number>=payoutBlock && payoutBlock != 0){
149             return true;
150         }
151 
152         if(block.number < payoutBlock){
153             return false;
154         }
155     }
156 
157     function getCurrentPayoutBlock() public view returns(uint){
158         return payoutBlock;
159     }
160 
161     function getRemainingBlocksUntilPayoutk() public view returns(uint){
162         return SafeMath.sub(payoutBlock, block.number);
163     }
164 
165     function getTotalBraggedVolume() public view returns (uint256 _amount){
166         return totalBraggedValue;
167     }
168 
169     function getCurrentBragKing() public view returns(address _bragger, uint256 _amount, string _quote, string _username, string _picture){
170         _bragger = braggers[braggers.length-1].braggerAddress;
171         _amount = braggers[braggers.length-1].braggedAmount;
172         _quote = braggers[braggers.length-1].braggerQuote;
173         if(isAlreadyUser(_bragger)){
174             _username = getUserNameByWallet(_bragger);
175         } else {
176             _username = "";
177         }
178 
179         if(hasPicture[_bragger]){
180             _picture = userWalletToPicture[_bragger];
181         } else {
182             _picture = initialPicture;
183         }
184 
185         return (_bragger, _amount, _quote, _username, _picture);
186     }
187 
188     function arrayLength()public view returns(uint256 length){
189         length = braggers.length;
190         return length;
191     }
192 
193     function getBraggerAtIndex(uint256 _index) public view returns(address _bragger, uint256 _brag, string _username, string _picture){
194         _bragger = braggers[_index].braggerAddress;
195         _brag = braggers[_index].braggedAmount;
196 
197         if(isAlreadyUser(_bragger)){
198             _username = getUserNameByWallet(_bragger);
199         } else {
200             _username = "";
201         }
202 
203          if(hasPicture[_bragger]){
204             _picture = userWalletToPicture[_bragger];
205         } else {
206             _picture = initialPicture;
207         }
208 
209         return (_bragger, _brag, _username, _picture);
210     }
211 
212     function getUserNameByWallet(address _wallet) public view returns (string _username){
213         require(isAlreadyUser(_wallet));
214         _username = userWalletToUserName[_wallet];
215         return _username;
216     }
217 
218      function getUserPictureByWallet(address _wallet) public view returns (string _url){
219         require(isAlreadyUser(_wallet));
220         _url = userWalletToPicture[_wallet];
221         return _url;
222     }
223 
224     function getUserWalletByUsername(string _username) public view returns(address _address){
225         address _user = userNameToUserWallet[_username];
226         return (_user);
227     }
228 
229     function getUserPictureByUsername(string _username) public view returns(string _url){
230         _url = userNameToPicture[_username];
231         return (_url);
232     }
233 
234     function getFineLevelOfAddress(address _user) public view returns(uint256 _fineLevel, uint256 _fineAmount){
235         _fineLevel = fineLevel[_user];
236         _fineAmount = _fineLevel * basicFine;
237         return (_fineLevel, _fineAmount);
238     }
239 
240     function getFineLevelOfUsername(string _username) public view returns(uint256 _fineLevel, uint256 _fineAmount){
241         address _user = userNameToUserWallet[_username];
242         _fineLevel = fineLevel[_user];
243         _fineAmount = _fineLevel * basicFine;
244         return (_fineLevel, _fineAmount);
245     }
246 
247     function getTotalBrags() public view returns(uint256){
248         return totalbrags;
249     }
250 
251     function getWinnerPot() public view returns(uint256){
252         return winningpot;
253     }
254 
255 /*********************************/
256 /****** BRAGING FUNCTIONS ********/
257 /*********************************/
258 
259     function getCurrentPot() public view returns (uint256 _amount){
260         return address(this).balance;
261     }
262 
263 
264     function brag() public payable{
265 
266         uint256 shortage = SafeMath.mul(30,SafeMath.div(msg.value, 100));
267 
268         if(braggers.length != 0){
269          require(braggers[braggers.length-1].braggedAmount < msg.value);
270         }
271 
272         Bragger memory _bragger = Bragger({
273             braggerAddress: msg.sender,
274             braggedAmount: msg.value,
275             braggerQuote: initialQuote
276         });
277 
278         braggers.push(_bragger);
279 
280         totalBraggedValue = totalBraggedValue + msg.value;
281 
282         winningpot = winningpot + SafeMath.sub(msg.value, shortage);
283 
284         bragAddress.transfer(shortage);
285 
286         totalbrags += 1;
287     }
288 
289 /*********************************/
290 /******* USER INTERACTION ********/
291 /*********************************/
292 
293     function setTheKingsQuote(string _message) public payable{
294         if(fineLevel[msg.sender] > 0){
295             require(msg.value >= (basicFine * fineLevel[msg.sender]));
296         }
297         address currentKing = braggers[braggers.length-1].braggerAddress;
298         require(msg.sender == currentKing);
299         braggers[braggers.length-1].braggerQuote = _message;
300     }
301 
302 /*********************************/
303 /********* USER CREATION *********/
304 /*********************************/
305 
306     function isAlreadyUser(address _address) public view returns (bool status){
307         if (isUser[_address]){
308             return true;
309         } else {
310             return false;
311         }
312     }
313 
314     function hasProfilePicture(address _address) public view returns (bool status){
315         if (isUser[_address]){
316             return true;
317         } else {
318             return false;
319         }
320     }
321 
322     function createNewUser(string _username, string _pictureUrl) public {
323 
324         require(!isAlreadyUser(msg.sender));
325 
326         User memory _user = User({
327             userAddress: msg.sender,
328             userName: _username
329         });
330 
331         userWalletToUserName[msg.sender] = _username;
332         userNameToUserWallet[_username] = msg.sender;
333         userNameToPicture[_username] = _pictureUrl;
334         userWalletToPicture[msg.sender] = _pictureUrl;
335         fineLevel[msg.sender] = 0;
336 
337         users.push(_user) - 1;
338         isUser[msg.sender] = true;
339         hasPicture[msg.sender] = true;
340     }
341 
342 /*********************************/
343 /******** OWNER FUNCTIONS ********/
344 /*********************************/
345 
346     function resetQuote()public onlyCreator{
347         braggers[braggers.length-1].braggerQuote = initialQuote;
348         fineLevel[braggers[braggers.length-1].braggerAddress] = fineLevel[braggers[braggers.length-1].braggerAddress] + 1;
349     }
350 
351     function resetUsername(string _username)public onlyCreator{
352         address user = userNameToUserWallet[_username];
353         userWalletToUserName[user] = "Mick";
354         fineLevel[user] = fineLevel[user] + 1;
355     }
356 
357     function resetUserPicture(string _username)public onlyCreator{
358         address user = userNameToUserWallet[_username];
359         userWalletToPicture[user] = initialPicture;
360         fineLevel[user] = fineLevel[user] + 1;
361     }
362 
363     /********** ResetUserPicture */
364 
365 /*********************************/
366 /******** LEGACY FUNCIONS ********/
367 /*********************************/
368 
369     function _transfer(address _from, address _to, uint _value) internal {
370         // Prevent transfer to 0x0 address. Use burn() instead
371         require(_to != 0x0);
372         // Check if the sender has enough
373         require(balanceOf[_from] >= _value);
374         // Check for overflows
375         require(balanceOf[_to] + _value > balanceOf[_to]);
376         // Save this for an assertion in the future
377         uint previousBalances = balanceOf[_from] + balanceOf[_to];
378         // Subtract from the sender
379         balanceOf[_from] -= _value;
380         // Add the same to the recipient
381         balanceOf[_to] += _value;
382         emit Transfer(_from, _to, _value);
383         // Asserts are used to use static analysis to find bugs in your code. They should never fail
384         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
385     }
386 
387     function transfer(address _to, uint256 _value) public {
388         _transfer(msg.sender, _to, _value);
389     }
390 
391     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
392         require(_value <= allowance[_from][msg.sender]);     // Check allowance
393         allowance[_from][msg.sender] -= _value;
394         _transfer(_from, _to, _value);
395         return true;
396     }
397 
398     function approve(address _spender, uint256 _value) public
399         returns (bool success) {
400         allowance[msg.sender][_spender] = _value;
401         return true;
402     }
403 
404     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
405         public
406         returns (bool success) {
407         tokenRecipient spender = tokenRecipient(_spender);
408         if (approve(_spender, _value)) {
409             spender.receiveApproval(msg.sender, _value, this, _extraData);
410             return true;
411         }
412     }
413 
414     function reset()public onlyCreator {
415         selfdestruct(ownerAddress);
416     }
417 
418 }
419 
420 /*********************************/
421 /*********** CALC LIB ************/
422 /*********************************/
423 
424 library SafeMath {
425 
426   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
427     if (a == 0) {
428       return 0;
429     }
430     uint256 c = a * b;
431     assert(c / a == b);
432     return c;
433   }
434 
435   function div(uint256 a, uint256 b) internal pure returns (uint256) {
436     // assert(b > 0); // Solidity automatically throws when dividing by 0
437     uint256 c = a / b;
438     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
439     return c;
440   }
441 
442   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
443     assert(b <= a);
444     return a - b;
445   }
446 
447   function add(uint256 a, uint256 b) internal pure returns (uint256) {
448     uint256 c = a + b;
449     assert(c >= a);
450     return c;
451   }
452 }