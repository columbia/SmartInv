1 pragma solidity ^0.4.19;
2 
3 //////////////////////////////////////////////////////////////////////
4 /**
5  * BetcoinToken ERC20 token contract was created 2017-12-12 by Betcoin Limited in UK 
6  * Copyright 2017, Betcoin All rights reserved
7  * Betcoin is the registered trademark of Betcoin Limited
8  * http://betcoin.com
9  */
10 
11 //////////////////////////////////////////////////////////////////////
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 //////////////////////////////////////////////////////////////////////
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   uint256 public totalSupply;
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 //////////////////////////////////////////////////////////////////////
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 //////////////////////////////////////////////////////////////////////
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 //////////////////////////////////////////////////////////////////////
108 /**
109  * @title Standard ERC20 token
110  *
111  * @dev Implementation of the basic standard token.
112  * @dev https://github.com/ethereum/EIPs/issues/20
113  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114  */
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130 
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) public view returns (uint256) {
161     return allowed[_owner][_spender];
162   }
163 
164   /**
165    * approve should be called when allowed[_spender] == 0. To increment
166    * allowed value is better to use this function to avoid 2 calls (and wait until
167    * the first transaction is mined)
168    * From MonolithDAO Token.sol
169    */
170   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
177     uint oldValue = allowed[msg.sender][_spender];
178     if (_subtractedValue > oldValue) {
179       allowed[msg.sender][_spender] = 0;
180     } else {
181       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182     }
183     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187 }
188 
189 //////////////////////////////////////////////////////////////////////
190 /**
191  * @title BetcoinToken
192  * @dev ERC20 Token
193  */
194 contract BetcoinToken is StandardToken {
195 
196   string public constant name = "BetcoinToken";
197   string public constant symbol = "BETC";
198   uint8 public constant decimals = 18;
199 
200   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
201 
202   /**
203    * @dev Constructor that gives msg.sender all of existing tokens.
204    */
205   function BetcoinToken() public {
206     totalSupply = INITIAL_SUPPLY;
207     balances[msg.sender] = INITIAL_SUPPLY;
208   }
209 
210 }