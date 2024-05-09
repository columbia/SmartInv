1 pragma solidity ^0.4.11;
2 
3 contract ERC20 {
4   function totalSupply() constant returns (uint totalSupply);
5   function balanceOf(address _owner) constant returns (uint balance);
6   function transfer(address _to, uint _value) returns (bool success);
7   function transferFrom(address _from, address _to, uint _value) returns (bool success);
8   function approve(address _spender, uint _value) returns (bool success);
9   function allowance(address _owner, address _spender) constant returns (uint remaining);
10   event Transfer(address indexed _from, address indexed _to, uint _value);
11   event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal constant returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  * @title UbiTok.io Reward Token.
42  *
43  * @dev Implementation of the basic standard token, with a fixed supply initially owned by creator.
44  * @dev https://github.com/ethereum/EIPs/issues/20
45  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
46  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
47  */
48 contract UbiRewardToken is ERC20 {
49 
50   using SafeMath for uint256;
51 
52   string public name = "UbiTok.io Reward Token";
53   string public symbol = "UBI";
54   uint256 public decimals = 18;
55   uint256 public INITIAL_SUPPLY = 12000000 ether;
56 
57   mapping(address => uint256) balances;
58   mapping (address => mapping (address => uint256)) allowed;
59 
60   function UbiRewardToken() {
61     balances[msg.sender] = INITIAL_SUPPLY;
62   }
63   
64   function totalSupply() public constant returns (uint totalSupply) {
65     return INITIAL_SUPPLY;
66   }
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of. 
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89   /**
90    * @dev Transfer tokens from one address to another
91    * @param _from address The address which you want to send tokens from
92    * @param _to address The address which you want to transfer to
93    * @param _value uint256 the amout of tokens to be transfered
94    */
95   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
96     var _allowance = allowed[_from][msg.sender];
97     balances[_to] = balances[_to].add(_value);
98     balances[_from] = balances[_from].sub(_value);
99     allowed[_from][msg.sender] = _allowance.sub(_value);
100     Transfer(_from, _to, _value);
101     return true;
102   }
103 
104   /**
105    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
106    * Beware that changing an allowance with this method brings the risk that someone may use both the old
107    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
108    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
109    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110    * Also potentially surprising: the approver need not own the funds at the time of approval.
111    * @param _spender The address which will spend the funds.
112    * @param _value The amount of tokens to be spent.
113    */
114   function approve(address _spender, uint256 _value) returns (bool) {
115     allowed[msg.sender][_spender] = _value;
116     Approval(msg.sender, _spender, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Function to check the amount of tokens that an owner allowed to a spender.
122    * @param _owner address The address which owns the funds.
123    * @param _spender address The address which will spend the funds.
124    * @return A uint256 specifing the amount of tokens still avaible for the spender.
125    */
126   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127     return allowed[_owner][_spender];
128   }
129 
130 }