1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) public view returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   uint256 totalSupply_;
53 
54   function totalSupply() public view returns (uint256) {
55     return totalSupply_;
56   }
57 
58   function transfer(address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     require(_value <= balances[msg.sender]);
61 
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     emit Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   function balanceOf(address _owner) public view returns (uint256 balance) {
70     return balances[_owner];
71   }
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) internal allowed;
77 
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     emit Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _value) public returns (bool) {
91     allowed[msg.sender][_spender] = _value;
92     emit Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   function allowance(address _owner, address _spender) public view returns (uint256) {
97     return allowed[_owner][_spender];
98   }
99 
100   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
101     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
102     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103     return true;
104   }
105 
106   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
107     uint oldValue = allowed[msg.sender][_spender];
108     if (_subtractedValue > oldValue) {
109       allowed[msg.sender][_spender] = 0;
110     } else {
111       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
112     }
113     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 }
117 
118 contract Ownable {
119   address public owner;
120 
121   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123   function Ownable() public {
124     owner = msg.sender;
125   }
126 
127   modifier onlyOwner() {
128     require(msg.sender == owner);
129     _;
130   }
131 
132   function transferOwnership(address newOwner) public onlyOwner {
133     require(newOwner != address(0));
134     emit OwnershipTransferred(owner, newOwner);
135     owner = newOwner;
136   }
137 }
138 
139 contract MintableToken is StandardToken, Ownable {
140   event Mint(address indexed to, uint256 amount);
141   event MintFinished();
142 
143   bool public mintingFinished = false;
144 
145 
146   modifier canMint() {
147     require(!mintingFinished);
148     _;
149   }
150 
151   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
152     totalSupply_ = totalSupply_.add(_amount);
153     balances[_to] = balances[_to].add(_amount);
154     emit Mint(_to, _amount);
155     emit Transfer(address(0), _to, _amount);
156     return true;
157   }
158 
159   function finishMinting() onlyOwner canMint public returns (bool) {
160     mintingFinished = true;
161     emit MintFinished();
162     return true;
163   }
164 }
165 
166 /**
167 * Special approach to implementing CryptographicCoin (CRTCoin) allowed to create the first world's 
168 * cryptocurrency which is ecological, economically beneficial and truly anonymous. 
169 */
170 contract CRTCoin is MintableToken {
171     string public constant name = "CRTCoin";
172     string public constant symbol = "CRT";
173     uint8 public constant decimals = 18;
174 }