1 pragma solidity ^0.4.20;
2 
3 interface ERC20 {
4     function totalSupply() constant returns (uint _totalSupply);
5     function balanceOf(address _owner) constant returns (uint balance);
6     function transfer(address _to, uint _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) returns (bool success);
8     function approve(address _spender, uint _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 
57 contract StandardToken is ERC20 {
58 
59     using SafeMath for uint256;
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     uint256 public totalSupply;
63 
64    function transfer(address _to, uint256 _value) public returns (bool) {
65         require(_to != address(0));
66         require(_value <= balances[msg.sender]);
67 
68         // SafeMath.sub will throw if there is not enough balance.
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76         require(_to != address(0));
77         require(_value <= balances[_from]);
78         require(_value <= allowed[_from][msg.sender]);
79 
80         balances[_from] = balances[_from].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function balanceOf(address _owner) public constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
98         return allowed[_owner][_spender];
99     }
100 
101     function totalSupply() public constant returns (uint _totalSupply) {
102         _totalSupply = totalSupply;
103     }
104 
105 
106 }
107 contract Ownable {
108   address public owner;
109 
110 
111   event OwnershipRenounced(address indexed previousOwner);
112   event OwnershipTransferred(
113     address indexed previousOwner,
114     address indexed newOwner
115   );
116 
117 
118   /**
119    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
120    * account.
121    */
122   constructor() public {
123     owner = msg.sender;
124   }
125 
126   /**
127    * @dev Throws if called by any account other than the owner.
128    */
129   modifier onlyOwner() {
130     require(msg.sender == owner);
131     _;
132   }
133 
134   /**
135    * @dev Allows the current owner to transfer control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function transferOwnership(address newOwner) public onlyOwner {
139     require(newOwner != address(0));
140     emit OwnershipTransferred(owner, newOwner);
141     owner = newOwner;
142   }
143 
144   /**
145    * @dev Allows the current owner to relinquish control of the contract.
146    */
147   function renounceOwnership() public onlyOwner {
148     emit OwnershipRenounced(owner);
149     owner = address(0);
150   }
151 }
152 
153 
154 contract Token is StandardToken, Ownable {
155 
156     string public name ="LYQD";
157     uint8 public decimals = 18;
158     string public symbol = "LYQD";
159     uint256 public initialSupply = 100000000;
160 
161     function Token(address _receiver) public {
162         require(_receiver != address(0));
163         totalSupply = initialSupply * 10 ** uint256(decimals);
164         balances[_receiver] = totalSupply;               // Give the receiver all initial tokens
165 
166     }
167     
168   event Mint(address indexed to, uint256 amount);
169   event MintFinished();
170 
171   bool public mintingFinished = false;
172 
173 
174   modifier canMint() {
175     require(!mintingFinished);
176     _;
177   }
178 
179   modifier hasMintPermission() {
180     require(msg.sender == owner);
181     _;
182   }
183 
184   /**
185    * @dev Function to mint tokens
186    * @param _to The address that will receive the minted tokens.
187    * @param _amount The amount of tokens to mint.
188    * @return A boolean that indicates if the operation was successful.
189    */
190   function mint(
191     address _to,
192     uint256 _amount
193   )
194     hasMintPermission
195     canMint
196     public
197     returns (bool)
198   {
199     totalSupply = totalSupply.add(_amount);
200     balances[_to] = balances[_to].add(_amount);
201     emit Mint(_to, _amount);
202     emit Transfer(address(0), _to, _amount);
203     return true;
204   }
205 
206   /**
207    * @dev Function to stop minting new tokens.
208    * @return True if the operation was successful.
209    */
210   function finishMinting() onlyOwner canMint public returns (bool) {
211     mintingFinished = true;
212     emit MintFinished();
213     return true;
214   }
215   
216    event Burn(address indexed burner, uint256 value);
217 
218   /**
219    * @dev Burns a specific amount of tokens.
220    * @param _value The amount of token to be burned.
221    */
222   function burn(uint256 _value) public {
223     _burn(msg.sender, _value);
224   }
225 
226   function _burn(address _who, uint256 _value) internal {
227     require(_value <= balances[_who]);
228     // no need to require value <= totalSupply, since that would imply the
229     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
230 
231     balances[_who] = balances[_who].sub(_value);
232     totalSupply = totalSupply.sub(_value);
233     emit Burn(_who, _value);
234     emit Transfer(_who, address(0), _value);
235   }
236 
237 
238 }