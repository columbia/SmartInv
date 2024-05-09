1 pragma solidity ^0.4.16;
2 
3 /*
4 Copyright (c) 2016 Smart Contract Solutions, Inc.
5 
6 Permission is hereby granted, free of charge, to any person obtaining
7 a copy of this software and associated documentation files (the
8 "Software"), to deal in the Software without restriction, including
9 without limitation the rights to use, copy, modify, merge, publish,
10 distribute, sublicense, and/or sell copies of the Software, and to
11 permit persons to whom the Software is furnished to do so, subject to
12 the following conditions:
13 
14 The above copyright notice and this permission notice shall be included
15 in all copies or substantial portions of the Software.
16 
17 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
18 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
19 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
20 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
21 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
22 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
23 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
24 */
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 interface IERC20 {
64   function balanceOf(address _owner) public view returns (uint256);
65   function allowance(address _owner, address _spender) public view returns (uint256);
66   function transfer(address _to, uint256 _value) public returns (bool);
67   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
68   function approve(address _spender, uint256 _value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 /**
74  * @title Standard ERC20 token
75  *
76  * @dev Implementation of the basic standard token.
77  * @dev https://github.com/ethereum/EIPs/issues/20
78  */
79 contract EvoToken is IERC20 {
80   using SafeMath for uint256;
81 
82   // Evo Token parameters
83   string public name = 'Evolution';
84   string public symbol = 'EVO';
85   uint8 public constant decimals = 18;
86   uint256 public constant decimalFactor = 10 ** uint256(decimals);
87   uint256 public constant totalSupply = 5000000000 * decimalFactor;
88   mapping (address => uint256) balances;
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   event Transfer(address indexed from, address indexed to, uint256 value);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 
94   /**
95   * @dev Constructor for Evo creation
96   * @dev Assigns the totalSupply to the EvoDistribution contract
97   */
98   function EvoToken(address _evoDistributionContractAddress) public {
99     require(_evoDistributionContractAddress != address(0));
100     balances[_evoDistributionContractAddress] = totalSupply;
101     Transfer(address(0), _evoDistributionContractAddress, totalSupply);
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256 balance) {
110     return balances[_owner];
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifying the amount of tokens still available for the spender.
118    */
119   function allowance(address _owner, address _spender) public view returns (uint256) {
120     return allowed[_owner][_spender];
121   }
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[msg.sender]);
131 
132     // SafeMath.sub will throw if there is not enough balance.
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   /**
210    * @dev Don't accept eth
211    */
212   function () public payable {
213       revert();
214   }
215 }