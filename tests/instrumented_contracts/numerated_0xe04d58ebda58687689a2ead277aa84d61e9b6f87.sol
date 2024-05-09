1 pragma solidity ^0.4.25;
2 
3 /*
4 *   EBIC2019 smart contract
5 *   Created by DAPCAR ( https://dapcar.io/ )
6 *   Copyright © European Blockchain Investment Congress 2019. All rights reserved.
7 *   http://ebic2019.com/
8 */
9 
10 interface IERC20 {
11     function totalSupply() public constant returns (uint256);
12     function balanceOf(address _owner) public constant returns (uint256 balance);
13     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14     function transfer(address _to, uint256 _value) public returns (bool success);
15     function approve(address _spender, uint256 _value) public returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 contract EBIC2019 {
23     
24     event PackageSent(address indexed sender, address indexed wallet, uint256 packageIndex, uint256 time);
25     event Withdraw(address indexed sender, address indexed wallet, uint256 amount);
26     event WithdrawTokens(address indexed sender, address indexed wallet, address indexed token, uint256 amount);
27     event DappPurpose(address indexed dappAddress);
28     event Suicide();
29     
30     address public owner;
31     address public dapp;
32     
33     struct Package {
34         Token[] tokens;
35         bool enabled;
36     }
37     
38     struct Token {
39         address smartAddress;
40         uint256 amount;
41     }
42     
43     Package[] packages;
44     uint256 public packageCount;
45     
46     mapping (address => uint256) public packageSent;
47     uint256 public packageSentCount;
48     
49     constructor() 
50     {
51         owner = msg.sender;
52         
53         packages.length++;
54     }
55     
56     function () 
57     external 
58     payable 
59     {
60 	}
61 	
62 	function packageCreate()
63 	public
64 	returns (uint256 _index)
65 	{
66 	    require(msg.sender == owner);
67 	    
68 	    uint256 index = packages.length++;
69 	    _index = index--;
70 	    Package storage package = packages[_index];
71 	    package.enabled = true;
72 	    packageCount++;
73 	}
74 	
75 	function packageTokenCreate(uint256 _packageIndex, address _token, uint256 _amount)
76 	public
77 	returns (bool _success)
78 	{
79 	    _success = false;
80 	    
81 	    require(msg.sender == owner);
82 	    require(_packageIndex > 0 && _packageIndex <= packageCount);
83 	    require(_token != address(0));
84 	    require(_amount > 0);
85 	    
86 	    Token memory token = Token({
87 	        smartAddress: _token,
88 	        amount: _amount
89 	    });
90 	    
91 	    Package storage package = packages[_packageIndex];
92 	    package.tokens.push(token);
93 	    
94 	    _success = true;
95 	}
96 	
97 	function packageEnabled(uint256 _packageIndex, bool _enabled)
98 	public
99 	returns (bool _success)
100 	{
101 	    _success = false;
102 	    require(msg.sender == owner);
103 	    require(_packageIndex > 0 && _packageIndex <= packageCount);
104 	    
105 	    Package storage package = packages[_packageIndex];
106 	    package.enabled = _enabled;
107 	    
108 	    _success = true;
109 	}
110 	
111 	function packageView(uint256 _packageIndex)
112 	view
113 	public
114 	returns (uint256 _tokensCount, bool _enabled)
115 	{
116 	    require(_packageIndex > 0 && _packageIndex <= packageCount);
117 	    
118 	    Package memory package = packages[_packageIndex];
119 	    
120 	    _tokensCount = package.tokens.length;
121 	    _enabled = package.enabled;
122 	}
123 	
124 	function packageTokenView(uint256 _packageIndex, uint256 _tokenIndex)
125 	view
126 	public
127 	returns (address _token, uint256 _amount)
128 	{
129 	    require(_packageIndex > 0 && _packageIndex <= packageCount);
130 	    
131 	    Package memory package = packages[_packageIndex];
132 	    
133 	    require(_tokenIndex < package.tokens.length);
134 	    
135 	    Token memory token = package.tokens[_tokenIndex];
136 	    _token = token.smartAddress;
137 	    _amount = token.amount;
138 	}
139 	
140 	function packageSend(address _wallet, uint256 _packageIndex)
141 	public
142 	returns (bool _success)
143 	{
144 	    _success = false;
145 	    
146 	    require(msg.sender == owner || msg.sender == dapp);
147 	    require(_wallet != address(0));
148 	    require(_packageIndex > 0);
149 	    require(packageSent[_wallet] != _packageIndex);
150 	    
151 	    Package memory package = packages[_packageIndex];
152 	    require(package.enabled);
153 	    
154 	    for(uint256 index = 0; index < package.tokens.length; index++){
155 	        require(IERC20(package.tokens[index].smartAddress).transfer(_wallet, package.tokens[index].amount));
156 	    }
157 	    
158 	    packageSent[_wallet] = _packageIndex;
159 	    packageSentCount++;
160 	    
161 	    emit PackageSent(msg.sender, _wallet, _packageIndex, now);
162 	    
163 	    _success = true;
164 	}
165 	
166 	function dappPurpose(address _dappAddress)
167 	public
168 	returns (bool _success) 
169 	{
170 	    _success = false;
171 	    
172 	    require(msg.sender == owner);
173 	    
174         dapp = _dappAddress;
175         emit DappPurpose(dapp);
176 	    
177 	    _success = true;
178 	}
179 	
180 	function balanceOfTokens(address _token)
181     public 
182     constant
183     returns (uint256 _amount) 
184     {
185         require(_token != address(0));
186         
187         return IERC20(_token).balanceOf(address(this));
188     }
189     
190     function withdrawTokens(address _token, uint256 _amount)
191     public 
192     returns (bool _success) 
193     {
194         require(msg.sender == owner);
195         require(_token != address(0));
196 
197         bool result = IERC20(_token).transfer(owner, _amount);
198         if (result) {
199             emit WithdrawTokens(msg.sender, owner, _token, _amount);
200         }
201         return result;
202     }
203     
204     function withdraw()
205     public 
206     returns (bool success)
207     {
208         require(msg.sender == owner);
209 
210         emit Withdraw(msg.sender, owner, address(this).balance);
211         owner.transfer(address(this).balance);
212         return true;
213     }
214     
215     function suicide()
216     public
217     {
218         require(msg.sender == owner);
219         
220         emit Suicide();
221         selfdestruct(owner);
222     }
223     
224     
225     
226 }