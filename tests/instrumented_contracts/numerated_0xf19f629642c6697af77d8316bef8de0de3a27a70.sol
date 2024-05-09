1 pragma solidity ^0.5.10;
2 
3 /// @title Owned
4 /// @author Adrià Massanet <adria@codecontext.io>
5 /// @notice The Owned contract has an owner address, and provides basic 
6 ///  authorization control functions, this simplifies & the implementation of
7 ///  user permissions; this contract has three work flows for a change in
8 ///  ownership, the first requires the new owner to validate that they have the
9 ///  ability to accept ownership, the second allows the ownership to be
10 ///  directly transfered without requiring acceptance, and the third allows for
11 ///  the ownership to be removed to allow for decentralization 
12 contract Owned {
13 
14     address public owner;
15     address public newOwnerCandidate;
16 
17     event OwnershipRequested(address indexed by, address indexed to);
18     event OwnershipTransferred(address indexed from, address indexed to);
19     event OwnershipRemoved();
20 
21     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
22     constructor() public {
23         owner = msg.sender;
24     }
25 
26     /// @dev `owner` is the only address that can call a function with this
27     /// modifier
28     modifier onlyOwner() {
29         require (msg.sender == owner);
30         _;
31     }
32     
33     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
34     ///  be called first by the current `owner` then `acceptOwnership()` must be
35     ///  called by the `newOwnerCandidate`
36     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
37     ///  new owner
38     /// @param _newOwnerCandidate The address being proposed as the new owner
39     function proposeOwnership(address _newOwnerCandidate) public onlyOwner {
40         newOwnerCandidate = _newOwnerCandidate;
41         emit OwnershipRequested(msg.sender, newOwnerCandidate);
42     }
43 
44     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
45     ///  transfer of ownership
46     function acceptOwnership() public {
47         require(msg.sender == newOwnerCandidate);
48 
49         address oldOwner = owner;
50         owner = newOwnerCandidate;
51         newOwnerCandidate = address(0);
52 
53         emit OwnershipTransferred(oldOwner, owner);
54     }
55 
56     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
57     ///  be called and it will immediately assign ownership to the `newOwner`
58     /// @notice `owner` can step down and assign some other address to this role
59     /// @param _newOwner The address of the new owner
60     function changeOwnership(address _newOwner) public onlyOwner {
61         require(_newOwner != address(0));
62 
63         address oldOwner = owner;
64         owner = _newOwner;
65         newOwnerCandidate = address(0);
66 
67         emit OwnershipTransferred(oldOwner, owner);
68     }
69 
70     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
71     ///  be called and it will immediately assign ownership to the 0x0 address;
72     ///  it requires a 0xdece be input as a parameter to prevent accidental use
73     /// @notice Decentralizes the contract, this operation cannot be undone 
74     /// @param _dac `0xdac` has to be entered for this function to work
75     function removeOwnership(address _dac) public onlyOwner {
76         require(_dac == address(0xdAc0000000000000000000000000000000000000));
77         owner = address(0);
78         newOwnerCandidate = address(0);
79         emit OwnershipRemoved();     
80     }
81 } 
82 
83 /// @dev `Escapable` is a base level contract built off of the `Owned`
84 ///  contract; it creates an escape hatch function that can be called in an
85 ///  emergency that will allow designated addresses to send any ether or tokens
86 ///  held in the contract to an `escapeHatchDestination` as long as they were
87 ///  not blacklisted
88 contract Escapable is Owned {
89     address public escapeHatchCaller;
90     address payable public escapeHatchDestination;
91     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
92 
93     /// @notice The Constructor assigns the `escapeHatchDestination` and the
94     ///  `escapeHatchCaller`
95     /// @param _escapeHatchCaller The address of a trusted account or contract
96     ///  to call `escapeHatch()` to send the ether in this contract to the
97     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
98     ///  cannot move funds out of `escapeHatchDestination`
99     /// @param _escapeHatchDestination The address of a safe location (usu a
100     ///  Multisig) to send the ether held in this contract; if a neutral address
101     ///  is required, the WHG Multisig is an option:
102     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
103     constructor(address _escapeHatchCaller, address payable _escapeHatchDestination) public {
104         escapeHatchCaller = _escapeHatchCaller;
105         escapeHatchDestination = _escapeHatchDestination;
106     }
107 
108     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
109     ///  are the only addresses that can call a function with this modifier
110     modifier onlyEscapeHatchCallerOrOwner {
111         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
112         _;
113     }
114 
115     /// @notice Creates the blacklist of tokens that are not able to be taken
116     ///  out of the contract; can only be done at the deployment, and the logic
117     ///  to add to the blacklist will be in the constructor of a child contract
118     /// @param _token the token contract address that is to be blacklisted 
119     function blacklistEscapeToken(address _token) internal {
120         escapeBlacklist[_token] = true;
121         emit EscapeHatchBlackistedToken(_token);
122     }
123 
124     /// @notice Checks to see if `_token` is in the blacklist of tokens
125     /// @param _token the token address being queried
126     /// @return False if `_token` is in the blacklist and can't be taken out of
127     ///  the contract via the `escapeHatch()`
128     function isTokenEscapable(address _token) view public returns (bool) {
129         return !escapeBlacklist[_token];
130     }
131 
132     /// @notice The `escapeHatch()` should only be called as a last resort if a
133     /// security issue is uncovered or something unexpected happened
134     /// @param _token to transfer, use 0x0 for ether
135     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
136         require(escapeBlacklist[_token]==false);
137 
138         uint256 balance;
139 
140         /// @dev Logic for ether
141         if (_token == address(0)) {
142             balance = address(this).balance;
143             escapeHatchDestination.transfer(balance);
144             emit EscapeHatchCalled(_token, balance);
145             return;
146         }
147         /// @dev Logic for tokens
148         ERC20 token = ERC20(_token);
149         balance = token.balanceOf(address(this));
150         require(token.transfer(escapeHatchDestination, balance));
151         emit EscapeHatchCalled(_token, balance);
152     }
153 
154     /// @notice Changes the address assigned to call `escapeHatch()`
155     /// @param _newEscapeHatchCaller The address of a trusted account or
156     ///  contract to call `escapeHatch()` to send the value in this contract to
157     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
158     ///  cannot move funds out of `escapeHatchDestination`
159     function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {
160         escapeHatchCaller = _newEscapeHatchCaller;
161     }
162 
163     event EscapeHatchBlackistedToken(address token);
164     event EscapeHatchCalled(address token, uint amount);
165 }
166 
167 
168 /*
169     Copyright 2018, Eduardo Antuña
170 
171     This program is free software: you can redistribute it and/or modify
172     it under the terms of the GNU General Public License as published by
173     the Free Software Foundation, either version 3 of the License, or
174     (at your option) any later version.
175 
176     This program is distributed in the hope that it will be useful,
177     but WITHOUT ANY WARRANTY; without even the implied warranty of
178     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
179     GNU General Public License for more details.
180 
181     You should have received a copy of the GNU General Public License
182     along with this program.  If not, see <http://www.gnu.org/licenses/>.
183 */
184 
185 /// @title DAppNodePackageDirectory Contract
186 /// @author Eduardo Antuña
187 /// @dev The goal of this smartcontrat is to keep a list of available packages 
188 ///  to install in the DAppNode
189 
190 contract DAppNodePackageDirectory is Owned,Escapable {
191 
192     /// @param position Indicates the position of the package. position integers
193     /// do not have to be consecutive. The biggest integer will be shown first.
194     /// @param status - 0: Deleted, 1: Active, 2: Developing, +
195     /// @param name ENS name of the package
196     struct DAppNodePackage {
197         uint128 position;
198         uint128 status;
199         string name;
200     }
201 
202     bytes32 public featured;
203     DAppNodePackage[] DAppNodePackages;
204 
205     event PackageAdded(uint indexed idPackage, string name);
206     event PackageUpdated(uint indexed idPackage, string name);
207     event StatusChanged(uint idPackage, uint128 newStatus);
208     event PositionChanged(uint idPackage, uint128 newPosition);
209     event FeaturedChanged(bytes32 newFeatured);
210 
211     /// @notice The Constructor assigns the `escapeHatchDestination` and the
212     ///  `escapeHatchCaller`
213     /// @param _escapeHatchCaller The address of a trusted account or contract
214     ///  to call `escapeHatch()` to send the ether in this contract to the
215     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
216     ///  cannot move funds out of `escapeHatchDestination`
217     /// @param _escapeHatchDestination The address of a safe location (usu a
218     ///  Multisig) to send the ether held in this contract; if a neutral address
219     ///  is required, the WHG Multisig is an option:
220     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
221     constructor(
222         address _escapeHatchCaller,
223         address payable _escapeHatchDestination
224     ) 
225         Escapable(_escapeHatchCaller, _escapeHatchDestination)
226         public
227     {
228     }
229 
230     /// @notice Add a new DAppNode package
231     /// @param name the ENS name of the package
232     /// @param status status of the package
233     /// @param position to order the packages in the UI
234     /// @return the idPackage of the new package
235     function addPackage (
236         string memory name,
237         uint128 status,
238         uint128 position
239     ) public onlyOwner returns(uint idPackage) {
240         idPackage = DAppNodePackages.length++;
241         DAppNodePackage storage c = DAppNodePackages[idPackage];
242         c.name = name;
243         if (position == 0) {
244             c.position = uint128(1000 * (idPackage + 1));
245         } else {
246             c.position = position;
247         }
248         c.status = status;
249         // An event to notify that a new package has been added
250         emit PackageAdded(idPackage, name);
251     }
252 
253     /// @notice Update a DAppNode package
254     /// @param idPackage the id of the package to be changed
255     /// @param name the new ENS name of the package
256     /// @param status status of the package
257     /// @param position to order the packages in the UI
258     function updatePackage (
259         uint idPackage,
260         string memory name,
261         uint128 status,
262         uint128 position
263     ) public onlyOwner {
264         require(idPackage < DAppNodePackages.length);
265         DAppNodePackage storage c = DAppNodePackages[idPackage];
266         c.name = name;
267         c.position = position;
268         c.status = status;
269         // An event to notify that a package has been updated
270         emit PackageUpdated(idPackage, name);
271     }
272 
273     /// @notice Change the status of a DAppNode package
274     /// @param idPackage the id of the package to be changed
275     /// @param newStatus the new status of the package
276     function changeStatus(
277         uint idPackage,
278         uint128 newStatus
279     ) public onlyOwner {
280         require(idPackage < DAppNodePackages.length);
281         DAppNodePackage storage c = DAppNodePackages[idPackage];
282         c.status = newStatus;
283         emit StatusChanged(idPackage, newStatus);
284     }
285 
286     /// @notice Change the status of a DAppNode package
287     /// @param idPackage the id of the package to be changed
288     /// @param newPosition position to order the packages in the UI
289     function changePosition(
290         uint idPackage,
291         uint128 newPosition
292     ) public onlyOwner {
293         require(idPackage < DAppNodePackages.length);
294         DAppNodePackage storage c = DAppNodePackages[idPackage];
295         c.position = newPosition;
296         emit PositionChanged(idPackage, newPosition);
297     }
298     
299     
300     /// @notice Switch the positio of two DAppNode packages
301     /// @param idPackage1 the id of the package to be switched
302     /// @param idPackage2 the id of the package to be switched
303     function switchPosition(
304         uint idPackage1,
305         uint idPackage2
306     ) public onlyOwner {
307         require(idPackage1 < DAppNodePackages.length);
308         require(idPackage2 < DAppNodePackages.length);
309 
310         DAppNodePackage storage p1 = DAppNodePackages[idPackage1];
311         DAppNodePackage storage p2 = DAppNodePackages[idPackage2];
312         
313         uint128 tmp = p1.position;
314         p1.position = p2.position;
315         p2.position = tmp;
316         emit PositionChanged(idPackage1, p1.position);
317         emit PositionChanged(idPackage2, p2.position);
318 
319     }
320 
321     /// @notice Change the list of featured packages
322     /// @param _featured List of the ids of the featured packages
323     /// if needed ids [5,43]: _featured = 0x052b0000000000000...
324     function changeFeatured(
325         bytes32 _featured
326     ) public onlyOwner {
327         featured = _featured;
328         emit FeaturedChanged(_featured);
329     }
330 
331     /// @notice Returns the information of a DAppNode package
332     /// @param idPackage the id of the package to be changed
333     /// @return name the new name of the package
334     /// @return status the status of the package
335     function getPackage(uint idPackage) public view returns (
336         string memory name,
337         uint128 status,
338         uint128 position
339     ) {
340         require(idPackage < DAppNodePackages.length);
341         DAppNodePackage storage c = DAppNodePackages[idPackage];
342         name = c.name;
343         status = c.status;
344         position = c.position;
345     }
346 
347     /// @notice its goal is to return the total number of DAppNode packages
348     /// @return the total number of DAppNode packages
349     function numberOfDAppNodePackages() view public returns (uint) {
350         return DAppNodePackages.length;
351     }
352 }
353 
354 /*
355     Copyright 2016, Jordi Baylina
356     Contributor: Adrià Massanet <adria@codecontext.io>
357 
358     This program is free software: you can redistribute it and/or modify
359     it under the terms of the GNU General Public License as published by
360     the Free Software Foundation, either version 3 of the License, or
361     (at your option) any later version.
362 
363     This program is distributed in the hope that it will be useful,
364     but WITHOUT ANY WARRANTY; without even the implied warranty of
365     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
366     GNU General Public License for more details.
367 
368     You should have received a copy of the GNU General Public License
369     along with this program.  If not, see <http://www.gnu.org/licenses/>.
370 */
371 
372 
373 
374 
375 
376 
377 
378 
379 /**
380  * @title ERC20
381  * @dev A standard interface for tokens.
382  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
383  */
384 contract ERC20 {
385   
386     /// @dev Returns the total token supply
387     function totalSupply() public view returns (uint256 supply);
388 
389     /// @dev Returns the account balance of the account with address _owner
390     function balanceOf(address _owner) public view returns (uint256 balance);
391 
392     /// @dev Transfers _value number of tokens to address _to
393     function transfer(address _to, uint256 _value) public returns (bool success);
394 
395     /// @dev Transfers _value number of tokens from address _from to address _to
396     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
397 
398     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
399     function approve(address _spender, uint256 _value) public returns (bool success);
400 
401     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
402     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
403 
404     event Transfer(address indexed _from, address indexed _to, uint256 _value);
405     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
406 
407 }