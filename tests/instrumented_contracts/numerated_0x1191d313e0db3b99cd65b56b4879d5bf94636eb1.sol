1 pragma solidity ^0.4.24;
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
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) constant returns (uint256);
32   function transfer(address to, uint256 value) returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) constant returns (uint256);
38   function transferFrom(address from, address to, uint256 value) returns (bool);
39   function approve(address spender, uint256 value) returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   function transfer(address _to, uint256 _value) returns (bool) {
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   function balanceOf(address _owner) constant returns (uint256 balance) {
56     return balances[_owner];
57   }
58 }
59 
60 contract StandardToken is ERC20, BasicToken {
61 
62   mapping (address => mapping (address => uint256)) allowed;
63 
64   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
65     var _allowance = allowed[_from][msg.sender];
66 
67     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
68     // require (_value <= _allowance);
69 
70     balances[_from] = balances[_from].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     allowed[_from][msg.sender] = _allowance.sub(_value);
73     Transfer(_from, _to, _value);
74     return true;
75   }
76 
77   function approve(address _spender, uint256 _value) returns (bool) {
78 
79     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
80 
81     allowed[msg.sender][_spender] = _value;
82     Approval(msg.sender, _spender, _value);
83     return true;
84   }
85 
86   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87     return allowed[_owner][_spender];
88   }
89 
90   function increaseApproval (address _spender, uint _addedValue)
91     returns (bool success) {
92     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
93     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94     return true;
95   }
96 
97   function decreaseApproval (address _spender, uint _subtractedValue)
98     returns (bool success) {
99     uint oldValue = allowed[msg.sender][_spender];
100     if (_subtractedValue > oldValue) {
101       allowed[msg.sender][_spender] = 0;
102     } else {
103       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
104     }
105     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106     return true;
107   }
108 }
109 
110 contract Ownable {
111   address public owner;
112 
113   function Ownable() {
114     owner = msg.sender;
115   }
116 
117   modifier onlyOwner() {
118     require(msg.sender == owner);
119     _;
120   }
121 
122   function transferOwnership(address newOwner) onlyOwner {
123     require(newOwner != address(0));
124     owner = newOwner;
125   }
126 }
127 
128 contract MintableToken is StandardToken, Ownable {
129   event Mint(address indexed to, uint256 amount);
130   event MintFinished();
131 
132   bool public mintingFinished = false;
133 
134   modifier canMint() {
135     require(!mintingFinished);
136     _;
137   }
138 
139   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
140     totalSupply = totalSupply.add(_amount);
141     balances[_to] = balances[_to].add(_amount);
142     Mint(_to, _amount);
143     Transfer(0x0, _to, _amount);
144     return true;
145   }
146 
147   function finishMinting() onlyOwner returns (bool) {
148     mintingFinished = true;
149     MintFinished();
150     return true;
151   }
152 }
153 
154 
155 contract KapelaToken is MintableToken {
156   string public name = "Kapela";
157   string public symbol = "KAP";
158   uint8 public decimals = 8;
159 
160   function KapelaToken() {
161       totalSupply = 2000000 * 1e8;
162       balances[msg.sender] = totalSupply;
163   }
164 
165   event Burn(address indexed burner, uint indexed value);
166 
167   function burn(uint _value) onlyOwner {
168     require(_value > 0);
169 
170     address burner = msg.sender;
171     balances[burner] = balances[burner].sub(_value);
172     totalSupply = totalSupply.sub(_value);
173     Burn(burner, _value);
174   }
175 }