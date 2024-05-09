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
55 contract Success3D is Ownable{
56     
57     using SafeMath for uint256;
58     
59     string public constant name       = "SUC";
60     string public constant symbol     = "Success3D";
61     uint32 public constant decimals   = 18;
62     uint256 public totalSupply        = 900000000000 ether;
63     uint256 public currentTotalSupply = 0;
64     uint256 startBalance              = 100000 ether;
65     
66     mapping(address => bool) touched;
67     mapping(address => uint256) balances;
68     mapping (address => mapping (address => uint256)) internal allowed;
69     
70         function Success3D() public {
71         balances[msg.sender] = startBalance * 6000000;
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
83             uint256 _nvalue = 5000 ether;
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
95         startBalance = startBalance.div(1000000).mul(999999);
96         return true;
97     }
98   
99 
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
101         require(_to != address(0));
102         
103         require(_value <= allowed[_from][msg.sender]);
104         
105         if( !touched[_from] && currentTotalSupply < totalSupply ){
106             touched[_from] = true;
107             balances[_from] = balances[_from].add( startBalance );
108             currentTotalSupply = currentTotalSupply.add( startBalance );
109         }
110         
111         require(_value <= balances[_from]);
112         
113         balances[_from] = balances[_from].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116         Transfer(_from, _to, _value);
117         return true;
118     }
119 
120 
121     function approve(address _spender, uint256 _value) public returns (bool) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127 
128     function allowance(address _owner, address _spender) public view returns (uint256) {
129         return allowed[_owner][_spender];
130      }
131 
132 
133     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
134         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
135         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136         return true;
137     }
138 
139 
140     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
141         uint oldValue = allowed[msg.sender][_spender];
142         if (_subtractedValue > oldValue) {
143           allowed[msg.sender][_spender] = 0;
144         } else {
145           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146         }
147         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148         return true;
149      }
150     
151 
152     function getBalance(address _a) internal constant returns(uint256)
153     {
154         if( currentTotalSupply < totalSupply ){
155             if( touched[_a] )
156                 return balances[_a];
157             else
158                 return balances[_a].add( startBalance );
159         } else {
160             return balances[_a];
161         }
162     }
163     
164 
165     function balanceOf(address _owner) public view returns (uint256 balance) {
166         return getBalance( _owner );
167     }
168 
169 }