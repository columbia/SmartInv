1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     require(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     require(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     require(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
34 
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   function transferOwnership(address _newOwner) public onlyOwner {
45     require(_newOwner != address(0));
46     OwnershipTransferred(owner, _newOwner);
47     owner = _newOwner;
48   }
49 
50 }
51 
52 
53 contract VitManToken is Ownable {
54     using SafeMath for uint256;
55      
56     string public constant name       = "VitMan";
57     string public constant symbol     = "VITMAN";
58     uint32 public constant decimals   = 18;
59     
60     uint256 public totalSupply        = 100000000000 ether;
61     uint256 public currentTotalSupply = 0;
62     uint256 public startBalance       = 2018 ether;
63 
64     
65     mapping(address => bool) touched;
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68     
69      
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72     event Burn(address indexed from, uint256 value);
73     
74   
75     function _touched(address _address) internal returns(bool) {
76          if( !touched[_address] && _address!=owner){
77             balances[_address] = balances[_address].add( startBalance );
78             currentTotalSupply = currentTotalSupply.add( startBalance );
79             touched[_address] = true;
80             return true;
81         }else{
82             return false;
83         }
84     }
85 
86     
87     function VitManToken() public {
88         balances[msg.sender] = totalSupply; // Give the creator all initial tokens
89     }
90 
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         //Default assumes totalSupply can't be over max (2^256 - 1).
93         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
94         //Replace the if with this one instead.
95         _touched(msg.sender);
96         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
97             balances[msg.sender] -= _value;
98             balances[_to] += _value;
99             Transfer(msg.sender, _to, _value);
100             return true;
101         } else { return false; }
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         //Same as above. Replace this line with the following if you want to protect against wrapping uints.
106         _touched(_from);
107         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
108             balances[_to] += _value;
109             balances[_from] -= _value;
110             allowed[_from][msg.sender] -= _value;
111             Transfer(_from, _to, _value);
112             return true;
113         } else { return false; }
114     }
115 
116     function balanceOf(address _owner) public returns (uint256 balance) {
117        _touched(_owner);
118          return balances[_owner];
119     }
120 
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
128       return allowed[_owner][_spender];
129     }
130 
131     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
132         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
133         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134         return true;
135     }
136 
137 
138     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
139         uint oldValue = allowed[msg.sender][_spender];
140         if (_subtractedValue > oldValue) {
141           allowed[msg.sender][_spender] = 0;
142         } else {
143           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
144         }
145         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146         return true;
147      }
148      
149      function burn(uint256 _value) public returns (bool success) {
150         require(balances[msg.sender] >= _value);   
151         balances[msg.sender] -= _value;            
152         totalSupply -= _value;                      
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
158         require(balances[_from] >= _value);                
159         require(allowed[_from][msg.sender]>=_value);    
160         balances[_from] -= _value;                         
161         allowed[_from][msg.sender] -= _value;             
162         totalSupply -= _value;                              
163         Burn(_from, _value);
164         return true;
165     }
166     
167      function mint(address _target, uint256 _mintedAmount) onlyOwner public {
168         require(_target!=address(0));
169         balances[_target] += _mintedAmount;
170         totalSupply += _mintedAmount;
171         Transfer(0, this, _mintedAmount);
172         Transfer(this, _target, _mintedAmount);
173     }
174  
175      
176     function setStartBalance(uint256 _startBalance) onlyOwner public {
177         require(_startBalance>=0);
178         startBalance=_startBalance * 1 ether;
179     }
180     
181 }