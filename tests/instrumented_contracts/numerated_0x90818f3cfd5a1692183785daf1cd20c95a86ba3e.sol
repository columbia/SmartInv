1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 
6 pragma solidity ^0.4.24;
7 
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 
50 
51 /**
52  * @title Pausable
53  * @dev Base contract which allows children to implement an emergency stop mechanism.
54  */
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is not paused.
64    */
65   modifier whenNotPaused() {
66     require(!paused);
67     _;
68   }
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is paused.
72    */
73   modifier whenPaused() {
74     require(paused);
75     _;
76   }
77 
78   /**
79    * @dev called by the owner to pause, triggers stopped state
80    */
81   function pause() onlyOwner whenNotPaused public {
82     paused = true;
83     emit Pause();
84   }
85 
86   /**
87    * @dev called by the owner to unpause, returns to normal state
88    */
89   function unpause() onlyOwner whenPaused public {
90     paused = false;
91     emit Unpause();
92   }
93 }
94 
95 pragma solidity ^0.4.24;
96 
97 pragma solidity ^0.4.24;
98 
99 // ----------------------------------------------------------------------------
100 contract ERC20Interface {
101 
102     // ERC Token Standard #223 Interface
103     // https://github.com/ethereum/EIPs/issues/223
104 
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108 
109     function transfer(address _to, uint _value, bytes _data) external returns (bool success);
110 
111     // approveAndCall
112     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
113 
114     // ERC Token Standard #20 Interface
115     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
116 
117 
118     function totalSupply() public constant returns (uint);
119     function balanceOf(address tokenOwner) public constant returns (uint balance);
120     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
121     function transfer(address to, uint tokens) public returns (bool success);
122     function approve(address spender, uint tokens) public returns (bool success);
123     function transferFrom(address from, address to, uint tokens) public returns (bool success);
124     event Transfer(address indexed from, address indexed to, uint tokens);
125     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
126 
127     // bulk operations
128     function transferBulk(address[] to, uint[] tokens) public;
129     function approveBulk(address[] spender, uint[] tokens) public;
130 }
131 
132 pragma solidity ^0.4.24;
133 
134 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
135 contract PluginInterface
136 {
137     /// @dev simply a boolean to indicate this is the contract we expect to be
138     function isPluginInterface() public pure returns (bool);
139 
140     function onRemove() public;
141 
142     /// @dev Begins new feature.
143     /// @param _cutieId - ID of token to auction, sender must be owner.
144     /// @param _parameter - arbitrary parameter
145     /// @param _seller - Old owner, if not the message sender
146     function run(
147         uint40 _cutieId,
148         uint256 _parameter,
149         address _seller
150     ) 
151     public
152     payable;
153 
154     /// @dev Begins new feature, approved and signed by COO.
155     /// @param _cutieId - ID of token to auction, sender must be owner.
156     /// @param _parameter - arbitrary parameter
157     function runSigned(
158         uint40 _cutieId,
159         uint256 _parameter,
160         address _owner
161     )
162     external
163     payable;
164 
165     function withdraw() public;
166 }
167 
168 
169 contract CuteCoinInterface is ERC20Interface
170 {
171     function mint(address target, uint256 mintedAmount) public;
172     function mintBulk(address[] target, uint256[] mintedAmount) external;
173     function burn(uint256 amount) external;
174 }
175 
176 
177 /// @dev Receives payments for payd features from players for Blockchain Cuties
178 /// @author https://BlockChainArchitect.io
179 contract CuteCoinShop is Pausable
180 {
181     CuteCoinInterface token;
182 
183     event CuteCoinShopBuy(address sender, uint value, bytes extraData);
184 
185     function setToken(CuteCoinInterface _token)
186         external
187         onlyOwner
188     {
189         token = _token;
190     }
191 
192     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData)
193         external
194         whenNotPaused
195     {
196         require(_tokenContract == address(token));
197         require(token.transferFrom(_sender, address(this), _value));
198         token.burn(_value);
199 
200         emit CuteCoinShopBuy(_sender, _value, _extraData);
201     }
202 
203     // @dev Transfers to _withdrawToAddress all tokens controlled by
204     // contract _tokenContract.
205     function withdrawTokenFromBalance(ERC20Interface _tokenContract, address _withdrawToAddress)
206         external
207         onlyOwner
208     {
209         uint256 balance = _tokenContract.balanceOf(address(this));
210         _tokenContract.transfer(_withdrawToAddress, balance);
211     }
212 }