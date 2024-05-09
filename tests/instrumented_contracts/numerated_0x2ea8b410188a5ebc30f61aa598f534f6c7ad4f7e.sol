1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract BasicAccessControl {
50     address public owner;
51     // address[] public moderators;
52     uint16 public totalModerators = 0;
53     mapping (address => bool) public moderators;
54     bool public isMaintaining = false;
55 
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     modifier onlyModerators() {
66         require(msg.sender == owner || moderators[msg.sender] == true);
67         _;
68     }
69 
70     modifier isActive {
71         require(!isMaintaining);
72         _;
73     }
74 
75     function ChangeOwner(address _newOwner) onlyOwner public {
76         if (_newOwner != address(0)) {
77             owner = _newOwner;
78         }
79     }
80 
81 
82     function AddModerator(address _newModerator) onlyOwner public {
83         if (moderators[_newModerator] == false) {
84             moderators[_newModerator] = true;
85             totalModerators += 1;
86         }
87     }
88     
89     function RemoveModerator(address _oldModerator) onlyOwner public {
90         if (moderators[_oldModerator] == true) {
91             moderators[_oldModerator] = false;
92             totalModerators -= 1;
93         }
94     }
95 
96     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
97         isMaintaining = _isMaintaining;
98     }
99 }
100 
101 interface IERC20 {
102     function totalSupply() external view returns (uint256);
103     function balanceOf(address who) external view returns (uint256);
104     function allowance(address owner, address spender) external view returns (uint256);
105     function transfer(address to, uint256 value) external returns (bool);
106     function approve(address spender, uint256 value) external returns (bool);
107     function transferFrom(address from, address to, uint256 value) external returns (bool);
108     event Transfer(address indexed from, address indexed to, uint256 value);
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 contract CubegoCoreInterface {
113     function getMaterialSupply(uint _mId) constant external returns(uint);
114     function getMyMaterialById(address _owner, uint _mId) constant external returns(uint);
115     function transferMaterial(address _sender, address _receiver, uint _mId, uint _amount) external;
116 }
117 
118 contract CubegoPlastic is IERC20, BasicAccessControl {
119     using SafeMath for uint;
120     string public constant name = "CubegoPlastic";
121     string public constant symbol = "CUBPL";
122     uint public constant decimals = 0;
123     
124     mapping (address => mapping (address => uint256)) private _allowed;
125     uint public mId = 0;
126     CubegoCoreInterface public cubegoCore;
127 
128     function setConfig(address _cubegoCoreAddress, uint _mId) onlyModerators external {
129         cubegoCore = CubegoCoreInterface(_cubegoCoreAddress);
130         mId = _mId;
131     }
132 
133     function emitTransferEvent(address from, address to, uint tokens) onlyModerators external {
134         emit Transfer(from, to, tokens);
135     }
136 
137     function totalSupply() public view returns (uint256) {
138         return cubegoCore.getMaterialSupply(mId);
139     }
140 
141     function balanceOf(address owner) public view returns (uint256) {
142         return cubegoCore.getMyMaterialById(owner, mId);
143     }
144 
145     function allowance(address owner, address spender) public view returns (uint256) {
146         return _allowed[owner][spender];
147     }
148 
149     function transfer(address to, uint256 value) public returns (bool) {
150         cubegoCore.transferMaterial(msg.sender, to, mId, value);
151         return true;
152     }
153 
154     function approve(address spender, uint256 value) public returns (bool) {
155         require(spender != address(0));
156         _allowed[msg.sender][spender] = value;
157         emit Approval(msg.sender, spender, value);
158         return true;
159     }
160 
161     function transferFrom(address from, address to, uint256 value) public returns (bool) {
162         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
163         cubegoCore.transferMaterial(from, to, mId, value);
164         return true;
165     }
166 
167     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
168         require(spender != address(0));
169 
170         _allowed[msg.sender][spender] = (
171         _allowed[msg.sender][spender].add(addedValue));
172         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
173         return true;
174     }
175 
176     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
177         require(spender != address(0));
178 
179         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
180         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
181         return true;
182     }
183 
184 }