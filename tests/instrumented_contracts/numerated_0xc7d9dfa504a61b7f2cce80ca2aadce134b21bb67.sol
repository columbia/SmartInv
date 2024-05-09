1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title ERC20 Token Standard
5  * @dev see https://theethereum.wiki/w/index.php/ERC20_Token_Standard
6  */
7 contract ERC20Interface {
8     function totalSupply() public constant returns (uint);
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 /**
20  * @title SafeMath Lib
21  * @dev see https://theethereum.wiki/w/index.php/ERC20_Token_Standard
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66     Minerta Token
67     @author minerta dev team
68 */
69 contract MINERTA is ERC20Interface{
70     //Token information
71     string public constant name = "MINERTA";
72     string public constant symbol = "MIT";
73     uint8 public constant decimals = 18;
74     uint _totalSupply ; 
75     using SafeMath for uint256;
76     uint256 public constant INITIAL_SUPPLY = 500 * (10**6) * (10 ** uint256(decimals));
77     mapping(address => uint256) balances;
78     mapping (address => mapping (address => uint256)) internal allowed;
79     
80   function MINERTA() public {
81     _totalSupply = INITIAL_SUPPLY;
82     balances[msg.sender] = INITIAL_SUPPLY;
83     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
84   }
85   
86   function totalSupply() public view returns (uint256) {
87     return _totalSupply;
88   }
89   
90    function balanceOf(address _owner) public view returns (uint256 balance) {
91     return balances[_owner];
92   }
93     
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97     require(_value>0);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105   
106   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[_from]);
109     require(_value <= allowed[_from][msg.sender]);
110     require(_value>0);
111     
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118   
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122     return true;
123   }
124   
125    function allowance(address _owner, address _spender) public view returns (uint256) {
126     return allowed[_owner][_spender];
127   }
128 
129   /**
130    * @dev Increase the amount of tokens that an owner allowed to a spender.
131    *
132    * approve should be called when allowed[_spender] == 0. To increment
133    * allowed value is better to use this function to avoid 2 calls (and wait until
134    * the first transaction is mined)
135    * From MonolithDAO Token.sol
136    * @param _spender The address which will spend the funds.
137    * @param _addedValue The amount of tokens to increase the allowance by.
138    */
139   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
140     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144 
145    /**
146    * @dev Decrease the amount of tokens that an owner allowed to a spender.
147    *
148    * approve should be called when allowed[_spender] == 0. To decrement
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * From MonolithDAO Token.sol
152    * @param _spender The address which will spend the funds.
153    * @param _subtractedValue The amount of tokens to decrease the allowance by.
154    */
155   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
156     uint oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 }