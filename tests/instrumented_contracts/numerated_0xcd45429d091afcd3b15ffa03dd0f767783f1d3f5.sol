1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55 
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66 }
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 contract MinerOnePromoToken is ERC20, Ownable {
102 	using SafeMath for uint256;
103 
104 	string public constant name = "MinerOne.io Discount";
105   	string public constant symbol = "MIO DISCOUNT";
106   	uint8 public constant decimals = 18;
107 
108 	mapping (address => uint256) balances;
109 	mapping (address => mapping (address => uint256)) internal allowed;
110 
111 	event Mint(address indexed to, uint256 amount);
112 
113 	/**
114 	* @dev transfer token for a specified address
115 	* @param _to The address to transfer to.
116 	* @param _value The amount to be transferred.
117 	*/
118 	function transfer(address _to, uint256 _value) public returns (bool) {
119 		require(_to != address(0));
120 		require(_value <= balances[msg.sender]);
121 
122 		// SafeMath.sub will throw if there is not enough balance.
123 		balances[msg.sender] = balances[msg.sender].sub(_value);
124 		balances[_to] = balances[_to].add(_value);
125 		Transfer(msg.sender, _to, _value);
126 		return true;
127 	}
128 
129 	/**
130 	* @dev Gets the balance of the specified address.
131 	* @param _owner The address to query the the balance of.
132 	* @return An uint256 representing the amount owned by the passed address.
133 	*/
134 	function balanceOf(address _owner) public view returns (uint256 balance) {
135 		return balances[_owner];
136 	}
137 
138 	/**
139 	* @dev Transfer tokens from one address to another
140 	* @param _from address The address which you want to send tokens from
141 	* @param _to address The address which you want to transfer to
142 	* @param _value uint256 the amount of tokens to be transferred
143 	*/
144 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145 		require(_to != address(0));
146 		require(_value <= balances[_from]);
147 		require(_value <= allowed[_from][msg.sender]);
148 
149 		balances[_from] = balances[_from].sub(_value);
150 		balances[_to] = balances[_to].add(_value);
151 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152 		Transfer(_from, _to, _value);
153 		return true;
154 	}
155 
156 	/**
157 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158 	*
159 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
160 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163 	* @param _spender The address which will spend the funds.
164 	* @param _value The amount of tokens to be spent.
165 	*/
166 	function approve(address _spender, uint256 _value) public returns (bool) {
167 		allowed[msg.sender][_spender] = _value;
168 		Approval(msg.sender, _spender, _value);
169 		return true;
170 	}
171 
172 	/**
173 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
174 	* @param _owner address The address which owns the funds.
175 	* @param _spender address The address which will spend the funds.
176 	* @return A uint256 specifying the amount of tokens still available for the spender.
177 	*/
178 	function allowance(address _owner, address _spender) public view returns (uint256) {
179 		return allowed[_owner][_spender];
180 	}
181 
182 	/**
183 	* @dev Increase the amount of tokens that an owner allowed to a spender.
184 	*
185 	* approve should be called when allowed[_spender] == 0. To increment
186 	* allowed value is better to use this function to avoid 2 calls (and wait until
187 	* the first transaction is mined)
188 	* From MonolithDAO Token.sol
189 	* @param _spender The address which will spend the funds.
190 	* @param _addedValue The amount of tokens to increase the allowance by.
191 	*/
192 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195 		return true;
196 	}
197 
198 	/**
199 	* @dev Decrease the amount of tokens that an owner allowed to a spender.
200 	*
201 	* approve should be called when allowed[_spender] == 0. To decrement
202 	* allowed value is better to use this function to avoid 2 calls (and wait until
203 	* the first transaction is mined)
204 	* From MonolithDAO Token.sol
205 	* @param _spender The address which will spend the funds.
206 	* @param _subtractedValue The amount of tokens to decrease the allowance by.
207 	*/
208 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209 		uint oldValue = allowed[msg.sender][_spender];
210 		if (_subtractedValue > oldValue) {
211 		  allowed[msg.sender][_spender] = 0;
212 		} else {
213 		  allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214 		}
215 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216 		return true;
217 	}
218 
219 	/**
220 	* @dev Function to mint tokens
221 	* @param _to The address that will receive the minted tokens.
222 	* @param _amount The amount of tokens to mint.
223 	* @return A boolean that indicates if the operation was successful.
224 	*/
225 	function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
226 		totalSupply = totalSupply.add(_amount);
227 		balances[_to] = balances[_to].add(_amount);
228 		Mint(_to, _amount);
229 		Transfer(address(0), _to, _amount);
230 		return true;
231 	}
232 
233   	function mintTokens(address[] _receivers, uint256[] _amounts) onlyOwner external  {
234 		require(_receivers.length > 0 && _receivers.length <= 100);
235 		require(_receivers.length == _amounts.length);
236 		for (uint256 i = 0; i < _receivers.length; i++) {
237 			address receiver = _receivers[i];
238 			uint256 amount = _amounts[i];
239 
240 	  		require(receiver != address(0));
241 	  		require(amount > 0);
242 
243 			mint(receiver, amount);
244 		}
245   	}
246 }