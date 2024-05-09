1 pragma solidity ^0.5.1;
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
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20 {
33   event Transfer(address indexed from, address indexed to, uint256 value);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35   
36   uint256 public totalSupply;
37   
38   function balanceOf(address who) public view returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address spender, uint256 value) public returns (bool);
42   function allowance(address owner, address spender) public view returns (uint256);
43 }
44 
45 contract StandardToken is ERC20 {
46   using SafeMath for uint256;
47 
48   mapping (address => uint256) balances;
49 
50   mapping (address => mapping (address => uint256)) internal allowed;
51 
52 
53   function balanceOf(address _owner) public view returns (uint256 balance) {
54     return balances[_owner];
55   }
56   
57   function transfer(address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59     require(_value <= balances[msg.sender]);
60 
61     // SafeMath.sub will throw if there is not enough balance.
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     emit Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[_from]);
71     require(_value <= allowed[_from][msg.sender]);
72 
73     balances[_from] = balances[_from].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
76     emit Transfer(_from, _to, _value);
77     return true;
78   }
79 
80   /**
81    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
82    *
83    * Beware that changing an allowance with this method brings the risk that someone may use both the old
84    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
85    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
86    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87    * @param _spender The address which will spend the funds.
88    * @param _value The amount of tokens to be spent.
89    */
90   function approve(address _spender, uint256 _value) public returns (bool) {
91     allowed[msg.sender][_spender] = _value;
92     emit Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   /**
97    * @dev Function to check the amount of tokens that an owner allowed to a spender.
98    * @param _owner address The address which owns the funds.
99    * @param _spender address The address which will spend the funds.
100    * @return A uint256 specifying the amount of tokens still available for the spender.
101    */
102   function allowance(address _owner, address _spender) public view returns (uint256) {
103     return allowed[_owner][_spender];
104   }
105 
106   /**
107    * approve should be called when allowed[_spender] == 0. To increment
108    * allowed value is better to use this function to avoid 2 calls (and wait until
109    * the first transaction is mined)
110    * From MonolithDAO Token.sol
111    */
112   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
113     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
119     uint oldValue = allowed[msg.sender][_spender];
120     if (_subtractedValue > oldValue) {
121       allowed[msg.sender][_spender] = 0;
122     } else {
123       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124     }
125     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 
129 }
130 
131 
132 contract Ownable {
133   address public owner;
134 
135   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137   modifier onlyOwner() {
138     require(msg.sender == owner);
139     _;
140   }
141 
142   function transferOwnership(address newOwner) public onlyOwner {
143     require(newOwner != address(0));
144     emit OwnershipTransferred(owner, newOwner);
145     owner = newOwner;
146   }
147   
148 }
149 
150 contract Pausable is Ownable {
151   event PausePublic(bool newState);
152   event PauseOwnerAdmin(bool newState);
153 
154   bool public pausedPublic = true;
155   bool public pausedOwnerAdmin = false;
156 
157   address public admin;
158 
159   modifier whenNotPaused() {
160     if(pausedPublic) {
161       if(!pausedOwnerAdmin) {
162         require(msg.sender == admin || msg.sender == owner);
163       } else {
164         revert();
165       }
166     }
167     _;
168   }
169 
170   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
171     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
172 
173     pausedPublic = newPausedPublic;
174     pausedOwnerAdmin = newPausedOwnerAdmin;
175 
176     emit PausePublic(newPausedPublic);
177     emit PauseOwnerAdmin(newPausedOwnerAdmin);
178   }
179   
180 }
181 
182 contract PausableToken is StandardToken, Pausable {
183 
184   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
185     return super.transfer(_to, _value);
186   }
187 
188   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
189     return super.transferFrom(_from, _to, _value);
190   }
191 
192   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
193     return super.approve(_spender, _value);
194   }
195 
196   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
197     return super.increaseApproval(_spender, _addedValue);
198   }
199 
200   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
201     return super.decreaseApproval(_spender, _subtractedValue);
202   }
203 }
204 
205 
206 contract BangkaToken is PausableToken {
207     string  public  constant name = "Bangka Token";
208     string  public  constant symbol = "BGT";
209     uint8   public  constant decimals = 18;
210 
211     modifier validDestination( address to )
212     {
213         require(to != address(0x0));
214         require(to != address(this));
215         _;
216     }
217 
218     constructor ( address _admin, address _owner, uint _totalTokenAmount ) public
219     {
220         admin = _admin;
221         owner = _owner;
222 
223         totalSupply = _totalTokenAmount;
224         balances[_owner] = _totalTokenAmount;
225         
226         emit Transfer(address(0x0), _owner, _totalTokenAmount);
227     }
228 
229     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) 
230     {
231         return super.transfer(_to, _value);
232     }
233 
234     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) 
235     {
236         return super.transferFrom(_from, _to, _value);
237     }
238 
239     event Burn(address indexed _burner, uint _value);
240 
241     function burn(uint _value) public returns (bool)
242     {
243         balances[msg.sender] = balances[msg.sender].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         emit Burn(msg.sender, _value);
246         emit Transfer(msg.sender, address(0x0), _value);
247         return true;
248     }
249 
250     // save some gas by making only one contract call
251     function burnFrom(address _from, uint256 _value) public returns (bool) 
252     {
253         assert( transferFrom( _from, msg.sender, _value ) );
254         return burn(_value);
255     }
256 
257     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner public {
258         // owner can drain tokens that are sent here by mistake
259         token.transfer( owner, amount );
260     }
261 
262     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
263 
264     function changeAdmin(address newAdmin) onlyOwner public {
265         // owner can re-assign the admin
266         emit AdminTransferred(admin, newAdmin);
267         admin = newAdmin;
268     }
269 }