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
128 contract iPUMP is StandardToken, Ownable {
129 
130   string public constant name = "iPUMP Token";
131   string public constant symbol = "iPUMP";
132   uint8 public constant decimals = 8;
133 
134   uint256 public constant SUPPLY_CAP = 21000000 * (10 ** uint256(decimals));
135 
136   address NULL_ADDRESS = address(0);
137 
138   uint public nonce = 0;
139 
140 event NonceTick(uint nonce);
141   function incNonce() {
142     nonce += 1;
143     if(nonce > 100) {
144         nonce = 0;
145     }
146     NonceTick(nonce);
147   }
148 
149   event PerformingDrop(uint count);
150   function drop(address[] addresses, uint256 amount) public onlyOwner {
151     uint256 amt = amount * 10**8;
152     require(amt > 0);
153     require(amt <= SUPPLY_CAP);
154     PerformingDrop(addresses.length);
155 
156     assert(addresses.length <= 1000);
157     assert(balances[owner] >= amt * addresses.length);
158     for (uint i = 0; i < addresses.length; i++) {
159       address recipient = addresses[i];
160       if(recipient != NULL_ADDRESS) {
161         balances[owner] -= amt;
162         balances[recipient] += amt;
163         Transfer(owner, recipient, amt);
164       }
165     }
166   }
167   
168   function iPUMP() {
169     totalSupply = SUPPLY_CAP;
170     balances[msg.sender] = SUPPLY_CAP;
171   }
172 }