1 pragma solidity ^0.4.19;
2 
3 contract ERC20
4 {
5     function totalSupply() public constant returns (uint totalsupply);
6     
7     function balanceOf(address _owner) public constant returns (uint balance);
8     
9     function transfer(address _to, uint _value) public returns (bool success);
10     
11     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
12     
13     function approve(address _spender, uint _value) public returns (bool success);
14     
15     function allowance(address _owner, address _spender) public constant returns (uint remaining);
16     
17     event Transfer(address indexed _from, address indexed _to, uint _value);
18     
19     event Approval(address indexed _owner, address indexed _spender, uint _value);
20 }
21 
22 contract AVL is ERC20
23 {
24     uint public incirculation;
25 
26     mapping (address => uint) balances;
27     mapping (address => mapping (address => uint)) allowed;
28     
29     mapping (address => uint) goo;
30 
31     function transfer(address _to, uint _value) public returns (bool success)
32     {
33         uint gas = msg.gas;
34         
35         if (balances[msg.sender] >= _value && _value > 0)
36         {
37             balances[msg.sender] -= _value;
38             balances[_to] += _value;
39             
40             Transfer(msg.sender, _to, _value);
41           
42             refund(gas+1158);
43             
44             return true;
45         } 
46         else
47         {
48             revert();
49         }
50     }
51 
52     function transferFrom(address _from, address _to, uint _value) public returns (bool success)
53     {
54         uint gas = msg.gas;
55 
56         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0)
57         {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             
62             Transfer(_from, _to, _value);
63           
64             refund(gas);
65             
66             return true;
67         }
68         else
69         {
70             revert();
71         }
72     }
73 
74     function approve(address _spender, uint _value) public returns (bool success)
75     {
76         allowed[msg.sender][_spender] = _value;
77 
78         Approval(msg.sender, _spender, _value);
79 
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) public constant returns (uint remaining)
84     {
85         return allowed[_owner][_spender];
86     }
87    
88     function balanceOf(address _owner) public constant returns (uint balance)
89     {
90         return balances[_owner];
91     }
92 
93     function totalSupply() public constant returns (uint totalsupply)
94     {
95         return incirculation;
96     }
97     
98     function refund(uint gas) internal
99     {
100         uint amount = (gas-msg.gas+36120) * tx.gasprice;
101         
102         if (goo[msg.sender] < amount && goo[msg.sender] > 0)
103         {
104             amount = goo[msg.sender];
105         }
106         
107         if (goo[msg.sender] >= amount)
108         {
109             goo[msg.sender] -= amount;
110             
111             msg.sender.transfer(amount);
112         }
113     }
114 }
115 
116 contract Avalanche is AVL 
117 {
118     string public constant name = "Avalanche";
119     uint8 public constant decimals = 4;
120     string public constant symbol = "AVL";
121     string public constant version = "1.0";
122 
123     event tokensCreated(uint total, uint price);
124     event etherSent(uint total);
125     event etherLeaked(uint total);
126     
127     uint public constant pieceprice = 1 ether / 256;
128     uint public constant oneavl = 10000;
129     uint public constant totalavl = 1000000 * oneavl;
130     
131     mapping (address => bytes1) addresslevels;
132 
133     mapping (address => uint) lastleak;
134     
135     function Avalanche() public
136     {
137         incirculation = 10000 * oneavl;
138         balances[0xe277694b762249f62e2458054fd3bfbb0a52ebc9] = 10000 * oneavl;
139     }
140 
141     function () public payable
142     {
143         uint gas = msg.gas;
144 
145         uint generateprice = getPrice(getAddressLevel());
146         uint generateamount = msg.value * oneavl / generateprice;
147         
148         if (incirculation + generateamount > totalavl)
149         {
150             revert();
151         }
152         
153         incirculation += generateamount;
154         balances[msg.sender] += generateamount;
155         goo[msg.sender] += msg.value;
156        
157         refund(gas); 
158         
159         tokensCreated(generateamount, msg.value);
160     }
161    
162     function sendEther(address x) public payable 
163     {
164         uint gas = msg.gas;
165         
166         x.transfer(msg.value);
167         
168         refund(gas+1715);
169         
170         etherSent(msg.value);
171     }
172    
173     function leakEther() public 
174     {
175         uint gas = msg.gas;
176         
177         if (now-lastleak[msg.sender] < 1 days)
178         { 
179             refund(gas);
180             
181             etherLeaked(0);
182             
183             return;
184         }
185         
186         uint amount = goo[msg.sender] / uint(getAddressLevel());
187         
188         if (goo[msg.sender] < amount && goo[msg.sender] > 0)
189         {
190             amount = goo[msg.sender];
191         }
192         
193         if (goo[msg.sender] >= amount)
194         {
195             lastleak[msg.sender] = now;
196             
197             goo[msg.sender] -= amount;
198             
199             msg.sender.transfer(amount);
200             
201             refund(gas+359);
202             
203             etherLeaked(amount);
204         }
205     }
206     
207     function gooBalanceOf(address x) public constant returns (uint) 
208     { 
209         return goo[x]; 
210     }
211     
212     function getPrice(bytes1 addrLevel) public pure returns (uint)
213     {
214         return pieceprice * (uint(addrLevel) + 1);
215     }
216    
217     function getAddressLevel() internal returns (bytes1 res)
218     {
219         if (addresslevels[msg.sender] > 0) 
220         {
221             return addresslevels[msg.sender];
222         }
223       
224         bytes1 highest = 0;
225         
226         for (uint i = 0; i < 20; i++)
227         {
228             bytes1 c = bytes1(uint8(uint(msg.sender) / (2 ** (8 * (19 - i)))));
229             
230             if (bytes1(c) > highest) highest = c;
231         }
232       
233         addresslevels[msg.sender] = highest;
234         
235         return highest;
236     }
237 }