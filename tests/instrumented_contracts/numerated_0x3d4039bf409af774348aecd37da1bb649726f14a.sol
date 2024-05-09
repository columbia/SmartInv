1 pragma solidity 0.4.24;
2 
3 //*************** SafeMath ***************
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
7       uint256 c = a * b;
8       assert(a == 0 || c / a == b);
9       return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure  returns (uint256) {
13       assert(b > 0);
14       uint256 c = a / b;
15       return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
19       assert(b <= a);
20       return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
24       uint256 c = a + b;
25       assert(c >= a);
26       return c;
27   }
28 }
29 
30 //*************** Ownable *************** 
31 
32 contract Ownable {
33   address public owner;
34 
35   constructor() public {
36       owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40       require(msg.sender == owner);
41       _;
42   }
43 
44   function transferOwnership(address newOwner)public onlyOwner {
45       if (newOwner != address(0)) {
46         owner = newOwner;
47       }
48   }
49 
50 }
51 
52 //************* ERC20 *************** 
53 
54 contract ERC20 {
55   
56   function balanceOf(address who)public constant returns (uint256);
57   function transfer(address to, uint256 value)public returns (bool);
58   function transferFrom(address from, address to, uint256 value)public returns (bool);
59   function allowance(address owner, address spender)public constant returns (uint256);
60   function approve(address spender, uint256 value)public returns (bool);
61 
62   event Transfer(address indexed from, address indexed to, uint256 value);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 //************* Utrade Token *************
67 
68 contract UtradeToken is ERC20,Ownable {
69   using SafeMath for uint256;
70 
71   // Token Info.
72   string public name;
73   string public symbol;
74   uint256 public totalSupply;
75   uint256 public constant decimals = 18;
76   mapping (address => uint256) public balanceOf;
77   mapping (address => mapping (address => uint256)) allowed;
78 
79   
80   constructor() public  {   
81     name="uTrade Trading Platform";
82     symbol="UTP";
83     totalSupply = 1000000000*(10**decimals);
84     balanceOf[msg.sender] = totalSupply; 
85  }
86 
87   function balanceOf(address _who)public constant returns (uint256 balance) {
88       require(_who != 0x0);
89       return balanceOf[_who];
90   }
91 
92   function _transferFrom(address _from, address _to, uint256 _value)  internal returns (bool)  {
93       require(_from != 0x0);
94       require(_to != 0x0);
95       require(balanceOf[_from] >= _value);
96       require(balanceOf[_to].add(_value) >= balanceOf[_to]);
97       uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
98       balanceOf[_from] = balanceOf[_from].sub(_value);
99       balanceOf[_to] = balanceOf[_to].add(_value);
100       assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
101       emit Transfer(_from, _to, _value);
102       return true;
103        
104   }
105   
106   function transfer(address _to, uint256 _value) public returns (bool){     
107       return _transferFrom(msg.sender,_to,_value);
108   }
109   
110   function ()public {
111   }
112 
113   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
114       require(_owner != 0x0);
115       require(_spender != 0x0);
116       return allowed[_owner][_spender];
117   }
118 
119   function approve(address _spender, uint256 _value)public returns (bool) {
120       require(_spender != 0x0);
121       require(balanceOf[msg.sender] >= _value);
122       allowed[msg.sender][_spender] = _value;
123       emit Approval(msg.sender, _spender, _value);
124       return true;
125   }
126   
127   function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
128       require(_from != 0x0);
129       require(_to != 0x0);
130       require(_value > 0);
131       require(allowed[_from][msg.sender] >= _value);
132       require(balanceOf[_from] >= _value);
133       require(balanceOf[_to].add(_value) >= balanceOf[_to]);
134       
135       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
136       balanceOf[_from] = balanceOf[_from].sub(_value);
137       balanceOf[_to] = balanceOf[_to].add(_value);
138             
139       emit Transfer(_from, _to, _value);
140       return true;
141     }
142 }