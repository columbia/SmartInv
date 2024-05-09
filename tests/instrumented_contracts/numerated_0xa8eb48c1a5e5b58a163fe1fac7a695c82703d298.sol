1 pragma solidity ^0.4.18;
2  
3 /* GUAVARA TOKEN VERSION 2
4  */
5 contract ERC20Basic {
6   uint256 public totalSupply;
7   function balanceOf(address who) constant returns (uint256);
8   function transfer(address to, uint256 value) returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11  
12 
13 contract ERC20 is ERC20Basic {
14   function allowance(address owner, address spender) constant returns (uint256);
15   function transferFrom(address from, address to, uint256 value) returns (bool);
16   function approve(address spender, uint256 value) returns (bool);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19  
20 
21 library SafeMath {
22     
23   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28  
29   function div(uint256 a, uint256 b) internal constant returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35  
36   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40  
41   function add(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46   
47 }
48  
49 contract BasicToken is ERC20Basic {
50     
51   using SafeMath for uint256;
52  
53   mapping(address => uint256) balances;
54  
55  function transfer(address _to, uint256 _value) returns (bool) {
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     Transfer(msg.sender, _to, _value);
59     return true;
60   }
61  
62   
63   function balanceOf(address _owner) constant returns (uint256 balance) {
64     return balances[_owner];
65   }
66  
67 }
68  
69 
70 contract StandardToken is ERC20, BasicToken {
71  
72   mapping (address => mapping (address => uint256)) allowed;
73  
74   
75   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
76     var _allowance = allowed[_from][msg.sender];
77  
78     
79  
80     balances[_to] = balances[_to].add(_value);
81     balances[_from] = balances[_from].sub(_value);
82     allowed[_from][msg.sender] = _allowance.sub(_value);
83     Transfer(_from, _to, _value);
84     return true;
85   }
86  
87   
88   function approve(address _spender, uint256 _value) returns (bool) {
89  
90     
91     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
92  
93     allowed[msg.sender][_spender] = _value;
94     Approval(msg.sender, _spender, _value);
95     return true;
96   }
97  
98   
99   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
100     return allowed[_owner][_spender];
101   }
102  
103 }
104  
105 
106 contract Ownable {
107     
108   address public owner;
109  
110  
111   function Ownable() {
112     owner = msg.sender;
113   }
114  
115   
116   modifier onlyOwner() {
117     require(msg.sender == owner);
118     _;
119   }
120  
121   
122   function transferOwnership(address newOwner) onlyOwner {
123     require(newOwner != address(0));      
124     owner = newOwner;
125   }
126  
127 }
128  
129 contract TheLiquidToken is StandardToken, Ownable {
130     // mint can be finished and token become fixed for forever
131   event Mint(address indexed to, uint256 amount);
132   event MintFinished();
133   bool public mintingFinished = false;
134   modifier canMint() {
135     require(!mintingFinished);
136     _;
137   }
138  
139  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
140     totalSupply = totalSupply.add(_amount);
141     balances[_to] = balances[_to].add(_amount);
142     Mint(_to, _amount);
143     return true;
144   }
145  
146   
147   function finishMinting() onlyOwner returns (bool) {
148     mintingFinished = true;
149     MintFinished();
150     return true;
151   }
152   
153 }
154     
155 contract ANV is TheLiquidToken {
156   string public constant name = "ANUVYS";
157       string public constant symbol = "ANV";
158   uint public constant decimals = 18;
159   uint256 public initialSupply = 26000000000000000000000000000;
160     
161   // Constructor
162   function ANV () { 
163      totalSupply = 26000000000000000000000000000;
164       balances[msg.sender] = totalSupply;
165       initialSupply = totalSupply; 
166         Transfer(0, this, totalSupply);
167         Transfer(this, msg.sender, totalSupply);
168   }
169 }