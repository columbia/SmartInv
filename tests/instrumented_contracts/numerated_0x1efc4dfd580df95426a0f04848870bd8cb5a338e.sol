1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function balanceOf(address _owner) public view returns (uint256);
9   function allowance(address _owner, address _spender) public view returns (uint256);
10   function transfer(address _to, uint256 _value) public returns (bool);
11   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
12   function approve(address _spender, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /*
18 Copyright (c) 2016 Smart Contract Solutions, Inc.
19 
20 Permission is hereby granted, free of charge, to any person obtaining
21 a copy of this software and associated documentation files (the
22 "Software"), to deal in the Software without restriction, including
23 without limitation the rights to use, copy, modify, merge, publish,
24 distribute, sublicense, and/or sell copies of the Software, and to
25 permit persons to whom the Software is furnished to do so, subject to
26 the following conditions:
27 
28 The above copyright notice and this permission notice shall be included
29 in all copies or substantial portions of the Software.
30 
31 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
32 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
33 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
34 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
35 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
36 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
37 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
38 */
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     if (a == 0) {
47       return 0;
48     }
49     uint256 c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60 
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 /**
74  * @title Standard ERC20 token
75  *
76  * @dev Implementation of the basic standard token.
77  * @dev https://github.com/ethereum/EIPs/issues/20
78  */
79 contract AcademyToken is IERC20 {
80   using SafeMath for uint256;
81 
82   // Poly Token parameters
83   string public name = 'Academy';
84   string public symbol = 'ACAD';
85   uint8 public constant decimals = 18;
86   uint256 public constant decimalFactor = 10 ** (uint256(decimals) - 4);
87   uint256 public constant totalSupply = 1856413689375 * decimalFactor;
88   mapping (address => uint256) balances;
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   event Transfer(address indexed from, address indexed to, uint256 value);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 
94   /**
95   * @dev Constructor for Poly creation
96   * @dev Assigns the totalSupply to the PolyDistribution contract
97   */
98   function AcademyToken(address _academyDistributionContractAddress) public {
99     require(_academyDistributionContractAddress != address(0));
100     balances[_academyDistributionContractAddress] = totalSupply;
101     Transfer(address(0), _academyDistributionContractAddress, totalSupply);
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
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }