1 pragma solidity ^0.5.1;
2 
3 /**
4  * SmartEth.co
5  * ERC20 Token and ICO smart contracts development, smart contracts audit, ICO websites.
6  * contact@smarteth.co / smarteth.co@gmail.com
7  */
8 
9 /**
10  * @title SafeMath
11  */
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 /**
43  * @title Ownable
44  */
45 contract Ownable {
46   address public owner;
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   constructor() public {
51     owner = 0x1EE6Db67a3e07d6f1f4b72571c0aA9C78500861A;
52   }
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 /**
68  * @title ERC20Basic
69  */
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title ERC20 interface
79  */
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) public view returns (uint256);
82   function transferFrom(address from, address to, uint256 value) public returns (bool);
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 /**
88  * @title Basic token
89  */
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   uint256 totalSupply_;
96 
97   function totalSupply() public view returns (uint256) {
98     return totalSupply_;
99   }
100 
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     emit Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  */
119 contract StandardToken is ERC20, BasicToken {
120 
121   mapping (address => mapping (address => uint256)) internal allowed;
122 
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[_from]);
126     require(_value <= allowed[_from][msg.sender]);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131     emit Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     emit Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   function allowance(address _owner, address _spender) public view returns (uint256) {
142     return allowed[_owner][_spender];
143   }
144 
145   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
146     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
147     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
152     uint oldValue = allowed[msg.sender][_spender];
153     if (_subtractedValue > oldValue) {
154       allowed[msg.sender][_spender] = 0;
155     } else {
156       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
157     }
158     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162 }
163 
164 contract WooshCoin is StandardToken, Ownable {
165     
166   string public name;
167   string public symbol;
168   uint8 public decimals;
169   uint256 public initialSupply;
170 
171   constructor() public {
172     name = 'WooshCoin';
173     symbol = 'XWO';
174     decimals = 18;
175     initialSupply = 89000000000 * 10 ** uint256(decimals);
176     totalSupply_ = initialSupply;
177     balances[owner] = initialSupply;
178     emit Transfer(address(0), owner, initialSupply);
179   }
180 }