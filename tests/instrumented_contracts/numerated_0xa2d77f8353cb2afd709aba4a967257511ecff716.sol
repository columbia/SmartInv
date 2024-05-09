1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract owned {
6 	address public owner;
7 
8 	constructor() public {
9 		owner = msg.sender;
10 	}
11 
12 	modifier onlyOwner {
13     	require(msg.sender == owner);
14     	_;
15 	}
16 
17 }
18 
19 library SafeMath {
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a, "SafeMath: subtraction overflow");
23         uint256 c = a - b;
24 
25         return c;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         
32         return c;
33     }
34 
35 }
36 
37 contract TokenERC20 is owned {
38     
39     using SafeMath for uint256;
40 
41 	string public name;
42 	string public symbol;
43 	uint8 public decimals = 8;
44 	uint256 public totalSupply;
45 
46 	mapping (address => uint256) public balanceOf;
47 	mapping (address => mapping(address => uint256)) public allowance;
48 	
49 	event Transfer(address indexed from, address indexed to, uint256 value);
50 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 	event Burn(address indexed from, address indexed to, uint256 value);
52 
53 	constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
54 			totalSupply = initialSupply*10**uint256(decimals);
55 			balanceOf[msg.sender] = totalSupply;
56 			emit Transfer(0x0, msg.sender, totalSupply);
57 			name = tokenName;
58 			symbol = tokenSymbol;
59 	}
60 	
61     function _transfer(address _from, address _to, uint _value) internal {
62     	
63     	require(_to !=0x0);
64     	require(balanceOf[_from] >= _value);
65     	require(balanceOf[_to].add(_value) >= balanceOf[_to]);
66     	
67         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
68     
69     	balanceOf[_from] = balanceOf[_from].sub(_value);
70     	balanceOf[_to] = balanceOf[_to].add(_value);
71     	
72     	emit Transfer(_from, _to, _value);
73     	assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
74     
75     }
76 
77     function transfer(address _to, uint256 _value) public returns (bool sucess){
78     	
79     	_transfer(msg.sender, _to, _value);
80     	return true;
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool sucess){
84     	
85     	require(_value <= allowance[_from][msg.sender]);
86     	allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
87     	_transfer(_from, _to, _value);
88     	return true;
89     
90     }
91     
92     function approve(address _spender, uint256 _value) public returns (bool sucess){
93     	
94     	allowance[msg.sender][_spender] = _value;
95     	emit Approval(msg.sender, _spender, _value);
96     	return true;
97     
98     }
99     
100     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
101         tokenRecipient spender = tokenRecipient(_spender);
102         if (approve(_spender, _value)) {
103             spender.receiveApproval(msg.sender, _value, this, _extraData);
104             return true;
105         }
106     }
107     
108     
109    function burn(uint256 _value) onlyOwner public returns (bool sucess){
110     	require(balanceOf[msg.sender] >= _value);
111     
112     	balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
113     	totalSupply = totalSupply.sub(_value);
114     	emit Transfer(msg.sender, address(0), _value);
115     	return true;
116     }
117     
118     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool sucess){
119     	require(balanceOf[_from] >= _value);
120     	require(_value <= allowance[_from][msg.sender]);
121     
122     	balanceOf[_from] = balanceOf[_from].sub(_value);
123     	allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
124     	totalSupply = totalSupply.sub(_value);
125     	emit Transfer(msg.sender, address(0), _value);
126     	return true;
127     }
128 
129     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
130     	balanceOf[target] = balanceOf[target].add(mintedAmount);
131     	totalSupply = totalSupply.add(mintedAmount);
132     	emit Transfer(address(0), target, mintedAmount);
133     }
134     
135 }