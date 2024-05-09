1 pragma solidity ^0.4.7;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     // assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     // assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     // assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract ERC20Basic {
48   uint256 public totalSupply;
49   function balanceOf(address who) constant returns (uint256);
50   function transfer(address to, uint256 value) returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) returns (bool);
57   function approve(address spender, uint256 value) returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) returns (bool) {
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of. 
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 contract StandardToken is ERC20, BasicToken {
90 
91   mapping (address => mapping (address => uint256)) allowed;
92 
93 
94   /**
95    * @dev Transfer tokens from one address to another
96    * @param _from address The address which you want to send tokens from
97    * @param _to address The address which you want to transfer to
98    * @param _value uint256 the amount of tokens to be transferred
99    */
100   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
101     var _allowance = allowed[_from][msg.sender];
102 
103     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
104     // require (_value <= _allowance);
105 
106     balances[_from] = balances[_from].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     allowed[_from][msg.sender] = _allowance.sub(_value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
115    * @param _spender The address which will spend the funds.
116    * @param _value The amount of tokens to be spent.
117    */
118   function approve(address _spender, uint256 _value) returns (bool) {
119 
120     // To change the approve amount you first have to reduce the addresses`
121     //  allowance to zero by calling `approve(_spender, 0)` if it is not
122     //  already 0 to mitigate the race condition described here:
123     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124     // require((_value == 0) || (allowed[msg.sender][_spender] == 0));
125 
126     allowed[msg.sender][_spender] = _value;
127     Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Function to check the amount of tokens that an owner allowed to a spender.
133    * @param _owner address The address which owns the funds.
134    * @param _spender address The address which will spend the funds.
135    * @return A uint256 specifying the amount of tokens still available for the spender.
136    */
137   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
138     return allowed[_owner][_spender];
139   }
140   
141     /*
142    * approve should be called when allowed[_spender] == 0. To increment
143    * allowed value is better to use this function to avoid 2 calls (and wait until 
144    * the first transaction is mined)
145    * From MonolithDAO Token.sol
146    */
147   function increaseApproval (address _spender, uint _addedValue) 
148     returns (bool success) {
149     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
150     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151     return true;
152   }
153 
154   function decreaseApproval (address _spender, uint _subtractedValue) 
155     returns (bool success) {
156     uint oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166 }
167 
168 contract Exploreon is StandardToken {
169     
170     string public name = "Exploreon";
171     string public symbol = "XPL";
172     uint public decimals = 3;
173     
174     uint public INITIAL_SUPPLY = 1000000;
175     
176     address public constant multisig = 
177     0x2aD9bebacc45d649E438eF24DeD6348d4a650b77;
178     
179     // 1 ether = 1000 EXP
180     uint public constant PRICE = 1000;
181     
182     function Exploreon() {
183         totalSupply = INITIAL_SUPPLY;
184         balances[msg.sender] = INITIAL_SUPPLY;
185     }
186     
187     function () payable {
188         createTokens(msg.sender);
189     }
190     
191     function createTokens(address recipient) payable {
192         if (msg.value == 0){
193             throw;
194         }
195         
196         uint tokens = msg.value.mul(getPrice());
197         totalSupply = totalSupply.add(tokens);
198         
199         balances[recipient] = balances[recipient].add(tokens);
200         
201         if (!multisig.send(msg.value)) {
202             throw;
203         }
204     }
205     
206     function getPrice() constant returns (uint result) {
207         return PRICE;
208     }
209     
210 }