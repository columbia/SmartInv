1 pragma solidity ^0.4.24;
2 
3 contract Token {
4 
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address _who) public view returns (uint256);
7   function transfer(address _to, uint256 _value) public returns (bool);
8   function allowance(address _owner, address _spender) public view returns (uint256);
9 
10   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
11 
12   function approve(address _spender, uint256 _value) public returns (bool);
13   event Approval(address indexed_owner,address indexed_spender,uint256 value);
14   event Transfer(address indexed_from, address indexed_to, uint256 value);
15 }
16 
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
23     if (_a == 0) {
24       return 0;
25     }
26 
27     c = _a * _b;
28     assert(c / _a == _b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
36     // assert(_b > 0); // Solidity automatically throws when dividing by 0
37     // uint256 c = _a / _b;
38     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
39     return _a / _b;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     assert(_b <= _a);
47     return _a - _b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
54     c = _a + _b;
55     assert(c >= _a);
56     return c;
57   }
58 }
59 
60 contract StandardToken is Token {
61   using SafeMath for uint256;
62   mapping (address => mapping (address => uint256)) internal allowed;
63 
64   mapping(address => uint256) internal balances;
65 
66   uint256 internal totalSupply_;
67 
68   /**
69   * @dev Total number of tokens in existence
70   */
71   function totalSupply() public view returns (uint256) {
72     return totalSupply_;
73   }
74 
75   /**
76   * @dev Transfer token for a specified address
77   * @param _to The address to transfer to.
78   * @param _value The amount to be transferred.
79   */
80   function transfer(address _to, uint256 _value) public returns (bool) {
81     require(_value <= balances[msg.sender]);
82     require(_to != address(0));
83 
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     emit Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) public view returns (uint256) {
96     return balances[_owner];
97   }
98 
99   /**
100    * @dev Transfer tokens from one address to another
101    * @param _from address The address which you want to send tokens from
102    * @param _to address The address which you want to transfer to
103    * @param _value uint256 the amount of tokens to be transferred
104    */
105   function transferFrom(
106     address _from,
107     address _to,
108     uint256 _value
109   )
110     public
111     returns (bool)
112   {
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115     require(_to != address(0));
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     emit Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     emit Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(
146     address _owner,
147     address _spender
148    )
149     public
150     view
151     returns (uint256)
152   {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157    * @dev Increase the amount of tokens that an owner allowed to a spender.
158    * approve should be called when allowed[_spender] == 0. To increment
159    * allowed value is better to use this function to avoid 2 calls (and wait until
160    * the first transaction is mined)
161    * From MonolithDAO Token.sol
162    * @param _spender The address which will spend the funds.
163    * @param _addedValue The amount of tokens to increase the allowance by.
164    */
165   function increaseApproval(
166     address _spender,
167     uint256 _addedValue
168   )
169     public
170     returns (bool)
171   {
172     allowed[msg.sender][_spender] = (
173     allowed[msg.sender][_spender].add(_addedValue));
174     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178   /**
179    * @dev Decrease the amount of tokens that an owner allowed to a spender.
180    * approve should be called when allowed[_spender] == 0. To decrement
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _subtractedValue The amount of tokens to decrease the allowance by.
186    */
187   function decreaseApproval(
188     address _spender,
189     uint256 _subtractedValue
190   )
191     public
192     returns (bool)
193   {
194     uint256 oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue >= oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 }
204 
205 contract TokaToken is StandardToken {
206     uint8 constant public decimals = 6;
207     uint256 public INITIAL_SUPPLY = 10000000000000000;
208     string constant public name = "Toka";
209     string constant public symbol = "TT";
210 
211     constructor() public {
212       totalSupply_ = INITIAL_SUPPLY;
213       balances[msg.sender] = totalSupply_;
214     }
215 }