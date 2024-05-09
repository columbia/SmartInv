1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract token {
21     string public standard = 'https://www.tntoo.com';
22     string public name = 'Transaction Network';
23     string public symbol = 'TNTOO';
24     uint8 public decimals = 18;
25     uint public totalSupply = 0;
26 
27     mapping (address => uint) public balanceOf;
28     mapping (address => mapping (address => uint)) public allowance;
29 
30     event Transfer(address indexed from, address indexed to, uint value);
31 
32     function _transfer(address _from, address _to, uint _value) internal {
33         require(_to != 0x0);
34         require(balanceOf[_from] >= _value);
35         require(balanceOf[_to] + _value > balanceOf[_to]);
36         uint previousBalances = balanceOf[_from] + balanceOf[_to];
37         balanceOf[_from] -= _value;
38         balanceOf[_to] += _value;
39         Transfer(_from, _to, _value);
40         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
41     }
42 
43     function transfer(address _to, uint _value) public {
44         _transfer(msg.sender, _to, _value);
45     }
46 
47     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
48         require(_value <= allowance[_from][msg.sender]);  
49         allowance[_from][msg.sender] -= _value;
50         _transfer(_from, _to, _value);
51         return true;
52     }
53 
54     function approve(address _spender, uint _value) public
55         returns (bool success) {
56         allowance[msg.sender][_spender] = _value;
57         return true;
58     }
59 }
60 
61 contract TNTOO is owned, token {
62     uint public allEther;
63     uint public ratio = 10000;
64     uint public ratioUpdateTime = now;
65     uint public windowPeriod = now + 180 days;
66     bool public windowPeriodEnd;
67     address[] public investors;
68     uint _seed = now;
69 
70     struct Good {
71         bytes32 preset;
72         uint price;
73         uint time;
74         address seller;
75     }
76 
77     mapping (bytes32 => Good) public goods;
78     // withdraw quota
79     mapping (address => uint) public quotaOf; 
80     // trade decision result
81     mapping (bytes32 => address) public decisionOf; 
82 
83     event WindowPeriodClosed(address target, uint time);
84     event Decision(uint result, address finalAddress, address[] buyers, uint[] amounts);
85     event Withdraw(address from, address target, uint ethAmount, uint amount, uint fee);
86 
87     function _random (uint _upper) internal returns (uint randomNumber) {
88         _seed = uint(keccak256(keccak256(block.blockhash(block.number), _seed), now));
89         return _seed % _upper;
90     }
91 
92     function _stringToBytes32(string memory _source) internal pure returns (bytes32 result) {
93         bytes memory tempEmptyStringTest = bytes(_source);
94         if (tempEmptyStringTest.length == 0) {
95             return 0x0;
96         }
97         assembly {
98             result := mload(add(_source, 32))
99         }
100     }
101 
102     // get decision result address
103     function _getFinalAddress(uint[] _amounts, address[] _buyers, uint result) internal pure returns (address finalAddress) {
104         uint congest = 0;
105         address _finalAddress = 0x0;
106         for (uint j = 0; j < _amounts.length; j++) {
107             congest += _amounts[j];
108             if (result <= congest && _finalAddress == 0x0) {
109                 _finalAddress = _buyers[j];
110             }
111         }
112         return _finalAddress;
113     }
114 
115     // try to update ratio,  15 days limit
116     function _checkRatio() internal {
117         if (ratioUpdateTime <= now - 15 days && allEther != 0) {
118             ratioUpdateTime = now;
119             ratio = uint(totalSupply / allEther);
120         }
121     }
122 
123     // 500ETH investors, everyone 5%
124     function _shareOut(uint feeAmount) internal {
125         uint shareAmount;
126         address investor;
127         for (uint k = 0; k < investors.length; k++) {
128             shareAmount = feeAmount * 5 / 100;
129             investor = investors[k];
130             balanceOf[investor] += shareAmount;
131             quotaOf[investor] += shareAmount;
132             balanceOf[owner] -= shareAmount;
133             quotaOf[owner] -= shareAmount;
134         }
135     }
136 
137     // try to close window period
138     function _checkWindowPeriod() internal {
139         if (now >= windowPeriod) {
140             windowPeriodEnd = true;
141             WindowPeriodClosed(msg.sender, now);
142         }
143     }
144 
145     // mall application delegate transfer
146     function delegateTransfer(address _from, address _to, uint _value, uint _fee) onlyOwner public {
147         if (_fee > 0) {
148             require(_fee < 100 * 10 ** uint256(decimals));
149             quotaOf[owner] += _fee;
150         }
151         if (_from != owner && _to != owner) {
152             _transfer(_from, owner, _fee);
153         }
154         _transfer(_from, _to, _value - _fee);
155     }
156 
157     function postTrade(bytes32 _preset, uint _price, address _seller) onlyOwner public {
158         // execute it only once
159         require(goods[_preset].preset == "");
160         goods[_preset] = Good({preset: _preset, price: _price, seller: _seller, time: now});
161     }
162 
163     function decision(bytes32 _preset, string _presetSrc, address[] _buyers, uint[] _amounts) onlyOwner public {
164         
165         // execute it only once
166         require(decisionOf[_preset] == 0x0);
167 
168         Good storage good = goods[_preset];
169         // preset authenticity
170         require(sha256(_presetSrc) == good.preset);
171 
172         // address added, parameter 1
173         uint160 allAddress;
174         for (uint i = 0; i < _buyers.length; i++) {
175             allAddress += uint160(_buyers[i]);
176         }
177         
178         // random, parameter 2
179         uint random = _random(allAddress);
180 
181         // preset is parameter 3, add and take the remainder
182         uint result = uint(uint(_stringToBytes32(_presetSrc)) + allAddress + random) % good.price;
183 
184         address finalAddress = _getFinalAddress(_amounts, _buyers, result);
185         
186         // save decision result
187         decisionOf[_preset] = finalAddress;
188         Decision(result, finalAddress, _buyers, _amounts);
189         
190         uint finalAmount = uint(good.price * 98 / 100);
191         uint feeAmount = uint(good.price * 1 / 100);
192         if (good.seller != 0x0) {
193             // quota for seller
194             quotaOf[good.seller] += finalAmount;
195         } else {
196             // quota for buyer
197             quotaOf[finalAddress] += finalAmount;
198             _transfer(owner, finalAddress, finalAmount); 
199         }
200 
201         // destroy tokens
202         balanceOf[owner] -= feeAmount;
203         totalSupply -= feeAmount;
204         quotaOf[owner] += feeAmount;
205         
206         _shareOut(feeAmount);
207         
208         _checkRatio();
209     }
210 
211     // TNTOO withdraw as ETH
212     function withdraw(address _target, uint _amount, uint _fee) public {
213         require(_amount <= quotaOf[_target]);
214         uint finalAmount = _amount - _fee;         
215         uint ethAmount = finalAmount / ratio;
216         require(ethAmount <= allEther);
217         // fee
218         if (msg.sender == owner && _target != owner) {
219             require(_fee < 100 * 10 ** uint256(decimals));
220             quotaOf[owner] += _fee;
221         } else {
222             require(msg.sender == _target);
223         }
224         quotaOf[_target] -= _amount;
225         // destroy tokens
226         totalSupply -= finalAmount;
227         balanceOf[owner] -= finalAmount;
228         // transfer ether
229         _target.transfer(ethAmount);
230         allEther -= ethAmount;
231         Withdraw(msg.sender, _target, ethAmount, _amount, _fee);
232     }
233 
234     function () payable public {
235         // ethers
236         uint etherAmount = msg.value;
237         uint tntooAmount = etherAmount * ratio;
238         allEther += etherAmount;
239         // investors
240         if (!windowPeriodEnd && investors.length < 5 && etherAmount >= 500 ether) {
241             quotaOf[owner] += tntooAmount;
242             investors.push(msg.sender);
243         }
244         totalSupply += tntooAmount;
245         // unified management by the application
246         balanceOf[owner] += tntooAmount;
247         _checkWindowPeriod();
248 
249         Transfer(this, owner, tntooAmount);
250     }
251 }