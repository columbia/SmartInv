1 pragma solidity ^0.4.16;
2 // Currency.io
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
17 library SafeMath {
18     
19   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24  
25   function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31  
32   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36  
37   function add(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43  
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46   mapping(address => uint256) balances;
47 
48  function transfer(address _to, uint256 _value) returns (bool) {
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54   function balanceOf(address _owner) constant returns (uint256 balance) {
55     return balances[_owner];
56   }
57 }
58 
59 contract StandardToken is ERC20, BasicToken {
60   mapping (address => mapping (address => uint256)) allowed;
61   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
62     var _allowance = allowed[_from][msg.sender];
63     balances[_to] = balances[_to].add(_value);
64     balances[_from] = balances[_from].sub(_value);
65     allowed[_from][msg.sender] = _allowance.sub(_value);
66     Transfer(_from, _to, _value);
67     return true;
68   }
69  
70   function approve(address _spender, uint256 _value) returns (bool) {
71     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
72     allowed[msg.sender][_spender] = _value;
73     Approval(msg.sender, _spender, _value);
74     return true;
75   }
76   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77     return allowed[_owner][_spender];
78 }
79 }
80  
81 contract Ownable {
82   address public owner;
83   function Ownable() {
84     owner = msg.sender;
85   }
86  
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91   function transferOwnership(address newOwner) onlyOwner {
92     require(newOwner != address(0));      
93     owner = newOwner;
94   }
95 }
96  
97 contract TheLiquidToken is StandardToken, Ownable {
98   function burn(uint _value)
99         public
100     {
101         require(_value > 0);
102 
103         address burner = msg.sender;
104         balances[burner] = balances[burner].sub(_value);
105         totalSupply = totalSupply.sub(_value);
106         Burn(burner, _value);
107     }
108     event Burn(address indexed burner, uint indexed value);
109 }
110     
111 contract Currency is TheLiquidToken {
112   string public constant name = "Currency.io";
113   string public constant symbol = "cio";
114   uint public constant decimals = 2;
115   uint256 public initialSupply;
116     
117   function Currency () { 
118      totalSupply = 100000000 * 10 ** decimals;
119      // total Supply is fixed = 100 mln 
120       balances[msg.sender] = totalSupply;
121       initialSupply = totalSupply; 
122         Transfer(0, this, totalSupply);
123         Transfer(this, msg.sender, totalSupply);
124   }
125 }