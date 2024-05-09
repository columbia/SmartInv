1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See:  tested
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
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Trazair is Ownable{
107 
108 using SafeMath for uint256;
109 
110   // function totalSupply() public view returns (uint256);
111   // function balanceOf(address who) public view returns (uint256);
112   // function transfer(address to, uint256 value) public payable returns (bool);
113 event Transfer(address indexed from, address indexed to, uint256 value);  
114 
115  mapping(address => uint256) balances;
116 
117  string public name = "Trazair";
118  uint256 totalSupply_;
119  uint256 public RATE = 1 ether;
120  string public symbol = "TRZA";                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
121  uint8 public decimals = 5;
122  uint public INITIAL_SUPPLY = 50000000000 * 10 ** uint256(decimals);
123  uint public totalSold_ = 0;
124  bool public FirstTimeTransfer = false;
125  
126  constructor() public {
127    totalSupply_ = INITIAL_SUPPLY;
128    balances[msg.sender] = INITIAL_SUPPLY;
129  }
130 
131   /**
132   * @dev total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138 
139   
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   
146   
147  function airdrop_byadmin(address _to, uint256 _value)  onlyOwner public  returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[msg.sender]);
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     totalSold_ = totalSold_.add(_value);
153     totalSupply_ = totalSupply_.sub(_value);
154     // emit Transfer(msg.sender, _to, _value);
155     return true;
156   }
157   
158 
159   function transfer(address _to, uint256 _value)   public  returns (bool) {
160     require(_to != address(0));
161     require(_value <= balances[msg.sender]);
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167  
168   modifier canTrans () {
169     require(!FirstTimeTransfer);
170     _;
171   }
172    
173   function transfer_byFirstOwner(address _to, uint256 _value) onlyOwner canTrans public returns (bool) {
174    require(_to != address(0));
175     require(_value <= balances[msg.sender]);
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     FirstTimeTransfer = true;
179     return true; 
180     
181   }
182  
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public view returns (uint256) {
189     return balances[_owner];
190   }
191 
192   function balanceEth(address _owner) public view returns (uint256) {
193     return _owner.balance;
194    }
195 
196  
197 }