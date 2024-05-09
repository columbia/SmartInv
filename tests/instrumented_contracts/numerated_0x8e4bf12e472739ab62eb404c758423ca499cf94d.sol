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
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   function transferOwnership(address newOwner) onlyOwner public {
32     require(newOwner != address(0));
33     OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 }
37 
38 library SaferMath {
39   function mulX(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a * b;
41     assert(a == 0 || c / a == b);
42     return c;
43   }
44 
45   function divX(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 contract BasicToken is ERC20Basic {
65   using SaferMath for uint256;
66   mapping(address => uint256) balances;
67 
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70 
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   function balanceOf(address _owner) public constant returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 contract StandardToken is ERC20, BasicToken {
84 
85   mapping (address => mapping (address => uint256)) allowed;
86 
87   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89 
90     uint256 _allowance = allowed[_from][msg.sender];
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = _allowance.sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   function approve(address _spender, uint256 _value) public returns (bool) {
100     allowed[msg.sender][_spender] = _value;
101     Approval(msg.sender, _spender, _value);
102     return true;
103   }
104 
105   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
106     return allowed[_owner][_spender];
107   }
108 
109   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
110     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
111     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 
115   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
116     uint oldValue = allowed[msg.sender][_spender];
117     if (_subtractedValue > oldValue) {
118       allowed[msg.sender][_spender] = 0;
119     } else {
120       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
121     }
122     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123     return true;
124   }
125 }
126 
127 contract HELLCOIN is StandardToken, Ownable {
128 
129   string public constant name = "HELL COIN";
130   string public constant symbol = "HELL";
131   uint8 public constant decimals = 8;
132 
133   uint256 public constant SUPPLY_CAP = 10000000000 * (10 ** uint256(decimals));
134 
135   address NULL_ADDRESS = address(0);
136 
137 
138   event NoteChanged(string newNote);
139   string public note = "Welcome to Hell";
140   function setNote(string note_) public onlyOwner {
141       note = note_;
142       NoteChanged(note);
143   }
144 
145   
146   event PerformingDrop(uint count);
147   function drop(address[] addresses, uint256 amount) public onlyOwner {
148     uint256 amt = amount * 10**8;
149     require(amt > 0);
150     require(amt <= SUPPLY_CAP);
151     PerformingDrop(addresses.length);
152     
153     assert(addresses.length <= 1000);
154     assert(balances[owner] >= amt * addresses.length);
155     for (uint i = 0; i < addresses.length; i++) {
156       address recipient = addresses[i];
157       if(recipient != NULL_ADDRESS) {
158         balances[owner] -= amt;
159         balances[recipient] += amt;
160         Transfer(owner, recipient, amt);
161       }
162     }
163   }
164 
165   function HELLCOIN() public {
166     totalSupply = SUPPLY_CAP;
167     balances[msg.sender] = SUPPLY_CAP;
168   }
169 }