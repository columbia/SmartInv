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
69 /*
70     TokenLogic
71 */
72 interface ITokenLogic {
73     function totalSupply() external view returns (uint256);
74     function balanceOf(address account) external view returns (uint256);
75     function allowance(address owner, address spender) external view returns (uint256);
76     function transfer(address from, address to, uint256 value) external returns (bool);
77     function approve(address spender, uint256 value, address owner) external returns (bool);
78     function transferFrom(address from, address to, uint256 value, address spender) external returns (bool);
79     function increaseAllowance(address spender, uint256 addedValue, address owner) external returns (bool);
80     function decreaseAllowance(address spender, uint256 subtractedValue, address owner) external returns (bool);
81 }
82 
83 /*
84     TokenFront
85 */
86 interface IERC20 {
87     function totalSupply() external view returns (uint256);
88     function balanceOf(address who) external view returns (uint256);
89     function allowance(address owner, address spender) external view returns (uint256);
90     function transfer(address to, uint256 value) external returns (bool);
91     function approve(address spender, uint256 value) external returns (bool);
92     function transferFrom(address from, address to, uint256 value) external returns (bool);
93     
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 contract TokenFront is Ownable, IERC20 {
99     string private _name;
100     string private _symbol;
101     uint8 private _decimals;
102     ITokenLogic private _tokenLogic;
103     
104     constructor(string name, string symbol, uint8 decimals) public {
105         _name = name;
106         _symbol = symbol;
107         _decimals = decimals;
108     }
109     
110     // detail info
111     function name() external view returns (string) {
112         return _name;
113     }
114     
115     function symbol() external view returns (string) {
116         return _symbol;
117     }
118     
119     function decimals() external view returns (uint8) {
120         return _decimals;
121     }
122     
123     // tokenLogic
124     event ChangeTokenLogic(address newTokenLogic); 
125     
126     function tokenLogic() external view returns (address) {
127         return _tokenLogic;
128     }
129     
130     function setTokenLogic(ITokenLogic newTokenLogic) external onlyOwner {
131         _tokenLogic = newTokenLogic;
132         emit ChangeTokenLogic(newTokenLogic);
133     }
134     
135     // ERC20
136     function totalSupply() external view returns (uint256) {
137         return _tokenLogic.totalSupply();
138     }
139     
140     function balanceOf(address account) external view returns (uint256) {
141         return _tokenLogic.balanceOf(account);
142     }
143     
144     function allowance(address owner, address spender) external view returns (uint256) {
145         return _tokenLogic.allowance(owner, spender);
146     }
147 
148     function transfer(address to, uint256 value) external returns (bool) {
149         require(_tokenLogic.transfer(msg.sender, to, value));
150         emit Transfer(msg.sender, to, value);
151         return true;
152     }
153     
154     function transferFrom(address from, address to, uint256 value) external returns (bool) {
155         require(_tokenLogic.transferFrom(from, to, value, msg.sender));
156         emit Transfer(from, to, value);
157         return true;
158     }
159     
160     function approve(address spender, uint256 value) external returns (bool) {
161         require(_tokenLogic.approve(spender, value, msg.sender));
162         emit Approval(msg.sender, spender, value);
163         return true;
164     }
165     
166     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
167         require(_tokenLogic.increaseAllowance(spender, addedValue, msg.sender));
168         emit Approval(msg.sender, spender, _tokenLogic.allowance(msg.sender, spender));
169         return true;
170     }
171     
172     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
173         require(_tokenLogic.decreaseAllowance(spender, subtractedValue, msg.sender));
174         emit Approval(msg.sender, spender, _tokenLogic.allowance(msg.sender, spender));
175         return true;
176     }
177 }