1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   function transfer(address _to, uint256 _value) public returns (bool) {
49     require(_to != address(0));
50     require(_value <= balances[msg.sender]);
51 
52     // SafeMath.sub will throw if there is not enough balance.
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   function balanceOf(address _owner) public constant returns (uint256 balance) {
60     return balances[_owner];
61   }
62 
63 }
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) internal allowed;
67 
68 
69   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[_from]);
72     require(_value <= allowed[_from][msg.sender]);
73 
74     balances[_from] = balances[_from].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
77     Transfer(_from, _to, _value);
78     return true;
79   }
80 
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84     return true;
85   }
86 
87   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88     return allowed[_owner][_spender];
89   }
90 
91   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
92     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
93     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94     return true;
95   }
96 
97   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
98     uint oldValue = allowed[msg.sender][_spender];
99     if (_subtractedValue > oldValue) {
100       allowed[msg.sender][_spender] = 0;
101     } else {
102       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
103     }
104     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105     return true;
106   }
107 
108 }
109 
110 contract Ownable {
111   address public owner;
112   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113   function Ownable() public{
114     owner = msg.sender;
115   }
116   modifier onlyOwner() {
117     require(msg.sender == owner);
118     _;
119   }
120   function transferOwnership(address newOwner) onlyOwner public {
121     require(newOwner != address(0));
122     OwnershipTransferred(owner, newOwner);
123     owner = newOwner;
124   }
125 
126 }
127 
128 contract MintableToken is StandardToken, Ownable {
129   event Mint(address indexed to, uint256 amount);
130   event MintFinished();
131 
132   bool public mintingFinished = false;
133 
134   modifier canMint() {
135     require(!mintingFinished);
136     _;
137   }
138 
139   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
140     totalSupply = totalSupply.add(_amount);
141     balances[_to] = balances[_to].add(_amount);
142     Mint(_to, _amount);
143     Transfer(address(0), _to, _amount);
144     return true;
145   }
146   function finishMinting() onlyOwner public returns (bool) {
147     mintingFinished = true;
148     MintFinished();
149     return true;
150   }
151 }
152 contract BurnableToken is StandardToken {
153 
154   function burn(uint _value) public {
155     require(_value > 0);
156     address burner = msg.sender;
157     balances[burner] = balances[burner].sub(_value);
158     totalSupply = totalSupply.sub(_value);
159     Burn(burner, _value);
160   }
161 
162   event Burn(address indexed burner, uint indexed value);
163 
164 }
165 
166 
167 contract WAEP is MintableToken, BurnableToken {
168     
169     string public constant name = "WeAre Pre-ICO Token";
170     
171     string public constant symbol = "WAEP";
172     
173     uint32 public constant decimals = 18;
174     
175     function WAEP() public{
176 		owner = msg.sender;
177     }
178     
179 }