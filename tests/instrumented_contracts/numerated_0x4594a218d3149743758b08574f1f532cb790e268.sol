1 pragma  solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable{
50   address public owner;
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   constructor() public {
58       owner = msg.sender;
59   } 
60     
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68   
69     /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) onlyOwner public {
74     require(newOwner != address(0));
75     emit OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78     
79 }
80 
81 contract VTEXP is Ownable {
82   
83   event Mint(address indexed to, uint256 amount);
84   event MintFinished();
85 
86   event Transfer(address indexed from, address indexed to, uint256 value);
87   using SafeMath for uint256;
88   string public constant name = "VTEX Promo Token";
89   string public constant symbol = "VTEXP";
90   uint8 public constant decimals = 5;  // 18 is the most common number of decimal places
91   bool public mintingFinished = false;
92   uint256 public totalSupply;
93   mapping(address => uint256) balances;
94 
95   modifier canMint() {
96     require(!mintingFinished);
97     _;
98   }
99   
100   /**
101   * @dev Function to mint tokens
102   * @param _to The address that will receive the minted tokens.
103   * @param _amount The amount of tokens to mint.
104   * @return A boolean that indicates if the operation was successful.
105   */
106   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
107 
108     totalSupply = totalSupply.add(_amount);
109     require(totalSupply <= 10000000000000);
110     balances[_to] = balances[_to].add(_amount);
111     emit  Mint(_to, _amount);
112     emit Transfer(address(0), _to, _amount);
113 
114     return true;
115   }
116 
117   /**
118   * @dev Function to stop minting new tokens.
119   * @return True if the operation was successful.
120   */
121   function finishMinting() onlyOwner canMint public returns (bool) {
122     mintingFinished = true;
123     emit MintFinished();
124     return true;
125   }
126  
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= totalSupply);
130 
131       balances[_to] = balances[_to].add(_value);
132       totalSupply = totalSupply.sub(_value);
133       balances[msg.sender] = balances[msg.sender].sub(_value);
134       emit Transfer(msg.sender, _to, _value);
135       return true;
136   }
137 
138   function balanceOf(address _owner) public constant returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142   function balanceEth(address _owner) public constant returns (uint256 balance) {
143     return _owner.balance;
144   }
145     
146 
147 }