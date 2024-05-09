1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 library SafeMath {
19 
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   uint256 totalSupply_;
56 
57   function totalSupply() public view returns (uint256) {
58     return totalSupply_;
59   }
60 
61   function transfer(address _to, uint256 _value) public returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64 
65     // SafeMath.sub will throw if there is not enough balance.
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     emit Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72 
73   function balanceOf(address _owner) public view returns (uint256 balance) {
74     return balances[_owner];
75   }
76 
77 }
78 
79 contract StandardToken is ERC20, BasicToken {
80 
81   mapping (address => mapping (address => uint256)) internal allowed;
82 
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[_from]);
86     require(_value <= allowed[_from][msg.sender]);
87 
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91     emit Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     emit Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   function allowance(address _owner, address _spender) public view returns (uint256) {
102     return allowed[_owner][_spender];
103   }
104 
105   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
106     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
107     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108     return true;
109   }
110 
111   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
112     uint oldValue = allowed[msg.sender][_spender];
113     if (_subtractedValue > oldValue) {
114       allowed[msg.sender][_spender] = 0;
115     } else {
116       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
117     }
118     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
119     return true;
120   }
121 
122 }
123 
124 contract Ownable {
125   address public owner;
126 
127 
128   event OwnershipRenounced(address indexed previousOwner);
129   event OwnershipTransferred(
130     address indexed previousOwner,
131     address indexed newOwner
132   );
133 
134   constructor() public {
135     owner = msg.sender;
136   }
137 
138   modifier onlyOwner() {
139     require(msg.sender == owner);
140     _;
141   }
142 
143   function transferOwnership(address newOwner) public onlyOwner {
144     require(newOwner != address(0));
145     emit OwnershipTransferred(owner, newOwner);
146     owner = newOwner;
147   }
148 
149   function renounceOwnership() public onlyOwner {
150     emit OwnershipRenounced(owner);
151     owner = address(0);
152   }
153 }
154 
155 contract MintableToken is StandardToken, Ownable {
156   event Mint(address indexed to, uint256 amount);
157   event MintFinished();
158 
159   bool public mintingFinished = false;
160 
161 
162   modifier canMint() {
163     require(!mintingFinished);
164     _;
165   }
166 
167   modifier hasMintPermission() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172   function mint(
173     address _to,
174     uint256 _amount
175   )
176     hasMintPermission
177     canMint
178     public
179     returns (bool)
180   {
181     totalSupply_ = totalSupply_.add(_amount);
182     balances[_to] = balances[_to].add(_amount);
183     emit Mint(_to, _amount);
184     emit Transfer(address(0), _to, _amount);
185     return true;
186   }
187 
188   function finishMinting() onlyOwner canMint public returns (bool) {
189     mintingFinished = true;
190     emit MintFinished();
191     return true;
192   }
193 }
194 
195 contract Horiz0n is MintableToken {
196 
197   string public constant name = "Horiz0n"; // solium-disable-line uppercase
198   string public constant symbol = "HRZ"; // solium-disable-line uppercase
199   uint8 public constant decimals = 18; // solium-disable-line uppercase
200 
201   uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
202 
203   }