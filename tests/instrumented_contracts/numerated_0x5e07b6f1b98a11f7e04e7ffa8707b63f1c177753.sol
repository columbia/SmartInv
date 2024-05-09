1 pragma solidity ^0.5.0;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/rmanzoku/src/github.com/doublejumptokyo/mch-dailyaction/contracts/MCHDailyActionV3.sol
6 // flattened :  Monday, 30-Sep-19 08:38:23 UTC
7 contract Ownable {
8     address private _owner;
9 
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     constructor () internal {
17         _owner = msg.sender;
18         emit OwnershipTransferred(address(0), _owner);
19     }
20 
21     /**
22      * @return the address of the owner.
23      */
24     function owner() public view returns (address) {
25         return _owner;
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         require(isOwner());
33         _;
34     }
35 
36     /**
37      * @return true if `msg.sender` is the owner of the contract.
38      */
39     function isOwner() public view returns (bool) {
40         return msg.sender == _owner;
41     }
42 
43     /**
44      * @dev Allows the current owner to relinquish control of the contract.
45      * @notice Renouncing to ownership will leave the contract without an owner.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      */
49     function renounceOwnership() public onlyOwner {
50         emit OwnershipTransferred(_owner, address(0));
51         _owner = address(0);
52     }
53 
54     /**
55      * @dev Allows the current owner to transfer control of the contract to a newOwner.
56      * @param newOwner The address to transfer ownership to.
57      */
58     function transferOwnership(address newOwner) public onlyOwner {
59         _transferOwnership(newOwner);
60     }
61 
62     /**
63      * @dev Transfers control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function _transferOwnership(address newOwner) internal {
67         require(newOwner != address(0));
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 
73 library Roles {
74     struct Role {
75         mapping (address => bool) bearer;
76     }
77 
78     /**
79      * @dev give an account access to this role
80      */
81     function add(Role storage role, address account) internal {
82         require(account != address(0));
83         require(!has(role, account));
84 
85         role.bearer[account] = true;
86     }
87 
88     /**
89      * @dev remove an account's access to this role
90      */
91     function remove(Role storage role, address account) internal {
92         require(account != address(0));
93         require(has(role, account));
94 
95         role.bearer[account] = false;
96     }
97 
98     /**
99      * @dev check if an account has this role
100      * @return bool
101      */
102     function has(Role storage role, address account) internal view returns (bool) {
103         require(account != address(0));
104         return role.bearer[account];
105     }
106 }
107 
108 library ECDSA {
109     /**
110      * @dev Recover signer address from a message by using their signature
111      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
112      * @param signature bytes signature, the signature is generated using web3.eth.sign()
113      */
114     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
115         bytes32 r;
116         bytes32 s;
117         uint8 v;
118 
119         // Check the signature length
120         if (signature.length != 65) {
121             return (address(0));
122         }
123 
124         // Divide the signature in r, s and v variables
125         // ecrecover takes the signature parameters, and the only way to get them
126         // currently is to use assembly.
127         // solhint-disable-next-line no-inline-assembly
128         assembly {
129             r := mload(add(signature, 0x20))
130             s := mload(add(signature, 0x40))
131             v := byte(0, mload(add(signature, 0x60)))
132         }
133 
134         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
135         if (v < 27) {
136             v += 27;
137         }
138 
139         // If the version is correct return the signer address
140         if (v != 27 && v != 28) {
141             return (address(0));
142         } else {
143             return ecrecover(hash, v, r, s);
144         }
145     }
146 
147     /**
148      * toEthSignedMessageHash
149      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
150      * and hash the result
151      */
152     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
153         // 32 is the length in bytes of hash,
154         // enforced by the type signature above
155         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
156     }
157 }
158 
159 contract PauserRole {
160     using Roles for Roles.Role;
161 
162     event PauserAdded(address indexed account);
163     event PauserRemoved(address indexed account);
164 
165     Roles.Role private _pausers;
166 
167     constructor () internal {
168         _addPauser(msg.sender);
169     }
170 
171     modifier onlyPauser() {
172         require(isPauser(msg.sender));
173         _;
174     }
175 
176     function isPauser(address account) public view returns (bool) {
177         return _pausers.has(account);
178     }
179 
180     function addPauser(address account) public onlyPauser {
181         _addPauser(account);
182     }
183 
184     function renouncePauser() public {
185         _removePauser(msg.sender);
186     }
187 
188     function _addPauser(address account) internal {
189         _pausers.add(account);
190         emit PauserAdded(account);
191     }
192 
193     function _removePauser(address account) internal {
194         _pausers.remove(account);
195         emit PauserRemoved(account);
196     }
197 }
198 
199 contract Pausable is PauserRole {
200     event Paused(address account);
201     event Unpaused(address account);
202 
203     bool private _paused;
204 
205     constructor () internal {
206         _paused = false;
207     }
208 
209     /**
210      * @return true if the contract is paused, false otherwise.
211      */
212     function paused() public view returns (bool) {
213         return _paused;
214     }
215 
216     /**
217      * @dev Modifier to make a function callable only when the contract is not paused.
218      */
219     modifier whenNotPaused() {
220         require(!_paused);
221         _;
222     }
223 
224     /**
225      * @dev Modifier to make a function callable only when the contract is paused.
226      */
227     modifier whenPaused() {
228         require(_paused);
229         _;
230     }
231 
232     /**
233      * @dev called by the owner to pause, triggers stopped state
234      */
235     function pause() public onlyPauser whenNotPaused {
236         _paused = true;
237         emit Paused(msg.sender);
238     }
239 
240     /**
241      * @dev called by the owner to unpause, returns to normal state
242      */
243     function unpause() public onlyPauser whenPaused {
244         _paused = false;
245         emit Unpaused(msg.sender);
246     }
247 }
248 
249 contract MCHDailyActionV3 is Ownable, Pausable {
250 
251   address public validator;
252   mapping(address => int64) public lastActionDate;
253 
254   event Action(
255                address indexed user,
256                int64 at
257                );
258 
259   constructor(address _varidator) public {
260     validator = _varidator;
261   }
262 
263   function setValidater(address _varidator) external onlyOwner() {
264     validator = _varidator;
265   }
266 
267   function requestDailyActionReward(bytes calldata _signature, int64 _time) external whenNotPaused() {
268     require(validateSig(msg.sender, _time, _signature), "invalid signature");
269     int64 day = _time / 86400;
270     require(lastActionDate[msg.sender] < day);
271     lastActionDate[msg.sender] = day;
272     emit Action(
273                 msg.sender,
274                 _time
275                 );
276   }
277 
278   function validateSig(address _from, int64 _time, bytes memory _signature) public view returns (bool) {
279     require(validator != address(0));
280     address signer = recover(ethSignedMessageHash(encodeData(_from, _time)), _signature);
281     return (signer == validator);
282   }
283 
284   function encodeData(address _from, int64 _time) public pure returns (bytes32) {
285     return keccak256(abi.encode(
286                                 _from,
287                                 _time
288                                 )
289                      );
290   }
291 
292   function ethSignedMessageHash(bytes32 _data) public pure returns (bytes32) {
293     return ECDSA.toEthSignedMessageHash(_data);
294   }
295 
296   function recover(bytes32 _data, bytes memory _signature) public pure returns (address) {
297     return ECDSA.recover(_data, _signature);
298   }
299 }