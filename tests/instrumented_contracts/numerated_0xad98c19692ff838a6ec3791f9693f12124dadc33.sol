1 pragma solidity ^0.4.19;
2 
3 interface ERC223ReceivingContract { 
4     function tokenFallback(address _from, uint _value, bytes _data) external;
5 }
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract owned {
37     address public owner;
38 
39     function owned() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) onlyOwner public {
49         owner = newOwner;
50     }
51 }
52 
53 contract MiaoMiToken is owned {
54     using SafeMath for uint256;
55     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
56 
57     mapping(address => uint) balances; // List of user balances.
58     
59     string _name;
60     string _symbol;
61     uint8 DECIMALS = 5;
62     // 6 decimals is the strongly suggested default, avoid changing it
63     uint256 _totalSupply;
64     address team_addr;
65     uint256 team_keep_amount;
66     uint256 _saledTotal = 0;
67     uint256 _amounToSale = 0;
68     uint _buyPrice = 10000;
69     uint256 _totalEther = 0;
70 
71 
72     function MiaoMiToken(
73         string tokenName,
74         string tokenSymbol
75     ) public 
76     {
77         _totalSupply = 950000000 * 10 ** uint256(DECIMALS);  // 实际供应总量
78         _amounToSale = 950000000 * 10 ** uint256(DECIMALS);
79         _saledTotal = 0;
80         _name = tokenName;                                       // 设置Token名字
81         _symbol = tokenSymbol;                                   // 设置Token符号
82     }
83 
84     function name() public constant returns (string) {
85         return _name;
86     }
87 
88     function symbol() public constant returns (string) {
89         return _symbol;
90     }
91 
92     function totalSupply() public constant returns (uint256) {
93         return _totalSupply;
94     }
95 
96     function buyPrice() public constant returns (uint256) {
97         return _buyPrice;
98     }
99     
100     function decimals() public constant returns (uint8) {
101         return DECIMALS;
102     }
103 
104     /**
105      * @dev Transfer the specified amount of tokens to the specified address.
106      *      Invokes the tokenFallback function if the recipient is a contract.
107      *      The token transfer fails if the recipient is a contract
108      *      but does not implement the tokenFallback function
109      *      or the fallback function to receive funds.
110      *
111      * @param _to    Receiver address.
112      * @param _value Amount of tokens that will be transferred.
113      * @param _data  Transaction metadata.
114      */
115     function transfer(address _to, uint _value, bytes _data) public returns (bool ok) {
116         // Standard function transfer similar to ERC20 transfer with no _data .
117         // Added due to backwards compatibility reasons .
118         uint codeLength;
119         require (_to != 0x0);
120         assembly {
121             // Retrieve the size of the code on target address, this needs assembly .
122             codeLength := extcodesize(_to)
123         }
124         require(balances[msg.sender]>=_value);
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         if (codeLength>0) {
128             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
129             receiver.tokenFallback(msg.sender, _value, _data);
130         }
131         Transfer(msg.sender, _to, _value, _data);
132         return true;
133     }
134     
135     /**
136      * @dev Transfer the specified amount of tokens to the specified address.
137 
138      *      This function works the same with the previous one
139      *      but doesn't contain _data param.
140      *      Added due to backwards compatibility reasons.
141      *
142      * @param _to    Receiver address.
143      * @param _value Amount of tokens that will be transferred.
144      */
145     function transfer(address _to, uint _value) public returns(bool ok) {
146         uint codeLength;
147         bytes memory empty;
148         require (_to != 0x0);
149         assembly {
150             // Retrieve the size of the code on target address, this needs assembly .
151             codeLength := extcodesize(_to)
152         }
153         require(balances[msg.sender]>=_value);
154         balances[msg.sender] = balances[msg.sender].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         if (codeLength>0) {
157             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
158             receiver.tokenFallback(msg.sender, _value, empty);
159         }
160         Transfer(msg.sender, _to, _value, empty);
161         return true;
162     }
163 
164     
165     /**
166      * @dev Returns balance of the _owner.
167      *
168      * @param _owner   The address whose balance will be returned.
169      * @return balance Balance of the _owner.
170      */
171     function balanceOf(address _owner) public constant returns (uint balance) {
172         return balances[_owner];
173     }
174 
175     function setPrices(uint256 newBuyPrice) onlyOwner public {
176         _buyPrice = newBuyPrice;
177     }
178 
179     /// @notice Buy tokens from contract by sending ether
180     function buyCoin() payable public returns (bool ok) {
181         uint amount = ((msg.value * _buyPrice) * 10 ** uint256(DECIMALS))/1000000000000000000;               // calculates the amount
182         require ((_amounToSale - _saledTotal)>=amount);
183         balances[msg.sender] = balances[msg.sender].add(amount);
184         _saledTotal = _saledTotal.add(amount);
185         _totalEther += msg.value;
186         return true;
187     }
188 
189     function dispatchTo(address target, uint256 amount) onlyOwner public returns (bool ok) {
190         require ((_amounToSale - _saledTotal)>=amount);
191         balances[target] = balances[target].add(amount);
192         _saledTotal = _saledTotal.add(amount);
193         return true;
194     }
195 
196     function withdrawTo(address _target, uint256 _value) onlyOwner public returns (bool ok) {
197         require(_totalEther <= _value);
198         _totalEther -= _value;
199         _target.transfer(_value);
200         return true;
201     }
202     
203     function () payable public {
204     }
205 
206 }