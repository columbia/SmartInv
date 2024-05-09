1 pragma solidity ^0.4.26;
2 
3 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
4 
5 contract owned {
6     address public owner;
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 }
21 
22 contract ERC20 {
23     function totalSupply() public constant returns (uint256 supply);
24 
25     function balanceOf(address _owner) public constant returns (uint256 balance);
26 
27     function transferTo(address _to, uint256 _value) public returns (bool);
28 
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
30 
31     function approve(address _spender, uint256 _value) public returns (bool success);
32 
33     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36 
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39     event Burn(address indexed _burner, uint256 _value);
40 }
41 
42 contract ERC677 is ERC20 {
43     function transferAndCall(address to, uint value, bytes data) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint value, bytes data);
46 }
47 
48 contract ERC677Receiver {
49     function onTokenTransfer(address _sender, uint _value, bytes _data) public;
50 }
51 
52 contract ERC20Token is ERC20 {
53     mapping(address => uint256) balances;
54     mapping(address => mapping(address => uint256)) allowed;
55     uint public supply;
56 
57     function _transfer(address _from, address _to, uint _value) internal {
58         require(_to != 0x0);
59         require(balances[_from] >= _value);
60         require(balances[_to] + _value >= balances[_to]);
61         uint previousBalances = balances[_from] + balances[_to];
62         balances[_from] -= _value;
63         balances[_to] += _value;
64         emit Transfer(_from, _to, _value);
65         assert(balances[_from] + balances[_to] == previousBalances);
66     }
67 
68     function transfer(address _to, uint256 _value) public returns (bool) {
69         _transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     function transferTo(address _to, uint256 _value) public returns (bool) {
74         _transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79         _transfer(_from, _to, _value);
80         return true;
81     }
82 
83     function totalSupply() public constant returns (uint256) {
84         return supply;
85     }
86 
87     function balanceOf(address _owner) public constant returns (uint256) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool) {
92         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
93 
94         allowed[msg.sender][_spender] = _value;
95         emit Approval(msg.sender, _spender, _value);
96 
97         return true;
98     }
99 
100     function _burn(address _burner, uint256 _value) internal returns (bool) {
101         require(_value > 0);
102         require(balances[_burner] > 0);
103         balances[_burner] -= _value;
104         supply -= _value;
105         emit Burn(_burner, _value);
106         return true;
107     }
108 
109     function allowance(address _owner, address _spender) public constant returns (uint256) {
110         return allowed[_owner][_spender];
111     }
112 }
113 
114 contract ERC677Token is ERC677 {
115 
116     function transferAndCall(address _to, uint _value, bytes _data) public returns (bool success) {
117         super.transferTo(_to, _value);
118         emit Transfer(msg.sender, _to, _value, _data);
119         if (isContract(_to)) {
120             contractFallback(_to, _value, _data);
121         }
122         return true;
123     }
124 
125     function contractFallback(address _to, uint _value, bytes _data) private {
126         ERC677Receiver receiver = ERC677Receiver(_to);
127         receiver.onTokenTransfer(msg.sender, _value, _data);
128     }
129 
130     function isContract(address _addr) private returns (bool hasCode) {
131         uint length;
132         assembly { length := extcodesize(_addr) }
133         return length > 0;
134     }
135 }
136 
137 contract CROERC20 {
138     function balanceOf(address addr) returns (uint256);
139 
140 }
141 
142 contract CRO is owned, ERC20Token, ERC677Token {
143 
144     CROERC20 constant public oldCRO = CROERC20(0x5BC84e3066448C2B0672304d4ee58EE492d9924E);
145     string public name = "CRO Decentralized Finance";
146     string public symbol = "CRO";
147     string public website = "www.crocryptocoin.com";
148     uint public decimals = 18;
149 
150     uint256 public totalSupplied;
151     uint256 public totalBurned;
152 
153     constructor() public {
154         supply = 500000000 * (1 ether / 1 wei);
155         totalBurned = 0;
156         totalSupplied = 0;
157         balances[address(this)] = supply;
158     }
159 
160     function changeWebsite(string _website) public onlyOwner returns (bool) {
161         website = _website;
162         return true;
163     }
164 
165     function changeName(string _name) public onlyOwner returns (bool) {
166         name = _name;
167         return true;
168     }
169 
170     function transferTo(address _to, uint256 _value) public onlyOwner returns (bool) {
171         totalSupplied += _value;
172         _transfer(address(this), _to, _value);
173         return true;
174     }
175 
176     function burnByValue(uint256 _value) public onlyOwner returns (bool) {
177         totalBurned += _value;
178         _burn(address(this), _value);
179         return true;
180     }
181 
182     function revertBalance(address[] addresses) public onlyOwner returns (bool) {
183         for (uint i=0; i<addresses.length; i++) {
184             uint256 oldBalance = oldCRO.balanceOf(addresses[i]);
185             balances[addresses[i]] = oldBalance;
186             totalSupplied += oldBalance;
187             balances[address(this)] -= oldBalance;
188             emit Transfer(address(this), addresses[i], oldBalance);
189         }
190         return true;
191     }
192 }