1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c>=a && c>=b);
23         return c;
24     }
25 }
26 
27 
28 contract Ownable {
29     
30     address public owner;
31     
32      constructor() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40     
41     modifier onlyPayloadSize(uint size) {
42         assert(msg.data.length >= size + 4);
43         _;
44     }
45 }
46 
47 
48 contract RDCCOIN is Ownable{
49 
50     using SafeMath for uint;
51     string public name;     
52     string public symbol;
53     uint8 public decimals;  
54     uint private _totalSupply;
55     uint public basisPointsRate = 0;
56     uint public minimumFee = 0;
57     uint public maximumFee = 0;
58 
59     mapping (address => uint256) internal balances;
60     mapping (address => mapping (address => uint256)) internal allowed;
61     
62     event Transfer(
63         address indexed from,
64         address indexed to,
65         uint256 value
66     );
67     
68     event Approval(
69         address indexed _owner,
70         address indexed _spender,
71         uint256 _value
72     );
73     
74     event Params(
75         uint feeBasisPoints,
76         uint maximumFee,
77         uint minimumFee
78     );
79     
80     event Issue(
81         uint amount
82     );
83 
84     event Redeem(
85         uint amount
86     );
87     
88 
89     constructor () public {
90         name = 'RIDDLE COIN'; 
91         symbol = 'RDC'; 
92         decimals = 18; 
93         _totalSupply = 600000000 * 10**uint(decimals); 
94         balances[msg.sender] = _totalSupply;
95     }
96     
97 
98     function totalSupply() public view returns (uint256) {
99         return _totalSupply;
100     }
101    
102   
103     function balanceOf(address owner) public view returns (uint256) {
104         return balances[owner];
105     }
106    
107     function transfer(address _to, uint256  _value) public onlyPayloadSize(2 * 32){
108         uint fee = (_value.mul(basisPointsRate)).div(1000);
109         if (fee > maximumFee) {
110             fee = maximumFee;
111         }
112         if (fee < minimumFee) {
113             fee = minimumFee;
114         }
115         require (_to != 0x0);
116 
117         require(_to != address(0));
118 
119         require (_value > 0); 
120 
121         require (balances[msg.sender] > _value);
122 
123         require (balances[_to].add(_value) > balances[_to]);
124 
125         uint sendAmount = _value.sub(fee);
126 
127         balances[msg.sender] = balances[msg.sender].sub(_value);
128 
129         balances[_to] = balances[_to].add(sendAmount); 
130 
131         if (fee > 0) {
132             balances[owner] = balances[owner].add(fee);
133             emit Transfer(msg.sender, owner, fee);
134         }
135 
136         emit Transfer(msg.sender, _to, _value);
137     }
138     
139   
140     function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
141 
142         require (_value > 0);
143 
144         require (balances[owner] > _value);
145 
146         require (_spender != msg.sender);
147 
148         allowed[msg.sender][_spender] = _value;
149 
150         emit Approval(msg.sender,_spender, _value);
151         return true;
152     }
153     
154  
155     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
156 
157         uint fee = (_value.mul(basisPointsRate)).div(1000);
158         if (fee > maximumFee) {
159                 fee = maximumFee;
160         }
161         if (fee < minimumFee) {
162             fee = minimumFee;
163         }
164 
165         require (_to != 0x0);
166 
167         require(_to != address(0));
168 
169         require (_value > 0); 
170 
171         require(_value < balances[_from]);
172 
173         require (balances[_to].add(_value) > balances[_to]);
174 
175         require (_value <= allowed[_from][msg.sender]);
176         uint sendAmount = _value.sub(fee);
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(sendAmount);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180         if (fee > 0) {
181             balances[owner] = balances[owner].add(fee);
182             emit Transfer(_from, owner, fee);
183         }
184         emit Transfer(_from, _to, sendAmount);
185         return true;
186     }
187     
188 
189     function allowance(address _from, address _spender) public view returns (uint remaining) {
190         return allowed[_from][_spender];
191     }
192     
193   
194     function setParams(uint newBasisPoints,uint newMaxFee,uint newMinFee) public onlyOwner {
195         require(newBasisPoints <= 9);
196         require(newMaxFee <= 100);
197         require(newMinFee <= 5);
198         basisPointsRate = newBasisPoints;
199         maximumFee = newMaxFee.mul(10**uint(decimals));
200         minimumFee = newMinFee.mul(10**uint(decimals));
201         emit Params(basisPointsRate, maximumFee, minimumFee);
202     }
203 
204     function increaseSupply(uint amount) public onlyOwner {
205         require(amount <= 10000000);
206         amount = amount.mul(10**uint(decimals));
207         require(_totalSupply.add(amount) > _totalSupply);
208         require(balances[owner].add(amount) > balances[owner]);
209         balances[owner] = balances[owner].add(amount);
210         _totalSupply = _totalSupply.add(amount);
211         emit Issue(amount);
212     }
213     
214 
215     function decreaseSupply(uint amount) public onlyOwner {
216         require(amount <= 10000000);
217         amount = amount.mul(10**uint(decimals));
218         require(_totalSupply >= amount);
219         require(balances[owner] >= amount);
220         _totalSupply = _totalSupply.sub(amount);
221         balances[owner] = balances[owner].sub(amount);
222         emit Redeem(amount);
223     }
224 }