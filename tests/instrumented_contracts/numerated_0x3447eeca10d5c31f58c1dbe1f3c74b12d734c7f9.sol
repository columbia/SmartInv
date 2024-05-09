1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45  
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51  
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address who) public view returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83 
84   
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   function approve(address _spender, uint256 _value) public returns (bool) {
125     allowed[msg.sender][_spender] = _value;
126     Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130   function allowance(address _owner, address _spender) public view returns (uint256) {
131     return allowed[_owner][_spender];
132   }
133 
134   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
135     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139 
140   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
141     uint oldValue = allowed[msg.sender][_spender];
142     if (_subtractedValue > oldValue) {
143       allowed[msg.sender][_spender] = 0;
144     } else {
145       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146     }
147     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151 }
152 
153  contract warlock is StandardToken, Ownable {
154     // Constants
155     string  public constant name = "warlock token";
156     string  public constant symbol = "warlock";
157     uint8   public constant decimals = 2;
158     uint256 public constant INITIAL_SUPPLY      = 1000000000 * (10 ** uint256(decimals));
159 
160     uint public amountRaised;
161     uint256 public buyPrice = 50000;
162     bool public crowdsaleClosed;
163     
164      function warlock() public {
165       totalSupply_ = INITIAL_SUPPLY;
166       balances[msg.sender] = INITIAL_SUPPLY;
167       Transfer(0x0, msg.sender, INITIAL_SUPPLY);
168     }
169 
170     function _transfer(address _from, address _to, uint _value) internal {     
171         require (balances[_from] >= _value);               // Check if the sender has enough
172         require (balances[_to] + _value > balances[_to]); // Check for overflows
173    
174         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
175         balances[_to] = balances[_to].add(_value);                            // Add the same to the recipient
176          
177         Transfer(_from, _to, _value);
178     }
179 
180 
181     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
182         require( _recipients.length > 0 && _recipients.length == _values.length);
183 
184         uint total = 0;
185         for(uint i = 0; i < _values.length; i++){
186             total = total.add(_values[i]);
187         }
188         require(total <= balances[msg.sender]);
189 
190         for(uint j = 0; j < _recipients.length; j++){
191             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
192             Transfer(msg.sender, _recipients[j], _values[j]);
193         }
194 
195         balances[msg.sender] = balances[msg.sender].sub(total);
196         return true;
197     }
198 }