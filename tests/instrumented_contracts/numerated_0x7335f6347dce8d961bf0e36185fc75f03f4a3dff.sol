1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     if (_a == 0) {
10       return 0;
11     }
12 
13     c = _a * _b;
14     assert(c / _a == _b);
15     return c;
16   }
17 
18   /**
19   * Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
22     return _a / _b;
23   }
24 
25   /**
26   * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     assert(_b <= _a);
30     return _a - _b;
31   }
32 
33   /**
34   *  Adds two numbers, throws on overflow.
35   */
36   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
37     c = _a + _b;
38     assert(c >= _a);
39     return c;
40   }
41 }
42 
43 contract ERC20 {
44   uint256 public totalSupply;
45 
46   function balanceOf(address _who) public view returns (uint256);
47 
48   function allowance(address _owner, address _spender) public view returns (uint256);
49 
50  // This generates a public event on the blockchain that will notify clients
51   function transfer(address _to, uint256 _value) public returns (bool);
52   
53 // This generates a public event on the blockchain that will notify clients
54   function approve(address _spender, uint256 _value) public returns (bool);
55 
56   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
57 
58   event Transfer( address indexed from, address indexed to,  uint256 value);
59 
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61   
62   // This notifies clients about the amount burnt
63   event Burn(address indexed from, uint256 value);
64 }
65 
66 
67 contract StandardToken is ERC20 {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74 
75   /**
76   * Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public view returns (uint256) {
81     return balances[_owner];
82   }
83 
84   /**
85    *  Function to check the amount of tokens that an owner allowed to a spender.
86    * @param _owner address The address which owns the funds.
87    * @param _spender address The address which will spend the funds.
88    * @return A uint256 specifying the amount of tokens still available for the spender.
89    */
90   function allowance(address _owner, address _spender) public view returns (uint256){
91     return allowed[_owner][_spender];
92   }
93 
94   /**
95   * Transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_value <= balances[msg.sender]);
101     require(_to != address(0));
102 
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   function approve(address _spender, uint256 _value) public returns (bool) {
110     allowed[msg.sender][_spender] = _value;
111     emit Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   /**
116    *  Transfer tokens from one address to another
117    * @param _from address The address which you want to send tokens from
118    * @param _to address The address which you want to transfer to
119    * @param _value uint256 the amount of tokens to be transferred
120    */
121   function transferFrom(
122     address _from,
123     address _to,
124     uint256 _value
125   )
126     public returns (bool)
127   {
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130     require(_to != address(0));
131 
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135     emit Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   /**
140    * Increase the amount of tokens that an owner allowed to a spender.
141    * approve should be called when allowed[_spender] == 0. To increment
142    * allowed value is better to use this function to avoid 2 calls (and wait until
143    * the first transaction is mined)
144    * @param _spender The address which will spend the funds.
145    * @param _addedValue The amount of tokens to increase the allowance by.
146    */
147   function increaseApproval(
148     address _spender,
149     uint256 _addedValue
150   ) public  returns (bool) {
151     allowed[msg.sender][_spender] = (
152       allowed[msg.sender][_spender].add(_addedValue));
153     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157   /**
158    *  Decrease the amount of tokens that an owner allowed to a spender.
159    * approve should be called when allowed[_spender] == 0. To decrement
160    * allowed value is better to use this function to avoid 2 calls (and wait until
161    * the first transaction is mined)
162    * @param _spender The address which will spend the funds.
163    * @param _subtractedValue The amount of tokens to decrease the allowance by.
164    */
165   function decreaseApproval(
166     address _spender,
167     uint256 _subtractedValue
168   )
169     public
170     returns (bool)
171   {
172     uint256 oldValue = allowed[msg.sender][_spender];
173     if (_subtractedValue >= oldValue) {
174       allowed[msg.sender][_spender] = 0;
175     } else {
176       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177     }
178     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181   
182    /**
183      * Destroy tokens
184      *
185      * Remove `_value` tokens from the system irreversibly
186      *
187      * @param _value the amount of money to burn
188      */
189     function burn(uint256 _value) public returns (bool success) {
190         require(balances[msg.sender] >= _value);   // Check if the sender has enough
191         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
192         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
193         emit Burn(msg.sender, _value);
194         return true;
195     }
196 
197     /**
198      * Destroy tokens from other account
199      *
200      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
201      *
202      * @param _from the address of the sender
203      * @param _value the amount of money to burn
204      */
205     function burnFrom(address _from, uint256 _value) public returns (bool success) {
206         require(balances[_from] >= _value);                // Check if the targeted balance is enough
207         require(_value <= allowed[_from][msg.sender]);    // Check allowance
208         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
209         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
210         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
211         emit Burn(_from, _value);
212         return true;
213     }
214 }
215 
216 contract POBTokenERC20 is StandardToken {
217     // Public variables of the token
218     string public name = "POB Network";
219     string public symbol = "POB";
220     uint8 constant public decimals = 18;
221     uint256 constant public initialSupply = 2100*100000000;
222 
223 	constructor() public {
224         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
225         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
226         emit Transfer(address(0), msg.sender, totalSupply);
227     }
228 }