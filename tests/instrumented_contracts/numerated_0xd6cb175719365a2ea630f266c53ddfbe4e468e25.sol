1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public creator;
5   address public owner;
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   constructor() Ownable() public {
9     creator = msg.sender;
10     owner = msg.sender;
11   }
12 
13   modifier onlyOwner() {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   modifier onlyCreator() {
19     require(msg.sender == creator);
20     _;
21   }
22   function transferOwnership(address newOwner) public onlyOwner {
23     require(newOwner != address(0));
24     emit OwnershipTransferred(owner, newOwner);
25     owner = newOwner;
26   }
27   function returnOwnership() public onlyCreator {
28     owner = creator;
29   }
30 
31 }
32 
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 contract ERC20Basic {
63   uint256 public totalSupply;
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73   mapping(address => bool) frozenAddress;
74 
75   function checkFrozen(address checkAddress) internal view returns (bool) {
76     return frozenAddress[checkAddress];
77   }
78 
79   function transfer(address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81     require(_value <= balances[msg.sender]);
82     require(!checkFrozen(msg.sender));
83 
84     // SafeMath.sub will throw if there is not enough balance.
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     emit Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93   }
94 }
95 
96 
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public view returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 contract StandardToken is ERC20, BasicToken {
105   event ChangeBalance (address from, uint256 fromBalance, address to, uint256 toBalance, uint256 seq);
106 
107   mapping (address => mapping (address => uint256)) internal allowed;
108 
109   uint256 internal seq = 0;
110 
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115     require(!checkFrozen(_from));
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     emit Transfer(_from, _to, _value);
121     emit ChangeBalance (_from, balances[_from], _to, balances[_to], ++seq);
122     return true;
123   }
124 
125   function approve(address _spender, uint256 _value) public returns (bool) {
126     allowed[msg.sender][_spender] = _value;
127     emit Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   function allowance(address _owner, address _spender) public view returns (uint256) {
132     return allowed[_owner][_spender];
133   }
134 
135   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
142     uint oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152 }
153 
154 
155 contract MintableToken is StandardToken, Ownable {
156   event Mint(address indexed to, uint256 amount);
157 
158   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
159     totalSupply = totalSupply.add(_amount);
160     balances[_to] = balances[_to].add(_amount);
161     emit Mint(_to, _amount);
162     emit Transfer(address(0), _to, _amount);
163     emit ChangeBalance (address(0), 0, _to, balances[_to], ++seq);
164     return true;
165   }
166 
167   function freezeAddress(address frAddress) onlyOwner public {
168     frozenAddress[frAddress] = true;
169   }
170   function unfreezeAddress(address frAddress) onlyOwner public {
171     frozenAddress[frAddress] = false;
172   }
173 
174 }
175 
176 contract HunimalToken is MintableToken {
177     string public constant name = "HUNI";
178     string public constant symbol = "HNI";
179     uint8 public constant decimals = 18;
180 
181     constructor() HunimalToken () public MintableToken () {
182     }
183 }