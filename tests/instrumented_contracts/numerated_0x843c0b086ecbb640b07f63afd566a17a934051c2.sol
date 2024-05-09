1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /home/edward/Projects/AXTWeb3/contracts/AXTToken.sol
6 // flattened :  Thursday, 18-Oct-18 09:51:07 UTC
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address _who) public view returns (uint256);
56   function transfer(address _to, uint256 _value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) internal balances;
64 
65   uint256 internal totalSupply_;
66 
67   /**
68   * @dev Total number of tokens in existence
69   */
70   function totalSupply() public view returns (uint256) {
71     return totalSupply_;
72   }
73 
74   /**
75   * @dev Transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) public returns (bool) {
80     require(_value <= balances[msg.sender]);
81     require(_to != address(0));
82 
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     emit Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of.
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public view returns (uint256) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 contract ERC20 is ERC20Basic {
101   function allowance(address _owner, address _spender)
102     public view returns (uint256);
103 
104   function transferFrom(address _from, address _to, uint256 _value)
105     public returns (bool);
106 
107   function approve(address _spender, uint256 _value) public returns (bool);
108   event Approval(
109     address indexed owner,
110     address indexed spender,
111     uint256 value
112   );
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(
127     address _from,
128     address _to,
129     uint256 _value
130   )
131     public
132     returns (bool)
133   {
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136     require(_to != address(0));
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     emit Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     emit Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(
167     address _owner,
168     address _spender
169    )
170     public
171     view
172     returns (uint256)
173   {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _addedValue The amount of tokens to increase the allowance by.
185    */
186   function increaseApproval(
187     address _spender,
188     uint256 _addedValue
189   )
190     public
191     returns (bool)
192   {
193     allowed[msg.sender][_spender] = (
194       allowed[msg.sender][_spender].add(_addedValue));
195     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(
209     address _spender,
210     uint256 _subtractedValue
211   )
212     public
213     returns (bool)
214   {
215     uint256 oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue >= oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 contract AXTToken is StandardToken {
228     using SafeMath for uint256;
229     
230     string public name = "Axtra";
231     string public symbol = "AXT";
232     uint256 public decimals = 18;
233     string  public standard = "AXT v1.1";
234     uint256 public totalSupply = 88888888888 * 10**18;
235     address admin;
236     address saleAddress;
237         
238     constructor () public {
239         admin = msg.sender;        
240         balances[admin] = totalSupply;       
241     }
242     
243     function setSaleAddr(address saleAddr, address owner) external
244     {
245         require(owner == admin, "Not authorized");
246         saleAddress = saleAddr;
247         balances[saleAddress] = totalSupply;
248         balances[admin] = 0;
249     }
250 
251     function deductFromInvestorWallet(address investor, address receiver, uint256 amount) external
252     {
253         require(msg.sender == saleAddress, "Not authorized");
254         require(amount >= 0, "Cannot deduct empty amount");
255         uint256 tokenAmount = amount;
256         balances[investor] = balances[investor].sub(tokenAmount);
257         balances[receiver] = balances[receiver].add(tokenAmount);
258     }
259 
260     function refundUserToken(address user) external
261     {
262         require(msg.sender == saleAddress, "Not authorized");
263         balances[user] = 0;
264     }    
265        
266     function transfer(address _to, uint _value) public returns (bool) {
267         return super.transfer(_to, _value);
268     }
269 
270     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
271         return super.transferFrom(_from, _to, _value);
272     }    
273 }