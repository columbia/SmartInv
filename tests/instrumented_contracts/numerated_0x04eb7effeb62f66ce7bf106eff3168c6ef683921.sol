1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5 		if (a == 0) {
6       		return 0;
7     	}
8 
9     	c = a * b;
10     	assert(c / a == b);
11     	return c;
12   	}
13 
14 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     	return a / b;
16 	}
17 
18 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     	assert(b <= a);
20     	return a - b;
21 	}
22 
23 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     	c = a + b;
25     	assert(c >= a);
26     	return c;
27 	}
28 	
29 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b != 0);
31         return a % b;
32     }
33 }
34 
35 contract Ownable {
36     address internal _owner;
37     
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39     
40     constructor() public {
41         _owner = msg.sender;
42         emit OwnershipTransferred(address(0), _owner);
43     }
44     
45     function owner() public view returns (address) {
46         return _owner;
47     }
48 
49     modifier onlyOwner() {
50         require(isOwner(), "you are not the owner!");
51         _;
52     }
53 
54     function isOwner() public view returns (bool) {
55         return msg.sender == _owner;
56     }
57     
58     function transferOwnership(address newOwner) public onlyOwner {
59         _transferOwnership(newOwner);
60     }
61     
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0), "cannot transfer ownership to ZERO address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 interface ITokenStore {
70     function totalSupply() external view returns (uint256);
71     function balanceOf(address account) external view returns (uint256);
72     function allowance(address owner, address spender) external view returns(uint256);
73     function transfer(address src, address dest, uint256 amount) external;
74     function approve(address owner, address spender, uint256 amount) external;
75     function mint(address dest, uint256 amount) external;
76     function burn(address dest, uint256 amount) external;
77 }
78 
79 /*
80     TokenStore
81 */
82 contract TokenStore is ITokenStore, Ownable {
83     using SafeMath for uint256;
84     
85     address private _tokenLogic;
86     uint256 private _totalSupply;
87     mapping (address => uint256) private _balances;
88     mapping (address => mapping (address => uint256)) private _allowed;
89     
90     constructor(uint256 totalSupply, address holder) public {
91         _totalSupply = totalSupply;
92         _balances[holder] = totalSupply;
93     }
94     
95     // token logic
96     event ChangeTokenLogic(address newTokenLogic);
97     
98     modifier onlyTokenLogic() {
99         require(msg.sender == _tokenLogic, "this method MUST be called by the security's logic address");
100         _;
101     }
102     
103     function tokenLogic() public view returns (address) {
104         return _tokenLogic;
105     }
106     
107     function setTokenLogic(ITokenLogic newTokenLogic) public onlyOwner {
108         _tokenLogic = newTokenLogic;
109         emit ChangeTokenLogic(newTokenLogic);
110     }
111     
112     function totalSupply() public view returns (uint256) {
113         return _totalSupply;
114     }
115     
116     function balanceOf(address account) public view returns (uint256) {
117         return _balances[account];
118     }
119     
120     function allowance(address owner, address spender) public view returns(uint256) {
121         return _allowed[owner][spender];
122     }
123     
124     function transfer(address src, address dest, uint256 amount) public onlyTokenLogic {
125         _balances[src] = _balances[src].sub(amount);
126         _balances[dest] = _balances[dest].add(amount);
127     }
128     
129     function approve(address owner, address spender, uint256 amount) public onlyTokenLogic {
130         _allowed[owner][spender] = amount;
131     }
132     
133     function mint(address dest, uint256 amount) public onlyTokenLogic {
134         _balances[dest] = _balances[dest].add(amount);
135         _totalSupply = _totalSupply.add(amount);
136     }
137     
138     function burn(address dest, uint256 amount) public onlyTokenLogic {
139         _balances[dest] = _balances[dest].sub(amount);
140         _totalSupply = _totalSupply.sub(amount);
141     }
142 }
143 
144 /*
145     TokenLogic
146 */
147 interface ITokenLogic {
148     function totalSupply() external view returns (uint256);
149     function balanceOf(address account) external view returns (uint256);
150     function allowance(address owner, address spender) external view returns (uint256);
151     function transfer(address from, address to, uint256 value) external returns (bool);
152     function approve(address spender, uint256 value, address owner) external returns (bool);
153     function transferFrom(address from, address to, uint256 value, address spender) external returns (bool);
154     function increaseAllowance(address spender, uint256 addedValue, address owner) external returns (bool);
155     function decreaseAllowance(address spender, uint256 subtractedValue, address owner) external returns (bool);
156 }