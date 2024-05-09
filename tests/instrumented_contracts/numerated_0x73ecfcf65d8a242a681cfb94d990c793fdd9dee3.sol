1 pragma solidity ^0.4.24;
2 
3 pragma experimental ABIEncoderV2;
4 
5 contract Subby {
6     event Post(address indexed publisherAddress, uint indexed postId, uint indexed timestamp, string publisherUsername, string link, string comment);
7     event Donation(address indexed recipientAddress, int indexed postId, address indexed senderAddress, string recipientUsername, string senderUsername, string text, uint amount, uint timestamp);
8 
9     mapping(address => string) public addressToThumbnail;
10     mapping(address => string) public addressToBio;
11     mapping(address => string) public addressToUsername;
12     mapping(string => address) private usernameToAddress;
13     mapping(address => string[]) private addressToComments;
14     mapping(address => string[]) private addressToLinks;
15     mapping(address => uint[]) public addressToTimestamps;
16     mapping(address => uint) public addressToMinimumTextDonation;
17     mapping(address => string[]) private addressToSubscriptions;
18     mapping(address => bool) public addressToIsTerminated;
19     mapping(address => uint) public addressToTotalDonationsAmount;
20     mapping(address => mapping(uint => uint)) public addressToPostIdToDonationsAmount;
21     mapping(address => bool) public addressToHideDonationsAmounts;
22    
23     constructor() public {}
24 
25     function terminateAccount() public {
26         addressToIsTerminated[msg.sender] = true;
27     }
28   
29     function donate(string text, address recipientAddress, string recipientUsername, int postId) public payable {
30         require(addressToIsTerminated[recipientAddress] == false, "Can't donate to terminated account.");
31        
32         if (bytes(recipientUsername).length > 0) {
33             recipientAddress = usernameToAddress[recipientUsername];
34         }
35         if (bytes(text).length > 0) {
36             require(addressToMinimumTextDonation[recipientAddress] > 0, "Recipient has disabled donations.");
37             require(msg.value >= addressToMinimumTextDonation[recipientAddress], "Donation amount lower than recipient minimum donation.");
38         }
39         recipientAddress.transfer(msg.value);
40         addressToTotalDonationsAmount[recipientAddress] += msg.value;
41         if (postId >= 0) {
42             addressToPostIdToDonationsAmount[recipientAddress][uint(postId)] += msg.value;
43         }
44         if (msg.value > addressToMinimumTextDonation[recipientAddress] && addressToMinimumTextDonation[recipientAddress] > 0) {
45             if (postId < 0) {
46                 postId = -1;
47             }
48             if (bytes(text).length > 0) {
49                 emit Donation(recipientAddress, postId, msg.sender, addressToUsername[recipientAddress], addressToUsername[msg.sender], text, msg.value, now);
50             }
51         }
52     }
53 
54     function publish(string link, string comment) public {
55         require(addressToIsTerminated[msg.sender] == false, "Terminated accounts may not publish.");
56         uint id = addressToComments[msg.sender].push(comment);
57         addressToLinks[msg.sender].push(link);
58         addressToTimestamps[msg.sender].push(now);
59 
60         emit Post(msg.sender, id, now, addressToUsername[msg.sender], link, comment);
61     }
62 
63     function setMinimumTextDonation (uint value) public {
64         addressToMinimumTextDonation[msg.sender] = value;
65     }
66 
67     function setThumbnail(string thumbnail) public {
68         addressToThumbnail[msg.sender] = thumbnail;
69     }
70 
71     function setBio(string bio) public {
72         addressToBio[msg.sender] = bio;
73     }
74 
75     function editProfile(string thumbnail, bool changeThumbnail, string bio, bool changeBio, uint minimumTextDonation, bool changeMinimumTextDonation, bool hideDonations, bool changeHideDonations, string username, bool changeUsername) public {
76         require(addressToIsTerminated[msg.sender] == false, "Cant not edit terminated account.");
77         if (changeHideDonations) {
78             addressToHideDonationsAmounts[msg.sender] = hideDonations;
79         }
80         if (changeMinimumTextDonation) {
81             require(minimumTextDonation > 0, "Can not set minimumTextDonation to less than 0.");
82             addressToMinimumTextDonation[msg.sender] = minimumTextDonation;
83         }
84         if (changeThumbnail) {
85             addressToThumbnail[msg.sender] = thumbnail;
86         }
87         if (changeBio) {
88             addressToBio[msg.sender] = bio;
89         }
90         if (changeUsername) {
91             require(bytes(username).length < 39, "Username can not have more than 39 characters.");
92             require(bytes(username).length > 0, "Username must be longer than 0 characters.");
93             // Require that the name has not already been taken.
94             require(usernameToAddress[username] == 0x0000000000000000000000000000000000000000, "Usernames can not be changed.");
95             // Require that the sender has not already set a name.
96             require(bytes(addressToUsername[msg.sender]).length == 0, "This username is already taken.");
97             addressToUsername[msg.sender] = username;
98             usernameToAddress[username] = msg.sender;
99         }
100     }
101 
102     function getProfile(address _address, string username) public view returns (address, string, uint, string[], uint, bool[]) {
103         string[] memory bio_thumbnail = new string[](2);
104         bool[] memory hideDonations_isTerminated = new bool[](2);
105         hideDonations_isTerminated[0] = addressToHideDonationsAmounts[_address];
106         hideDonations_isTerminated[1] = addressToIsTerminated[_address];
107         
108         if (addressToIsTerminated[_address]) {
109             return (0x0000000000000000000000000000000000000000, "", 0, bio_thumbnail, 0, hideDonations_isTerminated);
110         }
111 
112         if (bytes(username).length > 0) {
113             _address = usernameToAddress[username];
114         }
115 
116         bio_thumbnail[0] = getBio(_address);
117         bio_thumbnail[1] = getThumbnail(_address);
118         
119         return (_address, addressToUsername[_address], addressToMinimumTextDonation[_address], bio_thumbnail,
120             getTotalDonationsAmount(_address), hideDonations_isTerminated);
121     }
122 
123     function getProfiles(address[] memory addresses, string[] memory usernames) public view returns (address[] memory, string[] memory, uint[]) {
124         address[] memory addressesFromUsernames = getAddressesFromUsernames(usernames);
125         string[] memory thumbnails_bios_usernames = new string[]((addresses.length + addressesFromUsernames.length) * 3);
126         address[] memory returnAddresses = new address[](addresses.length + addressesFromUsernames.length);
127         uint[] memory minimumTextDonations_totalDonationsAmounts = new uint[]((addresses.length + addressesFromUsernames.length) * 2);
128 
129         for (uint i = 0; i < addresses.length; i++) {
130             thumbnails_bios_usernames[i] = getThumbnail(addresses[i]);
131             thumbnails_bios_usernames[i + addresses.length + addressesFromUsernames.length] = getBio(addresses[i]);
132             thumbnails_bios_usernames[i + ((addresses.length + addressesFromUsernames.length) * 2)] = getUsername(addresses[i]);
133             returnAddresses[i] = addresses[i];
134             minimumTextDonations_totalDonationsAmounts[i] = getMinimumTextDonation(addresses[i]);
135             minimumTextDonations_totalDonationsAmounts[i + addresses.length + addressesFromUsernames.length] = getTotalDonationsAmount(addresses[i]);
136         }
137         for (i = 0; i < addressesFromUsernames.length; i++) {
138             thumbnails_bios_usernames[i + addresses.length] = getThumbnail(addressesFromUsernames[i]);
139             thumbnails_bios_usernames[i + addresses.length + addresses.length + addressesFromUsernames.length] = getBio(addressesFromUsernames[i]);
140             thumbnails_bios_usernames[i + addresses.length + ((addresses.length + addressesFromUsernames.length) * 2)] = getUsername(addressesFromUsernames[i]);
141             returnAddresses[i + addresses.length] = addressesFromUsernames[i];
142             minimumTextDonations_totalDonationsAmounts[i + addresses.length] = getMinimumTextDonation(addressesFromUsernames[i]);
143             minimumTextDonations_totalDonationsAmounts[i + addresses.length + addresses.length + addressesFromUsernames.length] = getTotalDonationsAmount(addressesFromUsernames[i]);
144         }
145         return (returnAddresses, thumbnails_bios_usernames, minimumTextDonations_totalDonationsAmounts);
146     }
147         
148     function getSubscriptions(address _address, string username) public view returns (string[]) {
149         if (bytes(username).length > 0) {
150             _address = usernameToAddress[username];
151         }
152         return addressToSubscriptions[_address];
153     }
154 
155     function getSubscriptionsFromSender() public view returns (string[]) {
156         return addressToSubscriptions[msg.sender];
157     }
158     
159     function syncSubscriptions(string[] subsToPush, string[] subsToOverwrite, uint[] indexesToOverwrite ) public {
160         for (uint i = 0; i < indexesToOverwrite.length; i++ ) {
161             addressToSubscriptions[msg.sender][indexesToOverwrite[i]] = subsToOverwrite[i];
162         }
163         for ( i = 0; i < subsToPush.length; i++) {
164             addressToSubscriptions[msg.sender].push(subsToPush[i]);
165         }
166     }
167 
168     function getUsernameFromAddress(address _address) public view returns (string) {
169         return addressToUsername[_address];
170     }
171 
172     function getAddressFromUsername(string username) public view returns (address) {
173         return usernameToAddress[username];
174     }
175 
176     function getAddressesFromUsernames(string[] usernames) public view returns (address[]) {
177         address[] memory returnAddresses = new address[](usernames.length);
178         for (uint i = 0; i < usernames.length; i++) {
179             returnAddresses[i] = usernameToAddress[usernames[i]];
180         }
181         return returnAddresses;
182     }
183     
184     function getComment(address _address, uint id) public view returns (string) {
185         if (addressToIsTerminated[_address]) {
186             return "";
187         }
188         string[] memory comments = addressToComments[_address];
189         if (comments.length > id) {
190             return comments[id];
191         }
192         else {
193             return "";
194         }
195     }
196     
197     function getThumbnail(address _address) public view returns (string) {
198         if (addressToIsTerminated[_address]) {
199             return "";
200         }
201         return addressToThumbnail[_address];
202     }
203     
204     function getLink(address _address, uint id) public view returns (string) {
205         if (addressToIsTerminated[_address]) {
206             return "";
207         }
208         string[] memory links = addressToLinks[_address];
209         if (links.length > id) {
210             return links[id];
211         }
212         else {
213             return "";
214         }
215     }
216 
217     function getBio(address _address) public view returns (string) {
218         if (addressToIsTerminated[_address]) {
219             return "";
220         }
221         return addressToBio[_address];
222     }
223 
224     function getTimestamp(address _address, uint id) public view returns (uint) {
225         if (addressToIsTerminated[_address]) {
226             return 0;
227         }
228         uint[] memory timestamps = addressToTimestamps[_address];
229         if (timestamps.length > id) {
230             return timestamps[id];
231         }
232         else {
233             return 0;
234         }
235     }
236 
237     function getTotalDonationsAmount(address _address) public view returns (uint) {
238         if (addressToHideDonationsAmounts[_address]) {
239             return 0;
240         }
241         return addressToTotalDonationsAmount[_address];
242     }
243     
244     function getMinimumTextDonation(address _address) public view returns (uint) {
245         return addressToMinimumTextDonation[_address];
246     }
247     
248     function getUsername(address _address) public view returns (string) {
249         return addressToUsername[_address];
250     }
251 
252     function getLinks(address _address) public view returns (string[]) {
253         return addressToLinks[_address];
254     }
255 
256     function getComments(address _address) public view returns (string[]) {
257         return addressToComments[_address];
258     }
259 
260     function getTimestamps(address _address) public view returns (uint[]) {
261         return addressToTimestamps[_address];
262     }
263 
264     function getPostFromId(address _address, string username,  uint id) public view returns ( string[], address, uint, uint, uint) {
265         if (bytes(username).length > 0) {
266             _address = usernameToAddress[username];
267         }
268         string[] memory comment_link_username_thumbnail = new string[](4);
269         comment_link_username_thumbnail[0] = getComment(_address, id);
270         comment_link_username_thumbnail[1] = getLink(_address, id);
271         comment_link_username_thumbnail[2] = getUsername(_address);
272         comment_link_username_thumbnail[3] = addressToThumbnail[_address];
273         uint timestamp = getTimestamp(_address, id);
274         uint postDonationsAmount = getPostDonationsAmount(_address, id);
275 
276         return (comment_link_username_thumbnail, _address,  timestamp,  addressToMinimumTextDonation[_address], postDonationsAmount);
277     }
278     
279     function getPostDonationsAmount(address _address, uint id) public view returns (uint) {
280         if (addressToHideDonationsAmounts[_address]) {
281             return 0;
282         }
283         return addressToPostIdToDonationsAmount[_address][id];
284     }
285 
286     function getPostsFromIds(address[] addresses, string[] usernames, uint[] ids) public view returns (string[], address[], uint[]) {
287         address[] memory addressesFromUsernames = getAddressesFromUsernames(usernames);
288         string[] memory comments_links_usernames_thumbnails = new string[]((addresses.length + addressesFromUsernames.length) * 4);
289         address[] memory publisherAddresses = new address[](addresses.length + addressesFromUsernames.length);
290         uint[] memory minimumTextDonations_postDonationsAmount_timestamps = new uint[]((addresses.length + addressesFromUsernames.length) * 3);
291 
292         for (uint i = 0; i < addresses.length; i++) {
293             comments_links_usernames_thumbnails[i] = getComment(addresses[i], ids[i]);
294             comments_links_usernames_thumbnails[i + addresses.length + addressesFromUsernames.length] = getLink(addresses[i], ids[i]);
295             comments_links_usernames_thumbnails[i + ((addresses.length + addressesFromUsernames.length) * 2)] = getUsername(addresses[i]);
296             comments_links_usernames_thumbnails[i + ((addresses.length + addressesFromUsernames.length) * 3)] = getThumbnail(addresses[i]);
297             publisherAddresses[i] = addresses[i];
298             minimumTextDonations_postDonationsAmount_timestamps[i] = getMinimumTextDonation(addresses[i]);
299             minimumTextDonations_postDonationsAmount_timestamps[i + addresses.length + addressesFromUsernames.length] = getPostDonationsAmount(addresses[i], ids[i]);
300             minimumTextDonations_postDonationsAmount_timestamps[i + ((addresses.length + addressesFromUsernames.length) * 2)] = getTimestamp(addresses[i], ids[i]);
301         }
302         
303         for (i = 0; i < addressesFromUsernames.length; i++) {
304             comments_links_usernames_thumbnails[i + addresses.length] = getComment(addressesFromUsernames[i], ids[i + addresses.length]);
305             comments_links_usernames_thumbnails[i + addresses.length + (addresses.length + addressesFromUsernames.length)] = getLink(addressesFromUsernames[i], ids[i + addresses.length]);
306             comments_links_usernames_thumbnails[i + addresses.length + ((addresses.length + addressesFromUsernames.length) * 2)] = getUsername(addressesFromUsernames[i]);
307             comments_links_usernames_thumbnails[i + addresses.length + ((addresses.length + addressesFromUsernames.length) * 3)] = getThumbnail(addressesFromUsernames[i]);
308             publisherAddresses[i + addresses.length] = addressesFromUsernames[i];
309             minimumTextDonations_postDonationsAmount_timestamps[i + addresses.length] = getMinimumTextDonation(addressesFromUsernames[i]);
310             minimumTextDonations_postDonationsAmount_timestamps[i + addresses.length + (addresses.length + addressesFromUsernames.length)] = getPostDonationsAmount(addressesFromUsernames[i], ids[i + addresses.length]);
311             minimumTextDonations_postDonationsAmount_timestamps[i + addresses.length + ((addresses.length + addressesFromUsernames.length) * 2)] = getTimestamp(addressesFromUsernames[i], ids[i + addresses.length]);
312         }
313         
314         return (comments_links_usernames_thumbnails, publisherAddresses, minimumTextDonations_postDonationsAmount_timestamps);
315     }
316     
317     function getPostsFromPublisher(address _address, string username, uint startAt, bool startAtLatestPost, uint limit)
318         public view returns (string[], string[], address, uint[]) {
319         if (bytes(username).length > 0) {
320             _address = usernameToAddress[username];
321         }
322         string[] memory comments_links = new string[](limit * 2);
323         string[] memory thumbnail_username = new string[](2);
324         thumbnail_username[0] = addressToThumbnail[_address];
325         thumbnail_username[1] = addressToUsername[_address];
326         if (startAtLatestPost == true) {
327             startAt = addressToComments[_address].length;
328         }
329         uint[] memory timestamps_postDonationsAmounts_minimumTextDonation_postCount = new uint[]((limit * 2) + 2);
330 
331         parseCommentsLinks(comments_links, _address, startAt, limit, timestamps_postDonationsAmounts_minimumTextDonation_postCount);
332         timestamps_postDonationsAmounts_minimumTextDonation_postCount[limit * 2] = addressToMinimumTextDonation[_address];
333         timestamps_postDonationsAmounts_minimumTextDonation_postCount[(limit * 2) + 1] = addressToComments[_address].length;
334         
335         return (comments_links, thumbnail_username, _address, timestamps_postDonationsAmounts_minimumTextDonation_postCount );
336     }
337     
338     function parseCommentsLinks(string[] comments_links, 
339         address _address, uint startAt, uint limit, uint[] timestamps_postDonationsAmounts_minimumTextDonation_postCount) public view {
340         uint count = 0;
341         for (uint i = 1; i < limit + 1; i++) {
342             comments_links[count] = getComment(_address, startAt - i);
343             timestamps_postDonationsAmounts_minimumTextDonation_postCount[count] = getTimestamp(_address, startAt - i);
344             timestamps_postDonationsAmounts_minimumTextDonation_postCount[count + limit] = getPostDonationsAmount(_address, startAt - i);
345             count++;
346         } 
347         for (i = 1; i < limit + 1; i++) {
348             comments_links[count] = getLink(_address, startAt - i);
349             count++;
350         } 
351     }
352 
353     function getTimestampsFromPublishers(address[] addresses, string[] usernames, int[] startAts, int limit) public view returns (uint[], uint[]) {
354         uint[] memory returnTimestamps = new uint[]((addresses.length + usernames.length) * uint(limit));
355         uint[] memory publisherPostCounts = new uint[](addresses.length + usernames.length);
356         uint timestampIndex = 0;
357         uint addressesPlusUsernamesIndex = 0;
358         for (uint i = 0; i < addresses.length; i++) {
359             address _address = addresses[i];
360             // startAt is the first index that will be returned.
361             int startAt;
362             if (startAts.length == 0) {
363                 startAt = int(addressToTimestamps[_address].length - 1);
364             } else {
365                 startAt = startAts[addressesPlusUsernamesIndex];
366             }
367             // Collect timestamps, starting from startAt and counting down to 0 until limit is reached.
368             for (int j = 0; j < limit; j++) {
369                 if (addressToIsTerminated[_address] == false && ((startAt - j) >= 0) && ((startAt - j) < int(addressToTimestamps[_address].length))) {
370                     returnTimestamps[timestampIndex] = addressToTimestamps[_address][uint(startAt - j)];
371                 } else {
372                     returnTimestamps[timestampIndex] = 0;
373                 }
374                 timestampIndex++;
375             }
376             publisherPostCounts[addressesPlusUsernamesIndex] = addressToTimestamps[_address].length;
377             addressesPlusUsernamesIndex++;
378         }
379         // Do the same thing as above, but with usernames instead of addresses. Code duplication is essential to save gas.
380         if (usernames.length > 0) {
381             addresses = getAddressesFromUsernames(usernames);
382             for (i = 0; i < addresses.length; i++) {
383                 _address = addresses[i];
384                 if (startAts.length == 0) {
385                     startAt = int(addressToTimestamps[_address].length - 1);
386                 } else {
387                     startAt = startAts[addressesPlusUsernamesIndex];
388                 }
389                 for (j = 0; j < limit; j++) {
390                     if (addressToIsTerminated[_address] == false && ((startAt - j) >= 0) && ((startAt - j) < int(addressToTimestamps[_address].length))) {
391                         returnTimestamps[timestampIndex] = addressToTimestamps[_address][uint(startAt - j)];
392                     } else {
393                         returnTimestamps[timestampIndex] = 0;
394                     }
395                     timestampIndex++;
396                 }
397                 publisherPostCounts[addressesPlusUsernamesIndex] = addressToTimestamps[_address].length;
398                 addressesPlusUsernamesIndex++;
399             }
400         }
401         return (returnTimestamps, publisherPostCounts);
402     }
403 }