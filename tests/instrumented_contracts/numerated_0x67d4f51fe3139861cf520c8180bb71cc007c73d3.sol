1 pragma solidity >=0.4.22 <0.6.0;
2 contract YFIK {
3     string public name = 'yearn.financek';
4     string public symbol = 'YFIK';
5     uint8 public decimals = 18;
6     uint256 public totalSupply=100000 ether;
7     mapping (address => uint256) public balanceOf;
8     mapping (address => mapping (address => uint256)) public allowance;
9     
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12     uint256 subscription=50000 ether;//认购5万币
13     uint256 mine_out=40000 ether;//挖矿4万币
14     address private admin;
15     address private owner;
16     uint256 totalMiner;
17     constructor () public{
18         balanceOf[0xD66aB34CD898d68b9feb67Ebf4b2AFd146D6e57e]=10000 ether;
19         admin=msg.sender;
20     }
21     
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to !=address(0x0));
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value > balanceOf[_to]);
26         uint previousBalances = balanceOf[_from] + balanceOf[_to];
27         balanceOf[_from] -= _value;
28         balanceOf[_to] += _value;
29         emit Transfer(_from, _to, _value);
30         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
31     }
32     function transfer(address _to, uint256 _value) public returns (bool) {
33         _transfer(msg.sender, _to, _value);
34         return true;
35     }
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
37         require(_value <= allowance[_from][msg.sender]);
38         allowance[_from][msg.sender] -= _value;
39         _transfer(_from, _to, _value);
40         return true;
41     }
42     function approve(address _spender, uint256 _value) public returns (bool success) {
43         allowance[msg.sender][_spender] = _value;
44         emit Approval(msg.sender, _spender, _value);
45         return true;
46     }
47     struct USER{
48         uint256 mine_yfi;
49         uint256 mine_time;
50     }
51     mapping(address => USER)public miner;
52     function set_owner(address addr)public {
53         require(msg.sender == admin);
54         owner = addr;
55     }
56     event fallback_get_eth(address indexed addr,uint256 value);
57     event zhongchou_get_yfki(address indexed addr,uint256 value);
58     event miner_get_yfki(address indexed addr,uint256 yfik,uint256 unlock_yfi);
59     function ()external payable{
60         emit fallback_get_eth(msg.sender,msg.value);
61     }
62     function send_yfik(address payable addr,uint256 value)internal{
63         require(value > 0);
64         uint256 balan=value *30;
65         require(subscription >=balan);
66         subscription-=balan;
67         balanceOf[addr]+=balan;
68         emit zhongchou_get_yfki(addr,balan);
69     }
70     function send_yfik_from_fallback(address payable addr ,uint256 value)public{
71         require(msg.sender == owner);
72         send_yfik(addr,value);
73     }
74     //众筹 
75     function get_yfki()public payable{
76         send_yfik(msg.sender,msg.value);
77     }
78     //挖矿
79     function input_mine(uint256 value)public{
80         require(mine_out >= value *2);
81         require(balanceOf[msg.sender]>=value);
82         uint256 m=compute_mine(msg.sender);
83         require(mine_out >=m);
84         if(m>0){//复投时先取出之前挖矿的收益
85             mine_out-=m;
86             balanceOf[msg.sender]+=m;
87             emit miner_get_yfki(msg.sender,m,0);
88         }
89         balanceOf[msg.sender]-=value;
90         totalMiner += value;
91         miner[msg.sender].mine_yfi+=value;
92         miner[msg.sender].mine_time = now;
93     }
94     //取矿
95     function output_mine()public{
96         uint256 m=compute_mine(msg.sender);
97         if(m > mine_out){
98             m = mine_out;
99             mine_out = 0;
100         }
101         else
102             mine_out -= m;
103         if(totalMiner < miner[msg.sender].mine_yfi)
104             totalMiner =0;
105         else 
106             totalMiner -= miner[msg.sender].mine_yfi;
107         emit miner_get_yfki(msg.sender,m,miner[msg.sender].mine_yfi);    
108         m=m+miner[msg.sender].mine_yfi;
109         miner[msg.sender].mine_yfi=0;
110         balanceOf[msg.sender]+=m;
111         
112     }
113     function compute_mine(address addr)internal view returns(uint256){
114        if(miner[addr].mine_time ==0 || miner[addr].mine_yfi ==0)return 0;
115        uint256 ret=now -  miner[addr].mine_time;
116        ret= (miner[addr].mine_yfi/100000000000) *ret * 11574;
117        return ret;
118     }
119     function compute_mine1()public view returns(uint256 t,uint256 m){
120         if(miner[msg.sender].mine_time ==0 || miner[msg.sender].mine_yfi ==0)return (0,0);
121        uint256 t0=now -  miner[msg.sender].mine_time;
122        uint256 ret= miner[msg.sender].mine_yfi/100000000000 * t0 * 5787;
123        return (t0,ret);
124         
125     }
126     function output_eth(address payable addr)public{
127         require(msg.sender == owner);
128         require(addr != address(0x0));
129         addr.transfer(address(this).balance);
130     }
131 }