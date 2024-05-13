1 1 /**
2 2  *Submitted for verification at Etherscan.io on 2018-05-09
3 3 */
4 
5 4 pragma solidity ^0.4.21;
6 
7 
8 5 /**
9 6  * @title SafeMath
10 7  * @dev Math operations with safety checks that throw on error
11 8  */
12 9 library SafeMath {
13 
14 10   /**
15 11   * @dev Multiplies two numbers, throws on overflow.
16 12   */
17 13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18 14     if (a == 0) {
19 15       return 0;
20 16     }
21 17     uint256 c = a * b;
22 18     assert(c / a == b);
23 19     return c;
24 20   }
25 
26 21   /**
27 22   * @dev Integer division of two numbers, truncating the quotient.
28 23   */
29 24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30 25     // assert(b > 0); // Solidity automatically throws when dividing by 0
31 26     // uint256 c = a / b;
32 27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 28     return a / b;
34 29   }
35 
36 30   /**
37 31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38 32   */
39 33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40 34     assert(b <= a);
41 35     return a - b;
42 36   }
43 
44 37   /**
45 38   * @dev Adds two numbers, throws on overflow.
46 39   */
47 40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48 41     uint256 c = a + b;
49 42     assert(c >= a);
50 43     return c;
51 44   }
52 45 }
53 
54 46 /**
55 47  * @title ERC20Basic
56 48  * @dev Simpler version of ERC20 interface
57 49  * @dev see https://github.com/ethereum/EIPs/issues/179
58 50  */
59 51 contract ERC20Basic {
60 52   function totalSupply() public view returns (uint256);
61 53   function balanceOf(address who) public view returns (uint256);
62 54   function transfer(address to, uint256 value) public returns (bool);
63 55   event Transfer(address indexed from, address indexed to, uint256 value);
64 56 }
65 
66 57 /**
67 58  * @title ERC20 interface
68 59  * @dev see https://github.com/ethereum/EIPs/issues/20
69 60  */
70 61 contract ERC20 is ERC20Basic {
71 62   function allowance(address owner, address spender) public view returns (uint256);
72 63   function transferFrom(address from, address to, uint256 value) public returns (bool);
73 64   function approve(address spender, uint256 value) public returns (bool);
74 65   event Approval(address indexed owner, address indexed spender, uint256 value);
75 66 }
76 
77 67 /**
78 68  * @title Basic token
79 69  * @dev Basic version of StandardToken, with no allowances.
80 70  */
81 71 contract BasicToken is ERC20Basic {
82 72   using SafeMath for uint256;
83 
84 73   mapping(address => uint256) balances;
85 
86 74   uint256 totalSupply_;
87 
88 75   /**
89 76   * @dev total number of tokens in existence
90 77   */
91 78   function totalSupply() public view returns (uint256) {
92 79     return totalSupply_;
93 80   }
94 
95 81   /**
96 82   * @dev transfer token for a specified address
97 83   * @param _to The address to transfer to.
98 84   * @param _value The amount to be transferred.
99 85   */
100 86   function transfer(address _to, uint256 _value) public returns (bool) {
101 87     require(_to != address(0));
102 88     require(_value <= balances[msg.sender]);
103 
104 89     balances[msg.sender] = balances[msg.sender].sub(_value);
105 90     balances[_to] = balances[_to].add(_value);
106 91     emit Transfer(msg.sender, _to, _value);
107 92     return true;
108 93   }
109 
110 94   /**
111 95   * @dev Gets the balance of the specified address.
112 96   * @param _owner The address to query the the balance of.
113 97   * @return An uint256 representing the amount owned by the passed address.
114 98   */
115 99   function balanceOf(address _owner) public view returns (uint256 balance) {
116 100     return balances[_owner];
117 101   }
118 
119 102 }
120 
121 103 /**
122 104  * @title Standard ERC20 token
123 105  *
124 106  * @dev Implementation of the basic standard token.
125 107  * @dev https://github.com/ethereum/EIPs/issues/20
126 108  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127 109  */
128 110 contract StandardToken is ERC20, BasicToken {
129 
130 111   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133 112   /**
134 113    * @dev Transfer tokens from one address to another
135 114    * @param _from address The address which you want to send tokens from
136 115    * @param _to address The address which you want to transfer to
137 116    * @param _value uint256 the amount of tokens to be transferred
138 117    */
139 118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140 119     require(_to != address(0));
141 120     require(_value <= balances[_from]);
142 121     require(_value <= allowed[_from][msg.sender]);
143 
144 122     balances[_from] = balances[_from].sub(_value);
145 123     balances[_to] = balances[_to].add(_value);
146 124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147 125     emit Transfer(_from, _to, _value);
148 126     return true;
149 127   }
150 
151 128   /**
152 129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153 130    *
154 131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155 132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156 133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157 134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158 135    * @param _spender The address which will spend the funds.
159 136    * @param _value The amount of tokens to be spent.
160 137    */
161 138   function approve(address _spender, uint256 _value) public returns (bool) {
162 139     allowed[msg.sender][_spender] = _value;
163 140     emit Approval(msg.sender, _spender, _value);
164 141     return true;
165 142   }
166 
167 143   /**
168 144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169 145    * @param _owner address The address which owns the funds.
170 146    * @param _spender address The address which will spend the funds.
171 147    * @return A uint256 specifying the amount of tokens still available for the spender.
172 148    */
173 149   function allowance(address _owner, address _spender) public view returns (uint256) {
174 150     return allowed[_owner][_spender];
175 151   }
176 
177 152   /**
178 153    * @dev Increase the amount of tokens that an owner allowed to a spender.
179 154    *
180 155    * approve should be called when allowed[_spender] == 0. To increment
181 156    * allowed value is better to use this function to avoid 2 calls (and wait until
182 157    * the first transaction is mined)
183 158    * From MonolithDAO Token.sol
184 159    * @param _spender The address which will spend the funds.
185 160    * @param _addedValue The amount of tokens to increase the allowance by.
186 161    */
187 162   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188 163     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189 164     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190 165     return true;
191 166   }
192 
193 167   /**
194 168    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195 169    *
196 170    * approve should be called when allowed[_spender] == 0. To decrement
197 171    * allowed value is better to use this function to avoid 2 calls (and wait until
198 172    * the first transaction is mined)
199 173    * From MonolithDAO Token.sol
200 174    * @param _spender The address which will spend the funds.
201 175    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202 176    */
203 177   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204 178     uint oldValue = allowed[msg.sender][_spender];
205 179     if (_subtractedValue > oldValue) {
206 180       allowed[msg.sender][_spender] = 0;
207 181     } else {
208 182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209 183     }
210 184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211 185     return true;
212 186   }
213 
214 187 }
215 188 contract EZDEX is StandardToken {
216     
217 189     string public constant name = "EZDEX";
218 190     string public constant symbol = "EZX";
219 191     uint8 public constant decimals = 18;
220     
221 192     uint256 public constant INITIAL_SUPPLY = 1000000000000000000000000000;
222     
223 193     function EZDEX() {
224 194         totalSupply_ = INITIAL_SUPPLY;
225 195         balances[msg.sender] = INITIAL_SUPPLY;
226 196     }
227     
228 197 }