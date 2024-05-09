1 pragma solidity ^0.4.11;
2 
3 // File: contracts/CAVAssetInterface.sol
4 
5 contract CAVAssetInterface {
6     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
7     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
8     function __approve(address _spender, uint _value, address _sender) returns(bool);
9     function __process(bytes _data, address _sender) payable {
10         revert();
11     }
12 }
13 
14 // File: contracts/CAVAssetProxyInterface.sol
15 
16 contract CAVAssetProxy {
17     address public platform;
18     bytes32 public smbl;
19     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
20     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
21     function __approve(address _spender, uint _value, address _sender) returns(bool);
22     function getLatestVersion() returns(address);
23     function init(address _CAVPlatform, string _symbol, string _name);
24     function proposeUpgrade(address _newVersion) returns (bool);
25 }
26 
27 // File: contracts/CAVPlatformInterface.sol
28 
29 contract CAVPlatform {
30     mapping(bytes32 => address) public proxies;
31     function symbols(uint _idx) public constant returns (bytes32);
32     function symbolsCount() public constant returns (uint);
33 
34     function name(bytes32 _symbol) returns(string);
35     function setProxy(address _address, bytes32 _symbol) returns(uint errorCode);
36     function isCreated(bytes32 _symbol) constant returns(bool);
37     function isOwner(address _owner, bytes32 _symbol) returns(bool);
38     function owner(bytes32 _symbol) constant returns(address);
39     function totalSupply(bytes32 _symbol) returns(uint);
40     function balanceOf(address _holder, bytes32 _symbol) returns(uint);
41     function allowance(address _from, address _spender, bytes32 _symbol) returns(uint);
42     function baseUnit(bytes32 _symbol) returns(uint8);
43     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
44     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
45     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(uint errorCode);
46     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(uint errorCode);
47     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) returns(uint errorCode);
48     function reissueAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
49     function revokeAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
50     function isReissuable(bytes32 _symbol) returns(bool);
51     function changeOwnership(bytes32 _symbol, address _newOwner) returns(uint errorCode);
52     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool);
53 }
54 
55 // File: contracts/CAVAsset.sol
56 
57 /**
58  * @title CAV Asset implementation contract.
59  *
60  * Basic asset implementation contract, without any additional logic.
61  * Every other asset implementation contracts should derive from this one.
62  * Receives calls from the proxy, and calls back immediatly without arguments modification.
63  *
64  * Note: all the non constant functions return false instead of throwing in case if state change
65  * didn't happen yet.
66  */
67 contract CAVAsset is CAVAssetInterface {
68 
69     // Assigned asset proxy contract, immutable.
70     CAVAssetProxy public proxy;
71 
72     // banned addresses
73     mapping (address => bool) public blacklist;
74 
75     // stops asset transfers
76     bool public paused = false;
77 
78     /**
79      * Only assigned proxy is allowed to call.
80      */
81     modifier onlyProxy() {
82         if (proxy == msg.sender) {
83             _;
84         }
85     }
86     
87     modifier onlyNotPaused(address sender) {
88         if (!paused || isAuthorized(sender)) {
89             _;
90         }
91     }
92 
93     modifier onlyAcceptable(address _address) {
94         if (!blacklist[_address]) {
95             _;
96         }
97     }
98 
99     /**
100     *  Only assets's admins are allowed to execute
101     */
102     modifier onlyAuthorized() {
103         if (isAuthorized(msg.sender)) {
104             _;
105         }
106     }
107 
108     /**
109      * Sets asset proxy address.
110      *
111      * Can be set only once.
112      *
113      * @param _proxy asset proxy contract address.
114      *
115      * @return success.
116      * @dev function is final, and must not be overridden.
117      */
118     function init(CAVAssetProxy _proxy) returns(bool) {
119         if (address(proxy) != 0x0) {
120             return false;
121         }
122         proxy = _proxy;
123         return true;
124     }
125 
126     function isAuthorized(address sender) public view returns (bool) {
127         CAVPlatform platform = CAVPlatform(proxy.platform());
128         return platform.hasAssetRights(sender, proxy.smbl());
129     }
130 
131     /**
132     *  @dev Lifts the ban on transfers for given addresses
133     */
134     function restrict(address [] _restricted) external onlyAuthorized returns (bool) {
135         for (uint i = 0; i < _restricted.length; i++) {
136             blacklist[_restricted[i]] = true;
137         }
138         return true;
139     }
140 
141     /**
142     *  @dev Revokes the ban on transfers for given addresses
143     */
144     function unrestrict(address [] _unrestricted) external onlyAuthorized returns (bool) {
145         for (uint i = 0; i < _unrestricted.length; i++) {
146             delete blacklist[_unrestricted[i]];
147         }
148         return true;
149     }
150 
151     /**
152     * @dev called by the owner to pause, triggers stopped state
153     * Only admin is allowed to execute this method.
154     */
155     function pause() external onlyAuthorized returns (bool) {
156         paused = true;
157         return true;
158     }
159 
160     /**
161     * @dev called by the owner to unpause, returns to normal state
162     * Only admin is allowed to execute this method.
163     */
164     function unpause() external onlyAuthorized returns (bool) {
165         paused = false;
166         return true;
167     }
168 
169     /**
170      * Passes execution into virtual function.
171      *
172      * Can only be called by assigned asset proxy.
173      *
174      * @return success.
175      * @dev function is final, and must not be overridden.
176      */
177     function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
178         return _transferWithReference(_to, _value, _reference, _sender);
179     }
180 
181     /**
182      * Calls back without modifications if an asset is not stopped.
183      * Checks whether _from/_sender are not in blacklist.
184      *
185      * @return success.
186      * @dev function is virtual, and meant to be overridden.
187      */
188     function _transferWithReference(address _to, uint _value, string _reference, address _sender)
189     internal
190     onlyNotPaused(_sender)
191     onlyAcceptable(_to)
192     onlyAcceptable(_sender)
193     returns(bool)
194     {
195         return proxy.__transferWithReference(_to, _value, _reference, _sender);
196     }
197 
198     /**
199      * Passes execution into virtual function.
200      *
201      * Can only be called by assigned asset proxy.
202      *
203      * @return success.
204      * @dev function is final, and must not be overridden.
205      */
206     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
207         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
208     }
209 
210     /**
211      * Calls back without modifications if an asset is not stopped.
212      * Checks whether _from/_sender are not in blacklist.
213      *
214      * @return success.
215      * @dev function is virtual, and meant to be overridden.
216      */
217     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender)
218     internal
219     onlyNotPaused(_sender)
220     onlyAcceptable(_from)
221     onlyAcceptable(_to)
222     onlyAcceptable(_sender)
223     returns(bool)
224     {
225         return proxy.__transferFromWithReference(_from, _to, _value, _reference, _sender);
226     }
227 
228     /**
229      * Passes execution into virtual function.
230      *
231      * Can only be called by assigned asset proxy.
232      *
233      * @return success.
234      * @dev function is final, and must not be overridden.
235      */
236     function __approve(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {
237         return _approve(_spender, _value, _sender);
238     }
239 
240     /**
241      * Calls back without modifications.
242      *
243      * @return success.
244      * @dev function is virtual, and meant to be overridden.
245      */
246     function _approve(address _spender, uint _value, address _sender)
247     internal
248     onlyAcceptable(_spender)
249     onlyAcceptable(_sender)
250     returns(bool)
251     {
252         return proxy.__approve(_spender, _value, _sender);
253     }
254 }