1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   uint256 public totalSupply;
9   string public name;
10   string public symbol;
11   uint8 public decimals;
12 
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   function allowance(address owner, address spender) public view returns (uint256);
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17   function approve(address spender, uint256 value) public returns (bool);
18 
19   event Transfer(address indexed from, address indexed to, uint256 value);
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract HybridBlock is ERC20 {
57   using SafeMath for uint256;
58   
59   // The owner of this token
60   address public owner;
61 
62   // The balance in HybridBlock token that every address has
63   mapping (address => uint256) balances;
64 
65   // Keeps track of allowances for particular address
66   mapping (address => mapping (address => uint256)) public allowed;
67 
68   /**
69    * The constructor for the HybridBlock token
70    */
71   function HybridBlock() public {
72     owner = 0x35118ba64fD141F43958cF9EB493F13aca976e6a;
73     name = "Hybrid Block";
74     symbol = "HYB";
75     decimals = 18;
76     totalSupply = 1e9 * 10 ** uint256(decimals);
77 
78     // Initially allocate all minted tokens to the owner
79     balances[owner] = totalSupply;
80   }
81 
82   /**
83    * @dev Retrieves the balance of a specified address
84    * @param _owner address The address to query the balance of.
85    * @return A uint256 representing the amount owned by the _owner
86    */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91   /**
92    * @dev Transfers tokens to a specific address
93    * @param _to address The address to transfer tokens to
94    * @param _value unit256 The amount to be transferred
95    */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99   
100     // Subtract first
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102 
103     // Now add tokens
104     balances[_to] = balances[_to].add(_value);
105 
106     // Notify that a transfer has occurred
107     Transfer(msg.sender, _to, _value);
108 
109     return true;
110   }
111 
112   /**
113    * @dev Transfer on behalf of another address
114    * @param _from address The address to send tokens from
115    * @param _to address The address to send tokens to
116    * @param _value uint256 The amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     // Decrease both the _from amount and the allowed transfer amount
124     balances[_from] = balances[_from].sub(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126 
127     // Give _to the tokens
128     balances[_to] = balances[_to].add(_value);
129 
130     // Notify that a transfer has occurred
131     Transfer(_from, _to, _value);
132 
133     return true;
134   }
135 
136   /**
137    * @dev Approve sent address to spend the specified amount of tokens on
138    * behalf of msg.sender
139    *
140    * See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * for any potential security concerns
142    *
143    * @param _spender address The address that will spend funds
144    * @param _value uint256 The number of tokens they are allowed to spend
145    */
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     require(allowed[msg.sender][_spender] == 0);
148 
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Returns the amount a spender is allowed to spend for a particular
156    * address
157    * @param _owner address The address which owns the funds
158    * @param _spender address The address which will spend the funds.
159    * @return uint256 The number of tokens still available for the spender
160    */
161   function allowance(address _owner, address _spender) public view returns (uint256) {
162     return allowed[_owner][_spender];
163   }
164 
165   /**
166    * @dev Increases the number of tokens a spender is allowed to spend for
167    * `msg.sender`
168    * @param _spender address The address of the spender
169    * @param _addedValue uint256 The amount to increase the spenders approval by
170    */
171   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
172     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177   /**
178    * @dev Decreases the number of tokens a spender is allowed to spend for
179    * `msg.sender`
180    * @param _spender address The address of the spender
181    * @param _subtractedValue uint256 The amount to decrease the spenders approval by
182    */
183   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
184     uint _value = allowed[msg.sender][_spender];
185     if (_subtractedValue > _value) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = _value.sub(_subtractedValue);
189     }
190 
191     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 }