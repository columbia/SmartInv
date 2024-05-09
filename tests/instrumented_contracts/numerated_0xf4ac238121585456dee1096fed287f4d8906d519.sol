1 contract StandardToken
2 {
3     string public name;
4     string public symbol; 
5     uint256 public decimals;
6     uint256 public totalSupply;
7     mapping(address => uint256) public balanceOf;
8     mapping (address => mapping (address => uint256)) public allowance;
9     
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12     
13     function transfer(address _to, uint256 _value) public returns (bool) {
14         if( _value > balanceOf[msg.sender] || (balanceOf[_to]+_value) < balanceOf[_to]) return false;
15         balanceOf[msg.sender] -= _value;
16         balanceOf[_to] += _value;
17         Transfer(msg.sender, _to, _value);
18         return true;
19     }
20     
21     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
22         if( _value > balanceOf[_from] || _value > allowance[_from][msg.sender] || (balanceOf[_to]+_value) < balanceOf[_to] ) return false;
23         balanceOf[_from] -=_value;
24         balanceOf[_to] += _value;
25         allowance[_from][msg.sender] -= _value;
26         Transfer(_from, _to, _value);
27         return true;
28     }
29     
30     function approve(address _spender, uint256 _value) public returns (bool) {
31         allowance[msg.sender][_spender] = _value;
32         Approval(msg.sender, _spender, _value);
33         return true;
34     }
35 }
36 
37 contract ExtendetdToken is StandardToken
38 {
39     function batchTransfer(address[] _receivers, uint256 _value) public returns (bool) { 
40         uint256 cnt = _receivers.length;
41         uint256 amount = cnt * _value;
42         if(amount == 0) return false;
43         if(balanceOf[msg.sender] < amount) return false;
44         balanceOf[msg.sender] -= amount;
45         for (uint i = 0; i < cnt; i++) {
46             balanceOf[_receivers[i]] += _value;
47             Transfer(msg.sender, _receivers[i], _value);
48             }
49         return true;
50     }
51 }
52 
53 contract Traded is ExtendetdToken
54 {
55     mapping (address=>bool) public managers;
56     
57     modifier onlyManager()
58     {
59         if(!managers[msg.sender])throw;
60         _;
61     }
62     
63     event deal(address indexed seller, address indexed buyer, uint256 amount, uint256 price, bytes32 indexed data);
64     
65     function Trade(uint256 _qty, uint256 _price, bytes32 _data, address _seller, address _buyer) payable onlyManager
66     {
67         if(balanceOf[_seller]<_qty)return;
68         if(balanceOf[_buyer]+_qty<balanceOf[_buyer])return;
69         uint256 total = _qty*_price;
70         _seller.transfer(total);
71         balanceOf[_seller]-=_qty;
72         balanceOf[_buyer]+=_qty;
73         Transfer(_seller,_buyer,_qty);
74         deal(_seller,_buyer,_qty,_price,_data);
75     }
76     
77 }
78 
79 contract Shark is Traded
80 {
81     function Shark()
82     {
83         name = "SHARK TECH";
84         symbol = "SKT";
85         decimals = 18;
86         totalSupply = 100000000000000000000000;
87         balanceOf[msg.sender]=totalSupply;
88         managers[this]=true;
89     }
90     
91     address public owner = msg.sender;
92     
93     uint256 public price = 1;
94     
95     modifier onlyHuman()
96     {
97         if(msg.sender!=tx.origin)throw;
98         _;
99     }
100     
101     modifier onlyOwner()
102     {
103         if(msg.sender!=owner)throw;
104         _;
105     }
106     
107     function changePrice(uint256 _newPrice)
108     onlyOwner
109     {
110         if(_newPrice>price)
111         {
112             price = _newPrice;
113         }
114     }
115     
116     function Buy()
117     payable
118     onlyHuman
119     {
120         if(msg.value<price*1 ether)throw;
121         this.Trade(msg.value/price,price,"",owner,msg.sender); 
122     }
123     
124     function Sell(uint256 _qty) 
125     payable
126     onlyHuman
127     {
128         if(this.balance<_qty*price)throw;
129         this.Trade(_qty,price,"buyback",msg.sender,owner);
130     }
131     
132     function airDrop(address[] _adr,uint256 _val)
133     public
134     payable
135     {
136         if(msg.value >= _adr.length * _val)
137         {
138             Buy();
139             batchTransfer(_adr,_val);
140         }
141     }
142     
143     function cashOut(uint256 _am)
144     onlyOwner
145     payable
146     {
147         owner.transfer(_am);
148     }
149     
150     function() public payable{}
151     
152 }