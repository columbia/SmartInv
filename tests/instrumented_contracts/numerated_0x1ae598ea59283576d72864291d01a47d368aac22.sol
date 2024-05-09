1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract ERC20Basic {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57     
58   mapping (address => uint256) balances;
59 
60   uint256 totalSupply_;
61   
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0x0));
74     require(_value <= balances[msg.sender]);
75 
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of. 
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 }
91 
92 contract ERC20 is BasicToken {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96 }
97 
98 contract StandardToken is ERC20 {
99   mapping (address => mapping (address => uint256)) allowed;
100 
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0x0));
103     require(_value <= balances[msg.sender]);
104     require(_value <= allowed[_from][msg.sender]);
105 
106     balances[_to] = balances[_to].add(_value);
107     balances[_from] = balances[_from].sub(_value);
108     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109 
110     emit Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
116    * @param _spender The address which will spend the funds.
117    * @param _value The amount of tokens to be spent.
118    */
119   function approve(address _spender, uint256 _value) public returns (bool) {
120    /** require((_value == 0) || (allowed[msg.sender][_spender] == 0)); **/
121     allowed[msg.sender][_spender] = _value;
122     return true;
123   }
124 
125   /**
126    * @dev Function to check the amount of tokens that an owner allowed to a spender.
127    * @param _owner address The address which owns the funds.
128    * @param _spender address The address which will spend the funds.
129    * @return A uint256 specifing the amount of tokens still avaible for the spender.
130    */
131   function allowance(address _owner, address _spender) public view returns (uint256) {
132     return allowed[_owner][_spender];
133   }
134 }
135 
136 contract ETCVToken is StandardToken {
137     string public name = "Ethereum Classic Vision";
138     string public symbol = "ETCV";
139     uint8 public decimals = 18;
140       
141     uint256 INITIAL_SUPPLY = 400000000000000000000000000;
142     bool isNotInit = true;
143     uint public price = 50;
144     address owner = 0x103B4e7f316a058a3299e601dff7e16079B72501;
145     
146     function initContract() external {
147         require(isNotInit);
148         totalSupply_ = INITIAL_SUPPLY;
149         balances[address(owner)] = totalSupply_;
150         emit Transfer(address(this), address(owner), INITIAL_SUPPLY);
151         isNotInit = false;
152     }
153     
154     function () payable external {
155         require(msg.value > 0);
156         uint tokens = msg.value.mul(price);
157         balances[msg.sender] = balances[msg.sender].add(tokens);
158         emit Transfer(address(this), msg.sender, tokens);
159         address(owner).transfer(msg.value);
160     }
161 }