1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title ContractOwner
64  * @dev The ContractOwner contract serves the role of interactng with the functions of Ownable contracts,
65  * this simplifies the implementation of "user permissions".
66  */
67 contract HasContracts is Ownable {
68 
69   /**
70    * @dev Relinquish control of the owned _contract.
71    */
72   function renounceOwnedOwnership(address _contract) public onlyOwner {
73     Ownable(_contract).renounceOwnership();
74   }
75 
76   /**
77    * @dev Transfer control of the owned _contract to a newOwner.
78    * @param _newOwner The address to transfer ownership to.
79    */
80   function transferOwnedOwnership(address _contract, address _newOwner) public onlyOwner {
81     Ownable(_contract).transferOwnership(_newOwner);
82   }
83 }
84 
85 contract IOwnable {
86   address public owner;
87 
88   event OwnershipRenounced(address indexed previousOwner);
89   event OwnershipTransferred(
90     address indexed previousOwner,
91     address indexed newOwner
92   );
93 
94   function renounceOwnership() public;
95   function transferOwnership(address _newOwner) public;
96 }
97 
98 contract ITokenDistributor is IOwnable {
99 
100     address public targetToken;
101     address[] public stakeHolders;
102     uint256 public maxStakeHolders;
103     event InsufficientTokenBalance( address indexed _token, uint256 _time );
104     event TokensDistributed( address indexed _token, uint256 _total, uint256 _time );
105 
106     function isDistributionDue (address _token) public view returns (bool);
107     function isDistributionDue () public view returns (bool);
108     function countStakeHolders () public view returns (uint256);
109     function getTokenBalance(address _token) public view returns (uint256);
110     function getPortion (uint256 _total) public view returns (uint256);
111     function setTargetToken (address _targetToken) public returns (bool);
112     function distribute (address _token) public returns (bool);
113     function distribute () public returns (bool);
114 }
115 
116 /**
117 * A secondary contract which can interact directly with tokenDistributor
118 * and can ultimately be made Owner to acheieve full `Code is Law` state
119 */
120 contract HasDistributorHandler is Ownable {
121     /**
122     *   Allows distributing of tokens from tokenDistributor contracts
123     *   supports only 2 versions at present
124     *   Version1 : distribute()
125     *   version2 : distribute(address token) ( fallback() ) : for backward compatibility
126     *
127     *   version type has to be passed in to complete the release, default is version1.
128     *  0 => version1
129     *  1 => version2
130     *
131     */
132 
133     enum distributorContractVersion { v1, v2 }
134 
135     address public tokenDistributor;
136     distributorContractVersion public distributorVersion;
137 
138     constructor (distributorContractVersion _distributorVersion, address _tokenDistributor) public Ownable() {
139         setTokenDistributor(_distributorVersion, _tokenDistributor);
140     }
141 
142     function setTokenDistributor (distributorContractVersion _distributorVersion, address _tokenDistributor) public onlyOwner returns (bool) {
143       require(tokenDistributor == 0x0, 'Token Distributor already set');
144       distributorVersion = _distributorVersion;
145       tokenDistributor = _tokenDistributor;
146       return true;
147     }
148 
149     function distribute () public returns (bool) {
150         require(tokenDistributor != 0x0, 'Token Distributor not set');
151 
152         if (distributorVersion == distributorContractVersion.v2) {
153           /* TODO Check functionaliy and optimize  */
154             return tokenDistributor.call(0x0);
155         } else {
156           return ITokenDistributor(tokenDistributor).distribute();
157         }
158         return false;
159     }
160 
161     function () public {
162       distribute();
163     }
164 }
165 
166 pragma solidity^0.4.24;
167 
168 contract IVestingContract {
169   function release() public;
170   function release(address token) public;
171 }
172 
173 /**
174  * @title ERC20Basic
175  * @dev Simpler version of ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/179
177  */
178 contract ERC20Basic {
179   function totalSupply() public view returns (uint256);
180   function balanceOf(address who) public view returns (uint256);
181   function transfer(address to, uint256 value) public returns (bool);
182   event Transfer(address indexed from, address indexed to, uint256 value);
183 }
184 
185 contract TokenHandler is Ownable {
186 
187     address public targetToken;
188 
189     constructor ( address _targetToken) public Ownable() {
190         setTargetToken(_targetToken);
191     }
192 
193     function getTokenBalance(address _token) public view returns (uint256) {
194         ERC20Basic token = ERC20Basic(_token);
195         return token.balanceOf(address(this));
196     }
197 
198     function setTargetToken (address _targetToken) public onlyOwner returns (bool) {
199       require(targetToken == 0x0, 'Target token already set');
200       targetToken = _targetToken;
201       return true;
202     }
203 
204     function _transfer (address _token, address _recipient, uint256 _value) internal {
205         ERC20Basic token = ERC20Basic(_token);
206         token.transfer(_recipient, _value);
207     }
208 }
209 
210 /*
211 Supports default zeppelin vesting contract
212 https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/TokenVesting.sol
213 */
214 
215 
216 
217 
218 
219 contract VestingHandler is TokenHandler {
220 
221     /**
222     *   Allows releasing of tokens from vesting contracts
223     *   supports only 2 versions at present
224     *   Version1 : release()
225     *   version2 : release(address token)
226     *
227     *   version type has to be passed in to complete the release, default is version1.
228     *  0 => version1
229     *  1 => version2
230     */
231 
232     enum vestingContractVersion { v1, v2 }
233 
234     address public vestingContract;
235     vestingContractVersion public targetVersion;
236 
237     constructor ( vestingContractVersion _targetVersion, address _vestingContract, address _targetToken) public
238     TokenHandler(_targetToken){
239         setVestingContract(_targetVersion, _vestingContract);
240     }
241 
242     function setVestingContract (vestingContractVersion _version, address _vestingContract) public onlyOwner returns (bool) {
243         require(vestingContract == 0x0, 'Vesting Contract already set');
244         vestingContract = _vestingContract;
245         targetVersion = _version;
246         return true;
247     }
248 
249     function _releaseVesting (vestingContractVersion _version, address _vestingContract, address _targetToken) internal returns (bool) {
250         require(_targetToken != 0x0, 'Target token not set');
251         if (_version == vestingContractVersion.v1) {
252             return _releaseVesting (_version, _vestingContract);
253         } else if (_version == vestingContractVersion.v2){
254             IVestingContract(_vestingContract).release(_targetToken);
255             return true;
256         }
257         return false;
258     }
259 
260     function _releaseVesting (vestingContractVersion _version, address _vestingContract) internal returns (bool) {
261         if (_version != vestingContractVersion.v1) {
262             revert('You need to pass in the additional argument(s)');
263         }
264         IVestingContract(_vestingContract).release();
265         return true;
266     }
267 
268     function releaseVesting (vestingContractVersion _version, address _vestingContract, address _targetToken) public onlyOwner returns (bool) {
269         return _releaseVesting(_version, _vestingContract, _targetToken);
270     }
271 
272     function releaseVesting (vestingContractVersion _version, address _vestingContract) public onlyOwner returns (bool) {
273         return _releaseVesting(_version, _vestingContract);
274     }
275 
276     function release () public returns (bool){
277         require(vestingContract != 0x0, 'Vesting Contract not set');
278         return _releaseVesting(targetVersion, vestingContract, targetToken);
279     }
280 
281     function () public {
282       release();
283     }
284 }
285 
286 /**
287 * Allows using one call to both release and Distribute tokens from
288 * Handler and distributor in cases where separate contracts
289 * Presently does not support re-use
290 */
291 contract VestingHasDistributorHandler is VestingHandler, HasDistributorHandler {
292 
293     constructor (distributorContractVersion _distributorVersion, address _tokenDistributor, vestingContractVersion _targetVersion, address _vestingContract, address _targetToken) public
294     VestingHandler( _targetVersion, _vestingContract, _targetToken )
295     HasDistributorHandler(_distributorVersion, _tokenDistributor)
296     {
297     }
298 
299     function releaseAndDistribute () public {
300         release();
301         distribute();
302     }
303 
304     function () {
305       releaseAndDistribute();
306     }
307 }
308 
309 contract VestingHasDistributorHandlerHasContracts is VestingHasDistributorHandler, HasContracts {
310 
311     constructor (distributorContractVersion _distributorVersion, address _tokenDistributor, vestingContractVersion _targetVersion, address _vestingContract, address _targetToken) public
312     VestingHasDistributorHandler( _distributorVersion, _tokenDistributor, _targetVersion, _vestingContract, _targetToken )
313     HasContracts()
314     {
315     }
316 }