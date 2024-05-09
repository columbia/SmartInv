1 pragma solidity ^0.4.4;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) public constant returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 contract ERC20 is ERC20Basic {
36   function allowance(address owner, address spender) public constant returns (uint256);
37   function transferFrom(address from, address to, uint256 value) public returns (bool);
38   function approve(address spender, uint256 value) public returns (bool);
39   event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 contract BasicToken is ERC20Basic {
42   using SafeMath for uint256;
43 
44   mapping(address => uint256) balances;
45 
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53 
54     // SafeMath.sub will throw if there is not enough balance.
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   /**
62   * @dev Gets the balance of the specified address.
63   * @param _owner The address to query the the balance of.
64   * @return An uint256 representing the amount owned by the passed address.
65   */
66   function balanceOf(address _owner) public constant returns (uint256 balance) {
67     return balances[_owner];
68   }
69 
70 }
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74   mapping (address => mapping (address => uint256)) allowed;
75 
76 
77   /**
78    * @dev Transfer tokens from one address to another
79    * @param _from address The address which you want to send tokens from
80    * @param _to address The address which you want to transfer to
81    * @param _value uint256 the amount of tokens to be transferred
82    */
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85 
86     uint256 _allowance = allowed[_from][msg.sender];
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
100    *
101    * Beware that changing an allowance with this method brings the risk that someone may use both the old
102    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
103    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
104    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105    * @param _spender The address which will spend the funds.
106    * @param _value The amount of tokens to be spent.
107    */
108   function approve(address _spender, uint256 _value) public returns (bool) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Function to check the amount of tokens that an owner allowed to a spender.
116    * @param _owner address The address which owns the funds.
117    * @param _spender address The address which will spend the funds.
118    * @return A uint256 specifying the amount of tokens still available for the spender.
119    */
120   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }
123 
124   /**
125    * approve should be called when allowed[_spender] == 0. To increment
126    * allowed value is better to use this function to avoid 2 calls (and wait until
127    * the first transaction is mined)
128    * From MonolithDAO Token.sol
129    */
130   function increaseApproval (address _spender, uint _addedValue)
131     public returns (bool success) {
132     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
133     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134     return true;
135   }
136 
137   function decreaseApproval (address _spender, uint _subtractedValue)
138     public returns (bool success) {
139     uint oldValue = allowed[msg.sender][_spender];
140     if (_subtractedValue > oldValue) {
141       allowed[msg.sender][_spender] = 0;
142     } else {
143       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
144     }
145     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 
149 }
150 
151 contract BurnableToken is StandardToken {
152 
153     event Burn(address indexed burner, uint256 value);
154 
155     /**
156      * @dev Burns a specific amount of tokens.
157      * @param _value The amount of token to be burned.
158      */
159     function burn(uint256 _value) public {
160         require(_value > 0);
161 
162         address burner = msg.sender;
163         balances[burner] = balances[burner].sub(_value);
164         totalSupply = totalSupply.sub(_value);
165         Burn(burner, _value);
166     }
167 }
168 contract CgC is BurnableToken {
169 string public name = 'CgC';
170 string public symbol = 'CgC';
171 uint public decimals = 1;
172 uint public INITIAL_SUPPLY = 200000;
173 function CGC() public {
174   totalSupply = INITIAL_SUPPLY;
175   balances[msg.sender] = INITIAL_SUPPLY;
176 }
177 }