1 pragma solidity ^0.4.11;
2 
3 contract Crowdsale {
4     function buyTokens(address _recipient) payable;
5 }
6 
7 contract CapWhitelist {
8     address public owner;
9     mapping (address => uint256) public whitelist;
10 
11     event Set(address _address, uint256 _amount);
12 
13     function CapWhitelist() {
14         owner = msg.sender;
15         // Set in prod
16     }
17 
18     function destruct() {
19         require(msg.sender == owner);
20         selfdestruct(owner);
21     }
22 
23     function setWhitelisted(address _address, uint256 _amount) {
24         require(msg.sender == owner);
25         setWhitelistInternal(_address, _amount);
26     }
27 
28     function setWhitelistInternal(address _address, uint256 _amount) private {
29         whitelist[_address] = _amount;
30         Set(_address, _amount);
31     }
32 }
33 
34 contract Token {
35     uint256 public totalSupply;
36     function balanceOf(address _owner) constant returns (uint256 balance);
37     function transfer(address _to, uint256 _value) returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
39     function approve(address _spender, uint256 _value) returns (bool success);
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 
46 /*  ERC 20 token */
47 contract StandardToken is Token {
48     using SafeMath for uint256;
49     function transfer(address _to, uint256 _value) returns (bool success) {
50       if (balances[msg.sender] >= _value) {
51         balances[msg.sender] = balances[msg.sender].sub(_value);
52         balances[_to] = balances[_to].add(_value);
53         Transfer(msg.sender, _to, _value);
54         return true;
55       } else {
56         return false;
57       }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
62         balances[_to] = balances[_to].add(_value);
63         balances[_from] = balances[_from].sub(_value);
64         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
65         Transfer(_from, _to, _value);
66         return true;
67       } else {
68         return false;
69       }
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender,  uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
87       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
88       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
89       return true;
90     }
91 
92     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
93       uint oldValue = allowed[msg.sender][_spender];
94       if (_subtractedValue > oldValue) {
95         allowed[msg.sender][_spender] = 0;
96       } else {
97         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
98       }
99       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100       return true;
101     }
102 
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowed;
105 }
106 
107 contract Ownable {
108   address public owner;
109 
110 
111   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   function Ownable() {
119     owner = msg.sender;
120   }
121 
122 
123   /**
124    * @dev Throws if called by any account other than the owner.
125    */
126   modifier onlyOwner() {
127     require(msg.sender == owner);
128     _;
129   }
130 
131 
132   /**
133    * @dev Allows the current owner to transfer control of the contract to a newOwner.
134    * @param newOwner The address to transfer ownership to.
135    */
136   function transferOwnership(address newOwner) onlyOwner public {
137     require(newOwner != address(0));
138     OwnershipTransferred(owner, newOwner);
139     owner = newOwner;
140   }
141 
142 }
143 
144 library SafeMath {
145   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
146     uint256 c = a * b;
147     assert(a == 0 || c / a == b);
148     return c;
149   }
150 
151   function div(uint256 a, uint256 b) internal constant returns (uint256) {
152     // assert(b > 0); // Solidity automatically throws when dividing by 0
153     uint256 c = a / b;
154     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155     return c;
156   }
157 
158   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
159     assert(b <= a);
160     return a - b;
161   }
162 
163   function add(uint256 a, uint256 b) internal constant returns (uint256) {
164     uint256 c = a + b;
165     assert(c >= a);
166     return c;
167   }
168 }
169 
170 contract MintableToken is StandardToken, Ownable {
171   using SafeMath for uint256;
172   event Mint(address indexed to, uint256 amount);
173   event MintFinished();
174 
175   bool public mintingFinished = false;
176 
177   modifier canMint() {
178     require(!mintingFinished);
179     _;
180   }
181 
182   /**
183    * @dev Function to mint tokens
184    * @param _to The address that will receive the minted tokens.
185    * @param _amount The amount of tokens to mint.
186    */
187   function mint(address _to, uint256 _amount) onlyOwner canMint public {
188     totalSupply = totalSupply.add(_amount);
189     balances[_to] = balances[_to].add(_amount);
190     Mint(_to, _amount);
191     Transfer(0x0, _to, _amount);
192   }
193 
194   /**
195    * @dev Function to stop minting new tokens.
196    */
197   function finishMinting() onlyOwner public {
198     mintingFinished = true;
199     MintFinished();
200   }
201 }
202 contract RCNToken is MintableToken {
203     string public constant name = "Ripio Credit Network Token";
204     string public constant symbol = "RCN";
205     uint8 public constant decimals = 18;
206     string public version = "1.0";
207 }