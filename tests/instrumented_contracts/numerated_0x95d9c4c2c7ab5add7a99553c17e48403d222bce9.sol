1 //File: contracts/Owned.sol
2 pragma solidity ^0.4.19;
3 
4 
5 /// @title Owned
6 /// @author Adrià Massanet <adria@codecontext.io>
7 /// @notice The Owned contract has an owner address, and provides basic 
8 ///  authorization control functions, this simplifies & the implementation of
9 ///  user permissions; this contract has three work flows for a change in
10 ///  ownership, the first requires the new owner to validate that they have the
11 ///  ability to accept ownership, the second allows the ownership to be
12 ///  directly transfered without requiring acceptance, and the third allows for
13 ///  the ownership to be removed to allow for decentralization 
14 contract Owned {
15 
16     address public owner;
17     address public newOwnerCandidate;
18 
19     event OwnershipRequested(address indexed by, address indexed to);
20     event OwnershipTransferred(address indexed from, address indexed to);
21     event OwnershipRemoved();
22 
23     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
24     function Owned() public {
25         owner = msg.sender;
26     }
27 
28     /// @dev `owner` is the only address that can call a function with this
29     /// modifier
30     modifier onlyOwner() {
31         require (msg.sender == owner);
32         _;
33     }
34     
35     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
36     ///  be called first by the current `owner` then `acceptOwnership()` must be
37     ///  called by the `newOwnerCandidate`
38     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
39     ///  new owner
40     /// @param _newOwnerCandidate The address being proposed as the new owner
41     function proposeOwnership(address _newOwnerCandidate) public onlyOwner {
42         newOwnerCandidate = _newOwnerCandidate;
43         OwnershipRequested(msg.sender, newOwnerCandidate);
44     }
45 
46     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
47     ///  transfer of ownership
48     function acceptOwnership() public {
49         require(msg.sender == newOwnerCandidate);
50 
51         address oldOwner = owner;
52         owner = newOwnerCandidate;
53         newOwnerCandidate = 0x0;
54 
55         OwnershipTransferred(oldOwner, owner);
56     }
57 
58     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
59     ///  be called and it will immediately assign ownership to the `newOwner`
60     /// @notice `owner` can step down and assign some other address to this role
61     /// @param _newOwner The address of the new owner
62     function changeOwnership(address _newOwner) public onlyOwner {
63         require(_newOwner != 0x0);
64 
65         address oldOwner = owner;
66         owner = _newOwner;
67         newOwnerCandidate = 0x0;
68 
69         OwnershipTransferred(oldOwner, owner);
70     }
71 
72     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
73     ///  be called and it will immediately assign ownership to the 0x0 address;
74     ///  it requires a 0xdece be input as a parameter to prevent accidental use
75     /// @notice Decentralizes the contract, this operation cannot be undone 
76     /// @param _dac `0xdac` has to be entered for this function to work
77     function removeOwnership(address _dac) public onlyOwner {
78         require(_dac == 0xdac);
79         owner = 0x0;
80         newOwnerCandidate = 0x0;
81         OwnershipRemoved();     
82     }
83 } 
84 //File: contracts/ERC20.sol
85 pragma solidity ^0.4.19;
86 
87 
88 /**
89  * @title ERC20
90  * @dev A standard interface for tokens.
91  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
92  */
93 contract ERC20 {
94   
95     /// @dev Returns the total token supply
96     function totalSupply() public constant returns (uint256 supply);
97 
98     /// @dev Returns the account balance of the account with address _owner
99     function balanceOf(address _owner) public constant returns (uint256 balance);
100 
101     /// @dev Transfers _value number of tokens to address _to
102     function transfer(address _to, uint256 _value) public returns (bool success);
103 
104     /// @dev Transfers _value number of tokens from address _from to address _to
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
106 
107     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
108     function approve(address _spender, uint256 _value) public returns (bool success);
109 
110     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
111     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
112 
113     event Transfer(address indexed _from, address indexed _to, uint256 _value);
114     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
115 
116 }
117 //File: contracts/Escapable.sol
118 pragma solidity ^0.4.19;
119 /*
120     Copyright 2016, Jordi Baylina
121     Contributor: Adrià Massanet <adria@codecontext.io>
122 
123     This program is free software: you can redistribute it and/or modify
124     it under the terms of the GNU General Public License as published by
125     the Free Software Foundation, either version 3 of the License, or
126     (at your option) any later version.
127 
128     This program is distributed in the hope that it will be useful,
129     but WITHOUT ANY WARRANTY; without even the implied warranty of
130     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
131     GNU General Public License for more details.
132 
133     You should have received a copy of the GNU General Public License
134     along with this program.  If not, see <http://www.gnu.org/licenses/>.
135 */
136 
137 
138 
139 
140 
141 /// @dev `Escapable` is a base level contract built off of the `Owned`
142 ///  contract; it creates an escape hatch function that can be called in an
143 ///  emergency that will allow designated addresses to send any ether or tokens
144 ///  held in the contract to an `escapeHatchDestination` as long as they were
145 ///  not blacklisted
146 contract Escapable is Owned {
147     address public escapeHatchCaller;
148     address public escapeHatchDestination;
149     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
150 
151     /// @notice The Constructor assigns the `escapeHatchDestination` and the
152     ///  `escapeHatchCaller`
153     /// @param _escapeHatchCaller The address of a trusted account or contract
154     ///  to call `escapeHatch()` to send the ether in this contract to the
155     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
156     ///  cannot move funds out of `escapeHatchDestination`
157     /// @param _escapeHatchDestination The address of a safe location (usu a
158     ///  Multisig) to send the ether held in this contract; if a neutral address
159     ///  is required, the WHG Multisig is an option:
160     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
161     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) public {
162         escapeHatchCaller = _escapeHatchCaller;
163         escapeHatchDestination = _escapeHatchDestination;
164     }
165 
166     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
167     ///  are the only addresses that can call a function with this modifier
168     modifier onlyEscapeHatchCallerOrOwner {
169         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
170         _;
171     }
172 
173     /// @notice Creates the blacklist of tokens that are not able to be taken
174     ///  out of the contract; can only be done at the deployment, and the logic
175     ///  to add to the blacklist will be in the constructor of a child contract
176     /// @param _token the token contract address that is to be blacklisted 
177     function blacklistEscapeToken(address _token) internal {
178         escapeBlacklist[_token] = true;
179         EscapeHatchBlackistedToken(_token);
180     }
181 
182     /// @notice Checks to see if `_token` is in the blacklist of tokens
183     /// @param _token the token address being queried
184     /// @return False if `_token` is in the blacklist and can't be taken out of
185     ///  the contract via the `escapeHatch()`
186     function isTokenEscapable(address _token) view public returns (bool) {
187         return !escapeBlacklist[_token];
188     }
189 
190     /// @notice The `escapeHatch()` should only be called as a last resort if a
191     /// security issue is uncovered or something unexpected happened
192     /// @param _token to transfer, use 0x0 for ether
193     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
194         require(escapeBlacklist[_token]==false);
195 
196         uint256 balance;
197 
198         /// @dev Logic for ether
199         if (_token == 0x0) {
200             balance = this.balance;
201             escapeHatchDestination.transfer(balance);
202             EscapeHatchCalled(_token, balance);
203             return;
204         }
205         /// @dev Logic for tokens
206         ERC20 token = ERC20(_token);
207         balance = token.balanceOf(this);
208         require(token.transfer(escapeHatchDestination, balance));
209         EscapeHatchCalled(_token, balance);
210     }
211 
212     /// @notice Changes the address assigned to call `escapeHatch()`
213     /// @param _newEscapeHatchCaller The address of a trusted account or
214     ///  contract to call `escapeHatch()` to send the value in this contract to
215     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
216     ///  cannot move funds out of `escapeHatchDestination`
217     function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {
218         escapeHatchCaller = _newEscapeHatchCaller;
219     }
220 
221     event EscapeHatchBlackistedToken(address token);
222     event EscapeHatchCalled(address token, uint amount);
223 }
224 //File: contracts/DAppNodePackageDirectory.sol
225 pragma solidity ^0.4.19;
226 
227 /*
228     Copyright 2018, Eduardo Antuña
229 
230     This program is free software: you can redistribute it and/or modify
231     it under the terms of the GNU General Public License as published by
232     the Free Software Foundation, either version 3 of the License, or
233     (at your option) any later version.
234 
235     This program is distributed in the hope that it will be useful,
236     but WITHOUT ANY WARRANTY; without even the implied warranty of
237     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
238     GNU General Public License for more details.
239 
240     You should have received a copy of the GNU General Public License
241     along with this program.  If not, see <http://www.gnu.org/licenses/>.
242 */
243 
244 /// @title DAppNodePackageDirectory Contract
245 /// @author Eduardo Antuña
246 /// @dev The goal of this smartcontrat is to keep a list of available packages 
247 ///  to install in the DAppNode
248 
249 
250 
251 
252 contract DAppNodePackageDirectory is Owned,Escapable {
253 
254     enum DAppNodePackageStatus {Preparing, Develop, Active, Deprecated, Deleted}
255 
256     struct DAppNodePackage {
257         string name;
258         address repo;
259         DAppNodePackageStatus status;
260     }
261 
262     DAppNodePackage[] DAppNodePackages;
263 
264     event PackageAdded(uint indexed idPackage, string name, address repo);
265     event PackageUpdated(uint indexed idPackage, string name, address repo);
266     event StatusChanged(uint idPackage, DAppNodePackageStatus newStatus);
267 
268     /// @notice The Constructor assigns the `escapeHatchDestination` and the
269     ///  `escapeHatchCaller`
270     /// @param _escapeHatchCaller The address of a trusted account or contract
271     ///  to call `escapeHatch()` to send the ether in this contract to the
272     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
273     ///  cannot move funds out of `escapeHatchDestination`
274     /// @param _escapeHatchDestination The address of a safe location (usu a
275     ///  Multisig) to send the ether held in this contract; if a neutral address
276     ///  is required, the WHG Multisig is an option:
277     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
278     function DAppNodePackageDirectory(
279         address _escapeHatchCaller,
280         address _escapeHatchDestination
281     ) 
282         Escapable(_escapeHatchCaller, _escapeHatchDestination)
283         public
284     {
285     }
286 
287     /// @notice Add a new DAppNode package
288     /// @param name the ENS name of the package
289     /// @param repo the AragonPackageManager address of the repo.
290     /// @return the idPackage of the new package
291     function addPackage (
292         string name,
293         address repo
294     ) onlyOwner public returns(uint idPackage) {
295         idPackage = DAppNodePackages.length++;
296         DAppNodePackage storage c = DAppNodePackages[idPackage];
297         c.name = name;
298         c.repo = repo;
299         // An event to notify that a new package has been added
300         PackageAdded(idPackage,name,repo);
301     }
302 
303     /// @notice Update a DAppNode package
304     /// @param idPackage the id of the package to be changed
305     /// @param name the new ENS name of the package
306     /// @param repo the new AragonPackageManager address of the repo.
307     function updatePackage (
308         uint idPackage,
309         string name,
310         address repo
311     ) onlyOwner public {
312         require(idPackage < DAppNodePackages.length);
313         DAppNodePackage storage c = DAppNodePackages[idPackage];
314         c.name = name;
315         c.repo = repo;
316         // An event to notify that a package has been updated
317         PackageUpdated(idPackage,name,repo);
318     }
319 
320     /// @notice Change the status of a DAppNode package
321     /// @param idPackage the id of the package to be changed
322     /// @param newStatus the new status of the package
323     function changeStatus(
324         uint idPackage,
325         DAppNodePackageStatus newStatus
326     ) onlyOwner public {
327         require(idPackage < DAppNodePackages.length);
328         DAppNodePackage storage c = DAppNodePackages[idPackage];
329         c.status = newStatus;
330         // An event to notify that the status of a packet has been updated
331         StatusChanged(idPackage, newStatus);
332     }
333 
334     /// @notice Returns the information of a DAppNode package
335     /// @param idPackage the id of the package to be changed
336     /// @return name the new name of the package
337     /// @return repo the AragonPackageManager address of the repo.
338     /// @return status the status of the package
339     function getPackage(uint idPackage) constant public returns (
340         string name,
341         address repo,
342         DAppNodePackageStatus status
343     ) {
344         require(idPackage < DAppNodePackages.length);
345         DAppNodePackage storage c = DAppNodePackages[idPackage];
346         name = c.name;
347         repo = c.repo;
348         status = c.status;
349     }
350 
351     /// @notice its goal is to return the total number of DAppNode packages
352     /// @return the total number of DAppNode packages
353     function numberOfDAppNodePackages() view public returns (uint) {
354         return DAppNodePackages.length;
355     }
356 }