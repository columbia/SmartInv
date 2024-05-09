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
65 contract MyToken is Admined, ERC20,Token("TTL","Talent Token",18,50000000000000000000000000)
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
79      function MyToken() public{
80         	_balanceOf[msg.sender]=_totalSupply;
81     }
82     	
83     function balanceOf(address _addr)public constant returns (uint balance){
84        	return _balanceOf[_addr];
85 	}
86 
87 	function transfer(address _to, uint _value)whenTransferAllowed public returns (bool success){
88         	require(_to!=address(0) && _value <= balanceOf(msg.sender));{
89             _balanceOf[msg.sender]-= _value;
90            	_balanceOf[_to]+=_value;
91 			Transfer(msg.sender, _to, _value);
92            	return true;
93 		}
94 		return false;
95     	}	
96     
97 	function transferFrom(address _from, address _to, uint _value)whenTransferAllowed public returns(bool success){
98         require(balanceOf(_from)>=_value && _value<= _allowances[_from][msg.sender]);
99         {
100 			_balanceOf[_from]-=_value;
101     		_balanceOf[_to]+=_value;
102 			_allowances[_from][msg.sender] -= _value;
103 			Transfer(_from, _to, _value);  
104 			return true;
105     	}
106         	return false;
107    	}
108 
109 	function approve(address _spender, uint _value) public returns (bool success){
110         	_allowances[msg.sender][_spender] = _value;
111         	return true;
112     	}
113 
114     	function allowance(address _owner, address _spender) public constant returns(uint remaining){
115         	return _allowances[_owner][_spender];
116         }
117         
118     function allowTransfer() onlyOwner public {
119         transferAllowed = true;
120     }
121 
122  function burn(uint256 _value) public returns (bool) {
123         require(_value <= _balanceOf[msg.sender]);
124         _balanceOf[msg.sender] -= _value;
125         _totalSupply -= _value;
126         Burn(msg.sender, _value);
127         return true;
128     }
129     
130     function burnFrom(address _from, uint256 _value) public returns (bool success) {
131         require(_value <= _balanceOf[_from]);
132         require(_value <= _allowances[_from][msg.sender]);
133         _balanceOf[_from] -= _value;
134         _allowances[_from][msg.sender] -= _value;
135         _totalSupply -= _value;
136         Burn(_from, _value);
137         return true;
138     }
139 }