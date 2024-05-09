1 pragma solidity 0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   address public coinvest;
11   mapping (address => bool) public admins;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21     coinvest = msg.sender;
22     admins[owner] = true;
23     admins[coinvest] = true;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   modifier coinvestOrOwner() {
35       require(msg.sender == coinvest || msg.sender == owner);
36       _;
37   }
38 
39   modifier onlyAdmin() {
40       require(admins[msg.sender]);
41       _;
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) onlyOwner public {
49     require(newOwner != address(0));
50     emit OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53   
54   /**
55    * @dev Changes the Coinvest wallet that will receive funds from investment contract.
56    * @param _newCoinvest The address of the new wallet.
57   **/
58   function transferCoinvest(address _newCoinvest) 
59     external
60     onlyOwner
61   {
62     require(_newCoinvest != address(0));
63     coinvest = _newCoinvest;
64   }
65 
66   /**
67    * @dev Used to add admins who are allowed to add funds to the investment contract and change gas price.
68    * @param _user The address of the admin to add or remove.
69    * @param _status True to add the user, False to remove the user.
70   **/
71   function alterAdmin(address _user, bool _status)
72     external
73     onlyOwner
74   {
75     require(_user != address(0));
76     require(_user != coinvest);
77     admins[_user] = _status;
78   }
79 
80 }
81 
82 contract ERC20Interface {
83 
84     function totalSupply() public constant returns (uint);
85     function balanceOf(address tokenOwner) public constant returns (uint balance);
86     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
87     function transfer(address to, uint tokens) public returns (bool success);
88     function approve(address spender, uint tokens) public returns (bool success);
89     function transferFrom(address from, address to, uint tokens) public returns (bool success);
90 
91     event Transfer(address indexed from, address indexed to, uint tokens);
92     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
93 
94 }
95 
96 /**
97  * @title SafeMath
98  * @dev Math operations with safety checks that throw on error
99  */
100 library SafeMathLib{
101   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a * b;
103     assert(a == 0 || c / a == b);
104     return c;
105   }
106 
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118   
119   function add(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a + b;
121     assert(c >= a);
122     return c;
123   }
124 }
125 
126 contract UserData is Ownable {
127     using SafeMathLib for uint256;
128 
129     // Contract that is allowed to modify user holdings (investment.sol).
130     address public investmentAddress;
131     
132     // Address => crypto Id => amount of crypto wei held
133     mapping (address => mapping (uint256 => uint256)) public userHoldings;
134 
135     /**
136      * @param _investmentAddress Beginning address of the investment contract that may modify holdings.
137     **/
138     constructor(address _investmentAddress) 
139       public
140     {
141         investmentAddress = _investmentAddress;
142     }
143     
144     /**
145      * @dev Investment contract has permission to modify user's holdings on a buy or sell.
146      * @param _beneficiary The user who is buying or selling tokens.
147      * @param _cryptoIds The IDs of the cryptos being bought and sold.
148      * @param _amounts The amount of each crypto being bought and sold.
149      * @param _buy True if the purchase is a buy, false if it is a sell.
150     **/
151     function modifyHoldings(address _beneficiary, uint256[] _cryptoIds, uint256[] _amounts, bool _buy)
152       external
153     {
154         require(msg.sender == investmentAddress);
155         require(_cryptoIds.length == _amounts.length);
156         
157         for (uint256 i = 0; i < _cryptoIds.length; i++) {
158             if (_buy) {
159                 userHoldings[_beneficiary][_cryptoIds[i]] = userHoldings[_beneficiary][_cryptoIds[i]].add(_amounts[i]);
160             } else {
161                 userHoldings[_beneficiary][_cryptoIds[i]] = userHoldings[_beneficiary][_cryptoIds[i]].sub(_amounts[i]);
162             }
163         }
164     }
165 
166 /** ************************** Constants *********************************** **/
167     
168     /**
169      * @dev Return the holdings of a specific address. Returns dynamic array of all cryptos.
170      *      Start and end is used in case there are a large number of cryptos in total.
171      * @param _beneficiary The address to check balance of.
172      * @param _start The beginning index of the array to return.
173      * @param _end The (inclusive) end of the array to return.
174     **/
175     function returnHoldings(address _beneficiary, uint256 _start, uint256 _end)
176       external
177       view
178     returns (uint256[] memory holdings)
179     {
180         require(_start <= _end);
181         
182         holdings = new uint256[](_end.sub(_start)+1); 
183         for (uint256 i = 0; i < holdings.length; i++) {
184             holdings[i] = userHoldings[_beneficiary][_start+i];
185         }
186         return holdings;
187     }
188     
189 /** ************************** Only Owner ********************************** **/
190     
191     /**
192      * @dev Used to switch out the investment contract address to a new one.
193      * @param _newAddress The address of the new investment contract.
194     **/
195     function changeInvestment(address _newAddress)
196       external
197       onlyOwner
198     {
199         investmentAddress = _newAddress;
200     }
201     
202 /** ************************** Only Coinvest ******************************* **/
203     
204     /**
205      * @dev Allow the owner to take Ether or tokens off of this contract if they are accidentally sent.
206      * @param _tokenContract The address of the token to withdraw (0x0 if Ether).
207     **/
208     function tokenEscape(address _tokenContract)
209       external
210       coinvestOrOwner
211     {
212         if (_tokenContract == address(0)) coinvest.transfer(address(this).balance);
213         else {
214             ERC20Interface lostToken = ERC20Interface(_tokenContract);
215         
216             uint256 stuckTokens = lostToken.balanceOf(address(this));
217             lostToken.transfer(coinvest, stuckTokens);
218         }    
219     }
220     
221 }