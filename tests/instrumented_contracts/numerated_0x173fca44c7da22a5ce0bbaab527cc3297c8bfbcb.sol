1 pragma solidity 0.5.13;
2 
3 library SafeMath {
4     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
5         if (_a == 0) {
6           return 0;
7         }
8         c = _a * _b;
9         require(c / _a == _b);
10         return c;
11     }
12 
13     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14         require(_b != 0); 
15         return _a / _b;
16     }
17 
18     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
19         require(_a >= _b); 
20         return _a - _b;
21     }
22 
23     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
24         c = _a + _b;
25         require(c >= _a);
26         return c;
27     }
28 }
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address _who) external view returns (uint256);
33     function transfer(address _to, uint256 _value) external returns (bool);
34     function approve(address spender, uint256 value) external returns (bool);
35     function transferFrom(address from, address to, uint256 value) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     event Approval(address indexed owner, address indexed spender, uint256 oldValue, uint256 value); 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Burn(address indexed burner, uint256 value);
40 }
41 
42 contract Ownable {
43     address public owner;
44     event OwnershipRenounced( address indexed previousOwner );
45     event OwnershipTransferred( address indexed previousOwner, address indexed newOwner );
46     constructor() public {
47         owner = msg.sender;
48     }
49  
50     function transferOwnership(address _newOwner) public onlyOwner {
51         _transferOwnership(_newOwner);
52     }
53  
54     function _transferOwnership(address _newOwner) internal {
55         require(_newOwner != address(0));
56         emit OwnershipTransferred(owner, _newOwner);
57         owner = _newOwner;
58     }
59  
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 }
65 
66 contract ERC20_CPM1_Token_v3 is Ownable, IERC20 {
67     using SafeMath for uint256;
68     mapping(address => uint256) internal balances;
69     mapping (address => mapping (address => uint256)) private _allowed;
70     uint256 internal totalSupply_;
71     string public name = "Cryptomillions Series 1";
72     uint8 public decimals = 18;                
73     string public symbol = "CPM-1";
74     uint private TotalSupply = 600000000000000000000000000;
75     string public version = '1.0';
76     constructor() public {
77         totalSupply_ = TotalSupply;
78         balances[owner] = TotalSupply;
79         emit Transfer(address(this), owner, TotalSupply); 
80     }
81  
82     function totalSupply() public view returns (uint256) {
83         return totalSupply_;
84     }
85  
86     function balanceOf(address _owner) public view returns (uint256) {
87         return balances[_owner];
88     }
89  
90     function transfer(address _to, uint256 _value) public returns (bool) {
91         _transfer(msg.sender, _to, _value);
92         return true;
93     }
94  
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96         _transfer(_from, _to, _value);
97         _approve(_from, msg.sender, _allowed[_from][msg.sender].sub(_value));
98         return true;
99     }
100  
101     function _transfer(address _from, address _to, uint256 _value) internal {
102         require(_from != address(0));
103         require(_to != address(0));
104         require(_to != address(this));
105         require(balances[_from] >= _value);
106         balances[_from] = balances[_from].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         emit Transfer(_from, _to, _value); 
109     }
110  
111     function allowance(address owner, address spender) public view returns (uint256) {
112         return _allowed[owner][spender];
113     }
114  
115     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
116         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
117         return true;
118     }
119  
120     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
121         if (subtractedValue > _allowed[msg.sender][spender]) { 
122         _allowed[msg.sender][spender] = 0;
123         } 
124         else {
125             _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
126         }
127         return true;
128     }
129  
130     function approve(address spender, uint256 value) public returns (bool) {
131         _approve(msg.sender, spender, value);
132         return true;
133     }
134  
135     function _approve(address owner, address spender, uint256 value) internal {
136         require(owner != address(0));
137         require(spender != address(0));
138         uint256 _currentValue = _allowed[owner][spender];  
139         if ( _allowed[owner][spender] == _currentValue ) {
140             _allowed[owner][spender] = value;    
141         }
142         emit Approval(owner, spender, _currentValue, value);
143     }
144  
145     function burnTokens(uint256 _value) public onlyOwner {
146         _burn(msg.sender, _value);
147     }
148  
149     function _burn(address _who, uint256 _value) internal {
150         require(_value != 0);
151         require(balances[_who] >= _value);
152         balances[_who] = balances[_who].sub(_value);
153         totalSupply_ = totalSupply_.sub(_value);
154         emit Burn(_who, _value);
155         emit Transfer(_who, address(0), _value);
156     }
157  
158     function contractAddress() public view returns(address){
159         return address(this);
160     }
161 }