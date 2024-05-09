1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 {
38   uint256 public totalSupply;
39   function balanceOf(address who) public view returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   function allowance(address owner, address spender) public view returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 /**
49  * @title Standard ERC20 token
50  *
51  * @dev Implementation of the basic standard token.
52  * @dev https://github.com/ethereum/EIPs/issues/20
53  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
129 contract ArtToken is StandardToken {
130   string public constant name = "Art Coin";
131   string public constant symbol = "ARTC";
132   uint8 public constant decimals = 18;
133 
134   function ArtToken() public {
135     totalSupply = 1000000000000000000000000000;
136     balances[msg.sender] = totalSupply;
137   }
138 }