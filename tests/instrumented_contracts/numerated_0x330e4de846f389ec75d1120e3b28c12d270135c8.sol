1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 /**
12  * @title Basic token
13  * @dev Basic version of StandardToken, with no allowances.
14  */
15 contract BasicToken is ERC20Basic {
16   using SafeMath for uint256;
17 
18   mapping(address => uint256) balances;
19 
20   uint256 totalSupply_;
21 
22   /**
23   * @dev total number of tokens in existence
24   */
25   function totalSupply() public view returns (uint256) {
26     return totalSupply_;
27   }
28 
29   /**
30   * @dev transfer token for a specified address
31   * @param _to The address to transfer to.
32   * @param _value The amount to be transferred.
33   */
34   function transfer(address _to, uint256 _value) public returns (bool) {
35     require(_value <= balances[msg.sender]);
36 
37     balances[msg.sender] = balances[msg.sender].sub(_value);
38     balances[_to] = balances[_to].add(_value);
39     emit Transfer(msg.sender, _to, _value);
40     return true;
41   }
42 
43   /**
44   * @dev Gets the balance of the specified address.
45   * @param _owner The address to query the the balance of.
46   * @return An uint256 representing the amount owned by the passed address.
47   */
48   function balanceOf(address _owner) public view returns (uint256) {
49     return balances[_owner];
50   }
51 
52 }
53 
54 contract SwincaToken is BasicToken {
55     
56   struct Booking {
57       address addr;
58       bool isEnabled;
59   }
60 
61   string public constant name = "Swinca"; // solium-disable-line uppercase
62   string public constant symbol = "SWI"; // solium-disable-line uppercase
63   uint8 public constant decimals = 18; // solium-disable-line uppercase
64   
65   address public owner;
66   mapping(address => uint256) balancesBooking;
67   address[] balancesBookingArray;
68 
69   uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
70 
71   /**
72    * @dev Constructor that gives msg.sender all of existing tokens.
73    */
74   constructor() public {
75     totalSupply_ = INITIAL_SUPPLY;
76     balances[msg.sender] = INITIAL_SUPPLY;
77     owner = msg.sender;
78     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
79   }
80   
81   function book(address _to, uint256 _value) public returns (bool) {
82     require(msg.sender == owner);
83 
84     if(balancesBooking[_to]==0){
85         balancesBookingArray.push(_to);
86     }
87     balancesBooking[_to] = balancesBooking[_to].add(_value);
88     return true;
89   }
90   
91   function distributeBooking(uint256 _n) public returns (bool) {
92     require(msg.sender == owner);
93     require(_n <= balancesBookingArray.length);
94     
95     uint256 balancesBookingArrayLength = balancesBookingArray.length;
96     for(uint256 i=balancesBookingArray.length;i>=balancesBookingArrayLength-_n+1;i--){
97         uint256 j = i-1;
98         address _to = balancesBookingArray[j];
99         uint256 _value = balancesBooking[_to];
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         balancesBooking[_to] = 0;
103         balancesBookingArray.length--;
104         emit Transfer(msg.sender, _to, _value);
105     }
106     return true;
107   }
108   
109   function bookingBalanceOf(address _address) public view returns (uint256) {
110     return balancesBooking[_address];
111   }
112   
113   function cancelBooking(address _address) public returns (bool) {
114     require(msg.sender == owner);
115     
116     balancesBooking[_address] = 0;
117     return true;
118   }
119 
120 }
121 library SafeMath {
122 
123   /**
124   * @dev Multiplies two numbers, throws on overflow.
125   */
126   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
127     if (a == 0) {
128       return 0;
129     }
130     c = a * b;
131     assert(c / a == b);
132     return c;
133   }
134 
135   /**
136   * @dev Integer division of two numbers, truncating the quotient.
137   */
138   function div(uint256 a, uint256 b) internal pure returns (uint256) {
139     // assert(b > 0); // Solidity automatically throws when dividing by 0
140     // uint256 c = a / b;
141     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142     return a / b;
143   }
144 
145   /**
146   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
147   */
148   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149     assert(b <= a);
150     return a - b;
151   }
152 
153   /**
154   * @dev Adds two numbers, throws on overflow.
155   */
156   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
157     c = a + b;
158     assert(c >= a);
159     return c;
160   }
161 }