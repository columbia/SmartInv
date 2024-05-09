1 pragma solidity ^0.5.6;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b != 0);
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32     address public authorizedCaller;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     constructor() public {
37         owner = msg.sender;
38         authorizedCaller = msg.sender;
39     }
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44     modifier onlyAuthorized() {
45         require(msg.sender == owner || msg.sender == authorizedCaller);
46         _;
47     }
48     function transferAuthorizedCaller(address _newAuthorizedCaller) public onlyOwner {
49         require(_newAuthorizedCaller != address(0));
50         authorizedCaller = _newAuthorizedCaller;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54         require(_newOwner != address(0));
55         emit OwnershipTransferred(owner, _newOwner);
56         owner = _newOwner;
57     }
58 }
59 
60 contract ERC20 {
61     function totalSupply() public view returns (uint256);
62 
63     function balanceOf(address _tokenOwner) public view returns (uint);
64 
65     function transfer(address _to, uint _amount) public returns (bool);
66 
67     function transferFrom(address _from, address _to, uint _amount) public returns (bool);
68 
69     function allowance(address _tokenOwner, address _spender) public view returns (uint);
70 
71     function approve(address _spender, uint _amount) public returns (bool);
72 
73     event Transfer(address indexed from, address indexed to, uint tokens);
74     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
75 }
76 
77 contract BTourToken is ERC20, Ownable {
78     using SafeMath for uint256;
79 
80     uint8 public constant decimals = 18;
81     uint256 public constant _totalSupply = 2 * (10 ** 9) * (10 ** uint256(decimals));
82     string public constant name = "BTour Chain";
83     string public constant symbol = "BTOUR";
84 
85     bool public isPayable = true;
86     bool public isHalted = false;
87 
88     mapping(address => uint256) internal balances;
89     mapping(address => mapping(address => uint256)) internal allowed;
90     mapping(address => bool) public locked;
91 
92     constructor() public {
93         balances[msg.sender] = _totalSupply;
94     }
95 
96     modifier checkHalted() {
97         require(isHalted == false);
98         _;
99     }
100 
101     function() external payable {
102         if (isPayable == false || isHalted == true) {
103             revert();
104         }
105     }
106 
107     function totalSupply() public view returns (uint256) {
108         return _totalSupply;
109     }
110 
111     function sendFeeCurrency(address payable _receiver, uint256 _amount) external payable onlyAuthorized returns (bool) {
112         if (isPayable == false) {
113             revert();
114         }
115 
116         _receiver.transfer(_amount);
117         return true;
118     }
119 
120     function setIsPayable(bool p) external onlyAuthorized {
121         isPayable = p;
122     }
123 
124     function setHalted(bool _isHalted) external onlyOwner {
125         isHalted = _isHalted;
126     }
127 
128     function setLock(address _addr, bool _lock) external onlyAuthorized {
129         locked[_addr] = _lock;
130     }
131 
132     function balanceOf(address _tokenOwner) public view returns (uint) {
133         return balances[_tokenOwner];
134     }
135 
136     function transfer(address _to, uint _amount) public checkHalted returns (bool) {
137         if (msg.sender != owner) {
138             require(locked[msg.sender] == false && locked[_to] == false);
139         }
140         balances[msg.sender] = balances[msg.sender].sub(_amount);
141         balances[_to] = balances[_to].add(_amount);
142         emit Transfer(msg.sender, _to, _amount);
143         return true;
144     }
145 
146     function transferFrom(address _from, address _to, uint _amount) public checkHalted returns (bool) {
147         if (msg.sender != owner) {
148             require(locked[msg.sender] == false && locked[_from] == false && locked[_to] == false);
149         }
150         require(_amount <= balances[_from]);
151         if (_from != msg.sender) {
152             require(_amount <= allowed[_from][msg.sender]);
153             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
154         }
155         balances[_from] = balances[_from].sub(_amount);
156         balances[_to] = balances[_to].add(_amount);
157         emit Transfer(_from, _to, _amount);
158         return true;
159     }
160 
161     function allowance(address _tokenOwner, address _spender) public view returns (uint) {
162         return allowed[_tokenOwner][_spender];
163     }
164 
165     function approve(address _spender, uint _amount) public checkHalted returns (bool) {
166         require(locked[_spender] == false && locked[msg.sender] == false);
167 
168         allowed[msg.sender][_spender] = _amount;
169         emit Approval(msg.sender, _spender, _amount);
170         return true;
171     }
172 }