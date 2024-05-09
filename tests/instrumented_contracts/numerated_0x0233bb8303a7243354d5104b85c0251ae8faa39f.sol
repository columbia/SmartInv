1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract KolkhaCoin {
46 
47   modifier msgDataSize(uint nVar) {assert(msg.data.length == nVar*32 + 4); _ ;}
48 
49   string public constant name = "Kolkha";
50   string public constant symbol = "KHC";
51   uint public constant decimals = 6;
52   uint public totalSupply;
53 
54   using SafeMath for uint;
55 
56   event Transfer(address indexed _from, address indexed _to, uint _value);
57   event Approved(address indexed _owner, address indexed _spender, uint _value);
58 
59   mapping(address => uint) public balanceOf;
60   mapping(address => mapping(address => uint)) public allowance;
61 
62   function KolkhaCoin(uint initialSupply){
63     balanceOf[msg.sender] = initialSupply;
64     totalSupply = initialSupply;
65   }
66 
67   function transfer(address _to, uint _value) public msgDataSize(2) returns(bool success)
68   {
69     success = false;
70     require(balanceOf[msg.sender] >= _value); //Check if the sender has enough balance
71     require(balanceOf[_to].add(_value) > balanceOf[_to]); //Avoid overflow, and _value=0
72     require(_value > 0); //just to be safe
73 
74     //Perform the transfer
75     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
76     balanceOf[_to] = balanceOf[_to].add(_value);
77 
78     Transfer(msg.sender, _to, _value); //Fire the event
79     return true;
80   }
81 
82   function transferFrom(address _from, address _to, uint _value) public msgDataSize(3) returns (bool success)  {
83     require(allowance[_from][_to] >= _value); //check allowance, from _from to _to
84     require(balanceOf[_from] >= _value); //Check if there's enough coins on the _from account
85     require(balanceOf[_to].add(_value) > balanceOf[_to]); //Avoid overflow, and _value = 0
86     require(_value > 0); //Just in case
87 
88     //Transfer
89     balanceOf[_from] = balanceOf[_from].sub(_value);
90     balanceOf[_to] = balanceOf[_to].add(_value);
91 
92     //Retract _value coins from allowance
93     allowance[_from][_to] = allowance[_from][_to].sub(_value);
94 
95     //Fire the event
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   function approve(address _spender, uint _value) public msgDataSize(2) returns(bool success) {
101     success = false;
102     allowance[msg.sender][_spender] = _value;
103     Approved(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   //Once the block is mined
108   /*uint public constant blockReward = 1e6;
109   function claimBlockReward() {
110     balanceOf[block.coinbase] += blockReward;
111     totalSupply += blockReward;
112   }*/
113 }