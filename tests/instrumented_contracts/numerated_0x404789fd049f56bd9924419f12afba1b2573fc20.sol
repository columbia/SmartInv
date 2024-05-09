1 /*
2 
3     /     |  __    / ____|
4    /      | |__) | | |
5   / /    |  _  /  | |
6  / ____   | |    | |____
7 /_/    _ |_|  _  _____|
8 
9 * ARC: global/KYF.sol
10 *
11 * Latest source (may be newer): https://github.com/arcxgame/contracts/blob/master/contracts/global/KYF.sol
12 *
13 * Contract Dependencies: 
14 *	- Context
15 *	- Ownable
16 * Libraries: (none)
17 *
18 * MIT License
19 * ===========
20 *
21 * Copyright (c) 2020 ARC
22 *
23 * Permission is hereby granted, free of charge, to any person obtaining a copy
24 * of this software and associated documentation files (the "Software"), to deal
25 * in the Software without restriction, including without limitation the rights
26 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
27 * copies of the Software, and to permit persons to whom the Software is
28 * furnished to do so, subject to the following conditions:
29 *
30 * The above copyright notice and this permission notice shall be included in all
31 * copies or substantial portions of the Software.
32 *
33 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
34 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
35 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
36 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
37 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
38 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
39 */
40 
41 /* ===============================================
42 * Flattened with Solidifier by Coinage
43 * 
44 * https://solidifier.coina.ge
45 * ===============================================
46 */
47 
48 
49 pragma solidity ^0.5.0;
50 
51 /*
52  * @dev Provides information about the current execution context, including the
53  * sender of the transaction and its data. While these are generally available
54  * via msg.sender and msg.data, they should not be accessed in such a direct
55  * manner, since when dealing with GSN meta-transactions the account sending and
56  * paying for execution may not be the actual sender (as far as an application
57  * is concerned).
58  *
59  * This contract is only required for intermediate, library-like contracts.
60  */
61 contract Context {
62     // Empty internal constructor, to prevent people from mistakenly deploying
63     // an instance of this contract, which should be used via inheritance.
64     constructor () internal { }
65     // solhint-disable-previous-line no-empty-blocks
66 
67     function _msgSender() internal view returns (address payable) {
68         return msg.sender;
69     }
70 
71     function _msgData() internal view returns (bytes memory) {
72         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
73         return msg.data;
74     }
75 }
76 
77 
78 /**
79  * @dev Contract module which provides a basic access control mechanism, where
80  * there is an account (an owner) that can be granted exclusive access to
81  * specific functions.
82  *
83  * This module is used through inheritance. It will make available the modifier
84  * `onlyOwner`, which can be applied to your functions to restrict their use to
85  * the owner.
86  */
87 contract Ownable is Context {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     /**
93      * @dev Initializes the contract setting the deployer as the initial owner.
94      */
95     constructor () internal {
96         address msgSender = _msgSender();
97         _owner = msgSender;
98         emit OwnershipTransferred(address(0), msgSender);
99     }
100 
101     /**
102      * @dev Returns the address of the current owner.
103      */
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     /**
109      * @dev Throws if called by any account other than the owner.
110      */
111     modifier onlyOwner() {
112         require(isOwner(), "Ownable: caller is not the owner");
113         _;
114     }
115 
116     /**
117      * @dev Returns true if the caller is the current owner.
118      */
119     function isOwner() public view returns (bool) {
120         return _msgSender() == _owner;
121     }
122 
123     /**
124      * @dev Leaves the contract without owner. It will not be possible to call
125      * `onlyOwner` functions anymore. Can only be called by the current owner.
126      *
127      * NOTE: Renouncing ownership will leave the contract without an owner,
128      * thereby removing any functionality that is only available to the owner.
129      */
130     function renounceOwnership() public onlyOwner {
131         emit OwnershipTransferred(_owner, address(0));
132         _owner = address(0);
133     }
134 
135     /**
136      * @dev Transfers ownership of the contract to a new account (`newOwner`).
137      * Can only be called by the current owner.
138      */
139     function transferOwnership(address newOwner) public onlyOwner {
140         _transferOwnership(newOwner);
141     }
142 
143     /**
144      * @dev Transfers ownership of the contract to a new account (`newOwner`).
145      */
146     function _transferOwnership(address newOwner) internal {
147         require(newOwner != address(0), "Ownable: new owner is the zero address");
148         emit OwnershipTransferred(_owner, newOwner);
149         _owner = newOwner;
150     }
151 }
152 
153 
154 contract KYF is Ownable {
155 
156     address public verifier;
157 
158     uint256 public count;
159 
160     mapping (address => bool) public isVerified;
161 
162     event Verified (address _user, address _verified);
163     event Removed (address _user);
164     event VerifierSet (address _verifier);
165 
166     function verify(
167         address _user,
168         uint8 _v,
169         bytes32 _r,
170         bytes32 _s
171     )
172         public
173         returns (bool)
174     {
175         require(
176             isVerified[_user] == false,
177             "User has already been verified"
178         );
179 
180         bytes32 sigHash = keccak256(
181             abi.encodePacked(
182                 _user
183             )
184         );
185 
186         bytes32 recoveryHash = keccak256(
187             abi.encodePacked("\x19Ethereum Signed Message:\n32", sigHash)
188         );
189 
190         address recoveredAddress = ecrecover(
191             recoveryHash,
192             _v,
193             _r,
194             _s
195         );
196 
197         require(
198             recoveredAddress == verifier,
199             "Invalid signature"
200         );
201 
202         isVerified[_user] = true;
203 
204         count++;
205 
206         emit Verified(_user, verifier);
207     }
208 
209     function removeMultiple(
210         address[] memory _users
211     )
212         public
213     {
214         for (uint256 i = 0; i < _users.length; i++) {
215             remove(_users[i]);
216         }
217     }
218 
219     function remove(
220         address _user
221     )
222         public
223         onlyOwner
224     {
225         delete isVerified[_user];
226         count--;
227 
228         emit Removed(_user);
229     }
230 
231     function setVerifier(
232         address _verifier
233     )
234         public
235         onlyOwner
236     {
237         verifier = _verifier;
238         emit VerifierSet(_verifier);
239     }
240 
241 }