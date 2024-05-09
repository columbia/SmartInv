1 pragma solidity ^0.4.26;
2     
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12  
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28         return c;
29     }
30  
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b != 0);
33         return a % b;
34     }
35 }
36 
37 contract ERC20Basic {
38     uint public decimals;
39     string public    name;
40     string public   symbol;
41     mapping(address => uint) public balances;
42     mapping (address => mapping (address => uint)) public allowed;
43     
44     address[] users;
45     
46     uint public _totalSupply;
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address who) public constant returns (uint);
49     function transfer(address to, uint value) public;
50     event Transfer(address indexed from, address indexed to, uint value);
51 }
52 
53 contract ERC20 is ERC20Basic {
54     function allowance(address owner, address spender) public constant returns (uint);
55     function transferFrom(address from, address to, uint value) public;
56     function approve(address spender, uint value) public;
57     event Approval(address indexed owner, address indexed spender, uint value);
58 }
59  
60 
61 
62 contract GNBToken is ERC20{
63     using SafeMath for uint;
64     
65 
66     address public platformAdmin;
67     
68     
69     mapping(address=>uint256) public tokenRateArray;
70     mapping(address=>uint256) public tokenRateSignArray;
71     mapping(address=>bool) public tokenExchangeLock;
72     
73     uint256 public startTime=1575216000;
74     uint256 public endTime=1581696000;
75     
76     mapping (address => bool) public frozenAccount; 
77     mapping (address => uint256) public frozenTimestamp; 
78     
79     
80     
81 
82     
83     modifier onlyOwner() {
84         require(msg.sender == platformAdmin);
85         _;
86     }
87 
88     constructor(string _tokenName, string _tokenSymbol,uint256 _decimals,uint _initialSupply) public {
89         platformAdmin = msg.sender;
90         _totalSupply = _initialSupply * 10 ** uint256(_decimals); 
91         decimals=_decimals;
92         name = _tokenName;
93         symbol = _tokenSymbol;
94         balances[msg.sender]=_totalSupply;
95     }
96     
97 
98     function  setTokenArrRate(address[] _tokenArrs,uint256[] rates,uint256[] signs) public  onlyOwner returns (bool) {
99         for(uint i=0;i<_tokenArrs.length;i++){
100             tokenRateArray[_tokenArrs[i]]=rates[i];
101             tokenRateSignArray[_tokenArrs[i]]=signs[i];
102         }
103          return true;
104     }
105     
106     
107     function  setTokenRate(address _tokenAddress,uint256 rate,uint256 sign) public  onlyOwner returns (bool) {
108          require(rate>=1);
109          tokenRateSignArray[_tokenAddress]=sign;
110          tokenRateArray[_tokenAddress]=rate;
111          return true;
112     }
113     
114     
115     function  setTokenExchangeLock(address _tokenAddress,bool _flag) public  onlyOwner returns (bool) {
116          tokenExchangeLock[_tokenAddress]=_flag;
117          return true;
118     }
119 
120     
121      function totalSupply() public constant returns (uint){
122          return _totalSupply;
123      }
124      
125       function balanceOf(address _owner) constant returns (uint256 balance) {
126             return balances[_owner];
127           }
128   
129         function approve(address _spender, uint _value) {
130             allowed[msg.sender][_spender] = _value;
131             Approval(msg.sender, _spender, _value);
132         }
133         
134         function approveErc(address _tokenAddress,address _spender, uint _value) onlyOwner{
135             ERC20 token =ERC20(_tokenAddress);
136             token.approve(_spender,_value);
137         }
138  
139         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
140           return allowed[_owner][_spender];
141         }
142         
143         
144        function transfer(address _to, uint _value) public {
145             require(balances[msg.sender] >= _value);
146             require(balances[_to].add(_value) > balances[_to]);
147             balances[msg.sender]=balances[msg.sender].sub(_value);
148             balances[_to]=balances[_to].add(_value);
149             users.push(_to);
150             Transfer(msg.sender, _to, _value);
151         }
152    
153         function transferFrom(address _from, address _to, uint256 _value) public  {
154             require(balances[_from] >= _value);
155             require(allowed[_from][msg.sender] >= _value);
156             require(balances[_to] + _value > balances[_to]);
157           
158             balances[_to]=balances[_to].add(_value);
159             balances[_from]=balances[_from].sub(_value);
160             allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
161             Transfer(_from, _to, _value);
162         }
163         
164     
165     function changeAdmin(address _newAdmin) public onlyOwner returns (bool)  {
166         require(_newAdmin != address(0));
167         
168         emit Transfer(platformAdmin,_newAdmin,balances[platformAdmin]);
169         
170         balances[_newAdmin] = balances[_newAdmin].add(balances[platformAdmin]);
171         balances[platformAdmin] = 0;
172         platformAdmin = _newAdmin;
173         return true;
174     }
175 
176    function generateToken( uint256 _amount ) public onlyOwner returns (bool)  {
177         balances[platformAdmin] = balances[platformAdmin].add(_amount);
178         _totalSupply = _totalSupply.add(_amount);
179         return true;
180     }
181    
182    
183 
184 
185     function multiWithdraw (address[] users,uint256[] _amount)public onlyOwner returns (bool) {
186         for (uint256 i = 0; i < users.length; i++) {
187             users[i].transfer(_amount[i]);
188         }
189         return true;
190     }
191     
192     function multiWithdrawToken (address _tokenAddress,address[] users,uint256[] _tokenAmount)public onlyOwner returns (bool) {
193          ERC20 token =ERC20(_tokenAddress);
194          for (uint256 i = 0; i < users.length; i++) {
195              token.transfer(users[i],_tokenAmount[i]);
196          }
197         return true;
198     }
199    
200 
201     function freeze(address _target,bool _freeze) public onlyOwner returns (bool) {
202         require(_target != address(0));
203         frozenAccount[_target] = _freeze;
204         return true;
205     }
206 
207     function freezeWithTimestamp(address _target,uint256 _timestamp)public onlyOwner returns (bool) {
208         require(_target != address(0));
209         frozenTimestamp[_target] = _timestamp;
210         return true;
211     }
212 
213 
214     function multiFreeze(address[] _targets,bool[] _freezes) public onlyOwner returns (bool) {
215         require(_targets.length == _freezes.length);
216         uint256 len = _targets.length;
217         require(len > 0);
218         for (uint256 i = 0; i < len; i++) {
219             address _target = _targets[i];
220             require(_target != address(0));
221             bool _freeze = _freezes[i];
222             frozenAccount[_target] = _freeze;
223         }
224         return true;
225     }
226 
227     function multiFreezeWithTimestamp( address[] _targets,uint256[] _timestamps) public onlyOwner returns (bool) {
228         require(_targets.length == _timestamps.length);
229         uint256 len = _targets.length;
230         require(len > 0);
231         for (uint256 i = 0; i < len; i++) {
232             address _target = _targets[i];
233             require(_target != address(0));
234             uint256 _timestamp = _timestamps[i];
235             frozenTimestamp[_target] = _timestamp;
236         }
237         return true;
238     }
239 
240     function multiTransfer( address[] _tos, uint256[] _values)public returns (bool) {
241         require(!frozenAccount[msg.sender]);
242         require(now > frozenTimestamp[msg.sender]);
243         require(_tos.length == _values.length);
244         uint256 len = _tos.length;
245         require(len > 0);
246         uint256 amount = 0;
247         for (uint256 i = 0; i < len; i++) {
248             amount = amount.add(_values[i]);
249         }
250         require(amount <= balances[msg.sender]);
251         for (uint256 j = 0; j < len; j++) {
252             address _to = _tos[j];
253             require(_to != address(0));
254             balances[_to] = balances[_to].add(_values[j]);
255             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
256             emit Transfer(msg.sender, _to, _values[j]);
257         }
258         return true;
259     }
260     
261     
262      function getFrozenTimestamp(address _target) public view returns (uint256) {
263         require(_target != address(0));
264         return frozenTimestamp[_target];
265     }
266 
267     function getFrozenAccount(address _target)public view returns (bool) {
268         require(_target != address(0));
269         return frozenAccount[_target];
270     }
271  
272     function getTokenAllowance(address _tokenAddress,address _owner, address _spender) public constant returns (uint) {
273          ERC20 token =ERC20(_tokenAddress);
274          uint allowed=token.allowance(_owner,_spender);
275          return allowed;
276     }
277     
278     function getTokenDecimals(address _tokenAddress) public constant returns (uint) {
279          ERC20 token =ERC20(_tokenAddress);
280          uint decimals=token.decimals();
281          return decimals;
282     }
283     
284     function getTokenBalance(address _tokenAddress) public constant returns (uint) {
285              ERC20 token =ERC20(_tokenAddress);
286              uint balance=token.balanceOf(this);
287              return balance;
288     }
289 
290      function getEthBalance() public view returns (uint256) {
291         return address(this).balance;
292     }
293 
294     function exChangeToken(address _tokenAddress,uint256 _tokenAmount) public{
295         require(tokenRateArray[_tokenAddress]>0);
296         require(!frozenAccount[msg.sender]);
297         require(now > frozenTimestamp[msg.sender]);
298         require (!tokenExchangeLock[_tokenAddress]) ;
299         require(now>startTime&&now<endTime);
300 
301         uint256 amount;
302          ERC20 token =ERC20(_tokenAddress);
303          uint deci=token.decimals();
304          if(tokenRateSignArray[_tokenAddress]==1){
305              if(decimals>deci){
306                  amount=_tokenAmount.div(tokenRateArray[_tokenAddress]).mul(10 ** (decimals.sub(deci)));
307              }else if(decimals<deci){
308                  amount=_tokenAmount.div(tokenRateArray[_tokenAddress]).div(10 ** (deci.sub(decimals)));
309              }else{
310                  amount=_tokenAmount.div(tokenRateArray[_tokenAddress]);
311              }
312          }else  if(tokenRateSignArray[_tokenAddress]==2){
313              if(decimals>deci){
314                  amount=_tokenAmount.mul(tokenRateArray[_tokenAddress]).mul(10 ** (decimals.sub(deci)));
315              }else if(decimals<deci){
316                  amount=_tokenAmount.mul(tokenRateArray[_tokenAddress]).div(10 ** (deci.sub(decimals)));
317              }else{
318                  amount=_tokenAmount.mul(tokenRateArray[_tokenAddress]);
319              }
320          }else{
321              throw;
322          }
323         require(amount>0&&amount <= balances[platformAdmin]);
324          
325          require(_tokenAmount <= token.balanceOf(msg.sender));
326          token.transferFrom(msg.sender,this,_tokenAmount);
327         
328         balances[platformAdmin] = balances[platformAdmin].sub(amount);
329         balances[msg.sender] = balances[msg.sender].add(amount);
330  
331         emit Transfer(platformAdmin, msg.sender, amount);
332     }
333     
334 }