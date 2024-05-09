1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33   function Ownable() public {
34     owner = msg.sender;
35   }
36 
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public view returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   uint256 totalSupply_;
70 
71   function totalSupply() public view returns (uint256) {
72     return totalSupply_;
73   }
74 
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return balances[_owner];
88   }
89 }
90 
91 contract StandardToken is ERC20, BasicToken {
92   mapping (address => mapping (address => uint256)) internal allowed;
93 
94   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[_from]);
97     require(_value <= allowed[_from][msg.sender]);
98 
99     balances[_from] = balances[_from].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
102     Transfer(_from, _to, _value);
103     return true;
104   }
105 
106   function approve(address _spender, uint256 _value) public returns (bool) {
107     allowed[msg.sender][_spender] = _value;
108     Approval(msg.sender, _spender, _value);
109     return true;
110   }
111 
112   function allowance(address _owner, address _spender) public view returns (uint256) {
113     return allowed[_owner][_spender];
114   }
115 
116   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
117     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
118     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
119     return true;
120   }
121 
122   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
123     uint oldValue = allowed[msg.sender][_spender];
124     if (_subtractedValue > oldValue) {
125       allowed[msg.sender][_spender] = 0;
126     } else {
127       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
128     }
129     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
130     return true;
131   }
132 }
133 
134 contract MintableToken is StandardToken, Ownable {
135   event Mint(address indexed to, uint256 amount);
136   event MintFinished();
137 
138   bool public mintingFinished = false;
139 
140   modifier canMint() {
141     require(!mintingFinished);
142     _;
143   }
144 
145   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
146     totalSupply_ = totalSupply_.add(_amount);
147     balances[_to] = balances[_to].add(_amount);
148     Mint(_to, _amount);
149     Transfer(address(0), _to, _amount);
150     return true;
151   }
152 
153   function finishMinting() onlyOwner canMint public returns (bool) {
154     mintingFinished = true;
155     MintFinished();
156     return true;
157   }
158 }
159 
160 contract LumoToken is MintableToken {
161 
162     string public constant name = "Lumo";
163     string public constant symbol = "LUMO";
164     uint8 public constant decimals = 18;
165 
166     function getTotalSupply() public returns (uint256) {
167         return totalSupply_;
168     }
169 	
170 	function initialize() onlyOwner public {
171 		mint(msg.sender, 180 * 10**6 * 10**18);
172 		finishMinting();
173 	}
174 }