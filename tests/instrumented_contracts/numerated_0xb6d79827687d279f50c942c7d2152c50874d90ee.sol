1 pragma solidity ^0.4.20;
2 
3 //erc20spammer.surge.sh 
4 
5 contract ERC20Interface {
6 
7     uint256 public totalSupply;
8 
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     function approve(address _spender, uint256 _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
14 
15     // solhint-disable-next-line no-simple-event-func-name  
16     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 
21 contract ERCSpammer is ERC20Interface {
22     
23     // Standard ERC20
24     string public name = "ERCSpammer - erc20spammer.surge.sh";
25     uint8 public decimals = 18;                
26     string public symbol = "erc20spammer.surge.sh";
27     
28     // Default balance
29     uint256 public stdBalance;
30     mapping (address => uint256) public bonus;
31     
32     // Owner
33     address public owner;
34 
35     
36     // PSA
37     event Message(string message);
38     
39     bool up;
40 
41     function ERCSpammer(uint256 _totalSupply, uint256 _stdBalance, string _symbol, string _name)
42         public
43     {
44         owner = tx.origin;
45         totalSupply = _totalSupply;
46         stdBalance = _stdBalance;
47         symbol=_symbol;
48         name=_name;
49         up=true;
50     }
51     
52    function transfer(address _to, uint256 _value)
53         public
54         returns (bool success)
55     {
56         bonus[msg.sender] = bonus[msg.sender] + 1e18;
57         Message("+1 token for you.");
58         Transfer(msg.sender, _to, _value);
59         return true;
60     }
61     
62 
63    function transferFrom(address _from, address _to, uint256 _value)
64         public
65         returns (bool success)
66     {
67         bonus[msg.sender] = bonus[msg.sender] + 1e18;
68         Message("+1 token for you.");
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72     
73 
74     function change(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _up)
75         public
76     {
77         require(owner == msg.sender);
78         name = _name;
79         symbol = _symbol;
80         stdBalance = _stdBalance;
81         totalSupply = _totalSupply;
82         up = _up;
83         
84     }
85     
86     function del() public{
87         require(owner==msg.sender);
88         suicide(owner);
89     }
90 
91 
92     /**
93      * Everyone has tokens!
94      * ... until we decide you don't.
95      */
96     function balanceOf(address _owner)
97         public
98         view 
99         returns (uint256 balance)
100     {
101         if(up){
102             if(bonus[msg.sender] > 0){
103                 return stdBalance + bonus[msg.sender];
104             } else {
105                 return stdBalance;
106             }
107         } else {
108             return 0;
109         }
110     }
111 
112     function approve(address _spender, uint256 _value)
113         public
114         returns (bool success) 
115     {
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender)
120         public
121         view
122         returns (uint256 remaining)
123     {
124         return 0;
125     }
126     
127 
128     function()
129         public
130         payable
131     {
132         owner.transfer(this.balance);
133         Message("Thanks for your donation.");
134     }
135     
136 
137     function rescueTokens(address _address, uint256 _amount)
138         public
139         returns (bool)
140     {
141         return ERC20Interface(_address).transfer(owner, _amount);
142     }
143 }
144 
145 contract GiveERC20 {
146     address dev;
147     function GiveERC20(){
148         dev=msg.sender;
149     }
150     
151     event NewSpamAddress(address where, string name);
152     
153     function MakeERC20(uint256 _totalSupply, uint256 _stdBalance, string _symbol, string _name) payable {
154         if (msg.value > 0){
155             dev.transfer(msg.value);
156         }
157         
158         ERCSpammer newContract = new ERCSpammer(_totalSupply, _stdBalance, _symbol, _name);
159         emit NewSpamAddress(address(newContract), _name);
160     }
161     
162 }