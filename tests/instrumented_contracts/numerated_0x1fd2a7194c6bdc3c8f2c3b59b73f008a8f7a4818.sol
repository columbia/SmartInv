1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract ERC20 {
33     function totalSupply() public view returns (uint256);
34     function balanceOf(address who) public view returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     function allowance(address owner, address spender)
38     public view returns (uint256);
39 
40     function transferFrom(address from, address to, uint256 value)
41     public returns (bool);
42 
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(
45         address indexed owner,
46         address indexed spender,
47         uint256 value
48     );
49 }
50 
51 
52 /**
53  * @title SafeERC20
54  * @dev Wrappers around ERC20 operations that throw on failure.
55  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
56  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
57  */
58 library SafeERC20 {
59     function safeTransfer(ERC20 token, address to, uint256 value) internal {
60         require(token.transfer(to, value));
61     }
62 
63     function safeTransferFrom(
64         ERC20 token,
65         address from,
66         address to,
67         uint256 value
68     )
69     internal
70     {
71         require(token.transferFrom(from, to, value));
72     }
73 
74     function safeApprove(ERC20 token, address spender, uint256 value) internal {
75         require(token.approve(spender, value));
76     }
77 }
78 
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86     address public owner;
87 
88 
89     event OwnershipRenounced(address indexed previousOwner);
90     event OwnershipTransferred(
91         address indexed previousOwner,
92         address indexed newOwner
93     );
94 
95 
96     /**
97      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
98      * account.
99      */
100     constructor() public {
101         owner = msg.sender;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111 
112     /**
113      * @dev Allows the current owner to relinquish control of the contract.
114      * @notice Renouncing to ownership will leave the contract without an owner.
115      * It will not be possible to call the functions with the `onlyOwner`
116      * modifier anymore.
117      */
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipRenounced(owner);
120         owner = address(0);
121     }
122 
123     /**
124      * @dev Allows the current owner to transfer control of the contract to a newOwner.
125      * @param _newOwner The address to transfer ownership to.
126      */
127     function transferOwnership(address _newOwner) public onlyOwner {
128         _transferOwnership(_newOwner);
129     }
130 
131     /**
132      * @dev Transfers control of the contract to a newOwner.
133      * @param _newOwner The address to transfer ownership to.
134      */
135     function _transferOwnership(address _newOwner) internal {
136         require(_newOwner != address(0));
137         emit OwnershipTransferred(owner, _newOwner);
138         owner = _newOwner;
139     }
140 }
141 
142 
143 /**
144  * @title TokenTimelock
145  * @dev TokenTimelock is a token holder contract that will allow a
146  * beneficiary to extract the tokens after a given release time
147  */
148 contract TokenTimelock is Ownable {
149     using SafeERC20 for ERC20;
150     using SafeMath for uint256;
151 
152     // ERC20 basic token contract being held
153     ERC20 public token;
154 
155     mapping(address => uint256) public balances;
156     mapping(address => uint256) public releaseTime;
157 
158 
159     constructor(ERC20 _token) public {
160         token = _token;
161     }
162 
163     function addTokens(address _owner, uint256 _value, uint256 _releaseTime) onlyOwner external returns (bool) {
164         require(_owner != address(0));
165         token.safeTransferFrom(msg.sender, this, _value);
166 
167         balances[_owner] = balances[_owner].add(_value);
168         releaseTime[_owner] = now + _releaseTime * 1 days;
169     }
170 
171 
172     function getTokens() external {
173         require(balances[msg.sender] > 0);
174         require(releaseTime[msg.sender] < now);
175 
176         token.safeTransfer(msg.sender, balances[msg.sender]);
177         balances[msg.sender] = 0;
178         releaseTime[msg.sender] = 0;
179     }
180 }