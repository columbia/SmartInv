1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56 
57   address public owner;
58   
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner || msg.sender == 0x06F7caDAf2659413C335c1af22831307F88CBD21 );  // Address of the MAIN ACCOUNT FOR UPDATE AND EMERGENCY REASONS
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     owner = newOwner;
82     
83   }
84 }
85 
86 
87 contract Club1VIT is Ownable {
88 
89 using SafeMath for uint256;
90 
91   string public name = "Club1 VIT";
92   string public symbol = "VIT";
93   uint8 public decimals = 0;
94   uint256 public initialSupply  = 1;
95   
96   
97   
98   mapping(address => uint256) balances;
99   mapping (address => mapping (address => uint256)) internal allowed;
100 
101    event Transfer(address indexed from, address indexed to);
102 
103   /**
104   * @dev total number of tokens in existence
105   */
106   function totalSupply() public view returns (uint256) {
107     return initialSupply;
108   }
109 
110  
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public constant returns (uint256 balance) {
117     return balances[_owner];
118   }
119   
120   
121   /**
122    * @dev Transfer tokens from one address to another
123    * @param _from address The address which you want to send tokens from
124    * @param _to address The address which you want to transfer to
125    * onlyThe owner of the contract can do it. 
126    */
127   function transferFrom(address _from, address _to) public onlyOwner returns (bool) {
128     require(_to != address(0));
129     require(balances[_from] == 1);
130 
131     balances[_from] = 0;
132     balances[_to] = 1;
133     allowed[_from][msg.sender] = 0;
134     
135     Transfer(_from, _to);
136     return true;
137   }
138 
139   function transfer(address _to, uint256 _value) public returns (bool) {
140     _value = 1;
141     require(balances[msg.sender] == 1);
142     require(_to == owner);
143     if (!owner.call(bytes4(keccak256("resetToken()")))) revert();
144     
145     balances[msg.sender] = 0;
146     balances[_to] = 1;
147     Transfer(msg.sender, _to);
148     
149     return true;
150     
151   
152 }
153 
154 function Club1VIT() public {
155     
156     balances[msg.sender] = initialSupply;                // Give the creator all initial tokens
157   }
158   
159 
160 }