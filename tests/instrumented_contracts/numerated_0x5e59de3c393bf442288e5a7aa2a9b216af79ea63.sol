1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/interfaces/IRegistry.sol
68 
69 // limited ContractRegistry definition
70 interface IRegistry {
71   function owner()
72     external
73     returns(address);
74 
75   function updateContractAddress(
76     string _name,
77     address _address
78   )
79     external
80     returns (address);
81 
82   function getContractAddress(
83     string _name
84   )
85     external
86     view
87     returns (address);
88 }
89 
90 // File: contracts/interfaces/IBrickblockToken.sol
91 
92 // limited BrickblockToken definition
93 interface IBrickblockToken {
94   function transfer(
95     address _to,
96     uint256 _value
97   )
98     external
99     returns (bool);
100 
101   function transferFrom(
102     address from,
103     address to,
104     uint256 value
105   )
106     external
107     returns (bool);
108 
109   function balanceOf(
110     address _address
111   )
112     external
113     view
114     returns (uint256);
115 
116   function approve(
117     address _spender,
118     uint256 _value
119   )
120     external
121     returns (bool);
122 }
123 
124 // File: contracts/interfaces/IFeeManager.sol
125 
126 interface IFeeManager {
127   function claimFee(
128     uint256 _value
129   )
130     external
131     returns (bool);
132 
133   function payFee()
134     external
135     payable
136     returns (bool);
137 }
138 
139 // File: contracts/interfaces/IAccessToken.sol
140 
141 interface IAccessToken {
142   function lockBBK(
143     uint256 _value
144   )
145     external
146     returns (bool);
147 
148   function unlockBBK(
149     uint256 _value
150   )
151     external
152     returns (bool);
153 
154   function transfer(
155     address _to,
156     uint256 _value
157   )
158     external
159     returns (bool);
160 
161   function distribute(
162     uint256 _amount
163   )
164     external
165     returns (bool);
166 
167   function burn(
168     address _address,
169     uint256 _value
170   )
171     external
172     returns (bool);
173 }
174 
175 // File: contracts/BrickblockAccount.sol
176 
177 /* solium-disable security/no-block-members */
178 
179 
180 contract BrickblockAccount is Ownable {
181   uint8 public constant version = 1;
182   uint256 public releaseTimeOfCompanyBBKs;
183   IRegistry private registry;
184 
185   constructor
186   (
187     address _registryAddress,
188     uint256 _releaseTimeOfCompanyBBKs
189   )
190     public
191   {
192     require(_releaseTimeOfCompanyBBKs > block.timestamp);
193     releaseTimeOfCompanyBBKs = _releaseTimeOfCompanyBBKs;
194     registry = IRegistry(_registryAddress);
195   }
196 
197   function pullFunds()
198     external
199     onlyOwner
200     returns (bool)
201   {
202     IBrickblockToken bbk = IBrickblockToken(
203       registry.getContractAddress("BrickblockToken")
204     );
205     uint256 _companyFunds = bbk.balanceOf(address(bbk));
206     return bbk.transferFrom(address(bbk), address(this), _companyFunds);
207   }
208 
209   function lockBBK
210   (
211     uint256 _value
212   )
213     external
214     onlyOwner
215     returns (bool)
216   {
217     IAccessToken act = IAccessToken(
218       registry.getContractAddress("AccessToken")
219     );
220     IBrickblockToken bbk = IBrickblockToken(
221       registry.getContractAddress("BrickblockToken")
222     );
223 
224     require(bbk.approve(address(act), _value));
225 
226     return act.lockBBK(_value);
227   }
228 
229   function unlockBBK(
230     uint256 _value
231   )
232     external
233     onlyOwner
234     returns (bool)
235   {
236     IAccessToken act = IAccessToken(
237       registry.getContractAddress("AccessToken")
238     );
239     return act.unlockBBK(_value);
240   }
241 
242   function claimFee(
243     uint256 _value
244   )
245     external
246     onlyOwner
247     returns (bool)
248   {
249     IFeeManager fmr = IFeeManager(
250       registry.getContractAddress("FeeManager")
251     );
252     return fmr.claimFee(_value);
253   }
254 
255   function withdrawEthFunds(
256     address _address,
257     uint256 _value
258   )
259     external
260     onlyOwner
261     returns (bool)
262   {
263     require(address(this).balance >= _value);
264     _address.transfer(_value);
265     return true;
266   }
267 
268   function withdrawActFunds(
269     address _address,
270     uint256 _value
271   )
272     external
273     onlyOwner
274     returns (bool)
275   {
276     IAccessToken act = IAccessToken(
277       registry.getContractAddress("AccessToken")
278     );
279     return act.transfer(_address, _value);
280   }
281 
282   function withdrawBbkFunds(
283     address _address,
284     uint256 _value
285   )
286     external
287     onlyOwner
288     returns (bool)
289   {
290     require(block.timestamp >= releaseTimeOfCompanyBBKs);
291     IBrickblockToken bbk = IBrickblockToken(
292       registry.getContractAddress("BrickblockToken")
293     );
294     return bbk.transfer(_address, _value);
295   }
296 
297   // ensure that we can be paid ether
298   function()
299     public
300     payable
301   {}
302 }