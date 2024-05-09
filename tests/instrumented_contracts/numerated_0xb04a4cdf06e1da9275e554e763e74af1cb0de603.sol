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
50   function transfer(address _to, uint256 _value) public returns (bool);
51   
52   function approve(address _spender, uint256 _value) public returns (bool);
53 
54   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
55 
56   event Transfer( address indexed from, address indexed to,  uint256 value);
57 
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59   
60   event Burn(address indexed from, uint256 value);
61 }
62 
63 
64 contract StandardToken is ERC20 {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   mapping (address => mapping (address => uint256)) internal allowed;
70 
71 
72   /**
73   * Gets the balance of the specified address.
74   * @param _owner The address to query the the balance of.
75   * @return An uint256 representing the amount owned by the passed address.
76   */
77   function balanceOf(address _owner) public view returns (uint256) {
78     return balances[_owner];
79   }
80 
81   /**
82    *  Function to check the amount of tokens that an owner allowed to a spender.
83    * @param _owner address The address which owns the funds.
84    * @param _spender address The address which will spend the funds.
85    * @return A uint256 specifying the amount of tokens still available for the spender.
86    */
87   function allowance(address _owner, address _spender) public view returns (uint256){
88     return allowed[_owner][_spender];
89   }
90 
91   /**
92   * Transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_value <= balances[msg.sender]);
98     require(_to != address(0));
99 
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   function approve(address _spender, uint256 _value) public returns (bool) {
107     allowed[msg.sender][_spender] = _value;
108     emit Approval(msg.sender, _spender, _value);
109     return true;
110   }
111 
112   /**
113    *  Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121     require(_to != address(0));
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     emit Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * Increase the amount of tokens that an owner allowed to a spender.
132    * approve should be called when allowed[_spender] == 0. To increment
133    * allowed value is better to use this function to avoid 2 calls (and wait until
134    * the first transaction is mined)
135    * @param _spender The address which will spend the funds.
136    * @param _addedValue The amount of tokens to increase the allowance by.
137    */
138   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
139     allowed[msg.sender][_spender] = (
140     allowed[msg.sender][_spender].add(_addedValue));
141     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144 
145   /**
146    *  Decrease the amount of tokens that an owner allowed to a spender.
147    * approve should be called when allowed[_spender] == 0. To decrement
148    * allowed value is better to use this function to avoid 2 calls (and wait until
149    * the first transaction is mined)
150    * @param _spender The address which will spend the funds.
151    * @param _subtractedValue The amount of tokens to decrease the allowance by.
152    */
153   function decreaseApproval(address _spender,  uint256 _subtractedValue) public returns (bool) {
154     uint256 oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue >= oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159     }
160     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163   
164    /**
165      * Destroy tokens
166      *
167      * Remove `_value` tokens from the system irreversibly
168      *
169      * @param _value the amount of money to burn
170      */
171     function burn(uint256 _value) public returns (bool success) {
172         require(balances[msg.sender] >= _value);   
173         balances[msg.sender] = balances[msg.sender].sub(_value);          
174         totalSupply = totalSupply.sub(_value);                      
175         emit Burn(msg.sender, _value);
176         return true;
177     }
178 
179     /**
180      * Destroy tokens from other account
181      *
182      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
183      *
184      * @param _from the address of the sender
185      * @param _value the amount of money to burn
186      */
187     function burnFrom(address _from, uint256 _value) public returns (bool success) {
188         require(balances[_from] >= _value);                
189         require(_value <= allowed[_from][msg.sender]);    
190         balances[_from] = balances[_from].sub(_value);                        
191         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             
192         totalSupply = totalSupply.sub(_value);                              
193         emit Burn(_from, _value);
194         return true;
195     }
196 }
197 
198 contract SCCTokenERC20 is StandardToken {
199     // Public variables of the token
200     string public name = "Smart Cash Coin";
201     string public symbol = "SCC";
202     uint8 constant public decimals = 4;
203     uint256 constant public initialSupply = 50000000;
204 
205     constructor() public {
206         totalSupply = initialSupply * 10 ** uint256(decimals);  
207         balances[msg.sender] = totalSupply;               
208         emit Transfer(address(0), msg.sender, totalSupply);
209     }
210 }