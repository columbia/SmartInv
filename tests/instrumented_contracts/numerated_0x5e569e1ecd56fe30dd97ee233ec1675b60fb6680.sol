1 pragma solidity ^0.4.4;
2 
3 /**
4  * @title Project Kudos
5  *
6  * Events voting system of the Virtual Accelerator.
7  * Includes the voting for both judges and fans.
8  *
9  */
10 contract ProjectKudos {
11 
12     // votes limit for judge
13     uint KUDOS_LIMIT_JUDGE = 1000;
14 
15     // votes limit for regular user
16     uint KUDOS_LIMIT_USER  = 10;
17 
18     // additional votes given for social account proof
19     uint SOCIAL_PROOF_KUDOS = 100;
20 
21     // Grant Reason
22     uint GRANT_REASON_FACEBOOK = 0;
23     uint GRANT_REASON_TWITTER = 1;
24 
25     // keeps project votes data
26     struct ProjectInfo {
27         mapping(address => uint) kudosByUser;
28         uint kudosTotal;
29     }
30 
31     // keeps user votes data
32     struct UserInfo {
33         uint kudosLimit;
34         uint kudosGiven;
35         bool isJudge;
36         mapping(uint => bool) grant;
37     }
38 
39     // keeps links between user's votes
40     // and projects he voted for
41     struct UserIndex {
42         bytes32[] projects;
43         uint[] kudos;
44         mapping(bytes32 => uint) kudosIdx;
45     }
46 
47     // keeps time frames for vote period
48     struct VotePeriod {
49         uint start;
50         uint end;
51     }
52 
53     // contract creator's address
54     address owner;
55 
56     // vote period
57     VotePeriod votePeriod;
58 
59     // user votes mapping
60     mapping(address => UserInfo) users;
61 
62     // user index,
63     // helps to get votes given by one user for every project
64     mapping(address => UserIndex) usersIndex;
65 
66     // project votes mapping
67     mapping(bytes32 => ProjectInfo) projects;
68 
69     // emitted when vote is done
70     event Vote(
71         // address of voter
72         address indexed voter,
73         // sha3 of project code
74         bytes32 indexed projectCode,
75         // votes given
76         uint indexed count
77     );
78 
79     /**
80      * @dev Contract's constructor.
81      * Stores contract's owner and sets up vote period
82      */
83     function ProjectKudos() {
84 
85         owner = msg.sender;
86 
87         votePeriod = VotePeriod(
88             1479996000,     // GMT: 24-Nov-2016 14:00, Voting starts, 1st week passed
89             1482415200      // GMT: 22-Dec-2016 14:00, Voting ends, Hackathon ends
90         );
91     }
92 
93     /**
94      * @dev Registers voter to the event.
95      * Executable only by contract's owner.
96      *
97      * @param userAddress address of the user to register
98      * @param isJudge should be true if user is judge, false otherwise
99      */
100     function register(address userAddress, bool isJudge) onlyOwner {
101 
102         UserInfo user = users[userAddress];
103 
104         if (user.kudosLimit > 0) throw;
105 
106         if (isJudge)
107             user.kudosLimit = KUDOS_LIMIT_JUDGE;
108         else
109             user.kudosLimit = KUDOS_LIMIT_USER;
110 
111         user.isJudge = isJudge;
112 
113         users[userAddress] = user;
114     }
115 
116     /**
117      *  @dev Gives votes to the project.
118      *  Can only be executed within vote period.
119      *  User signed the Tx becomes votes giver.
120      *
121      *  @param projectCode code of the project, must be less than or equal to 32 bytes
122      *  @param kudos - votes to be given
123      */
124     function giveKudos(bytes32 projectCode, uint kudos) {
125 
126         // throw if called not during the vote period
127         if (now < votePeriod.start) throw;
128         if (now >= votePeriod.end) throw;        
129         
130         UserInfo giver = users[msg.sender];
131 
132         if (giver.kudosGiven + kudos > giver.kudosLimit) throw;
133 
134         ProjectInfo project = projects[projectCode];
135 
136         giver.kudosGiven += kudos;
137         project.kudosTotal += kudos;
138         project.kudosByUser[msg.sender] += kudos;
139 
140         // save index of user voting history
141         updateUsersIndex(projectCode, project.kudosByUser[msg.sender]);
142 
143         Vote(msg.sender, projectCode, kudos);
144     }
145 
146     /**
147      * @dev Grants extra kudos for identity proof.
148      *
149      * @param userToGrant address of user to grant additional
150      * votes for social proof
151      * 
152      * @param reason granting reason,  0 - Facebook, 1 - Twitter
153      */         
154     function grantKudos(address userToGrant, uint reason) onlyOwner {
155 
156         UserInfo user = users[userToGrant];
157 
158         if (user.kudosLimit == 0) throw; //probably user does not exist then
159 
160         if (reason != GRANT_REASON_FACEBOOK &&        // Facebook
161             reason != GRANT_REASON_TWITTER) throw;    // Twitter
162 
163         // if user is judge his identity is known
164         // not reasonble to grant more kudos for social
165         // proof.
166         if (user.isJudge) throw;
167 
168         // if not granted for that reason yet
169         if (user.grant[reason]) throw;
170 
171         // grant 100 votes
172         user.kudosLimit += SOCIAL_PROOF_KUDOS;
173         
174         user.grant[reason] = true;
175     }
176 
177 
178     // ********************* //
179     // *   Constant Calls  * //
180     // ********************* //
181 
182     /**
183      * @dev Returns total votes given to the project
184      *
185      * @param projectCode project's code
186      *
187      * @return number of give votes
188      */
189     function getProjectKudos(bytes32 projectCode) constant returns(uint) {
190         ProjectInfo project = projects[projectCode];
191         return project.kudosTotal;
192     }
193 
194     /**
195      * @dev Returns an array of votes given to the project
196      * corresponding to array of users passed in function call
197      *
198      * @param projectCode project's code
199      * @param users array of user addresses
200      *
201      * @return array of votes given by passed users
202      */
203     function getProjectKudosByUsers(bytes32 projectCode, address[] users) constant returns(uint[]) {
204         ProjectInfo project = projects[projectCode];
205         mapping(address => uint) kudosByUser = project.kudosByUser;
206         uint[] memory userKudos = new uint[](users.length);
207         for (uint i = 0; i < users.length; i++) {
208             userKudos[i] = kudosByUser[users[i]];
209        }
210 
211        return userKudos;
212     }
213 
214     /**
215      * @dev Returns votes given by specified user
216      * to the list of projects ever voted by that user
217      *
218      * @param giver user's address
219      * @return projects array of project codes represented by bytes32 array
220      * @return kudos array of votes given by user,
221      *         index of vote corresponds to index of project from projects array
222      */
223     function getKudosPerProject(address giver) constant returns (bytes32[] projects, uint[] kudos) {
224         UserIndex idx = usersIndex[giver];
225         projects = idx.projects;
226         kudos = idx.kudos;
227     }
228 
229     /**
230      * @dev Returns votes allowed to be given by user
231      *
232      * @param addr user's address
233      * @return number of votes left
234      */
235     function getKudosLeft(address addr) constant returns(uint) {
236         UserInfo user = users[addr];
237         return user.kudosLimit - user.kudosGiven;
238     }
239 
240     /**
241      * @dev Returns votes given by user
242      *
243      * @param addr user's address
244      * @return number of votes given
245      */
246     function getKudosGiven(address addr) constant returns(uint) {
247         UserInfo user = users[addr];
248         return user.kudosGiven;
249     }
250 
251 
252     // ********************* //
253     // *   Private Calls   * //
254     // ********************* //
255 
256     /**
257      * @dev Private function. Updates users index
258      *
259      * @param code project code represented by bytes32 array
260      * @param kudos votes total given to the project by sender
261      */
262     function updateUsersIndex(bytes32 code, uint kudos) private {
263 
264         UserIndex idx = usersIndex[msg.sender];
265         uint i = idx.kudosIdx[code];
266 
267         // add new entry to index
268         if (i == 0) {
269             i = idx.projects.length + 1;
270             idx.projects.length += 1;
271             idx.kudos.length += 1;
272             idx.projects[i - 1] = code;
273             idx.kudosIdx[code] = i;
274         }
275 
276         idx.kudos[i - 1] = kudos;
277     }
278 
279 
280     // ********************* //
281     // *     Modifiers     * //
282     // ********************* //
283 
284     /**
285      * @dev Throws if called not by contract's owner
286      */
287     modifier onlyOwner() {
288         if (msg.sender != owner) throw;
289         _;
290     }
291 }