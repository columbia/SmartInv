1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) public returns (bool) {
21     require(_to != address(0));
22     require(_value <= balances[msg.sender]);
23 
24     // SafeMath.sub will throw if there is not enough balance.
25     balances[msg.sender] = balances[msg.sender].sub(_value);
26     balances[_to] = balances[_to].add(_value);
27     Transfer(msg.sender, _to, _value);
28     return true;
29   }
30 
31   /**
32   * @dev Gets the balance of the specified address.
33   * @param _owner The address to query the the balance of.
34   * @return An uint256 representing the amount owned by the passed address.
35   */
36   function balanceOf(address _owner) public view returns (uint256 balance) {
37     return balances[_owner];
38   }
39 
40 }
41 
42 contract ERC20 is ERC20Basic {
43   function allowance(address owner, address spender) public view returns (uint256);
44   function transferFrom(address from, address to, uint256 value) public returns (bool);
45   function approve(address spender, uint256 value) public returns (bool);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract StandardToken is ERC20, BasicToken {
50 
51   mapping (address => mapping (address => uint256)) internal allowed;
52 
53 
54   /**
55    * @dev Transfer tokens from one address to another
56    * @param _from address The address which you want to send tokens from
57    * @param _to address The address which you want to transfer to
58    * @param _value uint256 the amount of tokens to be transferred
59    */
60   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[_from]);
63     require(_value <= allowed[_from][msg.sender]);
64 
65     balances[_from] = balances[_from].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
68     Transfer(_from, _to, _value);
69     return true;
70   }
71 
72   /**
73    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
74    *
75    * Beware that changing an allowance with this method brings the risk that someone may use both the old
76    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
77    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
78    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79    * @param _spender The address which will spend the funds.
80    * @param _value The amount of tokens to be spent.
81    */
82   function approve(address _spender, uint256 _value) public returns (bool) {
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88   /**
89    * @dev Function to check the amount of tokens that an owner allowed to a spender.
90    * @param _owner address The address which owns the funds.
91    * @param _spender address The address which will spend the funds.
92    * @return A uint256 specifying the amount of tokens still available for the spender.
93    */
94   function allowance(address _owner, address _spender) public view returns (uint256) {
95     return allowed[_owner][_spender];
96   }
97 
98   /**
99    * approve should be called when allowed[_spender] == 0. To increment
100    * allowed value is better to use this function to avoid 2 calls (and wait until
101    * the first transaction is mined)
102    * From MonolithDAO Token.sol
103    */
104   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
105     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
111     uint oldValue = allowed[msg.sender][_spender];
112     if (_subtractedValue > oldValue) {
113       allowed[msg.sender][_spender] = 0;
114     } else {
115       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
116     }
117     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121 }
122 
123 contract AndroidToken is StandardToken {
124 
125     string public name = 'AndroidToken';
126 
127     string public symbol = 'ANDT';
128 
129     uint256 public decimals = 18;
130 
131     function AndroidToken() public {
132         totalSupply = 25000000 * 10 ** uint(decimals);
133         balances[msg.sender] = totalSupply;
134     }
135 
136 }
137 
138 library SafeMath {
139   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140     if (a == 0) {
141       return 0;
142     }
143     uint256 c = a * b;
144     assert(c / a == b);
145     return c;
146   }
147 
148   function div(uint256 a, uint256 b) internal pure returns (uint256) {
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150     uint256 c = a / b;
151     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return c;
153   }
154 
155   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156     assert(b <= a);
157     return a - b;
158   }
159 
160   function add(uint256 a, uint256 b) internal pure returns (uint256) {
161     uint256 c = a + b;
162     assert(c >= a);
163     return c;
164   }
165 }