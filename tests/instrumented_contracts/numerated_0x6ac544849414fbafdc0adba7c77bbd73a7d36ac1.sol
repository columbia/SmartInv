1 pragma solidity ^0.4.24;
2 
3 contract IERC20 {
4     function balanceOf(address who) public view returns (uint256);
5     function allowance(address owner, address spender) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     function approve(address spender, uint256 value) public returns (bool);
8     function transferFrom(address from, address to, uint256 value) public returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that revert on error
16  */
17 library SafeMath {
18 
19     /**
20      * @dev Multiplies two numbers, reverts on overflow.
21      */
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
24         // benefit is lost if 'b' is also tested.
25         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b);
32 
33         return c;
34     }
35 
36     /**
37      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
38      */
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b > 0); // Solidity only automatically asserts when dividing by 0
41         uint256 c = a / b;
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43 
44         return c;
45     }
46 
47     /**
48      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b <= a);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     /**
58      * @dev Adds two numbers, reverts on overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a);
63 
64         return c;
65     }
66 
67     /**
68      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
69      * reverts when dividing by zero.
70      */
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b != 0);
73         return a % b;
74     }
75 }
76 
77 contract KBCC is IERC20{
78     using SafeMath for uint256;
79     
80     mapping (address => uint256) private _balances;
81     mapping (address => mapping (address => uint256)) private _allowed;
82 
83     string public name = "Knowledge Blockchain Coin";
84     uint8 public decimals = 6;
85     string public symbol = "KBCC";
86     uint256 public totalSupply =  1000000000 * (10 ** uint256(decimals)); // Total number of tokens in existence
87     address private owner; // contract master - super user
88     mapping (address => bool) private whiteList; // user can operate contract
89 
90     event fallbackTrigged(address indexed _who, uint256 _amount,bytes data);
91     function() public payable {emit fallbackTrigged(msg.sender, msg.value, msg.data);}
92 
93     constructor() public {
94         _balances[msg.sender] = totalSupply;   // Give the creator all initial tokens
95         owner = msg.sender;
96         whiteList[msg.sender] = true;
97     }
98 
99     modifier onlyOwner {
100         require(msg.sender == owner);
101         _;
102     }
103     
104      modifier inWhiteList {
105         require(whiteList[msg.sender]);
106         _;
107     }
108     
109     // transer contract to antoher user
110     function transferOwnership(address newOwner) public onlyOwner {
111         owner = newOwner;
112     }
113     
114     // only owner can set white list
115     function setWhiteList(address who, bool status) public onlyOwner {
116         whiteList[who] = status;
117     }
118     
119     // only owner can check white list
120     function isInWhiteList(address who) public view onlyOwner returns(bool)  {
121         return whiteList[who];
122     }
123 
124     function balanceOf(address who) public view returns (uint256) {
125         return _balances[who];
126     }
127 
128     function transfer(address to, uint256 value) public returns (bool) {
129         _transfer(msg.sender, to, value);
130         return true;
131     }
132 
133     function _transfer(address from, address to, uint256 value) internal {
134         require(value <= _balances[from]);
135         require(to != address(0));
136 
137         _balances[from] = _balances[from].sub(value);
138         _balances[to] = _balances[to].add(value);
139         emit Transfer(from, to, value);
140     }
141 
142     function allowance(address who, address spender) public view returns (uint256) {
143         return _allowed[who][spender];
144     }
145 
146     function approve(address spender, uint256 value) public returns (bool) {
147         require(spender != address(0));
148 
149         _allowed[msg.sender][spender] = value;
150         emit Approval(msg.sender, spender, value);
151         return true;
152     }
153 
154     function transferFrom(address from, address to, uint256 value) public returns (bool) {
155         require(value <= _allowed[from][msg.sender]);
156 
157         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
158         _transfer(from, to, value);
159         return true;
160     }
161 
162     // increase allowance
163     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
164         require(spender != address(0));
165 
166         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
167         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
168         return true;
169     }
170 
171     // decrease allowance
172     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
173         require(spender != address(0));
174 
175         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
176         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
177         return true;
178     }
179 
180     // mint more token 
181     function _mint(address account, uint256 value) public inWhiteList {
182         require(account != address(0));
183         totalSupply = totalSupply.add(value);
184         _balances[account] = _balances[account].add(value);
185         emit Transfer(address(0), account, value);
186     }
187 
188     // burn user token
189     function _burn(address account, uint256 value) public inWhiteList {
190         require(account != address(0));
191         require(value <= _balances[account]);
192 
193         totalSupply = totalSupply.sub(value);
194         _balances[account] = _balances[account].sub(value);
195         emit Transfer(account, address(0), value);
196     }
197     
198     // safe burn token 
199     function _burnFrom(address account, uint256 value) public inWhiteList {
200         require(value <= _allowed[account][msg.sender]);
201 
202         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
203         _burn(account, value);
204     }
205 
206 }