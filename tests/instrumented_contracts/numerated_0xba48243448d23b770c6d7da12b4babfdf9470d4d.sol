1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath
5 {
6     function add(uint256 a, uint256 b) internal pure returns (uint256)
7     {
8         uint256 c = a+b;
9         assert (c>=a);
10         return c;
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256)
13     {
14         assert(a>=b);
15         return (a-b);
16     }
17 
18     function mul(uint256 a,uint256 b)internal pure returns (uint256)
19     {
20         if (a==0)
21         {
22         return 0;
23         }
24         uint256 c = a*b;
25         assert ((c/a)==b);
26         return c;
27     }
28 
29     function div(uint256 a,uint256 b)internal pure returns (uint256)
30     {
31         uint256 c = a/b;
32         return c;
33     }
34 }
35 
36 contract ERC20
37 {
38   function allowance(address owner, address spender) public view returns (uint256);
39   function transferFrom(address from, address to, uint256 value) public returns (bool);
40   function approve(address spender, uint256 value) public returns (bool);
41   function totalSupply() public view returns (uint256);
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 contract Owned
49 {
50     address public owner;
51     function Owned() internal
52      {
53          owner = msg.sender;
54      }
55      modifier onlyowner()
56      {
57          require(msg.sender==owner);
58          _;
59      }
60      function setowner(address _newowner) public onlyowner
61      {
62          owner = _newowner;
63 
64      }
65 }
66 
67 
68 contract TokenControl is ERC20
69 {
70     using SafeMath for uint256;
71     mapping (address =>uint256) internal balances;
72     mapping (address => mapping(address =>uint256)) internal allowed;
73     uint256 totaltoken;
74 
75 
76     function totalSupply() public view returns (uint256)
77     {
78         return totaltoken;
79     }
80 
81     function transfer(address _to, uint256 _value) public returns (bool)
82     {
83         require(_to!=address(0));
84         require(_value <= balances[msg.sender]);
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         emit Transfer(msg.sender, _to, _value);
88         return true;
89     }
90     function balanceOf(address _owner) public view returns (uint256 balance)
91     {
92         return balances[_owner];
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
96     {
97         require(_to != address(0));
98         require(_value <= balances[_from]);
99         require(_value <= allowed[_from][msg.sender]);
100 
101         balances[_from] = balances[_from].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
104         emit Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function approve(address _spender, uint256 _value) public returns (bool)
109     {
110         allowed[msg.sender][_spender] = _value;
111         emit Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) public view returns (uint256)
116     {
117         return allowed[_owner][_spender];
118     }
119 
120     function increaseApproval(address _spender, uint _addedValue) public returns (bool)
121     {
122         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
123         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124         return true;
125     }
126 
127     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool)
128     {
129         uint256 oldValue = allowed[msg.sender][_spender];
130         if (_subtractedValue > oldValue)
131         {
132             allowed[msg.sender][_spender] = 0;
133         }
134         else
135         {
136             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
137         }
138         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139         return true;
140     }
141 }
142 //////////////////////////////////Atoken Start////////////////////////
143 
144 contract AToken is TokenControl,Owned
145 {
146     using SafeMath for uint256 ;
147 
148     string public constant name    = "Alvin's Token";
149     string public constant symbol  = "Atoken";
150     uint8 public decimals = 9;
151 
152 
153     //定義各個stage
154     enum  Stage
155     {
156         first,
157         firstreturn,
158         second,
159         secondreturn,
160         fail
161     }
162     Stage public stage;
163     uint32 public endtime;
164     uint256 public Remain;
165     //進入下一個stage
166     bool public confirm2stage = false;
167     function ownerconfirm() public onlyowner
168     {
169         require (uint32(block.timestamp)> endtime);
170         require (!confirm2stage);
171         Remain = Remain.add(40000000*10**9);
172         totaltoken = 90000000*10**9;
173         confirm2stage = true;
174         verifyStage();
175     }
176 
177     function ownerforce() public onlyowner
178     {
179         require(stage==Stage.second);
180         stage= Stage.secondreturn;
181     }
182 
183     function verifyStage()internal
184     {
185         if (stage==Stage.second&&Remain==0)
186         {
187             stage= Stage.secondreturn;
188         }
189         if (stage==Stage.firstreturn&&confirm2stage)
190         {
191              stage=Stage.second;
192         }
193         if (uint32(block.timestamp)> endtime&&Remain>10000000*10**9&&stage==Stage.first)
194         {
195             stage=Stage.fail;
196         }
197         if (uint32(block.timestamp)>= endtime&&stage==Stage.first)
198         {
199              stage=Stage.firstreturn;
200         }
201     }
202 
203     //根據不同state給予不同價錢
204     function price() internal constant returns (uint256)
205     {
206         if(stage==Stage.first)
207         {
208             return 10;
209         }
210         if(stage==Stage.second)
211         {
212             return 8;
213         }
214         else
215         {
216         return 0;
217         }
218     }
219 
220     //block時間
221     function timeset() public constant returns (uint256)
222     {
223         return block.timestamp;
224     }
225     function viewprice() public constant returns (uint256)
226     {
227         return price();
228     }
229 
230     //給予contract初始值
231     function AToken() public
232     {
233         totaltoken = 50000000*10**9;
234         Remain = totaltoken;
235         endtime = 1524571200;
236         stage= Stage.first;
237 
238     }
239     function () public payable
240     {
241         buyAtoken();
242     }
243 
244     function buyAtoken() public payable
245     {
246       //reject the buyer from contract
247         require(!isContract(msg.sender));
248         require(Remain>0);
249 
250       //check current changerate
251         uint256 rate = price();
252       //return if not in payable stage
253         require(rate >0);
254         uint256 requested;
255         uint256 toreturn;
256         requested = msg.value.mul(rate);
257         if (requested >Remain)
258         {
259           requested = Remain;
260           toreturn = msg.value.sub(Remain.div(rate));
261         }
262         Remain = Remain.sub(requested);
263         balances[msg.sender]=balances[msg.sender].add(requested);
264 
265         if (toreturn>0)
266         {
267             msg.sender.transfer(toreturn);
268         }
269         verifyStage();
270     }
271 
272 
273     function greedyowner() public
274     {
275         require(msg.sender==owner);
276         selfdestruct(owner);
277     }
278 
279     function withdraw() public
280     {
281       require(stage==Stage.fail);
282       require(balances[msg.sender]>0);
283       uint256 ethreturn = balances[msg.sender].div(10);
284       balances[msg.sender] = 0;
285       msg.sender.transfer(ethreturn);      
286     }
287 
288 
289     function isContract(address _addr) constant internal returns(bool) 
290     {
291         uint size;
292         if (_addr == 0) return false;
293         assembly {
294             size := extcodesize(_addr)
295         }
296         return size > 0;
297     }
298     
299     function ownertransfer(address _target,uint256 _amount) public onlyowner
300     {
301         require(stage==Stage.firstreturn||stage==Stage.secondreturn);
302         uint256 contractvalue = address(this).balance;
303         require(contractvalue>0);
304         if (_amount>contractvalue)
305         {
306             _target.transfer(contractvalue);
307         }    
308         else
309         {
310             _target.transfer(_amount);
311         }
312         
313     }
314 
315 }