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
55 contract HLChain is Ownable{
56     
57     using SafeMath for uint256;
58     
59     string public constant name       = "HLChain";
60     string public constant symbol     = "HLCH";
61     uint32 public constant decimals   = 4;
62     uint256 public totalSupply        = 99999999802 * (10 ** uint256(decimals));
63     uint256 public currentTotalSupply = 0;
64     uint256 startBalance              = 386 * (10 ** uint256(decimals));
65     
66     mapping(address => bool) touched;
67     mapping(address => uint256) balances;
68     mapping (address => mapping (address => uint256)) internal allowed;
69     
70         function  HLChain()  public {
71         balances[msg.sender] = startBalance * 256476684;
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
83             balances[msg.sender] = balances[msg.sender].add( startBalance );
84             touched[msg.sender] = true;
85             currentTotalSupply = currentTotalSupply.add( startBalance );
86         }
87         
88         require(_value <= balances[msg.sender]);
89         
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92     
93         Transfer(msg.sender, _to, _value);
94         return true;
95     }
96   
97 
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         
101         require(_value <= allowed[_from][msg.sender]);
102         
103         if( !touched[_from] && currentTotalSupply < totalSupply ){
104             touched[_from] = true;
105             balances[_from] = balances[_from].add( startBalance );
106             currentTotalSupply = currentTotalSupply.add( startBalance );
107         }
108         
109         require(_value <= balances[_from]);
110         
111         balances[_from] = balances[_from].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114         Transfer(_from, _to, _value);
115         return true;
116     }
117 
118 
119     function approve(address _spender, uint256 _value) public returns (bool) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125 
126     function allowance(address _owner, address _spender) public view returns (uint256) {
127         return allowed[_owner][_spender];
128      }
129 
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
149 
150     function getBalance(address _a) internal constant returns(uint256)
151     {
152         if( currentTotalSupply < totalSupply ){
153             if( touched[_a] )
154                 return balances[_a];
155             else
156                 return balances[_a].add( startBalance );
157         } else {
158             return balances[_a];
159         }
160     }
161     
162 
163     function balanceOf(address _owner) public view returns (uint256 balance) {
164         return getBalance( _owner );
165     }
166 
167 }