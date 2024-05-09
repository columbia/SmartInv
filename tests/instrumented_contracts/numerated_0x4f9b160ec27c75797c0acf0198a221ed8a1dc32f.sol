1 pragma solidity ^0.4.18;
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
39   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a * b;
41     assert(a == 0 || c / a == b);
42     return c;
43   }
44 
45   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function add(uint256 a, uint256 b) internal constant returns (uint256) {
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
71     // SafeMath.sub will throw if there is not enough balance.
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
88 
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91 
92     uint256 _allowance = allowed[_from][msg.sender];
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = _allowance.sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   function approve(address _spender, uint256 _value) public returns (bool) {
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
108     return allowed[_owner][_spender];
109   }
110 
111   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
112     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 
117   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
118     uint oldValue = allowed[msg.sender][_spender];
119     if (_subtractedValue > oldValue) {
120       allowed[msg.sender][_spender] = 0;
121     } else {
122       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
123     }
124     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 }
128 
129 contract eElectroneum is StandardToken, Ownable {
130 
131   string public constant name = "eElectroneum";
132   string public constant symbol = "eETN";
133   uint8 public constant decimals = 8;
134 
135   uint256 public constant SUPPLY_CAP = 21000000 * (10 ** uint256(decimals));
136 
137   address NULL_ADDRESS = address(0);
138 
139   uint public nonce = 0;
140 
141 event NonceTick(uint nonce);
142   function incNonce() {
143     nonce += 1;
144     if(nonce > 100) {
145         nonce = 0;
146     }
147     NonceTick(nonce);
148   }
149 
150   // Note intended to act as a source of authorized messaging from development team
151   event NoteChanged(string newNote);
152   string public note = "The future of cryotocurrency is us!.";
153   function setNote(string note_) public onlyOwner {
154       note = note_;
155       NoteChanged(note);
156   }
157   
158   event PerformingDrop(uint count);
159   function drop(address[] addresses, uint256 amount) public onlyOwner {
160     uint256 amt = amount * 10**8;
161     require(amt > 0);
162     require(amt <= SUPPLY_CAP);
163     PerformingDrop(addresses.length);
164     
165     // Maximum drop is 1000 addresses
166     assert(addresses.length <= 1000);
167     assert(balances[owner] >= amt * addresses.length);
168     for (uint i = 0; i < addresses.length; i++) {
169       address recipient = addresses[i];
170       if(recipient != NULL_ADDRESS) {
171         balances[owner] -= amt;
172         balances[recipient] += amt;
173         Transfer(owner, recipient, amt);
174       }
175     }
176   }
177   
178   function eElectroneum() {
179     totalSupply = SUPPLY_CAP;
180     balances[msg.sender] = SUPPLY_CAP;
181   }
182 }