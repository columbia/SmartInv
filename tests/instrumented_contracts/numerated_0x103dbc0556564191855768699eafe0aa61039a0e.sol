1 pragma solidity ^0.4.18;
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
27  * @title ERC20 interface
28  * @dev see https://github.com/ethereum/EIPs/issues/20
29  */
30 interface IERC20 {
31   function balanceOf(address _owner) public view returns (uint256);
32   function allowance(address _owner, address _spender) public view returns (uint256);
33   function transfer(address _to, uint256 _value) public returns (bool);
34   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
35   function approve(address _spender, uint256 _value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     if (a == 0) {
48       return 0;
49     }
50     uint256 c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 /**
75  * @title Standard ERC20 token
76  *
77  * @dev Implementation of the basic standard token.
78  * @dev https://github.com/ethereum/EIPs/issues/20
79  */
80 contract GRUToken is IERC20 {
81   using SafeMath for uint256;
82 
83   string public name = 'GRU';
84   string public symbol = 'GRU';
85   uint8 public constant decimals = 8;
86   uint256 public constant decimalFactor = 10**uint256(decimals);
87   uint256 public constant totalSupply = 2000000000*decimalFactor;
88   mapping (address => uint256) balances;
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   event Transfer(address indexed from, address indexed to, uint256 value);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 
94   /**
95   * @dev Constructor for GRUToken creation
96   * @dev Assigns the totalSupply to the GRUToken contract
97   */
98   function GRUToken() public {
99     balances[msg.sender] = totalSupply;
100     Transfer(address(0), msg.sender, totalSupply);
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112   /**
113    * @dev Function to check the amount of tokens that an owner allowed to a spender.
114    * @param _owner address The address which owns the funds.
115    * @param _spender address The address which will spend the funds.
116    * @return A uint256 specifying the amount of tokens still available for the spender.
117    */
118   function allowance(address _owner, address _spender) public view returns (uint256) {
119     return allowed[_owner][_spender];
120   }
121 
122   /**
123   * @dev transfer token for a specified address
124   * @param _to The address to transfer to.
125   * @param _value The amount to be transferred.
126   */
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= balances[msg.sender]);
130     // SafeMath.sub will throw if there is not enough balance.
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171 }