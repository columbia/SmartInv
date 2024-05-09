1 pragma solidity ^0.4.11;
2 
3  library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 
52  contract ERC20Basic {
53   uint public totalSupply;
54   function balanceOf(address who) constant returns (uint);
55   function transfer(address to, uint value);
56   event Transfer(address indexed from, address indexed to, uint value);
57 }
58 
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) constant returns (uint);
61   function transferFrom(address from, address to, uint value);
62   function approve(address spender, uint value);
63   event Approval(address indexed owner, address indexed spender, uint value);
64 }
65 
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint;
68 
69   mapping(address => uint) balances;
70 
71   modifier onlyPayloadSize(uint size) {
72      if(msg.data.length < size + 4) {
73        throw;
74      }
75      _;
76   }
77 
78   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82   }
83 
84   function balanceOf(address _owner) constant returns (uint balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 contract StandardToken is BasicToken, ERC20 {
91 
92   mapping (address => mapping (address => uint)) allowed;
93 
94   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
95     var _allowance = allowed[_from][msg.sender];
96     balances[_to] = balances[_to].add(_value);
97     balances[_from] = balances[_from].sub(_value);
98     allowed[_from][msg.sender] = _allowance.sub(_value);
99     Transfer(_from, _to, _value);
100   }
101 
102 
103   function approve(address _spender, uint _value) {
104     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
105     allowed[msg.sender][_spender] = _value;
106     Approval(msg.sender, _spender, _value);
107   }
108 
109 
110   function allowance(address _owner, address _spender) constant returns (uint remaining) {
111     return allowed[_owner][_spender];
112   }
113 
114 }
115 
116 contract BAC is StandardToken{
117     string public constant name = "BananaFundCoin";
118     string public constant symbol = "BAC";
119     uint public constant decimals = 18;
120     string public version = "1.0";
121     
122     //1以太可以兑换代币数量
123     uint public price ;
124     uint public issueIndex = 0;
125     //代币分配
126     uint public constant bacFund =500*(10**6)*10**decimals;
127     uint public constant MaxReleasedBac =1000*(10**6)*10**decimals;
128     //判定是否在BAC兑换中
129     bool public saleOrNot;
130     //事件
131     event InvalidCaller(address caller);
132     event Issue(uint issueIndex, address addr, uint ethAmount, uint tokenAmount);
133     event StartOK();
134     event InvalidState(bytes msg);
135     event ShowMsg(bytes msg);
136     
137     //定义为合约部署的部署钱包地址
138     address public target;
139     
140     //合约转账地址   代币兑换价格 
141     function BAC(uint _price){
142         target = msg.sender;
143         price =_price;
144         totalSupply=bacFund;
145         balances[target] = bacFund;
146         saleOrNot = false;
147     }
148     
149     modifier onlyOwner {
150         if (target == msg.sender) {
151           _;
152         } else {
153             InvalidCaller(msg.sender);
154             throw;
155         }
156     }
157 
158     modifier inProgress {
159         if (saleStarted()) {
160             _;
161         } else {
162             InvalidState("Sale is not in progress");
163             throw;
164         }
165     }
166   
167     //根据转入的以太币数额返币
168     function () payable{
169         if(saleOrNot){
170             issueToken(msg.sender);
171         }else{
172             throw;
173         }
174     }
175     
176     function issueToken(address recipient) payable inProgress{
177         assert(msg.value >= 0.01 ether);
178         //计算可以获得代币的数量
179         uint  amount = computeAccount(msg.value);
180         if(totalSupply < bacFund+MaxReleasedBac){
181             balances[recipient] = balances[recipient].add(amount);
182             totalSupply = totalSupply.add(amount);
183             Issue(issueIndex++, recipient,msg.value, amount);
184         }else{
185             InvalidState("BAC is not enough");
186             throw;
187         }
188         //将以太转入发起者的钱包地址
189         if (!target.send(msg.value)) {
190             throw;
191         }
192     }
193     
194     //计算返回代币的数量
195     function computeAccount(uint ehtAccount) internal constant returns (uint tokens){
196         tokens=price.mul(ehtAccount);
197     }
198     
199     //定义代币的兑换比列
200     function setPrice(uint _price) onlyOwner{
201         if(_price>0){
202             price= _price;
203         }else{
204             ShowMsg("Invalid price");
205         }
206     }
207     
208     //开启代币的发售
209     function startSale() onlyOwner{
210         if(!saleOrNot){
211             saleOrNot = true;
212             StartOK();
213         }else{
214             ShowMsg("sale is ing ");
215         }
216     }   
217     
218     // 停止代币的发售
219     function stopSale() onlyOwner{
220         if(saleOrNot) {
221             saleOrNot=false;
222             //将剩余的不足的代币转入target
223             if(totalSupply< 1500*(10**6)*10**decimals){
224                 balances[target] = balances[target].add(1500*(10**6)*10**decimals-totalSupply);
225             }
226         }else{
227             ShowMsg("sale has been over");
228         }
229     }
230     
231     function saleStarted() constant returns (bool) {
232         return saleOrNot;
233     }
234     
235     //自杀
236     function destroy() onlyOwner{
237         suicide(target);
238     }
239 }