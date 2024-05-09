1 pragma solidity ^0.4.20;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 contract BasicToken is ERC20Basic {
12   using SafeMath for uint256;
13 
14   mapping(address => uint256) balances;
15 
16   function transfer(address _to, uint256 _value) public returns (bool) {
17     require(_to != address(0));
18     require(_value > 0 && _value <= balances[msg.sender]);
19 
20     balances[msg.sender] = balances[msg.sender].sub(_value);
21     balances[_to] = balances[_to].add(_value);
22     Transfer(msg.sender, _to, _value);
23     return true;
24   }
25 
26 
27   function balanceOf(address _owner) public constant returns (uint256 balance) {
28     return balances[_owner];
29   }
30 }
31 
32 
33 contract ERC20 is ERC20Basic {
34   function allowance(address owner, address spender) public constant returns (uint256);
35   function transferFrom(address from, address to, uint256 value) public returns (bool);
36   function approve(address spender, uint256 value) public returns (bool);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 contract StandardToken is ERC20, BasicToken {
41 
42   mapping (address => mapping (address => uint256)) internal allowed;
43 
44   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
45     require(_to != address(0));
46     require(_value > 0 && _value <= balances[_from]);
47     require(_value <= allowed[_from][msg.sender]);
48 
49     balances[_from] = balances[_from].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
52     Transfer(_from, _to, _value);
53     return true;
54   }
55 
56   function approve(address _spender, uint256 _value) public returns (bool) {
57     allowed[msg.sender][_spender] = _value;
58     Approval(msg.sender, _spender, _value);
59     return true;
60   }
61 
62   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
63     return allowed[_owner][_spender];
64   }
65 }
66 
67 contract Ownable {
68   address public owner;
69 
70 
71   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73   function Ownable() {
74     owner = msg.sender;
75   }
76 
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   function transferOwnership(address newOwner) onlyOwner public {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 contract Pausable is Ownable {
91   event Pause();
92   event Unpause();
93 
94   bool public paused = false;
95 
96 
97   modifier whenNotPaused() {
98     require(!paused);
99     _;
100   }
101 
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   function pause() onlyOwner whenNotPaused public {
108     paused = true;
109     Pause();
110   }
111 
112   function unpause() onlyOwner whenPaused public {
113     paused = false;
114     Unpause();
115   }
116 }
117 
118 contract Frozen is Pausable {
119     event FrozenFunds(address target, bool frozen);
120     
121     mapping (address => bool) public frozenAccount;
122     function freezeAccount(address target, bool freeze) onlyOwner whenNotPaused public {
123         frozenAccount[target] = freeze;
124         FrozenFunds(target, freeze);
125     }
126     
127     modifier whenNotFrozen() {
128         require(!frozenAccount[msg.sender]);
129         _;
130     }
131 }
132 
133 contract PausableFrozenToken is StandardToken, Frozen {
134 
135   function transfer(address _to, uint256 _value) public whenNotPaused whenNotFrozen returns (bool) {
136     return super.transfer(_to, _value);
137   }
138 
139   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused whenNotFrozen returns (bool) {
140     require(!frozenAccount[_from]);
141     return super.transferFrom(_from, _to, _value);
142   }
143 
144   function approve(address _spender, uint256 _value) public whenNotPaused whenNotFrozen returns (bool) {
145     return super.approve(_spender, _value);
146   }
147 }
148 
149 contract HMCToken is PausableFrozenToken {
150     string public name = "HMC";
151     string public symbol = "HMC";
152     uint8 public decimals = 18;
153 
154     function HMCToken() {
155       totalSupply = 1000000000 * (10**(uint256(decimals)));
156       balances[msg.sender] = totalSupply;    
157     }
158 
159     function () {
160         revert();
161     }
162 }
163 
164 library SafeMath {
165   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
166     uint256 c = a * b;
167     assert(a == 0 || c / a == b);
168     return c;
169   }
170 
171   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
172     assert(b <= a);
173     return a - b;
174   }
175 
176   function div(uint256 a, uint256 b) internal constant returns (uint256) {
177     uint256 c = a / b;
178     return c;
179   }
180   
181   function add(uint256 a, uint256 b) internal constant returns (uint256) {
182     uint256 c = a + b;
183     assert(c >= a);
184     return c;
185   }
186 }