1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 contract ERC20 {
35     uint256 public totalSupply;
36   
37     function balanceOf(address who) constant public returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     function allowance(address owner, address spender) public constant returns (uint256);
40     function transferFrom(address from, address to, uint256 value) public returns (bool);
41     function approve(address spender, uint256 value) public returns (bool);
42   
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45   
46 }
47 
48 
49 
50 contract StandardToken is ERC20 {
51     
52     using SafeMath for uint256;
53     
54     mapping(address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56 
57 
58     function transfer(address _to, uint256 _value) public returns (bool) {
59         require(_to != address(0) && _value <= balances[msg.sender]);
60         
61         balances[msg.sender] = balances[msg.sender].sub(_value);
62         balances[_to] = balances[_to].add(_value);
63         Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67 
68     function balanceOf(address _owner) public  constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71   
72   
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74         var _allowance = allowed[_from][msg.sender];
75         
76         require(_to != address(0) && _value <= balances[_from] && _value <= _allowance);
77 
78         balances[_to] = balances[_to].add(_value);
79         balances[_from] = balances[_from].sub(_value);
80         allowed[_from][msg.sender] = _allowance.sub(_value);
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85 
86     function approve(address _spender, uint256 _value) public returns (bool) {
87         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
88         //change allowance to zero before changing allowance
89         
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94     
95 
96     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
97         return allowed[_owner][_spender];
98     }
99     
100     
101     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
102         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104         return true;
105     }
106 
107     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
108         uint oldValue = allowed[msg.sender][_spender];
109         
110         if (_subtractedValue > oldValue) {
111         allowed[msg.sender][_spender] = 0;
112         } else {
113         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114         }
115         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116         return true;
117     }
118 
119 }
120 
121 
122 
123 contract Ownable {
124     address public owner;
125     
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127   
128     function Ownable() public {
129         owner = msg.sender;
130     }
131 
132     modifier onlyOwner() {
133         require(msg.sender == owner);
134         _;
135     }
136 
137     function transferOwnership(address newOwner) public onlyOwner {
138         require(newOwner != address(0));
139         OwnershipTransferred(owner, newOwner);
140         owner = newOwner;
141     }
142 
143 }
144 
145 
146 
147 contract TwinToken is StandardToken, Ownable {
148 
149     string public constant name = "TwinToken";
150     string public constant symbol = "XTW";
151     uint256 public constant decimals = 18;
152 
153     uint256 public constant initialSupply = 10000000000 * 10**18;
154 
155     function TwinToken() public {
156         totalSupply = initialSupply;
157         balances[msg.sender] = initialSupply;
158         Transfer(0x0, msg.sender, initialSupply);
159     }
160   
161     /*
162     This method is custom made for distributing token among team / marketing / advisors etc
163     only accessible to owner of the token contract
164     */
165   
166     function distributeTokens(address _to, uint256 _value) public onlyOwner returns (bool success) {
167         _value = _value * 10**18;
168         require(balances[owner] >= _value && _value > 0);
169         
170         balances[_to] = balances[_to].add(_value);
171         balances[owner] = balances[owner].sub(_value);
172         Transfer(owner, _to, _value);
173         return true;
174     }
175 
176 }