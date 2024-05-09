1 pragma solidity ^0.4.18;
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
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     emit OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract HasNoEther is Ownable {
70 
71   /**
72   * @dev Constructor that rejects incoming Ether
73   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
74   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
75   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
76   * we could use assembly to access msg.value.
77   */
78   function HasNoEther() public payable {
79     require(msg.value == 0);
80   }
81 
82   /**
83    * @dev Disallows direct send by settings a default function without the `payable` flag.
84    */
85   function() external {
86   }
87 
88   /**
89    * @dev Transfer all Ether held by the contract to the owner.
90    */
91   function reclaimEther() external onlyOwner {
92     address myaddress = this;
93     assert(owner.send(myaddress.balance));
94   }
95 }
96 
97 contract ERC20Basic {
98   uint256 public totalSupply;
99   function getaddress0() public view returns (address);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   function getaddress0() public view returns (address){
111     return address(0);
112   }
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[msg.sender]);
122 
123     // SafeMath.sub will throw if there is not enough balance.
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     emit Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public view returns (uint256 balance) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 contract ERC20 is ERC20Basic {
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143 }
144 
145 contract StandardToken is ERC20, BasicToken {
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156 
157     balances[_from] = balances[_from].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163 }
164 
165 contract BurnableToken is StandardToken {
166 
167     event Burn(address indexed burner, uint256 value);
168 
169     /**
170      * @dev Burns a specific amount of tokens.
171      * @param _value The amount of token to be burned.
172      */
173     function burn(uint256 _value) public {
174         require(_value > 0);
175         require(_value <= balances[msg.sender]);
176         // no need to require value <= totalSupply, since that would imply the
177         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
178 
179         address burner = msg.sender;
180         balances[burner] = balances[burner].sub(_value);
181         totalSupply = totalSupply.sub(_value);
182         emit Burn(burner, _value);
183     }
184 }
185 
186 contract CoinmakeToken is BurnableToken, HasNoEther {
187 
188     string public constant name = "Coinmake Token";
189 
190     string public constant symbol = "CT";
191 
192     uint8 public constant decimals = 18;
193 
194     uint256 constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
195 
196     /**
197     * @dev Constructor that gives msg.sender all of existing tokens.
198     */
199     function CoinmakeToken() public {
200         totalSupply = INITIAL_SUPPLY;
201         balances[msg.sender] = INITIAL_SUPPLY;
202         emit Transfer(address(0), msg.sender, totalSupply);
203     }
204 
205     /**
206     * @dev transfer token for a specified address
207     * @param _to The address to transfer to.
208     * @param _value The amount to be transferred.
209     */
210     function transfer(address _to, uint256 _value) public returns (bool) {
211         return super.transfer(_to, _value);
212     }
213 
214     /**
215     * @dev Transfer tokens from one address to another
216     * @param _from address The address which you want to send tokens from
217     * @param _to address The address which you want to transfer to
218     * @param _value uint256 the amount of tokens to be transferred
219     */
220     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221         return super.transferFrom(_from, _to, _value);
222     }
223 
224     function multiTransfer(address[] recipients, uint256[] amounts) public {
225         require(recipients.length == amounts.length);
226         for (uint i = 0; i < recipients.length; i++) {
227             transfer(recipients[i], amounts[i]);
228         }
229     }
230 }