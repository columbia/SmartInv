1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5   function mul(uint a, uint b) internal pure  returns (uint) {
6     uint c = a * b;
7     require(a == 0 || c / a == b);
8     return c;
9   }
10   function div(uint a, uint b) internal pure returns (uint) {
11     require(b > 0);
12     uint c = a / b;
13     require(a == b * c + a % b);
14     return c;
15   }
16   function sub(uint a, uint b) internal pure returns (uint) {
17     require(b <= a);
18     return a - b;
19   }
20   function add(uint a, uint b) internal pure returns (uint) {
21     uint c = a + b;
22     require(c >= a);
23     return c;
24   }
25   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
26     return a >= b ? a : b;
27   }
28   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
29     return a < b ? a : b;
30   }
31   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
32     return a >= b ? a : b;
33   }
34   function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
35     return a < b ? a : b;
36   }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     function Ownable() public{
43         owner = msg.sender;
44     }
45 
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50     function transferOwnership(address newOwner) onlyOwner public{
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55 }
56 
57 
58 contract AUCC is  Ownable {
59     
60   using SafeMath for uint;
61   mapping(address => uint) balances;
62   
63   mapping (address => mapping (address => uint)) allowed;
64 
65   event Transfer(address indexed from, address indexed to, uint value);
66   event Approval(address indexed owner, address indexed spender, uint value);
67   
68   string public constant name = "Arc Unified Chain";
69   string public constant symbol = "AUCC";
70   uint public constant decimals = 18;
71   uint public totalSupply = 6700000000000000000000000;
72   
73   address public deadContractAddress;
74 
75   function AUCC() public {
76       balances[msg.sender] = totalSupply; // Send all tokens to owner
77   }
78   
79 
80   function transfer(address _to, uint _value) public{
81       
82     uint256 fee = _value.mul(1).div(100);
83     uint256 remainingValue = _value.mul(99).div(100);
84     
85     if (_to == deadContractAddress){
86         burn(_value);//Burn 100% transfer value
87     }else{
88         burn(fee); //Burn 1% transfer value
89         balances[msg.sender] = balances[msg.sender].sub(remainingValue);
90     }
91     
92     balances[_to] = balances[_to].add(remainingValue);
93     emit Transfer(msg.sender, _to, _value);
94   }
95   
96 
97   function balanceOf(address _owner) public constant returns (uint balance) {
98     return balances[_owner];
99   }
100   
101   
102   function transferFrom(address _from, address _to, uint _value) public {
103       
104     uint256 fee = _value.mul(1).div(100);//
105     uint256 remainingValue = _value.mul(99).div(100);
106     
107     if (_to == deadContractAddress){
108          burnFrom(_from, _value);//Burn 100% transfer value
109     }else{
110         burnFrom(_from, fee);//Burn 1% transfer value
111         balances[_from] = balances[_from].sub(remainingValue);
112     }
113    
114     balances[_to] = balances[_to].add(remainingValue);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     emit Transfer(_from, _to, _value);
117   }
118 
119   function approve(address _spender, uint _value) public{
120     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
121     allowed[msg.sender][_spender] = _value;
122     emit Approval(msg.sender, _spender, _value);
123   }
124 
125   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
126     return allowed[_owner][_spender];
127   }
128   
129  function burnFrom(address _from, uint _value) internal  returns (bool)  {
130     balances[_from] = balances[_from].sub(_value);
131     totalSupply = totalSupply.sub(_value);
132     emit Transfer(_from, 0x0, _value);
133     return true;
134   }
135 
136   function burn(uint _value)  public returns (bool) {
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     totalSupply = totalSupply.sub(_value);
139     emit Transfer(msg.sender, 0x0, _value);
140     return true;
141   }
142   
143   function setDeadContractAddress(address _deadContractAddress) onlyOwner public {
144    deadContractAddress = _deadContractAddress;
145   }
146 
147 }