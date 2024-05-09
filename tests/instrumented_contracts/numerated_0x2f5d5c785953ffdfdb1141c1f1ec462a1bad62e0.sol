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
38     owner = msg.sender;
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
55 contract NitroCoin is Ownable{
56     
57     using SafeMath for uint256;
58     
59     string public constant name       = "NitroCoin";
60     string public constant symbol     = "NRC";
61     uint32 public constant decimals   = 18;
62     uint256 public totalSupply        = 25000000 ether;
63     uint256 public currentTotalSupply = 0;
64     uint256 startBalance              = 10 ether;
65     
66     mapping(address => bool) touched;
67     mapping(address => uint256) balances;
68     mapping (address => mapping (address => uint256)) internal allowed;
69     
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72     
73 
74     function transfer(address _to, uint256 _value) public returns (bool) {
75         require(_to != address(0));
76 
77         if( !touched[msg.sender] && currentTotalSupply < totalSupply ){
78             balances[msg.sender] = balances[msg.sender].add( startBalance );
79             touched[msg.sender] = true;
80             currentTotalSupply = currentTotalSupply.add( startBalance );
81         }
82         
83         require(_value <= balances[msg.sender]);
84         
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87     
88         Transfer(msg.sender, _to, _value);
89         return true;
90     }
91   
92 
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
94         require(_to != address(0));
95         
96         require(_value <= allowed[_from][msg.sender]);
97         
98         if( !touched[_from] && currentTotalSupply < totalSupply ){
99             touched[_from] = true;
100             balances[_from] = balances[_from].add( startBalance );
101             currentTotalSupply = currentTotalSupply.add( startBalance );
102         }
103         
104         require(_value <= balances[_from]);
105         
106         balances[_from] = balances[_from].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109         Transfer(_from, _to, _value);
110         return true;
111     }
112 
113 
114     function approve(address _spender, uint256 _value) public returns (bool) {
115         allowed[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120 
121     function allowance(address _owner, address _spender) public view returns (uint256) {
122         return allowed[_owner][_spender];
123      }
124 
125 
126     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
127         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
128         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129         return true;
130     }
131 
132 
133     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
134         uint oldValue = allowed[msg.sender][_spender];
135         if (_subtractedValue > oldValue) {
136           allowed[msg.sender][_spender] = 0;
137         } else {
138           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
139         }
140         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141         return true;
142      }
143     
144 
145     function getBalance(address _a) internal constant returns(uint256)
146     {
147         if( currentTotalSupply < totalSupply ){
148             if( touched[_a] )
149                 return balances[_a];
150             else
151                 return balances[_a].add( startBalance );
152         } else {
153             return balances[_a];
154         }
155     }
156     
157 
158     function balanceOf(address _owner) public view returns (uint256 balance) {
159         return getBalance( _owner );
160     }
161 }