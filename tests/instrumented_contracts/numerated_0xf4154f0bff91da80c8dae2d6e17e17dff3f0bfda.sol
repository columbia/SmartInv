1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 		uint256 c = a * b;
9 		assert(c / a == b);
10 		return c;
11 	}
12 
13 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 		// assert(b > 0); // Solidity automatically throws when dividing by 0
15 		uint256 c = a / b;
16 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
17 		return c;
18 	}
19 
20 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21 		assert(b <= a);
22 		return a - b;
23 	}
24 
25 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
26 		uint256 c = a + b;
27 		assert(c >= a);
28 		return c;
29 	}
30 }
31 
32 contract ERC20Basic {
33 	uint256 public totalSupply;
34 	function balanceOf(address who) public view returns (uint256);
35 	function transfer(address to, uint256 value) public returns (bool);
36 	event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40 	function allowance(address owner, address spender) public view returns (uint256);
41 	function transferFrom(address from, address to, uint256 value) public returns (bool);
42 	function approve(address spender, uint256 value) public returns (bool);
43 	event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47 	using SafeMath for uint256;
48 
49 	mapping(address => uint256) balances;
50 
51 	/**
52 	* @dev transfer token for a specified address
53 	* @param _to The address to transfer to.
54 	* @param _value The amount to be transferred.
55 	*/
56 	function transfer(address _to, uint256 _value) public returns (bool) {
57 		require(_to != address(0));
58 		require(_value <= balances[msg.sender]);
59 
60 		// SafeMath.sub will throw if there is not enough balance.
61 		balances[msg.sender] = balances[msg.sender].sub(_value);
62 		balances[_to] = balances[_to].add(_value);
63 		emit Transfer(msg.sender, _to, _value);
64 		return true;
65 	}
66 
67 	/**
68 	* @dev Gets the balance of the specified address.
69 	* @param _owner The address to query the the balance of.
70 	* @return An uint256 representing the amount owned by the passed address.
71 	*/
72 	function balanceOf(address _owner) public view returns (uint256 balance) {
73 		return balances[_owner];
74 	}
75 }
76 
77 contract WoodToken is ERC20, BasicToken {
78 	// Public variables of the token
79     string public name;
80     string public symbol;
81     uint8 public decimals = 0;
82 
83 	mapping (address => mapping (address => uint256)) internal allowed;
84 	
85 	event Burn(address indexed burner, uint256 value);
86 	
87 	/**
88      * Constrctor function
89      *
90      * Initializes contract with initial supply tokens to the creator of the contract
91      */
92     function WoodToken(
93         uint256 initialSupply,
94         string tokenName,
95         string tokenSymbol
96     ) public {
97         totalSupply = initialSupply * 10 ** uint256(decimals);          // Update total supply with the decimal amount
98 		balances[msg.sender] = balances[msg.sender].add(totalSupply);   // Give the creator all initial tokens           
99         name = tokenName;                                               // Set the name for display purposes
100         symbol = tokenSymbol;                                           // Set the symbol for display purposes
101     }
102 	
103 	/**
104 	* @dev Transfer tokens from one address to another
105 	* @param _from address The address which you want to send tokens from
106 	* @param _to address The address which you want to transfer to
107 	* @param _value uint256 the amount of tokens to be transferred
108 	*/
109 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110 		require(_to != address(0));
111 		require(_value <= balances[_from]);
112 		require(_value <= allowed[_from][msg.sender]);
113 
114 		balances[_from] = balances[_from].sub(_value);
115 		balances[_to] = balances[_to].add(_value);
116 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117 		emit Transfer(_from, _to, _value);
118 		return true;
119 	}
120 	
121 	/**
122 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
123 	*
124 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
125 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
126 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
127 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128 	* @param _spender The address which will spend the funds.
129 	* @param _value The amount of tokens to be spent.
130 	*/
131 	function approve(address _spender, uint256 _value) public returns (bool) {
132 		allowed[msg.sender][_spender] = _value;
133 		emit Approval(msg.sender, _spender, _value);
134 		return true;
135 	}
136 	
137 	/**
138 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
139 	* @param _owner address The address which owns the funds.
140 	* @param _spender address The address which will spend the funds.
141 	* @return A uint256 specifying the amount of tokens still available for the spender.
142 	*/
143 	function allowance(address _owner, address _spender) public view returns (uint256) {
144 		return allowed[_owner][_spender];
145 	}
146 	
147 	/**
148      * @dev Burns a specific amount of tokens.
149      * @param _value The amount of token to be burned.
150      */
151     function burn(uint256 _value) public {
152         require(_value <= balances[msg.sender]);
153         // no need to require value <= totalSupply, since that would imply the
154         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
155 
156         address burner = msg.sender;
157         balances[burner] = balances[burner].sub(_value);
158         totalSupply = totalSupply.sub(_value);
159         emit Burn(burner, _value);
160     }
161 }