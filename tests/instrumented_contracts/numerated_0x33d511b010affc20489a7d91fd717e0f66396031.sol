1 pragma solidity ^0.4.24;
2 
3 /**
4  * Denzer Initiative - Emerging Technologies
5  * Email: denzerinitiative@gmail.com
6  * Telegram: t.me/DenzerInitiative and @DarciDenzer
7  * GitHub: https://github.com/Denzer-Initiative
8  */
9 
10 /**
11  * @title SafeMath
12  */
13 library SafeMath {
14 
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 /**
44  * @title Ownable
45  */
46 contract Ownable {
47   address public owner;
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51   constructor() public {
52     owner = 0x00Ab11bDCC66832D90b354AcE0a9145567323D75;
53   }
54 
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     emit OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66 }
67 
68 /**
69  * @title ERC20Basic
70  */
71 contract ERC20Basic {
72   function totalSupply() public view returns (uint256);
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 /**
79  * @title ERC20 interface
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) public view returns (uint256);
83   function transferFrom(address from, address to, uint256 value) public returns (bool);
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @title Basic token
90  */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96   uint256 totalSupply_;
97 
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     emit Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  */
120 contract StandardToken is ERC20, BasicToken {
121 
122   mapping (address => mapping (address => uint256)) internal allowed;
123 
124   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[_from]);
127     require(_value <= allowed[_from][msg.sender]);
128 
129     balances[_from] = balances[_from].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132     emit Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     emit Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   function allowance(address _owner, address _spender) public view returns (uint256) {
143     return allowed[_owner][_spender];
144   }
145 
146   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
147     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
153     uint oldValue = allowed[msg.sender][_spender];
154     if (_subtractedValue > oldValue) {
155       allowed[msg.sender][_spender] = 0;
156     } else {
157       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
158     }
159     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163 }
164 
165 contract DenzerToken is StandardToken, Ownable {
166     
167   string public name;
168   string public symbol;
169   uint8 public decimals;
170   uint256 public initialSupply;
171 
172   constructor() public {
173     name = 'DenzerToken';
174     symbol = 'Denzer';
175     decimals = 18;
176     initialSupply = 50000000 * 10 ** uint256(decimals);
177     totalSupply_ = initialSupply;
178     balances[owner] = initialSupply;
179     emit Transfer(0x0, owner, initialSupply);
180   }
181 }