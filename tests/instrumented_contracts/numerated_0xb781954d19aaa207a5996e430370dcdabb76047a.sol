1 pragma solidity ^0.4.18;
2 
3 library SafeOpt {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b > 0); 
15         uint256 c = a / b;
16         assert(a == b * c);
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a - b;
22         assert(b <= a);
23         assert(a == c + b);
24         return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         assert(a == c - b);
31         return c;
32     }
33 }
34 contract TTDTokenIssue {
35     uint256 public lastYearTotalSupply = 15 * 10 ** 26; 
36     uint8   public affectedCount = 0;
37     bool    public initialYear = true; 
38 	//uint16  public blockHeight = 2102400;
39 	address public tokenContractAddress;
40     uint16  public preRate = 1000; 
41     uint256 public lastBlockNumber;
42 
43     function TTDTokenIssue (address _tokenContractAddress) public{
44         tokenContractAddress = _tokenContractAddress;
45         lastBlockNumber = block.number;
46     }
47 
48     function returnRate() internal returns (uint256){
49         if(affectedCount == 10){
50             if(preRate > 100){
51                 preRate -= 100;
52             }
53             affectedCount = 0;
54         }
55         return SafeOpt.div(preRate, 10);
56     }
57 
58     function issue() public  {
59         if(initialYear){
60             require(SafeOpt.sub(block.number, lastBlockNumber) > 2102400);
61             initialYear = false;
62         }
63         require(SafeOpt.sub(block.number, lastBlockNumber) > 2102400);
64         TTDToken tokenContract = TTDToken(tokenContractAddress);
65         if(affectedCount == 10){
66             lastYearTotalSupply = tokenContract.totalSupply();
67         }
68         uint256 amount = SafeOpt.div(SafeOpt.mul(lastYearTotalSupply, returnRate()), 10000);
69         require(amount > 0);
70         tokenContract.issue(amount);
71         lastBlockNumber = block.number;
72         affectedCount += 1;
73     }
74 }
75 
76 
77 interface tokenRecipient {
78     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
79 }
80 
81 contract TTDToken {
82     string public name = 'TTD Token';
83     string public symbol = 'TTD';
84     uint8 public decimals = 18;
85     uint256 public totalSupply = 100 * 10 ** 26;
86 
87     address public issueContractAddress;
88     address public owner;
89 
90     mapping (address => uint256) public balanceOf;
91     mapping (address => mapping (address => uint256)) public allowance;
92 
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     event Burn(address indexed from, uint256 value);
96     event Issue(uint256 amount);
97 
98     function TTDToken() public {
99         owner = msg.sender;
100         balanceOf[owner] = totalSupply;
101         issueContractAddress = new TTDTokenIssue(address(this));
102     }
103 
104     function issue(uint256 amount) public {
105         require(msg.sender == issueContractAddress);
106         balanceOf[owner] = SafeOpt.add(balanceOf[owner], amount);
107         totalSupply = SafeOpt.add(totalSupply, amount);
108         Issue(amount);
109     }
110 
111     function balanceOf(address _owner) public view returns (uint256 balance) {
112         return balanceOf[_owner];
113     }
114 
115     function _transfer(address _from, address _to, uint _value) internal {
116         require(_to != 0x0);
117         require(balanceOf[_from] >= _value);
118         require(balanceOf[_to] + _value > balanceOf[_to]);
119         uint previousBalances = balanceOf[_from] + balanceOf[_to];
120         balanceOf[_from] -= _value;
121         balanceOf[_to] += _value;
122         Transfer(_from, _to, _value);
123         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
124     }
125 
126     function transfer(address _to, uint256 _value) public returns (bool success){
127         _transfer(msg.sender, _to, _value);
128         return true;
129     }
130 
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132         require(_value <= allowance[_from][msg.sender]);
133         allowance[_from][msg.sender] -= _value;
134         _transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function approve(address _spender, uint256 _value) public returns (bool success) {
139         require(_value <= balanceOf[msg.sender]);
140         allowance[msg.sender][_spender] = _value;
141         Approval(msg.sender, _spender, _value);
142         return true;
143     }
144 
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
146         tokenRecipient spender = tokenRecipient(_spender);
147         if (approve(_spender, _value)) {
148             spender.receiveApproval(msg.sender, _value, this, _extraData);
149             return true;
150         }
151     }
152 
153     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
154         return allowance[_owner][_spender];
155     }
156 
157     function burn(uint256 _value) public returns (bool success) {
158         require(balanceOf[msg.sender] >= _value);
159         balanceOf[msg.sender] -= _value;
160         totalSupply -= _value;
161         Burn(msg.sender, _value);
162         return true;
163     }
164 
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(balanceOf[_from] >= _value);
167         require(_value <= allowance[_from][msg.sender]);
168         balanceOf[_from] -= _value;
169         allowance[_from][msg.sender] -= _value;
170         totalSupply -= _value;
171         Burn(_from, _value);
172         return true;
173     }
174 
175 }