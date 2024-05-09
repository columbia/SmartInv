1 pragma solidity ^0.4.24;
2 contract OWN 
3 {
4     address public owner;
5     address internal newOwner;
6     constructor() 
7     public
8     payable
9     {
10         owner = msg.sender;
11     }
12     
13     modifier onlyOwner 
14     {
15         require(owner == msg.sender);
16         _;
17     }
18     function changeOwner(address _owner)
19     onlyOwner 
20     public
21     {
22         require(_owner != 0);
23         newOwner = _owner;
24     }
25     function confirmOwner()
26     public 
27      { 
28         require(newOwner == msg.sender);
29         owner = newOwner;
30         delete newOwner;
31     }
32 }
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a / b;
44     return c;
45   }
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 contract ERC20 
57 {
58     string  public constant name     = "DRIVER ETHEREUM";
59     string  public constant symbol   = "DRETH";
60     uint8   public constant decimals =  6;
61     uint256 public  totalSupply; //TOTAL 
62     
63     event Approval(address indexed owner, address indexed spender, uint value);
64     event Transfer(address indexed from, address indexed to, uint value);
65     mapping (address => mapping(address => uint256)) public allowance;
66     mapping (address => uint256) public balanceOf;
67     function balanceOf(address who)
68     public constant
69     returns (uint)
70     {
71         return balanceOf[who];
72     }
73     function approve(address _spender, uint _value)
74     public
75     {
76         allowance[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78     }
79     function allowance(address _owner, address _spender) 
80     public constant 
81     returns (uint remaining) 
82     {
83         return allowance[_owner][_spender];
84     }
85     modifier onlyPayloadSize(uint size) 
86     {
87         require(msg.data.length >= size + 4);
88         _;
89     }
90 }
91 contract DRIVER is OWN, ERC20
92 {
93     using SafeMath for uint256;
94     
95     uint256 public   Price = 800000000; //INIT
96     uint256 internal Minn  = 10000000000000000; //0.01 MIN
97     uint256 internal Maxx  = 10000000000000000000; //10 MAX
98     uint256 internal Bank; //BANK RESERVE 
99 
100     function () 
101     payable public 
102     {
103         require(msg.value>0);
104         require(msg.value >= Minn);
105         require(msg.value <= Maxx);
106         mintTokens(msg.sender, msg.value);
107     }
108 
109     function mintTokens(address _who, uint256 _value) 
110     internal 
111         {
112         require(_value >= Minn);
113         require(_value <= Maxx);
114         uint256 tokens = _value / (Price*10/8); //sale price
115         require(tokens > 0); 
116         require(balanceOf[_who] + tokens > balanceOf[_who]);
117         totalSupply += tokens; //mint tokens
118         balanceOf[_who] += tokens; //add tokens
119         uint256 perc = _value.div(100);
120         Bank += perc.mul(87);  // add to reserve
121         Price = Bank.div(totalSupply); // pump   
122         uint256 minus = _value % (Price*10/8); //change
123         require(minus > 0);
124         chart_call(); //log 
125         emit Transfer(this, _who, tokens);
126         _value=0; tokens=0;
127         owner.transfer(perc.mul(6)); //prof
128         _who.transfer(minus); //return
129         minus=0; 
130     }    
131 
132     mapping (uint256 => uint256) public chartPrice;//PRICES
133     mapping (uint256 => uint256) public chartVolume;//VOLUM
134     uint256 public BlockTime=0;//TIMER 
135     function chart_call()//SAVE STATS
136     internal
137     {
138         uint256 cm = (now.div(1800));//~30min.
139         if(cm > BlockTime)
140         { 
141             BlockTime = cm;
142             chartPrice[BlockTime]  = Price;
143             chartVolume[BlockTime] = totalSupply;
144         }
145     }
146     function transfer (address _to, uint _value) 
147     public onlyPayloadSize(2 * 32) 
148     returns (bool success)
149     {
150         require(balanceOf[msg.sender] >= _value);
151         if(_to != address(this)) //standart transfer
152         { 
153         require(balanceOf[_to] + _value >= balanceOf[_to]);
154         balanceOf[msg.sender] -= _value;
155         balanceOf[_to] += _value;
156         emit Transfer(msg.sender, _to, _value);  
157         }
158         else //sale to contract
159         {
160         balanceOf[msg.sender] -= _value;
161         uint256 change = _value.mul(Price);
162         require(address(this).balance >= change);
163 		if(totalSupply > _value){
164         uint256 plus = ( address(this).balance - Bank ).div(totalSupply);    
165         Bank -= change; 
166         totalSupply -= _value;
167         Bank += (plus.mul(_value)); // increase reserve
168         Price = Bank.div(totalSupply); // pump
169         chart_call();
170         emit Transfer(msg.sender, _to, _value);
171         }
172         if(totalSupply == _value){ //sale all
173         Price = address(this).balance/totalSupply;
174         Price = (Price.mul(102)).div(100); //pump
175         totalSupply=0;
176         Bank=0;
177         chart_call();
178         emit Transfer(msg.sender, _to, _value);
179         owner.transfer(address(this).balance - change);
180         }
181         msg.sender.transfer(change);
182         }
183         return true;
184     }
185     
186     function transferFrom(address _from, address _to, uint _value) 
187     public onlyPayloadSize(3 * 32)
188     returns (bool success)
189     {
190         require(balanceOf[_from] >= _value);
191         require(allowance[_from][msg.sender] >= _value);
192         if(_to != address(this))  // standart transfer
193         {
194         require(balanceOf[_to] + _value >= balanceOf[_to]);
195         balanceOf[_from] -= _value;
196         balanceOf[_to] += _value;
197         allowance[_from][msg.sender] -= _value;
198         emit Transfer(_from, _to, _value);
199         }
200         else //sale to contract
201         {
202         balanceOf[_from] -= _value;
203         uint256 change = _value.mul(Price);
204         require(address(this).balance >= change);
205         if(totalSupply > _value){ 
206         uint256 plus = ( address(this).balance - Bank ).div(totalSupply);    
207         Bank -= change; 
208         totalSupply -= _value;
209         Bank += (plus.mul(_value)); // increase reserve
210         Price = Bank.div(totalSupply); // pump
211         chart_call();
212         emit Transfer(_from, _to, _value);
213         allowance[_from][msg.sender] -= _value;
214         }
215         if(totalSupply == _value){ //sale all
216         Price = address(this).balance/totalSupply;
217         Price = (Price.mul(102)).div(100); //pump
218         totalSupply=0; 
219         Bank=0; 
220         chart_call();
221         emit Transfer(_from, _to, _value);
222         allowance[_from][msg.sender] -= _value;
223         owner.transfer(address(this).balance - change);
224         }
225         _from.transfer(change);
226         }
227         return true;
228     }
229     function money() 
230     public view 
231     returns (uint) 
232     {
233         return address(this).balance;
234     }
235 }