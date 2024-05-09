1 pragma solidity ^0.4.24;
2  
3 contract TSCoin {
4  
5     uint256 totalSupply_; 
6     string public constant name = "TS Coin";
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
69     function approve(address _spender, uint256 _value) public returns (bool) {
70         allowed[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72         return true;
73     }
74  
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76         require(_to != address(0));
77         require(_value <= balances[_from]);
78         require(_value <= allowed[_from][msg.sender]); 
79         balances[_from] = balances[_from] - _value; 
80         balances[_to] = balances[_to] + _value; 
81         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value; 
82         emit Transfer(_from, _to, _value); 
83         return true; 
84         } 
85  
86      function increaseApproval(address _spender, uint _addedValue) public returns (bool) { 
87      allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue; 
88      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
89      return true; 
90      } 
91  
92     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) { 
93         uint oldValue = allowed[msg.sender][_spender]; 
94         if (_subtractedValue > oldValue) {
95      
96             allowed[msg.sender][_spender] = 0;
97         } 
98             else {
99             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
100         }
101         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102         return true;
103     }
104     
105 	
106 
107  
108     constructor(uint256 prices) public {
109         totalSupply_ = initialSupply;
110         balances[msg.sender] = initialSupply;
111         
112 		buyPrice = prices;
113 		owner = msg.sender;
114     }
115 }