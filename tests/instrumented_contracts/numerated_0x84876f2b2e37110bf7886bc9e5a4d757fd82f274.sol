1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a); 
35     return a - b; 
36   } 
37   
38   function add(uint256 a, uint256 b) internal constant returns (uint256) { 
39     uint256 c = a + b; assert(c >= a);
40     return c;
41   }
42 
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53   string message;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64     
65     // SafeMath.sub will throw if there is not enough balance. 
66     balances[msg.sender] = balances[msg.sender].sub(_value); 
67     balances[_to] = balances[_to].add(_value); 
68     Transfer(msg.sender, _to, _value); 
69     return true; 
70   }
71 
72   /** 
73    * @dev Gets the balance of the specified address. 
74    * @param _owner The address to query the the balance of. 
75    * @return An uint256 representing the amount owned by the passed address. 
76    */ 
77   function balanceOf(address _owner) public constant returns (uint256 balance) { 
78     return balances[_owner]; 
79   } 
80 }
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable is BasicToken {
88   address public owner;
89 
90   /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94   function Ownable() public {
95     owner = msg.sender;
96     totalSupply = 10000000000*10**2;
97     balances[owner] = balances[owner].add(totalSupply);
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108 }
109 
110 contract BinaCoin is BasicToken, Ownable {
111     
112     uint256 order;
113     
114     string public constant name = "BinaCoin";
115     
116     string public constant symbol = "BCO";
117     
118     uint32 public constant decimals = 2;
119     
120     function transferToken(address _from, address _to, uint256 _value, uint256 _order) onlyOwner public returns (bool) {
121     
122         order = _order;
123         
124         require(_from != address(0));
125     	require(_to != address(0));
126     	require(_value <= balances[_from]);
127     
128     	balances[_from] = balances[_from].sub(_value);
129     	balances[_to] = balances[_to].add(_value);
130     
131     	Transfer(_from, _to, _value);
132     	return true;
133     }
134     
135 }