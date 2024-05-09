1 pragma solidity ^0.4.24;
2 
3 /**
4  * The contractName contract does this and that...
5  */
6 
7 interface tokenRecepient { function recieveApproval (address _from, uint256 _value, address _token, bytes _extradata) external;	}
8   
9 contract owned{
10 	address public owner;
11 
12 	constructor()public{
13 		owner = msg.sender;
14 	}
15 
16 	modifier onlyOwner{
17 
18 		require (msg.sender == owner);
19 		_;
20 		
21 	}
22 	function transferOwnership (address newOwner) public onlyOwner {
23 		owner = newOwner;
24 	}
25 	
26 }
27 
28 
29 contract byzbit is owned {
30 	string public name;
31 	string public symbol;
32 	uint8 public decimals=18;
33 	uint256 public totalSupply;
34 
35 	//uint256 public sellPrice;
36 	//uint256 public buyPrice;
37 
38 	mapping (address => uint256) public balanceOf;
39 	mapping (address => mapping (address => uint256)) public allowance;
40 	mapping (address => bool) public frozenAccount;
41 	
42 	 
43 	event Transfer(address indexed from, address indexed to, uint256 value);
44 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 	event Burn(address indexed from, uint256 value);
46 	event FrozenFunds(address target, bool frozen);
47 	
48 	
49 	
50 	
51 
52 	constructor(
53 		uint256 initialSupply,
54 		string tokenName,
55 		string tokenSymbol
56 		)public{
57 		totalSupply = initialSupply*10**uint256(decimals);
58 		balanceOf[msg.sender] = totalSupply;
59 		name = tokenName;
60 		symbol = tokenSymbol;
61 
62 	}
63 ////////////////////////////// TRANSFER //////////////////////////////
64 	function _transfer (address _from, address _to, uint _value) internal {
65 		
66 		require (_to != 0x0);
67 		require (balanceOf[_from] >= _value);
68 		require (balanceOf[_to] + _value >= balanceOf[_to]);
69 		require (!frozenAccount[msg.sender]);
70 		
71 
72 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
73 
74 		balanceOf[_from] -= _value;
75 		balanceOf[_to] += _value;
76 
77 
78 		emit Transfer (_from, _to, _value);
79 		assert (balanceOf[_from] + balanceOf[_to] == previousBalances);
80 		
81 				
82 	}
83 	
84 
85 	function transfer (address _to, uint256 _value) public 
86 	returns(bool success){
87 		
88 		_transfer(msg.sender, _to, _value);
89 		return true;
90 	}
91 	////////////////////////////// TRANSFER END //////////////////////////////
92 
93 ////////////////////////////// ALLOWANCE //////////////////////////////
94 
95 	function transferFrom (address _from, address _to, uint256 _value) public
96 	returns(bool success) {
97 		
98 		require (_value <= allowance[_from][msg.sender]);
99 		allowance[_from][msg.sender] -=_value;
100 		_transfer(_from, _to, _value);
101 		return true;
102 						
103 	}
104 	
105 
106 	function approve (address _spender, uint256 _value) onlyOwner public 
107 	returns(bool success) 
108 	 {
109 		allowance[msg.sender][_spender] = _value; 
110 		emit Approval(msg.sender, _spender, _value);
111 		return true;
112 	}
113 
114 	function approveAndCall (address _spender, uint256 _value, bytes _extradata) public 
115 	returns(bool success){
116 		tokenRecepient spender = tokenRecepient(_spender);
117 
118 		if(approve(_spender, _value)){
119 			spender.recieveApproval(msg.sender, _value, this, _extradata);
120 			return true;
121 		}
122 		
123 	}
124 	
125 	////////////////////////////// ALLOWANCE END //////////////////////////////
126 
127 	////////////////////////////// BURN //////////////////////////////
128 
129 	function burn (uint256 _value) public returns(bool success){
130 		
131 		require (balanceOf[msg.sender] >= _value) ;
132 		balanceOf[msg.sender] -= _value;
133 
134 		totalSupply -= _value;
135 
136 		emit Burn(msg.sender, _value);
137 		return true;
138 		
139 	}
140 
141 	function burnFrom (address _from, uint256 _value)public returns(bool success){
142 		require (balanceOf[_from] >= _value) ;
143 
144 		require (_value <= allowance[_from][msg.sender]);
145 		
146 		balanceOf[_from] -= _value;
147 		totalSupply -= _value;
148 		emit Burn(msg.sender, _value);
149 		return true;
150 	}
151 	
152 	
153 	////////////////////////////// BURN END //////////////////////////////
154 	
155 	////////////////////////////// FREEZING //////////////////////////////
156 
157 	function freezeAccount (address target, bool freeze) public onlyOwner  {
158 		frozenAccount[target] = freeze;
159 		emit FrozenFunds (target, freeze);
160 	}
161 	
162 	////////////////////////////// FREEZ END //////////////////////////////
163 
164 	/*////////////////////////////// BUY and SELL  //////////////////////////////
165 
166 	function setPrice (uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
167 		
168 		sellPrice = newSellPrice;
169 		buyPrice = newBuyPrice;
170 	}
171 	
172 	function buy () payable returns (uint amount){
173 		amount = msg.value/buyPrice;
174 		_transfer (this, msg.sender, amount);
175 		return amount;
176 
177 	}
178 
179 	function sell (uint amount) returns(uint revenue){
180 		
181 			require (balanceOf[msg.sender] >= amount);
182 			balanceOf[this] += amount;
183 			balanceOf[msg.sender] -=amount;
184 			revenue = amount * sellPrice;
185 			msg.sender.transfer(revenue);
186 
187 			return revenue;
188 				
189 	}
190 	
191 
192 	////////////////////////////// BUY and SELL END //////////////////////////////*/
193 	
194 }