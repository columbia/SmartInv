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
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return a / b;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63 
64   uint256 totalSupply_;
65 
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function balanceOf(address _owner) public view returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99     emit Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowed[msg.sender][_spender] = _value;
105     emit Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   function allowance(address _owner, address _spender) public view returns (uint256) {
110     return allowed[_owner][_spender];
111   }
112 
113   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
114     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
115     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116     return true;
117   }
118 
119   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
120     uint oldValue = allowed[msg.sender][_spender];
121     if (_subtractedValue > oldValue) {
122       allowed[msg.sender][_spender] = 0;
123     } else {
124       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
125     }
126     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127     return true;
128   }
129 
130 }
131 
132 contract Ownable {
133   address public owner;
134 
135 
136   event OwnershipRenounced(address indexed previousOwner);
137   event OwnershipTransferred(
138     address indexed previousOwner,
139     address indexed newOwner
140   );
141 
142 
143   constructor() public {
144     owner = msg.sender;
145   }
146 
147 
148   modifier onlyOwner() {
149     require(msg.sender == owner);
150     _;
151   }
152 
153   function transferOwnership(address newOwner) public onlyOwner {
154     require(newOwner != address(0));
155     emit OwnershipTransferred(owner, newOwner);
156     owner = newOwner;
157   }
158 
159   function renounceOwnership() public onlyOwner {
160     emit OwnershipRenounced(owner);
161     owner = address(0);
162   }
163 }
164 
165 contract MintableToken is StandardToken, Ownable {
166   event Mint(address indexed to, uint256 amount);
167   event MintFinished();
168 
169   bool public mintingFinished = false;
170 
171 
172   modifier canMint() {
173     require(!mintingFinished);
174     _;
175   }
176 
177   modifier hasMintPermission() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182   function mint(
183     address _to,
184     uint256 _amount
185   )
186     hasMintPermission
187     canMint
188     public
189     returns (bool)
190   {
191     totalSupply_ = totalSupply_.add(_amount);
192     balances[_to] = balances[_to].add(_amount);
193     emit Mint(_to, _amount);
194     emit Transfer(address(0), _to, _amount);
195     return true;
196   }
197 
198   function finishMinting() onlyOwner canMint public returns (bool) {
199     mintingFinished = true;
200     emit MintFinished();
201     return true;
202   }
203 }
204 
205 contract TrueLogic is MintableToken {
206 
207   string public constant name = "TrueLogic"; // solium-disable-line uppercase
208   string public constant symbol = "TRL"; // solium-disable-line uppercase
209   uint8 public constant decimals = 18; // solium-disable-line uppercase
210 
211   uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
212 
213   }