1 // SPDX-License-Identifier: MIT
2 // 
3 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 
29 
30 // OpenZeppelin Contracts v4.3.2 (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 /**
106  * @title nonReentrant module to prevent recursive calling of functions
107  * @dev See https://medium.com/coinmonks/protect-your-solidity-smart-contracts-from-reentrancy-attacks-9972c3af7c21
108  */
109  
110 abstract contract nonReentrant {
111     bool private _reentryKey = false;
112     modifier reentryLock {
113         require(!_reentryKey, "cannot reenter a locked function");
114         _reentryKey = true;
115         _;
116         _reentryKey = false;
117     }
118 }
119 
120 
121 interface Ethalien {
122     
123     function tokensOfWalletOwner(address _owner) external view returns (uint[] memory);
124     function ownerOf(uint256 tokenId) external view returns (address);
125     
126 }
127 
128 interface BabyEthalien {
129     
130     function publicMint(uint256 _quantity, address _breederAddress) external ;
131     
132 }
133 
134 interface Star {
135     
136     function balanceOf(address account) external view returns (uint256);
137     function transferFrom(
138         address from,
139         address to,
140         uint256 tokenId
141     ) external;
142     
143 }
144 
145 // ***********************************
146 //           Ethalien Breeding
147 // ***********************************
148 /*
149  *     
150  *
151 */
152 
153 
154 pragma solidity ^0.8.0;
155 
156 contract ethAlienBreeding is Ownable, nonReentrant{
157 	
158 	Ethalien public ethalien;
159 	BabyEthalien public ethbaby;
160     Star public star;
161     bool mintState = false;
162 	
163 	mapping(uint => bool) public hasBreeded;
164     
165     function setEthAlienAddress(address _ethAlienAddress) public onlyOwner {
166         ethalien = Ethalien(_ethAlienAddress);
167     }
168 	
169     function setEthBabyAddress(address _ethBabyAddress) public onlyOwner {
170         ethbaby = BabyEthalien(_ethBabyAddress);
171     } 
172 
173     function setStarAddress(address _starAddress) public onlyOwner {
174         star = Star(_starAddress);
175     }
176 
177 
178     function changeMintState() public onlyOwner {
179         mintState = !mintState;
180     } 
181 
182 
183 	// in website mint function, user must run a call to Ethalien contract to
184 	// approve(THIS CONTRACT ADDRESS, token ID)
185 	
186 	function alienOrgy(uint256[] memory tokenIds) public {
187 		require(msg.sender == tx.origin, "No transaction from smart contracts!");
188         require(mintState == true, "Breeding must be active" );
189         require(tokenIds.length % 2 == 0, "Odd number of Aliens!");
190 
191 		for (uint i = 0; i < tokenIds.length/2; i++) {
192 
193             breedAlien(tokenIds[i*2], tokenIds[i*2+1]);
194 
195         }
196 		
197 
198 	}
199 	
200  function breedAlien(uint A, uint B) internal reentryLock{
201         require(hasBreeded[A] == false && hasBreeded[B] == false, "Invalid breeding pair");
202            require(ethalien.ownerOf(A) == msg.sender, "Claimant is not the owner");
203    require(ethalien.ownerOf(B) == msg.sender, "Claimant is not the owner");
204               
205         hasBreeded[A] = true;
206         hasBreeded[B] = true;
207 
208       star.transferFrom(msg.sender ,0x000000000000000000000000000000000000dEaD, 300 ether) ;
209         ethbaby.publicMint(1, msg.sender);
210                 
211     } 
212 
213 
214     function checkaliens(uint A) public view returns (bool){
215         return hasBreeded[A];
216     }
217 
218     function checkState() public view returns (bool){
219         return mintState;
220     }
221 
222     
223 	
224 
225 }