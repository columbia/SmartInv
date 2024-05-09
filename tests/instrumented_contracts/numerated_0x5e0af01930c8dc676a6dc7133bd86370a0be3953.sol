1 /**
2  * @title Moderated
3  * @dev restricts execution of 'onlyModerator' modified functions to the contract moderator
4  * @dev restricts execution of 'ifUnrestricted' modified functions to when unrestricted
5  *      boolean state is true
6  * @dev allows for the extraction of ether or other ERC20 tokens mistakenly sent to this address
7  */
8 contract Moderated {
9 
10     address public moderator;
11 
12     bool public unrestricted;
13 
14     modifier onlyModerator {
15         require(msg.sender == moderator);
16         _;
17     }
18 
19     modifier ifUnrestricted {
20         require(unrestricted);
21         _;
22     }
23 
24     modifier onlyPayloadSize(uint numWords) {
25         assert(msg.data.length >= numWords * 32 + 4);
26         _;
27     }
28 
29     function Moderated() public {
30         moderator = msg.sender;
31         unrestricted = true;
32     }
33 
34     function reassignModerator(address newModerator) public onlyModerator {
35         moderator = newModerator;
36     }
37 
38     function restrict() public onlyModerator {
39         unrestricted = false;
40     }
41 
42     function unrestrict() public onlyModerator {
43         unrestricted = true;
44     }
45 
46     /// This method can be used to extract tokens mistakenly sent to this contract.
47     /// @param _token The address of the token contract that you want to recover
48     function extract(address _token) public returns (bool) {
49         require(_token != address(0x0));
50         Token token = Token(_token);
51         uint256 balance = token.balanceOf(this);
52         return token.transfer(moderator, balance);
53     }
54 
55     function isContract(address _addr) internal view returns (bool) {
56         uint256 size;
57         assembly { size := extcodesize(_addr) }
58         return (size > 0);
59     }
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract Token {
67 
68     function totalSupply() public view returns (uint256);
69     function balanceOf(address who) public view returns (uint256);
70     function transfer(address to, uint256 value) public returns (bool);
71     function transferFrom(address from, address to, uint256 value) public returns (bool);
72     function approve(address spender, uint256 value) public returns (bool);
73     function allowance(address owner, address spender) public view returns (uint256);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 
77 }
78 
79 /**
80  * @title SafeMath
81  * @dev Math operations that are safe for uint256 against overflow and negative values
82  * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
83  */
84 
85 library SafeMath {
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     if (a == 0) {
88       return 0;
89     }
90     uint256 c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   function div(uint256 a, uint256 b) internal pure returns (uint256) {
96     // assert(b > 0); // Solidity automatically throws when dividing by 0
97     uint256 c = a / b;
98     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99     return c;
100   }
101 
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   function add(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 // @dev Assign moderation of contract to CrowdSale
115 
116 contract Touch is Moderated {
117 	using SafeMath for uint256;
118 
119 		string public name = "Touch. Token";
120 		string public symbol = "TST";
121 		uint8 public decimals = 18;
122 
123         uint256 public maximumTokenIssue = 1000000000 * 10**18;
124 
125 		mapping(address => uint256) internal balances;
126 		mapping (address => mapping (address => uint256)) internal allowed;
127 
128 		uint256 internal totalSupply_;
129 
130 		event Approval(address indexed owner, address indexed spender, uint256 value);
131 		event Transfer(address indexed from, address indexed to, uint256 value);
132 
133 		/**
134 		* @dev total number of tokens in existence
135 		*/
136 		function totalSupply() public view returns (uint256) {
137 			return totalSupply_;
138 		}
139 
140 		/**
141 		* @dev transfer token for a specified address
142 		* @param _to The address to transfer to.
143 		* @param _value The amount to be transferred.
144 		*/
145 		function transfer(address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
146 		    return _transfer(msg.sender, _to, _value);
147 		}
148 
149 		/**
150 		* @dev Transfer tokens from one address to another
151 		* @param _from address The address which you want to send tokens from
152 		* @param _to address The address which you want to transfer to
153 		* @param _value uint256 the amount of tokens to be transferred
154 		*/
155 		function transferFrom(address _from, address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(3) returns (bool) {
156 		    require(_value <= allowed[_from][msg.sender]);
157 		    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158 		    return _transfer(_from, _to, _value);
159 		}
160 
161 		function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
162 			// Do not allow transfers to 0x0 or to this contract
163 			require(_to != address(0x0) && _to != address(this));
164 			// Do not allow transfer of value greater than sender's current balance
165 			require(_value <= balances[_from]);
166 			// Update balance of sending address
167 			balances[_from] = balances[_from].sub(_value);
168 			// Update balance of receiving address
169 			balances[_to] = balances[_to].add(_value);
170 			// An event to make the transfer easy to find on the blockchain
171 			Transfer(_from, _to, _value);
172 			return true;
173 		}
174 
175 		/**
176 		* @dev Gets the balance of the specified address.
177 		* @param _owner The address to query the the balance of.
178 		* @return An uint256 representing the amount owned by the passed address.
179 		*/
180 		function balanceOf(address _owner) public view returns (uint256) {
181 			return balances[_owner];
182 		}
183 
184 		/**
185 		* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186 		*
187 		* Beware that changing an allowance with this method brings the risk that someone may use both the old
188 		* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189 		* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190 		* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191 		* @param _spender The address which will spend the funds.
192 		* @param _value The amount of tokens to be spent.
193 		*/
194 		function approve(address _spender, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool sucess) {
195 			// Can only approve when value has not already been set or is zero
196 			require(allowed[msg.sender][_spender] == 0 || _value == 0);
197 			allowed[msg.sender][_spender] = _value;
198 			Approval(msg.sender, _spender, _value);
199 			return true;
200 		}
201 
202 		/**
203 		* @dev Function to check the amount of tokens that an owner allowed to a spender.
204 		* @param _owner address The address which owns the funds.
205 		* @param _spender address The address which will spend the funds.
206 		* @return A uint256 specifying the amount of tokens still available for the spender.
207 		*/
208 		function allowance(address _owner, address _spender) public view returns (uint256) {
209 			return allowed[_owner][_spender];
210 		}
211 
212 		/**
213 		* @dev Increase the amount of tokens that an owner allowed to a spender.
214 		*
215 		* approve should be called when allowed[_spender] == 0. To increment
216 		* allowed value is better to use this function to avoid 2 calls (and wait until
217 		* the first transaction is mined)
218 		* From MonolithDAO Token.sol
219 		* @param _spender The address which will spend the funds.
220 		* @param _addedValue The amount of tokens to increase the allowance by.
221 		*/
222 		function increaseApproval(address _spender, uint256 _addedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
223 			require(_addedValue > 0);
224 			allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226 			return true;
227 		}
228 
229 		/**
230 		* @dev Decrease the amount of tokens that an owner allowed to a spender.
231 		*
232 		* approve should be called when allowed[_spender] == 0. To decrement
233 		* allowed value is better to use this function to avoid 2 calls (and wait until
234 		* the first transaction is mined)
235 		* From MonolithDAO Token.sol
236 		* @param _spender The address which will spend the funds.
237 		* @param _subtractedValue The amount of tokens to decrease the allowance by.
238 		*/
239 		function decreaseApproval(address _spender, uint256 _subtractedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
240 			uint256 oldValue = allowed[msg.sender][_spender];
241 			require(_subtractedValue > 0);
242 			if (_subtractedValue > oldValue) {
243 				allowed[msg.sender][_spender] = 0;
244 			} else {
245 				allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246 			}
247 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248 			return true;
249 		}
250 
251 		/**
252 		* @dev Function to mint tokens
253 		* @param _to The address that will receive the minted tokens.
254 		* @param _amount The amount of tokens to mint.
255 		* @return A boolean that indicates if the operation was successful.
256 		*/
257 		function generateTokens(address _to, uint _amount) internal returns (bool) {
258 			totalSupply_ = totalSupply_.add(_amount);
259 			balances[_to] = balances[_to].add(_amount);
260 			Transfer(address(0x0), _to, _amount);
261 			return true;
262 		}
263 		/**
264 		* @dev fallback function - reverts transaction
265 		*/
266     	function () external payable {
267     	    revert();
268     	}
269 
270     	function Touch () public {
271     		generateTokens(msg.sender, maximumTokenIssue);
272     	}
273 
274 }