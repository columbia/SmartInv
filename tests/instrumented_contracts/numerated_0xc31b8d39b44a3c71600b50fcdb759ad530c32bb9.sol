1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 //-----------------------------------------------------------------------------
5 /// @title Ownable
6 /// @dev The Ownable contract has an owner address, and provides basic authorization
7 /// control functions, this simplifies the implementation of "user permissions".
8 //-----------------------------------------------------------------------------
9 contract Ownable {
10     address private _owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor () internal {
19         _owner = msg.sender;
20         emit OwnershipTransferred(address(0), _owner);
21     }
22 
23     /**
24      * @return the address of the owner.
25      */
26     function owner() public view returns (address) {
27         return _owner;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(isOwner());
35         _;
36     }
37 
38     /**
39      * @return true if `msg.sender` is the owner of the contract.
40      */
41     function isOwner() public view returns (bool) {
42         return msg.sender == _owner;
43     }
44 
45     /**
46      * @dev Allows the current owner to relinquish control of the contract.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      * @notice Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 
77 //-----------------------------------------------------------------------------
78 /// @title Crusades Configurations
79 //-----------------------------------------------------------------------------
80 contract CrusadesConfig is Ownable {
81     //=========================================================================
82     // RESOURCES
83     //=========================================================================
84     string[] public resourceTypes;
85     
86     function addNewResourceType (string calldata _description) external onlyOwner {
87         resourceTypes.push(_description);
88     }
89     
90     function resourcesLength () external view returns (uint) {
91         return resourceTypes.length;
92     }
93     
94     //=========================================================================
95     // PLANET
96     //=========================================================================
97     struct CrusadesTileData {
98         string description;
99         uint weight;
100         mapping (uint => uint) resourceIdToYield;
101     }
102     struct CrusadesCoordinates {
103         uint x;
104         uint y;
105     }
106     struct CrusadesPlanetTile {
107         uint tileDataId;                        // id of the data
108         uint cityId;                            // The ID of the city on this tile. 0 if none.
109         // an array of coordinates of all neighboring tiles
110         // neighbors[0] = up + left
111         // neighbors[1] = up
112         // neighbors[2] = up + right
113         // neighbors[3] = down + left
114         // neighbors[4] = down
115         // neighbors[5] = down + right
116         CrusadesCoordinates[6] neighbors;
117         
118     }
119     
120     mapping (uint => CrusadesTileData) public idToTileData;
121     mapping (uint => mapping (uint => CrusadesPlanetTile)) public planetTiles;
122 
123     function setTileData (
124         uint _tileId, 
125         string calldata _description, 
126         uint _weight,
127         uint[] calldata _resourceYields
128     ) external onlyOwner {
129         require (_resourceYields.length == resourceTypes.length);
130         CrusadesTileData storage tileData = idToTileData[_tileId];
131         tileData.description = _description;
132         tileData.weight = _weight;
133         for (uint i = 0; i < _resourceYields.length; ++i) {
134             tileData.resourceIdToYield[i] = _resourceYields[i];
135         }
136     }
137 
138     function initializePlanetTile (
139         uint _xCoordinate, 
140         uint _yCoordinate, 
141         uint _tileDataId
142     ) external onlyOwner {
143         CrusadesPlanetTile storage planetTile = planetTiles[_xCoordinate][_yCoordinate];
144         planetTile.tileDataId = _tileDataId;
145         
146         // TODO: EDGE CHECKING FOR WRAPPING OF COORDINATES ON GLOBE
147         // neighbor up + left
148         planetTile.neighbors[0].x = _xCoordinate - 1;
149         planetTile.neighbors[0].y = _yCoordinate - 1;
150         
151         // neighbor up
152         planetTile.neighbors[1].x = _xCoordinate;
153         planetTile.neighbors[1].y = _yCoordinate - 1;
154         
155         // neighbor up + right
156         planetTile.neighbors[2].x = _xCoordinate + 1;
157         planetTile.neighbors[2].y = _yCoordinate - 1;
158         
159         // neighbor down + left
160         planetTile.neighbors[3].x = _xCoordinate - 1;
161         planetTile.neighbors[3].y = _yCoordinate + 1;
162         
163         // neighbor up + left
164         planetTile.neighbors[4].x = _xCoordinate;
165         planetTile.neighbors[4].y = _yCoordinate + 1;
166         
167         // neighbor up + left
168         planetTile.neighbors[5].x = _xCoordinate + 1;
169         planetTile.neighbors[5].y = _yCoordinate + 1;
170     }
171 
172     function addCityToPlanetTile (
173         uint _xCoordinate, 
174         uint _yCoordinate, 
175         uint _cityId
176     ) external onlyOwner {
177         planetTiles[_xCoordinate][_yCoordinate].cityId = _cityId;
178     }
179     
180     function getPlanetTile(uint _xCoordinate, uint _yCoordinate) external view returns (
181         uint tileDataId,
182         uint cityId,
183         uint[] memory neighborsXCoordinates,
184         uint[] memory neighborsYCoordinates
185     ) {
186         tileDataId = planetTiles[_xCoordinate][_yCoordinate].tileDataId;
187         cityId = planetTiles[_xCoordinate][_yCoordinate].cityId;
188         neighborsXCoordinates = new uint[](6);
189         neighborsYCoordinates = new uint[](6);
190         for (uint i = 0; i < 6; ++i) {
191             neighborsXCoordinates[i] = planetTiles[_xCoordinate][_yCoordinate].neighbors[i].x;
192             neighborsYCoordinates[i] = planetTiles[_xCoordinate][_yCoordinate].neighbors[i].y;
193         }
194     }
195     
196     function getResourceYield(uint _tileId) external view returns (uint[] memory resources) {
197         resources = new uint[](resourceTypes.length);
198         for (uint i = 0; i < resources.length; ++i) {
199             resources[i] = idToTileData[_tileId].resourceIdToYield[i];
200         }
201     }
202     
203     function getNeighbors(uint _originX, uint _originY, uint _distance) external view returns (
204         uint[] memory neighborsXCoordinates, 
205         uint[] memory neighborsYCoordinates
206     ) {
207         require (_distance > 0 && _distance < 3);
208         // the formula is 3n^2 + 3n
209         neighborsXCoordinates = new uint[]((_distance ** 2 * 3) + (3 * _distance));
210         neighborsYCoordinates = new uint[]((_distance ** 2 * 3) + (3 * _distance));
211         for (uint i = 0; i < 6; ++i) {
212             if (planetTiles[_originX][_originY].neighbors[i].x != 0 || planetTiles[_originX][_originY].neighbors[i].y != 0) {
213                 neighborsXCoordinates[i] = planetTiles[_originX][_originY].neighbors[i].x;
214                 neighborsYCoordinates[i] = planetTiles[_originX][_originY].neighbors[i].y;
215             }
216             if (_distance == 2) {
217                 for(i = 0; i < 6; ++i) {
218                     if (planetTiles[_originX][_originY].neighbors[i].x != 0 || planetTiles[_originX][_originY].neighbors[i].y != 0) {
219                         neighborsXCoordinates[i] = planetTiles[_originX][_originY].neighbors[i].x;
220                         neighborsYCoordinates[i] = planetTiles[_originX][_originY].neighbors[i].y;
221                     }
222                 }
223             }
224         }
225     }
226     
227     function getHarvest(uint _originX, uint _originY) external view returns (
228         uint[] memory
229     ) {
230         // the formula is 3n^2 + 3n
231         CrusadesCoordinates[] memory neighborCoordinates = new CrusadesCoordinates[](6);
232         for (uint i = 0; i < 6; ++i) {
233             if (planetTiles[_originX][_originY].neighbors[i].x != 0 || planetTiles[_originX][_originY].neighbors[i].y != 0) {
234                 neighborCoordinates[i] = planetTiles[_originX][_originY].neighbors[i];
235             }
236         }
237         
238         uint[] memory resourcesToHarvest = new uint[](resourceTypes.length);
239         for (uint i = 0; i < neighborCoordinates.length; ++i) {
240             uint tileId = planetTiles[neighborCoordinates[i].x][neighborCoordinates[i].y].tileDataId;
241             for (uint j = 0; j < resourceTypes.length; ++j) {
242                 resourcesToHarvest[j] += idToTileData[tileId].resourceIdToYield[j];
243             }
244         }
245     }
246     
247     //=========================================================================
248     // TROOPS
249     //=========================================================================
250     struct CrusadesTroopData {
251         string description;
252         mapping (uint => uint) troopAttributeIdToValue;
253         mapping (uint => uint) resourceIdToCost;
254     }
255     
256     mapping (uint => CrusadesTroopData) public idToTroopData;
257     mapping (uint => mapping (uint => int)) public typeIdToTypeIdToEffectiveness;
258     string[] public troopAttributes;
259 
260     
261     function addNewTroopAttribute (string calldata _description) external onlyOwner {
262         troopAttributes.push(_description);
263     }
264     
265     function initializeTroopData (
266         uint _troopId,
267         string calldata _description,
268         uint[] calldata _troopAttributeValues,
269         uint[] calldata _resourceCosts
270     ) external onlyOwner {
271         require (_resourceCosts.length == resourceTypes.length);
272         require (_troopAttributeValues.length == troopAttributes.length);
273         CrusadesTroopData storage troopData = idToTroopData[_troopId];
274         troopData.description = _description;
275         for (uint i = 0; i < _troopAttributeValues.length; ++i) {
276             troopData.troopAttributeIdToValue[i] = _troopAttributeValues[i];
277         }
278         for(uint i = 0; i < _resourceCosts.length; ++i) {
279             troopData.resourceIdToCost[i] = _resourceCosts[i];
280         }
281     }
282     
283     function getTroopAttributeValue(uint _troopId, uint _attributeId) external view returns (uint) {
284         return idToTroopData[_troopId].troopAttributeIdToValue[_attributeId];
285     }
286     
287     function getTroopResourceCost(uint _troopId, uint _resourceId) external view returns (uint) {
288         return idToTroopData[_troopId].resourceIdToCost[_resourceId];
289     }
290     
291     //=========================================================================
292     // MODIFIERS
293     //=========================================================================
294     string[] public modifiers;
295     function addNewModifier (string calldata _description) external onlyOwner {
296         modifiers.push(_description);
297     }
298     function modifiersLength () external view returns (uint) {
299         return modifiers.length;
300     }
301     
302     //=========================================================================
303     // POLICIES
304     //=========================================================================
305     struct CrusadesPolicyData {
306         string description;
307         mapping (uint => uint) resourceIdToCost;
308         mapping (uint => bool) policyIdToRequired;
309         mapping (uint => int) modifierIdToAmountChangedByThisPolicy;
310     }
311     
312     mapping (uint => CrusadesPolicyData) public idToPolicyData;
313     
314     function setPolicyData (
315         uint _policyId,
316         string calldata _description,
317         uint[] calldata _resourceCosts, 
318         uint[] calldata _requirements, 
319         int[] calldata _modifiers
320     ) external onlyOwner {
321         require (_resourceCosts.length == resourceTypes.length);
322         require (_modifiers.length == modifiers.length);
323         CrusadesPolicyData storage policyData = idToPolicyData[_policyId];
324         policyData.description = _description;
325         for (uint i = 0; i < _resourceCosts.length; ++i) {
326             policyData.resourceIdToCost[i] = _resourceCosts[i];
327         }
328         for (uint i = 0; i < _requirements.length; ++i) {
329             policyData.policyIdToRequired[_requirements[i]] = true;
330         }
331         for (uint i = 0; i < _modifiers.length; ++i){
332             policyData.modifierIdToAmountChangedByThisPolicy[i] = _modifiers[i];
333         }
334     }
335     
336     //=========================================================================
337     // BUILDINGS
338     //=========================================================================
339     struct CrusadesBuildingData {
340         string description;
341         mapping (uint => mapping(uint => uint)) buildingLevelToAttributeIdToValue;
342         mapping (uint => mapping(uint => uint)) buildingLevelToResourceIdToCost;
343     }
344     
345     mapping (uint => CrusadesBuildingData) public idToBuildingData;
346     string[] public buildingAttributes;
347     
348     function addNewBuildingAttribute (string calldata _description) external onlyOwner {
349         buildingAttributes.push(_description);
350     }
351     
352     function initializeBuildingData (
353         uint _buildingId,
354         string calldata _description
355     ) external onlyOwner {
356         idToBuildingData[_buildingId].description = _description;
357     }
358     
359     function setBuildingAttributesByLevel(
360         uint _buildingId, 
361         uint _buildingLevel, 
362         uint[] calldata _attributeValues
363     ) external onlyOwner {
364         require(_attributeValues.length == buildingAttributes.length);
365         for (uint i = 0; i < _attributeValues.length; ++i) {
366             idToBuildingData[_buildingId].buildingLevelToAttributeIdToValue[_buildingLevel][i] = _attributeValues[i];
367         }
368         
369     }
370     
371     function setBuildingCostsByLevel(
372         uint _buildingId,
373         uint _buildingLevel,
374         uint[] calldata _resourceCosts
375     ) external onlyOwner {
376         require(_resourceCosts.length == resourceTypes.length);
377         for(uint i = 0; i < _resourceCosts.length; ++i) {
378             idToBuildingData[_buildingId].buildingLevelToResourceIdToCost[_buildingLevel][i] = _resourceCosts[i];
379         }
380     }
381     
382     function getBuildingAttributeValue(
383         uint _buildingId,
384         uint _buildingLevel,
385         uint _attributeId
386     ) external view returns (uint) {
387         return idToBuildingData[_buildingId].buildingLevelToAttributeIdToValue[_buildingLevel][_attributeId];
388     }
389     
390     function getBuildingResourceCost(
391         uint _buildingId, 
392         uint _buildingLevel, 
393         uint _resourceId
394     ) external view returns (uint) {
395         return idToBuildingData[_buildingId].buildingLevelToResourceIdToCost[_buildingLevel][_resourceId];
396     }
397     
398     //=========================================================================
399     // OTHER CONFIGURATIONS
400     //=========================================================================
401     uint public cityPrice = 1 ether / 5;
402     uint public harvestInterval = 1 hours;
403     uint public maxHarvests = 8;
404     string[] public customizations;
405     mapping (uint => string) public customizationIdToSkin;
406     mapping (uint => string) public customizationIdToChroma;
407     
408     function changeCityPrice(uint _newPrice) external onlyOwner {
409         require (_newPrice > 0);
410         cityPrice = _newPrice;
411     }
412     
413     function changeHarvestInterval(uint _newInterval) external onlyOwner {
414         require (_newInterval > 0);
415         cityPrice = _newInterval;
416     }
417 }