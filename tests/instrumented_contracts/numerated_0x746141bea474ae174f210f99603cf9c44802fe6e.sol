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
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   function transferOwnership(address newOwner) onlyOwner public {
35     require(newOwner != address(0));
36     OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 }
40 
41 library SaferMath {
42   function mulX(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function divX(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 contract BasicToken is ERC20Basic {
68   using SaferMath for uint256;
69   mapping(address => uint256) balances;
70 
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73 
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   function balanceOf(address _owner) public constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 contract StandardToken is ERC20, BasicToken {
87 
88   mapping (address => mapping (address => uint256)) allowed;
89 
90   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92 
93     uint256 _allowance = allowed[_from][msg.sender];
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = _allowance.sub(_value);
98     Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
109     return allowed[_owner][_spender];
110   }
111 
112   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
113     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
119     uint oldValue = allowed[msg.sender][_spender];
120     if (_subtractedValue > oldValue) {
121       allowed[msg.sender][_spender] = 0;
122     } else {
123       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124     }
125     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 }
129 
130 contract YOURCOIN is StandardToken, Ownable {
131 
132   string public constant name = "YOUR COIN";
133   string public constant symbol = "YOUR";
134   uint8 public constant decimals = 8;
135 
136   uint256 public constant SUPPLY_CAP = 10000000 * (10 ** uint256(decimals));
137 
138   address NULL_ADDRESS = address(0);
139 
140 
141   event NoteChanged(string newNote);
142   string public note = "YOUR COIN.";
143   function setNote(string note_) public onlyOwner {
144       note = note_;
145       NoteChanged(note);
146   }
147 
148   
149   event PerformingDrop(uint count);
150   function drop(address[] addresses, uint256 amount) public onlyOwner {
151     uint256 amt = amount * 10**8;
152     require(amt > 0);
153     require(amt <= SUPPLY_CAP);
154     PerformingDrop(addresses.length);
155     
156     // Maximum drop is 1000 addresses
157     assert(addresses.length <= 1000);
158     assert(balances[owner] >= amt * addresses.length);
159     for (uint i = 0; i < addresses.length; i++) {
160       address recipient = addresses[i];
161       if(recipient != NULL_ADDRESS) {
162         balances[owner] -= amt;
163         balances[recipient] += amt;
164         Transfer(owner, recipient, amt);
165       }
166     }
167   }
168 
169   function YOURCOIN() public {
170     totalSupply = SUPPLY_CAP;
171     balances[msg.sender] = SUPPLY_CAP;
172   }
173 }