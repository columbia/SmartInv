1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  * Created for providing solution for deforestation in Bengaluru Techsummit Blockchain Hackathon
8  * website www.gyantraz.com   designed by shashikanth r
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) constant returns (uint256);
47   function transferFrom(address from, address to, uint256 value) returns (bool);
48   function approve(address spender, uint256 value) returns (bool);
49   event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 
53 
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) returns (bool) {
65     require(_to != address(0));
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of. 
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83 }
84 
85 contract StandardToken is ERC20, BasicToken {
86 
87   mapping (address => mapping (address => uint256)) allowed;
88 
89 
90   /**
91    * @dev Transfer tokens from one address to another
92    * @param _from address The address which you want to send tokens from
93    * @param _to address The address which you want to transfer to
94    * @param _value uint256 the amount of tokens to be transferred
95    */
96   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
97     require(_to != address(0));
98 
99     var _allowance = allowed[_from][msg.sender];
100 
101     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
102     // require (_value <= _allowance);
103 
104     balances[_from] = balances[_from].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
113    * @param _spender The address which will spend the funds.
114    * @param _value The amount of tokens to be spent.
115    */
116   function approve(address _spender, uint256 _value) returns (bool) {
117 
118     // To change the approve amount you first have to reduce the addresses`
119     //  allowance to zero by calling `approve(_spender, 0)` if it is not
120     //  already 0 to mitigate the race condition described here:
121     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
123 
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
136     return allowed[_owner][_spender];
137   }
138   
139   /**
140    * approve should be called when allowed[_spender] == 0. To increment
141    * allowed value is better to use this function to avoid 2 calls (and wait until 
142    * the first transaction is mined)
143    * From MonolithDAO Token.sol
144    */
145   function increaseApproval (address _spender, uint _addedValue) 
146     returns (bool success) {
147     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   function decreaseApproval (address _spender, uint _subtractedValue) 
153     returns (bool success) {
154     uint oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue > oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159     }
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164 }
165 
166 
167 contract YSVONE is StandardToken {
168 
169   string public constant name = "YSVONE";
170   string public constant symbol = "YS1";
171   uint8 public constant decimals = 2;
172 
173   uint256 public constant INITIAL_SUPPLY = 90000000000000000;
174 
175   /**
176    * @dev Contructor that gives msg.sender all of existing tokens.
177    */
178   function YSVONE() {
179     totalSupply = INITIAL_SUPPLY;
180     balances[msg.sender] = INITIAL_SUPPLY;
181   }
182 
183 }