1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4 
5   function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
6     uint256 z = x + y;
7     assert((z >= x) && (z >= y));
8     return z;
9   }
10 
11   function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
12     assert(x >= y);
13     uint256 z = x - y;
14     return z;
15   }
16 
17   function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
18     uint256 z = x * y;
19     assert((x == 0)||(z/x == y));
20     return z;
21   }
22 }
23 contract ERC20 {
24   uint public totalSupply;
25   function balanceOf(address who) public  constant returns (uint);
26   function allowance(address owner, address spender) public  constant returns (uint);
27   function transfer(address to, uint value) public  returns (bool ok);
28   function transferFrom(address from, address to, uint value) public  returns (bool ok);
29   function approve(address spender, uint value) public  returns (bool ok);
30   event Transfer(address indexed from, address indexed to, uint value);
31   event Approval(address indexed owner, address indexed spender, uint value);
32 }
33 contract StandardToken is ERC20, SafeMath {
34   /**
35   * @dev Fix for the ERC20 short address attack.
36    */
37   modifier onlyPayloadSize(uint size) {
38     require(msg.data.length >= size + 4) ;
39     _;
40   }
41 
42   mapping(address => uint) balances;
43   mapping (address => mapping (address => uint)) allowed;
44 
45   function transfer(address _to, uint _value) public  onlyPayloadSize(2 * 32)  returns (bool success){
46     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
47     balances[_to] = safeAdd(balances[_to], _value);
48     emit Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   function transferFrom(address _from, address _to, uint _value) public  onlyPayloadSize(3 * 32) returns (bool success) {
53     uint _allowance = allowed[_from][msg.sender];
54 
55     balances[_to] = safeAdd(balances[_to], _value);
56     balances[_from] = safeSubtract(balances[_from], _value);
57     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
58     emit Transfer(_from, _to, _value);
59     return true;
60   }
61 
62   function balanceOf(address _owner) public  constant returns (uint balance) {
63     return balances[_owner];
64   }
65 
66   function approve(address _spender, uint _value) public  returns (bool success) {
67     allowed[msg.sender][_spender] = _value;
68     emit Approval(msg.sender, _spender, _value);
69     return true;
70   }
71 
72   function allowance(address _owner, address _spender) public  constant returns (uint remaining) {
73     return allowed[_owner][_spender];
74   }
75 }
76 contract Ownable {
77   address public owner;
78 
79   constructor() public {
80     owner = msg.sender;
81   }
82 
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88   function transferOwnership(address newOwner) public  onlyOwner {
89     if (newOwner != address(0)) {
90       owner = newOwner;
91     }
92   }
93 }
94 contract Pausable is Ownable {
95   event Pause();
96   event Unpause();
97 
98   bool public paused = false;
99   modifier whenNotPaused() {
100     require (!paused);
101     _;
102   }
103 
104   modifier whenPaused {
105     require (paused) ;
106     _;
107   }
108   function pause() public onlyOwner whenNotPaused returns (bool) {
109     paused = true;
110     emit Pause();
111     return true;
112   }
113 
114   function unpause() public onlyOwner whenPaused returns (bool) {
115     paused = false;
116     emit Unpause();
117     return true;
118   }
119 }
120 contract IcoToken is SafeMath, StandardToken, Pausable {
121   string public name;
122   string public symbol;
123   uint256 public decimals;
124   string public version;
125   address public icoContract;
126 
127   constructor(
128     string _name,
129     string _symbol,
130     uint256 _decimals,
131     string _version
132   ) public
133   {
134     name = _name;
135     symbol = _symbol;
136     decimals = _decimals;
137     version = _version;
138   }
139 
140   function transfer(address _to, uint _value) public  whenNotPaused returns (bool success) {
141     return super.transfer(_to,_value);
142   }
143 
144   function approve(address _spender, uint _value) public  whenNotPaused returns (bool success) {
145     return super.approve(_spender,_value);
146   }
147 
148   function balanceOf(address _owner) public  constant returns (uint balance) {
149     return super.balanceOf(_owner);
150   }
151 
152   function setIcoContract(address _icoContract) public onlyOwner {
153     if (_icoContract != address(0)) {
154       icoContract = _icoContract;
155     }
156   }
157 
158   function sell(address _recipient, uint256 _value) public whenNotPaused returns (bool success) {
159       assert(_value > 0);
160       require(msg.sender == icoContract);
161 
162       balances[_recipient] += _value;
163       totalSupply += _value;
164 
165       emit Transfer(0x0, owner, _value);
166       emit Transfer(owner, _recipient, _value);
167       return true;
168   }
169 
170 }