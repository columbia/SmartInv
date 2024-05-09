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
34 contract MHCTokenIssue {
35     uint256 public lastYearTotalSupply = 15 * 10 ** 26; 
36     uint8   public affectedCount = 0;
37     bool    public initialYear = true; 
38 	address public tokenContractAddress;
39     uint16  public preRate = 1000; 
40     uint256 public lastBlockNumber;
41 
42     function MHCTokenIssue (address _tokenContractAddress) public{
43         tokenContractAddress = _tokenContractAddress;
44         lastBlockNumber = block.number;
45     }
46 
47     function returnRate() internal returns (uint256){
48         if(affectedCount == 10){
49             if(preRate > 100){
50                 preRate -= 100;
51             }
52             affectedCount = 0;
53         }
54         return SafeOpt.div(preRate, 10);
55     }
56 
57     function issue() public  {
58         if(initialYear){
59             require(SafeOpt.sub(block.number, lastBlockNumber) > 2102400);
60             initialYear = false;
61         }
62         require(SafeOpt.sub(block.number, lastBlockNumber) > 2102400);
63         MHCToken tokenContract = MHCToken(tokenContractAddress);
64         if(affectedCount == 10){
65             lastYearTotalSupply = tokenContract.totalSupply();
66         }
67         uint256 amount = SafeOpt.div(SafeOpt.mul(lastYearTotalSupply, returnRate()), 10000);
68         require(amount > 0);
69         tokenContract.issue(amount);
70         lastBlockNumber = block.number;
71         affectedCount += 1;
72     }
73 }
74 
75 
76 interface tokenRecipient {
77     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
78 }
79 
80 contract MHCToken {
81     string public name = 'MagicHerb Coin';
82     string public symbol = 'MHC';
83     uint8 public decimals = 18;
84     uint256 public totalSupply = 1000 * 10 ** 26;
85 
86     address public issueContractAddress;
87     address public owner;
88 
89     mapping (address => uint256) public balanceOf;
90     mapping (address => mapping (address => uint256)) public allowance;
91 
92     event Transfer(address indexed from, address indexed to, uint256 value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94     event Burn(address indexed from, uint256 value);
95     event Issue(uint256 amount);
96 
97     function MHCToken() public {
98         owner = msg.sender;
99         balanceOf[owner] = totalSupply;
100         issueContractAddress = new MHCTokenIssue(address(this));
101     }
102 
103     function issue(uint256 amount) public {
104         require(msg.sender == issueContractAddress);
105         balanceOf[owner] = SafeOpt.add(balanceOf[owner], amount);
106         totalSupply = SafeOpt.add(totalSupply, amount);
107         Issue(amount);
108     }
109 
110     function balanceOf(address _owner) public view returns (uint256 balance) {
111         return balanceOf[_owner];
112     }
113 
114     function _transfer(address _from, address _to, uint _value) internal {
115         require(_to != 0x0);
116         require(balanceOf[_from] >= _value);
117         require(balanceOf[_to] + _value > balanceOf[_to]);
118         uint previousBalances = balanceOf[_from] + balanceOf[_to];
119         balanceOf[_from] -= _value;
120         balanceOf[_to] += _value;
121         Transfer(_from, _to, _value);
122         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
123     }
124 
125     function transfer(address _to, uint256 _value) public returns (bool success){
126         _transfer(msg.sender, _to, _value);
127         return true;
128     }
129 
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
131         require(_value <= allowance[_from][msg.sender]);
132         allowance[_from][msg.sender] -= _value;
133         _transfer(_from, _to, _value);
134         return true;
135     }
136 
137     function approve(address _spender, uint256 _value) public returns (bool success) {
138         require(_value <= balanceOf[msg.sender]);
139         allowance[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
145         tokenRecipient spender = tokenRecipient(_spender);
146         if (approve(_spender, _value)) {
147             spender.receiveApproval(msg.sender, _value, this, _extraData);
148             return true;
149         }
150     }
151 
152     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
153         return allowance[_owner][_spender];
154     }
155 
156     function burn(uint256 _value) public returns (bool success) {
157         require(balanceOf[msg.sender] >= _value);
158         balanceOf[msg.sender] -= _value;
159         totalSupply -= _value;
160         Burn(msg.sender, _value);
161         return true;
162     }
163 
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165         require(balanceOf[_from] >= _value);
166         require(_value <= allowance[_from][msg.sender]);
167         balanceOf[_from] -= _value;
168         allowance[_from][msg.sender] -= _value;
169         totalSupply -= _value;
170         Burn(_from, _value);
171         return true;
172     }
173 
174 }