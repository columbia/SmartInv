1 pragma solidity ^0.4.18;
2 
3 interface ERC20{
4 	function balanceOf(address _owner) public constant returns(uint);
5 	function transfer(address _to, uint _value) public returns(bool);
6 	function transferFrom(address _from, address _to, uint _value) public returns(bool);
7 	function approve(address _sender, uint _value) public returns (bool);
8 	function allowance(address _owner, address _spender) public constant returns(uint);
9     event Transfer(address indexed _from, address indexed _to, uint _value);
10 	event Approval(address indexed _owner, address indexed _spender, uint _value);
11 	event Burn(address indexedFrom,uint256 value);
12 }
13 
14 contract Token
15 {
16 	string internal _symbol;
17 	string internal _name;
18 	uint8 internal _decimals;	
19     uint256 internal _totalSupply;
20    	mapping(address =>uint) internal _balanceOf;
21 	mapping(address => mapping(address => uint)) internal _allowances;
22 
23     function Token(string symbol, string name, uint8 decimals, uint totalSupply) public{
24 	    _symbol = symbol;
25 		_name = name;
26 		_decimals = decimals;
27 		_totalSupply = totalSupply;
28     }
29 
30 	function name() public constant returns (string){
31         	return _name;    
32 	}
33 
34 	function symbol() public constant returns (string){
35         	return _symbol;    
36 	}
37 
38 	function decimals() public constant returns (uint8){
39 		return _decimals;
40 	}
41 
42 	function totalSupply() public constant returns (uint){
43         	return _totalSupply;
44 	}
45 }
46 contract Admined{
47     
48     address public owner;
49 
50     function Admined() public {
51         owner = msg.sender;
52     }
53     
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58     
59     function transferOwnership(address newOwner) onlyOwner public {
60         require(newOwner != address(0));      
61         owner = newOwner;
62     }
63 }
64 
65 contract MyToken is Admined, ERC20,Token("TLT","Talent Coin",18,50000000000000000000000000)
66 {
67    	mapping(address =>uint) private _balanceOf;
68     mapping(address => mapping(address => uint)) private _allowances;
69 	bool public transferAllowed = false;
70     
71     modifier whenTransferAllowed() 
72 	{
73         if(msg.sender != owner){
74         	require(transferAllowed);
75         }
76         _;
77     }
78     
79     function MyToken() public{
80         	_balanceOf[msg.sender]=_totalSupply;
81     }
82     	
83     function balanceOf(address _addr)public constant returns (uint balance){
84        	return _balanceOf[_addr];
85 	}
86 
87 	function transfer(address _to, uint _value)public returns (bool success){
88             _balanceOf[msg.sender]-= _value;
89            	_balanceOf[_to]+=_value;
90 			Transfer(msg.sender, _to, _value);
91            	return true;
92 	}	
93     
94 	function transferFrom(address _from, address _to, uint _value) public returns(bool success){
95         uint allowed = _allowances[_from][msg.sender];
96 		_balanceOf[_from] -= _value;
97     	_balanceOf[_to] += _value;
98 		_allowances[_from][msg.sender] -= allowed;
99 		Transfer(_from, _to, _value);  
100 		return true;
101    	}
102 
103 	function approve(address _spender, uint _value) public returns (bool success){
104     	_allowances[msg.sender][_spender] = _value;
105     	return true;
106 	}
107 
108     function allowance(address _owner, address _spender) public constant returns(uint remaining){
109     	return _allowances[_owner][_spender];
110     }
111         
112     function allowTransfer() onlyOwner public {
113         transferAllowed = true;
114     }
115 
116     function burn(uint256 _value) public returns (bool) {
117         require(_value <= _balanceOf[msg.sender]);
118         _balanceOf[msg.sender] -= _value;
119         _totalSupply -= _value;
120         Burn(msg.sender, _value);
121         return true;
122     }
123     
124     function burnFrom(address _from, uint256 _value) public returns (bool success) {
125         require(_value <= _balanceOf[_from]);
126         require(_value <= _allowances[_from][msg.sender]);
127         _balanceOf[_from] -= _value;
128         _allowances[_from][msg.sender] -= _value;
129         _totalSupply -= _value;
130         Burn(_from, _value);
131         return true;
132     }
133 }