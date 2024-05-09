1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 
7 
8 // @title iNovaStaking
9 // @dev The interface for cross-contract calls to the Nova Staking contract
10 // @author Dragon Foundry (https://www.nvt.gg)
11 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
12 contract iNovaStaking {
13 
14   function balanceOf(address _owner) public view returns (uint256);
15 }
16 
17 
18 
19 // @title iNovaGame
20 // @dev The interface for cross-contract calls to the Nova Game contract
21 // @author Dragon Foundry (https://www.nvt.gg)
22 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
23 contract iNovaGame {
24   function isAdminForGame(uint _game, address account) external view returns(bool);
25 
26   // List of all games tracked by the Nova Game contract
27   uint[] public games;
28 }
29 
30 
31 
32 // @title SafeMath
33 // @dev Math operations with safety checks that throw on error
34 library SafeMath {
35 
36   // @dev Multiplies two numbers, throws on overflow.
37   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
38     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (a == 0) {
42       return 0;
43     }
44 
45     c = a * b;
46     require(c / a == b, "mul failed");
47     return c;
48   }
49 
50   // @dev Integer division of two numbers, truncating the quotient.
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     // uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return a / b;
56   }
57 
58   // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b <= a, "sub fail");
61     return a - b;
62   }
63 
64   // @dev Adds two numbers, throws on overflow.
65   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     c = a + b;
67     require(c >= a, "add fail");
68     return c;
69   }
70 }
71 
72 
73 // @title Nova Game Access (Nova Token Game Access Control)
74 // @dev NovaGame contract for controlling access to games, and allowing managers to add and remove operator accounts
75 // @author Dragon Foundry (https://www.nvt.gg)
76 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
77 contract NovaGameAccess is iNovaGame {
78   using SafeMath for uint256;
79 
80   event AdminPrivilegesChanged(uint indexed game, address indexed account, bool isAdmin);
81   event OperatorPrivilegesChanged(uint indexed game, address indexed account, bool isAdmin);
82 
83   // Admin addresses are stored both by gameId and address
84   mapping(uint => address[]) public adminAddressesByGameId; 
85   mapping(address => uint[]) public gameIdsByAdminAddress;
86 
87   // Stores admin status (as a boolean) by gameId and account
88   mapping(uint => mapping(address => bool)) public gameAdmins;
89 
90   // Reference to the Nova Staking contract
91   iNovaStaking public stakingContract;
92 
93   // @dev Access control modifier to limit access to game admin accounts
94   modifier onlyGameAdmin(uint _game) {
95     require(gameAdmins[_game][msg.sender]);
96     _;
97   }
98 
99   constructor(address _stakingContract)
100     public
101   {
102     stakingContract = iNovaStaking(_stakingContract);
103   }
104 
105   // @dev gets the admin status for a game & account
106   // @param _game - the gameId of the game
107   // @param _account - the address of the user
108   // @returns bool - the admin status of the requested account for the requested game
109   function isAdminForGame(uint _game, address _account)
110     external
111     view
112   returns(bool) {
113     return gameAdmins[_game][_account];
114   }
115 
116   // @dev gets the list of admins for a game
117   // @param _game - the gameId of the game
118   // @returns address[] - the list of admin addresses for the requested game
119   function getAdminsForGame(uint _game) 
120     external
121     view
122   returns(address[]) {
123     return adminAddressesByGameId[_game];
124   }
125 
126   // @dev gets the list of games that the requested account is the admin of
127   // @param _account - the address of the user
128   // @returns uint[] - the list of game Ids for the requested account
129   function getGamesForAdmin(address _account) 
130     external
131     view
132   returns(uint[]) {
133     return gameIdsByAdminAddress[_account];
134   }
135 
136   // @dev Adds an address as an admin for a game
137   // @notice Can only be called by an admin of the game
138   // @param _game - the gameId of the game
139   // @param _account - the address of the user
140   function addAdminAccount(uint _game, address _account)
141     external
142     onlyGameAdmin(_game)
143   {
144     require(_account != msg.sender);
145     require(_account != address(0));
146     require(!gameAdmins[_game][_account]);
147     _addAdminAccount(_game, _account);
148   }
149 
150   // @dev Removes an address from an admin for a game
151   // @notice Can only be called by an admin of the game.
152   // @notice Can't remove your own account's admin privileges.
153   // @param _game - the gameId of the game
154   // @param _account - the address of the user to remove admin privileges.
155   function removeAdminAccount(uint _game, address _account)
156     external
157     onlyGameAdmin(_game)
158   {
159     require(_account != msg.sender);
160     require(gameAdmins[_game][_account]);
161     
162     address[] storage opsAddresses = adminAddressesByGameId[_game];
163     uint startingLength = opsAddresses.length;
164     // Yes, "i < startingLength" is right. 0 - 1 == uint.maxvalue, not -1.
165     for (uint i = opsAddresses.length - 1; i < startingLength; i--) {
166       if (opsAddresses[i] == _account) {
167         uint newLength = opsAddresses.length.sub(1);
168         opsAddresses[i] = opsAddresses[newLength];
169         delete opsAddresses[newLength];
170         opsAddresses.length = newLength;
171       }
172     }
173 
174     uint[] storage gamesByAdmin = gameIdsByAdminAddress[_account];
175     startingLength = gamesByAdmin.length;
176     for (i = gamesByAdmin.length - 1; i < startingLength; i--) {
177       if (gamesByAdmin[i] == _game) {
178         newLength = gamesByAdmin.length.sub(1);
179         gamesByAdmin[i] = gamesByAdmin[newLength];
180         delete gamesByAdmin[newLength];
181         gamesByAdmin.length = newLength;
182       }
183     }
184 
185     gameAdmins[_game][_account] = false;
186     emit AdminPrivilegesChanged(_game, _account, false);
187   }
188 
189   // @dev Adds an address as an admin for a game
190   // @notice Can only be called by an admin of the game
191   // @notice Operator privileges are managed on the layer 2 network
192   // @param _game - the gameId of the game
193   // @param _account - the address of the user to
194   // @param _isOperator - "true" to grant operator privileges, "false" to remove them
195   function setOperatorPrivileges(uint _game, address _account, bool _isOperator)
196     external
197     onlyGameAdmin(_game)
198   {
199     emit OperatorPrivilegesChanged(_game, _account, _isOperator);
200   }
201 
202   // @dev Internal function to add an address as an admin for a game
203   // @param _game - the gameId of the game
204   // @param _account - the address of the user
205   function _addAdminAccount(uint _game, address _account)
206     internal
207   {
208     address[] storage opsAddresses = adminAddressesByGameId[_game];
209     require(opsAddresses.length < 256, "a game can only have 256 admins");
210     for (uint i = opsAddresses.length; i < opsAddresses.length; i--) {
211       require(opsAddresses[i] != _account);
212     }
213 
214     uint[] storage gamesByAdmin = gameIdsByAdminAddress[_account];
215     require(gamesByAdmin.length < 256, "you can only own 256 games");
216     for (i = gamesByAdmin.length; i < gamesByAdmin.length; i--) {
217       require(gamesByAdmin[i] != _game, "you can't become an operator twice");
218     }
219     gamesByAdmin.push(_game);
220 
221     opsAddresses.push(_account);
222     gameAdmins[_game][_account] = true;
223     emit AdminPrivilegesChanged(_game, _account, true);
224   }
225 }
226 
227 
228 // @title Nova Game (Nova Token Game Data)
229 // @dev NovaGame contract for managing all game data
230 // @author Dragon Foundry (https://www.nvt.gg)
231 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
232 contract NovaGame is NovaGameAccess {
233 
234   struct GameData {
235     string json;
236     uint tradeLockSeconds;
237     bytes32[] metadata;
238   }
239 
240   event GameCreated(uint indexed game, address indexed owner, string json, bytes32[] metadata);
241 
242   event GameMetadataUpdated(
243     uint indexed game, 
244     string json,
245     uint tradeLockSeconds, 
246     bytes32[] metadata
247   );
248 
249   mapping(uint => GameData) internal gameData;
250 
251   constructor(address _stakingContract) 
252     public 
253     NovaGameAccess(_stakingContract)
254   {
255     games.push(2**32);
256   }
257 
258   // @dev Create a new game by setting its data. 
259   //   Created games are initially owned and managed by the game's creator
260   // @notice - there's a maximum of 2^32 games (4.29 billion games)
261   // @param _json - a json encoded string containing the game's name, uri, logo, description, etc
262   // @param _tradeLockSeconds - the number of seconds a card remains locked to a purchaser's account
263   // @param _metadata - game-specific metadata, in bytes32 format. 
264   function createGame(string _json, uint _tradeLockSeconds, bytes32[] _metadata) 
265     external
266   returns(uint _game) {
267     // Create the game
268     _game = games.length;
269     require(_game < games[0], "too many games created");
270     games.push(_game);
271 
272     // Log the game as created
273     emit GameCreated(_game, msg.sender, _json, _metadata);
274 
275     // Add the creator as the first game admin
276     _addAdminAccount(_game, msg.sender);
277 
278     // Store the game's metadata
279     updateGameMetadata(_game, _json, _tradeLockSeconds, _metadata);
280   }
281 
282   // @dev Gets the number of games in the system
283   // @returns the number of games stored in the system
284   function numberOfGames() 
285     external
286     view
287   returns(uint) {
288     return games.length;
289   }
290 
291   // @dev Get all game data for one given game
292   // @param _game - the # of the game
293   // @returns game - the game ID of the requested game
294   // @returns json - the json data of the game
295   // @returns tradeLockSeconds - the number of card sets
296   // @returns balance - the Nova Token balance 
297   // @returns metadata - a bytes32 array of metadata used by the game
298   function getGameData(uint _game)
299     external
300     view
301   returns(uint game,
302     string json,
303     uint tradeLockSeconds,
304     uint256 balance,
305     bytes32[] metadata) 
306   {
307     GameData storage data = gameData[_game];
308     game = _game;
309     json = data.json;
310     tradeLockSeconds = data.tradeLockSeconds;
311     balance = stakingContract.balanceOf(address(_game));
312     metadata = data.metadata;
313   }
314 
315   // @dev Update the json, trade lock, and metadata for a single game
316   // @param _game - the # of the game
317   // @param _json - a json encoded string containing the game's name, uri, logo, description, etc
318   // @param _tradeLockSeconds - the number of seconds a card remains locked to a purchaser's account
319   // @param _metadata - game-specific metadata, in bytes32 format. 
320   function updateGameMetadata(uint _game, string _json, uint _tradeLockSeconds, bytes32[] _metadata)
321     public
322     onlyGameAdmin(_game)
323   {
324     gameData[_game].tradeLockSeconds = _tradeLockSeconds;
325     gameData[_game].json = _json;
326 
327     bytes32[] storage data = gameData[_game].metadata;
328     if (_metadata.length > data.length) { data.length = _metadata.length; }
329     for (uint k = 0; k < _metadata.length; k++) { data[k] = _metadata[k]; }
330     for (k; k < data.length; k++) { delete data[k]; }
331     if (_metadata.length < data.length) { data.length = _metadata.length; }
332 
333     emit GameMetadataUpdated(_game, _json, _tradeLockSeconds, _metadata);
334   }
335 }