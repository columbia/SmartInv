1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 
28 
29 contract ERC20Basic {
30     uint256 public totalSupply;
31     function balanceOf(address who) public view returns (uint256);
32     function transfer(address to, uint256 value) public returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37     function allowance(address owner, address spender) public view returns (uint256);
38     function transferFrom(address from, address to, uint256 value) public returns (bool);
39     function approve(address spender, uint256 value) public returns (bool);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract RGOinterface {
44     
45      function RGOFallback(address _from, uint _value, uint _code);
46     
47 }
48 
49 contract RGO is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53   
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57     mapping (address => bool) public blacklist;
58 
59     string public constant name = "RGO CHAIN";
60     string public constant symbol = "RGO";
61     uint public constant decimals = 8;
62     uint256 public totalSupply = 100000000e8;
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66     
67    
68    
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73     
74  
75     
76     function RGO () public {
77         owner = msg.sender;
78         balances[owner]= 100000000e8;
79         Transfer(address(0), owner, 100000000e8);
80     }
81     
82     function transferOwnership(address newOwner) onlyOwner public {
83         if (newOwner != address(0)) {
84             owner = newOwner;
85         }
86     }
87   
88     function () public payable {
89     }
90     
91    
92    
93     function balanceOf(address _owner)public view  returns (uint256) {
94         return balances[_owner];
95     }
96 
97     // mitigates the ERC20 short address attack
98     modifier onlyPayloadSize(uint size) {
99         assert(msg.data.length >= size + 4);
100         _;
101     }
102     
103  
104     
105     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
106         require(_to != address(0));
107         require(_amount <= balances[_from]);
108         require(_amount <= allowed[_from][msg.sender]);
109         
110         balances[_from] = balances[_from].sub(_amount);
111         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
112         balances[_to] = balances[_to].add(_amount);
113         Transfer(_from, _to, _amount);
114         return true;
115     }
116     
117     function approve(address _spender, uint256 _value) public returns (bool success) {
118         // mitigates the ERC20 spend/approval race condition
119         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124     
125     function allowance(address _owner, address _spender) view public returns (uint256) {
126         return allowed[_owner][_spender];
127     }
128     
129     
130     
131     function withdraw() onlyOwner public {
132         uint256 etherBalance = this.balance;
133         owner.transfer(etherBalance);
134     }
135     function transfer(address _to, uint _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[msg.sender]);
138     
139     // SafeMath.sub will throw if there is not enough balance.
140         if(!isContract(_to)){
141             balances[msg.sender] = balances[msg.sender].sub(_value);
142             balances[_to] = balances[_to].add(_value);
143             Transfer(msg.sender, _to, _value);
144             return true;
145             }
146         else{
147             balances[msg.sender] = balanceOf(msg.sender).sub(_value);
148             balances[_to] = balanceOf(_to).add(_value);
149             RGOinterface receiver = RGOinterface(_to);
150             receiver.RGOFallback(msg.sender, _value, 0);
151             Transfer(msg.sender, _to, _value);
152             return true;
153         }
154     }
155 
156     function transfer(address _to, uint _value,uint _code) public returns (bool) {
157         require(_to != address(0));
158         require(_value <= balances[msg.sender]);
159     
160     // SafeMath.sub will throw if there is not enough balance.
161         if(!isContract(_to)){
162             balances[msg.sender] = balances[msg.sender].sub(_value);
163             balances[_to] = balances[_to].add(_value);
164             Transfer(msg.sender, _to, _value);
165             return true;
166         }
167         else{
168             balances[msg.sender] = balanceOf(msg.sender).sub(_value);
169             balances[_to] = balanceOf(_to).add(_value);
170             RGOinterface receiver = RGOinterface(_to);
171             receiver.RGOFallback(msg.sender, _value, _code);
172             Transfer(msg.sender, _to, _value);
173             return true;
174         }
175     }
176     
177 
178     function isContract(address _addr) private returns (bool is_contract) {
179     uint length;
180     assembly {
181         //retrieve the size of the code on target address, this needs assembly
182         length := extcodesize(_addr)
183     }
184     return (length>0);
185   }
186 
187 
188 }