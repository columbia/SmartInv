1 pragma solidity ^0.4.24;
2  
3 contract TSCoin {
4  
5     uint256 totalSupply_; 
6     string public constant name = "TSCoin";
7     string public constant symbol = "TSC";
8     uint8 public constant decimals = 18;
9     uint256 public constant initialSupply = 200000000*(10**uint256(decimals));
10 	uint256 public buyPrice;
11 	address public owner;
12  
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15  
16     mapping (address => uint256) balances; 
17     mapping (address => mapping (address => uint256)) allowed;
18     
19     function totalSupply() public view returns (uint256){
20         return totalSupply_;
21     }
22  
23     function balanceOf(address _owner) public view returns (uint256){
24         return balances[_owner];
25     }
26  
27     function allowance(address _owner, address _spender) public view returns (uint256) {
28         return allowed[_owner][_spender];
29   }
30 
31 
32 	
33 	function _transfer(address _from, address _to, uint256 _value) internal returns (bool ) {
34         require(_to != address(0));
35         require(balances[_from] >= _value); 
36         balances[_from] = balances[_from] - _value; 
37         balances[_to] = balances[_to] + _value; 
38         emit Transfer(_from, _to, _value);
39         return true;
40     }
41     
42     function transfer(address _to, uint256 _value)  public {
43         _transfer(msg.sender, _to, _value);
44     }
45 
46 
47 		function _buy(address _from, uint256 _value) internal {
48 		uint256 _amount = (_value / buyPrice)*(10**uint256(decimals));
49 		_transfer(this, _from, _amount);
50 		emit Transfer(this, _from, _amount);
51 		}
52 		
53 		function() public payable{
54 			 _buy(msg.sender, msg.value);
55 		}
56 		
57 		function buy() public payable {
58 			_buy(msg.sender, msg.value);
59 		}
60 		
61 	
62 
63 		function transferEthers() public {
64 			require(msg.sender == owner);
65 			owner.transfer(address(this).balance);
66 		}
67 
68 
69 
70 
71 
72  
73     function approve(address _spender, uint256 _value) public returns (bool) {
74         allowed[msg.sender][_spender] = _value;
75         emit Approval(msg.sender, _spender, _value);
76         return true;
77     }
78  
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81         require(_value <= balances[_from]);
82         require(_value <= allowed[_from][msg.sender]); 
83         balances[_from] = balances[_from] - _value; 
84         balances[_to] = balances[_to] + _value; 
85         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value; 
86         emit Transfer(_from, _to, _value); 
87         return true; 
88         } 
89  
90      function increaseApproval(address _spender, uint _addedValue) public returns (bool) { 
91      allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue; 
92      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
93      return true; 
94      } 
95  
96     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) { 
97     uint oldValue = allowed[msg.sender][_spender]; 
98     if (_subtractedValue > oldValue) {
99  
100         allowed[msg.sender][_spender] = 0;
101     } 
102         else {
103         allowed[msg.sender][_spender] = oldValue - _subtractedValue;
104     }
105     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106     return true;
107     }
108 	
109 
110  
111     constructor(uint256 prices) public {
112         totalSupply_ = initialSupply;
113         balances[this] = initialSupply;
114         
115 		buyPrice = prices;
116 		owner = msg.sender;
117     }
118 }