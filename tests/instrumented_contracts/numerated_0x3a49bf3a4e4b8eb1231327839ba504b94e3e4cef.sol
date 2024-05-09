1 pragma solidity ^0.4.23;
2 
3 contract NotASecurity {
4   uint public totalSupply;
5 
6   uint public decimals = 18;
7   string public symbol = "NOT";
8   string public name = "NotASecurity";
9 
10   mapping (address => uint) public balanceOf;
11   mapping (address => mapping (address => uint)) internal allowed;
12 
13   address[11] public benefactors;
14   uint public benefactorsBalance;
15 
16   // Caching things for performance reasons
17   mapping (address => uint8) private benefactorMap;
18   address private lowestBenefactor;
19 
20   event Approval(address indexed _owner, address indexed _spender, uint _value);
21   event Transfer(address indexed _from, address indexed _to, uint _value);
22 
23   constructor (uint _fee) public {
24     benefactors[1] = msg.sender;
25     lowestBenefactor = address(0);
26     benefactorMap[msg.sender] = 1;
27     balanceOf[msg.sender] = _fee;
28     totalSupply = _fee;
29     benefactorsBalance = _fee;
30   }
31 
32   function buy() payable public returns (uint) {
33     uint _wei = msg.value;
34     address _investor = msg.sender;
35 
36     require(_wei > 0);
37     require(distribute(_wei));
38 
39     balanceOf[_investor] += _wei;
40     totalSupply += _wei;
41 
42     require(reorganize(_wei, _investor));
43 
44     return _wei;
45   }
46 
47   function () payable public {
48     buy();
49   }
50 
51   event Distribution(address _addr, uint _amount);
52 
53   function distribute(uint _amount) public returns (bool) {
54     for (uint _i = 1; _i < benefactors.length; _i++) {
55       address _benefactor = benefactors[_i];
56       uint _benefactorBalance = balanceOf[_benefactor];
57 
58       uint _amountToTransfer = (_benefactorBalance * _amount) / benefactorsBalance;
59       emit Distribution(_benefactor, _amountToTransfer);
60 
61       if (_amountToTransfer > 0 && _benefactor != address(0)) {
62         _benefactor.transfer(_amountToTransfer);
63       }
64     }
65 
66     return true;
67   }
68 
69   function findLowestBenefactor() public returns (address) {
70     address _lowestBenefactor = benefactors[1];
71     address _benefactor;
72     for (
73       uint _j = 2;
74       _j < benefactors.length;
75       _j++
76     ) {
77       _benefactor = benefactors[_j];
78       if (_benefactor == address(0)) {
79         return _benefactor;
80 
81       } else if (balanceOf[_benefactor] < balanceOf[_lowestBenefactor]) {
82         _lowestBenefactor = _benefactor;
83       }
84     }
85     return _lowestBenefactor;
86   }
87 
88   function findEmptyBenefactorIndex() public returns (uint8) {
89     for (uint8 _i = 1; _i < benefactors.length; _i++) {
90       if (benefactors[_i] == address(0)) {
91         return _i;
92       }
93     }
94 
95     return 0;
96   }
97 
98   function reorganize(uint _amount, address _investor) public returns (bool) {
99     // if investor is already a benefactor
100     if (benefactorMap[_investor] > 0) {
101       benefactorsBalance += _amount;
102 
103     // if investor is now a top token holder
104     } else if (balanceOf[_investor] > balanceOf[lowestBenefactor]) {
105       bool _lowestBenefactorEmpty = lowestBenefactor == address(0);
106       uint _oldBalance = balanceOf[lowestBenefactor];
107       uint8 _indexToSwap = _lowestBenefactorEmpty
108         ? findEmptyBenefactorIndex()
109         : benefactorMap[lowestBenefactor];
110 
111       // Swap out benefactors
112       if (!_lowestBenefactorEmpty) {
113         benefactorMap[lowestBenefactor] = 0;
114       }
115       benefactors[_indexToSwap] = _investor;
116       benefactorMap[_investor] = _indexToSwap;
117       lowestBenefactor = findLowestBenefactor();
118 
119       // Adjust benefactors balance
120       benefactorsBalance += (balanceOf[_investor] - _oldBalance);
121 
122     }
123 
124     return true;
125   }
126 
127   function _transfer(
128     address _from,
129     address _to,
130     uint _amount
131   ) internal returns (bool success) {
132     require(_to != address(0));
133     require(_to != address(this));
134     require(_amount > 0);
135     require(balanceOf[_from] >= _amount);
136     require(balanceOf[_to] + _amount > balanceOf[_to]);
137 
138     balanceOf[_from] -= _amount;
139     balanceOf[_to] += _amount;
140 
141     // reorganize for both addresses
142 
143     emit Transfer(msg.sender, _to, _amount);
144 
145     return true;
146   }
147 
148   function transfer(address _to, uint _amount) public returns (bool success) {
149     return _transfer(msg.sender, _to, _amount);
150   }
151 
152   function transferFrom(address _from, address _to, uint _amount) external returns (bool success) {
153     require(allowed[_from][msg.sender] >= _amount);
154 
155     bool _tranferSuccess = _transfer(_from, _to, _amount);
156     if (_tranferSuccess) {
157       allowed[_from][msg.sender] -= _amount;
158       return true;
159     } else {
160       return false;
161     }
162   }
163 
164   function approve(address _spender, uint _value) external returns (bool success) {
165     allowed[msg.sender][_spender] = _value;
166     emit Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   function allowance(address _owner, address _spender) external constant returns (uint remaining) {
171     return allowed[_owner][_spender];
172   }
173 }