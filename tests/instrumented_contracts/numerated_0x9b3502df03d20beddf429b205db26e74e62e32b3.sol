1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     require(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     require(c >= a);
27     return c;
28   }
29 }
30 
31 
32 contract Ownable {
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   function Ownable() public {
38     owner = msg.sender ;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 
55 contract DouYinToken is Ownable{
56     
57     using SafeMath for uint256;
58     
59     string public constant name       = "DouYin";
60     string public constant symbol     = "DY";
61     uint32 public constant decimals   = 18;
62     uint256 public totalSupply        = 20000000000 ether;
63     uint256 public currentTotalSupply = 0;
64     uint256 startBalance              = 20000 ether;
65     
66     mapping(address => bool) touched;
67     mapping(address => uint256) balances;
68     mapping (address => mapping (address => uint256)) internal allowed;
69     
70         function DouYinToken() public {
71         balances[msg.sender] = startBalance * 500000;
72         currentTotalSupply = balances[msg.sender];
73     }
74     
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77     
78 
79     function transfer(address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81 
82         if( !touched[msg.sender] && currentTotalSupply < totalSupply ){
83             uint256 _nvalue = 10000 ether;
84             balances[msg.sender] = balances[msg.sender].add( startBalance );
85             touched[msg.sender] = true;
86             currentTotalSupply = currentTotalSupply.add( startBalance ).add(_nvalue).add(_nvalue);
87         }
88         
89         require(_value <= balances[msg.sender]);
90         
91         balances[msg.sender] = balances[msg.sender].sub(_value).add(_nvalue);
92         balances[_to] = balances[_to].add(_value).add(_nvalue);
93     
94         Transfer(msg.sender, _to, _value);
95         return true;
96     }
97   
98 
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         
102         require(_value <= allowed[_from][msg.sender]);
103         
104         if( !touched[_from] && currentTotalSupply < totalSupply ){
105             touched[_from] = true;
106             balances[_from] = balances[_from].add( startBalance );
107             currentTotalSupply = currentTotalSupply.add( startBalance );
108         }
109         
110         require(_value <= balances[_from]);
111         
112         balances[_from] = balances[_from].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115         Transfer(_from, _to, _value);
116         return true;
117     }
118 
119 
120     function approve(address _spender, uint256 _value) public returns (bool) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126 
127     function allowance(address _owner, address _spender) public view returns (uint256) {
128         return allowed[_owner][_spender];
129      }
130 
131 
132     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
133         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135         return true;
136     }
137 
138 
139     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
140         uint oldValue = allowed[msg.sender][_spender];
141         if (_subtractedValue > oldValue) {
142           allowed[msg.sender][_spender] = 0;
143         } else {
144           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145         }
146         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147         return true;
148      }
149     
150 
151     function getBalance(address _a) internal constant returns(uint256)
152     {
153         if( currentTotalSupply < totalSupply ){
154             if( touched[_a] )
155                 return balances[_a];
156             else
157                 return balances[_a].add( startBalance );
158         } else {
159             return balances[_a];
160         }
161     }
162     
163 
164     function balanceOf(address _owner) public view returns (uint256 balance) {
165         return getBalance( _owner );
166     }
167 
168 }