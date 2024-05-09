1 pragma solidity 0.4.19;
2 
3 
4 contract IConnections {
5     // Forward = the connection is from the Connection creator to the specified recipient
6     // Backwards = the connection is from the specified recipient to the Connection creator
7     enum Direction {NotApplicable, Forwards, Backwards, Invalid}
8     function createUser() external returns (address entityAddress);
9     function createUserAndConnection(address _connectionTo, bytes32 _connectionType, Direction _direction) external returns (address entityAddress);
10     function createVirtualEntity() external returns (address entityAddress);
11     function createVirtualEntityAndConnection(address _connectionTo, bytes32 _connectionType, Direction _direction) external returns (address entityAddress);
12     function editEntity(address _entity, bool _active, bytes32 _data) external;
13     function transferEntityOwnerPush(address _entity, address _newOwner) external;
14     function transferEntityOwnerPull(address _entity) external;
15     function addConnection(address _entity, address _connectionTo, bytes32 _connectionType, Direction _direction) public;
16     function editConnection(address _entity, address _connectionTo, bytes32 _connectionType, Direction _direction, bool _active, bytes32 _data, uint _expiration) external;
17     function removeConnection(address _entity, address _connectionTo, bytes32 _connectionType) external;
18     function isUser(address _entity) view public returns (bool isUserEntity);
19     function getEntity(address _entity) view external returns (bool active, address transferOwnerTo, bytes32 data, address owner);
20     function getConnection(address _entity, address _connectionTo, bytes32 _connectionType) view external returns (bool entityActive, bool connectionEntityActive, bool connectionActive, bytes32 data, Direction direction, uint expiration);
21 
22     // ################## Events ################## //
23     event entityAdded(address indexed entity, address indexed owner);
24     event entityModified(address indexed entity, address indexed owner, bool indexed active, bytes32 data);
25     event entityOwnerChangeRequested(address indexed entity, address indexed oldOwner, address newOwner);
26     event entityOwnerChanged(address indexed entity, address indexed oldOwner, address newOwner);
27     event connectionAdded(address indexed entity, address indexed connectionTo, bytes32 connectionType, Direction direction);
28     event connectionModified(address indexed entity, address indexed connectionTo, bytes32 indexed connectionType, Direction direction, bool active, uint expiration);
29     event connectionRemoved(address indexed entity, address indexed connectionTo, bytes32 indexed connectionType);
30     event entityResolved(address indexed entityRequested, address indexed entityResolved);    
31 }
32 
33 
34 /**
35  * @title Connections v0.2
36  * @dev The Connections contract records different connections between different types of entities.
37  *
38  * The contract has been designed for flexibility and scalability for use by anyone wishing to record different types of connections.
39  *
40  * Entities can be Users representing People, or Virtual Entities representing abstract types such as companies, objects, devices, robots etc...
41  * User entities are special: each Ethereum address that creates or controls a User entity can only ever create one User Entity.
42  * Each entity has an address to refer to it.
43  *
44  * Each entity has a number of connections to other entities, which are refered to using the entities address that the connection is to.
45  * Modifying or removing entities, or adding, modifying or removing connections can only be done by the entity owner.
46  *
47  * Each connection also has a type, a direction and an expiration. The use of these fields is up to the Dapp to define and interprete.
48  * Hashing a string of the connection name to create the connection type is suggested to obscure and diffuse types. Example bytes32 connection types:
49  *     0x30ed9383ab64b27cb4b70035e743294fe1a1c83eaf57eca05033b523d1fa4261 = keccak256("isAdvisorOf")
50  *     0xffe72ffb7d5cc4224f27ea8ad324f4b53b37835a76fc2b627b3d669180b75ecc = keccak256("isPartneredWith")
51  *     0xa64b51178a7ee9735fb96d8e7ffdebb455b02beb3b1e17a709b5c1beef797405 = keccak256("isEmployeeOf")
52  *     0x0079ca0c877589ba53b2e415a660827390d2c2a62123cef473009d003577b7f6 = keccak256("isColleagueOf")
53  *
54  */
55 contract Connections is IConnections {
56 
57     struct Entity {
58         bool active;
59         address transferOwnerTo;
60         address owner;
61         bytes32 data; // optional, this can link to IPFS or another off-chain storage location
62         mapping (address => mapping (bytes32 => Connection)) connections;
63     }
64 
65     // Connection has a type and direction
66     struct Connection {
67         bool active;
68         bytes32 data; // optional, this can link to IPFS or another off-chain storage location
69         Direction direction;
70         uint expiration; // optional, unix timestamp or latest date to assume this connection is valid, 0 as no expiration
71     }
72 
73     mapping (address => Entity) public entities;
74     mapping (address => address) public entityOfUser;
75     uint256 public virtualEntitiesCreated = 0;
76 
77     // ################## Constructor and Fallback function ################## //
78     /**
79      * Constructor
80      */
81     function Connections() public {}
82 
83     /**
84      * Fallback function that cannot be called and will not accept Ether
85      * Note that Ether can still be forced to this contract with a contract suicide()
86      */
87     function () external {
88         revert();
89     }
90 
91 
92     // ################## External function ################## //
93     /**
94      * Creates a new user entity with an address of the msg.sender
95      */
96     function createUser() external returns (address entityAddress) {
97         entityAddress = msg.sender;
98         assert(entityOfUser[msg.sender] == address(0));
99         createEntity(entityAddress, msg.sender);
100         entityOfUser[msg.sender] = entityAddress;
101     }
102 
103     /**
104      * Creates a new user entity and a connection in one transaction
105      * @param _connectionTo - the address of the entity to connect to
106      * @param _connectionType - hash of the connection type
107      * @param _direction - indicates the direction of the connection type
108      */
109     function createUserAndConnection(
110         address _connectionTo,
111         bytes32 _connectionType,
112         Direction _direction
113     )
114         external returns (address entityAddress)
115     {
116         entityAddress = msg.sender;
117         assert(entityOfUser[msg.sender] == address(0));
118         createEntity(entityAddress, msg.sender);
119         entityOfUser[msg.sender] = entityAddress;
120         addConnection(entityAddress, _connectionTo, _connectionType, _direction);
121     }
122 
123     /**
124      * Creates a new virtual entity that is assigned to a unique address
125      */
126     function createVirtualEntity() external returns (address entityAddress) {
127         entityAddress = createVirtualAddress();
128         createEntity(entityAddress, msg.sender);
129     }
130 
131     /**
132      * Creates a new virtual entity and a connection in one transaction
133      * @param _connectionTo - the address of the entity to connect to
134      * @param _connectionType - hash of the connection type
135      * @param _direction - indicates the direction of the connection type
136      */
137     function createVirtualEntityAndConnection(
138         address _connectionTo,
139         bytes32 _connectionType,
140         Direction _direction
141     )
142         external returns (address entityAddress)
143     {
144         entityAddress = createVirtualAddress();
145         createEntity(entityAddress, msg.sender);
146         addConnection(entityAddress, _connectionTo, _connectionType, _direction);
147     }
148 
149     /**
150      * Edits data or active boolean of an entity that the msg sender is an owner of
151      * This can be used to activate or deactivate an entity
152      * @param _entity - the address of the entity to edit
153      * @param _active - boolean to indicate if the entity is active or not
154      * @param _data - data to be used to locate off-chain information about the user
155      */
156     function editEntity(address _entity, bool _active, bytes32 _data) external {
157         address resolvedEntity = resolveEntityAddressAndOwner(_entity);
158         Entity storage entity = entities[resolvedEntity];
159         entity.active = _active;
160         entity.data = _data;
161         entityModified(_entity, msg.sender, _active, _data);
162     }
163 
164     /**
165      * Creates a request to transfer the ownership of an entity which must be accepted.
166      * To cancel a request execute this function with _newOwner = address(0)
167      * @param _entity - the address of the entity to transfer
168      * @param _newOwner - the address of the new owner that will then have the exclusive permissions to control the entity
169      */
170     function transferEntityOwnerPush(address _entity, address _newOwner) external {
171         address resolvedEntity = resolveEntityAddressAndOwner(_entity);
172         entities[resolvedEntity].transferOwnerTo = _newOwner;
173         entityOwnerChangeRequested(_entity, msg.sender, _newOwner);
174     }
175 
176     /**
177      * Accepts a request to transfer the ownership of an entity
178      * @param _entity - the address of the entity to get ownership of
179      */
180     function transferEntityOwnerPull(address _entity) external {
181         address resolvedEntity = resolveEntityAddress(_entity);
182         emitEntityResolution(_entity, resolvedEntity);
183         Entity storage entity = entities[resolvedEntity];
184         require(entity.transferOwnerTo == msg.sender);
185         if (isUser(resolvedEntity)) { // This is a user entity
186             assert(entityOfUser[msg.sender] == address(0) ||
187                    entityOfUser[msg.sender] == resolvedEntity);
188             entityOfUser[msg.sender] = resolvedEntity;
189         }
190         address oldOwner = entity.owner;
191         entity.owner = entity.transferOwnerTo;
192         entity.transferOwnerTo = address(0);
193         entityOwnerChanged(_entity, oldOwner, msg.sender);
194     }
195 
196     /**
197      * Edits a connection to another entity
198      * @param _entity - the address of the entity to edit the connection of
199      * @param _connectionTo - the address of the entity to connect to
200      * @param _connectionType - hash of the connection type
201      * @param _active - boolean to indicate if the connection is active or not
202      * @param _direction - indicates the direction of the connection type
203      * @param _expiration - number to indicate the expiration of the connection
204      */
205     function editConnection(
206         address _entity,
207         address _connectionTo,
208         bytes32 _connectionType,
209         Direction _direction,
210         bool _active,
211         bytes32 _data,
212         uint _expiration
213     )
214         external
215     {
216         address resolvedEntity = resolveEntityAddressAndOwner(_entity);
217         address resolvedConnectionEntity = resolveEntityAddress(_connectionTo);
218         emitEntityResolution(_connectionTo, resolvedConnectionEntity);
219         Entity storage entity = entities[resolvedEntity];
220         Connection storage connection = entity.connections[resolvedConnectionEntity][_connectionType];
221         connection.active = _active;
222         connection.direction = _direction;
223         connection.data = _data;
224         connection.expiration = _expiration;
225         connectionModified(_entity, _connectionTo, _connectionType, _direction, _active, _expiration);
226     }
227 
228     /**
229      * Removes a connection from the entities connections mapping.
230      * If this is the last connection of any type to the _connectionTo address, then the removeConnection function should also be called to clean up the Entity
231      * @param _entity - the address of the entity to edit the connection of
232      * @param _connectionTo - the address of the entity to connect to
233      * @param _connectionType - hash of the connection type
234      */
235     function removeConnection(address _entity, address _connectionTo, bytes32 _connectionType) external {
236         address resolvedEntity = resolveEntityAddressAndOwner(_entity);
237         address resolvedConnectionEntity = resolveEntityAddress(_connectionTo);
238         emitEntityResolution(_connectionTo,resolvedConnectionEntity);
239         Entity storage entity = entities[resolvedEntity];
240         delete entity.connections[resolvedConnectionEntity][_connectionType];
241         connectionRemoved(_entity, _connectionTo, _connectionType); // TBD: @haresh should we use resolvedEntity and resolvedConnectionEntity here?
242     }
243 
244     /**
245      * Returns the sha256 hash of a string. Useful for looking up the bytes32 values are for connection types.
246      * Note this function is designed to be called off-chain for convenience, it is not used by any functions internally and does not change contract state
247      * @param _string - string to hash
248      * @return result - the hash of the string
249      */
250     function sha256ofString(string _string) external pure returns (bytes32 result) {
251         result = keccak256(_string);
252     }
253 
254     /**
255      * Returns all the fields of an entity
256      * @param _entity - the address of the entity to retrieve
257      * @return (active, transferOwnerTo, data, owner) - a tuple containing the active flag, transfer status, data field and owner of an entity
258      */
259     function getEntity(address _entity) view external returns (bool active, address transferOwnerTo, bytes32 data, address owner) {
260         address resolvedEntity = resolveEntityAddress(_entity);
261         Entity storage entity = entities[resolvedEntity];
262         return (entity.active, entity.transferOwnerTo, entity.data, entity.owner);
263     }
264 
265     /**
266      * Returns details of a connection
267      * @param _entity - the address of the entity which created the
268      * @return (entityActive, connectionEntityActive, connectionActive, data, direction, expiration)
269      *                - tupple containing the entity active and the connection fields
270      */
271     function getConnection(
272         address _entity,
273         address _connectionTo,
274         bytes32 _connectionType
275     )
276         view external returns (
277             bool entityActive,
278             bool connectionEntityActive,
279             bool connectionActive,
280             bytes32 data,
281             Direction direction,
282             uint expiration
283     ){
284         address resolvedEntity = resolveEntityAddress(_entity);
285         address resolvedConnectionEntity = resolveEntityAddress(_connectionTo);
286         Entity storage entity = entities[resolvedEntity];
287         Connection storage connection = entity.connections[resolvedConnectionEntity][_connectionType];
288         return (entity.active, entities[resolvedConnectionEntity].active, connection.active, connection.data, connection.direction, connection.expiration);
289     }
290 
291 
292     // ################## Public function ################## //
293     /**
294      * Creates a new connection to another entity
295      * @param _entity - the address of the entity to add a connection to
296      * @param _connectionTo - the address of the entity to connect to
297      * @param _connectionType - hash of the connection type
298      * @param _direction - indicates the direction of the connection type
299      */
300     function addConnection(
301         address _entity,
302         address _connectionTo,
303         bytes32 _connectionType,
304         Direction _direction
305     )
306         public
307     {
308         address resolvedEntity = resolveEntityAddressAndOwner(_entity);
309         address resolvedEntityConnection = resolveEntityAddress(_connectionTo);
310         emitEntityResolution(_connectionTo, resolvedEntityConnection);
311         Entity storage entity = entities[resolvedEntity];
312         assert(!entity.connections[resolvedEntityConnection][_connectionType].active);
313         Connection storage connection = entity.connections[resolvedEntityConnection][_connectionType];
314         connection.active = true;
315         connection.direction = _direction;
316         connectionAdded(_entity, _connectionTo, _connectionType, _direction);
317     }
318 
319     /**
320      * Returns true if an entity is a user, false if a virtual entity or fails if is not an entity
321      * @param _entity - the address of the entity
322      * @return isUserEntity - true if the entity was created with createUser(), false if the entity is created using createVirtualEntity()
323      */
324     function isUser(address _entity) view public returns (bool isUserEntity) {
325         address resolvedEntity = resolveEntityAddress(_entity);
326         assert(entities[resolvedEntity].active); // Make sure the user is active, otherwise this function call is invalid
327         address owner = entities[resolvedEntity].owner;
328         isUserEntity = (resolvedEntity == entityOfUser[owner]);
329     }
330 
331 
332     // ################## Internal functions ################## //
333     /**
334      * Creates a new entity at a specified address
335      */
336     function createEntity(address _entityAddress, address _owner) internal {
337         require(!entities[_entityAddress].active); // Ensure the new entity address is not in use, prevents forceful takeover off addresses
338         Entity storage entity = entities[_entityAddress];
339         entity.active = true;
340         entity.owner = _owner;
341         entityAdded(_entityAddress, _owner);
342     }
343 
344     /**
345      * Returns a new unique deterministic address that has not been used before
346      */
347     function createVirtualAddress() internal returns (address virtualAddress) {
348         virtualAddress = address(keccak256(safeAdd(virtualEntitiesCreated,block.number)));
349         virtualEntitiesCreated = safeAdd(virtualEntitiesCreated,1);
350     }
351 
352     /**
353      * Emits an event if an entity resolution took place. Separated out as it would impact
354      * view only functions which need entity resolution as well.
355      */
356     function emitEntityResolution(address _entity, address _resolvedEntity) internal {
357         if (_entity != _resolvedEntity)
358             entityResolved(_entity,_resolvedEntity);
359     }
360 
361     /**
362      * Returns the correct entity address resolved based on entityOfUser mapping
363      */
364     function resolveEntityAddress(address _entityAddress) internal view returns (address resolvedAddress) {
365         if (entityOfUser[_entityAddress] != address(0) && entityOfUser[_entityAddress] != _entityAddress) {
366             resolvedAddress = entityOfUser[_entityAddress];
367         } else {
368             resolvedAddress = _entityAddress;
369         }
370     }
371 
372     /**
373      * Returns the correct entity address resolved based on entityOfUser mapping and also reverts if the
374      * resolved if it is owned by the message sender
375      * sender.
376      */
377     function resolveEntityAddressAndOwner(address _entityAddress) internal returns (address entityAddress) {
378         entityAddress = resolveEntityAddress(_entityAddress);
379         emitEntityResolution(_entityAddress, entityAddress);
380         require(entities[entityAddress].owner == msg.sender);
381     }
382 
383     /**
384      * Adds two numbers and returns result throws in case an overflow occurs.
385      */
386     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
387       uint256 z = x + y;
388       assert(z >= x);
389       return z;
390     }    
391 
392 }