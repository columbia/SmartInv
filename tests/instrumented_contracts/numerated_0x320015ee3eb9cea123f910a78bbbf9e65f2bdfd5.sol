1 pragma solidity ^0.4.19;
2 
3 
4 
5 /**
6  * @title Moderated
7  * @dev restricts execution of 'onlyModerator' modified functions to the contract moderator
8  * @dev restricts execution of 'ifUnrestricted' modified functions to when unrestricted 
9  *      boolean state is true
10  * @dev allows for the extraction of ether or other ERC20 tokens mistakenly sent to this address
11  */
12 contract Moderated {
13     
14     address public moderator;
15     
16     bool public unrestricted;
17     
18     modifier onlyModerator {
19         require(msg.sender == moderator);
20         _;
21     }
22     
23     modifier ifUnrestricted {
24         require(unrestricted);
25         _;
26     }
27     
28     modifier onlyPayloadSize(uint256 numWords) {
29         assert(msg.data.length >= numWords * 32 + 4);
30         _;
31     }    
32     
33     function Moderated() public {
34         moderator = msg.sender;
35         unrestricted = true;
36     }
37     
38     function reassignModerator(address newModerator) public onlyModerator {
39         moderator = newModerator;
40     }
41     
42     function restrict() public onlyModerator {
43         unrestricted = false;
44     }
45     
46     function unrestrict() public onlyModerator {
47         unrestricted = true;
48     }  
49     
50     /// This method can be used to extract tokens mistakenly sent to this contract.
51     /// @param _token The address of the token contract that you want to recover
52     function extract(address _token) public returns (bool) {
53         require(_token != address(0x0));
54         Token token = Token(_token);
55         uint256 balance = token.balanceOf(this);
56         return token.transfer(moderator, balance);
57     }
58     
59     function isContract(address _addr) internal view returns (bool) {
60         uint256 size;
61         assembly { size := extcodesize(_addr) }
62         return (size > 0);
63     }  
64     
65     function getModerator() public view returns (address) {
66         return moderator;
67     }
68 } 
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract Token { 
75 
76     function totalSupply() public view returns (uint256);
77     function balanceOf(address who) public view returns (uint256);
78     function transfer(address to, uint256 value) public returns (bool);
79     function transferFrom(address from, address to, uint256 value) public returns (bool);    
80     function approve(address spender, uint256 value) public returns (bool);
81     function allowance(address owner, address spender) public view returns (uint256);    
82     event Transfer(address indexed from, address indexed to, uint256 value);    
83     event Approval(address indexed owner, address indexed spender, uint256 value);    
84 
85 }
86 
87 
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations that are safe for uint256 against overflow and negative values
92  * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
93  */
94 
95 library SafeMath {
96   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97     if (a == 0) {
98       return 0;
99     }
100     uint256 c = a * b;
101     assert(c / a == b);
102     return c;
103   }
104 
105   function div(uint256 a, uint256 b) internal pure returns (uint256) {
106     // assert(b > 0); // Solidity automatically throws when dividing by 0
107     uint256 c = a / b;
108     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109     return c;
110   }
111 
112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   function add(uint256 a, uint256 b) internal pure returns (uint256) {
118     uint256 c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 // @dev Assign moderation of contract to CrowdSale
125 
126 contract LEON is Moderated {	
127 	using SafeMath for uint256;
128 
129 		string public name = "LEONS Coin";	
130 		string public symbol = "LEONS";			
131 		uint8 public decimals = 18;
132 		
133 		mapping(address => uint256) internal balances;
134 		mapping (address => mapping (address => uint256)) internal allowed;
135 
136 		uint256 internal totalSupply_;
137 
138 		// the maximum number of LEONS there may exist is capped at 200 million tokens
139 		uint256 public constant maximumTokenIssue = 200000000 * 10**18;
140 		
141 		event Approval(address indexed owner, address indexed spender, uint256 value); 
142 		event Transfer(address indexed from, address indexed to, uint256 value);		
143 
144 		/**
145 		* @dev total number of tokens in existence
146 		*/
147 		function totalSupply() public view returns (uint256) {
148 			return totalSupply_;
149 		}
150 
151 		/**
152 		* @dev transfer token for a specified address
153 		* @param _to The address to transfer to.
154 		* @param _value The amount to be transferred.
155 		*/
156 		function transfer(address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
157 		    return _transfer(msg.sender, _to, _value);
158 		}
159 
160 		/**
161 		* @dev Transfer tokens from one address to another
162 		* @param _from address The address which you want to send tokens from
163 		* @param _to address The address which you want to transfer to
164 		* @param _value uint256 the amount of tokens to be transferred
165 		*/
166 		function transferFrom(address _from, address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(3) returns (bool) {
167 		    require(_value <= allowed[_from][msg.sender]);
168 		    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169 		    return _transfer(_from, _to, _value);
170 		}		
171 
172 		function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
173 			// Do not allow transfers to 0x0 or to this contract
174 			require(_to != address(0x0) && _to != address(this));
175 			// Do not allow transfer of value greater than sender's current balance
176 			require(_value <= balances[_from]);
177 			// Update balance of sending address
178 			balances[_from] = balances[_from].sub(_value);	
179 			// Update balance of receiving address
180 			balances[_to] = balances[_to].add(_value);		
181 			// An event to make the transfer easy to find on the blockchain
182 			Transfer(_from, _to, _value);
183 			return true;
184 		}
185 
186 		/**
187 		* @dev Gets the balance of the specified address.
188 		* @param _owner The address to query the the balance of.
189 		* @return An uint256 representing the amount owned by the passed address.
190 		*/
191 		function balanceOf(address _owner) public view returns (uint256) {
192 			return balances[_owner];
193 		}
194 
195 		/**
196 		* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197 		*
198 		* Beware that changing an allowance with this method brings the risk that someone may use both the old
199 		* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200 		* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201 		* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202 		* @param _spender The address which will spend the funds.
203 		* @param _value The amount of tokens to be spent.
204 		*/
205 		function approve(address _spender, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool sucess) {
206 			// Can only approve when value has not already been set or is zero
207 			require(allowed[msg.sender][_spender] == 0 || _value == 0);
208 			allowed[msg.sender][_spender] = _value;
209 			Approval(msg.sender, _spender, _value);
210 			return true;
211 		}
212 
213 		/**
214 		* @dev Function to check the amount of tokens that an owner allowed to a spender.
215 		* @param _owner address The address which owns the funds.
216 		* @param _spender address The address which will spend the funds.
217 		* @return A uint256 specifying the amount of tokens still available for the spender.
218 		*/
219 		function allowance(address _owner, address _spender) public view returns (uint256) {
220 			return allowed[_owner][_spender];
221 		}
222 
223 		/**
224 		* @dev Increase the amount of tokens that an owner allowed to a spender.
225 		*
226 		* approve should be called when allowed[_spender] == 0. To increment
227 		* allowed value is better to use this function to avoid 2 calls (and wait until
228 		* the first transaction is mined)
229 		* From MonolithDAO Token.sol
230 		* @param _spender The address which will spend the funds.
231 		* @param _addedValue The amount of tokens to increase the allowance by.
232 		*/
233 		function increaseApproval(address _spender, uint256 _addedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
234 			require(_addedValue > 0);
235 			allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237 			return true;
238 		}
239 
240 		/**
241 		* @dev Decrease the amount of tokens that an owner allowed to a spender.
242 		*
243 		* approve should be called when allowed[_spender] == 0. To decrement
244 		* allowed value is better to use this function to avoid 2 calls (and wait until
245 		* the first transaction is mined)
246 		* From MonolithDAO Token.sol
247 		* @param _spender The address which will spend the funds.
248 		* @param _subtractedValue The amount of tokens to decrease the allowance by.
249 		*/
250 		function decreaseApproval(address _spender, uint256 _subtractedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
251 			uint256 oldValue = allowed[msg.sender][_spender];
252 			require(_subtractedValue > 0);
253 			if (_subtractedValue > oldValue) {
254 				allowed[msg.sender][_spender] = 0;
255 			} else {
256 				allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257 			}
258 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259 			return true;
260 		}
261 
262 		/**
263 		* @dev Function to mint tokens
264 		* @param _to The address that will receive the minted tokens.
265 		* @param _amount The amount of tokens to mint.
266 		* @return A boolean that indicates if the operation was successful.
267 		*/
268 		function generateTokens(address _to, uint _amount) public onlyModerator returns (bool) {
269 		    require(isContract(moderator));
270 			require(totalSupply_.add(_amount) <= maximumTokenIssue);
271 			totalSupply_ = totalSupply_.add(_amount);
272 			balances[_to] = balances[_to].add(_amount);
273 			Transfer(address(0x0), _to, _amount);
274 			return true;
275 		}
276 		/**
277 		* @dev fallback function - reverts transaction
278 		*/		
279     	function () external payable {
280     	    revert();
281     	}		
282 }