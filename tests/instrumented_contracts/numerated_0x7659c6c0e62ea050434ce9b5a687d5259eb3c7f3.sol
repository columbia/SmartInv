1 pragma solidity ^0.4.25;
2 
3 // @website sunpower.io
4 // @Partner ixx.com
5 // @Partner yunjiami.com
6  
7 contract ERC20 {
8   function totalSupply() public constant returns (uint256);
9 
10   function balanceOf(address _who) public constant returns (uint256);
11 
12   function allowance(address _owner, address _spender) public constant returns (uint256);
13 
14   function transfer(address _to, uint256 _value) public returns (bool);
15 
16   function approve(address _spender, uint256 _fromValue,uint256 _toValue) public returns (bool);
17 
18   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
19 
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract Ownable {
26   address public owner;
27 
28   event OwnershipRenounced(address indexed previousOwner);
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31   constructor() public {
32     owner = msg.sender;
33   }
34 
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   function transferOwnership(address _newOwner) public onlyOwner {
46     require(_newOwner != address(0));
47     emit OwnershipTransferred(owner, _newOwner);
48     owner = _newOwner;
49   }
50 
51   
52 }
53 
54 contract Pausable is Ownable {
55   event Paused();
56   event Unpaused();
57 
58   bool public paused = false;
59 
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   function pause() public onlyOwner whenNotPaused {
71     paused = true;
72     emit Paused();
73   }
74 
75   function unpause() public onlyOwner whenPaused {
76     paused = false;
77     emit Unpaused();
78   }
79 }
80 
81 library SafeMath {
82   
83   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
84     require(_b <= _a);
85     uint256 c = _a - _b;
86 
87     return c;
88   }
89 
90   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     uint256 c = _a + _b;
92     require(c >= _a);
93 
94     return c;
95   }
96 
97   
98 }
99 
100 contract SunPower is ERC20, Pausable {
101   using SafeMath for uint256;
102 
103   mapping (address => uint256) balances;
104   mapping (address => mapping (address => uint256)) allowed;
105 
106   string public symbol;
107   string public  name;
108   uint256 public decimals;
109   uint256 _totalSupply;
110 
111   constructor() public {
112     symbol = "SP";
113     name = "SunPower";
114     decimals = 18;
115 
116     _totalSupply = 6*(10**26);
117     balances[owner] = _totalSupply;
118     emit Transfer(address(0), owner, _totalSupply);
119   }
120 
121   function totalSupply() public  constant returns (uint256) {
122     return _totalSupply;
123   }
124 
125   function balanceOf(address _owner) public  constant returns (uint256) {
126     return balances[_owner];
127   }
128 
129   function allowance(address _owner, address _spender) public  constant returns (uint256) {
130     return allowed[_owner][_spender];
131   }
132 
133   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
134     require(_value <= balances[msg.sender]);
135     require(_to != address(0));
136 
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     emit Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   function approve(address _spender, uint256 _fromValue, uint256 _toValue) public whenNotPaused returns (bool) {
144     require(_spender != address(0));
145     require(allowed[msg.sender][_spender] ==_fromValue);
146     allowed[msg.sender][_spender] = _toValue;
147     emit Approval(msg.sender, _spender, _toValue);
148     return true;
149   }
150 
151   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154     require(_to != address(0));
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   
164 }