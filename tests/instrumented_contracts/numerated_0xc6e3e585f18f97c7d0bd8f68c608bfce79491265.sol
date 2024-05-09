1 pragma solidity ^0.4.21;
2 
3 contract simpleToken {
4 
5     uint256 totalSupply_; 
6     string public constant name = "VINCI";
7     string public constant symbol = "VINCI";
8     uint8 public constant decimals = 10;
9     uint256 public constant initialSupply = 600000000*(10**uint256(decimals));
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 
14     mapping (address => uint256) balances; 
15     mapping (address => mapping (address => uint256)) allowed;
16     
17     function totalSupply() public view returns (uint256){
18         return totalSupply_;
19     }
20 
21     function balanceOf(address _owner) public view returns (uint256){
22         return balances[_owner];
23     }
24 
25     function allowance(address _owner, address _spender) public view returns (uint256) {
26         return allowed[_owner][_spender];
27   }
28 
29     function transfer(address _to, uint256 _value) public returns (bool ) {
30         require(_to != address(0));
31         require(balances[msg.sender] >= _value); 
32         balances[msg.sender] = balances[msg.sender] - _value; 
33         balances[_to] = balances[_to] + _value; 
34         emit Transfer(msg.sender, _to, _value);
35         return true;
36     }
37 
38     function approve(address _spender, uint256 _value) public returns (bool) {
39         allowed[msg.sender][_spender] = _value;
40         emit Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
45         require(_to != address(0));
46         require(_value <= balances[_from]);
47         require(_value <= allowed[_from][msg.sender]); 
48         balances[_from] = balances[_from] - _value; 
49         balances[_to] = balances[_to] + _value; 
50         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value; 
51         emit Transfer(_from, _to, _value); 
52         return true; 
53         } 
54 
55      function increaseApproval(address _spender, uint _addedValue) public returns (bool) { 
56      allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue; 
57      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
58      return true; 
59      } 
60  
61     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) { 
62     uint oldValue = allowed[msg.sender][_spender]; 
63     if (_subtractedValue > oldValue) {
64 
65         allowed[msg.sender][_spender] = 0;
66     } 
67         else {
68         allowed[msg.sender][_spender] = oldValue - _subtractedValue;
69     }
70     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
71     return true;
72     }
73 
74     function simpleToken() public {
75         totalSupply_ = initialSupply;
76         balances[msg.sender] = initialSupply;
77         emit Transfer(0x0, msg.sender, initialSupply);
78     }
79 }