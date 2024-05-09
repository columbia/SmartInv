1 pragma solidity ^0.4.4;
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
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 
58 /**
59  * @title SafeWallet Coin
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract SafeWalletCoin is ERC20Basic {
63   
64   using SafeMath for uint256;
65   
66   string public name = "SafeWallet Coin";
67   string public symbol = "SWC";
68   uint8 public decimals = 0;
69   uint256 public airDropNum = 1000;
70   uint256 public totalSupply = 100000000;
71   address public owner;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76  
77   //event Burn(address indexed from, uint256 value);
78  
79   function SafeWalletCoin() public {
80 
81     totalSupply_ = totalSupply;
82     owner = msg.sender;
83     balances[msg.sender] = totalSupply;
84   }
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(msg.sender == owner);
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 	
103     balances[msg.sender] = SafeMath.sub(balances[msg.sender],(_value));
104     balances[_to] = SafeMath.add(balances[_to],(_value));
105 
106     return true;
107   }
108   
109   function multyTransfer(address[] arrAddr, uint256[] value) public{
110     require(msg.sender == owner);
111     require(arrAddr.length == value.length);
112     for(uint i = 0; i < arrAddr.length; i++) {
113       transfer(arrAddr[i],value[i]);
114     }
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256 balance) {
123     return balances[_owner];
124   }
125   
126   /**
127   * @dev recycle token for a specified address
128   * @param _user user address.
129   * @param _value The amount to be burnned.
130   */
131   function recycle(address _user,uint256 _value) returns (bool success) {
132 	require(msg.sender == owner);
133     require(balances[_user] >= _value);
134 	require(_value > 0);
135 	balances[msg.sender] = SafeMath.add(balances[msg.sender],(_value));
136 	balances[_user] = SafeMath.sub(balances[_user],(_value));           
137     //Burn(msg.sender, _value);
138     return true;
139     }
140 
141 }