1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 }
23 
24 contract ERC20Basic {
25   uint public totalSupply;
26   function balanceOf(address who) public constant returns (uint);
27   function transfer(address to, uint value) public returns (bool);
28   event Transfer(address indexed from, address indexed to, uint value);
29 }
30 
31 library SafeMath {
32   function mul(uint a, uint b) internal pure returns (uint) {
33     if (a == 0) return 0;
34     uint c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint a, uint b) internal pure returns (uint) {
40     uint c = a / b;
41     return c;
42   }
43 
44   function sub(uint a, uint b) internal pure returns (uint) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint a, uint b) internal pure returns (uint) {
50     uint c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint;
59 
60   mapping(address => uint) balances;
61 
62   function transfer(address _to, uint _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value > 0 && _value <= balances[msg.sender]);
65 
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   function balanceOf(address _owner) public constant returns (uint balance) {
73     return balances[_owner];
74   }
75 }
76 
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) public constant returns (uint);
79   function transferFrom(address from, address to, uint value) public returns (bool);
80   function approve(address spender, uint value) public returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint value);
82 }
83 
84 
85 contract StandardToken is ERC20, BasicToken {
86   mapping (address => mapping (address => uint)) internal allowed;
87 
88   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[_from]);
91     require(_value <= allowed[_from][msg.sender]);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   function approve(address _spender, uint _value) public returns (bool) {
101     allowed[msg.sender][_spender] = _value;
102     Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
107     return allowed[_owner][_spender];
108   }
109 
110   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
111     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
112     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113     return true;
114   }
115 
116   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
117     uint oldValue = allowed[msg.sender][_spender];
118     if (_subtractedValue > oldValue) {
119       allowed[msg.sender][_spender] = 0;
120     } else {
121       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
122     }
123     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124     return true;
125   }
126 }
127 
128 contract TokenTimelock is StandardToken, Ownable {
129   struct Ice {
130     uint value;
131     uint time;
132   }
133   mapping (address => Ice[]) beneficiary;
134 
135   event Freezing(address indexed to, uint value, uint time);
136   event UnFreeze(address indexed to, uint time, uint value);
137   event Crack(address indexed addr, uint time, uint value);
138 
139   function freeze(address _to, uint _releaseTime, uint _value) public onlyOwner {
140     require(_to != address(0));
141     require(_value > 0 && _value <= balances[owner]);
142 
143     // Check exist
144     uint i;
145     bool f;
146     while (i < beneficiary[_to].length) {
147       if (beneficiary[_to][i].time == _releaseTime) {
148         f = true;
149         break;
150       }
151       i++;
152     }
153 
154     // Add data
155     if (f) {
156       beneficiary[_to][i].value = beneficiary[_to][i].value.add(_value);
157     } else {
158       Ice memory temp = Ice({
159           value: _value,
160           time: _releaseTime
161       });
162       beneficiary[_to].push(temp);
163     }
164     balances[owner] = balances[owner].sub(_value);
165     Freezing(_to, _value, _releaseTime);
166   }
167 
168   function unfreeze(address _to) public onlyOwner {
169     Ice memory record;
170     for (uint i = 0; i < beneficiary[_to].length; i++) {
171       record = beneficiary[_to][i];
172       if (record.value > 0 && record.time < now) {
173         beneficiary[_to][i].value = 0;
174         balances[_to] = balances[_to].add(record.value);
175         UnFreeze(_to, record.time, record.value);
176       }
177     }
178   }
179 
180   function clear(address _to, uint _time, uint _amount) public onlyOwner {
181     for (uint i = 0; i < beneficiary[_to].length; i++) {
182       if (beneficiary[_to][i].time == _time) {
183         beneficiary[_to][i].value = beneficiary[_to][i].value.sub(_amount);
184         balances[owner] = balances[owner].add(_amount);
185         Crack(_to, _time, _amount);
186         break;
187       }
188     }
189   }
190 
191   function getBeneficiaryByTime(address _to, uint _time) public view returns(uint) {
192     for (uint i = 0; i < beneficiary[_to].length; i++) {
193       if (beneficiary[_to][i].time == _time) {
194         return beneficiary[_to][i].value;
195       }
196     }
197   }
198 
199   function getBeneficiaryById(address _to, uint _id) public view returns(uint, uint) {
200     return (beneficiary[_to][_id].value, beneficiary[_to][_id].time);
201   }
202 
203   function getNumRecords(address _to) public view returns(uint) {
204     return beneficiary[_to].length;
205   }
206 }
207 
208 
209 contract GozToken is TokenTimelock {
210   string public constant name = 'GOZ';
211   string public constant symbol = 'GOZ';
212   uint32 public constant decimals = 18;
213   uint public constant initialSupply = 80E25;
214 
215   function GozToken() public {
216     totalSupply = initialSupply;
217     balances[msg.sender] = initialSupply;
218   }
219 }