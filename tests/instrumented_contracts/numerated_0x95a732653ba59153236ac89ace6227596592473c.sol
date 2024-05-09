1 pragma solidity ^0.4.23;
2 
3 contract XToken {
4     /**
5     代币：商品购买
6     初始化时定义商品描述，商品价格和单位
7     商品商家:即收款方
8     买家：即出资方
9     */
10     struct Goods {
11         string _desc;   //备注
12         string _name;   //商品名称
13         string _unit;   //商品计量单位
14         uint _price;    //商品价格
15         address _shopowner; //店长
16     }
17 
18     /**
19     买家购物清单
20     */
21     struct ShoppingItem {
22         uint _id;
23         uint _count;
24     }
25     struct ShoppingList {
26         address _buyer;
27         ShoppingItem[] _items;
28     }
29 
30     address private _owner; //平台拥有者
31     address private _finance; //负责财经，平台收款人员
32     uint private _percentage; //接百分比提成
33 
34     //商品列表
35     Goods[] private _goods;
36     //买家清单
37     ShoppingList[] private _buyers;
38 
39 
40 	mapping (address => uint) private balances;
41 
42 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
43 
44 
45 	function send_coin(address from, address to, uint amount) private returns(bool sufficient) {
46 		require(balances[from] > amount, "发起交易的账号没有更多额度");
47 
48 		balances[from] -= amount;
49 		balances[to] += amount;
50 
51 		emit Transfer(from, to, amount);
52 		return true;
53 	}
54 
55     /**
56     只有管理员才可以给其它账号充值
57      */
58     function recharge(address to, uint amount) public returns(bool) {
59         balances[to] += amount;
60         balances[_owner] -= amount;//总账号数据要减少，保证存量一定
61         emit Transfer(_owner, to, amount);
62         return true;
63     } 
64 
65     constructor(uint percent) public {
66 		//balances[msg.sender] = 100000000000;
67 
68         //_owner = msg.sender;
69         _percentage = percent; 
70 
71         //指定两个特殊号
72         _owner = address(0x420534893844e08af857df1b4ee8e25b09eed227); //公链账号
73         _finance = address(0x1Af666fB7D3fF7096eA3b47AB2A710fF10E5Cd41);
74 
75         //_owner = address(0x18523c846681b51cdfa69a5daa251fb1977a151e); //私有链账号
76         //_finance = address(0xbf62672b2705e59df2216499a94a2e53c928d53f); 
77         //代币总量
78         balances[_owner] = 100000000000;
79     }
80 
81     function set_percentage(uint percentage) public {
82         require(msg.sender == _owner, "非平台管理员，不能修改提成");
83 
84         _percentage = percentage;
85     }
86 
87     /**
88      */
89     function add_goods(string name, string unit, uint price, address shopowner, string desc) public returns(uint) {
90         require(price > 0, "商品价格需要大于0");
91         require(shopowner != address(0), "商家地址不能为空");
92         /**
93         新增商品，每个商品的基本属性：价格，单位，名称，拥有者
94         */
95         Goods memory newGoods = Goods({
96             _name: name,
97             _unit: unit,
98             _price: price,
99             _shopowner: shopowner,
100             _desc: desc
101         });
102         
103         _goods.push(newGoods);
104 
105         //返回商品ＩＤ
106         return _goods.length;
107     }
108 
109     function sell_goods(uint goodsID, uint count, address buyer) public returns(uint) {
110         /**
111         出售商品：买家需要向店长　按商品名和数量，支付费用
112         */
113         
114         require(count > 0, "购买数据不能为0");
115         require(buyer != address(0), "买家不能为空");
116 
117         /**
118         查找是否有指定的商品名，如果有就支付，没有返回
119          */
120 
121         uint price;
122         uint p_shop;
123         uint p_owner;
124         /**这里后面需要修改为id来查找，不能用商品名，因为商品名有重复 */
125         for (uint i = 0; i < _goods.length; i++) {
126             if( i ==  goodsID) {
127 
128                 price = _goods[i]._price * count;
129 
130                 p_shop = price * (100 - _percentage) / 100;
131                 p_owner = price * _percentage;
132 
133                 if(false == send_coin(buyer, _goods[i]._shopowner, p_shop)) {
134                     return 0;
135                 }
136                 if(false == send_coin(buyer, _finance, p_owner)) {
137                     return 0;
138                 }
139 
140                 //只存在买家清单中
141                 return price;
142             }
143         }
144 
145         return 0;
146     }
147 
148 
149 
150     function stringsEqual(string storage _a, string memory _b) internal returns (bool) {
151         bytes storage a = bytes(_a);
152         bytes memory b = bytes(_b);
153         if (a.length != b.length)
154             return false;
155         // @todo unroll this loop
156         for (uint i = 0; i < a.length; i ++)
157             if (a[i] != b[i])
158             {
159                 return false;
160             }    
161         return true;
162     }
163     
164 
165 	function get_balance(address addr) public returns(uint) {
166 		return balances[addr];
167 	}
168 }