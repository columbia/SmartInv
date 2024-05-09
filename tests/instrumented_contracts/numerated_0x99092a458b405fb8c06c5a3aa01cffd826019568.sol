1 pragma solidity ^0.4.21;
2 contract ERC20 {
3   uint256 public totalSupply;
4   function balanceOf(address who) public view returns (uint256 _user){}
5   function transfer(address to, uint256 value) public returns (bool success){}
6   function allowance(address owner, address spender) public view returns (uint256 value){}
7   function transferFrom(address from, address to, uint256 value) public returns (bool success){}
8   function approve(address spender, uint256 value) public returns (bool success){}
9 
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15   
16   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function safeAdd(uint256 a, uint256 b) internal pure  returns (uint256) {
31     uint c = a + b;
32     assert(c>=a);
33     return c;
34   }
35   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 }
42 
43 contract OnlyOwner {
44   address public owner;
45   /** 
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function OnlyOwner() public {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner. 
56    */
57   modifier isOwner {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 }
63 
64 contract StandardToken is ERC20{
65 	using SafeMath for uint256;
66 
67   	mapping(address => uint256) balances;
68   	mapping (address => mapping (address => uint256)) allowed;
69 
70   	event Minted(address receiver, uint256 amount);
71   	
72   	
73 
74   	
75 
76   	function _transfer(address _from, address _to, uint256 _value) internal view returns (bool success){
77   		//prevent sending of tokens from genesis address or to self
78 	    require(_from != address(0) && _from != _to);
79 	    require(_to != address(0));
80 	    //subtract tokens from the sender on transfer
81 	    balances[_from] = balances[_from].safeSub(_value);
82 	    //add tokens to the receiver on reception
83 	    balances[_to] = balances[_to].safeAdd(_value);
84 	    return true;
85   	}
86 
87 	function transfer(address _to, uint256 _value) onlyPayloadSize(2*32) returns (bool success) 
88 	{ 
89 		require(_value <= balances[msg.sender]);
90 	    _transfer(msg.sender,_to,_value);
91 	    Transfer(msg.sender, _to, _value);
92 	    return true;
93 	}
94 
95 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96     	uint256 _allowance = allowed[_from][msg.sender];
97     	//value must be less than allowed value
98     	require(_value <= _allowance);
99     	//balance of sender + token value transferred by sender must be greater than balance of sender
100     	require(balances[_to] + _value > balances[_to]);
101     	//call transfer function
102     	_transfer(_from,_to,_value);
103     	//subtract the amount allowed to the sender 
104      	allowed[_from][msg.sender] = _allowance.safeSub(_value);
105      	//trigger Transfer event
106     	Transfer(_from, _to, _value);
107     	return true;
108   	}
109 
110   	function balanceOf(address _owner) public constant returns (uint balance) {
111     	return balances[_owner];
112   	}
113 
114   /**
115    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
116    *
117    * Beware that changing an allowance with this method brings the risk that someone may use both the old
118    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
119    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
120    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124 
125   function approve(address _spender, uint256 _value) public returns (bool) {
126     allowed[msg.sender][_spender] = _value;
127     Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Function to check the amount of tokens that an owner allowed to a spender.
133    * @param _owner address The address which owns the funds.
134    * @param _spender address The address which will spend the funds.
135    * @return A uint256 specifying the amount of tokens still available for the spender.
136    */
137   function allowance(address _owner, address _spender) public view returns (uint256) {
138     return allowed[_owner][_spender];
139   }
140 
141    /**
142    * @dev Increase the amount of tokens that an owner allowed to a spender.
143    *
144    * approve should be called when allowed[_spender] == 0. To increment
145    * allowed value is better to use this function to avoid 2 calls (and wait until
146    * the first transaction is mined)
147    * From MonolithDAO Token.sol
148    * @param _spender The address which will spend the funds.
149    * @param _addedValue The amount of tokens to increase the allowance by.
150    */
151   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
152     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].safeAdd(_addedValue);
153     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157   /**
158    * @dev Decrease the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To decrement
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _subtractedValue The amount of tokens to decrease the allowance by.
166    */
167   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
168     uint256 oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.safeSub(_subtractedValue);
173     }
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178   modifier onlyPayloadSize(uint size) {
179 		assert(msg.data.length == size + 4);
180 		_;
181 	} 
182 
183 }
184 
185 contract XRT is StandardToken, OnlyOwner{
186 	uint8 public constant decimals = 18;
187     uint256 private constant multiplier = billion*10**18;
188   	string public constant name = "XRT Token";
189   	string public constant symbol = "XRT";
190   	string public version = "X1.0";
191   	uint256 private billion = 10*10**8;
192   	uint256 private maxSupply = multiplier;
193     uint256 public totalSupply = (50*maxSupply)/100;
194   	
195   	function XRT() public{
196   	    balances[msg.sender] = totalSupply;
197   	}
198   	
199   	function maximumToken() isOwner returns (uint){
200   	    return maxSupply;
201   	}
202   	
203   	event Mint(address indexed to, uint256 amount);
204   	event MintFinished();
205     
206  	bool public mintingFinished = false;
207 
208 
209 	modifier canMint() {
210 		require(!mintingFinished);
211 		require(totalSupply <= maxSupply);
212 		_;
213 	}
214 
215   /**
216    * @dev Function to mint tokens
217    * @param _to The address that will receive the minted tokens.
218    * @param _amount The amount of tokens to mint.
219    * @return A boolean that indicates if the operation was successful.
220    */
221 	function mint(address _to, uint256 _amount) isOwner canMint public returns (bool) {
222 	    uint256 newAmount = _amount.safeMul(multiplier.safeDiv(100));
223 	    require(totalSupply <= maxSupply.safeSub(newAmount));
224 	    totalSupply = totalSupply.safeAdd(newAmount);
225 		balances[_to] = balances[_to].safeAdd(newAmount);
226 		Mint(_to, newAmount);
227 		Transfer(address(0), _to, newAmount);
228 		return true;
229 	}
230 
231   /**
232    * @dev Function to stop minting new tokens.
233    * @return True if the operation was successful.
234    */
235   	function finishMinting() isOwner canMint public returns (bool) {
236     	mintingFinished = true;
237     	MintFinished();
238     	return true;
239   	}
240 }