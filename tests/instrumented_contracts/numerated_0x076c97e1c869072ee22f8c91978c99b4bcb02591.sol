1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) returns (bool) {
21     require(_to != address(0));
22 
23     // In case of insufficient funds, SafeMath#sub throws exception.
24     balances[msg.sender] = balances[msg.sender].sub(_value);
25     balances[_to] = balances[_to].add(_value);
26     Transfer(msg.sender, _to, _value);
27     return true;
28   }
29 
30   /**
31   * @dev Gets the balance of the specified address.
32   * @param _owner The address to query the the balance of.
33   * @return An uint256 representing the amount owned by the passed address.
34   */
35   function balanceOf(address _owner) constant returns (uint256 balance) {
36     return balances[_owner];
37   }
38 
39 }
40 
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender) constant returns (uint256);
43   function transferFrom(address from, address to, uint256 value) returns (bool);
44   function approve(address spender, uint256 value) returns (bool);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 library SafeMath {
49 
50   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal constant returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 
61 }
62 
63 contract StandardToken is ERC20, BasicToken {
64 
65   mapping (address => mapping (address => uint256)) allowed;
66 
67 
68   /**
69    * @dev Transfer tokens from one address to another
70    * @param _from address The address which you want to send tokens from
71    * @param _to address The address which you want to transfer to
72    * @param _value uint256 the amount of tokens to be transferred
73    */
74   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
75     require(_to != address(0));
76 
77     var _allowance = allowed[_from][msg.sender];
78 
79     // In case of insufficient funds, SafeMath#sub throws exception.
80 
81     balances[_from] = balances[_from].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     allowed[_from][msg.sender] = _allowance.sub(_value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   /**
89    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
90    * @param _spender The address which will spend the funds.
91    * @param _value The amount of tokens to be spent.
92    */
93   function approve(address _spender, uint256 _value) returns (bool) {
94 
95     // To change the approve amount you first have to reduce the addresses`
96     //  allowance to zero by calling `approve(_spender, 0)` if it is not
97     //  already 0 to mitigate the race condition described here:
98     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
99     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
100 
101     allowed[msg.sender][_spender] = _value;
102     Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106   /**
107    * @dev Function to check the amount of tokens that an owner allowed to a spender.
108    * @param _owner address The address which owns the funds.
109    * @param _spender address The address which will spend the funds.
110    * @return A uint256 specifying the amount of tokens still available for the spender.
111    */
112   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113     return allowed[_owner][_spender];
114   }
115 
116   /**
117    * approve should be called when allowed[_spender] == 0. To increment
118    * allowed value is better to use this function to avoid 2 calls (and wait until
119    * the first transaction is mined)
120    * From MonolithDAO Token.sol
121    */
122   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
123     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
124     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
129     uint oldValue = allowed[msg.sender][_spender];
130     if (_subtractedValue > oldValue) {
131       allowed[msg.sender][_spender] = 0;
132     } else {
133       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
134     }
135     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139 }
140 
141 contract CommerceBlockToken is StandardToken {
142 
143     string public name = "CommerceBlock Token";
144     string public symbol = "CBT";
145     uint256 public decimals = 18;
146 
147     uint256 public supplyExponent = 9;
148     uint256 public totalSupply = (10 ** supplyExponent) * (10 ** decimals);
149 
150     function CommerceBlockToken(address company) {
151       balances[company] = totalSupply;
152     }
153 
154 }