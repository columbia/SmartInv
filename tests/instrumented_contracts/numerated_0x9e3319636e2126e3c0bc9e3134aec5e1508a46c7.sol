1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title UTN-P ERC20 token by Universa Blockchain.
5  *
6  * @dev Based on OpenZeppelin framework.
7  *
8  * Features:
9  *
10  * * ERC20 compatibility, with token details as properties.
11  * * total supply: 4997891952 (initially given to the contract author).
12  * * decimals: 18
13  * * BurnableToken: some addresses are allowed to burn tokens.
14  * * “third-party smart contract trading protection”: transferFrom/approve/allowance methods are present but do nothing.
15  * * TimeLock: implemented externally (in TokenTimelock contract), some tokens are time-locked for 3 months.
16  * * Bulk send: implemented externally (in BulkSender contract), some tokens are time-locked for 3 months.
17  */
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
60     owner = msg.sender;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 contract ERC20Basic {
86   uint256 public totalSupply;
87   function balanceOf(address who) public view returns (uint256);
88   function transfer(address to, uint256 value) public returns (bool);
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 contract BurnableToken is BasicToken {
125 
126     event Burn(address indexed burner, uint256 value);
127 
128     /**
129      * @dev Burns a specific amount of tokens.
130      * @param _value The amount of token to be burned.
131      */
132     function burn(uint256 _value) public {
133         require(_value <= balances[msg.sender]);
134         // no need to require value <= totalSupply, since that would imply the
135         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
136 
137         address burner = msg.sender;
138         balances[burner] = balances[burner].sub(_value);
139         totalSupply = totalSupply.sub(_value);
140         Burn(burner, _value);
141     }
142 }
143 
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public view returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 contract UTNP is BasicToken, BurnableToken, ERC20, Ownable {
152 
153     string public constant name = "UTN-P: Universa Token";
154     string public constant symbol = "UTNP";
155     uint8 public constant decimals = 18;
156     string public constant version = "1.0";
157 
158     uint256 constant INITIAL_SUPPLY_UTN = 4997891952;
159 
160     /// @dev whether an address is permitted to perform burn operations.
161     mapping(address => bool) public isBurner;
162 
163     /**
164      * @dev Constructor that:
165      * * gives all of existing tokens to the message sender;
166      * * initializes the burners (also adding the message sender);
167      */
168     function UTNP() public {
169         totalSupply = INITIAL_SUPPLY_UTN * (10 ** uint256(decimals));
170         balances[msg.sender] = totalSupply;
171 
172         isBurner[msg.sender] = true;
173     }
174 
175     /**
176      * @dev Standard method to comply with ERC20 interface;
177      * prevents some Ethereum-contract-initiated operations.
178      */
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180         return false;
181     }
182 
183     /**
184      * @dev Standard method to comply with ERC20 interface;
185      * prevents some Ethereum-contract-initiated operations.
186      */
187     function approve(address _spender, uint256 _value) public returns (bool) {
188         return false;
189     }
190 
191     /**
192      * @dev Standard method to comply with ERC20 interface;
193      * prevents some Ethereum-contract-initiated operations.
194      */
195     function allowance(address _owner, address _spender) public view returns (uint256) {
196         return 0;
197     }
198 
199     /**
200      * @dev Grant or remove burn permissions. Only owner can do that!
201      */
202     function grantBurner(address _burner, bool _value) public onlyOwner {
203         isBurner[_burner] = _value;
204     }
205 
206     /**
207      * @dev Throws if called by any account other than the burner.
208      */
209     modifier onlyBurner() {
210         require(isBurner[msg.sender]);
211         _;
212     }
213 
214     /**
215      * @dev Burns a specific amount of tokens.
216      * Only an address listed in `isBurner` can do this.
217      * @param _value The amount of token to be burned.
218      */
219     function burn(uint256 _value) public onlyBurner {
220         super.burn(_value);
221     }
222 }