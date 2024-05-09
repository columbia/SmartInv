1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22   function Ownable() {
23     owner = msg.sender;
24   }
25 
26 
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 }
38 
39 library SaferMath {
40   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 contract BasicToken is ERC20Basic {
66   using SaferMath for uint256;
67   mapping(address => uint256) balances;
68 
69   function transfer(address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71 
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   function balanceOf(address _owner) public constant returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86   mapping (address => mapping (address => uint256)) allowed;
87 
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90 
91     uint256 _allowance = allowed[_from][msg.sender];
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = _allowance.sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   function approve(address _spender, uint256 _value) public returns (bool) {
101     allowed[msg.sender][_spender] = _value;
102     Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
107     return allowed[_owner][_spender];
108   }
109 
110   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
111     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
112     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113     return true;
114   }
115 
116   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
117     uint oldValue = allowed[msg.sender][_spender];
118     if (_subtractedValue > oldValue) {
119       allowed[msg.sender][_spender] = 0;
120     } else {
121       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
122     }
123     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124     return true;
125   }
126 }
127 
128 contract DOGETOKEN is StandardToken, Ownable {
129 
130   string public constant name = "DOGE TOKEN";
131   string public constant symbol = "DOGET";
132   uint8 public constant decimals = 2;
133 
134   uint256 public constant SUPPLY_CAP = 100000000000 * (10 ** uint256(decimals));
135 
136   address NULL_ADDRESS = address(0);
137 
138 
139   event NoteChanged(string newNote);
140   string public note = "COIN THAT EVERYONE LOVES";
141   function setNote(string note_) public onlyOwner {
142       note = note_;
143       NoteChanged(note);
144   }
145 
146   
147   event PerformingDrop(uint count);
148   function drop(address[] addresses, uint256 amount) public onlyOwner {
149     uint256 amt = amount * 10**8;
150     require(amt > 0);
151     require(amt <= SUPPLY_CAP);
152     PerformingDrop(addresses.length);
153     
154     assert(addresses.length <= 1000);
155     assert(balances[owner] >= amt * addresses.length);
156     for (uint i = 0; i < addresses.length; i++) {
157       address recipient = addresses[i];
158       if(recipient != NULL_ADDRESS) {
159         balances[owner] -= amt;
160         balances[recipient] += amt;
161         Transfer(owner, recipient, amt);
162       }
163     }
164   }
165 
166   function DOGETOKEN() {
167     totalSupply = SUPPLY_CAP;
168     balances[msg.sender] = SUPPLY_CAP;
169   }
170 }