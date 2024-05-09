1 pragma solidity ^0.4.8;
2 
3 contract SafeMath {
4 
5     function assert(bool assertion) internal {
6         if (!assertion) {
7             throw;
8         }
9     }
10 
11     function safeAddCheck(uint256 x, uint256 y) internal returns(bool) {
12       uint256 z = x + y;
13       if ((z >= x) && (z >= y)) {
14           return true;
15       }
16     }
17 
18     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
19         uint256 z = x * y;
20         assert((x == 0)||(z/x == y));
21         return z;
22     }
23 
24 }
25 
26 contract Token {
27     uint256 public totalSupply;
28     function balanceOf(address _owner) constant returns (uint256 balance);
29     function transfer(address _to, uint256 _value) returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31     function approve(address _spender, uint256 _value) returns (bool success);
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 
38 /*  ERC 20 token */
39 contract LeeroyPoints is Token, SafeMath {
40     address public owner;
41     mapping (address => bool) public controllers;
42 
43     string public constant name = "Leeroy Points";
44     string public constant symbol = "LRP";
45     uint256 public constant decimals = 18;
46     string public version = "1.0";
47     uint256 public constant baseUnit = 1 * 10**decimals;
48 
49     event CreateLRP(address indexed _to, uint256 _value);
50 
51     function LeeroyPoints() {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner { if (msg.sender != owner) throw; _; }
56 
57     modifier onlyController { if (controllers[msg.sender] == false) throw; _; }
58 
59     function enableController(address controller) onlyOwner {
60         controllers[controller] = true;
61     }
62 
63     function disableController(address controller) onlyOwner {
64         controllers[controller] = false;
65     }
66 
67     function create(uint num, address targetAddress) onlyController {
68         uint points = safeMult(num, baseUnit);
69         // use bool instead of assert, controller can run indefinitely
70         // regardless of totalSupply
71         bool checked = safeAddCheck(totalSupply, points);
72         if (checked) {
73             totalSupply = totalSupply + points;
74             balances[targetAddress] += points;
75             CreateLRP(targetAddress, points);
76         }
77    }
78 
79     function transfer(address _to, uint256 _value) returns (bool success) {
80       if (balances[msg.sender] >= _value && _value > 0) {
81         balances[msg.sender] -= _value;
82         balances[_to] += _value;
83         Transfer(msg.sender, _to, _value);
84         return true;
85       } else {
86         return false;
87       }
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
91       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
92         balances[_to] += _value;
93         balances[_from] -= _value;
94         allowed[_from][msg.sender] -= _value;
95         Transfer(_from, _to, _value);
96         return true;
97       } else {
98         return false;
99       }
100     }
101 
102     function balanceOf(address _owner) constant returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113       return allowed[_owner][_spender];
114     }
115 
116     mapping (address => uint256) balances;
117     mapping (address => mapping (address => uint256)) allowed;
118 }
119 
120 contract Leeroy {
121 
122     // metadata
123     string public constant name = "Leeroy";
124 
125     // points contract
126     LeeroyPoints public points;
127 
128     // points awarded
129     uint pointsPerAction = 1;
130 
131     // events
132     event NewUser(bytes32 indexed username);
133     event NewPost(bytes32 indexed username, uint id);
134     event Reply(bytes32 indexed username, bytes32 indexed target, uint indexed id);
135     event Follow(bytes32 indexed username, bytes32 indexed target, bool follow);
136     event Like(bytes32 indexed username, bytes32 indexed target, uint indexed id);
137     event Repost(bytes32 indexed username, bytes32 indexed target, uint indexed id);
138     event ChangeFeed(bytes32 indexed username, uint indexed id);
139 
140     function Leeroy(address pointsAddress) {
141         points = LeeroyPoints(pointsAddress);
142     }
143 
144     // users
145     struct User {
146         bytes32 username;
147         address owner;
148         bytes32 detailsHash;
149         uint joined;
150         uint blockNumber;
151         mapping(bytes32 => bool) following;
152     }
153 
154     mapping (bytes32 => User) public usernames; // lookup user by username
155     mapping (address => bytes32) public addresses; // lookup username by address
156 
157     // posts
158     struct Post {
159         bytes32 username;
160         bytes32 postHash;
161         uint timestamp;
162         uint blockNumber;
163         uint id;
164         mapping(bytes32 => bool) likes;
165         mapping(bytes32 => bool) reposts;
166         uint repostOf;
167         uint inReplyTo;
168     }
169 
170     Post[] public posts;
171 
172     function registerUsername(bytes32 username) {
173         var senderUsername = addresses[msg.sender];
174         var user = usernames[senderUsername];
175         if (usernames[username].owner != 0) throw; // prevents registration of existing name
176         if (user.owner != 0) throw; // prevents registered address from registering another name
177         if (!isLowercase(username)) throw; // username must be lowercase
178         var newUser = User({
179             username: username,
180             owner: msg.sender,
181             detailsHash: "",
182             joined: block.timestamp,
183             blockNumber: block.number,
184         });
185         usernames[username] = newUser;
186         addresses[msg.sender] = username;
187         NewUser(username);
188         points.create(pointsPerAction, msg.sender);
189     }
190 
191     function updateUserDetails(bytes32 detailsHash) {
192         var senderUsername = addresses[msg.sender]; // lookup registered username for this address
193         var user = usernames[senderUsername]; // get user details
194         if (user.owner == 0) throw; // user must be registered
195         user.detailsHash = detailsHash;
196     }
197 
198     function follow(bytes32 username) {
199         var senderUsername = addresses[msg.sender];
200         var user = usernames[senderUsername];
201         var target = usernames[username];
202         var following = user.following[target.username];
203         if (user.owner == 0) throw; // user must be registered
204         if (target.owner == 0) throw; // target must be registered
205         if (user.username == target.username) throw; // user cannot follow themself
206         if (following == true) throw; // user must not have followed target already
207         user.following[target.username] = true;
208         Follow(user.username, target.username, true);
209     }
210 
211     function unfollow(bytes32 username) {
212         var senderUsername = addresses[msg.sender];
213         var user = usernames[senderUsername];
214         var target = usernames[username];
215         var following = user.following[target.username];
216         if (user.owner == 0) throw; // user must be registered
217         if (target.owner == 0) throw; // target must be registered
218         if (user.username == target.username) throw; // user cannot follow themself
219         if (following == false) throw; // user must be following target
220         user.following[target.username] = false;
221         Follow(user.username, target.username, false);
222     }
223 
224     function post(bytes32 postHash) {
225         var senderUsername = addresses[msg.sender];
226         var user = usernames[senderUsername];
227         if (user.owner == 0) throw; // user must be registered
228         // create post
229         var id = posts.length + 1;
230         posts.push(Post({
231             username: user.username,
232             postHash: postHash,
233             timestamp: block.timestamp,
234             blockNumber: block.number,
235             id: id,
236             repostOf: 0,
237             inReplyTo: 0,
238         }));
239         NewPost(user.username, id);
240         points.create(pointsPerAction, user.owner);
241     }
242 
243     function reply(bytes32 postHash, uint id) {
244         var senderUsername = addresses[msg.sender];
245         var user = usernames[senderUsername];
246         uint index = id - 1;
247         var post = posts[index];
248         if (user.owner == 0) throw; // user must be registered
249         if (post.id == 0) throw; // post must exist
250         var postId = posts.length + 1;
251         posts.push(Post({
252             username: user.username,
253             postHash: postHash,
254             timestamp: block.timestamp,
255             blockNumber: block.number,
256             id: postId,
257             repostOf: 0,
258             inReplyTo: post.id,
259         }));
260         Reply(user.username, post.username, post.id);
261         ChangeFeed(post.username, post.id);
262         NewPost(user.username, postId);
263         if (user.username != post.username) {
264             // points only created when interacting with other user content
265             points.create(pointsPerAction, usernames[post.username].owner);
266             points.create(pointsPerAction, user.owner);
267         }
268     }
269 
270     function repost(uint id) {
271         var senderUsername = addresses[msg.sender];
272         var user = usernames[senderUsername];
273         uint index = id - 1;
274         var post = posts[index];
275         var reposted = post.reposts[user.username];
276         if (user.owner == 0) throw; // user must be registered
277         if (post.id == 0) throw; // post must exist
278         if (reposted == true) throw; // user must not have reposted already
279         post.reposts[user.username] = true;
280         var postId = posts.length + 1;
281         posts.push(Post({
282             username: user.username,
283             postHash: "",
284             timestamp: block.timestamp,
285             blockNumber: block.number,
286             id: postId,
287             repostOf: post.id,
288             inReplyTo: 0,
289         }));
290         Repost(user.username, post.username, post.id);
291         ChangeFeed(post.username, post.id);
292         NewPost(user.username, postId);
293         if (user.username != post.username) {
294             points.create(pointsPerAction, usernames[post.username].owner);
295             points.create(pointsPerAction, user.owner);
296         }
297     }
298 
299     function like(uint id) {
300         var senderUsername = addresses[msg.sender];
301         var user = usernames[senderUsername];
302         uint index = id - 1;
303         var post = posts[index];
304         var liked = post.likes[user.username];
305         if (user.owner == 0) throw; // user must be registered
306         if (post.id == 0) throw; // post must exist
307         if (liked == true) throw; // user must not have liked already
308         post.likes[user.username] = true;
309         Like(user.username, post.username, post.id);
310         ChangeFeed(post.username, post.id);
311         if (user.username != post.username) {
312             points.create(pointsPerAction, usernames[post.username].owner);
313             points.create(pointsPerAction, user.owner);
314         }
315     }
316 
317     function isLowercase(bytes32 self) internal constant returns (bool) {
318         for (uint i = 0; i < 32; i++) {
319             byte char = byte(bytes32(uint(self) * 2 ** (8 * i)));
320             if (char >= 0x41 && char <= 0x5A) {
321                 return false;
322             }
323         }
324         return true;
325     }
326 
327     function getUserBlockNumber(bytes32 username) constant returns (uint) {
328         return usernames[username].blockNumber;
329     }
330 
331 }