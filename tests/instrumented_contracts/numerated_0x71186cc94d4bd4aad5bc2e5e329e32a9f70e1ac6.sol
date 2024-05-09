1 pragma solidity ^0.4.20;
2 
3 // OFFICIAL PRE-ICO TOKENS SALE FOR PROJECT:iVeryone(VRY) https://ivery.one/
4 // VRY tokens will be automatically sent to buyer's wallet after buyer send ETH to contract address
5 // Pre-ICO token price: 1 ETH = 1000 VRY
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * @title ERC20 interface
37  */
38 contract ERC20 {
39   uint256 public totalSupply;
40   function balanceOf(address who) public view returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   function allowance(address owner, address spender) public view returns (uint256);
43   function transferFrom(address from, address to, uint256 value) public returns (bool);
44   function approve(address spender, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 /**
50  * @title Standard ERC20 token
51  *
52  * @dev Implementation of the basic standard token.
53  * @dev https://github.com/ethereum/EIPs/issues/20
54  */
55 contract StandardToken is ERC20 {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59   mapping (address => mapping (address => uint256)) allowed;
60 
61   /**
62    * @dev Gets the balance of the specified address.
63    * @param _owner The address to query the the balance of.
64    * @return An uint256 representing the amount owned by the passed address.
65    */
66   function balanceOf(address _owner) public view returns (uint256 balance) {
67     return balances[_owner];
68   }
69 
70   /**
71    * @dev transfer token for a specified address
72    * @param _to The address to transfer to.
73    * @param _value The amount to be transferred.
74    */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77 
78     // SafeMath.sub will throw if there is not enough balance.
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86    * @dev Transfer tokens from one address to another
87    * @param _from address The address which you want to send tokens from
88    * @param _to address The address which you want to transfer to
89    * @param _value uint256 the amount of tokens to be transferred
90    */
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92     var _allowance = allowed[_from][msg.sender];
93     require(_to != address(0));
94     require (_value <= _allowance);
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = _allowance.sub(_value);
98     Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   /**
103    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
104    * @param _spender The address which will spend the funds.
105    * @param _value The amount of tokens to be spent.
106    */
107   function approve(address _spender, uint256 _value) public returns (bool) {
108     // To change the approve amount you first have to reduce the addresses`
109     //  allowance to zero by calling `approve(_spender, 0)` if it is not
110     //  already 0 to mitigate the race condition described here:
111     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifying the amount of tokens still available for the spender.
123    */
124   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
125     return allowed[_owner][_spender];
126   }
127 }
128 
129 contract VRYCoin is StandardToken {
130   string public constant name = "VRY";
131   string public constant symbol = "VRY";
132   uint8 public constant decimals = 18;
133   
134   address private fundsWallet;
135 
136   function VRYCoin() public {
137     totalSupply = 1000000000000000000000000000000;
138     balances[msg.sender] = totalSupply;
139     fundsWallet = msg.sender;
140   }
141   
142   function() payable{   
143         fundsWallet.transfer(msg.value);
144         uint256 unitsOneEthCanBuy = 1000;
145         uint256 amount = msg.value * unitsOneEthCanBuy;
146         if (balances[fundsWallet] < amount) {
147             return;
148         }
149         balances[fundsWallet] = balances[fundsWallet] - amount;
150         balances[msg.sender] = balances[msg.sender] + amount;
151         Transfer(fundsWallet, msg.sender, amount); 
152 
153                                        
154     }
155 }