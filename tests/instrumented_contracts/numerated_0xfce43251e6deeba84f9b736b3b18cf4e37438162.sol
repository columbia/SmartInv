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
40     address private bragAddress = 0x845EC9f9C0650b98f70E05fc259F4A04f6AC366e;
41 
42     string private initialQuote = "Teach your people with your wisdom.";
43     /******SET PICTURE*/
44     string private initialPicture = "https://cdn2.iconfinder.com/data/icons/ios-7-icons/50/user_male2-512.png";
45 
46     uint256 basicFine = 25000000000000000;
47 
48     uint256 blocks;
49     uint256 totalBraggedValue = 0;
50     
51     uint256 winningpot = 0;
52     
53     uint256 totalbrags = 0;
54 
55 /*********************************/
56 /*********** DATA TYPES **********/
57 /*********************************/
58 
59     struct Bragger{
60         address braggerAddress;
61         uint256 braggedAmount;
62         string braggerQuote;
63     }
64 
65     Bragger[] private braggers;
66 
67     struct User{
68         address userAddress;
69         string userName;
70     }
71 
72     User[] private users;
73 
74 /*********************************/
75 /*********** MODIFIER ************/
76 /*********************************/
77 
78     /// @dev Access modifier for CEO-only functionality
79     modifier onlyCreator() {
80         require(msg.sender == ownerAddress);
81         _;
82     }
83 
84 
85 /*********************************/
86 /********** CONSTRUCTOR **********/
87 /*********************************/
88 
89     constructor() public {
90         blocks=0;
91         ownerAddress = msg.sender;
92     }
93 
94     function random() private view returns (uint8) {
95         return uint8(uint256(keccak256(block.timestamp, block.difficulty))%251);
96     }
97 
98     function random2() private view returns (uint8) {
99         return uint8(uint256(keccak256(blocks, block.difficulty))%251);
100     }
101 
102     function random3() private view returns (uint8) {
103         return uint8(uint256(keccak256(blocks, block.difficulty))%braggers.length);
104     }
105 
106 /*********************************/
107 /************ GETTERS ************/
108 /*********************************/
109 
110     function getTotalBraggedVolume() public view returns (uint256 _amount){
111         return totalBraggedValue;
112     }
113 
114     function getCurrentBragKing() public view returns(address _bragger, uint256 _amount, string _quote, string _username, string _picture){
115         _bragger = braggers[braggers.length-1].braggerAddress;
116         _amount = braggers[braggers.length-1].braggedAmount;
117         _quote = braggers[braggers.length-1].braggerQuote;
118         if(isAlreadyUser(_bragger)){
119             _username = getUserNameByWallet(_bragger);
120         } else {
121             _username = "";
122         }
123 
124         if(hasPicture[_bragger]){
125             _picture = userWalletToPicture[_bragger];
126         } else {
127             _picture = initialPicture;
128         }
129 
130         return (_bragger, _amount, _quote, _username, _picture);
131     }
132 
133     function arrayLength()public view returns(uint256 length){
134         length = braggers.length;
135         return length;
136     }
137 
138     function getBraggerAtIndex(uint256 _index) public view returns(address _bragger, uint256 _brag, string _username, string _picture){
139         _bragger = braggers[_index].braggerAddress;
140         _brag = braggers[_index].braggedAmount;
141 
142         if(isAlreadyUser(_bragger)){
143             _username = getUserNameByWallet(_bragger);
144         } else {
145             _username = "";
146         }
147 
148          if(hasPicture[_bragger]){
149             _picture = userWalletToPicture[_bragger];
150         } else {
151             _picture = initialPicture;
152         }
153 
154         return (_bragger, _brag, _username, _picture);
155     }
156 
157     function getUserNameByWallet(address _wallet) public view returns (string _username){
158         require(isAlreadyUser(_wallet));
159         _username = userWalletToUserName[_wallet];
160         return _username;
161     }
162 
163      function getUserPictureByWallet(address _wallet) public view returns (string _url){
164         require(isAlreadyUser(_wallet));
165         _url = userWalletToPicture[_wallet];
166         return _url;
167     }
168 
169     function getUserWalletByUsername(string _username) public view returns(address _address){
170         address _user = userNameToUserWallet[_username];
171         return (_user);
172     }
173 
174     function getUserPictureByUsername(string _username) public view returns(string _url){
175         _url = userNameToPicture[_username];
176         return (_url);
177     }
178 
179     function getFineLevelOfAddress(address _user) public view returns(uint256 _fineLevel, uint256 _fineAmount){
180         _fineLevel = fineLevel[_user];
181         _fineAmount = _fineLevel * basicFine;
182         return (_fineLevel, _fineAmount);
183     }
184 
185     function getFineLevelOfUsername(string _username) public view returns(uint256 _fineLevel, uint256 _fineAmount){
186         address _user = userNameToUserWallet[_username];
187         _fineLevel = fineLevel[_user];
188         _fineAmount = _fineLevel * basicFine;
189         return (_fineLevel, _fineAmount);
190     }
191     
192     function getTotalBrags() public view returns(uint256){
193         return totalbrags;
194     }
195     
196     function getWinnerPot() public view returns(uint256){
197         return winningpot;
198     }
199 
200 /*********************************/
201 /****** BRAGING FUNCTIONS ********/
202 /*********************************/
203 
204     function getCurrentPot() public view returns (uint256 _amount){
205         return address(this).balance;
206     }
207 
208 
209     function brag() public payable{
210 
211         uint256 shortage = SafeMath.mul(30,SafeMath.div(msg.value, 100));
212 
213         if(braggers.length != 0){
214          require(braggers[braggers.length-1].braggedAmount < msg.value);
215         }
216 
217         Bragger memory _bragger = Bragger({
218             braggerAddress: msg.sender,
219             braggedAmount: msg.value,
220             braggerQuote: initialQuote
221         });
222 
223         braggers.push(_bragger);
224 
225         totalBraggedValue = totalBraggedValue + msg.value;
226         
227         winningpot = winningpot + SafeMath.sub(msg.value, shortage);
228 
229         bragAddress.transfer(shortage);
230 
231         if(random() == random2()){
232             address sender = msg.sender;
233             sender.transfer(SafeMath.mul(SafeMath.div(address(this).balance,100), 70));
234             uint256 luckyIndex = random3();
235             address luckyGuy = braggers[luckyIndex].braggerAddress;
236             luckyGuy.transfer(address(this).balance);
237         }
238 
239         blocks = SafeMath.add(blocks, random());
240         totalbrags += 1;
241     }
242 
243 /*********************************/
244 /******* USER INTERACTION ********/
245 /*********************************/
246 
247     function setTheKingsQuote(string _message) public payable{
248         if(fineLevel[msg.sender] > 0){
249             require(msg.value > (basicFine * fineLevel[msg.sender]));
250         }
251         address currentKing = braggers[braggers.length-1].braggerAddress;
252         require(msg.sender == currentKing);
253         braggers[braggers.length-1].braggerQuote = _message;
254     }
255 
256 /*********************************/
257 /********* USER CREATION *********/
258 /*********************************/
259 
260     function isAlreadyUser(address _address) public view returns (bool status){
261         if (isUser[_address]){
262             return true;
263         } else {
264             return false;
265         }
266     }
267 
268     function hasProfilePicture(address _address) public view returns (bool status){
269         if (isUser[_address]){
270             return true;
271         } else {
272             return false;
273         }
274     }
275 
276     function createNewUser(string _username, string _pictureUrl) public {
277 
278         require(!isAlreadyUser(msg.sender));
279 
280         User memory _user = User({
281             userAddress: msg.sender,
282             userName: _username
283         });
284 
285         userWalletToUserName[msg.sender] = _username;
286         userNameToUserWallet[_username] = msg.sender;
287         userNameToPicture[_username] = _pictureUrl;
288         userWalletToPicture[msg.sender] = _pictureUrl;
289         fineLevel[msg.sender] = 0;
290 
291         users.push(_user) - 1;
292         isUser[msg.sender] = true;
293         hasPicture[msg.sender] = true;
294     }
295 
296 /*********************************/
297 /******** OWNER FUNCTIONS ********/
298 /*********************************/
299 
300     function resetQuote()public onlyCreator{
301         braggers[braggers.length-1].braggerQuote = initialQuote;
302         fineLevel[braggers[braggers.length-1].braggerAddress] = fineLevel[braggers[braggers.length-1].braggerAddress] + 1;
303     }
304 
305     function resetUsername(string _username)public onlyCreator{
306         address user = userNameToUserWallet[_username];
307         userWalletToUserName[user] = "Mick";
308         fineLevel[user] = fineLevel[user] + 1;
309     }
310 
311     function resetUserPicture(string _username)public onlyCreator{
312         address user = userNameToUserWallet[_username];
313         userWalletToPicture[user] = initialPicture;
314         fineLevel[user] = fineLevel[user] + 1;
315     }
316 
317     /********** ResetUserPicture */
318 
319 /*********************************/
320 /******** LEGACY FUNCIONS ********/
321 /*********************************/
322 
323     function _transfer(address _from, address _to, uint _value) internal {
324         // Prevent transfer to 0x0 address. Use burn() instead
325         require(_to != 0x0);
326         // Check if the sender has enough
327         require(balanceOf[_from] >= _value);
328         // Check for overflows
329         require(balanceOf[_to] + _value > balanceOf[_to]);
330         // Save this for an assertion in the future
331         uint previousBalances = balanceOf[_from] + balanceOf[_to];
332         // Subtract from the sender
333         balanceOf[_from] -= _value;
334         // Add the same to the recipient
335         balanceOf[_to] += _value;
336         emit Transfer(_from, _to, _value);
337         // Asserts are used to use static analysis to find bugs in your code. They should never fail
338         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
339     }
340 
341     function transfer(address _to, uint256 _value) public {
342         _transfer(msg.sender, _to, _value);
343     }
344 
345     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
346         require(_value <= allowance[_from][msg.sender]);     // Check allowance
347         allowance[_from][msg.sender] -= _value;
348         _transfer(_from, _to, _value);
349         return true;
350     }
351 
352     function approve(address _spender, uint256 _value) public
353         returns (bool success) {
354         allowance[msg.sender][_spender] = _value;
355         return true;
356     }
357 
358     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
359         public
360         returns (bool success) {
361         tokenRecipient spender = tokenRecipient(_spender);
362         if (approve(_spender, _value)) {
363             spender.receiveApproval(msg.sender, _value, this, _extraData);
364             return true;
365         }
366     }
367 
368     function reset()public onlyCreator {
369         selfdestruct(ownerAddress);
370     }
371 
372 }
373 
374 /*********************************/
375 /*********** CALC LIB ************/
376 /*********************************/
377 
378 library SafeMath {
379 
380   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
381     if (a == 0) {
382       return 0;
383     }
384     uint256 c = a * b;
385     assert(c / a == b);
386     return c;
387   }
388 
389   function div(uint256 a, uint256 b) internal pure returns (uint256) {
390     // assert(b > 0); // Solidity automatically throws when dividing by 0
391     uint256 c = a / b;
392     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
393     return c;
394   }
395 
396   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
397     assert(b <= a);
398     return a - b;
399   }
400 
401   function add(uint256 a, uint256 b) internal pure returns (uint256) {
402     uint256 c = a + b;
403     assert(c >= a);
404     return c;
405   }
406 }