1 pragma solidity 0.4.16;
2 
3 contract ERC20Interface {
4     function totalSupply() constant returns (uint256 total);
5 
6     function balanceOf(address _who) constant returns (uint256 balance);
7 
8     function transfer(address _to, uint256 _value) returns (bool success);
9 
10     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11 
12     function approve(address _spender, uint256 _value) returns (bool success);
13 
14     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 contract CrypotaTestToken is ERC20Interface {
21     using SafeMath for uint256;
22 
23     string public name = "CrypotaPay Token 3";
24     string public symbol = "CTT3";
25 
26     uint256 public totalSupply = 1000000;
27     uint8 public decimals = 0;
28 
29     address public owner;
30 
31     mapping(address => uint256) balances;
32     mapping(address => mapping (address => uint256)) allowed;
33  
34     uint256 public totalPayments;
35     mapping(address => uint256) public payments;
36 
37     bool public paused = false;
38 
39     uint256 reclaimAmount;
40 
41     event Burn(address indexed burner, uint indexed value);
42     event Mint(address indexed to, uint256 amount);
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44     event PaymentForTest(address indexed to, uint256 amount);
45     event WithdrawPaymentForTest(address indexed to, uint256 amount);
46 
47     event Pause();
48     event Unpause();
49 
50     modifier whenNotPaused() {
51         require(!paused);
52         _;
53     }
54 
55     modifier whenPaused() {
56         require(paused);
57         _;
58     }
59 
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function CrypotaTestToken() {
66         owner = msg.sender;
67         balances[owner] = 1000000;
68     }
69 
70     function totalSupply() constant returns (uint256 total) {
71         return totalSupply;
72     }
73 
74     function balanceOf(address _who) constant returns (uint256 balance) {
75         return balances[_who];
76     }
77 
78     function transfer(address _to, uint256 _value) whenNotPaused returns (bool success) {
79         require(_to != address(0));
80 
81         balances[msg.sender] = balances[msg.sender].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool success) {
88         require(_to != address(0));
89 
90         var _allowance = allowed[_from][msg.sender];
91 
92         balances[_from] = balances[_from].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         allowed[_from][msg.sender] = _allowance.sub(_value);
95         Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function approve(address _spender, uint256 _value) whenNotPaused returns (bool success) {
100         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
101 
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
108         return allowed[_owner][_spender];
109     }
110 
111     function increaseApproval (address _spender, uint _addedValue) whenNotPaused returns (bool success) {
112         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114         return true;
115     }
116 
117     function decreaseApproval (address _spender, uint _subtractedValue) whenNotPaused returns (bool success) {
118 
119         uint oldValue = allowed[msg.sender][_spender];
120         if (_subtractedValue > oldValue) {
121             allowed[msg.sender][_spender] = 0;
122         } else {
123             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124         }
125         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126         return true;
127     }
128 
129     function burn(uint _value) returns (bool success)
130     {
131         require(_value > 0);
132 
133         address burner = msg.sender;
134         balances[burner] = balances[burner].sub(_value);
135         totalSupply = totalSupply.sub(_value);
136         Burn(burner, _value);
137         return true;
138     }
139 
140     function mint(address _to, uint256 _amount) onlyOwner returns (bool success) {
141         totalSupply = totalSupply.add(_amount);
142         balances[_to] = balances[_to].add(_amount);
143         Mint(_to, _amount);
144         Transfer(0x0, _to, _amount);
145         return true;
146     }
147 
148     function () payable {
149 
150     }
151 
152     function pause() onlyOwner whenNotPaused {
153         paused = true;
154         Pause();
155     }
156 
157     function unpause() onlyOwner whenPaused {
158         paused = false;
159         Unpause();
160     }
161 
162     function destroy() onlyOwner {
163         selfdestruct(owner);
164     }
165 
166     function transferOwnership(address newOwner) onlyOwner {
167         require(newOwner != address(0));
168         OwnershipTransferred(owner, newOwner);
169         owner = newOwner;
170     }
171 
172     function reclaimToken(ERC20Interface token) external onlyOwner {
173         reclaimAmount = token.balanceOf(this);
174         token.transfer(owner, reclaimAmount);
175         reclaimAmount = 0;
176     }
177 
178     function asyncSend(address _to, uint256 _amount) onlyOwner {
179         payments[_to] = payments[_to].add(_amount);
180         totalPayments = totalPayments.add(_amount);
181         PaymentForTest(_to, _amount);
182     }
183 
184     function withdrawPayments() {
185         address payee = msg.sender;
186         uint256 payment = payments[payee];
187 
188         require(payment != 0);
189         require(this.balance >= payment);
190 
191         totalPayments = totalPayments.sub(payment);
192         payments[payee] = 0;
193 
194         payee.transfer(payment);
195         WithdrawPaymentForTest(msg.sender, payment);
196     }
197 
198     function withdrawToAdress(address _to, uint256 _amount) onlyOwner {
199         require(_to != address(0));
200         require(this.balance >= _amount);
201         _to.transfer(_amount);
202     }
203 
204 }
205 
206 library SafeMath {
207     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
208         uint256 c = a * b;
209         assert(a == 0 || c / a == b);
210         return c;
211     }
212 
213     function div(uint256 a, uint256 b) internal constant returns (uint256) {
214         uint256 c = a / b;
215         return c;
216     }
217 
218     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
219         assert(b <= a);
220         return a - b;
221     }
222 
223     function add(uint256 a, uint256 b) internal constant returns (uint256) {
224         uint256 c = a + b;
225         assert(c >= a);
226         return c;
227     }
228 }