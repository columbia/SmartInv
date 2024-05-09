1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal constant returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal constant returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   /**
49   * @dev transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) returns (bool) {
54     require(_to != address(0));
55 
56     // SafeMath.sub will throw if there is not enough balance.
57     balances[msg.sender] = balances[msg.sender].sub(_value);
58     balances[_to] = balances[_to].add(_value);
59     Transfer(msg.sender, _to, _value);
60     return true;
61   }
62 
63   /**
64   * @dev Gets the balance of the specified address.
65   * @param _owner The address to query the the balance of. 
66   * @return An uint256 representing the amount owned by the passed address.
67   */
68   function balanceOf(address _owner) constant returns (uint256 balance) {
69     return balances[_owner];
70   }
71 
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) allowed;
77 
78 
79   /**
80    * @dev Transfer tokens from one address to another
81    * @param _from address The address which you want to send tokens from
82    * @param _to address The address which you want to transfer to
83    * @param _value uint256 the amount of tokens to be transferred
84    */
85   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
86     require(_to != address(0));
87 
88     var _allowance = allowed[_from][msg.sender];
89 
90     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
91     // require (_value <= _allowance);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = _allowance.sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    * @param _spender The address which will spend the funds.
103    * @param _value The amount of tokens to be spent.
104    */
105   function approve(address _spender, uint256 _value) returns (bool) {
106 
107     // To change the approve amount you first have to reduce the addresses`
108     //  allowance to zero by calling `approve(_spender, 0)` if it is not
109     //  already 0 to mitigate the race condition described here:
110     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
112 
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifying the amount of tokens still available for the spender.
123    */
124   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
125     return allowed[_owner][_spender];
126   }
127   
128   /**
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until 
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    */
134   function increaseApproval (address _spender, uint _addedValue) 
135     returns (bool success) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141   function decreaseApproval (address _spender, uint _subtractedValue) 
142     returns (bool success) {
143     uint oldValue = allowed[msg.sender][_spender];
144     if (_subtractedValue > oldValue) {
145       allowed[msg.sender][_spender] = 0;
146     } else {
147       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
148     }
149     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152 
153 }
154 
155 contract IssuedToken is StandardToken {
156     string public name;
157     string public symbol;
158     uint public decimals;
159     address public owner;
160 
161     function IssuedToken(string _name, string _symbol, uint _totalSupply, uint _decimals) {
162         name = _name;
163         symbol = _symbol;
164         totalSupply = _totalSupply;
165         decimals = _decimals;
166 
167         balances[msg.sender] = _totalSupply;
168     }
169 }
170 
171 contract BurnableToken is StandardToken {
172 
173     /**
174      * @dev Burns a specific amount of tokens.
175      * @param _value The amount of token to be burned.
176      */
177     function burn(uint _value)
178         public
179     {
180         require(_value > 0);
181 
182         address burner = msg.sender;
183         balances[burner] = balances[burner].sub(_value);
184         totalSupply = totalSupply.sub(_value);
185         Burn(burner, _value);
186     }
187 
188     event Burn(address indexed burner, uint indexed value);
189 }
190 
191 contract GoldeaToken is IssuedToken, BurnableToken {
192     function GoldeaToken(uint256 _totalSupply) IssuedToken("GOLDEA", "GEA", _totalSupply, 8) {
193     }
194 }