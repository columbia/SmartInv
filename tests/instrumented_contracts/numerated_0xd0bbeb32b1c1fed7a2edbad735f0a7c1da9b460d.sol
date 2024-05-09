1 /* Token Development for Ethereum ERC20 Utility by BlackNWhite Team 2018. */
2 
3 pragma solidity ^0.4.12;
4 
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   function transferOwnership(address newOwner) onlyOwner public {
52     require(newOwner != address(0));
53     OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 }
57 
58 contract ERC20Basic {
59   uint256 public totalSupply;
60   function balanceOf(address who) public constant returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71 
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82 
83   function balanceOf(address _owner) public constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 }
87 
88 
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 
97 
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105 
106     uint256 _allowance = allowed[_from][msg.sender];
107 
108     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
109     // require (_value <= _allowance);
110 
111     balances[_from] = balances[_from].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     allowed[_from][msg.sender] = _allowance.sub(_value);
114     Transfer(_from, _to, _value);
115     return true;
116   }
117 
118 
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125 
126   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
127     return allowed[_owner][_spender];
128   }
129 
130 
131   function increaseApproval (address _spender, uint _addedValue) public
132     returns (bool success) {
133     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135     return true;
136   }
137 
138   function decreaseApproval (address _spender, uint _subtractedValue) public
139     returns (bool success) {
140     uint oldValue = allowed[msg.sender][_spender];
141     if (_subtractedValue > oldValue) {
142       allowed[msg.sender][_spender] = 0;
143     } else {
144       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145     }
146     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149 }
150 
151 
152 contract BurnableToken is StandardToken {
153 
154     event Burn(address indexed burner, uint256 value);
155 
156 
157     function burn(uint256 _value) public {
158         require(_value > 0);
159         require(_value <= balances[msg.sender]);
160         // no need to require value <= totalSupply, since that would imply the
161         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
162 
163         address burner = msg.sender;
164         balances[burner] = balances[burner].sub(_value);
165         totalSupply = totalSupply.sub(_value);
166         Burn(burner, _value);
167     }
168 }
169 
170 contract BlackNWhite  is BurnableToken, Ownable {
171 
172     string public constant name = "Black N White";
173     string public constant symbol = "BNWG";
174     uint public constant decimals = 18;
175     // there is no problem in using * here instead of .mul()
176     uint256 public constant initialSupply = 5000000000 * (10 ** uint256(decimals));
177 	
178 
179     // Constructors
180     function BlackNWhite () public {
181         totalSupply = initialSupply;
182         balances[msg.sender] = initialSupply; // Send all tokens to owner
183     }
184 
185 }