1 pragma solidity ^0.4.24;
2 
3 // Create SafeMath Library
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a / b;
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 // Contract owner permissions granted only to initial sender
29 contract Ownable {
30   address public owner;
31 
32  constructor() public {
33     owner = msg.sender;
34   }
35 
36 // Any call to the contract not from the creator's account will be thrown.   
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42 // Allows the current owner to transfer control of the contract to a new owner.
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));      
45     owner = newOwner;
46   }
47 
48 }
49 
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public constant returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76 
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     emit Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of. 
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 
94 contract StandardToken is ERC20, BasicToken {
95 
96   mapping (address => mapping (address => uint256)) allowed;
97 
98   /**
99    * @dev Transfer tokens from one address to another
100    * @param _from address The address which you want to send tokens from
101    * @param _to address The address which you want to transfer to
102    * @param _value uint256 the amount of tokens to be transferred
103    */
104   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106 
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     emit Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) public returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     emit Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
138     return allowed[_owner][_spender];
139   }
140   
141   function increaseApproval (address _spender, uint _addedValue) public
142     returns (bool success) {
143     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
144     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148   function decreaseApproval (address _spender, uint _subtractedValue) public 
149     returns (bool success) {
150     uint oldValue = allowed[msg.sender][_spender];
151     if (_subtractedValue > oldValue) {
152       allowed[msg.sender][_spender] = 0;
153     } else {
154       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
155     }
156     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160 }
161 
162 contract BurnableToken is StandardToken {
163 
164 // Invokes burn function
165     function burn(uint _value)
166         public
167     {
168         require(_value > 0);
169 
170         address burner = msg.sender;
171         balances[burner] = balances[burner].sub(_value);
172         totalSupply = totalSupply.sub(_value);
173         emit Burn(burner, _value);
174     }
175 
176     event Burn(address indexed burner, uint indexed value);
177 }
178 
179 contract MintableToken is StandardToken, Ownable {
180   event Mint(address indexed to, uint256 amount);
181   event MintFinished();
182 
183   bool public mintingFinished = false;
184 
185 
186   modifier canMint() {
187     require(!mintingFinished);
188     _;
189   }
190 
191   /**
192    * @dev Function to mint tokens
193    * @param _to The address that will receive the minted tokens.
194    * @param _amount The amount of tokens to mint.
195    * @return A boolean that indicates if the operation was successful.
196    */
197   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
198     totalSupply = totalSupply.add(_amount);
199     balances[_to] = balances[_to].add(_amount);
200     emit Mint(_to, _amount);
201     emit Transfer(0x0, _to, _amount);
202     return true;
203   }
204 
205 // Stop minting function
206   function finishMinting() public onlyOwner returns (bool) {
207     mintingFinished = true;
208     emit MintFinished();
209     return true;
210   }
211 }
212 
213 contract TokenRecipient {
214 
215     function tokenFallback() pure internal returns (bool) {}
216 
217 }
218 
219 contract CustomToken is MintableToken, BurnableToken {
220 
221     string public constant name = "Credits";
222     string public constant symbol = "CREDS";
223     uint8 public constant decimals = 18;
224 
225     constructor() public {
226 
227     }
228 
229     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230         bool result = super.transferFrom(_from, _to, _value);
231         return result;
232     }
233 
234     mapping (address => bool) stopReceive;
235 
236     function setStopReceive(bool stop) public {
237         stopReceive[msg.sender] = stop;
238     }
239 
240     function getStopReceive() constant public returns (bool) {
241         return stopReceive[msg.sender];
242     }
243 
244     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
245         bool result = super.mint(_to, _amount);
246         return result;
247     }
248 
249     function burn(uint256 _value) public {
250         super.burn(_value);
251     }
252 
253     function transferAndCall(address _recipient, uint256 _amount) public {
254         require(_recipient != address(0));
255         require(_amount <= balances[msg.sender]);
256 
257         balances[msg.sender] = balances[msg.sender].sub(_amount);
258         balances[_recipient] = balances[_recipient].add(_amount);
259 
260         emit Transfer(msg.sender, _recipient, _amount);
261     }
262 }