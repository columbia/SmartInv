1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  */
39 contract Ownable {
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   constructor() public {
45     owner = 0x36cA6bD16db5faC0dC5bAbaDaA7f30CbFb29b6B9;
46   }
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     emit OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 /**
62  * @title ERC20Basic
63  */
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address who) public view returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 /**
72  * @title ERC20 interface
73  */
74 contract ERC20 is ERC20Basic {
75   function allowance(address owner, address spender) public view returns (uint256);
76   function transferFrom(address from, address to, uint256 value) public returns (bool);
77   function approve(address spender, uint256 value) public returns (bool);
78   event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @title Basic token
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   function balanceOf(address _owner) public view returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 /**
111  * @title Standard ERC20 token
112  */
113 contract StandardToken is ERC20, BasicToken {
114 
115   mapping (address => mapping (address => uint256)) internal allowed;
116 
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     emit Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   function approve(address _spender, uint256 _value) public returns (bool) {
130     allowed[msg.sender][_spender] = _value;
131     emit Approval(msg.sender, _spender, _value);
132     return true;
133   }
134 
135   function allowance(address _owner, address _spender) public view returns (uint256) {
136     return allowed[_owner][_spender];
137   }
138 
139   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
140     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144 
145   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
146     uint oldValue = allowed[msg.sender][_spender];
147     if (_subtractedValue > oldValue) {
148       allowed[msg.sender][_spender] = 0;
149     } else {
150       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
151     }
152     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156 }
157 
158 contract eXdoradoShares is StandardToken, Ownable {
159     
160   string public name;
161   string public symbol;
162   uint8 public decimals;
163   uint256 public initialSupply;
164 
165   constructor() public {
166     name = 'eXdorado Shares';
167     symbol = 'EXS';
168     decimals = 18;
169     initialSupply = 21000000 * 10 ** uint256(decimals);
170     totalSupply_ = initialSupply;
171     balances[owner] = initialSupply;
172     emit Transfer(0x0, owner, initialSupply);
173   }
174 }