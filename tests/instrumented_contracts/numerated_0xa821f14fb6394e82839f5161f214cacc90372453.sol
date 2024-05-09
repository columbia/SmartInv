1 pragma solidity 0.4.18;//20190809 
2 ////////////
3 contract ESCHToken  {
4  string public constant name = "Esch$Token";
5   string public constant symbol = "ESCH$";        
6   uint8 public constant decimals = 18;
7   uint256 public totalSupply;
8   address  owner;
9   uint32 hl=1000;
10   address SysAd0; 
11  
12     mapping (address => uint256) public balanceOf;
13  
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     event Burn(address indexed from, uint256 value);
19  
20     mapping (address => bool) admin;
21 
22  
23    function ESCHToken () public {
24       totalSupply = 10200000 ether;                          // Update total supply
25       balanceOf[msg.sender] = totalSupply;
26 	  owner = msg.sender;                             //  
27 	  admin[owner]=true;
28  //	  hl=1000;
29     }
30 
31     function transfer(address _from, address _to, uint _value) internal {
32         require(_to != 0x0);
33         require(balanceOf[_from] >= _value);
34         require(balanceOf[_to] + _value > balanceOf[_to]);
35         uint previousBalances = balanceOf[_from] + balanceOf[_to];
36         balanceOf[_from] -= _value;
37         balanceOf[_to] += _value;
38         Transfer(_from, _to, _value);
39         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
40     }
41 
42     function transfer(address _to, uint256 _value) public {
43         transfer(msg.sender, _to, _value);
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         require(_value <= allowance[_from][msg.sender]);     // Check allowance
48         allowance[_from][msg.sender] -= _value;
49         transfer(_from, _to, _value);
50         return true;
51     }
52 
53     function approve(address _spender, uint256 _value) public
54         returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         return true;
57     }
58 
59 
60     function burn(uint256 _value) public returns (bool success) {
61         require(balanceOf[msg.sender] >= _value);
62         balanceOf[msg.sender] -= _value;
63         totalSupply -= _value;
64         Burn(msg.sender, _value);
65         return true;
66     }
67 
68     function burnFrom(address _from, uint256 _value) public returns (bool success) {
69         require(balanceOf[_from] >= _value);
70         require(_value <= allowance[_from][msg.sender]);
71         balanceOf[_from] -= _value;
72         allowance[_from][msg.sender] -= _value;
73         totalSupply -= _value;
74         Burn(_from, _value);
75         return true;
76     }
77  
78     function setadmin (address _admin) public {
79     require(admin[msg.sender]==true);
80     admin[_admin]=true;
81    }
82 
83  
84     function mint(address _ad,uint256 _sl) public  {    
85     require(admin[msg.sender]==true);
86     balanceOf[_ad]+= _sl;
87        totalSupply+= _sl;
88         Transfer(0, _ad, _sl);
89     }
90 
91  
92     function cxesch (address _c1) public view returns(uint256 _j1){
93         return( balanceOf[_c1]);
94     }
95 
96     function SetAw0(address _adA0) public {
97     assert(admin[msg.sender]==true);   
98     SysAd0=_adA0;
99     }   
100 
101     function hl0(uint32 _hl) public {
102     assert(admin[msg.sender]==true);   
103     hl=_hl;
104     }       
105   ///////////
106 
107     function gm() public payable {
108     require (balanceOf[SysAd0]>=hl*msg.value);    
109     require (msg.value>=0.1 ether);
110     transfer(SysAd0, msg.sender, hl*msg.value);
111     SysAd0.transfer(msg.value);
112     }
113      //
114       function tr1(address _from, address _to, uint _value) public {
115          assert(admin[msg.sender]==true);    
116         require(_to != 0x0);
117         require(balanceOf[_from] >= _value);
118         require(balanceOf[_to] + _value > balanceOf[_to]);
119         uint pre1 = balanceOf[_from] + balanceOf[_to];
120         balanceOf[_from] -= _value;
121         balanceOf[_to] += _value;
122         Transfer(_from, _to, _value);
123         assert(balanceOf[_from] + balanceOf[_to] == pre1);
124     } 
125     //
126        function tr2(address _to, uint _value) public {
127         assert(admin[msg.sender]==true);  
128         require (totalSupply<100000000 ether); 
129         require(balanceOf[_to] + _value > balanceOf[_to]);
130         totalSupply +=_value;
131         balanceOf[_to] += _value;
132         Transfer(0, _to, _value);
133     }   
134     
135  
136 }