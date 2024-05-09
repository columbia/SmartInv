1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ERC20Basic {
31   function totalSupply() public view returns (uint256);
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender) public view returns (uint256);
39   function transferFrom(address from, address to, uint256 value) public returns (bool);
40   function approve(address spender, uint256 value) public returns (bool);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   uint256 totalSupply_;
50 
51   function totalSupply() public view returns (uint256) {
52     return totalSupply_;
53   }
54 
55   function transfer(address _to, uint256 _value) public returns (bool) {
56     require(_to != address(0));
57     require(_value <= balances[msg.sender]);
58 
59     balances[msg.sender] = balances[msg.sender].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     emit Transfer(msg.sender, _to, _value);
62     return true;
63   }
64 
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71 
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74   /**
75    * @dev Transfer tokens from one address to another
76    * @param _from address The address which you want to send tokens from
77    * @param _to address The address which you want to transfer to
78    * @param _value uint256 the amount of tokens to be transferred
79    */
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value <= allowed[_from][msg.sender]);
84 
85     balances[_from] = balances[_from].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88     emit Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   /**
93    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
94    *
95    * Beware that changing an allowance with this method brings the risk that someone may use both the old
96    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
97    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
98    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
99    * @param _spender The address which will spend the funds.
100    * @param _value The amount of tokens to be spent.
101    */
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     emit Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   /**
109    * @dev Function to check the amount of tokens that an owner allowed to a spender.
110    * @param _owner address The address which owns the funds.
111    * @param _spender address The address which will spend the funds.
112    * @return A uint256 specifying the amount of tokens still available for the spender.
113    */
114   function allowance(address _owner, address _spender) public view returns (uint256) {
115     return allowed[_owner][_spender];
116   }
117 
118   /**
119    * @dev Increase the amount of tokens that an owner allowed to a spender.
120    *
121    * approve should be called when allowed[_spender] == 0. To increment
122    * allowed value is better to use this function to avoid 2 calls (and wait until
123    * the first transaction is mined)
124    * From MonolithDAO Token.sol
125    * @param _spender The address which will spend the funds.
126    * @param _addedValue The amount of tokens to increase the allowance by.
127    */
128   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
129     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
130     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133 
134   /**
135    * @dev Decrease the amount of tokens that an owner allowed to a spender.
136    *
137    * approve should be called when allowed[_spender] == 0. To decrement
138    * allowed value is better to use this function to avoid 2 calls (and wait until
139    * the first transaction is mined)
140    * From MonolithDAO Token.sol
141    * @param _spender The address which will spend the funds.
142    * @param _subtractedValue The amount of tokens to decrease the allowance by.
143    */
144   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
145     uint oldValue = allowed[msg.sender][_spender];
146     if (_subtractedValue > oldValue) {
147       allowed[msg.sender][_spender] = 0;
148     } else {
149       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
150     }
151     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154 }
155 
156 contract arcToken is StandardToken {
157 
158   string public name; 
159   string public symbol; 
160   uint8 public decimals; 
161 
162   function arcToken() public {
163     name = 'ARC Token';
164     symbol = 'ARC';
165     decimals = 18;
166     totalSupply_ = 10000000000 * (10 ** uint256(decimals));
167     balances[msg.sender] = totalSupply_;
168     emit Transfer(0x0, msg.sender, totalSupply_);
169   }
170 }