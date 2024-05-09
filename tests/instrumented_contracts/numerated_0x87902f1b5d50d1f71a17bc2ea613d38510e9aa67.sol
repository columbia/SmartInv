1 pragma solidity ^0.4.24;
2 //pragma experimental ABIEncoderV2;
3 
4 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender)
78     public view returns (uint256);
79 
80   function transferFrom(address from, address to, uint256 value)
81     public returns (bool);
82 
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 // File: contracts/registry/BancorBuyer.sol
92 
93 //pragma experimental ABIEncoderV2;
94 
95 
96 
97 
98 contract IMultiToken {
99     function changeableTokenCount() external view returns(uint16 count);
100     function tokens(uint256 i) public view returns(ERC20);
101     function weights(address t) public view returns(uint256);
102     function totalSupply() public view returns(uint256);
103     function mint(address _to, uint256 _amount) public;
104 }
105 
106 
107 contract BancorBuyer {
108     using SafeMath for uint256;
109 
110     mapping(address => uint256) public balances;
111     mapping(address => mapping(address => uint256)) public tokenBalances; // [owner][token]
112 
113     function sumWeightOfMultiToken(IMultiToken mtkn) public view returns(uint256 sumWeight) {
114         for (uint i = mtkn.changeableTokenCount(); i > 0; i--) {
115             sumWeight += mtkn.weights(mtkn.tokens(i - 1));
116         }
117     }
118 
119     function deposit(address _beneficiary, address[] _tokens, uint256[] _tokenValues) payable external {
120         if (msg.value > 0) {
121             balances[_beneficiary] = balances[_beneficiary].add(msg.value);
122         }
123 
124         for (uint i = 0; i < _tokens.length; i++) {
125             ERC20 token = ERC20(_tokens[i]);
126             uint256 tokenValue = _tokenValues[i];
127 
128             uint256 balance = token.balanceOf(this);
129             token.transferFrom(msg.sender, this, tokenValue);
130             require(token.balanceOf(this) == balance.add(tokenValue));
131             tokenBalances[_beneficiary][token] = tokenBalances[_beneficiary][token].add(tokenValue);
132         }
133     }
134 
135     function withdraw(address _to, uint256 _value, address[] _tokens, uint256[] _tokenValues) external {
136         if (_value > 0) {
137             _to.transfer(_value);
138             balances[msg.sender] = balances[msg.sender].sub(_value);
139         }
140 
141         for (uint i = 0; i < _tokens.length; i++) {
142             ERC20 token = ERC20(_tokens[i]);
143             uint256 tokenValue = _tokenValues[i];
144 
145             uint256 tokenBalance = token.balanceOf(this);
146             token.transfer(_to, tokenValue);
147             require(token.balanceOf(this) == tokenBalance.sub(tokenValue));
148             tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].sub(tokenValue);
149         }
150     }
151 
152     // function approveAndCall(address _to, uint256 _value, bytes _data, address[] _tokens, uint256[] _tokenValues) payable external {
153     //     uint256[] memory tempBalances = new uint256[](_tokens.length);
154     //     for (uint i = 0; i < _tokens.length; i++) {
155     //         ERC20 token = ERC20(_tokens[i]);
156     //         uint256 tokenValue = _tokenValues[i];
157 
158     //         tempBalances[i] = token.balanceOf(this);
159     //         token.approve(_to, tokenValue);
160     //     }
161 
162     //     require(_to.call.value(_value)(_data));
163     //     balances[msg.sender] = balances[msg.sender].add(msg.value).sub(_value);
164 
165     //     for (i = 0; i < _tokens.length; i++) {
166     //         token = ERC20(_tokens[i]);
167     //         tokenValue = _tokenValues[i];
168 
169     //         uint256 tokenSpent = tempBalances[i].sub(token.balanceOf(this));
170     //         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].sub(tokenSpent);
171     //         token.approve(_to, 0);
172     //     }
173     // }
174     
175     function buyOne(
176         ERC20 token,
177         address _exchange,
178         uint256 _value,
179         bytes _data
180     ) 
181         payable
182         public
183     {
184         balances[msg.sender] = balances[msg.sender].add(msg.value);
185         uint256 tokenBalance = token.balanceOf(this);
186         require(_exchange.call.value(_value)(_data));
187         balances[msg.sender] = balances[msg.sender].sub(_value);
188         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token]
189             .add(token.balanceOf(this).sub(tokenBalance));
190     }
191     
192     function buy1(
193         address[] _tokens,
194         address[] _exchanges,
195         uint256[] _values,
196         bytes _data1
197     ) 
198         payable
199         public
200     {
201         balances[msg.sender] = balances[msg.sender].add(msg.value);
202         this.buyOne(ERC20(_tokens[0]), _exchanges[0], _values[0], _data1);
203     }
204     
205     function buy2(
206         address[] _tokens,
207         address[] _exchanges,
208         uint256[] _values,
209         bytes _data1,
210         bytes _data2
211     ) 
212         payable
213         public
214     {
215         balances[msg.sender] = balances[msg.sender].add(msg.value);
216         this.buyOne(ERC20(_tokens[0]), _exchanges[0], _values[0], _data1);
217         this.buyOne(ERC20(_tokens[1]), _exchanges[1], _values[1], _data2);
218     }
219     
220     function buy3(
221         address[] _tokens,
222         address[] _exchanges,
223         uint256[] _values,
224         bytes _data1,
225         bytes _data2,
226         bytes _data3
227     ) 
228         payable
229         public
230     {
231         balances[msg.sender] = balances[msg.sender].add(msg.value);
232         this.buyOne(ERC20(_tokens[0]), _exchanges[0], _values[0], _data1);
233         this.buyOne(ERC20(_tokens[1]), _exchanges[1], _values[1], _data2);
234         this.buyOne(ERC20(_tokens[2]), _exchanges[2], _values[2], _data3);
235     }
236     
237     // function buyMany(
238     //     address[] _tokens,
239     //     address[] _exchanges,
240     //     uint256[] _values,
241     //     bytes[] _datas
242     // ) 
243     //     payable
244     //     public
245     // {
246     //     balances[msg.sender] = balances[msg.sender].add(msg.value);
247     //     for (uint i = 0; i < _tokens.length; i++) {
248     //         this.buyOne(ERC20(_tokens[i]), _exchanges[i], _values[i], _datas[i]);
249     //     }
250     // }
251 
252     // function buy(
253     //     IMultiToken _mtkn, // may be 0
254     //     address[] _exchanges, // may have 0
255     //     uint256[] _values,
256     //     bytes[] _datas
257     // ) 
258     //     payable
259     //     public
260     // {
261     //     require(_mtkn.changeableTokenCount() == _exchanges.length, "");
262 
263     //     balances[msg.sender] = balances[msg.sender].add(msg.value);
264     //     for (uint i = 0; i < _exchanges.length; i++) {
265     //         if (_exchanges[i] == 0) {
266     //             continue;
267     //         }
268 
269     //         ERC20 token = _mtkn.tokens(i);
270             
271     //         // ETH => XXX
272     //         uint256 tokenBalance = token.balanceOf(this);
273     //         require(_exchanges[i].call.value(_values[i])(_datas[i]));
274     //         balances[msg.sender] = balances[msg.sender].sub(_values[i]);
275     //         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].add(token.balanceOf(this).sub(tokenBalance));
276     //     }
277     // }
278 
279     // function buyAndMint(
280     //     IMultiToken _mtkn, // may be 0
281     //     uint256 _minAmount,
282     //     address[] _exchanges, // may have 0
283     //     uint256[] _values,
284     //     bytes[] _datas
285     // ) 
286     //     payable
287     //     public
288     // {
289     //     buy(_mtkn, _exchanges, _values, _datas);
290 
291     //     uint256 totalSupply = _mtkn.totalSupply();
292     //     uint256 bestAmount = uint256(-1);
293     //     for (uint i = 0; i < _exchanges.length; i++) {
294     //         ERC20 token = _mtkn.tokens(i);
295 
296     //         // Approve XXX to mtkn
297     //         uint256 thisTokenBalance = tokenBalances[msg.sender][token];
298     //         uint256 mtknTokenBalance = token.balanceOf(_mtkn);
299     //         _values[i] = token.balanceOf(this);
300     //         token.approve(_mtkn, thisTokenBalance);
301             
302     //         uint256 amount = totalSupply.mul(thisTokenBalance).div(mtknTokenBalance);
303     //         if (amount < bestAmount) {
304     //             bestAmount = amount;
305     //         }
306     //     }
307 
308     //     require(bestAmount >= _minAmount);
309     //     _mtkn.mint(msg.sender, bestAmount);
310 
311     //     for (i = 0; i < _exchanges.length; i++) {
312     //         token = _mtkn.tokens(i);
313     //         token.approve(_mtkn, 0);
314     //         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].sub(token.balanceOf(this).sub(_values[i]));
315     //     }
316     // }
317 
318 }