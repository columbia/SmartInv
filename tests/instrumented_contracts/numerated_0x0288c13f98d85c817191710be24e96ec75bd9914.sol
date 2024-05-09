1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipRenounced(address indexed previousOwner);
50   event OwnershipTransferred(
51     address indexed previousOwner,
52     address indexed newOwner
53   );
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   constructor() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to relinquish control of the contract.
74    * @notice Renouncing to ownership will leave the contract without an owner.
75    * It will not be possible to call the functions with the `onlyOwner`
76    * modifier anymore.
77    */
78   function renounceOwnership() public onlyOwner {
79     emit OwnershipRenounced(owner);
80     owner = address(0);
81   }
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param _newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address _newOwner) public onlyOwner {
88     _transferOwnership(_newOwner);
89   }
90 
91   /**
92    * @dev Transfers control of the contract to a newOwner.
93    * @param _newOwner The address to transfer ownership to.
94    */
95   function _transferOwnership(address _newOwner) internal {
96     require(_newOwner != address(0));
97     emit OwnershipTransferred(owner, _newOwner);
98     owner = _newOwner;
99   }
100 }
101 
102 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
103 
104 /**
105  * @title Pausable
106  * @dev Base contract which allows children to implement an emergency stop mechanism.
107  */
108 contract Pausable is Ownable {
109   event Pause();
110   event Unpause();
111 
112   bool public paused = false;
113 
114 
115   /**
116    * @dev Modifier to make a function callable only when the contract is not paused.
117    */
118   modifier whenNotPaused() {
119     require(!paused);
120     _;
121   }
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is paused.
125    */
126   modifier whenPaused() {
127     require(paused);
128     _;
129   }
130 
131   /**
132    * @dev called by the owner to pause, triggers stopped state
133    */
134   function pause() public onlyOwner whenNotPaused {
135     paused = true;
136     emit Pause();
137   }
138 
139   /**
140    * @dev called by the owner to unpause, returns to normal state
141    */
142   function unpause() public onlyOwner whenPaused {
143     paused = false;
144     emit Unpause();
145   }
146 }
147 
148 // File: contracts/AbstractDeployer.sol
149 
150 contract AbstractDeployer is Ownable {
151     function title() public view returns(string);
152 
153     function deploy(bytes data)
154         external onlyOwner returns(address result)
155     {
156         // solium-disable-next-line security/no-low-level-calls
157         require(address(this).call(data), "Arbitrary call failed");
158         // solium-disable-next-line security/no-inline-assembly
159         assembly {
160             returndatacopy(0, 0, 32)
161             result := mload(0)
162         }
163     }
164 }
165 
166 // File: contracts/interface/IBasicMultiToken.sol
167 
168 contract IBasicMultiToken is ERC20 {
169     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
170     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
171 
172     function tokensCount() public view returns(uint256);
173     function tokens(uint i) public view returns(ERC20);
174     function bundlingEnabled() public view returns(bool);
175     
176     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
177     function bundle(address _beneficiary, uint256 _amount) public;
178 
179     function unbundle(address _beneficiary, uint256 _value) public;
180     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
181 
182     // Owner methods
183     function disableBundling() public;
184     function enableBundling() public;
185 
186     bytes4 public constant InterfaceId_IBasicMultiToken = 0xd5c368b6;
187 	  /**
188 	   * 0xd5c368b6 ===
189 	   *   bytes4(keccak256('tokensCount()')) ^
190 	   *   bytes4(keccak256('tokens(uint256)')) ^
191        *   bytes4(keccak256('bundlingEnabled()')) ^
192        *   bytes4(keccak256('bundleFirstTokens(address,uint256,uint256[])')) ^
193        *   bytes4(keccak256('bundle(address,uint256)')) ^
194        *   bytes4(keccak256('unbundle(address,uint256)')) ^
195        *   bytes4(keccak256('unbundleSome(address,uint256,address[])')) ^
196        *   bytes4(keccak256('disableBundling()')) ^
197        *   bytes4(keccak256('enableBundling()'))
198 	   */
199 }
200 
201 // File: contracts/interface/IMultiToken.sol
202 
203 contract IMultiToken is IBasicMultiToken {
204     event Update();
205     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
206 
207     function weights(address _token) public view returns(uint256);
208     function changesEnabled() public view returns(bool);
209     
210     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
211     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
212 
213     // Owner methods
214     function disableChanges() public;
215 
216     bytes4 public constant InterfaceId_IMultiToken = 0x81624e24;
217 	  /**
218 	   * 0x81624e24 ===
219        *   InterfaceId_IBasicMultiToken(0xd5c368b6) ^
220 	   *   bytes4(keccak256('weights(address)')) ^
221        *   bytes4(keccak256('changesEnabled()')) ^
222        *   bytes4(keccak256('getReturn(address,address,uint256)')) ^
223 	   *   bytes4(keccak256('change(address,address,uint256,uint256)')) ^
224        *   bytes4(keccak256('disableChanges()'))
225 	   */
226 }
227 
228 // File: contracts/network/MultiTokenNetwork.sol
229 
230 contract MultiTokenNetwork is Pausable {
231     address[] private _multitokens;
232     AbstractDeployer[] private _deployers;
233 
234     event NewMultitoken(address indexed mtkn);
235     event NewDeployer(uint256 indexed index, address indexed oldDeployer, address indexed newDeployer);
236 
237     function multitokensCount() public view returns(uint256) {
238         return _multitokens.length;
239     }
240 
241     function multitokens(uint i) public view returns(address) {
242         return _multitokens[i];
243     }
244 
245     function allMultitokens() public view returns(address[]) {
246         return _multitokens;
247     }
248 
249     function deployersCount() public view returns(uint256) {
250         return _deployers.length;
251     }
252 
253     function deployers(uint i) public view returns(AbstractDeployer) {
254         return _deployers[i];
255     }
256 
257     function allWalletBalances(address wallet) public view returns(uint256[]) {
258         uint256[] memory balances = new uint256[](_multitokens.length);
259         for (uint i = 0; i < _multitokens.length; i++) {
260             balances[i] = ERC20(_multitokens[i]).balanceOf(wallet);
261         }
262         return balances;
263     }
264 
265     function deleteMultitoken(uint index) public onlyOwner {
266         require(index < _multitokens.length, "deleteMultitoken: index out of range");
267         if (index != _multitokens.length - 1) {
268             _multitokens[index] = _multitokens[_multitokens.length - 1];
269         }
270         _multitokens.length -= 1;
271     }
272 
273     function deleteDeployer(uint index) public onlyOwner {
274         require(index < _deployers.length, "deleteDeployer: index out of range");
275         if (index != _deployers.length - 1) {
276             _deployers[index] = _deployers[_deployers.length - 1];
277         }
278         _deployers.length -= 1;
279     }
280 
281     function disableBundlingMultitoken(uint index) public onlyOwner {
282         IBasicMultiToken(_multitokens[index]).disableBundling();
283     }
284 
285     function enableBundlingMultitoken(uint index) public onlyOwner {
286         IBasicMultiToken(_multitokens[index]).enableBundling();
287     }
288 
289     function disableChangesMultitoken(uint index) public onlyOwner {
290         IMultiToken(_multitokens[index]).disableChanges();
291     }
292 
293     function addDeployer(AbstractDeployer deployer) public onlyOwner whenNotPaused {
294         require(deployer.owner() == address(this), "addDeployer: first set MultiTokenNetwork as owner");
295         emit NewDeployer(_deployers.length, address(0), deployer);
296         _deployers.push(deployer);
297     }
298 
299     function setDeployer(uint256 index, AbstractDeployer deployer) public onlyOwner whenNotPaused {
300         require(deployer.owner() == address(this), "setDeployer: first set MultiTokenNetwork as owner");
301         emit NewDeployer(index, _deployers[index], deployer);
302         _deployers[index] = deployer;
303     }
304 
305     function deploy(uint256 index, bytes data) public whenNotPaused {
306         address mtkn = _deployers[index].deploy(data);
307         _multitokens.push(mtkn);
308         emit NewMultitoken(mtkn);
309     }
310 
311     function makeCall(address target, uint256 value, bytes data) public onlyOwner {
312         // solium-disable-next-line security/no-call-value
313         require(target.call.value(value)(data), "Arbitrary call failed");
314     }
315 }