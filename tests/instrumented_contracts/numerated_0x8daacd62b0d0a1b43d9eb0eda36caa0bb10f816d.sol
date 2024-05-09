1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract ERC20Interface {
25 	function name() public view returns (string);
26 	function symbol() public view returns (string);
27 	function decimals() public view returns (uint);
28     function totalSupply() public view returns (uint);
29 	function maximumSupply() public view returns (uint);
30 	
31     function balanceOf(address _queryAddress) public constant returns (uint balance);
32     function allowance(address _queryAddress, address _approvedAddress) public constant returns (uint remaining);
33     function transfer(address _transferAddress, uint _tokenAmount) public returns (bool success);
34     function approve(address _approvedAddress, uint _tokenAmount) public returns (bool success);
35     function transferFrom(address _fromAddress, address _transferAddress, uint _tokenAmount) public returns (bool success);
36 
37     event Transfer(address indexed _fromAddress, address indexed _transferAddress, uint _tokenAmount);
38     event Approval(address indexed _fromAddress, address indexed _approvedAddress, uint _tokenAmount);
39 }
40 
41 
42 contract PLEXToken is ERC20Interface {
43 	using SafeMath for uint;
44     mapping(address => uint) public balances;
45 	mapping(address => mapping(address => uint)) public allowed;
46 	
47 	string public name;
48 	string public symbol;
49 	uint public decimals;
50 	uint public totalSupply;
51 	uint public maximumSupply;
52 	uint public preSaleSupply;
53 	uint public mainSaleSupply;
54 	uint public preSaleRate;
55 	uint public mainSaleRateP1;
56 	uint public mainSaleRateP2;
57 	uint public mainSaleRateP3;
58 	uint public mainSaleRateP4;
59 	uint public preSaleEnd;
60 	uint public mainSaleStart;
61 	uint public mainSaleEnd;
62 	address public contractOwner;
63 
64     constructor() public {
65 		name = "PLEX";
66 		symbol = "PLEX";
67 		decimals = 2;
68 		totalSupply = 0;
69 		maximumSupply = 10000000000;
70 		preSaleSupply = 1000000000;
71 		mainSaleSupply = 4000000000;
72 		preSaleRate = 0.0002 ether;
73 		mainSaleRateP1 = 0.000625 ether;
74 		mainSaleRateP2 = 0.00071428571 ether;
75 		mainSaleRateP3 = 0.00083333333 ether;
76 		mainSaleRateP4 = 0.001 ether;
77 		preSaleEnd = 1529884800;
78 		mainSaleStart = 1530554400;
79 		mainSaleEnd = 1532908800;
80 		contractOwner = msg.sender;
81 		
82 		balances[0xaF3D1767966B8464bEDD88f5B6cFDC23D3Ba7CE3] = 100000000;
83 		emit Transfer(0, 0xaF3D1767966B8464bEDD88f5B6cFDC23D3Ba7CE3, 100000000);
84 		
85 		balances[0x0d958C8f7CCD8d3b03653C3A487Bc11A5db9749B] = 400000000;
86 		emit Transfer(0, 0x0d958C8f7CCD8d3b03653C3A487Bc11A5db9749B, 400000000);
87 		
88 		balances[0x3ca16559A1CC5172d4e524D652892Fb9D422F030] = 500000000;
89 		emit Transfer(0, 0x3ca16559A1CC5172d4e524D652892Fb9D422F030, 500000000);
90 		
91 		balances[0xf231dcadBf45Ab3d4Ca552079FC9B71860CC8255] = 500000000;
92 		emit Transfer(0, 0xf231dcadBf45Ab3d4Ca552079FC9B71860CC8255, 500000000);
93 		
94 		balances[0x38ea72e347232BE550CbF15582056f3259e3A2DF] = 500000000;
95 		emit Transfer(0, 0x38ea72e347232BE550CbF15582056f3259e3A2DF, 500000000);
96 		
97 		balances[0x0e951a73965e373a0ACdFF4Ca6839aB3Aa111061] = 1000000000;
98 		emit Transfer(0, 0x0e951a73965e373a0ACdFF4Ca6839aB3Aa111061, 1000000000);
99 		
100 		balances[0x7Ee2Ec2ECC77Dd7DB791629D5D1aA18f97E7569B] = 1000000000;
101 		emit Transfer(0, 0x7Ee2Ec2ECC77Dd7DB791629D5D1aA18f97E7569B, 1000000000);
102 		
103 		balances[0xF8041851c7E9deB3EA93472F27e9DF872014EcDd] = 1000000000;
104 		emit Transfer(0, 0xF8041851c7E9deB3EA93472F27e9DF872014EcDd, 1000000000);
105 		
106 		totalSupply = totalSupply.add(5000000000);
107 	}
108 	
109 	function name() public constant returns (string) {
110 		return name;
111 	}
112 	
113 	function symbol() public constant returns (string) {
114 		return symbol;
115 	}
116 	
117 	function decimals() public constant returns (uint) {
118 		return decimals;
119 	}
120 	
121 	function totalSupply() public constant returns (uint) {
122 		return totalSupply;
123 	}
124 	
125 	function maximumSupply() public constant returns (uint) {
126 		return maximumSupply;
127 	}
128 	
129 	function balanceOf(address _queryAddress) public constant returns (uint balance) {
130         return balances[_queryAddress];
131     }
132 	
133 	function allowance(address _queryAddress, address _approvedAddress) public constant returns (uint remaining) {
134         return allowed[_queryAddress][_approvedAddress];
135     }
136 	
137 	function transfer(address _transferAddress, uint _tokenAmount) public returns (bool success) {
138         balances[msg.sender] = balances[msg.sender].sub(_tokenAmount);
139         balances[_transferAddress] = balances[_transferAddress].add(_tokenAmount);
140         emit Transfer(msg.sender, _transferAddress, _tokenAmount);
141         return true;
142     }
143 	
144 	function approve(address _approvedAddress, uint _tokenAmount) public returns (bool success) {
145         allowed[msg.sender][_approvedAddress] = _tokenAmount;
146         emit Approval(msg.sender, _approvedAddress, _tokenAmount);
147         return true;
148     }
149 	
150 	function transferFrom(address _fromAddress, address _transferAddress, uint _tokenAmount) public returns (bool success) {
151         balances[_fromAddress] = balances[_fromAddress].sub(_tokenAmount);
152         allowed[_fromAddress][msg.sender] = allowed[_fromAddress][msg.sender].sub(_tokenAmount);
153         balances[_transferAddress] = balances[_transferAddress].add(_tokenAmount);
154         emit Transfer(_fromAddress, _transferAddress, _tokenAmount);
155         return true;
156     }
157 	
158 	function setDates(uint _preSaleEnd, uint _mainSaleStart, uint _mainSaleEnd) public returns (bool success) {
159 		require(msg.sender == contractOwner);
160 		preSaleEnd = _preSaleEnd;
161 		mainSaleStart = _mainSaleStart;
162 		mainSaleEnd = _mainSaleEnd;
163 		return true;
164 	}
165 	
166 	function setPreSaleRate(uint _preSaleRate) public returns (bool success) {
167 		require(msg.sender == contractOwner);
168 		preSaleRate = _preSaleRate;
169 		return true;
170 	}
171     
172     function() public payable {
173         require((now <= preSaleEnd) || (now >= mainSaleStart && now <= mainSaleEnd));
174 		if (now <= preSaleEnd) {
175 			require((msg.value >= 0.01 ether && msg.value <= 15 ether) && (preSaleSupply >= (msg.value / preSaleRate) * 100));
176 			preSaleSupply = preSaleSupply.sub((msg.value / preSaleRate) * 100);
177 			totalSupply = totalSupply.add((msg.value / preSaleRate) * 100);
178 			balances[msg.sender] = balances[msg.sender].add((msg.value / preSaleRate) * 100);
179 			emit Transfer(0, msg.sender, (msg.value / preSaleRate) * 100);
180 		}
181 		if (now >= mainSaleStart && now <= mainSaleEnd) {
182 			require((msg.value >= 0.01 ether && msg.value <= 15 ether) && (mainSaleSupply >= (msg.value / mainSaleRateP1) * 100));
183 			if (mainSaleSupply <= 4000000000 && mainSaleSupply > 3000000000) {
184 				mainSaleSupply = mainSaleSupply.sub((msg.value / mainSaleRateP1) * 100);
185 				totalSupply = totalSupply.add((msg.value / mainSaleRateP1) * 100);
186 				balances[msg.sender] = balances[msg.sender].add((msg.value / mainSaleRateP1) * 100);
187 				emit Transfer(0, msg.sender, (msg.value / mainSaleRateP1) * 100);
188 			}
189 			if (mainSaleSupply <= 3000000000 && mainSaleSupply > 2000000000) {
190 				mainSaleSupply = mainSaleSupply.sub((msg.value / mainSaleRateP2) * 100);
191 				totalSupply = totalSupply.add((msg.value / mainSaleRateP2) * 100);
192 				balances[msg.sender] = balances[msg.sender].add((msg.value / mainSaleRateP2) * 100);
193 				emit Transfer(0, msg.sender, (msg.value / mainSaleRateP2) * 100);
194 			}
195 			if (mainSaleSupply <= 2000000000 && mainSaleSupply > 1000000000) {
196 				mainSaleSupply = mainSaleSupply.sub((msg.value / mainSaleRateP3) * 100);
197 				totalSupply = totalSupply.add((msg.value / mainSaleRateP3) * 100);
198 				balances[msg.sender] = balances[msg.sender].add((msg.value / mainSaleRateP3) * 100);
199 				emit Transfer(0, msg.sender, (msg.value / mainSaleRateP3) * 100);
200 			}
201 			if (mainSaleSupply <= 1000000000) {
202 				mainSaleSupply = mainSaleSupply.sub((msg.value / mainSaleRateP4) * 100);
203 				totalSupply = totalSupply.add((msg.value / mainSaleRateP4) * 100);
204 				balances[msg.sender] = balances[msg.sender].add((msg.value / mainSaleRateP4) * 100);
205 				emit Transfer(0, msg.sender, (msg.value / mainSaleRateP4) * 100);
206 			}
207 		}
208 		contractOwner.transfer(msg.value);
209     }
210 }