1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Emitted when `value` tokens are moved from one account (`from`) to
11      * another (`to`).
12      *
13      * Note that `value` may be zero.
14      */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     /**
18      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
19      * a call to {approve}. `value` is the new allowance.
20      */
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23     /**
24      * @dev Returns the value of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the value of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves a `value` amount of tokens from the caller's account to `to`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address to, uint256 value) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
53      * caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 value) external returns (bool);
67 
68     /**
69      * @dev Moves a `value` amount of tokens from `from` to `to` using the
70      * allowance mechanism. `value` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address from, address to, uint256 value) external returns (bool);
78 }
79 
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address) {
82         return msg.sender;
83     }
84 
85     function _msgData() internal view virtual returns (bytes calldata) {
86         return msg.data;
87     }
88 }
89 
90 
91 abstract contract Ownable is Context {
92     address private _owner;
93 
94     /**
95      * @dev The caller account is not authorized to perform an operation.
96      */
97     error OwnableUnauthorizedAccount(address account);
98 
99     /**
100      * @dev The owner is not a valid owner account. (eg. `address(0)`)
101      */
102     error OwnableInvalidOwner(address owner);
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     /**
107      * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
108      */
109     constructor(address initialOwner) {
110         _transferOwnership(initialOwner);
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         _checkOwner();
118         _;
119     }
120 
121     /**
122      * @dev Returns the address of the current owner.
123      */
124     function owner() public view virtual returns (address) {
125         return _owner;
126     }
127 
128     /**
129      * @dev Throws if the sender is not the owner.
130      */
131     function _checkOwner() internal view virtual {
132         if (owner() != _msgSender()) {
133             revert OwnableUnauthorizedAccount(_msgSender());
134         }
135     }
136 
137     /**
138      * @dev Leaves the contract without owner. It will not be possible to call
139      * `onlyOwner` functions. Can only be called by the current owner.
140      *
141      * NOTE: Renouncing ownership will leave the contract without an owner,
142      * thereby disabling any functionality that is only available to the owner.
143      */
144     function renounceOwnership() public virtual onlyOwner {
145         _transferOwnership(address(0));
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      * Can only be called by the current owner.
151      */
152     function transferOwnership(address newOwner) public virtual onlyOwner {
153         if (newOwner == address(0)) {
154             revert OwnableInvalidOwner(address(0));
155         }
156         _transferOwnership(newOwner);
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Internal function without access restriction.
162      */
163     function _transferOwnership(address newOwner) internal virtual {
164         address oldOwner = _owner;
165         _owner = newOwner;
166         emit OwnershipTransferred(oldOwner, newOwner);
167     }
168 }
169 
170 
171 contract Deelance_BSC_Claim is Ownable {
172     IERC20 public assignedToken;
173     
174     // mapping of user addresses to their token balances
175     mapping(address => uint256) public balances;
176     
177     bool public paused = false;
178 
179     constructor(IERC20 _token, address _owner) Ownable(_owner) {
180         assignedToken = _token;
181     }
182 
183     modifier whenNotPaused() {
184         require(!paused, "Contract is paused");
185         _;
186     }
187 
188     // owner can pause/unpause the contract
189     function setPaused(bool _paused) external onlyOwner {
190         paused = _paused;
191     }
192 
193     // only callable by owner, used to add users to the contract and assign them token balances
194     function addUsers(address[] calldata _users, uint256[] calldata _amounts) external onlyOwner  {
195         require(_users.length == _amounts.length, "Users and amounts arrays must have the same length");
196 
197         uint256 totalAmount = 0;
198         for(uint256 i = 0; i < _users.length; i++) {
199             balances[_users[i]] += _amounts[i];
200             totalAmount += _amounts[i];
201         }
202         
203         require(assignedToken.transferFrom(msg.sender, address(this), totalAmount), "Token transfer failed");
204     }
205 
206     // users can claim their tokens by calling this function
207     function claimTokens() external whenNotPaused {
208         uint256 amount = balances[msg.sender];
209         require(amount > 0, "No tokens to claim");
210         require(assignedToken.balanceOf(address(this)) >= amount, "Not enough tokens in the contract");
211         
212         // update balance before transfer to prevent reentrancy attacks
213         balances[msg.sender] = 0;
214         
215         require(assignedToken.transfer(msg.sender, amount), "Token transfer failed");
216     }
217     
218     // owner can withdraw any unclaimed tokens of the assigned type
219     function withdraw() external onlyOwner {
220         uint256 contractBalance = assignedToken.balanceOf(address(this));
221         require(contractBalance > 0, "No tokens to withdraw");
222         
223         require(assignedToken.transfer(owner(), contractBalance), "Token transfer failed");
224     }
225 
226     // only callable by owner, used to remove a user from the contract and zero their balance
227     function removeUser(address _user) external onlyOwner {
228         require(balances[_user] > 0, "User does not exist or balance is already zero");
229         balances[_user] = 0;
230     }
231 
232     // only callable by owner, used to modify the token amount of a user
233     function modifyUserAmount(address _user, uint256 _newAmount) external onlyOwner {
234         require(balances[_user] > 0, "User does not exist");
235         balances[_user] = _newAmount;
236     }
237 
238     // owner can withdraw any type of ERC20 tokens
239     function withdrawOtherTokens(IERC20 _token) external onlyOwner {
240         uint256 contractBalance = _token.balanceOf(address(this));
241         require(contractBalance > 0, "No tokens to withdraw");
242 
243         require(_token.transfer(owner(), contractBalance), "Token transfer failed");
244     }
245 }