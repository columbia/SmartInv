1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   function totalSupply() public constant returns (uint256);
5 
6   function balanceOf(address _who) public constant returns (uint256);
7 
8   function allowance(address _owner, address _spender) public constant returns (uint256);
9 
10   function transfer(address _to, uint256 _value) public returns (bool);
11 
12   function approve(address _spender, uint256 _fromValue,uint256 _toValue) public returns (bool);
13 
14   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15 
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract Ownable {
22   address public owner;
23 
24   event OwnershipRenounced(address indexed previousOwner);
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   function transferOwnership(address _newOwner) public onlyOwner {
42     require(_newOwner != address(0));
43     emit OwnershipTransferred(owner, _newOwner);
44     owner = _newOwner;
45   }
46 
47   
48 }
49 
50 contract Pausable is Ownable {
51   event Paused();
52   event Unpaused();
53 
54   bool public paused = false;
55 
56   modifier whenNotPaused() {
57     require(!paused);
58     _;
59   }
60 
61   modifier whenPaused() {
62     require(paused);
63     _;
64   }
65 
66   function pause() public onlyOwner whenNotPaused {
67     paused = true;
68     emit Paused();
69   }
70 
71   function unpause() public onlyOwner whenPaused {
72     paused = false;
73     emit Unpaused();
74   }
75 }
76 
77 library SafeMath {
78   
79   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
80     require(_b <= _a);
81     uint256 c = _a - _b;
82 
83     return c;
84   }
85 
86   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
87     uint256 c = _a + _b;
88     require(c >= _a);
89 
90     return c;
91   }
92 
93   
94 }
95 
96 contract NDNLink is ERC20, Pausable {
97   using SafeMath for uint256;
98 
99   mapping (address => uint256) balances;
100   mapping (address => mapping (address => uint256)) allowed;
101 
102   string public symbol;
103   string public  name;
104   uint256 public decimals;
105   uint256 _totalSupply;
106 
107   constructor() public {
108     symbol = "NDN";
109     name = "NDN Link";
110     decimals = 18;
111 
112     _totalSupply = 50*(10**26);
113     balances[owner] = _totalSupply;
114     emit Transfer(address(0), owner, _totalSupply);
115   }
116 
117   function totalSupply() public  constant returns (uint256) {
118     return _totalSupply;
119   }
120 
121   function balanceOf(address _owner) public  constant returns (uint256) {
122     return balances[_owner];
123   }
124 
125   function allowance(address _owner, address _spender) public  constant returns (uint256) {
126     return allowed[_owner][_spender];
127   }
128 
129   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
130     require(_value <= balances[msg.sender]);
131     require(_to != address(0));
132 
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   function approve(address _spender, uint256 _fromValue, uint256 _toValue) public whenNotPaused returns (bool) {
140     require(_spender != address(0));
141     require(allowed[msg.sender][_spender] ==_fromValue);
142     allowed[msg.sender][_spender] = _toValue;
143     emit Approval(msg.sender, _spender, _toValue);
144     return true;
145   }
146 
147   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150     require(_to != address(0));
151 
152     balances[_from] = balances[_from].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155     emit Transfer(_from, _to, _value);
156     return true;
157   }
158 
159   
160 }