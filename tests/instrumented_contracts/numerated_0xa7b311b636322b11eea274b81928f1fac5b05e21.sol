1 pragma solidity ^0.4.11;
2  
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10  function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   uint256 public totalSupply;
73   function balanceOf(address who) constant public returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) tokenBalances;
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(tokenBalances[msg.sender]>=_value);
94     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
95     tokenBalances[_to] = tokenBalances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) constant public returns (uint256 balance) {
106     return tokenBalances[_owner];
107   }
108 }
109 
110 contract EtherpayCoin is BasicToken,Ownable {
111 
112    using SafeMath for uint256;
113    
114    string public constant name = "Etherpay";
115    string public constant symbol = "EPC";
116    uint256 public constant decimals = 4;
117    uint256 public buyPrice = 111 * 10 ** 12 ;   // per token the price is 2.2222*10^-4 eth, this price is equivalent in wei
118    address public ethStore = 0x933252A4Fd45D12BC0ea4211427EAE934912d002;
119    uint256 public constant INITIAL_SUPPLY = 21000000;
120    event Debug(string message, address addr, uint256 number);
121    event Message(string message);
122     string buyMessage;
123    // fallback function can be used to buy tokens
124    function () public payable {
125     buy(msg.sender);
126    }
127   
128    /**
129    * @dev Contructor that gives msg.sender all of existing tokens.
130    */
131    //TODO: Change the name of the constructor
132     function EtherpayCoin() public {
133         owner = ethStore;
134         totalSupply = INITIAL_SUPPLY;
135         tokenBalances[owner] = INITIAL_SUPPLY * (10 ** uint256(decimals));   //Since we divided the token into 10^18 parts
136     }
137     
138     function buy(address beneficiary) payable public {
139         uint amount = msg.value.div(buyPrice);                    // calculates the amount
140         amount = amount * (10 ** uint256(decimals));
141         require(tokenBalances[owner] >= amount);               // checks if it has enough to sell
142         tokenBalances[beneficiary] = tokenBalances[beneficiary].add(amount);                  // adds the amount to buyer's balance
143         tokenBalances[owner] = tokenBalances[owner].sub(amount);                        // subtracts amount from seller's balance
144         Transfer(owner, beneficiary, amount);               // execute an event reflecting the change
145         ethStore.transfer(msg.value);                       //send the eth to the address where eth should be collected
146         buyMessage = "Thank you for participating in EtherpayCoin ICO";
147         Message(buyMessage);
148     }
149     
150     function getTokenBalance() public view returns (uint256 balance) {
151         balance = tokenBalances[msg.sender].div (10**decimals); // show token balance in full tokens not part
152     }
153  
154     function changeBuyPrice(uint newPrice) public onlyOwner {
155         buyPrice = newPrice;
156     }
157 }