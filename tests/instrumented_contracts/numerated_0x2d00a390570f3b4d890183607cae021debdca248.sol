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
97  * @title Bank
98  * @dev Bank holds all user funds so Investment contract can easily be replaced.
99 **/
100 contract Bank is Ownable {
101     
102     address public investmentAddr;      // Investment contract address used to allow withdrawals
103     address public coinToken;           // COIN token address.
104     address public cashToken;           // CASH token address.
105 
106     /**
107      * @param _coinToken address of the Coinvest token.
108      * @param _cashToken address of the CASH token.
109     **/
110     constructor(address _coinToken, address _cashToken)
111       public
112     {
113         coinToken = _coinToken;
114         cashToken = _cashToken;
115     }
116 
117 /** ****************************** Only Investment ****************************** **/
118     
119     /**
120      * @dev Investment contract needs to be able to disburse funds to users.
121      * @param _to Address to send funds to.
122      * @param _value Amount of funds to send to _to.
123      * @param _isCoin True if the crypto to be transferred is COIN, false if it is CASH.
124     **/
125     function transfer(address _to, uint256 _value, bool _isCoin)
126       external
127     returns (bool success)
128     {
129         require(msg.sender == investmentAddr);
130 
131         ERC20Interface token;
132         if (_isCoin) token = ERC20Interface(coinToken);
133         else token = ERC20Interface(cashToken);
134 
135         require(token.transfer(_to, _value));
136         return true;
137     }
138     
139 /** ******************************* Only Owner ********************************** **/
140     
141     /**
142      * @dev Owner may change the investment address when contracts are being updated.
143      * @param _newInvestment The address of the new investment contract.
144     **/
145     function changeInvestment(address _newInvestment)
146       external
147       onlyOwner
148     {
149         require(_newInvestment != address(0));
150         investmentAddr = _newInvestment;
151     }
152     
153 /** ****************************** Only Coinvest ******************************* **/
154 
155     /**
156      * @dev Allow the owner to take non-COIN Ether or tokens off of this contract if they are accidentally sent.
157      * @param _tokenContract The address of the token to withdraw (0x0 if Ether)--cannot be COIN.
158     **/
159     function tokenEscape(address _tokenContract)
160       external
161       coinvestOrOwner
162     {
163         require(_tokenContract != coinToken && _tokenContract != cashToken);
164         if (_tokenContract == address(0)) coinvest.transfer(address(this).balance);
165         else {
166             ERC20Interface lostToken = ERC20Interface(_tokenContract);
167         
168             uint256 stuckTokens = lostToken.balanceOf(address(this));
169             lostToken.transfer(coinvest, stuckTokens);
170         }    
171     }
172 
173 }