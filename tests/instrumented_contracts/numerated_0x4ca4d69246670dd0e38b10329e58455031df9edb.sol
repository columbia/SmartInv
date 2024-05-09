1 pragma solidity 0.7.2;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 abstract contract Ownable is Context {
14     address private _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev Initializes the contract setting the deployer as the initial owner.
20      */
21     constructor() {
22         _setOwner(_msgSender());
23     }
24 
25     /**
26      * @dev Returns the address of the current owner.
27      */
28     function owner() public view virtual returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(owner() == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     /**
41      * @dev Leaves the contract without owner. It will not be possible to call
42      * `onlyOwner` functions anymore. Can only be called by the current owner.
43      *
44      * NOTE: Renouncing ownership will leave the contract without an owner,
45      * thereby removing any functionality that is only available to the owner.
46      */
47     function renounceOwnership() public virtual onlyOwner {
48         _setOwner(address(0));
49     }
50 
51     /**
52      * @dev Transfers ownership of the contract to a new account (`newOwner`).
53      * Can only be called by the current owner.
54      */
55     function transferOwnership(address newOwner) public virtual onlyOwner {
56         require(newOwner != address(0), "Ownable: new owner is the zero address");
57         _setOwner(newOwner);
58     }
59 
60     function _setOwner(address newOwner) private {
61         address oldOwner = _owner;
62         _owner = newOwner;
63         emit OwnershipTransferred(oldOwner, newOwner);
64     }
65 }
66 
67 interface IERC20 {
68     /**
69      * @dev Returns the amount of tokens in existence.
70      */
71     function totalSupply() external view returns (uint256);
72 
73     /**
74      * @dev Returns the amount of tokens owned by `account`.
75      */
76     function balanceOf(address account) external view returns (uint256);
77 
78     /**
79      * @dev Moves `amount` tokens from the caller's account to `recipient`.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transfer(address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Returns the remaining number of tokens that `spender` will be
89      * allowed to spend on behalf of `owner` through {transferFrom}. This is
90      * zero by default.
91      *
92      * This value changes when {approve} or {transferFrom} are called.
93      */
94     function allowance(address owner, address spender) external view returns (uint256);
95 
96     /**
97      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * IMPORTANT: Beware that changing an allowance with this method brings the risk
102      * that someone may use both the old and the new allowance by unfortunate
103      * transaction ordering. One possible solution to mitigate this race
104      * condition is to first reduce the spender's allowance to 0 and set the
105      * desired value afterwards:
106      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address spender, uint256 amount) external returns (bool);
111 
112     /**
113      * @dev Moves `amount` tokens from `sender` to `recipient` using the
114      * allowance mechanism. `amount` is then deducted from the caller's
115      * allowance.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(
122         address sender,
123         address recipient,
124         uint256 amount
125     ) external returns (bool);
126 
127     /**
128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
129      * another (`to`).
130      *
131      * Note that `value` may be zero.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     /**
136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
137      * a call to {approve}. `value` is the new allowance.
138      */
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 contract EthToBnbBridge is Ownable {
143     IERC20 token;
144     uint256 public fee;
145 
146     event FeeSet(uint256 _fee);
147     event MovedToBnb(address _user, uint256 _amount);
148 
149     constructor(address _token) public {
150         token = IERC20(_token);
151     }
152 
153     function setFee(uint256 _feeAmountEth) external onlyOwner {
154         fee = _feeAmountEth;
155 
156         emit FeeSet(_feeAmountEth);
157     }
158 
159     function unlock(address _receiver, uint256 _amount) external onlyOwner {
160         token.transfer(_receiver, _amount);
161     }
162 
163     function moveToBnb(uint256 _amount) external payable returns(uint256) {
164         require(msg.value == fee, "EthToBnbBridge: Invalid fee amount");
165 
166         token.transferFrom(msg.sender, address(this), _amount);
167 
168         emit MovedToBnb(msg.sender, _amount);
169         return _amount;
170     }
171 
172     function withdrawFee(uint256 _amount) external onlyOwner {
173         (msg.sender).transfer(_amount);
174     }
175 }