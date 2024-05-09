1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
5     if (_a == 0) { return 0; }
6     c = _a * _b;
7     assert(c / _a == _b);
8     return c;
9   }
10 
11   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
12     return _a / _b;
13   }
14 
15   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
16     assert(_b <= _a);
17     return _a - _b;
18   }
19 
20   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
21     c = _a + _b;
22     assert(c >= _a);
23     return c;
24   }
25 }
26 
27 contract ERC20 {
28   function totalSupply() public view returns (uint256);
29   function balanceOf(address _who) public view returns (uint256);
30   function allowance(address _owner, address _spender) public view returns (uint256);
31   function transfer(address _to, uint256 _value) public returns (bool);
32   function approve(address _spender, uint256 _value) public returns (bool);
33   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract Ownable {
39   address public owner;
40 
41   event OwnershipRenounced(address indexed previousOwner);
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43   modifier onlyOwner() { require(msg.sender == owner); _; }
44 
45   constructor() public { owner = msg.sender; }
46 
47   function renounceOwnership() public onlyOwner() {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 
52   function transferOwnership(address _newOwner) public onlyOwner() {
53     _transferOwnership(_newOwner);
54   }
55 
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 contract AdjustableToken is ERC20, Ownable {
64   using SafeMath for uint256;
65 
66   uint256 totalSupply_;
67   bool public adjusted;
68   mapping(address => uint256) balances;
69   mapping (address => mapping (address => uint256)) internal allowed;
70 
71   event Adjusted(address indexed who, uint256 value);
72   modifier onlyOnce() { require(!adjusted); _; }
73 
74   function totalSupply() public view returns (uint256) {
75     return totalSupply_;
76   }
77 
78   function balanceOf(address _owner) public view returns (uint256) {
79     return balances[_owner];
80   }
81 
82   function allowance(address _owner, address _spender) public view returns (uint256) {
83     return allowed[_owner][_spender];
84   }
85 
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_value <= balances[msg.sender]);
88     require(_to != address(0));
89 
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   function approve(address _spender, uint256 _value) public returns (bool) {
97     allowed[msg.sender][_spender] = _value;
98     emit Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
103     require(_value <= balances[_from]);
104     require(_value <= allowed[_from][msg.sender]);
105     require(_to != address(0));
106 
107     balances[_from] = balances[_from].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
110     emit Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
115     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
116     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117     return true;
118   }
119 
120   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
121     uint256 oldValue = allowed[msg.sender][_spender];
122     if (_subtractedValue >= oldValue) {
123       allowed[msg.sender][_spender] = 0;
124     } else {
125       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126     }
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131   function adjustSupply(uint256 _value) external onlyOwner() onlyOnce() {
132     adjusted = true;
133     require(_value <= balances[msg.sender]);
134     balances[msg.sender] = balances[msg.sender].sub(_value);
135     totalSupply_ = totalSupply_.sub(_value);
136     emit Adjusted(msg.sender, _value);
137     emit Transfer(msg.sender, address(0), _value);
138   }
139 }
140 
141 contract BitSongToken is AdjustableToken {
142   string public name;
143   string public symbol;
144   uint8 public decimals;
145 
146   constructor(string _name, string _symbol, uint8 _decimals, uint256 _initialSupply) public {
147     name = _name;
148     symbol = _symbol;
149     decimals = _decimals;
150     totalSupply_ = _initialSupply * 10**uint256(decimals);
151     balances[msg.sender] = totalSupply_;
152   }
153 }