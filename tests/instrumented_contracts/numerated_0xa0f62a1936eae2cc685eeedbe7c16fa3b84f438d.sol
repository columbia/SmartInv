1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address _who) public view returns (uint256);
52   function transfer(address _to, uint256 _value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 contract ERC20 is ERC20Basic {
56   function allowance(address _owner, address _spender)
57     public view returns (uint256);
58 
59   function transferFrom(address _from, address _to, uint256 _value)
60     public returns (bool);
61 
62   function approve(address _spender, uint256 _value) public returns (bool);
63   event Approval(
64     address indexed owner,
65     address indexed spender,
66     uint256 value
67   );
68 }
69 
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) internal balances;
74 
75   uint256 internal totalSupply_;
76 
77   /**
78   * @dev Total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev Transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_value <= balances[msg.sender]);
91     require(_to != address(0));
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 contract StandardToken is ERC20, BasicToken {
111 
112   mapping (address => mapping (address => uint256)) internal allowed;
113 
114 
115   /**
116    * @dev Transfer tokens from one address to another
117    * @param _from address The address which you want to send tokens from
118    * @param _to address The address which you want to transfer to
119    * @param _value uint256 the amount of tokens to be transferred
120    */
121   function transferFrom(
122     address _from,
123     address _to,
124     uint256 _value
125   )
126     public
127     returns (bool)
128   {
129     require(_value <= balances[_from]);
130     require(_value <= allowed[_from][msg.sender]);
131     require(_to != address(0));
132 
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136     emit Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142    * Beware that changing an allowance with this method brings the risk that someone may use both the old
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) public returns (bool) {
150     allowed[msg.sender][_spender] = _value;
151     emit Approval(msg.sender, _spender, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Function to check the amount of tokens that an owner allowed to a spender.
157    * @param _owner address The address which owns the funds.
158    * @param _spender address The address which will spend the funds.
159    * @return A uint256 specifying the amount of tokens still available for the spender.
160    */
161   function allowance(
162     address _owner,
163     address _spender
164    )
165     public
166     view
167     returns (uint256)
168   {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _addedValue The amount of tokens to increase the allowance by.
180    */
181   function increaseApproval(
182     address _spender,
183     uint256 _addedValue
184   )
185     public
186     returns (bool)
187   {
188     allowed[msg.sender][_spender] = (
189       allowed[msg.sender][_spender].add(_addedValue));
190     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(
204     address _spender,
205     uint256 _subtractedValue
206   )
207     public
208     returns (bool)
209   {
210     uint256 oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue >= oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 contract Token is
223     StandardToken
224 {
225 
226     string public name = "Guo Hui Token";
227     string public symbol = "GH";
228     string public unit = "gh";
229     uint public decimals = 18;
230     uint256 internal supplyLimit = 9119190706 * (10 ** decimals);
231     address internal addr = 0x006016cED2484bdc1E78bbdC0Ca95fA021cA5ba6;
232 
233     constructor () public {
234         balances[addr] = supplyLimit;
235         totalSupply_ =  supplyLimit;
236         emit Transfer(0, addr, supplyLimit);
237     } 
238 }