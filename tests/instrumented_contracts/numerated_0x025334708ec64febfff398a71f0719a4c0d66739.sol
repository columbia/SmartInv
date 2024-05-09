1 pragma  solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable{
50   address public owner;
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   constructor() public {
58       owner = msg.sender;
59   }
60     
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68  
69     /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) onlyOwner public {
74     require(newOwner != address(0));
75     emit OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78     
79 }
80 
81 library Locklist {
82   
83   struct List {
84     mapping(address => bool) registry;
85   }
86   
87   function add(List storage list, address _addr)
88     internal
89   {
90     list.registry[_addr] = true;
91   }
92 
93   function remove(List storage list, address _addr)
94     internal
95   {
96     list.registry[_addr] = false;
97   }
98 
99   function check(List storage list, address _addr)
100     view
101     internal
102     returns (bool)
103   {
104     return list.registry[_addr];
105   }
106 }
107 
108 
109 
110 contract Locklisted  {
111 
112   Locklist.List private _list;
113   
114   modifier onlyLocklisted() {
115     require(Locklist.check(_list, msg.sender) == true);
116     _;
117   }
118 
119   event AddressAdded(address _addr);
120   event AddressRemoved(address _addr);
121   
122   function LocklistedAddress()
123   public
124   {
125     Locklist.add(_list, msg.sender);
126   }
127 
128   function LocklistAddressenable(address _addr)
129     public
130   {
131     Locklist.add(_list, _addr);
132     emit AddressAdded(_addr);
133   }
134 
135   function LocklistAddressdisable(address _addr)
136     public
137   {
138     Locklist.remove(_list, _addr);
139    emit AddressRemoved(_addr);
140   }
141   
142   function LocklistAddressisListed(address _addr)
143   public
144   view
145   returns (bool)
146   {
147       return Locklist.check(_list, _addr);
148   }
149 }
150 
151 contract VTEXP is Ownable,Locklisted {
152  
153   event Mint(address indexed to, uint256 amount);
154   event MintFinished();
155 
156   event Transfer(address indexed from, address indexed to, uint256 value);
157   using SafeMath for uint256;
158   string public constant name = "VTEX Promo Token";
159   string public constant symbol = "VTEXP";
160   uint8 public constant decimals = 5;  // 18 is the most common number of decimal places
161   bool public mintingFinished = false;
162   uint256 public totalSupply;
163   mapping(address => uint256) balances;
164 
165   modifier canMint() {
166     require(!mintingFinished);
167     _;
168   }
169  
170   /**
171   * @dev Function to mint tokens
172   * @param _to The address that will receive the minted tokens.
173   * @param _amount The amount of tokens to mint.
174   * @return A boolean that indicates if the operation was successful.
175   */
176   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
177     require(!LocklistAddressisListed(_to));
178     totalSupply = totalSupply.add(_amount);
179     require(totalSupply <= 10000000000000);
180     balances[_to] = balances[_to].add(_amount);
181     emit  Mint(_to, _amount);
182     emit Transfer(address(0), _to, _amount);
183 
184     return true;
185   }
186 
187   /**
188   * @dev Function to stop minting new tokens.
189   * @return True if the operation was successful.
190   */
191   function finishMinting() onlyOwner canMint public returns (bool) {
192     mintingFinished = true;
193     emit MintFinished();
194     return true;
195   }
196  
197   function transfer(address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= totalSupply);
200     require(!LocklistAddressisListed(_to));
201       balances[_to] = balances[_to].add(_value);
202       totalSupply = totalSupply.sub(_value);
203       balances[msg.sender] = balances[msg.sender].sub(_value);
204       emit Transfer(msg.sender, _to, _value);
205       return true;
206   }
207  
208  
209   function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
210     require(!LocklistAddressisListed(_to));
211     require(_to != address(0));
212     require(_value <= balances[_from]);
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     emit Transfer(_from, _to, _value);
216     return true;
217   }
218  
219  
220  
221 
222 
223   function balanceOf(address _owner) public constant returns (uint256 balance) {
224     return balances[_owner];
225   }
226 
227   function balanceEth(address _owner) public constant returns (uint256 balance) {
228     return _owner.balance;
229   }
230     
231 
232 }