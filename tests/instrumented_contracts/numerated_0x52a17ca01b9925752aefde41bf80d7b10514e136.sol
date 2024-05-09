1 pragma solidity ^0.4.18;
2  
3 /* 
4     Pump it up, 
5     get rich, 
6     buy lambo, 
7     enjoy cool life
8  */
9  
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) constant returns (uint256);
13   function transfer(address to, uint256 value) returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) constant returns (uint256);
19   function transferFrom(address from, address to, uint256 value) returns (bool);
20   function approve(address spender, uint256 value) returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30  
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37  
38   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42  
43   function add(uint256 a, uint256 b) internal constant returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49  
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52   mapping(address => uint256) balances;
53  
54  function transfer(address _to, uint256 _value) returns (bool) {
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60  
61   function balanceOf(address _owner) constant returns (uint256 balance) {
62     return balances[_owner];
63   }
64 }
65 
66 contract StandardToken is ERC20, BasicToken {
67   mapping (address => mapping (address => uint256)) allowed;
68   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
69     var _allowance = allowed[_from][msg.sender];
70     balances[_to] = balances[_to].add(_value);
71     balances[_from] = balances[_from].sub(_value);
72     allowed[_from][msg.sender] = _allowance.sub(_value);
73     Transfer(_from, _to, _value);
74     return true;
75   }
76  
77   function approve(address _spender, uint256 _value) returns (bool) {
78    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
79     allowed[msg.sender][_spender] = _value;
80     Approval(msg.sender, _spender, _value);
81     return true;
82   }
83  
84   /*
85   Function to check the amount of tokens that an owner allowed to a spender.
86   param _owner address The address which owns the funds.
87   param _spender address The address which will spend the funds.
88   return A uint256 specifing the amount of tokens still available for the spender.
89    */
90   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91     return allowed[_owner][_spender];
92 }
93 }
94  
95 /*
96 The Ownable contract has an owner address, and provides basic authorization control
97  functions, this simplifies the implementation of "user permissions".
98  */
99 contract Ownable {
100     
101   address public owner;
102  
103   function Ownable() {
104     owner = msg.sender;
105   }
106   /*
107   Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113  
114   /*
115   Allows the current owner to transfer control of the contract to a newOwner.
116   param newOwner The address to transfer ownership to.
117    */
118   function transferOwnership(address newOwner) onlyOwner {
119     require(newOwner != address(0));      
120     owner = newOwner;
121   }
122 }
123   
124 contract Pumpcoin is StandardToken, Ownable {
125   string public constant name = "Pump coin";
126   string public constant symbol = "PUMP";
127   uint public constant decimals = 15;
128   uint256 public initialSupply;
129     
130   function Pumpcoin () { 
131      totalSupply = 1000000 * 10 ** decimals;
132       balances[msg.sender] = totalSupply;
133       initialSupply = totalSupply; 
134         Transfer(0, this, totalSupply);
135         Transfer(this, msg.sender, totalSupply);
136   }
137 }