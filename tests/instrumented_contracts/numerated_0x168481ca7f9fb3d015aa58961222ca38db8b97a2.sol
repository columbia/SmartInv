1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24   /**
25   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
26   */
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31   /**
32   * @dev Adds two numbers, throws on overflow.
33   */
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 contract ERC20Basic {
42   function totalSupply() public view returns (uint256);
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) public view returns (uint256);
50   function transferFrom(address from, address to, uint256 value) public returns (bool);
51   function approve(address spender, uint256 value) public returns (bool);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57   mapping(address => uint256) balances;
58   uint256 totalSupply_;
59   function totalSupply() public view returns (uint256) {
60     return totalSupply_;
61   }
62 
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     emit Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   function balanceOf(address _owner) public view returns (uint256 balance) {
73     return balances[_owner];
74   }
75 }
76 
77 
78 contract StandardToken is ERC20, BasicToken {
79     
80   mapping (address => mapping (address => uint256)) internal allowed;
81   
82   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[_from]);
85     require(_value <= allowed[_from][msg.sender]);
86 
87     balances[_from] = balances[_from].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90     emit Transfer(_from, _to, _value);
91     return true;
92   }
93 
94   function approve(address _spender, uint256 _value) public returns (bool) {
95     allowed[msg.sender][_spender] = _value;
96     emit Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100   function allowance(address _owner, address _spender) public view returns (uint256) {
101     return allowed[_owner][_spender];
102   }
103 
104   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
105     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
111     uint oldValue = allowed[msg.sender][_spender];
112     if (_subtractedValue > oldValue) {
113       allowed[msg.sender][_spender] = 0;
114     } else {
115       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
116     }
117     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126   function Ownable() public {
127     owner = msg.sender;
128   }
129 
130   modifier onlyOwner() {
131     require(msg.sender == owner);
132     _;
133   }
134   function transferOwnership(address newOwner) public onlyOwner {
135     if (newOwner != address(0)) {
136       owner = newOwner;
137     }
138   }  
139 }
140 
141 contract BurnableToken is BasicToken {
142     
143   event Burn(address indexed burner, uint256 value);
144 
145   function burn(uint256 _value) public {
146     require(_value <= balances[msg.sender]);
147     address burner = msg.sender;
148     balances[burner] = balances[burner].sub(_value);
149     totalSupply_ = totalSupply_.sub(_value);
150     emit Burn(burner, _value);
151     emit Transfer(burner, address(0), _value);
152   }
153 }
154 
155 contract TZSToken is BurnableToken {
156 
157     string public constant name = "TenzShield";
158     string public constant symbol = "TZS";
159     uint8 public constant decimals = 18;
160 
161     uint256 private constant TOKEN_INITIAL = 10000000000 * (10 ** uint256(decimals));
162 
163     function TZSToken() public {
164       totalSupply_ = TOKEN_INITIAL;
165       balances[msg.sender] = TOKEN_INITIAL;
166       emit Transfer(address(0), msg.sender, TOKEN_INITIAL);
167   }
168 }