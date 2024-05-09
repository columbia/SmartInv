1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract BasicAccessControl {
49     address public owner;
50     // address[] public moderators;
51     uint16 public totalModerators = 0;
52     mapping (address => bool) public moderators;
53     bool public isMaintaining = false;
54 
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     modifier onlyModerators() {
65         require(msg.sender == owner || moderators[msg.sender] == true);
66         _;
67     }
68 
69     modifier isActive {
70         require(!isMaintaining);
71         _;
72     }
73 
74     function ChangeOwner(address _newOwner) onlyOwner public {
75         if (_newOwner != address(0)) {
76             owner = _newOwner;
77         }
78     }
79 
80 
81     function AddModerator(address _newModerator) onlyOwner public {
82         if (moderators[_newModerator] == false) {
83             moderators[_newModerator] = true;
84             totalModerators += 1;
85         }
86     }
87     
88     function RemoveModerator(address _oldModerator) onlyOwner public {
89         if (moderators[_oldModerator] == true) {
90             moderators[_oldModerator] = false;
91             totalModerators -= 1;
92         }
93     }
94 
95     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
96         isMaintaining = _isMaintaining;
97     }
98 }
99 
100 interface IERC20 {
101     function totalSupply() external view returns (uint256);
102     function balanceOf(address who) external view returns (uint256);
103     function allowance(address owner, address spender) external view returns (uint256);
104     function transfer(address to, uint256 value) external returns (bool);
105     function approve(address spender, uint256 value) external returns (bool);
106     function transferFrom(address from, address to, uint256 value) external returns (bool);
107     event Transfer(address indexed from, address indexed to, uint256 value);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract CubegoCoreInterface {
112     function getMaterialSupply(uint _mId) constant external returns(uint);
113     function getMyMaterialById(address _owner, uint _mId) constant external returns(uint);
114     function transferMaterial(address _sender, address _receiver, uint _mId, uint _amount) external;
115 }
116 
117 contract CubegoWood is IERC20, BasicAccessControl {
118     using SafeMath for uint;
119     string public constant name = "CubegoWood";
120     string public constant symbol = "CUBWO";
121     uint public constant decimals = 0;
122     
123     mapping (address => mapping (address => uint256)) private _allowed;
124     uint public mId = 6;
125     CubegoCoreInterface public cubegoCore;
126 
127     function setConfig(address _cubegoCoreAddress, uint _mId) onlyModerators external {
128         cubegoCore = CubegoCoreInterface(_cubegoCoreAddress);
129         mId = _mId;
130     }
131 
132     function emitTransferEvent(address from, address to, uint tokens) onlyModerators external {
133         emit Transfer(from, to, tokens);
134     }
135 
136     function totalSupply() public view returns (uint256) {
137         return cubegoCore.getMaterialSupply(mId);
138     }
139 
140     function balanceOf(address owner) public view returns (uint256) {
141         return cubegoCore.getMyMaterialById(owner, mId);
142     }
143 
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     function transfer(address to, uint256 value) public returns (bool) {
149         cubegoCore.transferMaterial(msg.sender, to, mId, value);
150         return true;
151     }
152 
153     function approve(address spender, uint256 value) public returns (bool) {
154         require(spender != address(0));
155         _allowed[msg.sender][spender] = value;
156         emit Approval(msg.sender, spender, value);
157         return true;
158     }
159 
160     function transferFrom(address from, address to, uint256 value) public returns (bool) {
161         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
162         cubegoCore.transferMaterial(from, to, mId, value);
163         return true;
164     }
165 
166     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
167         require(spender != address(0));
168 
169         _allowed[msg.sender][spender] = (
170         _allowed[msg.sender][spender].add(addedValue));
171         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
172         return true;
173     }
174 
175     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
176         require(spender != address(0));
177 
178         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
179         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
180         return true;
181     }
182 
183 }