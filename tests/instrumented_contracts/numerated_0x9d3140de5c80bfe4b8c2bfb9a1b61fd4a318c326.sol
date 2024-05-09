1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract OldContract
4 {
5     function balanceOf(address addr) public view returns(uint256);
6     function user_addr(uint32 index)public view returns(address);
7 }
8 
9 contract AnowToken {
10     string public name = 'Anow ';
11     string public symbol = 'Anow';
12     uint8 public decimals = 18;
13     uint256 public totalSupply;
14     uint256 private team_before_miner=3000000 ether;
15     mapping (address => USERINFO) public user;
16     mapping (address => mapping (address => uint256)) public allowance;
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     address private admin;
19     address private owner;
20     uint8 private updata_old;
21     struct USERINFO{
22         uint256 anow;
23         uint256 mine;
24         uint256 time;
25         uint8 is_hacker;
26     }
27     
28     constructor () public {
29         admin=msg.sender;
30         owner=address(0x166451fFd5F53d2691e0734bEF2f3503747380B9);
31     }
32     
33     function _transfer(address _from, address _to, uint _value) internal {
34 
35         require(_to !=address(0x0));
36         require(user[_from].anow >= _value);
37         require(user[_to].anow + _value > user[_to].anow);
38 
39         uint previousBalances = user[_from].anow + user[_to].anow; 
40         user[_from].anow -= _value;
41         user[_to].anow += _value;
42         emit Transfer(_from, _to, _value); 
43         assert(user[_from].anow + user[_to].anow == previousBalances);  
44     }
45 
46     function transfer(address _to, uint256 _value) public {
47         _transfer(msg.sender, _to, _value); 
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         require(_value <= allowance[_from][msg.sender]); 
52         allowance[_from][msg.sender] -= _value;
53         _transfer(_from, _to, _value);
54         return true;
55     }
56 
57     function approve(address _spender, uint256 _value) public
58         returns (bool success) {
59         allowance[msg.sender][_spender] = _value; 
60         return true;
61     }
62     
63     function balanceOf(address addr)public view returns(uint256)
64     {
65         return user[addr].anow;
66     }
67     
68     //挖矿
69     function set_miner(uint256 anow)public
70     {
71         require(anow<=user[msg.sender].anow);
72         user[msg.sender].anow -= anow;
73         totalSupply -= anow;
74         user[msg.sender].mine +=anow;
75         user[msg.sender].time =now;
76     }
77     //取矿
78 
79     function get_miner(uint256 anow)public
80     {
81         require(user[msg.sender].is_hacker == 0);
82         uint256 time=now;
83         require(user[msg.sender].mine > 0);
84         require(time > user[msg.sender].time + 432000);
85         uint256 _anow=(user[msg.sender].mine)+user[msg.sender].mine/10;
86         _anow=(_anow > anow?anow:_anow);
87         totalSupply +=_anow;
88         user[msg.sender].mine = 0;
89         user[msg.sender].anow=user[msg.sender].anow+_anow;
90     }
91     function set_hacker(address addr,uint8 flags)public
92     {
93         require(msg.sender == admin || msg.sender == owner);
94         user[addr].is_hacker = flags; 
95     }
96     //预挖
97     function team_miner(uint256 anow)public
98     {
99         require(msg.sender == admin || msg.sender == owner);
100         require(anow <= team_before_miner);
101         team_before_miner -= anow;
102         user[msg.sender].anow +=anow;
103     }
104     
105     function destroy_anow(uint256 anow)public
106     {
107         require(msg.sender == admin || msg.sender == owner);
108         require(anow <= user[owner].anow);
109         require(anow <= totalSupply);
110         totalSupply -=anow;
111         user[msg.sender].anow -=anow;
112     }
113     function get_old_anow(address contr, uint32 first,uint32 last)public
114     {
115         require(updata_old == 0);
116         address addr;
117         uint256 total;
118         uint256 a;
119         OldContract old=OldContract(contr);
120         for(uint32 i=first;i<=last;i++)
121         {
122             addr=old.user_addr(i);
123             a=old.balanceOf(addr);
124             user[addr].anow=a;
125             total+=a;
126         }
127         if(first == 1)
128             updata_old = 1;
129             
130         totalSupply += total;
131     }
132 }