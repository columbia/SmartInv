1 // GYM Ledger Token Contract - Project website: www.gymledger.com
2 
3 // Token distribution:
4 
5 //    Private Investors = 10%
6 //    GYM Ledger Token Sale = 20%
7 //    Ecosystem Development = 30%
8 //    Long Term Fund (Future Growth, Partnerships, EtC) = 25%
9 //    Advisors and Development = 15%
10 
11 // GYM Reward, LLC
12 
13 pragma solidity ^0.4.25;
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 contract Ownable {
42   address public owner;
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46   constructor() public {
47     owner = msg.sender;
48   }
49   modifier onlyOwner() {
50     require(msg.sender == owner, "Only owner can call this function");
51     _;
52   }
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0), "Valid address is required");
55     emit OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 contract ERC20Basic {
62   uint256 public totalSupply;
63   function balanceOf(address who) public view returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   function transfer(address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0), "Valid address is required");
82     require(_value <= balances[msg.sender], "Not enougth balance");
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
94 
95 }
96 
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) internal allowed;
100 
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0), "Valid address is required");
103     require(_value <= balances[_from], "Not enough balance");
104     require(_value <= allowed[_from][msg.sender], "Amount exeeds allowance");
105 
106     balances[_from] = balances[_from].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109     emit Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   function approve(address _spender, uint256 _value) public returns (bool) {
114     allowed[msg.sender][_spender] = _value;
115     emit Approval(msg.sender, _spender, _value);
116     return true;
117   }
118 
119   function allowance(address _owner, address _spender) public view returns (uint256) {
120     return allowed[_owner][_spender];
121   }
122 
123   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
124     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
125     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 
129   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
130     uint oldValue = allowed[msg.sender][_spender];
131     if (_subtractedValue > oldValue) {
132       allowed[msg.sender][_spender] = 0;
133     } else {
134       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
135     }
136     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139 
140 }
141 
142 contract LGRToken is Ownable, StandardToken {
143   string public constant name = "GYM Ledger Token";
144   string public constant symbol = "LGR";
145   uint8 public constant decimals = 18;
146   uint256 public constant MAX_SUPPLY = 100000000 * (10 ** uint256(decimals));
147   bool public paused;
148   address public minter;
149 
150   event Minted(address indexed to, uint256 amount);
151   event Paused(bool paused);
152 
153   modifier notPaused() {
154     require(paused == false, "Token is paused");
155     _;
156   }
157 
158   modifier canMint() {
159     require((msg.sender == owner || msg.sender == minter), "You are not authorized");
160     _;
161   }
162 
163   constructor() public {        
164     paused = false;              
165   }
166 
167   function pause(bool _paused) public onlyOwner {
168     paused = _paused;
169     emit Paused(paused);
170   }
171 
172   function setMinter(address _minter) public onlyOwner {
173     minter = _minter;
174   }
175 
176   function mintTo(address _to, uint256 _amount) public canMint {
177     require((totalSupply + _amount) <= MAX_SUPPLY, "Invalid amount");
178     balances[_to] = balances[_to].add(_amount);
179     totalSupply = totalSupply.add(_amount);
180     emit Minted(_to, _amount);
181   }
182 
183   function transfer(address _to, uint256 _value) public notPaused returns (bool) {
184     return super.transfer(_to, _value);
185   }
186 
187   function transferFrom(address _from, address _to, uint256 _value) public notPaused returns (bool) {
188     return super.transferFrom(_from, _to, _value);
189   }
190 
191   function approve(address _spender, uint256 _value) public returns (bool) {
192     return super.approve(_spender, _value);
193   }
194 
195   function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
196     return super.increaseApproval(_spender, _addedValue);
197   }
198 
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
200     return super.decreaseApproval(_spender, _subtractedValue);
201   }
202 
203 }