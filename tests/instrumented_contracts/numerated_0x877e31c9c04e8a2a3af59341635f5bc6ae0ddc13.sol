1 /*
2 
3     /     |  __    / ____|
4    /      | |__) | | |
5   / /    |  _  /  | |
6  / ____   | |    | |____
7 /_/    _ |_|  _  _____|
8 
9 * ARC: global/KYFV2.sol
10 *
11 * Latest source (may be newer): https://github.com/arcxgame/contracts/blob/master/contracts/global/KYFV2.sol
12 *
13 * Contract Dependencies: 
14 *	- Context
15 *	- IKYFV2
16 *	- Ownable
17 * Libraries: (none)
18 *
19 * MIT License
20 * ===========
21 *
22 * Copyright (c) 2020 ARC
23 *
24 * Permission is hereby granted, free of charge, to any person obtaining a copy
25 * of this software and associated documentation files (the "Software"), to deal
26 * in the Software without restriction, including without limitation the rights
27 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
28 * copies of the Software, and to permit persons to whom the Software is
29 * furnished to do so, subject to the following conditions:
30 *
31 * The above copyright notice and this permission notice shall be included in all
32 * copies or substantial portions of the Software.
33 *
34 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
35 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
36 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
37 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
38 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
39 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
40 */
41 
42 /* ===============================================
43 * Flattened with Solidifier by Coinage
44 * 
45 * https://solidifier.coina.ge
46 * ===============================================
47 */
48 
49 
50 pragma solidity ^0.5.0;
51 
52 /*
53  * @dev Provides information about the current execution context, including the
54  * sender of the transaction and its data. While these are generally available
55  * via msg.sender and msg.data, they should not be accessed in such a direct
56  * manner, since when dealing with GSN meta-transactions the account sending and
57  * paying for execution may not be the actual sender (as far as an application
58  * is concerned).
59  *
60  * This contract is only required for intermediate, library-like contracts.
61  */
62 contract Context {
63     // Empty internal constructor, to prevent people from mistakenly deploying
64     // an instance of this contract, which should be used via inheritance.
65     constructor () internal { }
66     // solhint-disable-previous-line no-empty-blocks
67 
68     function _msgSender() internal view returns (address payable) {
69         return msg.sender;
70     }
71 
72     function _msgData() internal view returns (bytes memory) {
73         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
74         return msg.data;
75     }
76 }
77 
78 
79 /**
80  * @dev Contract module which provides a basic access control mechanism, where
81  * there is an account (an owner) that can be granted exclusive access to
82  * specific functions.
83  *
84  * This module is used through inheritance. It will make available the modifier
85  * `onlyOwner`, which can be applied to your functions to restrict their use to
86  * the owner.
87  */
88 contract Ownable is Context {
89     address private _owner;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     /**
94      * @dev Initializes the contract setting the deployer as the initial owner.
95      */
96     constructor () internal {
97         address msgSender = _msgSender();
98         _owner = msgSender;
99         emit OwnershipTransferred(address(0), msgSender);
100     }
101 
102     /**
103      * @dev Returns the address of the current owner.
104      */
105     function owner() public view returns (address) {
106         return _owner;
107     }
108 
109     /**
110      * @dev Throws if called by any account other than the owner.
111      */
112     modifier onlyOwner() {
113         require(isOwner(), "Ownable: caller is not the owner");
114         _;
115     }
116 
117     /**
118      * @dev Returns true if the caller is the current owner.
119      */
120     function isOwner() public view returns (bool) {
121         return _msgSender() == _owner;
122     }
123 
124     /**
125      * @dev Leaves the contract without owner. It will not be possible to call
126      * `onlyOwner` functions anymore. Can only be called by the current owner.
127      *
128      * NOTE: Renouncing ownership will leave the contract without an owner,
129      * thereby removing any functionality that is only available to the owner.
130      */
131     function renounceOwnership() public onlyOwner {
132         emit OwnershipTransferred(_owner, address(0));
133         _owner = address(0);
134     }
135 
136     /**
137      * @dev Transfers ownership of the contract to a new account (`newOwner`).
138      * Can only be called by the current owner.
139      */
140     function transferOwnership(address newOwner) public onlyOwner {
141         _transferOwnership(newOwner);
142     }
143 
144     /**
145      * @dev Transfers ownership of the contract to a new account (`newOwner`).
146      */
147     function _transferOwnership(address newOwner) internal {
148         require(newOwner != address(0), "Ownable: new owner is the zero address");
149         emit OwnershipTransferred(_owner, newOwner);
150         _owner = newOwner;
151     }
152 }
153 
154 
155 interface IKYFV2 {
156 
157     function checkVerified(
158         address _user
159     )
160         external
161         view
162         returns (bool);
163 
164 }
165 
166 
167 contract KYFV2 is Ownable, IKYFV2 {
168 
169     address public verifier;
170 
171     uint256 public count;
172 
173     uint256 public hardCap;
174 
175     mapping (address => bool) public isVerified;
176 
177     event Verified (address _user, address _verified);
178     event Removed (address _user);
179     event VerifierSet (address _verifier);
180     event HardCapSet (uint256 _hardCap);
181 
182     function checkVerified(
183         address _user
184     )
185         external
186         view
187         returns (bool)
188     {
189         return isVerified[_user];
190     }
191 
192     function verify(
193         address _user,
194         uint8 _v,
195         bytes32 _r,
196         bytes32 _s
197     )
198         public
199         returns (bool)
200     {
201         require(
202             count < hardCap,
203             "Hard cap reached"
204         );
205 
206         require(
207             isVerified[_user] == false,
208             "User has already been verified"
209         );
210 
211         bytes32 sigHash = keccak256(
212             abi.encodePacked(
213                 _user
214             )
215         );
216 
217         bytes32 recoveryHash = keccak256(
218             abi.encodePacked("\x19Ethereum Signed Message:\n32", sigHash)
219         );
220 
221         address recoveredAddress = ecrecover(
222             recoveryHash,
223             _v,
224             _r,
225             _s
226         );
227 
228         require(
229             recoveredAddress == verifier,
230             "Invalid signature"
231         );
232 
233         isVerified[_user] = true;
234 
235         count++;
236 
237         emit Verified(_user, verifier);
238     }
239 
240     function removeMultiple(
241         address[] memory _users
242     )
243         public
244     {
245         for (uint256 i = 0; i < _users.length; i++) {
246             remove(_users[i]);
247         }
248     }
249 
250     function remove(
251         address _user
252     )
253         public
254         onlyOwner
255     {
256         delete isVerified[_user];
257         count--;
258 
259         emit Removed(_user);
260     }
261 
262     function setVerifier(
263         address _verifier
264     )
265         public
266         onlyOwner
267     {
268         verifier = _verifier;
269         emit VerifierSet(_verifier);
270     }
271 
272     function setHardCap(
273         uint256 _hardCap
274     )
275         public
276         onlyOwner
277     {
278         hardCap = _hardCap;
279         emit HardCapSet(_hardCap);
280     }
281 
282 }