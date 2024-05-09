1 pragma solidity ^0.4.23;
2 
3 
4 library Roles {
5   struct Role {
6     mapping (address => bool) bearer;
7   }
8 
9   /**
10    * @dev give an address access to this role
11    */
12   function add(Role storage role, address addr)
13     internal
14   {
15     role.bearer[addr] = true;
16   }
17 
18   /**
19    * @dev remove an address' access to this role
20    */
21   function remove(Role storage role, address addr)
22     internal
23   {
24     role.bearer[addr] = false;
25   }
26 
27   /**
28    * @dev check if an address has this role
29    * // reverts
30    */
31   function check(Role storage role, address addr)
32     view
33     internal
34   {
35     require(has(role, addr));
36   }
37 
38   /**
39    * @dev check if an address has this role
40    * @return bool
41    */
42   function has(Role storage role, address addr)
43     view
44     internal
45     returns (bool)
46   {
47     return role.bearer[addr];
48   }
49 }
50 
51 
52 contract RBAC {
53   using Roles for Roles.Role;
54 
55   mapping (string => Roles.Role) private roles;
56 
57   event RoleAdded(address addr, string roleName);
58   event RoleRemoved(address addr, string roleName);
59 
60   /**
61    * @dev reverts if addr does not have role
62    * @param addr address
63    * @param roleName the name of the role
64    * // reverts
65    */
66   function checkRole(address addr, string roleName)
67     view
68     public
69   {
70     roles[roleName].check(addr);
71   }
72 
73   /**
74    * @dev determine if addr has role
75    * @param addr address
76    * @param roleName the name of the role
77    * @return bool
78    */
79   function hasRole(address addr, string roleName)
80     view
81     public
82     returns (bool)
83   {
84     return roles[roleName].has(addr);
85   }
86 
87   /**
88    * @dev add a role to an address
89    * @param addr address
90    * @param roleName the name of the role
91    */
92   function addRole(address addr, string roleName)
93     internal
94   {
95     roles[roleName].add(addr);
96     emit RoleAdded(addr, roleName);
97   }
98 
99   /**
100    * @dev remove a role from an address
101    * @param addr address
102    * @param roleName the name of the role
103    */
104   function removeRole(address addr, string roleName)
105     internal
106   {
107     roles[roleName].remove(addr);
108     emit RoleRemoved(addr, roleName);
109   }
110 
111   /**
112    * @dev modifier to scope access to a single role (uses msg.sender as addr)
113    * @param roleName the name of the role
114    * // reverts
115    */
116   modifier onlyRole(string roleName)
117   {
118     checkRole(msg.sender, roleName);
119     _;
120   }
121 
122   /**
123    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
124    * @param roleNames the names of the roles to scope access to
125    * // reverts
126    *
127    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
128    *  see: https://github.com/ethereum/solidity/issues/2467
129    */
130   // modifier onlyRoles(string[] roleNames) {
131   //     bool hasAnyRole = false;
132   //     for (uint8 i = 0; i < roleNames.length; i++) {
133   //         if (hasRole(msg.sender, roleNames[i])) {
134   //             hasAnyRole = true;
135   //             break;
136   //         }
137   //     }
138 
139   //     require(hasAnyRole);
140 
141   //     _;
142   // }
143 }
144 
145 
146 contract RBACWithAdmin is RBAC {
147   /**
148    * A constant role name for indicating admins.
149    */
150   string public constant ROLE_ADMIN = "admin";
151   string public constant ROLE_PAUSE_ADMIN = "pauseAdmin";
152 
153   /**
154    * @dev modifier to scope access to admins
155    * // reverts
156    */
157   modifier onlyAdmin()
158   {
159     checkRole(msg.sender, ROLE_ADMIN);
160     _;
161   }
162   modifier onlyPauseAdmin()
163   {
164     checkRole(msg.sender, ROLE_PAUSE_ADMIN);
165     _;
166   }
167   /**
168    * @dev constructor. Sets msg.sender as admin by default
169    */
170   constructor()
171     public
172   {
173     addRole(msg.sender, ROLE_ADMIN);
174     addRole(msg.sender, ROLE_PAUSE_ADMIN);
175   }
176 
177   /**
178    * @dev add a role to an address
179    * @param addr address
180    * @param roleName the name of the role
181    */
182   function adminAddRole(address addr, string roleName)
183     onlyAdmin
184     public
185   {
186     addRole(addr, roleName);
187   }
188 
189   /**
190    * @dev remove a role from an address
191    * @param addr address
192    * @param roleName the name of the role
193    */
194   function adminRemoveRole(address addr, string roleName)
195     onlyAdmin
196     public
197   {
198     removeRole(addr, roleName);
199   }
200 }
201 
202 
203 contract DragonStats is RBACWithAdmin {
204     uint256 constant UINT128_MAX = 340282366920938463463374607431768211455;
205     uint256 constant UINT248_MAX = 452312848583266388373324160190187140051835877600158453279131187530910662655;
206     struct parent {
207         uint128 parentOne;
208         uint128 parentTwo;
209     }
210     
211     struct lastAction {
212         uint8  lastActionID;
213         uint248 lastActionDragonID;
214     }
215     
216     struct dragonStat {
217         uint32 fightWin;
218         uint32 fightLose;
219         uint32 children;
220         uint32 fightToDeathWin;
221         uint32 mutagenFace;
222         uint32 mutagenFight;
223         uint32 genLabFace;
224         uint32 genLabFight;
225     }
226     
227     mapping(uint256 => uint256) public birthBlock;
228     mapping(uint256 => uint256) public deathBlock;
229     mapping(uint256 => parent)  public parents;
230     mapping(uint256 => lastAction) public lastActions;
231     mapping(uint256 => dragonStat) public dragonStats;
232 
233 
234     function setBirthBlock(uint256 _dragonID) external onlyRole("MainContract") {
235         require(birthBlock[_dragonID] == 0);
236         birthBlock[_dragonID] = block.number;
237     }
238     
239     function setDeathBlock(uint256 _dragonID) external onlyRole("MainContract") {
240         require(deathBlock[_dragonID] == 0);
241         deathBlock[_dragonID] = block.number;
242     }
243     
244     function setParents(uint256 _dragonID, uint256 _parentOne, uint256 _parentTwo) 
245         external 
246         onlyRole("MainContract") 
247     {
248         
249         require(birthBlock[_dragonID] == 0);
250         
251         if (_parentOne <= UINT128_MAX) { 
252             parents[_dragonID].parentOne = uint128(_parentOne);
253         }
254         
255         if (_parentTwo <= UINT128_MAX) { 
256             parents[_dragonID].parentTwo = uint128(_parentTwo);
257         }
258     }
259     
260     function setLastAction(uint256 _dragonID, uint256 _lastActionDragonID, uint8 _lastActionID) 
261         external 
262         onlyRole("ActionContract") 
263     {
264         lastActions[_dragonID].lastActionID = _lastActionID;
265         if (_lastActionDragonID > UINT248_MAX) {
266             lastActions[_dragonID].lastActionDragonID = 0;
267         } else {
268             lastActions[_dragonID].lastActionDragonID = uint248(_lastActionDragonID);
269         }
270     }
271     
272     function incFightWin(uint256 _dragonID) external onlyRole("FightContract") {
273         dragonStats[_dragonID].fightWin++;
274     }
275     
276     function incFightLose(uint256 _dragonID) external onlyRole("FightContract") {
277         dragonStats[_dragonID].fightLose++;
278     }
279     
280     function incFightToDeathWin(uint256 _dragonID) external onlyRole("DeathContract") {
281         dragonStats[_dragonID].fightToDeathWin++;
282     }
283     
284     function incChildren(uint256 _dragonID) external onlyRole("MainContract") {
285         dragonStats[_dragonID].children++;
286     }
287     
288     function addMutagenFace(uint256 _dragonID, uint256 _mutagenCount) 
289         external 
290         onlyRole("MutagenFaceContract") 
291     {
292         dragonStats[_dragonID].mutagenFace = dragonStats[_dragonID].mutagenFace + uint32(_mutagenCount);
293     }
294     
295     function addMutagenFight(uint256 _dragonID, uint256 _mutagenCount) 
296         external 
297         onlyRole("MutagenFightContract") 
298     {
299         dragonStats[_dragonID].mutagenFight = dragonStats[_dragonID].mutagenFight + uint32(_mutagenCount);
300     }
301     
302     function incGenLabFace(uint256 _dragonID) external onlyRole("GenLabContract") {
303         dragonStats[_dragonID].genLabFace++;
304     }
305     
306     function incGenLabFight(uint256 _dragonID) external onlyRole("GenLabContract") {
307         dragonStats[_dragonID].genLabFight++;
308     }
309     
310     function getDragonFight(uint256 _dragonID) external view returns (uint256){
311         return  (dragonStats[_dragonID].fightWin + dragonStats[_dragonID].fightLose + dragonStats[_dragonID].fightToDeathWin);
312     }
313 }