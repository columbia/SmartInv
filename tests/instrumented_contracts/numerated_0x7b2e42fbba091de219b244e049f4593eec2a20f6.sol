1 pragma solidity ^0.4.11;
2 
3 
4 
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) constant returns (uint256);
35   function transfer(address to, uint256 value) returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) constant returns (uint256);
41   function transferFrom(address from, address to, uint256 value) returns (bool);
42   function approve(address spender, uint256 value) returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56   function transfer(address _to, uint256 _value) returns (bool) {
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
86     var _allowance = allowed[_from][msg.sender];
87 
88     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
89     // require (_value <= _allowance);
90 
91     balances[_from] = balances[_from].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     allowed[_from][msg.sender] = _allowance.sub(_value);
94     Transfer(_from, _to, _value);
95     return true;
96   }
97 
98   /**
99    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
100    * @param _spender The address which will spend the funds.
101    * @param _value The amount of tokens to be spent.
102    */
103   function approve(address _spender, uint256 _value) returns (bool) {
104 
105     // To change the approve amount you first have to reduce the addresses`
106     //  allowance to zero by calling `approve(_spender, 0)` if it is not
107     //  already 0 to mitigate the race condition described here:
108     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
109     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
110 
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
118    * @param _owner address The address which owns the funds.
119    * @param _spender address The address which will spend the funds.
120    * @return A uint256 specifying the amount of tokens still available for the spender.
121    */
122   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123     return allowed[_owner][_spender];
124   }
125   
126     /*
127    * approve should be called when allowed[_spender] == 0. To increment
128    * allowed value is better to use this function to avoid 2 calls (and wait until 
129    * the first transaction is mined)
130    * From MonolithDAO Token.sol
131    */
132   function increaseApproval (address _spender, uint _addedValue) 
133     returns (bool success) {
134     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
135     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139   function decreaseApproval (address _spender, uint _subtractedValue) 
140     returns (bool success) {
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
153 contract SimpleToken is StandardToken{
154     
155     string public name = "CryptoSoft Coin";
156     string public symbol ="CSC";
157     uint public decimals = 2;
158 	// Total amount is still 9.876.543.210 but the variable also needs the decimal digits
159     uint public INITIAL_SUPPLY = 987654321000;
160     
161     function SimpleToken(){
162         totalSupply = INITIAL_SUPPLY;
163         balances[msg.sender] = INITIAL_SUPPLY;
164         
165     }
166     
167 }