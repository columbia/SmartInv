1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 interface ERC20 {
34   function balanceOf(address who) public constant returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   function allowance(address owner, address spender) public constant returns (uint256);
37   function transferFrom(address from, address to, uint256 value) public returns (bool);
38   function approve(address spender, uint256 value) public returns (bool);
39 
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 
45 contract XNTToken is ERC20 {
46   using SafeMath for uint256;
47 
48   uint256 public totalSupply;
49 
50   mapping (address => uint256) balances;
51   mapping (address => mapping (address => uint256)) internal allowed;
52 
53   string public constant name = "EXANTE Token";
54   string public constant symbol = "XNT";
55   uint8 public constant decimals = 0;
56 
57   uint256 public constant INITIAL_SUPPLY = 100000000;
58 
59   /**
60    * @dev Constructor that gives msg.sender all of existing tokens.
61    */
62   function XNTToken() public {
63     totalSupply = INITIAL_SUPPLY;
64     balances[msg.sender] = INITIAL_SUPPLY;
65   }
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75 
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of.
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92   /**
93    * @dev Transfer tokens from one address to another
94    * @param _from address The address which you want to send tokens from
95    * @param _to address The address which you want to transfer to
96    * @param _value uint256 the amount of tokens to be transferred
97    */
98   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[_from]);
101     require(_value <= allowed[_from][msg.sender]);
102 
103     balances[_from] = balances[_from].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
106     Transfer(_from, _to, _value);
107     return true;
108   }
109 
110   /**
111    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
112    *
113    * Beware that changing an allowance with this method brings the risk that someone may use both the old
114    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
115    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
116    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117    * @param _spender The address which will spend the funds.
118    * @param _value The amount of tokens to be spent.
119    */
120   function approve(address _spender, uint256 _value) public returns (bool) {
121     require(_value != 0 || allowed[msg.sender][_spender] == 0);
122 
123     allowed[msg.sender][_spender] = _value;
124     Approval(msg.sender, _spender, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Function to check the amount of tokens that an owner allowed to a spender.
130    * @param _owner address The address which owns the funds.
131    * @param _spender address The address which will spend the funds.
132    * @return A uint256 specifying the amount of tokens still available for the spender.
133    */
134   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
135     return allowed[_owner][_spender];
136   }
137 
138   /**
139    * approve should be called when allowed[_spender] == 0. To increment
140    * allowed value is better to use this function to avoid 2 calls (and wait until
141    * the first transaction is mined)
142    * From MonolithDAO Token.sol
143    */
144   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
145     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
146     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149 
150   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
151     uint oldValue = allowed[msg.sender][_spender];
152     if (_subtractedValue > oldValue) {
153       allowed[msg.sender][_spender] = 0;
154     } else {
155       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
156     }
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 }