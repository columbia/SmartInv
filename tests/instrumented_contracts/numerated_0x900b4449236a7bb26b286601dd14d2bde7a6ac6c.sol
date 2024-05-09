1 pragma solidity ^0.4.18;
2 
3 
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) public constant returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 
38 
39 /**
40  * Basic version of StandardToken, with no allowances.
41  */
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47   function transfer(address _to, uint256 _value) public returns (bool) {
48     require(_to != address(0));
49     require(_value <= balances[msg.sender]);
50 
51     // SafeMath.sub will throw if there is not enough balance.
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   function balanceOf(address _owner) public constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 
65 
66 /**
67  * ERC20 interface - see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public constant returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 /**
78  * Implementation of the basic standard token.
79  * https://github.com/ethereum/EIPs/issues/20
80  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
81  */
82 contract StandardToken is ERC20, BasicToken {
83 
84   mapping (address => mapping (address => uint256)) internal allowed;
85 
86 
87   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[_from]);
90     require(_value <= allowed[_from][msg.sender]);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
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
109   /**
110    * approve should be called when allowed[_spender] == 0. To increment
111    * allowed value is better to use this function to avoid 2 calls (and wait until
112    * the first transaction is mined)
113    * From MonolithDAO Token.sol
114    */
115   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
116     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
117     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
122     uint oldValue = allowed[msg.sender][_spender];
123     if (_subtractedValue > oldValue) {
124       allowed[msg.sender][_spender] = 0;
125     } else {
126       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
127     }
128     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129     return true;
130   }
131 
132 }
133 
134 
135 
136 /**
137  * @title Burnable Token
138  * @dev Token that can be irreversibly burned (destroyed).
139  */
140 contract BurnableToken is StandardToken {
141 
142   event Burn(address indexed burner, uint256 value);
143 
144   /**
145    * @dev Burns a specific amount of tokens.
146    * @param _value The amount of token to be burned.
147    */
148   function burn(uint256 _value) public {
149     require(_value <= balances[msg.sender]);
150     // no need to require value <= totalSupply, since that would imply the
151     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
152 
153     address burner = msg.sender;
154     balances[burner] = balances[burner].sub(_value);
155     totalSupply = totalSupply.sub(_value);
156     Burn(burner, _value);
157     Transfer(burner, address(0), _value);
158   }
159 }
160 
161 
162 
163 
164 contract EARTHToken is BurnableToken {
165 
166     string public name = "EARTH Token";
167     string public symbol = "EARTH";
168     uint public decimals = 8;
169     uint public INITIAL_SUPPLY = 100000000000000000;
170 
171     function EARTHToken() public {
172         totalSupply = INITIAL_SUPPLY;
173         balances[msg.sender] = INITIAL_SUPPLY;
174     }
175     
176 }