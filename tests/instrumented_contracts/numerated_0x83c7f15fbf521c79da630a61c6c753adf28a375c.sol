1 pragma solidity ^0.4.24;
2  //     https://globallongevity.io
3 contract Longevity {
4  
5     uint256 totalSupply_; 
6     string public constant name = "Longevity";
7     string public constant symbol = "LGV";
8     uint8 public constant decimals = 18;
9     uint256 public constant initialSupply = 100000000000*(10**uint256(decimals));
10     
11     uint256 public buyPrice; //цена продажи
12     address public owner = 0x7E601454dC38A70a4dC464506c571c99b1654590; // 
13 
14      
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17  
18     mapping (address => uint256) balances; 
19     mapping (address => mapping (address => uint256)) allowed;
20     
21     function totalSupply() public view returns (uint256){
22         return totalSupply_;
23     }
24  
25     function balanceOf(address _owner) public view returns (uint256){
26         return balances[_owner];
27     }
28  
29     function allowance(address _owner, address _spender) public view returns (uint256) {
30         return allowed[_owner][_spender];
31   }
32  //--------------- Новое
33 
34 	
35 	function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
36         require(_to != address(0));
37         require(balances[_from] >= _value); 
38         balances[_from] = balances[_from] - _value; 
39         balances[_to] = balances[_to] + _value; 
40         emit Transfer(_from, _to, _value);
41         return true;
42     }
43     
44     function transfer(address _to, uint256 _value)  public returns (bool) {
45         _transfer(msg.sender, _to, _value);
46     }
47 
48 
49 		function _buy(address _from, uint256 _value) internal {
50 		uint256 _amount = (_value / buyPrice)*(10**uint256(decimals));
51 		_transfer(this, _from, _amount);
52 		emit Transfer(this, _from, _amount);
53 		}
54 		
55 		function() public payable{
56 			 _buy(msg.sender, msg.value);
57 		}
58 		
59 		function buy() public payable {
60 			_buy(msg.sender, msg.value);
61 		}
62 		
63 
64 		function transferEthers() public {
65 			require(msg.sender == owner);
66 			owner.transfer(address(this).balance);
67 		}
68 
69 
70 //---------------------------------------------
71 
72 
73  
74     function approve(address _spender, uint256 _value) public returns (bool) {
75         allowed[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true;
78     }
79  
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82         require(_value <= balances[_from]);
83         require(_value <= allowed[_from][msg.sender]); 
84         balances[_from] = balances[_from] - _value; 
85         balances[_to] = balances[_to] + _value; 
86         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value; 
87         emit Transfer(_from, _to, _value); 
88         return true; 
89         } 
90  
91      function increaseApproval(address _spender, uint _addedValue) public returns (bool) { 
92      allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue; 
93      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
94      return true; 
95      } 
96  
97     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) { 
98     uint oldValue = allowed[msg.sender][_spender]; 
99     if (_subtractedValue > oldValue) {
100  
101         allowed[msg.sender][_spender] = 0;
102     } 
103         else {
104         allowed[msg.sender][_spender] = oldValue - _subtractedValue;
105     }
106     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108     }
109 	
110 
111  
112     constructor() public {
113         totalSupply_ = initialSupply;
114         balances[this] = 1000000*(10**uint256(decimals));
115         
116             balances[owner] = initialSupply - balances[this];
117         Transfer(this, owner, balances[owner]);
118 		buyPrice = 0.00001 ether;
119 		owner = msg.sender;
120     }
121 }