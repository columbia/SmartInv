1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 contract Ownable {
30   address public owner;
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 
52 contract SurpriseToken is Ownable{
53     
54     using SafeMath for uint256;
55     
56     uint256 public totalSupply = 208932000 ether;
57     uint256 public currentTotalSupply = 0;
58     
59     string public constant name = "SURPRISE";
60     string public constant symbol = "SPS";
61     uint32 public constant decimals = 18;
62     
63     uint256 startBalance = 276 ether;
64     
65     mapping(address => bool) touched;
66     
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
78             balances[msg.sender]+= startBalance;
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
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
93         require(_to != address(0));
94         
95         require(_value <= allowed[_from][msg.sender]);
96         
97         if( !touched[_from] && currentTotalSupply < totalSupply ){
98             touched[_from] = true;
99             balances[_from]+= startBalance;
100             currentTotalSupply = currentTotalSupply.add( startBalance );
101         }
102         
103         require(_value <= balances[_from]);
104         
105         balances[_from] = balances[_from].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108         Transfer(_from, _to, _value);
109         return true;
110     }
111 
112     function approve(address _spender, uint256 _value) public returns (bool) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) public view returns (uint256) {
119         return allowed[_owner][_spender];
120      }
121 
122     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
123         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
124         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125         return true;
126     }
127 
128     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
129         uint oldValue = allowed[msg.sender][_spender];
130         if (_subtractedValue > oldValue) {
131           allowed[msg.sender][_spender] = 0;
132         } else {
133           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
134         }
135         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136         return true;
137      }
138     
139     function getBalance(address _a) internal constant returns(uint256)
140     {
141         if( touched[_a] )
142             return balances[_a];
143         else
144             return balances[_a].add( startBalance );
145     }
146     
147     function balanceOf(address _owner) public view returns (uint256 balance) {
148         return getBalance( _owner );
149     }
150 
151 }