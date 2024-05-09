1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-01
3 */
4 
5 /*
6 
7     /     |  __    / ____|
8    /      | |__) | | |
9   / /    |  _  /  | |
10  / ____   | |    | |____
11 /_/    _ |_|  _  _____|
12 
13 * ARC: global/KYFV2.sol
14 *
15 * Latest source (may be newer): https://github.com/arcxgame/contracts/blob/master/contracts/global/KYFV2.sol
16 *
17 * Contract Dependencies: 
18 *	- Context
19 *	- IKYFV2
20 *	- Ownable
21 * Libraries: (none)
22 *
23 * MIT License
24 * ===========
25 *
26 * Copyright (c) 2020 ARC
27 *
28 * Permission is hereby granted, free of charge, to any person obtaining a copy
29 * of this software and associated documentation files (the "Software"), to deal
30 * in the Software without restriction, including without limitation the rights
31 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
32 * copies of the Software, and to permit persons to whom the Software is
33 * furnished to do so, subject to the following conditions:
34 *
35 * The above copyright notice and this permission notice shall be included in all
36 * copies or substantial portions of the Software.
37 *
38 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
39 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
40 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
41 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
42 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
43 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
44 */
45 
46 /* ===============================================
47 * Flattened with Solidifier by Coinage
48 * 
49 * https://solidifier.coina.ge
50 * ===============================================
51 */
52 
53 
54 pragma solidity ^0.5.0;
55 
56 /*
57  * @dev Provides information about the current execution context, including the
58  * sender of the transaction and its data. While these are generally available
59  * via msg.sender and msg.data, they should not be accessed in such a direct
60  * manner, since when dealing with GSN meta-transactions the account sending and
61  * paying for execution may not be the actual sender (as far as an application
62  * is concerned).
63  *
64  * This contract is only required for intermediate, library-like contracts.
65  */
66 contract Context {
67     // Empty internal constructor, to prevent people from mistakenly deploying
68     // an instance of this contract, which should be used via inheritance.
69     constructor () internal { }
70     // solhint-disable-previous-line no-empty-blocks
71 
72     function _msgSender() internal view returns (address payable) {
73         return msg.sender;
74     }
75 
76     function _msgData() internal view returns (bytes memory) {
77         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
78         return msg.data;
79     }
80 }
81 
82 
83 /**
84  * @dev Contract module which provides a basic access control mechanism, where
85  * there is an account (an owner) that can be granted exclusive access to
86  * specific functions.
87  *
88  * This module is used through inheritance. It will make available the modifier
89  * `onlyOwner`, which can be applied to your functions to restrict their use to
90  * the owner.
91  */
92 contract Ownable is Context {
93     address private _owner;
94 
95     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97     /**
98      * @dev Initializes the contract setting the deployer as the initial owner.
99      */
100     constructor () internal {
101         address msgSender = _msgSender();
102         _owner = msgSender;
103         emit OwnershipTransferred(address(0), msgSender);
104     }
105 
106     /**
107      * @dev Returns the address of the current owner.
108      */
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(isOwner(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     /**
122      * @dev Returns true if the caller is the current owner.
123      */
124     function isOwner() public view returns (bool) {
125         return _msgSender() == _owner;
126     }
127 
128     /**
129      * @dev Leaves the contract without owner. It will not be possible to call
130      * `onlyOwner` functions anymore. Can only be called by the current owner.
131      *
132      * NOTE: Renouncing ownership will leave the contract without an owner,
133      * thereby removing any functionality that is only available to the owner.
134      */
135     function renounceOwnership() public onlyOwner {
136         emit OwnershipTransferred(_owner, address(0));
137         _owner = address(0);
138     }
139 
140     /**
141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
142      * Can only be called by the current owner.
143      */
144     function transferOwnership(address newOwner) public onlyOwner {
145         _transferOwnership(newOwner);
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      */
151     function _transferOwnership(address newOwner) internal {
152         require(newOwner != address(0), "Ownable: new owner is the zero address");
153         emit OwnershipTransferred(_owner, newOwner);
154         _owner = newOwner;
155     }
156 }
157 
158 
159 interface IKYFV2 {
160 
161     function checkVerified(
162         address _user
163     )
164         external
165         view
166         returns (bool);
167 
168 }
169 
170 
171 contract KYFV2 is Ownable, IKYFV2 {
172 
173     address public verifier;
174 
175     uint256 public count;
176 
177     uint256 public hardCap;
178 
179     mapping (address => bool) public isVerified;
180 
181     event Verified (address _user, address _verified);
182     event Removed (address _user);
183     event VerifierSet (address _verifier);
184     event HardCapSet (uint256 _hardCap);
185 
186     function checkVerified(
187         address _user
188     )
189         external
190         view
191         returns (bool)
192     {
193         return isVerified[_user];
194     }
195 
196     function verify(
197         address _user,
198         uint8 _v,
199         bytes32 _r,
200         bytes32 _s
201     )
202         public
203         returns (bool)
204     {
205         require(
206             count < hardCap,
207             "Hard cap reached"
208         );
209 
210         require(
211             isVerified[_user] == false,
212             "User has already been verified"
213         );
214 
215         bytes32 sigHash = keccak256(
216             abi.encodePacked(
217                 _user
218             )
219         );
220 
221         bytes32 recoveryHash = keccak256(
222             abi.encodePacked("\x19Ethereum Signed Message:\n32", sigHash)
223         );
224 
225         address recoveredAddress = ecrecover(
226             recoveryHash,
227             _v,
228             _r,
229             _s
230         );
231 
232         require(
233             recoveredAddress == verifier,
234             "Invalid signature"
235         );
236 
237         isVerified[_user] = true;
238 
239         count++;
240 
241         emit Verified(_user, verifier);
242     }
243 
244     function removeMultiple(
245         address[] memory _users
246     )
247         public
248     {
249         for (uint256 i = 0; i < _users.length; i++) {
250             remove(_users[i]);
251         }
252     }
253 
254     function remove(
255         address _user
256     )
257         public
258         onlyOwner
259     {
260         delete isVerified[_user];
261         count--;
262 
263         emit Removed(_user);
264     }
265 
266     function setVerifier(
267         address _verifier
268     )
269         public
270         onlyOwner
271     {
272         verifier = _verifier;
273         emit VerifierSet(_verifier);
274     }
275 
276     function setHardCap(
277         uint256 _hardCap
278     )
279         public
280         onlyOwner
281     {
282         hardCap = _hardCap;
283         emit HardCapSet(_hardCap);
284     }
285 
286 }