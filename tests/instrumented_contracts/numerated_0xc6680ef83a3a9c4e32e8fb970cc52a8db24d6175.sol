1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-30
3 */
4 
5 /*
6 * MIT License
7 * ===========
8 *
9 * Permission is hereby granted, free of charge, to any person obtaining a copy
10 * of this software and associated documentation files (the "Software"), to deal
11 * in the Software without restriction, including without limitation the rights
12 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
13 * copies of the Software, and to permit persons to whom the Software is
14 * furnished to do so, subject to the following conditions:
15 *
16 * The above copyright notice and this permission notice shall be included in all
17 * copies or substantial portions of the Software.
18 *
19 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
20 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
21 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
22 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
23 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
24 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
25 */
26 
27 
28 pragma solidity >= 0.4.22<0.6.0;
29 
30 library SafeMath {
31   function mul(uint a, uint b) internal pure  returns (uint) {
32 	uint c = a * b;
33 	assert(a == 0 || c / a == b);
34 	return c;
35   }
36  
37   function div(uint a, uint b) internal pure  returns (uint) {
38 	// assert(b > 0); // Solidity automatically throws when dividing by 0
39 	uint c = a / b;
40 	// assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 	return c;
42   }
43  
44   function sub(uint a, uint b) internal pure returns (uint) {
45 	assert(b <= a);
46 	return a - b;
47   }
48  
49   function add(uint a, uint b) internal  pure   returns (uint) {
50 	uint c = a + b;
51 	assert(c >= a);
52 	return c;
53   }
54 }
55 contract HertzNetworkToken {
56 	using SafeMath for uint;
57 	uint private totalSupplyAmount;
58 	address private owner;
59 	mapping(address => uint) private balances;
60 	mapping(address => mapping(address => uint)) private allowed;
61 	string private tokenName;
62 	string private tokenSymbol;
63 	uint8 private decimalPoints;
64 	
65 	 /**
66   * @dev Fix for the ERC20 short address attack.
67    */
68   modifier onlyPayloadSize(uint size) {
69     require(msg.data.length >= size + 4) ;
70     _;
71   }
72 	constructor(string name,string symbol,
73 	uint initialSupply,uint8 decimals) public {
74     	tokenName=name;
75     	tokenSymbol=symbol;
76     	decimalPoints=decimals;
77     	uint supply=SafeMath.mul(initialSupply,10**uint(decimalPoints));
78     	totalSupplyAmount=supply;
79     	owner=msg.sender;
80     	balances[owner]=SafeMath.add(balances[owner],totalSupplyAmount);
81     	emit Transfer(address(0),owner,totalSupplyAmount);
82 	}
83     
84 	function name() public view returns(string memory){
85     	return tokenName;
86 	}
87     
88 	function symbol() public view returns(string memory){
89     	return tokenSymbol;
90 	}
91     
92 	function decimals() public view returns(uint){
93     	return decimalPoints;
94 	}
95  
96 	function totalSupply() public view returns(uint){
97     	return totalSupplyAmount;
98 	}
99     
100 	function balanceOf(address findingBalanceAddress) public view returns(uint){
101     	return balances[findingBalanceAddress];
102 	}
103     
104 	function getTokenOwnerAddress() public view returns(address){
105     	return owner;
106 	}
107     
108 	function transfer(address to,uint tokenAmountInWEI) public returns(bool){
109     	require(balances[msg.sender]>=tokenAmountInWEI);
110     	require(tokenAmountInWEI>0);
111     	require((SafeMath.add(balances[to],tokenAmountInWEI))>balances[to]);
112     	balances[msg.sender] = SafeMath.sub(balances[msg.sender],tokenAmountInWEI);
113     	balances[to] = SafeMath.add(balances[to],tokenAmountInWEI);
114     	emit Transfer(msg.sender,to,tokenAmountInWEI);
115     	return true;
116 	}
117 
118 	function transferFrom(address from,address to,uint tokenAmountInWEI) onlyPayloadSize(3 * 32) public returns(bool){
119  	    require(balances[from]>=tokenAmountInWEI);   
120  	    require(allowed[from] [msg.sender]>=tokenAmountInWEI);
121  	    require(tokenAmountInWEI>0);
122     
123  	    require((SafeMath.add(balances[to],tokenAmountInWEI))>balances[to]);
124  	    balances[to] = SafeMath.add(balances[to],tokenAmountInWEI);
125  	    balances[from] = SafeMath.sub(balances[from],tokenAmountInWEI);
126  	    allowed[from][msg.sender] = SafeMath.sub(allowed[from][msg.sender],tokenAmountInWEI);
127  	    emit Transfer(from,to,tokenAmountInWEI);
128  	    return true;
129 	}
130     
131 	function approve(address spender,uint tokenAmountInWEI) public  returns(bool){
132     	allowed[msg.sender][spender]=SafeMath.add(allowed[msg.sender][spender],tokenAmountInWEI);
133      	emit  Approval(msg.sender,spender,tokenAmountInWEI);
134     	return true;
135 	}
136     
137 	function allownce(address from,address spender) public view returns(uint){
138     	return allowed[from][spender];
139 	}
140 	
141 	function burn (uint tokenAmount) public returns(bool){
142 	    uint amountInWEI=SafeMath.mul(tokenAmount,10**uint(decimalPoints));
143 	    require(msg.sender==owner && balances[msg.sender]>=amountInWEI && totalSupplyAmount>=amountInWEI);
144         totalSupplyAmount=SafeMath.sub(totalSupplyAmount,amountInWEI);
145         balances[msg.sender]=SafeMath.sub(balances[msg.sender],amountInWEI);
146         emit Transfer(msg.sender,address(0),amountInWEI);
147         return true;
148 	}
149 	
150 	event Transfer(address indexed from,address indexed to,uint amount);
151 	event Approval(address indexed indexer,address indexed spender,uint amount);
152 }