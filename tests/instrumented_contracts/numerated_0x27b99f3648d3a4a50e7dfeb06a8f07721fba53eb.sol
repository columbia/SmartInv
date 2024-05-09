1 pragma solidity ^0.4.12;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint256 a, uint256 b) internal constant returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 }
25 contract Ownable {
26   address public owner;
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28  
29   function Ownable() {
30     owner = msg.sender;
31   }
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36   function transferOwnership(address newOwner) onlyOwner public {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 }
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public constant returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 contract BasicToken is ERC20Basic {
49   using SafeMath for uint256;
50 
51   mapping(address => uint256) balances;
52 
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55 
56     // SafeMath.sub will throw if there is not enough balance.
57     balances[msg.sender] = balances[msg.sender].sub(_value);
58     balances[_to] = balances[_to].add(_value);
59     Transfer(msg.sender, _to, _value);
60     return true;
61   }
62   function balanceOf(address _owner) public constant returns (uint256 balance) {
63     return balances[_owner];
64   }
65 }
66 
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public constant returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) allowed;
77 
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80 
81     uint256 _allowance = allowed[_from][msg.sender];
82 
83     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
84     // require (_value <= _allowance);
85 
86     balances[_from] = balances[_from].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     allowed[_from][msg.sender] = _allowance.sub(_value);
89     Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   function approve(address _spender, uint256 _value) public returns (bool) {
94     allowed[msg.sender][_spender] = _value;
95     Approval(msg.sender, _spender, _value);
96     return true;
97   }
98 
99   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
100     return allowed[_owner][_spender];
101   }
102 
103   function increaseApproval (address _spender, uint _addedValue)
104     returns (bool success) {
105     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110   function decreaseApproval (address _spender, uint _subtractedValue)
111     returns (bool success) {
112     uint oldValue = allowed[msg.sender][_spender];
113     if (_subtractedValue > oldValue) {
114       allowed[msg.sender][_spender] = 0;
115     } else {
116       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
117     }
118     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
119     return true;
120   }
121 }
122 
123 contract BurnableToken is StandardToken {
124 
125     event Burn(address indexed burner, uint256 value);
126 
127     function burn(uint256 _value) public {
128         require(_value > 0);
129         require(_value <= balances[msg.sender]);
130        
131         address burner = msg.sender;
132         balances[burner] = balances[burner].sub(_value);
133         totalSupply = totalSupply.sub(_value);
134         Burn(burner, _value);
135     }
136 }
137 
138 contract BEZOP_EXCHANGE is BurnableToken, Ownable {
139 
140     string public constant name = "Bezop Exchange Token";
141     string public constant symbol = "Bezx";
142     uint public constant decimals = 18;
143     uint256 public constant initialSupply = 1618137250 * (10 ** uint256(decimals));
144 
145   
146     function BEZOP_EXCHANGE() {
147         totalSupply = initialSupply;
148         balances[msg.sender] = initialSupply; // Send all tokens to owner
149     }
150 }