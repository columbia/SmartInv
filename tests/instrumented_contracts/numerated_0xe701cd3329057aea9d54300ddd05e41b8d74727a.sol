1 pragma solidity ^0.4.16;
2 
3 /* 
4    High value, community controlled token.
5    */
6    contract ERC20Basic {
7     uint256 public totalSupply;
8     function balanceOf(address who) constant returns (uint256);
9     function transfer(address to, uint256 value) returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11   }
12 
13 /*
14    ERC20 interface
15   see https://github.com/ethereum/EIPs/issues/20
16   */
17   contract ERC20 is ERC20Basic {
18     function allowance(address owner, address spender) constant returns (uint256);
19     function transferFrom(address from, address to, uint256 value) returns (bool);
20     function approve(address spender, uint256 value) returns (bool);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22   }
23 
24 /*  SafeMath - the lowest gas library
25   Math operations with safety checks that throw on error
26   */
27   library SafeMath {
28 
29     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
30       uint256 c = a * b;
31       assert(a == 0 || c / a == b);
32       return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal constant returns (uint256) {
36       // assert(b > 0); // Solidity automatically throws when dividing by 0
37       uint256 c = a / b;
38       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39       return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
43       assert(b <= a);
44       return a - b;
45     }
46 
47     function add(uint256 a, uint256 b) internal constant returns (uint256) {
48       uint256 c = a + b;
49       assert(c >= a);
50       return c;
51     }
52 
53   }
54 
55 /*
56 Basic token
57  Basic version of StandardToken, with no allowances. 
58  */
59  contract BasicToken is ERC20Basic {
60 
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   function transfer(address _to, uint256 _value) returns (bool) {
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   /*
73   Gets the balance of the specified address.
74    param _owner The address to query the the balance of. 
75    return An uint256 representing the amount owned by the passed address.
76    */
77    function balanceOf(address _owner) constant returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 /* Implementation of the basic standard token.
84   https://github.com/ethereum/EIPs/issues/20
85   */
86   contract StandardToken is ERC20, BasicToken {
87 
88     mapping (address => mapping (address => uint256)) allowed;
89 
90   /*
91     Transfer tokens from one address to another
92     param _from address The address which you want to send tokens from
93     param _to address The address which you want to transfer to
94     param _value uint256 the amout of tokens to be transfered
95     */
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
97       var _allowance = allowed[_from][msg.sender];
98 
99       // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
100       // require (_value <= _allowance);
101 
102       balances[_to] = balances[_to].add(_value);
103       balances[_from] = balances[_from].sub(_value);
104       allowed[_from][msg.sender] = _allowance.sub(_value);
105       Transfer(_from, _to, _value);
106       return true;
107     }
108 
109   /*
110   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
111    param _spender The address which will spend the funds.
112    param _value The amount of Roman Lanskoj's tokens to be spent.
113    */
114    function approve(address _spender, uint256 _value) returns (bool) {
115 
116     // To change the approve amount you first have to reduce the addresses`
117     //  allowance to zero by calling `approve(_spender, 0)` if it is not
118     //  already 0 to mitigate the race condition described here:
119     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
121 
122     allowed[msg.sender][_spender] = _value;
123     Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   /*
128   Function to check the amount of tokens that an owner allowed to a spender.
129   param _owner address The address which owns the funds.
130   param _spender address The address which will spend the funds.
131   return A uint256 specifing the amount of tokens still available for the spender.
132   */
133   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
134     return allowed[_owner][_spender];
135   }
136 }
137 
138 /*
139 The Ownable contract has an owner address, and provides basic authorization control
140  functions, this simplifies the implementation of "user permissions".
141  */
142  contract Ownable {
143 
144   address public owner;
145 
146 
147   function Ownable() {
148     owner = msg.sender;
149   }
150 
151   /*
152   Throws if called by any account other than the owner.
153   */
154   modifier onlyOwner() {
155     require(msg.sender == owner);
156     _;
157   }
158 
159   /*
160   Allows the current owner to transfer control of the contract to a newOwner.
161   param newOwner The address to transfer ownership to.
162   */
163   function transferOwnership(address newOwner) onlyOwner {
164     require(newOwner != address(0));      
165     owner = newOwner;
166   }
167 
168 }
169 
170 contract MToken is StandardToken, Ownable {
171   string public constant name = "10M Token";
172   string public constant symbol = "10MT";
173   uint public constant decimals = 10;
174   uint256 public initialSupply;
175 
176   function MToken () { 
177    totalSupply = 10000000 * 10 ** decimals;
178    balances[msg.sender] = totalSupply;
179    initialSupply = totalSupply; 
180    Transfer(0, this, totalSupply);
181    Transfer(this, msg.sender, totalSupply);
182   }
183 
184   function distribute10MT(address[] addresses) onlyOwner {
185     // 1106.2688 * (10**10)
186     for (uint i = 0; i < addresses.length; i++) {
187       balances[owner] -= 11669024045261 ;
188       balances[addresses[i]] += 11669024045261;
189       Transfer(owner, addresses[i], 11669024045261);
190     }
191   }
192 }