1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SKP-T ERC20 token by Sleekplay.
5  *
6  * @dev Based on OpenZeppelin framework.
7  *
8  * Features:
9  *
10  * * ERC20 compatibility, with token details as properties.
11  * * total supply: 6400000000 (initially given to the contract author).
12  * * decimals: 18
13  * * BurnableToken: some addresses are allowed to burn tokens.
14  * * “third-party smart contract trading protection”: transferFrom/approve/allowance methods are present but do nothing.
15  * * TimeLock: implemented externally (in TokenTimelock contract)
16  */
17 
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() public {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     emit OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract ERC20Basic {
85   uint256 public totalSupply;
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104 
105     // SafeMath.sub will throw if there is not enough balance.
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256 balance) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 contract BurnableToken is BasicToken {
124 
125     event Burn(address indexed burner, uint256 value);
126 
127     /**
128      * @dev Burns a specific amount of tokens.
129      * @param _value The amount of token to be burned.
130      */
131     function burn(uint256 _value) public {
132         require(_value <= balances[msg.sender]);
133         // no need to require value <= totalSupply, since that would imply the
134         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
135 
136         address burner = msg.sender;
137         balances[burner] = balances[burner].sub(_value);
138         totalSupply = totalSupply.sub(_value);
139         emit Burn(burner, _value);
140     }
141 }
142 
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender) public view returns (uint256);
145   function transferFrom(address from, address to, uint256 value) public returns (bool);
146   function approve(address spender, uint256 value) public returns (bool);
147   event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 contract SKPT is BasicToken, BurnableToken, ERC20, Ownable {
151 
152     string public constant name = "SKP-T: Sleekplay Token";
153     string public constant symbol = "SKPT";
154     uint8 public constant decimals = 18;
155     string public constant version = "1.0";
156 
157     uint256 constant INITIAL_SUPPLY_SKPT = 6400000000;
158 
159     /// @dev whether an address is permitted to perform burn operations.
160     mapping(address => bool) public isBurner;
161 
162     /**
163      * @dev Constructor that:
164      * * gives all of existing tokens to the message sender;
165      * * initializes the burners (also adding the message sender);
166      */
167     function SKPT() public {
168         totalSupply = INITIAL_SUPPLY_SKPT * (10 ** uint256(decimals));
169         balances[msg.sender] = totalSupply;
170 
171         isBurner[msg.sender] = true;
172     }
173 
174     /**
175      * @dev Standard method to comply with ERC20 interface;
176      * prevents some Ethereum-contract-initiated operations.
177      */
178     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179         return false;
180     }
181 
182     /**
183      * @dev Standard method to comply with ERC20 interface;
184      * prevents some Ethereum-contract-initiated operations.
185      */
186     function approve(address _spender, uint256 _value) public returns (bool) {
187         return false;
188     }
189 
190     /**
191      * @dev Standard method to comply with ERC20 interface;
192      * prevents some Ethereum-contract-initiated operations.
193      */
194     function allowance(address _owner, address _spender) public view returns (uint256) {
195         return 0;
196     }
197 
198     /**
199      * @dev Grant or remove burn permissions. Only owner can do that!
200      */
201     function grantBurner(address _burner, bool _value) public onlyOwner {
202         isBurner[_burner] = _value;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the burner.
207      */
208     modifier onlyBurner() {
209         require(isBurner[msg.sender]);
210         _;
211     }
212 
213     /**
214      * @dev Burns a specific amount of tokens.
215      * Only an address listed in `isBurner` can do this.
216      * @param _value The amount of token to be burned.
217      */
218     function burn(uint256 _value) public onlyBurner {
219         super.burn(_value);
220     }
221     
222 }