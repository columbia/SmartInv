1 pragma solidity ^0.4.23;
2 
3 pragma solidity ^0.4.23;
4 
5 
6 pragma solidity ^0.4.23;
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
95 pragma solidity ^0.4.23;
96 
97 pragma solidity ^0.4.23;
98 
99 // ----------------------------------------------------------------------------
100 contract ERC20 {
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
132 
133 contract CuteCoinInterface is ERC20
134 {
135     function mint(address target, uint256 mintedAmount) public;
136     function mintBulk(address[] target, uint256[] mintedAmount) external;
137     function burn(uint256 amount) external;
138 }
139 
140 
141 /// @dev Receives payments for payd features from players for Blockchain Cuties
142 /// @author https://BlockChainArchitect.io
143 contract CuteCoinShop is Pausable
144 {
145     CuteCoinInterface token;
146 
147     mapping (address=>bool) operatorAddress;
148 
149     function addOperator(address _newOperator) public onlyOwner {
150         require(_newOperator != address(0));
151 
152         operatorAddress[_newOperator] = true;
153     }
154 
155     function removeOperator(address _newOperator) public onlyOwner {
156         delete(operatorAddress[_newOperator]);
157     }
158 
159     function isOperator(address _address) view public returns (bool) {
160         return operatorAddress[_address];
161     }
162 
163     modifier onlyOperator() {
164         require(isOperator(msg.sender) || msg.sender == owner);
165         _;
166     }
167 
168 
169     event CuteCoinShopBuy(address sender, uint value, bytes extraData);
170 
171     function setToken(CuteCoinInterface _token)
172         external
173         onlyOwner
174     {
175         token = _token;
176     }
177 
178     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData)
179         external
180         whenNotPaused
181     {
182         require(_tokenContract == address(token));
183         require(token.transferFrom(_sender, address(this), _value));
184 
185         emit CuteCoinShopBuy(_sender, _value, _extraData);
186     }
187 
188     // @dev Transfers to _withdrawToAddress all tokens controlled by
189     // contract _tokenContract.
190     function withdrawAllTokensFromBalance(ERC20 _tokenContract, address _withdrawToAddress) external onlyOperator
191     {
192         uint256 balance = _tokenContract.balanceOf(address(this));
193         _tokenContract.transfer(_withdrawToAddress, balance);
194     }
195 
196     // @dev Transfers to _withdrawToAddress all tokens controlled by
197     // contract _tokenContract.
198     function withdrawTokenFromBalance(ERC20 _tokenContract, address _withdrawToAddress, uint amount) external onlyOperator
199     {
200         _tokenContract.transfer(_withdrawToAddress, amount);
201     }
202 }