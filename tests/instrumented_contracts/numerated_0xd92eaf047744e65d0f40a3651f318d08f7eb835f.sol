1 pragma solidity 0.4.15;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract BasicToken is ERC20Basic {
18   using SafeMath for uint256;
19 
20   mapping(address => uint256) balances;
21 
22   function transfer(address _to, uint256 _value) returns (bool) {
23     balances[msg.sender] = balances[msg.sender].sub(_value);
24     balances[_to] = balances[_to].add(_value);
25     Transfer(msg.sender, _to, _value);
26     return true;
27   }
28 
29   function balanceOf(address _owner) constant returns (uint256 balance) {
30     return balances[_owner];
31   }
32 
33 }
34 
35 contract Ownable {
36   address public owner;
37 
38   function Ownable() {
39     owner = msg.sender;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function transferOwnership(address newOwner) onlyOwner {
48     require(newOwner != address(0)); 
49     owner = newOwner;
50   }
51 }
52 
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59 
60   function div(uint256 a, uint256 b) internal constant returns (uint256) {
61     uint256 c = a / b;
62     return c;
63   }
64 
65   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   function add(uint256 a, uint256 b) internal constant returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) allowed;
80 
81   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
82     var _allowance = allowed[_from][msg.sender];
83 
84     balances[_to] = balances[_to].add(_value);
85     balances[_from] = balances[_from].sub(_value);
86     allowed[_from][msg.sender] = _allowance.sub(_value);
87     Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   function approve(address _spender, uint256 _value) returns (bool) {
92 
93     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
94 
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
101     return allowed[_owner][_spender];
102   }
103 
104 }
105 
106 contract MintableToken is StandardToken, Ownable {
107   event Mint(address indexed to, uint256 amount);
108   event MintFinished();
109 
110   bool public mintingFinished = false;
111 
112   modifier canMint() {
113     require(!mintingFinished);
114     _;
115   }
116 
117   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
118     totalSupply = totalSupply.add(_amount);
119     balances[_to] = balances[_to].add(_amount);
120     Mint(_to, _amount);
121     Transfer(0x0, _to, _amount);
122     return true;
123   }
124 
125   function finishMinting() onlyOwner returns (bool) {
126     mintingFinished = true;
127     MintFinished();
128     return true;
129   }
130 }
131 
132 contract BSDB is MintableToken
133 {
134     string public name = "BsdbWealth";
135     string public symbol = "BSDB";
136     uint public decimals = 8;
137 
138     uint private initialSupply = 81*10**(6+8); // 81 Millions
139     
140     function BSDB()
141     {
142         owner = msg.sender;
143         totalSupply = initialSupply;
144         balances[owner] = initialSupply;
145     }
146 }